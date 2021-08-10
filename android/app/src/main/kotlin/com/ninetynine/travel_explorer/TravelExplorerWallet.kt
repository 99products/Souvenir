package com.ninetynine.travel_explorer

import android.content.Context
import android.provider.Settings
import androidx.multidex.MultiDexApplication
import com.ninetynine.travel_explorer.bridge_server.BridgeServer
import com.squareup.moshi.Moshi
import okhttp3.OkHttpClient
import org.komputing.khex.extensions.toNoPrefixHexString
import org.walletconnect.Session
import org.walletconnect.impls.*
import org.walletconnect.nullOnThrow
import java.io.File
import java.util.*

class TravelExplorerWallet: MultiDexApplication() {
    private val PREFERANCE_NAME = "WALLET_PREFERENCE";
    override fun onCreate() {
        super.onCreate()
        initMoshi()
        initClient()
        initBridge()
        initSessionStorage()
        initUUID()
    }

    private fun initClient() {
        client = OkHttpClient.Builder().build()
    }

    private fun initMoshi() {
        moshi = Moshi.Builder().build()
    }


    private fun initBridge() {
        bridge = BridgeServer(moshi)
        bridge.start()
    }

    private fun initSessionStorage() {
        storage = FileWCSessionStore(File(cacheDir, "session_store.json").apply { createNewFile() }, moshi)
    }

    private fun initUUID() {
        val context = this as Context
        val sharedPref = context.getSharedPreferences(PREFERANCE_NAME, Context.MODE_PRIVATE)
        deviceId = sharedPref?.getString("DEVICE_ID", "").toString();
        if(deviceId.isNullOrEmpty() || deviceId.isEmpty()) {
            deviceId = UUID.randomUUID().toString()
            with (sharedPref.edit()) {
                putString("DEVICE_ID", deviceId)
                apply()
            }
        }
    }

    companion object {
        private lateinit var client: OkHttpClient
        private lateinit var moshi: Moshi
        private lateinit var bridge: BridgeServer
        private lateinit var storage: WCSessionStore
        lateinit var config: Session.Config
        lateinit var session: Session
        lateinit var deviceId: String

        fun loadSession(): WCSessionStore.State? {
            val state = storage.load(deviceId)
            if (state != null) {
                print(state.approvedAccounts)
                resetSession()
            };
            return state
        }

        fun resetSession() {
            nullOnThrow { session }?.clearCallbacks()
            val key = ByteArray(32).also { Random().nextBytes(it) }.toNoPrefixHexString()
            config = Session.Config(deviceId, "http://localhost:${BridgeServer.PORT}", key)
            session = WCSession(config,
                MoshiPayloadAdapter(moshi),
                storage,
                OkHttpTransport.Builder(client, moshi),
                Session.PeerMeta(name = "Souvenir", url = "https://99products.in/", description = "NFT as Souvenir"),
                deviceId
            )

            session.offer()
        }
    }
}