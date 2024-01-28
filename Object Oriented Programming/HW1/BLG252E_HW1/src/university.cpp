/* @Author
 * Student Name:  Abdullah Jafar Mansour Shamout
 * Student ID : 150200919
 */
#include <iostream>
#include "university.h"
    // For the constructor I used my set_XXXXX methods to set the values of the object created
    University::University(std::string name, float GPA, float GRE, float TOEFL, float bias, std::string country){
        set_name(name);
        set_GPA(GPA);
        set_GRE(GRE);
        set_TOEFL(TOEFL);
        set_bias(bias);
        set_country(country);
    }
    // my getters only return the requested values
    std::string University::get_name() const{
        return name;
    }
    float University::get_GPA() const{
        return GPA;
    }
    float University::get_GRE() const{
        return GRE;
    }
    float University::get_TOEFL() const{
        return TOEFL;
    }
    float University::get_bias() const{
        return bias;
    }
    //my setters set the value for the object attributes when called
    void University::set_name(std::string new_name){
        this-> name = new_name;
    }
    void University::set_GPA(float new_GPA){
        this-> GPA = new_GPA;
    }
    void University::set_GRE(float new_GRE){
        this-> GRE = new_GRE;
    }
    void University::set_TOEFL(float new_TOEFL){
        this-> TOEFL = new_TOEFL;
    }
    void University::set_bias(float new_bias){
        this-> bias = new_bias;
    }
    void University::set_country(std::string new_country){
        this-> country = new_country;
    }
    /* this is the evaluate function, as stated in the homework paper, it works according to the perceptron, by creating a float value z
    and getting the sum of the inputs of the student * the weight of that input according to the specific university
    then by using an if statement and checking if z >= 0 we can print whether he will be admitted or rejected
    at the end of each evaluation the inc_app() function is called which increases the number of applications of that student by 1
    */
    void University::evaluate_student(const Student& stud){
        float z = stud.get_GPA() * get_GPA() + stud.get_GRE() * get_GRE() + stud.get_TOEFL() * get_TOEFL() + get_bias();
        if(z >= 0){
            std::cout << stud.get_name() << " is admitted to " << get_name() << "." << std::endl;
        }
        else{
            std::cout << stud.get_name() << " is rejected from " << get_name() << "." << std::endl;
        }
        stud.inc_app();
    }
