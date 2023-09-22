//
//  GlobalConst.swift
//  AJ
//
//  Created by Денис on 22.09.2023.
//

import Foundation

struct GC {

    static let natureSymbols = [
        "globe.americas",
        "globe.americas.fill",
        "globe.europe.africa",
        "globe.europe.africa.fill",
        "globe.asia.australia",
        "globe.asia.australia.fill",
        "globe.central.south.asia",
        "globe.central.south.asia.fill",
        "sun.min",
        "sun.min.fill",
        "sun.max",
        "sun.max.fill",
        "sun.max.circle",
        "sun.max.circle.fill",
        "sun.max.trianglebadge.exclamationmark",
        "sun.max.trianglebadge.exclamationmark.fill",
        "sunrise",
        "sunrise.fill",
        "sunrise.circle",
        "sunrise.circle.fill",
        "sunset",
        "sunset.fill",
        "sunset.circle",
        "sunset.circle.fill",
        "sun.horizon",
        "sun.horizon.fill",
        "sun.horizon.circle",
        "sun.horizon.circle.fill",
        "sun.dust",
        "sun.dust.fill",
        "sun.dust.circle",
        "sun.dust.circle.fill",
        "sun.haze",
        "sun.haze.fill",
        "sun.haze.circle",
        "sun.haze.circle.fill",
        "sun.rain",
        "sun.rain.fill",
        "sun.rain.circle",
        "sun.rain.circle.fill",
        "sun.snow",
        "sun.snow.fill",
        "sun.snow.circle",
        "sun.snow.circle.fill",
        "moonphase.new.moon",
        "moonphase.waxing.crescent",
        "moonphase.first.quarter",
        "moonphase.waxing.gibbous",
        "moonphase.full.moon",
        "moonphase.waning.gibbous",
        "moonphase.last.quarter",
        "moonphase.waning.crescent",
        "moonphase.new.moon.inverse",
        "moonphase.waxing.crescent.inverse",
        "moonphase.first.quarter.inverse",
        "moonphase.waxing.gibbous.inverse",
        "moonphase.full.moon.inverse",
        "moonphase.waning.gibbous.inverse",
        "moonphase.last.quarter.inverse",
        "moonphase.waning.crescent.inverse",
        "moon",
        "moon.fill",
        "moon.circle",
        "moon.circle.fill",
        "moon.dust",
        "moon.dust.fill",
        "moon.dust.circle",
        "moon.dust.circle.fill",
        "moon.haze",
        "moon.haze.fill",
        "moon.haze.circle",
        "moon.haze.circle.fill",
        "sparkles",
        "moon.stars",
        "moon.stars.fill",
        "moon.stars.circle",
        "moon.stars.circle.fill",
        "cloud",
        "cloud.fill",
        "cloud.circle",
        "cloud.circle.fill",
        "cloud.drizzle",
        "cloud.drizzle.fill",
        "cloud.drizzle.circle",
        "cloud.drizzle.circle.fill",
        "cloud.rain",
        "cloud.rain.fill",
        "cloud.rain.circle",
        "cloud.rain.circle.fill",
        "cloud.heavyrain",
        "cloud.heavyrain.fill",
        "cloud.heavyrain.circle",
        "cloud.heavyrain.circle.fill",
        "cloud.fog",
        "cloud.fog.fill",
        "cloud.fog.circle",
        "cloud.fog.circle.fill",
        "cloud.hail",
        "cloud.hail.fill",
        "cloud.hail.circle",
        "cloud.hail.circle.fill",
        "cloud.snow",
        "cloud.snow.fill",
        "cloud.snow.circle",
        "cloud.snow.circle.fill",
        "cloud.sleet",
        "cloud.sleet.fill",
        "cloud.sleet.circle",
        "cloud.sleet.circle.fill",
        "cloud.bolt",
        "cloud.bolt.fill",
        "cloud.bolt.circle",
        "cloud.bolt.circle.fill",
        "cloud.bolt.rain",
        "cloud.bolt.rain.fill",
        "cloud.bolt.rain.circle",
        "cloud.bolt.rain.circle.fill",
        "cloud.sun",
        "cloud.sun.fill",
        "cloud.sun.circle",
        "cloud.sun.circle.fill",
        "cloud.sun.rain",
        "cloud.sun.rain.fill",
        "cloud.sun.rain.circle",
        "cloud.sun.rain.circle.fill",
        "cloud.sun.bolt",
        "cloud.sun.bolt.fill",
        "cloud.sun.bolt.circle",
        "cloud.sun.bolt.circle.fill",
        "cloud.moon",
        "cloud.moon.fill",
        "cloud.moon.circle",
        "cloud.moon.circle.fill",
        "cloud.moon.rain",
        "cloud.moon.rain.fill",
        "cloud.moon.rain.circle",
        "cloud.moon.rain.circle.fill",
        "cloud.moon.bolt",
        "cloud.moon.bolt.fill",
        "cloud.moon.bolt.circle",
        "cloud.moon.bolt.circle.fill",
        "smoke",
        "smoke.fill",
        "smoke.circle",
        "smoke.circle.fill",
        "wind",
        "wind.circle",
        "wind.circle.fill",
        "wind.snow",
        "wind.snow.circle",
        "wind.snow.circle.fill",
        "snowflake",
        "snowflake.circle",
        "snowflake.circle.fill",
        "snowflake.slash",
        "tornado",
        "tornado.circle",
        "tornado.circle.fill",
        "tropicalstorm",
        "tropicalstorm.circle",
        "tropicalstorm.circle.fill",
        "hurricane",
        "hurricane.circle",
        "hurricane.circle.fill",
        "thermometer.sun",
        "thermometer.sun.fill",
        "thermometer.sun.circle",
        "thermometer.sun.circle.fill",
        "thermometer.snowflake",
        "thermometer.snowflake.circle",
        "thermometer.snowflake.circle.fill",
        "thermometer.variable.and.figure",
        "thermometer.variable.and.figure.circle",
        "thermometer.variable.and.figure.circle.fill",
        "humidity",
        "humidity.fill",
        "rainbow",
        "cloud.rainbow.half",
        "cloud.rainbow.half.fill",
        "water.waves",
        "water.waves.slash",
        "water.waves.and.arrow.up",
        "water.waves.and.arrow.down",
        "water.waves.and.arrow.down.trianglebadge.exclamationmark",
        "drop",
        "drop.fill",
        "drop.circle",
        "drop.circle.fill",
        "drop.degreesign",
        "drop.degreesign.fill",
        "drop.degreesign.slash",
        "drop.degreesign.slash.fill",
        "drop.triangle",
        "drop.triangle.fill",
        "flame",
        "flame.fill",
        "flame.circle",
        "flame.circle.fill",
        "bolt",
        "bolt.fill",
        "bolt.circle",
        "bolt.circle.fill",
        "bolt.square",
        "bolt",
        "bolt.square.fill",
        "bolt.shield",
        "bolt.shield.fill",
        "bolt.slash",
        "bolt.slash.fill",
        "bolt.slash.circle",
        "bolt.slash.circle.fill",
        "bolt.badge.clock",
        "bolt.badge.clock.fill",
        "bolt.badge.automatic",
        "bolt.badge.automatic.fill",
        "bolt.badge.checkmark",
        "bolt.badge.checkmark.fill",
        "bolt.badge.xmark",
        "bolt.badge.xmark.fill",
        "bolt.trianglebadge.exclamationmark",
        "bolt.trianglebadge.exclamationmark.fill",
        "mountain.2",
        "mountain.2.fill",
        "mountain.2.circle",
        "mountain.2.circle.fill",
        "allergens",
        "allergens.fill",
        "microbe",
        "microbe.fill",
        "microbe.circle",
        "microbe.circle.fill",
        "hare",
        "hare.fill",
        "hare.circle",
        "hare.circle.fill",
        "tortoise",
        "tortoise.fill",
        "tortoise.circle",
        "tortoise.circle.fill",
        "dog",
        "dog.fill",
        "dog.circle",
        "dog.circle.fill",
        "cat",
        "cat.fill",
        "cat.circle",
        "cat.circle.fill",
        "lizard",
        "lizard.fill",
        "lizard.circle",
        "lizard.circle.fill",
        "bird",
        "bird.fill",
        "bird.circle",
        "bird.circle.fill",
        "ant",
        "ant.fill",
        "ant.circle",
        "ant.circle.fill",
        "ladybug",
        "ladybug.fill",
        "ladybug.circle",
        "ladybug.circle.fill",
        "fish",
        "fish.fill",
        "fish.circle",
        "fish.circle.fill",
        "pawprint",
        "pawprint.fill",
        "pawprint.circle",
        "pawprint.circle.fill",
        "leaf",
        "leaf.fill",
        "leaf.circle",
        "leaf.circle.fill",
        "leaf.arrow.triangle.circlepath",
        "laurel.leading",
        "laurel.trailing",
        "camera.macro",
        "camera.macro.circle",
        "camera.macro.circle.fill",
        "tree",
        "tree.fill",
        "tree.circle",
        "tree.circle.fill",
        "carrot",
        "carrot.fill",
        "atom",
        "fossil.shell",
        "fossil.shell.fill"
    ]
}
