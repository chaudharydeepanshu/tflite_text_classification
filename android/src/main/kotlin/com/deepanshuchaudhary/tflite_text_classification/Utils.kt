package com.deepanshuchaudhary.tflite_text_classification

import io.flutter.plugin.common.MethodChannel

class Utils {

    fun finishSuccessfully(
        result: Any?, resultCallback: MethodChannel.Result?
    ) {
        resultCallback?.success(result)
    }

    fun finishWithError(
        errorCode: String,
        errorMessage: String?,
        errorDetails: String?,
        resultCallback: MethodChannel.Result?
    ) {
        resultCallback?.error(errorCode, errorMessage, errorDetails)
    }
}