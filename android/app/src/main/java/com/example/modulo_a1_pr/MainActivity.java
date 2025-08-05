package com.example.modulo_a1_pr;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import androidx.annotation.NonNull;
import java.util.List;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private String caminhoCanal = "com.example.modulo_a1_pr";
    private BroadcastReceiver broadInternet, brodFones;

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(broadInternet);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor(), caminhoCanal + "/main").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

                List<Object> args = call.arguments();

                switch (call.method) {



                }

            }
        });

        new EventChannel(flutterEngine.getDartExecutor(), caminhoCanal + "/internet").setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                events.success(verificaConexao());
                broadInternet = new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        events.success(verificaConexao());
                    }
                };
                registerReceiver(broadInternet, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });

        new EventChannel(flutterEngine.getDartExecutor(), caminhoCanal + "/fones").setStreamHandler(new EventChannel.StreamHandler() {
            AudioManager audioManager = (AudioManager) getSystemService(AUDIO_SERVICE);
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                brodFones = new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        events.success(audioManager.isWiredHeadsetOn());
                    }
                };
                registerReceiver(brodFones, new IntentFilter(AudioManager.ACTION_HEADSET_PLUG));
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });



    }

    private int verificaConexao() {

        int conexao = 0;

        ConnectivityManager connectivityManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();

        if (networkInfo != null) {

            switch (networkInfo.getState()) {

                case CONNECTED:
                    conexao = 1;

                    break;

                default:

                    conexao = 0;

                    break;

            }

        }

        return  conexao;

    }


}