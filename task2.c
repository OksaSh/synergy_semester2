#include <iostream>
#include <string>

using namespace std;

// Базовый класс
class Vehicle
{
protected:
    string brand;

public:
    // Конструктор базового класса
    Vehicle(const string& vehicleBrand)
        : brand(vehicleBrand)
    {
        cout << "Вызван конструктор базового класса Vehicle." << endl;
    }

    // Метод базового класса
    void ShowBrand() const
    {
        cout << "Марка транспортного средства: " << brand << endl;
    }

    // Виртуальный метод базового класса
    virtual void Move() const
    {
        cout << "Транспортное средство движется." << endl;
    }

    // Виртуальный деструктор
    virtual ~Vehicle()
    {
        cout << "Вызван деструктор класса Vehicle." << endl;
    }
};

// Производный класс
class Car : public Vehicle
{
private:
    string model;

public:
    // Конструктор производного класса
    Car(const string& carBrand, const string& carModel)
        : Vehicle(carBrand), model(carModel)
    {
        cout << "Вызван конструктор производного класса Car." << endl;
    }

    // Метод производного класса
    void ShowModel() const
    {
        cout << "Модель автомобиля: " << model << endl;
    }

    // Переопределение метода базового класса
    void Move() const override
    {
        cout << "Автомобиль " << brand << " " << model
             << " движется по дороге." << endl;
    }

    // Деструктор производного класса
    ~Car() override
    {
        cout << "Вызван деструктор класса Car." << endl;
    }
};

int main()
{
    cout << "Создание объекта производного класса:" << endl;

    Car car("Toyota", "Camry");

    cout << endl;
    cout << "Вызов унаследованного метода базового класса:" << endl;
    car.ShowBrand();

    cout << endl;
    cout << "Вызов метода производного класса:" << endl;
    car.ShowModel();

    cout << endl;
    cout << "Вызов переопределенного метода:" << endl;
    car.Move();

    cout << endl;
    cout << "Демонстрация полиморфизма:" << endl;

    Vehicle* vehiclePointer = &car;
    vehiclePointer->Move();

    cout << endl;
    cout << "Завершение программы." << endl;

    return 0;
}