package com.cabinj.express.interfaces;

import com.cabinj.express.http.Request;
import com.cabinj.express.http.Response;
import com.cabinj.express.middleware.MiddlewareChain;

import java.io.IOException;

/**
 * Represents a middleware for an HTTP request.
 * @author Sang Le
 * @version 1.0.0
 * @since 2024-12-24
 */
@FunctionalInterface
public interface Middleware {
    /**
     * Applies the middleware to an HTTP request.
     *
     * @param request  the request object
     * @param response the response object
     * @param next     the next middleware in the chain
     * @throws IOException if an I/O error occurs during request processing
     */
    void apply(Request request, Response response, MiddlewareChain next) throws IOException;
}
