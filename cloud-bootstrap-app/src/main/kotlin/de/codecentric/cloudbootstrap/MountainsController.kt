package de.codecentric.cloudbootstrap

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class MountainsController {

    @GetMapping("/mountains")
    fun getAll(): List<Mountain> {
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