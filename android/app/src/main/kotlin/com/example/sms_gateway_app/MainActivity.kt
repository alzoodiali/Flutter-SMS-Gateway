package com.example.sms_gateway_app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.sms_gateway_app/sms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    val phoneNumber = call.argument<String>("phone_number")
                    val message = call.argument<String>("message")
                    val simSlot = call.argument<Int>("sim_slot") ?: 1

                    if (phoneNumber != null && message != null) {
                        val (sent, errorMsg) = sendNativeSms(phoneNumber, message, simSlot)
                        if (sent) {
                            result.success(true)
                        } else {
                            result.error("SMS_SEND_FAILED", errorMsg ?: "Unknown error", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Phone number or message missing", null)
                    }
                }
                "requestPermission" -> {
                    val granted = checkAndRequestSmsPermission()
                    result.success(granted)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkAndRequestSmsPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS, Manifest.permission.READ_PHONE_STATE), 101)
            return false
        }
        return true
    }

    private fun sendNativeSms(phoneNumber: String, message: String, simSlot: Int): Pair<Boolean, String?> {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            return Pair(false, "إذن إرسال SMS غير مسموح (Permission Denied). يرجى التفعيل من الإعدادات.")
        }

        return try {
            val smsManager: SmsManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val subscriptionManager = this.getSystemService(SubscriptionManager::class.java)
                val activeList = subscriptionManager?.activeSubscriptionInfoList
                if (!activeList.isNullOrEmpty() && simSlot <= activeList.size) {
                    val subId = activeList[simSlot - 1].subscriptionId
                    this.getSystemService(SmsManager::class.java).createForSubscriptionId(subId)
                } else {
                    this.getSystemService(SmsManager::class.java)
                }
            } else {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }

            val parts = smsManager.divideMessage(message)
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(phoneNumber, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(phoneNumber, null, message, null, null)
            }
            Pair(true, null)
        } catch (e: Exception) {
            Pair(false, e.localizedMessage ?: e.toString())
        }
    }
}