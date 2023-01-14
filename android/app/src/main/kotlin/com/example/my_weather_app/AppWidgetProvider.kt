package com.example.my_weather_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.ImageView
import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.module.AppGlideModule
import com.bumptech.glide.Glide;
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider


class AppWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                val temp = widgetData.getString("_temp", "No data")

                var tempText = "$temp"

                val city = widgetData.getString("_city", "No data")

                var cityText = "$city"

                val updated = widgetData.getString("_updated", "No data")

                var updatedText = "Upd: $updated"

                if (temp == "" || city == "" || updated == ""){
                    tempText = ""
                    cityText = ""
                    updatedText = "No favorite location"
                }

                setTextViewText(R.id.tv_temp, tempText)
                setTextViewText(R.id.tv_city, cityText)
                setTextViewText(R.id.tv_updated, updatedText)
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
                        Uri.parse("myAppWidget://updateForecast"))
                setOnClickPendingIntent(R.id.bt_update, backgroundIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

