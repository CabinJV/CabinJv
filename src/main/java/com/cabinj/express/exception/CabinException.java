package com.cabinj.express.exception;

public class CabinException extends RuntimeException {
    public CabinException(String message) {
        super(message);
    }

    public CabinException(String message, Throwable cause) {
        super(message, cause);
    }
}