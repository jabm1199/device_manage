package utils;

import java.net.InetAddress;



public class PingUtil {
    public static int boolToInt(Boolean b) {
        return b ? 1 : 0;
    }
    public static int ping(String ipAddress) throws Exception {
        int  timeOut =  2000 ;  //超时应该在3钞以上
        boolean status = InetAddress.getByName(ipAddress).isReachable(timeOut);     // 当返回值是true-1时，说明host是可用的，false-0则不可。
        return boolToInt(status);
    }


}