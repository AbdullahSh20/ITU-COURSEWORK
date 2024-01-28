/*
Abdullah Jafar Mansour Shamout
150200919
*/
#pragma once
#include <iostream>

class Pokemon{
    public:
        Pokemon(const std::string& NAME, int hp,const int DAMAGE,const double POWERUP_CHANCE,const int RECHARGE); //constructor for attributes for all pokemons, hp is the only non const value as it changes during battle
        const std::string& get_NAME() const { return NAME; };       //a function that gets the name of the pokemon, its a getter so i wrote it as inline
        const int get_DAMAGE() const { return DAMAGE; };            //a function that gets the amount of damage that a pokemon does, its a getter so i wrote it as inline
        const int get_hp() const { return hp; };                    //a function that gets the hp of the pokemon, its a getter so i wrote it as inline
        const bool is_powered_up() const { return powered_up; };    //a function that checks if the pokemon is powered up, its short and returns a bool so I wrote it as inline
        const bool is_fainted() const { return fainted; };          //a function that checks whether the pokemon fainted or not, its short and returns a bool so I wrote it as inline
        const bool is_own_terrain() const { return own_terrain; };  //a funciton that checks if the pokemon is in his own terrain or not, its short and returns a bool so I wrote it as inline
        void set_fainted();                                         //a setter that sets the pokemon to fainted or not based on its hp.
        void set_own_terrain(const bool ON_TERRAIN);                //a function that sets the own_terrain attribute to 1 if the pokemon is on its own terrain
        void damage_taken(const int DAMAGE_TAKEN);                  //a function that makes the pokemon take damage, as requested per the assignment it is uniform for all pokemons
        void power_up();                                            //a function that attempts to power up the pokemon if the conditions are suitable and the probability is met

    private:
        const std::string NAME{};       //name of the pokemon, const as the name doesnt change
        int hp{};                       //hitpoints of the pokemon, changes during battle, thats why its not capitalized as its a convintion only for constants to be all capitalized
        const int DAMAGE{};             //damage dealt by the pokemon, doesnt change per requested in the assignment
        const double POWERUP_CHANCE{};  //power up chance, set by the pokemon type and cant be changed per requested
        const int RECHARGE{};           //recharge time, set by the pokemon type and cant be changed per requested
        int powerup_cooldown{};         //used to calculate the cooldown for a power up attempt, initialized as 0
        bool fainted{};                 //initialized as 0 as normally the pokemon would be alive at the start thus its false, the pokemon "faints" when its 1
        bool powered_up{};              //initialized as 0 as normally the pokemon would not be powered up at the start of the battle.
        bool own_terrain{};             //initialized as 0, but during the match it might change
};