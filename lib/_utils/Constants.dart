class Constants{
  static const String BASE_URL = 'http://192.168.1.8:8080/api';
  static const String TEST_URL = '/admin/values';

  static const String FARMER_REG_URL = '/farmer';
  static const String BUYER_REG_URL = '/buyer';
  static const String FARMER_LOGIN_URL = '/farmer/login';
  static const String ADMIN_LOGIN_URL = '/admin/login';
  static const String BUYER_LOGIN_URL = '/buyer/login';


  static const String ADD_LAND = '/land';
  static const String GET_LANDS = '/land';

  static const String GET_FARMERS = '/farmer';
  static const String APPROVE = '/farmer'; // /farmerId

  static const String GET_HARVEST = '/harvest';
  static const String ADD_HARVEST = '/farmer/harvest';

  static const String GET_BID = '/bids';
  static const String ADD_BID = '/bid';
}