#ifndef LED_H
#define LED_H

class LED {
public:
    // Constructor
    LED(int pinNumber);

    // Turn the LED on
    void on();

    // Turn the LED off
    void off();

    // Check if the LED is on
    bool isOn() const;

private:
    int pin;    // Pin number the LED is connected to
    bool state; // Current state of the LED (true = ON, false = OFF)
};

#endif // LED_H