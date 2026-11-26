import '../models/topic_model.dart';

/// Полный курс английского языка 8 класса по официальному школьному учебнику
/// «Spotlight 8» (Английский в фокусе 8 класс, Ю. Е. Ваулина, Д. Дули, О. Е. Подоляко, В. Эванс, Просвещение).
/// Все 8 учебных модулей программы (Modules 1 – 8) вынесены в отдельные самостоятельные темы:
/// лексика, грамматические правила и формулы, пассивный залог, косвенная речь, условные предложения (0–3), фразовые глаголы и примеры.
const List<Topic> englishTopics8 = [
  Topic(
    id: 'eng_8_mod01',
    title: 'Module 1. Socialising (Общение. Времена группы Present и Future)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Character traits, body language, meeting people, dealing with conflict; Grammar: Present Simple vs Present Continuous, Stative verbs, expressing future actions (will, be going to, Present Continuous), degrees of comparison; Phrasal verb: get (along with, across, over, down).',
    formulas: [
      FormulaItem(
        title: 'Present Simple vs Present Continuous',
        formula: '\\text{Present Simple (facts/habits): } S + V1 / V\\text{-s} \\qquad \\text{Present Continuous (now/temporary): } S + \\text{am/is/are} + V\\text{-ing}',
        description: 'Stative verbs (like, believe, know, understand, hate) are NOT used in continuous forms',
      ),
      FormulaItem(
        title: 'Способы выражения будущего (Future Forms)',
        formula: 'will + V1 \\text{ (спонтанное решение)}; \\quad \\text{be going to} + V1 \\text{ (план/намерение)}; \\quad \\text{Present Continuous (договоренность)}',
        description: 'I think I will help you vs I am going to buy a car vs I am flying to Rome on Friday',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Body Language (Язык тела)',
        definition: 'Невербальное общение с помощью мимики, жестов, зрительного контакта и позы.',
      ),
      DefinitionItem(
        term: 'Stative Verbs',
        definition: 'Глаголы восприятия, мыслительной деятельности и эмоций, которые описывают состояние, а не динамическое действие.',
      ),
    ],
    rules: [
      'Глаголы со смешанным значением: "think" в значении "считать/полагать" — stative ("I think you are right"); в значении "размышлять" — dynamic ("I am thinking about the problem").',
      'Фразовый глагол get: get along/on with (ладить с кем-то), get over (преодолеть трудность/выздороветь), get across (донести мысль до слушателя), get down (расстраивать/угнетать).',
      'Степени сравнения наречий: fast -> faster -> fastest; carefully -> more carefully -> most carefully.',
    ],
    lifehacks: [
      'Если действие запланировано на 100% с купленными билетами или точной договоренностью с другими людьми — используйте Present Continuous: "We are meeting at 6 pm".',
    ],
    examples: [
      ExampleItem(
        task: 'Выберите правильную форму глагола: "Look at those dark clouds! It (will rain / is going to rain)".',
        steps: [
          'Прогноз погоды основан на очевидных видимых признаках в настоящий момент (темные тучи).',
          'Для очевидных прогнозов на основе внешних фактов используется конструкция be going to.',
        ],
        answer: 'is going to rain',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 1',
      'socialising',
      'Present tenses',
      'Future forms',
      'phrasal get',
    ],
  ),

  Topic(
    id: 'eng_8_mod02',
    title: 'Module 2. Food & Shopping (Питание и покупки. Времена группы Perfect)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Cooking methods, food collocations, supermarkets and packaging, consumer habits; Grammar: Present Perfect vs Present Perfect Continuous, has gone to vs has been to/in, quantifiers, order of adjectives; Phrasal verb: go (off, on, through, with).',
    formulas: [
      FormulaItem(
        title: 'Present Perfect Continuous (Действие началось в прошлом и длится до сих пор)',
        formula: 'S + \\text{have/has} + \\text{been} + V\\text{-ing}',
        description: 'How long have you been cooking? — I have been cooking for two hours.',
      ),
      FormulaItem(
        title: 'Порядок прилагательных перед существительным (Order of Adjectives)',
        formula: '\\text{Opinion} \\to \\text{Size} \\to \\text{Age} \\to \\text{Shape} \\to \\text{Colour} \\to \\text{Origin} \\to \\text{Material} \\to \\text{Noun}',
        description: 'A lovely (opinion) small (size) old (age) round (shape) brown (colour) wooden (material) table',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Present Perfect Continuous',
        definition: 'Время, подчеркивающее длительность и процесс действия, начавшегося в прошлом и продолжающегося в настоящем.',
      ),
      DefinitionItem(
        term: 'Has gone to vs Has been to',
        definition: 'has gone to — ушел/уехал туда и еще не вернулся; has been to — побывал там и уже вернулся обратно.',
      ),
    ],
    rules: [
      'Фразовый глагол go: go off (испортиться — о еде / сработать — о будильнике), go on (продолжать), go through (пережить трудности), go with (подходить, сочетаться — об одежде/еде).',
      'Quantifiers: a lot of (в утверждениях), many / much (в вопросах и отрицаниях), a few (несколько, достаточно), few (мало, недостаточно), a little (немного, достаточно), little (мало).',
    ],
    lifehacks: [
      'Мнемоническое слово для порядка прилагательных: OSASCOMP (Opinion, Size, Age, Shape, Colour, Origin, Material, Purpose).',
    ],
    examples: [
      ExampleItem(
        task: 'Вставьте has gone to или has been to: "Where is Mum? — She ... the supermarket to buy some groceries".',
        steps: [
          'Мамы сейчас нет дома, вопрос "Where is Mum?" показывает, что она ушла и еще не вернулась.',
          'Следовательно, используется has gone to.',
        ],
        answer: 'has gone to',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 2',
      'food',
      'shopping',
      'Present Perfect',
      'Present Perfect Continuous',
      'order of adjectives',
      'go',
    ],
  ),

  Topic(
    id: 'eng_8_mod03',
    title: 'Module 3. Great Minds (Великие умы. Прошедшие совершенные времена)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Famous scientists and inventors (Marie Curie, Thomas Edison), professions, life stages; Grammar: Past Perfect (had + V3) vs Past Perfect Continuous (had been + V-ing), Complex Object; Phrasal verb: bring (about, out, round, up).',
    formulas: [
      FormulaItem(
        title: 'Past Perfect (Предпрошедшее время — действие раньше другого в прошлом)',
        formula: 'S + \\text{had} + V3/\\text{ed} \\quad (-) S + \\text{had not} + V3 \\quad (?) \\text{Had} + S + V3?',
        description: 'Keywords: by 5 o\'clock yesterday, by the time, before, after',
      ),
      FormulaItem(
        title: 'Complex Object (Сложное дополнение)',
        formula: 'S + V + \\text{Object (him/her/me)} + \\text{to-infinitive / bare infinitive / V-ing}',
        description: 'I want him to help me (желание). I saw him cross / crossing the street (восприятие).',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Past Perfect',
        definition: 'Время, выражающее действие, которое завершилось до определенного момента или до начала другого действия в прошлом.',
      ),
      DefinitionItem(
        term: 'Complex Object',
        definition: 'Синтаксическая конструкция, состоящая из существительного (или местоимения в объектном падеже) и инфинитива или причастия, выступающая единым членом предложения.',
      ),
    ],
    rules: [
      'Если в прошлом произошли два последовательных действия, то более раннее действие ставится в Past Perfect, а более позднее — в Past Simple: "When we arrived at the cinema, the film had already started".',
      'После глаголов чувственного восприятия (see, hear, watch, feel) частица to НЕ СТАВИТСЯ: "I heard her sing" (факт) или "I heard her singing" (процесс).',
      'После глаголов make (заставлять) и let (разрешать) инфинитив используется БЕЗ to: "He made me laugh", "Let him go".',
      'Фразовый глагол bring: bring about (вызвать, повлечь за собой), bring out (выпустить в продажу), bring round (привести в сознание), bring up (воспитывать детей).',
    ],
    lifehacks: [
      'Запомните формулу времени: Past Perfect — это "прошедшее для прошедшего". Если действие произошло ДО какого-то момента в прошлом — только Past Perfect (had + V3)!',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: By the time the police arrived, the thieves already (escape).',
        steps: [
          'Приезд полиции произошел в прошлом (arrived — Past Simple).',
          'Воры сбежали раньше, чем приехала полиция (предпрошедшее действие с маркером By the time).',
          'Используем Past Perfect: had already escaped.',
        ],
        answer: 'had already escaped',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 3',
      'Past Perfect',
      'Complex Object',
      'scientists',
      'bring',
    ],
  ),

  Topic(
    id: 'eng_8_mod04',
    title: 'Module 4. Be Yourself (Будь собой. Пассивный залог и каузатив)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Appearance, fashion trends, clothing styles and patterns, body image, self-esteem; Grammar: Passive Voice (Пассивный залог во всех временах), Causative Form (have/get something done), too / enough; Phrasal verb: put (on, off, out, through).',
    formulas: [
      FormulaItem(
        title: 'Формула страдательного залога (Passive Voice)',
        formula: 'S + \\text{be (в нужном времени)} + V3/\\text{ed} + (\\text{by / with} + \\dots)',
        description: 'The book was written by Pushkin. The letter is being typed now.',
      ),
      FormulaItem(
        title: 'Каузативная конструкция (Causative Form)',
        formula: 'S + \\text{have / get} + \\text{Object} + V3',
        description: 'Действие выполняется не самим человеком, а кем-то по его заказу (в парикмахерской, автосервисе): I had my hair cut',
      ),
      FormulaItem(
        title: 'Конструкции too и enough',
        formula: '\\text{too} + \\text{adjective} \\quad (\\text{слишком}); \\qquad \\text{adjective} + \\text{enough} \\quad (\\text{достаточно})',
        description: 'Too expensive (слишком дорогой) vs warm enough (достаточно теплый)',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Passive Voice (Страдательный залог)',
        definition: 'Грамматическая конструкция, в которой подлежащее является не исполнителем действия, а объектом, испытывающим воздействие на себе.',
      ),
      DefinitionItem(
        term: 'Causative Form',
        definition: 'Конструкция have something done, означающая, что услуга или действие выполнено для субъекта профессионалом за плату.',
      ),
    ],
    rules: [
      'Предлог by указывает на исполнителя действия ("written by Shakespeare"), а предлог with — на орудие или материал ("cut with a knife", "filled with water").',
      'Фразовый глагол put: put on (надеть одежду), put off (отложить на потом), put out (потушить огонь), put through (соединить по телефону), put up with (мириться с чем-то).',
      'Слово enough ставится ПОСЛЕ прилагательного (rich enough), но ПЕРЕД существительным (enough money).',
    ],
    lifehacks: [
      'Если вы подстриглись в парикмахерской, никогда не говорите "I cut my hair" (это значит, что вы сами взяли ножницы и обрезали волосы!). Скажите: "I had my hair cut" (Causative form).',
    ],
    examples: [
      ExampleItem(
        task: 'Переделайте предложение в Passive Voice: "They built this bridge in 1995".',
        steps: [
          'Дополнение "this bridge" становится новым подлежащим.',
          'Время глагола built — Past Simple.',
          'Форма глагола be в Past Simple для единственного числа — was.',
          'Третья форма глагола build — built.',
          'Получаем: "This bridge was built in 1995".',
        ],
        answer: 'This bridge was built in 1995',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 4',
      'Passive Voice',
      'Causative',
      'too enough',
      'put',
      'fashion',
    ],
  ),

  Topic(
    id: 'eng_8_mod05',
    title: 'Module 5. Global Issues (Глобальные проблемы. Инфинитив и герундий)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Natural disasters (earthquakes, tsunamis, floods), climate change, endangered species, weather idioms; Grammar: Infinitive vs -ing form (Герундий), used to vs be/get used to, coordinate conjunctions (both...and, neither...nor, either...or); Phrasal verb: call (for, in, off, on).',
    formulas: [
      FormulaItem(
        title: 'Infinitive vs -ing Form',
        formula: '\\text{want, decide, hope, promise, afford} + \\text{to-infinitive}; \\quad \\text{enjoy, avoid, suggest, mind, spend time} + V\\text{-ing}',
        description: 'I decided to stay at home vs I enjoy reading books',
      ),
      FormulaItem(
        title: 'Конструкции привыкания (Used to / Be used to)',
        formula: '\\text{used to} + V1 \\text{ (раньше бывало)}; \\quad \\text{be / get used to} + V\\text{-ing / Noun} \\text{ (привык / привыкаю к)}',
        description: 'I used to live in a village vs I am used to waking up early',
      ),
      FormulaItem(
        title: 'Сочинительные союзы',
        formula: '\\text{both \\dots and (и \\dots и)}; \\quad \\text{either \\dots or (или \\dots или)}; \\quad \\text{neither \\dots nor (ни \\dots ни)}',
        description: 'Neither John nor Mary likes cold weather',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Герундий (-ing form)',
        definition: 'Неличная форма глагола, совмещающая свойства глагола и существительного, отвечающая на вопрос "делание чего-либо".',
      ),
    ],
    rules: [
      'После предлогов (about, in, of, without, after, before) глагол ВСЕГДА стоит в форме с окончанием -ing (герундий): "He left without saying goodbye".',
      'Глаголы stop, remember, forget меняют значение в зависимости от инфинитива или герундия: "stop smoking" (бросить курить навсегда) vs "stop to smoke" (остановиться, чтобы закурить).',
      'Фразовый глагол call: call for (требовать), call off (отменить мероприятие), call in (заглянуть к кому-то), call out (громко выкрикнуть).',
    ],
    lifehacks: [
      'Союз NEITHER ... NOR уже содержит отрицание! Второе отрицание в предложении не требуется: "Neither Tom nor Alex went to school" (НЕ "didn\'t go").',
    ],
    examples: [
      ExampleItem(
        task: 'Выберите правильную форму: 1) She suggested (going / to go) to the cinema. 2) He is interested in (learning / learn) Spanish.',
        steps: [
          '1) После глагола suggest употребляется герундий (-ing form) -> going.',
          '2) После предлога in употребляется герундий -> learning.',
        ],
        answer: '1) going; 2) learning',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 5',
      'infinitive',
      'gerund',
      'used to',
      'neither nor',
      'call',
      'ecology',
    ],
  ),

  Topic(
    id: 'eng_8_mod06',
    title: 'Module 6. Culture Exchanges (Культурный обмен. Косвенная речь)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Travel experiences, holidays, means of transport, host families, cultural monuments in danger; Grammar: Reported Speech (Косвенная речь: утверждения, команды, вопросы), согласование времен (Sequence of Tenses), say vs tell; Phrasal verb: set (off, out, back, aside).',
    formulas: [
      FormulaItem(
        title: 'Сдвиг времен в косвенной речи (Sequence of Tenses)',
        formula: 'V1 \\to V2; \\quad V2 \\to \\text{had } V3; \\quad \\text{have/has } V3 \\to \\text{had } V3; \\quad \\text{will} \\to \\text{would}; \\quad \\text{can} \\to \\text{could}',
        description: 'Present Simple -> Past Simple; Present Continuous -> Past Continuous; Past Simple -> Past Perfect',
      ),
      FormulaItem(
        title: 'Вопросы в косвенной речи (Прямой порядок слов!)',
        formula: 'S + \\text{asked} + \\text{wh-word / if} + \\text{Subject} + \\text{Verb}',
        description: '"Where do you live?" -> He asked me where I lived (без вспомогательного глагола do/did)',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Reported Speech (Косвенная речь)',
        definition: 'Передача чужого высказывания не слово в слово, а от лица автора с соответствующими грамматическими изменениями местоимений, времен и наречий времени.',
      ),
    ],
    rules: [
      'Разница say и tell: SAY используется без указания адресата ("He said that..."), TELL используется с обязательным указанием лица ("He told ME that...").',
      'Изменение указателей времени: now -> then; today -> that day; yesterday -> the day before; tomorrow -> the next day; here -> there; this -> that.',
      'Приказы и просьбы: "Open the door" -> "He told me TO open the door"; "Don\'t shout" -> "He told me NOT TO shout".',
      'Фразовый глагол set: set off / set out (отправиться в путешествие), set back (задержать развитие), set aside (откладывать деньги).',
    ],
    lifehacks: [
      'В косвенном вопросе порядок слов становится ПРЯМЫМ, как в обычном утверждении: сначала подлежащее, потом сказуемое! Никаких do, does, did в косвенных вопросах быть не должно!',
    ],
    examples: [
      ExampleItem(
        task: 'Переведите в косвенную речь: Ann said: "I bought a new camera yesterday".',
        steps: [
          'Глагол в главной части said (в прошедшем времени) -> требуется сдвиг времен.',
          'Местоимение I меняется на she.',
          'Past Simple "bought" сдвигается на шаг назад в Past Perfect: "had bought".',
          'Наречие времени "yesterday" меняется на "the day before".',
          'Итог: Ann said that she had bought a new camera the day before.',
        ],
        answer: 'Ann said that she had bought a new camera the day before',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 6',
      'Reported Speech',
      'say tell',
      'косвенная речь',
      'set',
      'travel',
    ],
  ),

  Topic(
    id: 'eng_8_mod07',
    title: 'Module 7. Education (Образование и медиа. Модальные глаголы предположения)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'School education, exams, higher education (Trinity College), careers in media, computer networks; Grammar: Modal verbs (must, have to, should, ought to, may, might, can, could), Modals for deduction (must be, can\'t be); Phrasal verb: give (away, back, up, off).',
    formulas: [
      FormulaItem(
        title: 'Модальные глаголы логической дедукции (Modals of Deduction)',
        formula: 'must \\text{ (уверенность на 90%: должно быть)}; \\quad may / might / could \\text{ (возможно: 50%)}; \\quad can\'t \\text{ (уверенность в невозможности)}',
        description: 'He must be at home (свет горит). He can\'t be abroad (я только что видел его).',
      ),
      FormulaItem(
        title: 'Долженствование: must vs have to vs should',
        formula: 'must \\text{ (личное решение)}; \\quad have to \\text{ (внешние правила/законы)}; \\quad should / ought to \\text{ (совет)}',
        description: 'You have to wear a school uniform (школьное правило). You should study more (совет).',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Modal Verbs of Deduction',
        definition: 'Модальные глаголы, выражающие степень уверенности говорящего в истинности утверждения на основе имеющихся улик или фактов.',
      ),
    ],
    rules: [
      'Must be означает твердую уверенность в утверждении ("Он наверняка...").',
      'Can\'t be означает твердую уверенность в том, что это невозможно ("Он точно не может быть..."). Отрицания "mustn\'t" в значении дедукции НЕ БЫВАЕТ!',
      'Фразовый глагол give: give away (отдать бесплатно / выдать тайну), give back (вернуть), give up (сдаться / бросить занятие), give off (испускать запах, дым, газ).',
    ],
    lifehacks: [
      'Если нужно выразить мысль "Не может быть, чтобы это было правдой!", используйте "It can\'t be true!", а не "must not".',
    ],
    examples: [
      ExampleItem(
        task: 'Вставьте подходящий модальный глагол дедукции (must или can\'t): "He has lived in London for 20 years. He ... speak English fluently".',
        steps: [
          'Человек прожил в Лондоне 20 лет, поэтому мы практически на 100% уверены, что он свободно говорит по-английски.',
          'Используем глагол уверенного логического вывода must.',
        ],
        answer: 'must',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 7',
      'modal verbs',
      'deduction',
      'must be',
      'can\'t be',
      'education',
    ],
  ),

  Topic(
    id: 'eng_8_mod08',
    title: 'Module 8. Pastimes (Спорт и увлечения. Условные предложения 0, 1, 2, 3 типов)',
    subjectId: 'english',
    grade: 8,
    shortSummary: 'Sports, extreme hobbies, sports equipment and venues; Grammar: Conditionals (Types 0, 1, 2, 3), Wish / If only, unless; Phrasal verb: take (after, off, up, over).',
    formulas: [
      FormulaItem(
        title: 'Zero & First Conditionals (Факты и реальное будущее)',
        formula: '\\text{Type 0: } \\text{If} + \\text{Present Simple}, \\quad \\text{Present Simple} \\qquad \\text{Type 1: } \\text{If} + \\text{Present Simple}, \\quad \\text{will} + V1',
        description: 'If you heat ice, it melts. If the weather is fine tomorrow, we will go cycling.',
      ),
      FormulaItem(
        title: 'Second Conditional (Нереальное условие в настоящем / мечты)',
        formula: '\\text{If} + \\text{Past Simple}, \\quad S + \\text{would} + V1',
        description: 'If I were rich, I would travel around the world. (В условии для всех лиц используется were: If I were you...)',
      ),
      FormulaItem(
        title: 'Third Conditional (Сожаление о нереальном прошлом)',
        formula: '\\text{If} + \\text{had} + V3, \\quad S + \\text{would have} + V3',
        description: 'If I had trained harder, I would have won the competition yesterday.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Second Conditional',
        definition: 'Условные предложения II типа, выражающие воображаемые, маловероятные или нереальные ситуации в настоящем или будущем ("Если бы... то бы...").',
      ),
      DefinitionItem(
        term: 'Third Conditional',
        definition: 'Условные предложения III типа, выражающие нереальные условия в прошлом, которые уже невозможно изменить, выражая сожаление или упрек.',
      ),
    ],
    rules: [
      'В условных предложениях II типа глагол to be традиционно принимает форму WERE для всех лиц (включая I, he, she, it): "If I were you, I would consult a doctor".',
      'Союз UNLESS означает "IF NOT" (если не): "You will fail the exam unless you study hard" = "if you don\'t study hard".',
      'Конструкция `I wish / If only + Past Simple` выражает сожаление о настоящем ("Жаль, что я не..."): "I wish I had more free time".',
      'Фразовый глагол take: take after (быть похожим на родителей), take up (начать заниматься спортом/хобби), take off (снять одежду / взлететь), take over (захватить контроль).',
    ],
    lifehacks: [
      'Как быстро различить типы: Type 1 — настоящее + будущее (реально); Type 2 — прошедшее + would (мечта в настоящем); Type 3 — предпрошедшее (had + V3) + would have (прошлое не вернуть).',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки во 2-м типе условий: If I (have) enough money, I (buy) this professional snowboard.',
        steps: [
          'Это Second Conditional (маловероятная ситуация в настоящем).',
          'В части с If ставим Past Simple: had.',
          'В главной части ставим would + V1: would buy.',
        ],
        answer: 'had, would buy',
      ),
    ],
    tags: [
      'english 8',
      'Spotlight 8',
      'Module 8',
      'Conditionals',
      'Second Conditional',
      'Third Conditional',
      'wish',
      'take',
    ],
  ),

];
