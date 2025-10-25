package com.cabinj.express.exception;

public class BadRequestException extends CabinException {
    public BadRequestException(String message) {
        super(message);
    }
}