package org.example;

/**
 * Головний файл проєкту
 */
public class Main {

    /**
     * Метод гри, симуляція кидання кубика
     * @param count кількість кидків
     * @return рядок (текст) результату який буде виводитись в консолі та у файлі
     */
    public static String playGame (int count) {
        int countValue1 = 0, countValue2 = 0, countValue3 = 0, countValue4 = 0, countValue5 = 0, countValue6 = 0;
        int max=0, min = 7;

        for (int i=0; i<count;i++) {
            int cubeNum = (int) (Math.random() * 6) + 1;
            if (cubeNum > max) max = cubeNum;
            if (cubeNum < min) min = cubeNum;
            switch (cubeNum){
                case 1:
                    countValue1 +=1;
                    break;
                case 2:
                    countValue2 +=1;
                    break;
                case 3:
                    countValue3 +=1;
                    break;
                case 4:
                    countValue4 +=1;
                    break;
                case 5:
                    countValue5 +=1;
                    break;
                case 6:
                    countValue6 +=1;
                    break;
            }
        }
        String result = "Кінець симуляції\nРезультати:\n";
        result += "Максимальне значення: "+max+"\n";
        result += "Мінімальне значення: "+min+"\n";
        result += "Число 1 випало: "+countValue1+" разів"+"\n";
        result += "Число 2 випало: "+countValue2+" разів"+"\n";
        result += "Число 3 випало: "+countValue3+" разів"+"\n";
        result += "Число 4 випало: "+countValue4+" разів"+"\n";
        result += "Число 5 випало: "+countValue5+" разів"+"\n";
        result += "Число 6 випало: "+countValue6+" разів"+"\n";
        return result;
    }

    /**
     * Тіло проєкту
     * @param args аргументи командного рядка (не використовуються)
     */
    public static void main(String[] args) {
        String result = "";
        result += "Частина 1:\n";
        int count = Utils.readFile("input.txt");
        if (count != -1){
            if (Utils.validationCount(count)){
                result += playGame(count);
            }
            else result += ("Помилка! Число не знаходиться в діапазоні від 1 до 10\n");
        }
        else result += "Частину 1 не виконано через помилку в input.txt\n";
        result += "\nЧастина 2:\n";
        result += ConfigRunner.runConfig("config.txt");
        Utils.writeResult("output.txt",result);
        System.out.println("Завершення симуляції");
    }
}
