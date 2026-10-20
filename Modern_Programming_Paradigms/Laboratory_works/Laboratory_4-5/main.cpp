#include <iostream> 
#include <vector> 
#include <algorithm> 
#include <numeric> 
#include <functional> 
#include <ctime>

// Чиста функція: результат залежить лише від x, нічого не змінює поза собою і не виводить на екран.
int square(int x) { 
    return x * x; 
}

// Функція вищого порядку: приймає функцію func як аргумент. Чиста: початковий вектор не змінюється (const), повертається новий.
std::vector<int> transformVector(const std::vector<int>& vec, std::function<int(int)> func) { 
    std::vector<int> result;
    std::transform(vec.begin(), vec.end(), std::back_inserter(result), func);
    return result;
}

// Чиста функція: повертає результат лише на основі аргументу, без побічних ефектів.
int increment(int x) { 
    return x + 1; 
}

// Чиста функція: повертає результат лише на основі аргументу, без побічних ефектів.
int doubleValue(int x) { 
    return 2 * x;
}

// Функція вищого порядку: приймає дві функції і повертає нову, яка спочатку застосовує g, а потім f (композиція f(g(x))).
std::function<int(int)> compose(std::function<int(int)> f, std::function<int(int)> g) { 
    return [f, g](int x) { return f(g(x)); }; 
}

// Чиста функція-предикат: повертає true, якщо число просте. Залежить лише від num, використовується як умова для std::copy_if.
bool isPrime(int num) { 
    if (num <= 1) return false; 
    for (int i = 2; i * i <= num; i++) { 
        if (num % i == 0) return false; 
    } 
    return true; 
}

int main() { 
    std::srand(static_cast<unsigned int>(std::time(nullptr)));
    std::vector<int> nums, array, array2;
    for (int i = 1; i <= 20; i++) { 
        nums.push_back(i);
        array2.push_back(i);
        array.push_back(((rand()%3)-1)*i); 
    }

    std::cout << "=== Завдання 1: чиста функція та функція вищого порядку ===" << std::endl;
    nums = transformVector(nums, square);
    std::cout << "Квадрати чисел від 1 до 20: ";
    for (int i = 0; i < nums.size(); i++) {
        std::cout << nums[i] << " "; 
    }
    std::cout << std::endl << std::endl;

    std::cout << "=== Завдання 2: фільтрація парних чисел ===" << std::endl;
    std::vector<int> destination;

    // std::copy_if і std::accumulate: готові функції вищого порядку, умова або правило передаються лямбдою чи функцією.
    std::copy_if(array.begin(), array.end(), std::back_inserter(destination), [](int x) { return x % 2 == 0; });

    std::cout << "Парні числа: ";
    for (int i = 0; i < destination.size(); i++) {
        std::cout << destination[i] << " ";
    }
    std::cout << std::endl << std::endl;

    std::cout << "=== Завдання 3: композиція функцій ===" << std::endl;
    std::cout << "Результат композиції функцій (increment та doubleValue): ";
    for (int i = 0; i < array2.size(); i++) { 
        std::cout << compose(increment, doubleValue)(array2[i]) << " "; 
    }
    std::cout << std::endl << std::endl;

    std::cout << "=== Завдання 4: середнє значення простих чисел ===" << std::endl;
    std::vector<int> array1;
    for (int i = 1; i <= 100; i++) { 
        array1.push_back(rand() % 100 + 1); 
    }
    std::vector<int> result;
    double sum = 0.0;
    int count = 0;
    std::copy_if(array1.begin(), array1.end(), std::back_inserter(result), [](int x) { return isPrime(x); });
    sum = std::accumulate(result.begin(), result.end(), sum);
    count = result.size();
    std::cout << "Прості числа: ";
    for (int i = 0; i < result.size(); i++) {
        std::cout << result[i] << " "; 
    }
    std::cout << std::endl;
    std::cout << "Сума масиву простих чисел: " << sum << std::endl;
    std::cout << "Кількість простих чисел: " << count << std::endl;
    if (count > 0) {
        std::cout << "Середнє значення простих чисел: " << sum / count << std::endl;
    } else {
        std::cout << "Середнє значення простих чисел: 0" << std::endl;
    }

    return 0; 
}