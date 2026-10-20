package org.example;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Допоміжні статичні методи, без логіки гри
 */
public class Utils {

    /**
     * Перевіряє, чи кількість кидків входить у дозволений діапазон від 1 до 10.
     *
     * @param number кількість кидків, яку потрібно перевірити
     * @return true, якщо число від 1 до 10 включно, інакше false
     */
    public static boolean validationCount (int number){
        if(number <=0 || number>10) return false;
        else return true;
    }

    /**
     * Читання файлу з перевіркою чи є число у файлі
     * @param nameFile ім'я файлу який потрібно зчитати, який обов'язково повинен знаходитись в папці проєкту, або шлях до цього файлу
     * @return зчитане число або -1, якщо файл пустий або там написано не число
     */
    public static int readFile(String nameFile){
        try (BufferedReader rd = Files.newBufferedReader(Path.of(nameFile))) {
            String number = rd.readLine();
            if(number!=null){
                int result = Integer.parseInt(number.trim());
                System.out.println("Успішне читання файлу");
                return result;
            }
            else {
                System.out.println("Помилка читання з файлу. Файл пустий");
                return -1;
            }
        } catch (IOException e) {
            System.out.println("Помилка читання з файлу");
            return -1;
        }
        catch (NumberFormatException e) {
            System.out.println("Помилка читання з файлу. У файлі не число");
            return -1;
        }
    }

    /**
     * Запис у файл переданого тексту
     * @param nameFile ім'я файлу в який потрібно записати текст, який обов'язково повинен знаходитись в папці проєкту, або шлях до цього файлу
     * @param text текст який потрібно записати у файл
     * @return true якщо запис був успішний і false якщо інше
     */
    public static boolean writeFile (String nameFile, String text){
        try {
            Files.writeString(Path.of(nameFile), text);
            System.out.println("Успішний запис у файл.");
            return true;
        } catch (IOException e) {
            System.out.println("Помилка під час запису файлу.");
            return false;
        }
    }

    /**
     * Вивід результату в консоль та файл
     * @param nameFile ім'я файлу в який потрібно записати текст, який обов'язково повинен знаходитись в папці проєкту, або шлях до цього файлу
     * @param text текст який потрібно записати у файл
     * @return true якщо запис у файл був успішний і false якщо інше
     */
    public static boolean writeResult(String nameFile, String text){
        System.out.println(text);
        if (!writeFile(nameFile, text)) {
            return false;
        }
        return true;
    }
}
