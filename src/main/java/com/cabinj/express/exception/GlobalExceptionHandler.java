package com.cabinj.express.exception;

import com.cabinj.express.http.Response;
import com.cabinj.express.logger.CabinLogger;

public class GlobalExceptionHandler {
    public static void handleException(Throwable e, Response response) {
        if (e instanceof CabinException) {
            response.setStatusCode(400);
            response.writeBody(e.getMessage());
        } else {
            response.setStatusCode(500);
            response.writeBody("Internal Server Error");
        }
        response.send();
        CabinLogger.error("Exception handled: " + e.getMessage(), e);
    }
}