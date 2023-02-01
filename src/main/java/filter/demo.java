package filter;

import utils.PingUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class demo {
    public static int boolToInt(Boolean b) {
        return b ? 1 : 0;
    }

    public static void main(String[] args) throws Exception {

        PingUtil pingUtil=new PingUtil();
        String ipAddress = "192.168.1.132";
        System.out.println(pingUtil.ping(ipAddress));
    }

}