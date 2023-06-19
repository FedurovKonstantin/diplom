package com.example.untitled

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.allViews
import androidx.core.view.get
import com.jjoe64.graphview.GraphView
import com.jjoe64.graphview.series.DataPoint
import com.jjoe64.graphview.series.LineGraphSeries
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.lang.reflect.Method
import kotlinx.coroutines .*
import kotlinx.serialization.json.*
import java.util.LinkedList

@kotlinx.serialization.Serializable
data class Dollar(val value: Double)

internal class NativeView(context: Context, messenger: BinaryMessenger, creationParams: Any?) : PlatformView,
    MethodChannel.MethodCallHandler {

    private val methodChannel: MethodChannel
    private var view: View
    private val layout:ConstraintLayout

    init {
        methodChannel = MethodChannel(messenger,"native_view_chart/data")
        methodChannel.setMethodCallHandler(this)

        layout = ConstraintLayout(context)
        view =  MyGraphView(layout.context, LinkedList());
    }

    override fun getView(): View? {
        val params = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )

         view.layoutParams = params

        if(!layout.allViews.contains(view)){
            layout.addView(view)
        }

        return layout;
    }

    override fun dispose() {}


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method == "data"){
            val data = call.arguments as String

            val parsedData = Json.decodeFromString<List<Dollar>>(data)

            val series =
                parsedData.map { it -> it.value }

            layout.removeView(view);
            view.invalidate()
            view =  MyGraphView(layout.context, series);
            layout.addView(view)

        }else{
            result.notImplemented()
        }
    }
}

class MyGraphView(context: Context,outData: List<Double> ) : View(context) {

    private var paint = Paint()
    private var data = outData;

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)

        paint.color = Color.parseColor("#9C27B0")
        paint.strokeWidth = 2f
        paint.isAntiAlias = true

        val height = height.toFloat()
        val width = width.toFloat()

        if(data.size == 0){
            return;
        }

        val maxValue = data.reduce{acc,value -> if (acc > value) acc else value}
        val minValue = data.reduce{acc,value -> if (acc < value) acc else value}

        val yUnit = height / (maxValue - minValue);

        var prevX = 0f
        var prevY = 0f

        for (i in 0 until data.size) {
            val newX = i * width / (data.size - 1)
            val newY = (data[i] - minValue) * yUnit


            if(i != 0)
                canvas?.drawLine(prevX,prevY,newX,newY.toFloat(),paint)

            prevX = newX
            prevY = newY.toFloat()
        }
    }
}



