
/* * * * * * * * * * * * * * * * * * * * * * * * *
* PLEASE DO NOT CHANGE ANYTHING UNLESS REQUESTED *
* * * * * * * * * * * * * * * * * * * * * * * * * */
/* @Author
 * Student Name: Abdullah Jafar Mansour Shamout
 * Student ID : 150200919
 */

#include "university.h"
#include <string>
#include <iostream>

int main() {

    std::cout << "Welcome to the University Admission System!" << std::endl;

    /* Create University objects */
    University university_array[4] = {
        University{"Scranton State University", 1, 0.01, 0.009, -1, "USA"},
        University{"Central Perk College", 0.9, 0.03, 0.01, -5},
        University{"Brooklyn Institute of Technology", 0.4, 0.03, 0.001, -10},
        University{"McLaren's University", 0.2, 0.003, 0.001, -1.5}
    };

    /* Create Student objects */
    const Student student1{"Micheal", 2.5, 100, 90};
    Student student2{"Ross", 3.8, 160, 120};
    Student student3{"Amy", 3.5, 140, 100};
    Student* student4 = new Student{student1};
    student4->set_name("Lily");

    /* Evaluate students */
    university_array[0].evaluate_student(student1);

    university_array[1].evaluate_student(student2);
    university_array[2].evaluate_student(student2);
    university_array[3].evaluate_student(student2);

    university_array[0].evaluate_student(student3);
    university_array[3].evaluate_student(student3);
    
    /* Delete dynamically allocated memory */
    delete student4;

    return 0;
}