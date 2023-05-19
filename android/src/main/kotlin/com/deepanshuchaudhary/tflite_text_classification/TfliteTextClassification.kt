package com.deepanshuchaudhary.tflite_text_classification

import android.app.Activity
import android.util.Log
import com.deepanshuchaudhary.tflite_text_classification.TfliteTextClassificationPlugin.Companion.LOG_TAG
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class TfliteTextClassification(
    private val activity: Activity
) {

    private var job: Job? = null

    private val utils = Utils()

    // For classifying text
    fun classify(
        resultCallback: MethodChannel.Result,
        text: String?,
        delegate: Int?,
        modelType: ModelType?,
        modelPath: String?,
    ) {
        Log.d(
            LOG_TAG,
            "classifyText - IN, text=$text, delegate=$delegate, modelType=$modelType, modelPath=$modelPath"
        )

        val uiScope = CoroutineScope(Dispatchers.IO)
        job?.cancel() // Cancel the previous job if it exists
        job = uiScope.launch {
            try {

                val classifierHelper = TextClassificationHelper(
                    currentDelegate = delegate!!,
                    currentModel = modelType!!,
                    MODEL_PATH = modelPath!!,
                    context = activity
                )

                val classifierResult: HashMap<String, Any> = classifierHelper.classify(text!!)

                utils.finishSuccessfully(classifierResult, resultCallback)


            } catch (e: Exception) {
                utils.finishWithError(
                    "classifyText_exception", e.stackTraceToString(), null, resultCallback
                )
            } catch (e: OutOfMemoryError) {
                utils.finishWithError(
                    "classifyText_OutOfMemoryError", e.stackTraceToString(), null, resultCallback
                )
            } finally {
                job = null // Reset the job after completion
            }
        }
        Log.d(LOG_TAG, "classifyText - OUT")
    }

}
