package org.example;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Клас зчитує config.txt і обробляє всі набори даних для гри (Частина 2)
 */
public class ConfigRunner {

    /**
     * Читає файл та повертає наступний непорожній рядок від поточної позиції
     * @param buffer буфер файлу BufferedReader
     * @return повертає наступний непорожній рядок від поточної позиції типу String, null - кінець файлу
     * @throws IOException може повертати тільки IOException (помилка читання файлу)
     */
    public static String readNonEmptyLine(BufferedReader buffer) throws IOException {
        String line;
        while ((line = buffer.readLine()) != null) {
            if (!(line.trim().isEmpty())){
                return line;
            }
        }
        return null;
    }

    /**
     * Перетворює рядок на ціле число, при помилці конвертації повертає -1
     * @param line рядок для перетворення
     * @return повертає ціле число або -1 якщо при конвертації виникла помилка
     */
    public static int parseNumber(String line){
        int number;
        try {
            number = Integer.parseInt(line.trim());
        }
        catch (NumberFormatException e){
            number=-1;
        }
        return number;
    }

    /**
     * Метод для виконання частини 2
     * @param nameFile ім'я файлу конфігурації
     * @return повертає результат симуляції наборів з файлу типу String, при помилці в даних повертається текст повідомлення про помилку
     */
    public static String runConfig(String nameFile) {
        String result = "";
        try (BufferedReader rd = Files.newBufferedReader(Path.of(nameFile))) {
            String countSetsStr= readNonEmptyLine(rd);
            if (countSetsStr !=null){
                int countSets = parseNumber(countSetsStr);
                if (countSets>0){
                    for (int i = 0; i< countSets; i+=1){
                        String countStr=readNonEmptyLine(rd);
                        if (countStr == null){
                            result += "Помилка! Наборів у файлі менше, ніж вказано в першому рядку (знайдено " + i + " з " + countSets + ")" + "\n";
                            break;
                        }
                        int count = parseNumber(countStr);
                        if (Utils.validationCount(count)){
                            result += "Набір " + (i + 1) + ":\n" + Main.playGame(count);
                        }
                        else{
                            result+= "Набір " + (i + 1) + ": помилка! Кількість кидків має бути цілим числом від 1 до 10" + "\n";
                        }
                    }
                    String countStrNext=readNonEmptyLine(rd);
                    if (countStrNext != null){
                        result += "Помилка! Наборів у файлі більше, ніж вказано в першому рядку (знайдено як мінімум " + (countSets + 1) + " з " + countSets + ") і вони проігноровані" + "\n";
                    }
                }
                else {
                    return "Помилка! Кількість наборів у першому рядку має бути цілим числом більше 0" + "\n";
                }
            }
            else{
                return "Помилка! Файл конфігурації порожній" + "\n";
            }
        } catch (IOException e) {
            return "Помилка читання з файлу " + nameFile + "\n";
        }
        return result;
    }
}
