# Simple CloudFormation ALB Project

Максимально простий CloudFormation проект з одним Application Load Balancer та двома EC2 інстансами.

## Структура проекту

```
cloudformation-elb/
├── templates/
│   └── elb.yaml              # Єдиний CloudFormation шаблон
├── parameters.json           # Файл параметрів
├── scripts/
│   ├── deploy.sh             # Скрипт деплою
│   └── destroy.sh            # Скрипт видалення стеку
├── .gitignore               # Git ignore правила
├── Makefile                 # Автоматизація
└── README.md                # Документація
```

## Передумови

- AWS CLI встановлений та налаштований
- EC2 Key Pair створений в AWS
- Права доступу для CloudFormation операцій

## Швидкий старт

1. **Налаштуйте параметри:**

   ```bash
   # Відредагуйте parameters.json та вкажіть ваш Key Pair
   nano parameters.json
   ```

2. **Валідуйте шаблон:**

   ```bash
   make validate
   ```

3. **Запустіть деплой:**

   ```bash
   make deploy
   ```

4. **Перевірте результат:**
   - Скрипт покаже URL вашого ALB
   - Відкрийте URL в браузері

## Ручний деплой

```bash
# Деплой з дефолтною назвою стеку
./scripts/deploy.sh

# Деплой з кастомною назвою стеку
./scripts/deploy.sh my-custom-stack-name
```

## Управління стеком

### Видалення стеку

```bash
make destroy
# або
./scripts/destroy.sh
```

### Перегляд виходів стеку

```bash
aws cloudformation describe-stacks \
  --stack-name simple-alb-stack \
  --query 'Stacks[0].Outputs' \
  --output table
```

## Конфігурація

### Параметри

Єдиний параметр, який потрібно налаштувати:

- `KeyPairName` - Назва існуючого EC2 Key Pair для SSH доступу

## Створені ресурси

Шаблон створює наступні AWS ресурси:

- **VPC** - Віртуальна приватна хмара
- **Internet Gateway** - Шлюз для доступу в інтернет
- **2 Public Subnets** - Публічні підмережі в різних AZ
- **Route Table** - Таблиця маршрутизації
- **Security Groups** - Групи безпеки для ALB та EC2
- **Application Load Balancer** - Балансувальник навантаження
- **Target Group** - Група цілей для ALB
- **2 EC2 Instances** - EC2 інстанси з веб-сервером Apache
- **Listener** - HTTP слухач на порту 80

## Що відбувається після деплою

1. ALB отримує публічний DNS адрес
2. Два EC2 інстанси запускають Apache веб-сервер
3. Кожен інстанс показує різне повідомлення:
   - Instance 1: "Hello from EC2 Instance 1!"
   - Instance 2: "Hello from EC2 Instance 2!"
4. ALB розподіляє навантаження між інстансами

## Тестування

Після успішного деплою:

1. Відкрийте URL ALB в браузері
2. Оновлюйте сторінку кілька разів
3. Ви побачите різні повідомлення від різних інстансів

## Видалення ресурсів

```bash
make destroy
```

**Увага:** Це видалить всі створені ресурси!

## Корисні команди

```bash
# Перевірити статус стеку
aws cloudformation describe-stacks --stack-name simple-alb-stack

# Переглянути події стеку
aws cloudformation describe-stack-events --stack-name simple-alb-stack

# Валідувати шаблон
aws cloudformation validate-template --template-body file://templates/elb.yaml

# Переглянути всі стеки
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE
```

## Вартість

Цей проект створює ресурси, які можуть мати вартість:

- ALB: ~$16/місяць
- EC2 t2.micro: ~$8.5/місяць за інстанс (2 інстанси)
- **Загальна вартість: ~$33/місяць**

Не забудьте видалити стек після тестування!

## Ліцензія

MIT License
