/*
 * Centralized hotel image mapping.
 *
 * Room photos use stable URLs. Food photos prefer a confident recipe/media API
 * match, then use a curated, dish-type fallback so every menu card has a photo.
 */
(function (global) {
  'use strict';

  const image = (photoId, width = 800) =>
    `https://images.unsplash.com/photo-${photoId}?auto=format&fit=crop&w=${width}&q=80`;

  const MEAL_DB_API = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';
  const COMMONS_API = 'https://commons.wikimedia.org/w/api.php';
  const foodImageCache = new Map();

  const normalizeMealName = value => String(value ?? '')
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
    .toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();

  async function findApiFoodImage(food) {
    const name = String(food.service_name || food.name || '').trim();
    const key = normalizeMealName(name);
    if (!key) return null;
    if (foodImageCache.has(key)) return foodImageCache.get(key);

    const cacheKey = `hotel-food-image-v3:${key}`;
    try {
      const cached = localStorage.getItem(cacheKey);
      if (cached) {
        const result = JSON.parse(cached);
        foodImageCache.set(key, result);
        return result;
      }
    } catch (_) { /* Storage may be unavailable in private browsing. */ }

    const lookup = (async () => {
      try {
        const response = await fetch(`${MEAL_DB_API}${encodeURIComponent(name)}`);
        const payload = response.ok ? await response.json() : {};
        const meals = Array.isArray(payload.meals) ? payload.meals : [];
        const wanted = normalizeMealName(name);
        const wantedTokens = new Set(wanted.split(' ').filter(token => token.length > 2 || /^\d+$/.test(token)));
        const ranked = meals.map(meal => {
          const title = normalizeMealName(meal.strMeal);
          const titleTokens = new Set(title.split(' ').filter(token => token.length > 2 || /^\d+$/.test(token)));
          const overlap = [...wantedTokens].filter(token => titleTokens.has(token)).length;
          const score = wantedTokens.size ? overlap / wantedTokens.size : 0;
          return { meal, title, score, exact: title === wanted, extraTokens: titleTokens.size - overlap };
        }).sort((a, b) => Number(b.exact) - Number(a.exact) || b.score - a.score || a.extraTokens - b.extraTokens);
        const best = ranked[0];
        // TheMealDB is the preferred source. Reject broad/partial matches.
        const match = best && (best.exact || (wantedTokens.size >= 2 && best.score >= 0.8))
          ? best.meal.strMealThumb
          : null;
        if (match) {
          try { localStorage.setItem(cacheKey, JSON.stringify(match)); } catch (_) { /* Cache is optional. */ }
          return match;
        }
      } catch (_) {
        // Try the image index below when the recipe API is unavailable.
      }

      try {
        const params = new URLSearchParams({
          action: 'query', generator: 'search', gsrnamespace: '6', gsrlimit: '20',
          gsrsearch: `filetype:bitmap ${name} food`, prop: 'imageinfo',
          iiprop: 'url', iiurlwidth: '1200', format: 'json', origin: '*'
        });
        const response = await fetch(`${COMMONS_API}?${params}`);
        if (!response.ok) return null;
        const payload = await response.json();
        const pages = Object.values(payload.query?.pages || {});
        const wanted = normalizeMealName(name);
        const wantedTokens = new Set(wanted.split(' ').filter(token => token.length > 2 || /^\d+$/.test(token)));
        const ranked = pages.map(page => {
          const title = normalizeMealName(page.title.replace(/^file\s+/, '').replace(/\.[a-z0-9]{2,5}$/i, ''));
          const titleTokens = new Set(title.split(' ').filter(token => token.length > 2 || /^\d+$/.test(token)));
          const overlap = [...wantedTokens].filter(token => titleTokens.has(token)).length;
          return { page, title, score: wantedTokens.size ? overlap / wantedTokens.size : 0, extraTokens: titleTokens.size - overlap };
        }).sort((a, b) => b.score - a.score || a.extraTokens - b.extraTokens);
        // A Commons title must identify the requested dish; otherwise show the
        // neutral placeholder rather than a plausible but incorrect food photo.
        const best = ranked[0];
        const imageUrl = best && wantedTokens.size > 0 && best.score >= 0.8
          ? (best.page.imageinfo?.[0]?.thumburl || best.page.imageinfo?.[0]?.url)
          : null;
        try { localStorage.setItem(cacheKey, JSON.stringify(imageUrl)); } catch (_) { /* Cache is optional. */ }
        return imageUrl;
      } catch (_) {
        return null;
      }
    })();
    foodImageCache.set(key, lookup);
    const result = await lookup;
    foodImageCache.set(key, result);
    return result;
  }

  const ROOM_IMAGES = {
    'luxury suite': image('1618773928121-c32242e63f39'),
    'standard ac room': image('1566665797739-1674de7a421a'),
    'ac room with balcony': image('1578683010236-d716f9a3f461'),
    'family ac room': image('1591088398332-8a7791972843'),
    'economy non-ac room': image('1590490360182-c33d57733427')
  };

  const FOOD_IMAGES = {
    southBreakfast: image('1589301760014-d929f3979dbc', 1200),
    dosa: image('1791209135209-5fe1e8295b47', 1200),
    northIndian: image('1546833999-b9f581a1996d', 1200),
    northCurry: image('1781332145637-5e14298f3f26', 1200),
    chicken: image('1779469716753-ddb6937c63a0', 1200),
    chinese: 'https://thesassyfoodie.com/wp-content/uploads/2023/06/hakka-style-noodles-5-720x1080.jpg',
    friedRice: image('1772729440931-e8efd3adc748', 1200),
    thai: image('1559847844-5315695dadae', 1200),
    fish: image('1708146464361-5c5ce4f9abb6', 1200),
    continental: image('1473093295043-cdd812d0e601', 1200),
    pasta: image('1567838102430-3399b503d563', 1200),
    pastaBowl: image('1669109230787-71bdd4699af4', 1200),
    pizza: image('1780642207472-5d2e942e4425', 1200),
    chickenPizza: image('1552580715-4d9bc27f1e2f', 1200),
    carbonara: image('1546549032-9571cd6b27df', 1200),
    salad: image('1540189549336-e6e99c3679fe', 1200),
    sandwich: image('1542820242-dd9053219a22', 1200)
  };

  const FOOD_CATEGORY_IMAGES = {
    'south indian': [FOOD_IMAGES.southBreakfast, FOOD_IMAGES.dosa],
    'north indian': [FOOD_IMAGES.northIndian, FOOD_IMAGES.northCurry, FOOD_IMAGES.chicken],
    chinese: [FOOD_IMAGES.chinese, FOOD_IMAGES.friedRice],
    thai: [FOOD_IMAGES.thai, FOOD_IMAGES.fish, FOOD_IMAGES.friedRice],
    continental: [FOOD_IMAGES.continental, FOOD_IMAGES.pasta, FOOD_IMAGES.pastaBowl, FOOD_IMAGES.pizza, FOOD_IMAGES.carbonara, FOOD_IMAGES.salad, FOOD_IMAGES.sandwich]
  };

  // Exact, high-resolution dish photos shared by the homepage and guest portal.
  const CURATED_FOOD_IMAGES = {
    'appam with vegetable stew': 'https://commons.wikimedia.org/wiki/Special:FilePath/Appam_%289188698747%29.jpg?width=1200',
    'shahi paneer': 'https://commons.wikimedia.org/wiki/Special:FilePath/Shahi_Paneer_Masala.JPG?width=1200',
    'paneer butter masala': 'https://commons.wikimedia.org/wiki/Special:FilePath/Paneer_Butter_Masala.jpg?width=1200',
    'fish tikka': 'https://commons.wikimedia.org/wiki/Special:FilePath/Fish_Tikka.JPG?width=1200'
  };

  // Curated, dish-specific photos for Chinese menu items. These override broad
  // search results so Manchurian, noodles, rice, and soup never share a generic
  // low-resolution cuisine photo.
  const CHINESE_DISH_IMAGES = {
    'vegetable fried rice': 'https://commons.wikimedia.org/wiki/Special:FilePath/Vegetable_fried_rice.jpg?width=1200',
    'chicken fried rice': 'https://www.eatlanka.com/wp-content/uploads/2024/04/chicken_fried_rice00032a-1200x1200-1.jpg',
    'vegetable hakka noodles': 'https://commons.wikimedia.org/wiki/Special:FilePath/Hakka_Noodles_Veg.jpg?width=1200',
    'chicken hakka noodles': 'https://cdn3.didevelop.com/public/customer_photos/533_98946f1b2548d96868f1805681fc8e32.jpeg',
    'vegetable manchurian': 'https://www.indianhealthyrecipe.com/wp-content/uploads/2024/01/sEme9gIbJH6e5-UnyX4ZHxFrhdn9Ew01XyF9OICPjGw.webp',
    'chicken manchurian': 'https://commons.wikimedia.org/wiki/Special:FilePath/Chicken_Manchurian.JPG?width=1200',
    'chilli paneer': 'https://images.squarespace-cdn.com/content/v1/5f5104b0f508426faa0f0ad5/1a29ad20-76c0-43b7-b3f9-2abbce1806f0/Indulge%2Bin%2BExquisite%2BChili%2BDelights%2BA%2BFusion%2Bof%2BSpice%2C%2BFlavors%2C%2Band%2BTexture%2B%282%29.jpg',
    'chilli chicken': 'https://b.zmtcdn.com/data/pictures/chains/8/41218/a5bb42ce51c7316aecbc83ef71669131.jpeg?crop=750%3A500%3B%2A%2C%2A&fit=around%7C750%3A500',
    'vegetable spring rolls': 'https://imagedelivery.net/9lr8zq_Jvl7h6OFWqEi9IA/39fe1cb5-f7fd-44d9-05c1-86e9ca73cd00/public',
    'hot sour soup': 'https://popmenucloud.com/cdn-cgi/image/width%3D1200%2Cheight%3D1200%2Cfit%3Dscale-down%2Cformat%3Dauto%2Cquality%3D60/ucwphoaj/bb779059-afed-4c47-a76c-0ecb0c2cf454.jpg'
  };

  function stableIndex(value, length) {
    let hash = 0;
    for (const char of String(value ?? '')) hash = (hash * 31 + char.charCodeAt(0)) >>> 0;
    return length ? hash % length : 0;
  }

  const normalize = value => String(value ?? '').trim().toLowerCase().replace(/\s+/g, ' ');

  function resolveRoomImage(room = {}) {
    const typeKey = normalize(room.room_type || room.category);
    return ROOM_IMAGES[typeKey] || room.image_url || image('1618773928121-c32242e63f39');
  }

  function resolveFoodImage(food = {}) {
    const name = normalizeMealName(food.service_name || food.name);
    const category = normalizeMealName(food.service_category || food.category);

    if (CURATED_FOOD_IMAGES[name]) return CURATED_FOOD_IMAGES[name];
    if (category === 'chinese' && CHINESE_DISH_IMAGES[name]) return CHINESE_DISH_IMAGES[name];

    // Prefer a photo of the same kind of dish, even when an API has no exact hit.
    if (/pasta|carbonara|arrabbiata/.test(name)) {
      return /alfredo|carbonara/.test(name) ? FOOD_IMAGES.carbonara : FOOD_IMAGES.pasta;
    }
    if (/pizza/.test(name)) return /chicken/.test(name) ? FOOD_IMAGES.chickenPizza : FOOD_IMAGES.pizza;
    if (/salad/.test(name)) return FOOD_IMAGES.salad;
    if (/sandwich/.test(name)) return FOOD_IMAGES.sandwich;
    if (/fish|seafood/.test(name)) return FOOD_IMAGES.fish;
    if (/dosa|uttapam/.test(name)) return FOOD_IMAGES.dosa;
    if (/idli|vada|pongal|upma|appam|puttu|poori/.test(name)) return FOOD_IMAGES.southBreakfast;
    if (/naan|roti|paratha|parotta/.test(name)) return FOOD_IMAGES.northIndian;
    if (/fried rice/.test(name)) return FOOD_IMAGES.friedRice;
    if (/noodle|spring roll|manchurian|chilli paneer|chilli chicken|hot sour soup/.test(name)) return FOOD_IMAGES.chinese;
    if (/pad thai|thai|tom yum|tom kha|mango sticky/.test(name)) return FOOD_IMAGES.thai;
    if (/paneer|dal makhani|chole|rajma|kofta|curry|rogan josh/.test(name)) {
      return category === 'south indian' ? FOOD_IMAGES.chicken : FOOD_IMAGES.northCurry;
    }
    if (/chicken|steak|tandoori|tikka|grilled/.test(name)) return FOOD_IMAGES.chicken;
    if (/soup/.test(name)) return category === 'thai' ? FOOD_IMAGES.thai : FOOD_IMAGES.chinese;

    const categoryImages = FOOD_CATEGORY_IMAGES[category] || FOOD_CATEGORY_IMAGES.continental;
    return categoryImages[stableIndex(name, categoryImages.length)];
  }

  function resolveRoomFallback(primary) {
    const fallback = ROOM_IMAGES['luxury suite'];
    return primary === fallback ? ROOM_IMAGES['family ac room'] : fallback;
  }

  function resolveFoodFallback(food, primary) {
    const fallback = resolveFoodImage(food);
    if (fallback !== primary) return fallback;
    const category = normalizeMealName(food.service_category || food.category);
    return category === 'chinese' ? FOOD_IMAGES.chinese : FOOD_IMAGES.continental;
  }

  function bindImage(element, src, fallback, altText) {
    if (!element) return;
    if (altText) element.alt = altText;
    element.loading = element.loading || 'lazy';
    element.decoding = element.decoding || 'async';
    if (!element.dataset.imageFallbackBound) {
      element.dataset.imageFallbackBound = 'true';
      element.addEventListener('error', () => {
        if (element.dataset.imageFallbackApplied === 'true') {
          element.removeAttribute('src');
          return;
        }
        element.dataset.imageFallbackApplied = 'true';
        element.src = fallback;
      });
    }
    element.dataset.imageFallbackApplied = 'false';
    element.src = src || fallback;
  }

  function hydrate(root = document) {
    root.querySelectorAll('[data-image-map-room]').forEach(element => {
      const type = element.dataset.imageMapRoom;
      const primary = resolveRoomImage({ room_type: type });
      bindImage(element, primary, resolveRoomFallback(primary), element.alt || type);
    });
    root.querySelectorAll('[data-image-map-food]').forEach(element => {
      const name = element.dataset.imageMapFood;
      const category = element.dataset.imageMapCategory || '';
      const food = { service_name: name, service_category: category };
      const primary = resolveFoodImage(food);
      const fallback = resolveFoodFallback(food, primary);
      bindImage(element, primary, fallback, element.alt || name);
      const normalizedName = normalizeMealName(name);
      if (CURATED_FOOD_IMAGES[normalizedName] || (normalizeMealName(category) === 'chinese' && CHINESE_DISH_IMAGES[normalizedName])) return;
      findApiFoodImage(food).then(apiImage => {
        if (apiImage && element.isConnected && element.dataset.imageMapFood === name) {
          bindImage(element, apiImage, fallback, element.alt || name);
        }
      });
    });
  }

  global.HotelImageMap = {
    ROOM_IMAGES,
    resolveRoomImage,
    resolveFoodImage,
    bindImage,
    hydrate,
    getStats() { return { roomTypes: Object.keys(ROOM_IMAGES).length, foodImageSources: ['TheMealDB', 'Wikimedia Commons'] }; }
  };
}(window));
