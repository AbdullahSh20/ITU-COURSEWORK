/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "arena.h"

Arena::~Arena(){
    if(Electric != nullptr)     //if Electric had memory allocated to it and it wasnt freed, I free it
        delete Electric;
    if(Psychic != nullptr)      //if Psychic had memory allocated to it and it wasnt freed, I free it
        delete Psychic;
};

void Arena::addPokemon(const char TYPE,const std::string NAME, int hp, int DAMAGE){
    if(TYPE == 'e'){    //if the type of the pokemon is electric do the following
        if(Electric == nullptr){    //check if it is null
            Electric = new ElectricPokemon(NAME, hp, DAMAGE);   //if its null, allocate memory for it and print that it entered the arena in the format specified in the output.txt
            std::cout << "Electric Pokemon " << NAME << " has entered the arena." << std::endl;
            std::cout << "Class: Electric" << std::endl;
            std::cout << "        Name: " << NAME << std::endl;
            std::cout << "        HP: " << hp << std::endl;
            std::cout << "        Damage: " << DAMAGE << "\n" << "\n" << std::endl;
        }
        else{
            delete Electric;                                    //if its not null, free the memory from before
            Electric = new ElectricPokemon(NAME, hp, DAMAGE);   //allocate memory for it and print that it entered the arena in the format specified in the output.txt
            restartTerrain();                                   //restart the terrain, since new pokemon entered the arena
            std::cout << "Electric Pokemon " << NAME << " has entered the arena." << std::endl;
            std::cout << "Class: Electric" << std::endl;
            std::cout << "        Name: " << NAME << std::endl;
            std::cout << "        HP: " << hp << std::endl;
            std::cout << "        Damage: " << DAMAGE << "\n" << "\n" << std::endl;
        }
    }
    else if(TYPE == 'p'){  //if the type of the pokemon is psychic I did the same thing that I did for electric
        if(Psychic == nullptr){
            Psychic = new PsychicPokemon(NAME, hp, DAMAGE);
            std::cout << "Psychic Pokemon " << NAME << " has entered the arena." << std::endl;
            std::cout << "Class: Psychic" << std::endl;
            std::cout << "        Name: " << NAME << std::endl;
            std::cout << "        HP: " << hp << std::endl;
            std::cout << "        Damage: " << DAMAGE << "\n" << "\n" << std::endl;
        }
        else{
            delete Psychic;
            Psychic = new PsychicPokemon(NAME, hp, DAMAGE);
            restartTerrain();
            std::cout << "Psychic Pokemon " << NAME << " has entered the arena." << std::endl;
            std::cout << "Class: Psychic" << std::endl;
            std::cout << "        Name: " << NAME << std::endl;
            std::cout << "        HP: " << hp << std::endl;
            std::cout << "        Damage: " << DAMAGE << "\n" << "\n" << std::endl;
        }

    }
    else{   //if its neither I created this error message
        std::cout << "One PsychicPokemon and one ElectricPokemon can enter an arena for battle (any other combination of Pokemons is not possible)";
    }
    return;
};
void Arena::spawnTerrain(){
    int temp = rand() % 10;         //I generate a random temporary number between 0 and 9
    if(terrain_cooldown == 0){      //if there is no cooldown I check for probabilities
        if (temp < 2)               //20% it is electric
        {
            terrain = "electric";   //the terrain is set to electric
            terrain_cooldown = 4;   //since the first round will be with this terrain that means the cooldown will be 4 since with this round it will be 5 rounds
            Electric->set_own_terrain(1);   //the electric pokemon is informed that it is on its own terrain
            Psychic->set_own_terrain(0);    //the psychic pokemon is informed that it is not on its own terrain
        }
        else if(temp < 4 && temp >= 2){ //20% it is psychic
            terrain = "psychic";    //the terrain is set to psychic
            terrain_cooldown = 4;   //since the first round will be with this terrain that means the cooldown will be 4 since with this round it will be 5 rounds
            Electric->set_own_terrain(0);   //the electric pokemon is informed that it is not on its own terrain
            Psychic->set_own_terrain(1);    //the psychic pokemon is informed that it is on its own terrain
        }
        else{
            terrain = "none";           //60% it is on neither terrain
            Electric->set_own_terrain(0);   //both pokemons are informed they are not on their own terrains
            Psychic->set_own_terrain(0);
        }
    }
    else{
        terrain_cooldown--;         //if there is a cooldown then I decrement it
    }
    return;
};

