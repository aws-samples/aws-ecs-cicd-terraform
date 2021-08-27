package de.codecentric.cloudbootstrap

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import mu.KotlinLogging

@RestController
class MountainsController {

    var logger = KotlinLogging.logger {}

    @GetMapping("/mountains")
    fun getAll(): List<Mountain> {
        logger.info { "Received request against '/mountains' endpoint - returning mountains." }
        return allMountains()
    }

    private fun allMountains(): List<Mountain> {
        return listOf(
                Mountain("Lalidererspitze", "Karwendelgebirge", 2588),
                Mountain("Alpspitze", "Wettersteingebirge", 2628),
                Mountain("Westliche Karwendelspitze", "Karwendelgebirge", 2385),
                Mountain("Krottenkopf", "Estergebirge", 2086),
                Mountain("Brünnstein", "Mangfallgebirge", 1619)
        )
    }

}