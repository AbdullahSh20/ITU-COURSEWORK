/* @Author
 * Student Name:  Abdullah Jafar Mansour Shamout
 * Student ID : 150200919
 */
#include <iostream>
#include "student.h"

    // I used the constructor to print the login message, as whenever an object is created they login into the system
    // I also used the setter methods I created to set the values of the student object
    Student::Student(std::string name, float GPA, int GRE, int TOEFL){
        set_name(name);
        set_GPA(GPA);
        set_GRE(GRE);
        set_TOEFL(TOEFL);
        std::cout << get_name() <<" logged in to the system." << std::endl;
        }
    // here I created a copy constructor because in main, student 4 was defined as a copy of student 1. So I took the input as a constant refrence because student 1 is a constant object
    Student::Student(const Student& stud) : Student {stud.name, stud.GPA, stud.GRE, stud.TOEFL}{
    }
    // here I created a destructor to log out everyone from the system once they go out of scope
    Student::~Student(){
        std::cout << get_name() << " logged out of the system with " << get_app() << " application(s)" << std::endl;
    }

    //Here I created the getters, they return the value requested without changing it since they are const methods

    std::string Student::get_name() const{
        return name;
    }
    float Student::get_GPA() const{
        return GPA;
    }
    int Student::get_GRE() const{
        return GRE;
    }
    int Student::get_TOEFL() const{
        return TOEFL;
    }
    int Student::get_app() const{
        return No_of_applications;
    }

    //Here I created the setters, they take the new input and give it as a value for the attribute
    void Student::set_name(std::string new_name){
        this-> name = new_name;
    }
    void Student::set_GPA(float new_GPA){
        this-> GPA = new_GPA;
    }
    void Student::set_GRE(int new_GRE){
        this-> GRE = new_GRE;
    }
    void Student::set_TOEFL(int new_TOEFL){
        this-> TOEFL = new_TOEFL;
    }

    //Here I created an increment function that is called everytime a student is evaluated, it increments the number of their applications by 1
    void Student::inc_app() const{
        this-> No_of_applications++;
    }