#include "led.h"
//#include <iostream>

// Constructor
LED::LED(int pinNumber) : pin(pinNumber), state(false) 
{  
    //std::cout << "LED created on pin " << pin << std::endl;
    pin = pinNumber;
}

//class LED
//{
//public: 
//    LED(int pinNumber) : pin(pinNumber), state(false) 
//    {
//        pin = pinNumber;
//    }
//    //std::cout << "LED created on pin " << pin << std::endl;
//}


// Turn the LED on
void LED::on() {
    state = true;
    //std::cout << "LED on pin " << pin << " is ON." << std::endl;
}

// Turn the LED off
void LED::off() {
    state = false;
    //std::cout << "LED on pin " << pin << " is OFF." << std::endl;
}

// Get the current state of the LED
bool LED::isOn() const {
    return state;
}