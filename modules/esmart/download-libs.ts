import fetch from 'node-fetch'; // Импортируем node-fetch для HTTP запросов
import fs from 'fs/promises'; // Модуль для работы с файловой системой
import path from 'path'; // Модуль для работы с файловой системой

const modules = [
  {
    env: 'ANDROID_LIB_ALPHA_OPEN_URL',
    output: path.resolve(__dirname, './android/libs/lib-alphaopenRelease-1.19.aar'),
  },
  {
    env: 'IOS_LIB_ALPHA_OPEN_URL',
    output: path.resolve(__dirname, './ios/libs/libEsmartVirtualCard.a'),
  },
];

// Функция для загрузки и декодирования файла
async function fetchAndSaveFile(url: string, output: string) {
  // Выполняем HTTP запрос
  const response = await fetch(url);
  if (!response.ok) {
    console.error(`HTTP error! Status: ${response.status}`);
    throw new Error(`HTTP error! Status: ${response.status}`);
  }

  // Получаем данные в виде текста (base64)
  const base64Data = await response.text();

  // Декодируем base64 в строку
  const decodedData = Buffer.from(base64Data, 'base64');

  // Сохраняем файл на диск
  await fs.writeFile(output, decodedData);

  console.log(`Success - ${output}`);
}

const run = async () => {
  console.log('Starting download-libs.js');

  for (const module of modules) {
    const env = process.env[module.env];
    if (env) {
      console.log(`Starting download ${module.env}`);
      await fetchAndSaveFile(env, module.output).catch(() => {
        console.error('fetchAndSaveFile failed');
      });
    } else {
      console.log(`process.env.${module.env} is empty, skip`);
    }
  }

  console.log('Ending download-libs.js');
};

run();