void Arena::restartTerrain(){
    terrain_cooldown = 0;       //to restart the terrain I set the cooldown to 0 and call spawnTerrain()
    spawnTerrain();
    return;
};

void Arena::simulateBattle(){
    int round = 0;              //starting a round counting variable
    int heads;                  //variable used to decide who starts first
    while ((Electric->is_fainted() == 0) && (Psychic->is_fainted() == 0))   //starting the loop and continuing it if both pokemons did not faint
    {
        spawnTerrain();             //spawn a terrain for the round
        heads = rand() % 2;         //if 1 Electric goes first, if 0 psychic goes first
        if (heads)
        {
            Electric->power_up();                       //electric attempts to power up
            Psychic->damage_taken(Electric->attack());  //electric attacks and Psychic takes damage
            
            if(Psychic->is_fainted()==0){               //if psychic didnt faint
            Psychic->power_up();                        //it attempts to power up
            Electric->damage_taken(Psychic->attack());  //it attacks and electric takes damage
            if(Psychic->is_powered_up()){               //if psychic was powered up when it attacked then it confuses the electric
                Electric->set_confused(1);
            }
            }

        }
        else{                                               //psychic goes first case
            Psychic->power_up();                            //it attempts to power up
            Electric->damage_taken(Psychic->attack());      //psychic attacks and electric takes damage
            if(Psychic->is_powered_up()){                   //if psychic was powered up when it attacked then it confuses the electric
                Electric->set_confused(1);
            }

            if(Electric->is_fainted()==0){                  //to check if electric didnt faint from the previous attack
            Electric->power_up();                           //it attempts to power up
            Psychic->damage_taken(Electric->attack());      //electric attacks and psyhic takes damage
            }
        }
        round++;                                            //increment the round
        printRoundStats(round, heads);                      //print the round stats
    }
    printMatchResults();                                    //if one of the pokemons fail then we print the match results
    return;
};

void Arena::printRoundStats(const int ROUND, const int HEADS) const{

    std::cout << "Round: " << ROUND << std::endl;                   //print the round number
    std::cout << "Current Terrain: " << get_terrain() << std::endl; //print the type of terrain I am on

    //according to the simulation I print who went first
    if (HEADS)
    {
        std::cout << Electric->get_NAME() << " goes first." << std::endl;
    }
    else{
        std::cout << Psychic->get_NAME() << " goes first." << std::endl;
    }

    //I write if Electric powered up first then I write if Psychic powered up, as per the output example, "it is not HEADS dependent"
    if(Electric->is_powered_up()){
        std::cout << Electric->get_NAME() << " has initiated a power up" << std::endl;
    }
    if(Psychic->is_powered_up()){
        std::cout << Psychic->get_NAME() << " has initiated a power up" << std::endl;
    }

    //I print the HP stats for Electric then Psychic as per the output example
    std::cout << Electric->get_NAME() << " HP: " << Electric->get_hp() << std::endl;
    std::cout << Psychic->get_NAME() << " HP: " << Psychic->get_hp() << std::endl;

    //I print out who is in the lead according to their HP stats and if they are both equal I print that no one is in the lead
    if(Electric->get_hp() > Psychic->get_hp()){
        std::cout << Electric->get_NAME() << " is in the lead!" << "\n" << "\n" << std::endl;
    }
    else if(Electric->get_hp() < Psychic->get_hp()){
        std::cout << Psychic->get_NAME() << " is in the lead!" << "\n" << "\n" << std::endl;
    }
    else{
        std::cout << "no one is in the lead!" << "\n" << "\n" << std::endl;
    }
    return;
};

void Arena::printMatchResults() const{
    std::cout << "Match Results: " << std::endl;
    if (Electric->is_fainted())     //if the electric pokemon is the one that fainted, then I print that the psychic won
    {
        std::cout << Psychic->get_NAME() << " has won the match!" << "\n" << "\n" << std::endl;
    }
    else{                           //if the psychic pokemon is the one that fainted, then I print that the Electric won
        std::cout << Electric->get_NAME() << " has won the match!" << "\n" << "\n" << std::endl;
    }
    return;
};