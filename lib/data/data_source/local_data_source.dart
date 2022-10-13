import 'package:advanced_app/data/network/error_handler.dart';
import 'package:advanced_app/data/response/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 minute cache in millis

const CACHE_STORE_DETAILS_KEY = "CACHE_STORE_DETAILS_KEY";
const CACHE_STORE_DETAILS_INTERVAL = 60 * 2000; // 2 minute cache in millis

abstract class LocalDataSource{
  Future<HomeResponse> getHomeData();

  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse);

  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource{
  // run time cache
  Map<String, CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHomeData() async{
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];

    if(cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)){
      // return response from cache
      return cachedItem.data;
    }else{
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async{
    CachedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];

    if(cachedItem != null && cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)){
      // return response from cache
      return cachedItem.data;
    }else{
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async{
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse) async{
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(storeDetailsResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem{
  dynamic data;

  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem{
  bool isValid(int expirationTimeInMillis){
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;

    bool isValid = currentTimeInMillis - cacheTime <= expirationTimeInMillis;

    return isValid;
  }
}