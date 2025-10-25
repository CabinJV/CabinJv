package com.cabinj.express.middleware;

import com.cabinj.express.http.Request;
import com.cabinj.express.http.Response;
import com.cabinj.express.interfaces.Middleware;
import com.cabinj.express.logger.CabinLogger;


import java.io.IOException;

public class GzipMiddleware implements Middleware {
    @Override
    public void apply(Request req, Response res, MiddlewareChain chain) throws IOException {
        String acceptEncoding = req.getHeader("Accept-Encoding");
        if (acceptEncoding != null && acceptEncoding.contains("gzip")) {
            try {
                res.enableCompression();
            } catch (Exception e) {
                CabinLogger.error("Error enabling GZIP compression: " + e.getMessage(), e);
                // Continue without compression as fallback
            }
        }
        // Proceed down the chain regardless
        chain.next(req, res);
    }
}