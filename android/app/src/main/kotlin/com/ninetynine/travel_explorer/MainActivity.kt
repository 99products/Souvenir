package com.ninetynine.travel_explorer

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.walletconnect.Session
import org.walletconnect.nullOnThrow
import java.lang.Exception

class MainActivity: FlutterActivity(), Session.Callback {

    private val CHANNEL = "com.ninetynine.travel_explorer/wallet"
    private var walletConnected = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "connectWallet" -> connect()
                "walletConnectionState" -> {
                    result.success(isWalletConnected())
                }
                "walletAddress" -> {
                    val address = getConnectedWalletAddress()
                    result.success(address)
                }
                "mintToken" -> {
                    val txHash = mintToken(
                        call.argument<Long>("id") ?: System.currentTimeMillis(),
                        call.argument<String>("from") ?: throw Exception("mintToken:No from Address"),
                        call.argument<String>("to") ?: throw Exception("mintToken:No to Address"),
                        call.argument<String>("data") ?: throw Exception("mintToken:No data found"),
                    )
                    result.success(txHash)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        initialSetup()

    }

    override fun onDestroy() {
        TravelExplorerWallet.session.removeCallback(this)
        super.onDestroy()
    }

    override fun onMethodCall(call: Session.MethodCall) {
        print(call.hashCode())
    }

    override fun onStatus(status: Session.Status) {
        when(status) {
            Session.Status.Approved -> sessionApproved()
            Session.Status.Connected -> {
                requestConnectionToWallet()
            }
            Session.Status.Disconnected,
            is Session.Status.Error -> {
                // Do Stuff
            }
        }
    }

    private fun initialSetup() {
        val sessionState = TravelExplorerWallet.loadSession()
        if (sessionState != null) {
            walletConnected = true
        }
    }

    private fun connect() {
        print("Method called")
        TravelExplorerWallet.resetSession()
        TravelExplorerWallet.session.addCallback(this)
    }

    private fun isWalletConnected(): Boolean {
        return walletConnected
    }

    private fun getConnectedWalletAddress(): String? {
        val session = nullOnThrow { TravelExplorerWallet.session } ?: return ""
        return session.approvedAccounts()?.get(0)
    }

    private fun sessionApproved() {
        walletConnected = true
    }

    private fun requestConnectionToWallet() {
        val i = Intent(Intent.ACTION_VIEW)
        i.data = Uri.parse(TravelExplorerWallet.config.toWCUri())
        startActivity(i)
    }

    private fun mintToken(id: Long, from: String, to: String, data: String): Long {
        val from = TravelExplorerWallet.session.approvedAccounts()?.first()
            ?: throw Exception("Wallet not connected")
        val txRequest = System.currentTimeMillis()
        TravelExplorerWallet.session.performMethodCall(
            Session.MethodCall.SendTransaction(
                id,
                from,
                to,
                null,
                null,
                null,
                "0x0",
                data
            ),
            ::onMintSuccess
        )
        return txRequest
    }

    private fun onMintSuccess(resp: Session.MethodCall.Response) {

    }

}
