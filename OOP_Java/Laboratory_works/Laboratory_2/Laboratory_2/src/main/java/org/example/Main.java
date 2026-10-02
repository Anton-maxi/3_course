package org.example;

import java.util.InputMismatchException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Введіть кількість кидків: ");
        int count;
        while (true){
            try {
                count = scanner.nextInt();
                if(count<=0 || count>10) throw new InputMismatchException();
                break;
            }
            catch (InputMismatchException e){
                System.out.print("Помилка! Введіть кількість кидків (ціле додатнє число, від 1 до 10): ");
                scanner.nextLine();
            }
        }

        int[] countValues= {0,0,0,0,0,0};
        int max=0, min = 7;

        for (int i=0; i<count;i++) {
            int cubeNum = (int) (Math.random() * 6) + 1;
            if (cubeNum > max) max = cubeNum;
            if (cubeNum < min) min = cubeNum;
            countValues[cubeNum - 1] += 1;
        }
        System.out.println("Кінець симуляції\nРезультати:\n");
        System.out.println("Максимальне значення: "+max);
        System.out.println("Мінімальне значення: "+min);
        for (int i=1; i<=countValues.length;i++){
            System.out.println("Число "+(i)+" випало: "+countValues[i-1]+" разів");
        }
        scanner.close();
    }
}
