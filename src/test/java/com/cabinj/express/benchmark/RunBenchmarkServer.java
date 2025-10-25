package com.cabinj.express.benchmark;

import java.io.IOException;

/**
 * Simple runner for the BenchmarkServer
 * Use this to start the benchmark server for manual testing
 */
public class RunBenchmarkServer {
    public void startBenchmarkServer() throws IOException {
        System.err.println("Starting BenchmarkServer...");
        BenchmarkServer.startBenchmarkServer();
    }
}
