/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "electricPokemon.h"

//constructor that sets the ElectricPokemon by calling the Pokemon constructor
ElectricPokemon::ElectricPokemon(const std::string& Name, int hp, const int DAMAGE): Pokemon::Pokemon{Name,hp,DAMAGE,0.2,3}{};//the 0.2 here refers to the power up chance and the 3 refers to the recharge time for a power up

void ElectricPokemon::set_confusion_cooldown(){
    confusion_cooldown = 3;                         // a function that sets the cooldown for the confusion effect to 3
    return;         
};

void ElectricPokemon::set_confused(const bool STATUS){ //a fucntion that makes the electric pokemon confused if the psychic pokemon is powered up
    if(is_own_terrain()){                           //if the pokemon is on its own terrain then it doesnt get effected
        confused = 0;
    }
    else{
        confused = STATUS;                          //setting the confused attribute to the status recieved
        if(STATUS == 1){                            //if the pokemon gets confused then we will have to start a cooldown on its confusion
            set_confusion_cooldown();
        }
    }
    return;
};

const int ElectricPokemon::attack(){                //a function to generate damage that is going to be dealt by the pokemon that round
    if(is_confused()){                              //if it is confused we decrease the cooldown by 1
        confusion_cooldown--;
        if(confusion_cooldown == 0){                //if the cooldown became 0 we remove its confused state for the next round
            set_confused(0);
        }
        return (0);                                 //we return 0 damage for that round as it was confused
    }
    else if(is_powered_up()){                       //if it wasnt confused we check if it powered up that round, if it did it will deal 3 times the damage
        return (get_DAMAGE() * 3);
    }
    else{
        return get_DAMAGE();                        //if it wasnt powered up or confused then it deals the normal amount of damage
    }
};
