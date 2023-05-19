/*
 * Copyright 2022 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.deepanshuchaudhary.tflite_text_classification

import android.content.Context
import android.os.SystemClock
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.tensorflow.lite.support.label.Category
import org.tensorflow.lite.task.core.BaseOptions
import org.tensorflow.lite.task.text.nlclassifier.BertNLClassifier
import org.tensorflow.lite.task.text.nlclassifier.NLClassifier
import java.io.File
import java.io.FileInputStream
import java.nio.channels.FileChannel

enum class ModelType {
    WordVec, MobileBert
}

class TextClassificationHelper(
    var currentDelegate: Int = 0,
    var currentModel: ModelType = ModelType.WordVec,
    var MODEL_PATH: String,
    val context: Context,
) {
    // There are two different classifiers here to support both the Average Word Vector
    // model (NLClassifier) and the MobileBERT model (BertNLClassifier). Model selection
    // can be changed from the UI bottom sheet.
    private lateinit var bertClassifier: BertNLClassifier
    private lateinit var nlClassifier: NLClassifier


    init {
        initClassifier()
    }

    private fun initClassifier() {

        val file = File(MODEL_PATH)

        if (file.exists()) {
            Log.d(TfliteTextClassificationPlugin.LOG_TAG, "Provided path model exists")
        } else {
            Log.d(TfliteTextClassificationPlugin.LOG_TAG, "Provided path model does not exist")
        }

        // Look this StackOverflow post for why we need to do this
        // https://stackoverflow.com/a/59450159
        val fis = FileInputStream(file)
        val modelByteBuffer = fis.channel.map(FileChannel.MapMode.READ_ONLY, 0, file.length())
        // Close the FileInputStream after the ByteBuffer is created.
        fis.close()
        // Look into why we cant use path in BertNLClassifier.createFromFileAndOptions instead of
        // using ByteBuffer in BertNLClassifier.createFromBufferAndOptions


        val baseOptionsBuilder = BaseOptions.builder()

        // Use the specified hardware for running the model. Default to CPU.
        // Possible to also use a GPU delegate, but this requires that the classifier be created
        // on the same thread that is using the classifier, which is outside of the scope of this
        // sample's design.
        when (currentDelegate) {
            DELEGATE_CPU -> {
                // Default
            }

            DELEGATE_NNAPI -> {
                baseOptionsBuilder.useNnapi()
            }
        }

        val baseOptions = baseOptionsBuilder.build()


        // Directions for generating both models can be found at
        // https://www.tensorflow.org/lite/models/modify/model_maker/text_classification
        if (currentModel == ModelType.MobileBert) {
            val options =
                BertNLClassifier.BertNLClassifierOptions.builder().setBaseOptions(baseOptions)
                    .build()

            bertClassifier = BertNLClassifier.createFromBufferAndOptions(
                modelByteBuffer, options
            )


        } else if (currentModel == ModelType.WordVec) {
            val options =
                NLClassifier.NLClassifierOptions.builder().setBaseOptions(baseOptions).build()

            nlClassifier = NLClassifier.createFromBufferAndOptions(
                modelByteBuffer, options
            )


        }

        // Clear the ByteBuffer to avoid memory leaks.
        modelByteBuffer.clear()


    }

    suspend fun classify(text: String): HashMap<String, Any> {

        val resultMap: HashMap<String, Any> = HashMap()

        withContext(Dispatchers.IO) {

            // inferenceTime is the amount of time, in milliseconds, that it takes to
            // classify the input text.
            var inferenceTime = SystemClock.uptimeMillis()

            // Use the appropriate classifier based on the selected model
            val results: List<Category> = if (currentModel == ModelType.MobileBert) {
                // Closing the classifier after use to avoid resource leaks using the "use" block.
                bertClassifier.use { bertClassifier -> bertClassifier.classify(text) }
            } else {
                // Closing the classifier after use to avoid resource leaks using the "use" block.
                nlClassifier.use { bertClassifier -> bertClassifier.classify(text) }
            }

            inferenceTime = SystemClock.uptimeMillis() - inferenceTime

            // List of category objects called "results" and the inference time in milliseconds
            // called "inferenceTime".
            val categories: ArrayList<HashMap<String, Any>> = ArrayList()
            for (category in results) {
                val tempMap: HashMap<String, Any> = HashMap()
                tempMap["label"] = category.label
                tempMap["displayName"] = category.displayName
                tempMap["score"] = category.score
                tempMap["index"] = category.index
                categories.add(tempMap)
            }

            // Add the inference time to the final map
            resultMap["categories"] = categories
            resultMap["inferenceTime"] = inferenceTime

        }

        return resultMap
    }

    companion object {
        const val DELEGATE_CPU = 0
        const val DELEGATE_NNAPI = 1
    }
}