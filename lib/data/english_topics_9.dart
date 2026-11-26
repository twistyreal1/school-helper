import '../models/topic_model.dart';

/// Полный курс английского языка 9 класса по официальному школьному учебнику
/// «Spotlight 9» (Английский в фокусе 9 класс, Ю. Е. Ваулина, Д. Дули, О. Е. Подоляко, В. Эванс, Просвещение).
/// Все 8 модулей программы (Modules 1 – 8): грамматика, лексика, идиомы, фразовые глаголы, правила и практические примеры.
const List<Topic> englishTopics9 = [
  Topic(
    id: 'eng_9_mod01',
    title: 'Module 1. Celebrations (Праздники и традиции. Настоящие времена и Relative Clauses)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Festivals, traditions, superstitions, special occasions, idioms with cake. Grammar: Present Simple, Present Continuous, Present Perfect, Present Perfect Continuous, Relative Clauses (who, which, whose, where, when), participle adjectives (-ed / -ing). Phrasal verb: turn.',
    formulas: [
      FormulaItem(
        title: 'Present Perfect vs Present Perfect Continuous',
        formula: '\\text{Present Perfect (результат): } S + \\text{have/has} + V3 \\qquad \\text{Present Perfect Continuous (длительность): } S + \\text{have/has been} + V\\text{-ing}',
        description: 'I have painted the room (оно готово) vs I have been painting since morning (процесс все еще идет или только что прекратился)',
      ),
      FormulaItem(
        title: 'Относительные придаточные (Relative Clauses)',
        formula: '\\text{People: } \\textbf{who / that} \\quad \\text{Things: } \\textbf{which / that} \\quad \\text{Possession: } \\textbf{whose} \\quad \\text{Places: } \\textbf{where} \\quad \\text{Time: } \\textbf{when}',
        description: 'Defining clauses не выделяются запятыми; non-defining (дополнительная информация) выделяются запятыми, в них нельзя использовать that.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Defining Relative Clause',
        definition: 'Определительное придаточное предложение, содержащее существенную информацию для идентификации предмета или лица (без него смысл фразы теряется). Запятыми не выделяется.',
      ),
      DefinitionItem(
        term: 'Non-defining Relative Clause',
        definition: 'Определительное придаточное, сообщающее лишь дополнительную информацию. Обязательно выделяется запятыми с обеих сторон; союз "that" в нем не употребляется.',
      ),
    ],
    rules: [
      'Причастия на -ed описывают состояние или чувства человека (bored = скучающий, interested = заинтересованный). Причастия на -ing описывают свойство предмета или ситуации (boring = скучный, interesting = интересный).',
      'Фразовый глагол turn: turn into (превращаться в), turn down (отклонять предложение / делать тише), turn up (появляться неожиданно / делать громче), turn off (выключать), turn on (включать).',
      'Идиомы со словом cake: "a piece of cake" (проще простого), "sell like hot cakes" (расходиться нарасхват), "icing on the cake" (вишенка на торте).',
      'Временные маркеры: for (период времени — for 3 years) и since (начальная точка отсчета — since Monday).',
    ],
    lifehacks: [
      'Если в предложении есть глагол со значением состояния (know, have, like, believe) и маркер since/for, Present Perfect Continuous НЕ используется: пишем только Present Perfect — "I have known him for 5 years" (а не "have been knowing").',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: "She (wait) for the festival parade to start for two hours and she is very tired."',
        steps: [
          '1. Действие началось два часа назад (for two hours), длилось непрерывно и его результат ощущается прямо сейчас (she is very tired).',
          '2. Глагол wait — динамический, выражает длительность процесса.',
          '3. Формула Present Perfect Continuous: has been + waiting.',
        ],
        answer: 'has been waiting',
      ),
      ExampleItem(
        task: 'Объедините предложения с помощью местоимения whose: "This is Mark. His brother won the dance competition."',
        steps: [
          '1. Местоимение his выражает принадлежность (чей брат?).',
          '2. Заменяем притяжательное местоимение his на союзное слово whose.',
        ],
        answer: 'This is Mark, whose brother won the dance competition.',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 1', 'Celebrations', 'Present Perfect Continuous', 'Relative Clauses', 'Phrasal turn'],
  ),

  Topic(
    id: 'eng_9_mod02',
    title: 'Module 2. Life & Living (Образ жизни и жилье. Инфинитив, герундий и косвенные вопросы)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Houses, household chores, living in space, towns & villages, neighbours. Grammar: Infinitive (to-infinitive / bare infinitive) vs -ing form (Gerund), too and enough, order of adjectives, direct and indirect questions. Phrasal verb: make.',
    formulas: [
      FormulaItem(
        title: 'Употребление герундия (-ing form) и инфинитива',
        formula: '\\text{-ing: enjoy, avoid, mind, suggest, look forward to} \\qquad \\text{to-inf: decide, hope, promise, refuse, afford, want}',
        description: 'Bare infinitive (без частицы to): после модальных глаголов (can, must, should) и глаголов let, make (в активном залоге).',
      ),
      FormulaItem(
        title: 'Конструкции с too и enough',
        formula: '\\textbf{too} + \\text{adjective/adverb} + \\text{to-V1} \\qquad \\text{adjective/adverb} + \\textbf{enough} + \\text{to-V1} \\qquad \\textbf{enough} + \\text{noun}',
        description: 'He is too young to drive (слишком молод). He is old enough to drive. We have enough money.',
      ),
      FormulaItem(
        title: 'Порядок нескольких прилагательных перед существительным (OSASCOMP)',
        formula: '\\text{Opinion} \\rightarrow \\text{Size} \\rightarrow \\text{Age} \\rightarrow \\text{Shape} \\rightarrow \\text{Colour} \\rightarrow \\text{Origin} \\rightarrow \\text{Material} \\rightarrow \\text{Noun}',
        description: 'A beautiful (opinion) large (size) old (age) square (shape) brown (colour) wooden (material) table.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Gerund (-ing form)',
        definition: 'Неличная форма глагола, совмещающая свойства глагола и существительного. Употребляется в роли подлежащего, дополнения, а также после предлогов и фиксированных выражений.',
      ),
      DefinitionItem(
        term: 'Indirect Question (Косвенный вопрос)',
        definition: 'Вежливая форма вопроса, начинающаяся с вводной фразы (Could you tell me...? Do you know...?). Порядок слов в самом вопросе становится прямым (подлежащее + сказуемое), вспомогательные do/does/did опускаются.',
      ),
    ],
    rules: [
      'Глаголы с изменением значения: remember / forget to do (помнить о необходимости сделать что-то) vs remember doing (помнить о событии в прошлом); stop to do (остановиться, чтобы сделать) vs stop doing (прекратить действие совсем).',
      'Фразовый глагол make: make up (придумывать историю / мириться / наносить макияж), make out (разглядеть / разобрать с трудом), make up for (компенсировать, заглаживать вину), make for (направляться к).',
      'Косвенный вопрос: "Where is the post office?" -> "Could you tell me where the post office is?" (а не "where is the post office").',
    ],
    lifehacks: [
      'После предлогов ВСЕГДА ставится форма с окончанием -ing: fond of reading, interested in learning, good at drawing, without saying a word.',
    ],
    examples: [
      ExampleItem(
        task: 'Переделайте прямой вопрос в косвенный: "What time does the train arrive?" -> "Do you know..."',
        steps: [
          '1. Начинаем с вводной вежливой фразы: "Do you know...".',
          '2. Убираем вспомогательный глагол does.',
          '3. Глагол arrive принимает окончание третьего лица единственного числа: arrives.',
          '4. Порядок слов становится прямым: the train arrives.',
        ],
        answer: 'Do you know what time the train arrives?',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 2', 'Life & Living', 'Infinitive', 'Gerund', 'too and enough', 'Indirect questions', 'Phrasal make'],
  ),

  Topic(
    id: 'eng_9_mod03',
    title: 'Module 3. See It to Believe It (Тайны и загадки. Прошедшие времена и модальные глаголы предположения)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Monsters, dreams & nightmares, illusions, mysteries, castle legends. Grammar: Past Simple, Past Continuous, Past Perfect, Past Perfect Continuous, used to / would, modal verbs of deduction and assumption (must, can’t, may/might). Phrasal verb: come.',
    formulas: [
      FormulaItem(
        title: 'Времена группы Past',
        formula: '\\text{Past Simple: } V2/V\\text{-ed} \\quad \\text{Past Continuous: } \\text{was/were} + V\\text{-ing} \\quad \\text{Past Perfect: } \\text{had} + V3 \\quad \\text{Past Perf. Cont.: } \\text{had been} + V\\text{-ing}',
        description: 'Past Perfect выражает действие, совершившееся РАНЬШЕ другого действия в прошлом: When we arrived, the train had already left.',
      ),
      FormulaItem(
        title: 'Модальные глаголы вероятности и предположения (Modals of Deduction)',
        formula: '\\textbf{must + V1} \\text{ (уверенность 95\\%: должно быть)} \\quad \\textbf{can’t + V1} \\text{ (не может быть)} \\quad \\textbf{may / might / could + V1} \\text{ (возможно 50\\%)}',
        description: 'He must be at home (свет горит). He can’t be at work (сегодня воскресенье). He may know the answer.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Past Perfect Continuous',
        definition: 'Прошедшее совершенное длительное время, выражающее действие, которое началось в прошлом, продолжалось некоторое время и завершилось к определенному моменту в прошлом или вызвало видимый результат в тот момент.',
      ),
      DefinitionItem(
        term: 'Modals of Deduction',
        definition: 'Модальные глаголы, используемые говорящим для оценки степени уверенности в правдивости какого-либо факта на основании имеющихся улик или логики.',
      ),
    ],
    rules: [
      'Used to и would: "used to + V1" используется как для повторяющихся действий в прошлом, так и для прошлых состояний (I used to have a dog). "Would + V1" употребляется ТОЛЬКО для повторяющихся действий, но не для состояний (нельзя сказать: "I would live in London").',
      'Фразовый глагол come: come across (случайно натолкнуться / встретить), come down with (слечь с болезнью, простудиться), come out (выходить в свет, публиковаться), come round (приходить в себя / заходить в гости).',
      'Связка Past Continuous и Past Simple: длительное фоновое действие в Past Continuous прерывается кратким точечным действием в Past Simple: "I was sleeping when the phone rang".',
    ],
    lifehacks: [
      'В значении "не может быть" НИКОГДА не используется глагол mustn’t (он означает строгий запрет "нельзя"). Для отрицательного предположения используется ТОЛЬКО can’t: "It can’t be true!".',
    ],
    examples: [
      ExampleItem(
        task: 'Выберите правильный модальный глагол: "Listen! Somebody is playing the guitar. It (must / can’t) be John, he has sold his guitar yesterday."',
        steps: [
          '1. Вторая часть сообщает факт: Джон продал свою гитару вчера.',
          '2. Следовательно, это совершенно точно не может быть Джон.',
          '3. Для уверенности в невозможности события используется can’t.',
        ],
        answer: 'can’t',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 3', 'Mysteries', 'Past Perfect', 'used to and would', 'Modals of deduction', 'Phrasal come'],
  ),

  Topic(
    id: 'eng_9_mod04',
    title: 'Module 4. Technology (Технологии и будущее. Способы выражения будущего времени)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Technology, computers, internet problems, robots, gadgets. Grammar: Future Simple (will), be going to, Future Continuous, Future Perfect, Future Perfect Continuous, Time Clauses and Clauses of Purpose. Phrasal verb: break.',
    formulas: [
      FormulaItem(
        title: 'Future Continuous vs Future Perfect',
        formula: '\\text{Future Continuous: } \\textbf{will be} + V\\text{-ing} \\qquad \\text{Future Perfect: } \\textbf{will have} + V3',
        description: 'This time tomorrow I will be flying to London (процесс в точный момент). By 5 pm I will have finished my project (действие завершится К моменту).',
      ),
      FormulaItem(
        title: 'Придаточные времени и условия (Time and Condition Clauses)',
        formula: '\\text{Main Clause: } \\textbf{Future Simple (will + V1)} \\longleftrightarrow \\text{if / when / as soon as / before / until} + \\textbf{Present Simple}',
        description: 'В придаточных времени и условия будущее время НИКОГДА не употребляется с will: "I will call you when I arrive" (а не "when I will arrive").',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Future Perfect',
        definition: 'Будущее совершенное время. Обозначает действие, которое уже будет выполнено и завершено к определенному моменту в будущем (часто используется маркер "by + время" — by tomorrow, by 2030, by the end of the month).',
      ),
      DefinitionItem(
        term: 'Future Continuous',
        definition: 'Будущее длительное время. Обозначает действие, которое будет находиться в процессе развития в определенный точный момент в будущем.',
      ),
    ],
    rules: [
      'Конструкции выражения цели (Clauses of Purpose): to + V1 (чтобы сделать), in order to / so as to + V1, so that + can/could/will/would (чтобы + подлежащее + глагол).',
      'Фразовый глагол break: break down (сломаться о механизме / расплакаться, потерять самообладание), break into (вломиться, проникнуть со взломом), break out (внезапно начаться — о пожаре, войне, эпидемии), break up (расстаться, прекратить отношения / закрываться на каникулы).',
      'Случаи употребления will: спонтанные решения в момент речи, прогнозы на основе личного мнения (I think, I believe, probably), обещания (I promise I will help), угрозы и предложения помощи.',
    ],
    lifehacks: [
      'Маркер "by" (к какому-то моменту) — главный индикатор времен Perfect. Если стоит "by 6 o’clock tomorrow" — ставьте Future Perfect: will have finished.',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: "Don’t call me at 8 pm tomorrow. I (watch) the championship match."',
        steps: [
          '1. Указан конкретный момент времени в будущем: в 8 часов вечера завтра (at 8 pm tomorrow).',
          '2. В этот момент говорящий будет находиться в процессе просмотра матча.',
          '3. Формула Future Continuous: will be watching.',
        ],
        answer: 'will be watching',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 4', 'Technology', 'Future forms', 'Future Continuous', 'Future Perfect', 'Time clauses', 'Phrasal break'],
  ),

  Topic(
    id: 'eng_9_mod05',
    title: 'Module 5. Art & Literature (Искусство и литература. Степени сравнения и предпочтения)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Art forms, music types, theater, cinema, Shakespeare and literature. Grammar: Comparative and Superlative degrees, Gradable and Non-gradable (Extreme) adjectives, expressions of preference (would rather / would prefer). Phrasal verb: run.',
    formulas: [
      FormulaItem(
        title: 'Усилители сравнительной степени (Modifiers of Comparatives)',
        formula: '\\textbf{much / far / a lot / a bit / slightly} + \\text{Comparative} \\qquad \\textbf{by far} + \\text{Superlative}',
        description: 'Much faster (намного быстрее), slightly bigger (чуть больше), by far the best (безусловно лучший).',
      ),
      FormulaItem(
        title: 'Конструкции предпочтения: would rather vs would prefer',
        formula: '\\textbf{would rather} + V1 \\text{ than } + V1 \\qquad \\textbf{would prefer} + \\text{to-V1} \\text{ rather than } + V1',
        description: 'I would rather stay at home than go out. I would prefer to watch a film rather than read.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Gradable Adjectives',
        definition: 'Прилагательные, выражающие качество, которое может проявляться в разной степени (cold, hot, good, tired). Усиливаются наречиями very, extremely, slightly, rather.',
      ),
      DefinitionItem(
        term: 'Non-gradable / Extreme Adjectives',
        definition: 'Абсолютные (предельные) прилагательные, обозначающие крайнюю степень качества (freezing = ледяной, boiling = кипящий, fantastic, exhausted, tiny). Сочетаются с absolutely, totally, completely (но НЕ с very!).',
      ),
    ],
    rules: [
      'Нельзя сказать "very freezing" или "very exhausted" — с абсолютными прилагательными используется наречие absolutely: absolutely freezing, absolutely fantastic.',
      'Параллельная конструкция "чем..., тем...": "The more you practice, the better you play" (the + comparative..., the + comparative...).',
      'Фразовый глагол run: run into / across (случайно встретить знакомого), run out of (закончиться, иссякнуть о запасах — we ran out of milk), run over (переехать, сбить машиной), run away (убежать).',
      'Конструкция prefer: "prefer + noun/-ing + TO + noun/-ing": "I prefer cinema to theater", "I prefer dancing to singing".',
    ],
    lifehacks: [
      'Запомните: после "would rather" частица "to" НИКОГДА не ставится: "I would rather go" (НЕ "to go"). Но после "would prefer" частица "to" ОБЯЗАТЕЛЬНА: "I would prefer to go".',
    ],
    examples: [
      ExampleItem(
        task: 'Исправьте ошибку: "The weather was very boiling yesterday, so we stayed indoors."',
        steps: [
          '1. Boiling — это экстремальное (non-gradable) прилагательное со значением "невыносимо жаркий, кипящий".',
          '2. С такими прилагательными наречие very не используется.',
          '3. Заменяем very на absolutely или completely (либо заменяем boiling на hot: very hot).',
        ],
        answer: 'The weather was absolutely boiling yesterday, so we stayed indoors.',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 5', 'Art & Literature', 'Comparatives', 'Gradable adjectives', 'would rather', 'Phrasal run'],
  ),

  Topic(
    id: 'eng_9_mod06',
    title: 'Module 6. Town & Community (Городская жизнь. Пассивный залог и каузативная форма)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'City life, public services, volunteer work, animal shelters, green transport. Grammar: The Passive Voice (all tenses), The Causative (have/get something done), Reflexive & Emphatic Pronouns (-self/-selves), both...and, either...or, neither...nor. Phrasal verb: check.',
    formulas: [
      FormulaItem(
        title: 'Пассивный залог (The Passive Voice)',
        formula: '\\text{Subject} + \\textbf{be (в нужной форме)} + \\textbf{V3 (Past Participle)} + (\\text{by } + \\text{Agent})',
        description: 'The road was repaired yesterday. The new bridge is being built now. The parcel has been delivered.',
      ),
      FormulaItem(
        title: 'Каузативная конструкция (The Causative)',
        formula: '\\textbf{have / get} + \\text{object} + \\textbf{V3 (Past Participle)}',
        description: 'Обозначает действие, которое для субъекта выполняет кто-то другой (специалист): "I had my hair cut" (мне подстригли волосы, а не я сам их подстриг).',
      ),
      FormulaItem(
        title: 'Двойные союзы согласования',
        formula: '\\textbf{both ... and} \\text{ (всегда мн. число)}; \\quad \\textbf{either ... or} / \\textbf{neither ... nor} \\text{ (согласование по ближайшему подлежащему)}',
        description: 'Neither Peter nor his friends were ready. Either my mum or my dad is picking me up.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'The Causative Form',
        definition: 'Грамматическая конструкция (have/get + дополнение + Past Participle), выражающая организацию выполнения услуги или действия третьим лицом за плату или по поручению.',
      ),
      DefinitionItem(
        term: 'Reflexive Pronouns',
        definition: 'Возвратные местоимения (myself, yourself, himself, herself, itself, ourselves, yourselves, themselves). Используются, когда действие субъекта направлено на самого себя.',
      ),
    ],
    rules: [
      'Предлоги by и with в пассиве: "by" используется для исполнителя действия (орудие/человек: written by Pushkin), а "with" — для инструмента, материала или ингредиента (cut with a knife, filled with water).',
      'Глаголы, требующие двух дополнений (give, send, show, offer): имеют два варианта пассива. Более естественным в английском считается вариант с лицом в роли подлежащего: "I was offered a job" (предпочтительнее, чем "A job was offered to me").',
      'Фразовый глагол check: check in (зарегистрироваться в отеле/аэропорту), check out (выселиться / ознакомиться, проверить информацию), check off (отмечать галочкой в списке), check up on (проверять, контролировать кого-то).',
    ],
    lifehacks: [
      'Если вам починили телефон, покрасили забор или вылечили зуб — никогда не говорите "I repaired my phone" (это значит, что вы делали это лично своими руками). Всегда говорите каузативом: "I had my phone repaired".',
    ],
    examples: [
      ExampleItem(
        task: 'Перепишите в пассивном залоге: "They are painting the school building right now."',
        steps: [
          '1. Определяем время активного предложения: Present Continuous (are painting).',
          '2. Дополнение "the school building" становится подлежащим (ед. число).',
          '3. Формула Passive в Present Continuous: is/are being + V3 -> is being painted.',
        ],
        answer: 'The school building is being painted right now.',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 6', 'Town & Community', 'Passive Voice', 'Causative', 'Reflexive pronouns', 'Phrasal check'],
  ),

  Topic(
    id: 'eng_9_mod07',
    title: 'Module 7. Staying Safe (Безопасность и здоровье. Условные предложения 0–3 и модальные глаголы)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Fears and phobias, emotions, emergency services, healthy habits, safety tips. Grammar: Conditionals (Types 0, 1, 2, 3), Wishes (I wish / If only), Modal verbs of obligation, necessity and advice (must, have to, should, ought to, needn’t). Phrasal verb: keep.',
    formulas: [
      FormulaItem(
        title: 'Условные предложения (Conditionals Types 0 – 3)',
        formula: '\\text{Type 0 (факты): } \\text{If Present, Present} \\qquad \\text{Type 1 (реальное будущее): } \\text{If Present, will + V1} \\\\\n\\text{Type 2 (нереальное настоящее): } \\text{If Past Simple, would + V1} \\\\\n\\text{Type 3 (нереальное прошлое): } \\text{If Past Perfect, would have + V3}',
        description: 'Type 2: If I had wings, I would fly. Type 3: If you had warned me yesterday, I would have helped you.',
      ),
      FormulaItem(
        title: 'Конструкции сожаления (Wishes & Regrets)',
        formula: '\\textbf{I wish / If only} + \\text{Past Simple (сожаление о настоящем)} \\qquad \\textbf{I wish} + \\text{Past Perfect (сожаление о прошлом)}',
        description: 'I wish I had more free time (но у меня его нет). I wish I hadn’t eaten that cake yesterday (но я его съел).',
      ),
      FormulaItem(
        title: 'Модальные глаголы необходимости и совета',
        formula: '\\textbf{must} \\text{ (личная убежденность)} \\quad \\textbf{have to} \\text{ (внешние обстоятельства/правила)} \\quad \\textbf{should / ought to} \\text{ (совет)} \\quad \\textbf{needn’t} \\text{ (нет необходимости)}',
        description: 'Mustn’t = строгий запрет (нельзя!). Don’t have to = отсутствие необходимости (не обязательно).',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Conditional Type 3',
        definition: 'Условное предложение третьего типа (нереальное прошлое). Относится к уже произошедшим событиям в прошлом и выражает упущенную возможность или сожаление. Изменить прошлое уже невозможно.',
      ),
      DefinitionItem(
        term: 'Wishes (I wish / If only)',
        definition: 'Специальные конструкции, используемые для выражения сожаления о текущей ситуации (сдвиг времени на шаг назад в Past Simple) или о сделанном/несделанном в прошлом (сдвиг в Past Perfect).',
      ),
    ],
    rules: [
      'В Conditionals Type 2 с глаголом to be традиционно используется форма were для всех лиц: "If I were you, I would consult a doctor".',
      'I wish + would: используется только для выражения раздражения или желания, чтобы кто-то другой изменил свое поведение: "I wish you would stop shouting!". С местоимениями I и we форма would НЕ употребляется.',
      'Фразовый глагол keep: keep on (продолжать делать что-то упорно), keep up with (успевать за кем-то, держаться наравне), keep back (скрывать информацию / сдерживать), keep out of (держаться подальше от неприятностей).',
    ],
    lifehacks: [
      'Не путайте "mustn’t" и "don’t have to": "You mustn’t smoke here" = строго запрещено законом; "You don’t have to wake up early tomorrow" = воскресенье, можно поспать, нет необходимости.',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки (Conditionals Type 3): "If they (leave) earlier yesterday, they (not miss) the train."',
        steps: [
          '1. Ситуация относится к прошлому (yesterday) и является нереальной (поезд уже ушел).',
          '2. В придаточном с if используется Past Perfect: had left.',
          '3. В главном предложении используется would have + V3: would not have missed.',
        ],
        answer: 'If they had left earlier yesterday, they would not have missed the train.',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 7', 'Staying Safe', 'Conditionals 0-3', 'Wishes', 'Modals of obligation', 'Phrasal keep'],
  ),

  Topic(
    id: 'eng_9_mod08',
    title: 'Module 8. Challenges (Испытания и достижения. Косвенная речь и Question Tags)',
    subjectId: 'english',
    grade: 9,
    shortSummary: 'Survival skills, extreme expeditions, body parts and injuries, Helen Keller’s achievements. Grammar: Reported Speech (statements, questions, commands), reporting verbs, pronouns some/any/every/no compounds, Question Tags. Phrasal verb: carry.',
    formulas: [
      FormulaItem(
        title: 'Правило согласования времен в косвенной речи (Backshift of Tenses)',
        formula: '\\text{Present Simple} \\rightarrow \\text{Past Simple} \\qquad \\text{Present Continuous} \\rightarrow \\text{Past Continuous} \\\\\n\\text{Past Simple / Present Perfect} \\rightarrow \\text{Past Perfect} \\qquad \\text{will} \\rightarrow \\text{would} \\quad \\text{can} \\rightarrow \\text{could}',
        description: 'Сдвиг времен происходит, если вводный глагол стоит в прошедшем времени (said, told, asked).',
      ),
      FormulaItem(
        title: 'Разделительные вопросы (Question Tags)',
        formula: '\\text{Positive sentence} \\rightarrow \\textbf{negative tag?} \\qquad \\text{Negative sentence} \\rightarrow \\textbf{positive tag?}',
        description: 'You are from London, aren’t you? She didn’t call, did she? Let’s go, shall we? I am right, aren’t I?',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Reported Speech (Косвенная речь)',
        definition: 'Способ передачи чужого высказывания без сохранения его дословной формы. При этом изменяются личные местоимения, временные формы глаголов и указатели времени/места.',
      ),
      DefinitionItem(
        term: 'Reporting Verbs',
        definition: 'Глаголы, вводящие косвенную речь с передачей оттенка смысла: warn (предупреждать), advise (советовать), offer (предлагать помощь), refuse (отказываться), promise (обещать), apologize for (извиняться).',
      ),
    ],
    rules: [
      'Изменение указателей времени и места в косвенной речи: now -> then, today -> that day, yesterday -> the day before, tomorrow -> the next/following day, this -> that, these -> those, here -> there.',
      'Косвенный вопрос: вспомогательные глаголы do/does/did исчезают, порядок слов становится прямым повествовательным, знак вопроса в конце предложения не ставится. Общие вопросы вводятся союзами if / whether.',
      'Фразовый глагол carry: carry on (продолжать начатое), carry out (выполнять поручение / проводить опыт или исследование), carry away (увлекать, опьянять успехом — be carried away).',
    ],
    lifehacks: [
      'Исключения из правил Question Tags: 1) "I am..." -> "...aren’t I?"; 2) побуждение "Let’s..." -> "...shall we?"; 3) приказ/просьба "Close the window..." -> "...will you?".',
    ],
    examples: [
      ExampleItem(
        task: 'Переведите в косвенную речь: "He said: \'I haven’t seen Mary today\'."',
        steps: [
          '1. Вводный глагол said — в прошедшем времени, включается согласование времен.',
          '2. Местоимение I меняется на he.',
          '3. Время Present Perfect (haven’t seen) переходит на шаг назад в Past Perfect (hadn’t seen).',
          '4. Указатель времени today меняется на that day.',
        ],
        answer: 'He said that he hadn’t seen Mary that day.',
      ),
    ],
    tags: ['english 9', 'Spotlight 9', 'Module 8', 'Challenges', 'Reported Speech', 'Reporting verbs', 'Question Tags', 'Phrasal carry'],
  ),
];
