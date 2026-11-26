import '../models/topic_model.dart';

/// Полный курс английского языка 7 класса по официальному школьному учебнику
/// «Spotlight 7» (Английский в фокусе 7 класс, Ю. Е. Ваулина, Д. Дули, О. Е. Подоляко, В. Эванс, Просвещение).
/// Все 10 учебных модулей программы (Modules 1 – 10) вынесены в отдельные самостоятельные темы:
/// лексика, грамматические правила и формулы, фразовые глаголы, предлоги, лайфхаки и типовые упражнения.
const List<Topic> englishTopics7 = [
  Topic(
    id: 'eng_7_mod01',
    title: 'Module 1. Lifestyles (Город и деревня. Настоящие времена)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'City and country lifestyles, safety rules in the street, free-time activities; Grammar: Present Simple vs Present Continuous; Phrasal verb: turn (on, off, into, up).',
    formulas: [
      FormulaItem(
        title: 'Present Simple (Regular/habitual actions)',
        formula: '(+) S + V / V-s/es \\quad (-) S + do/does + not + V1 \\quad (?) Do/Does + S + V1?',
        description: 'Keywords: always, usually, often, sometimes, rarely, never, every day/week',
      ),
      FormulaItem(
        title: 'Present Continuous (Action happening right now / temporary)',
        formula: '(+) S + am/is/are + V-ing \\quad (-) S + am/is/are + not + V-ing \\quad (?) Am/Is/Are + S + V-ing?',
        description: 'Keywords: now, at the moment, look!, listen!, currently, these days',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Present Simple',
        definition: 'Время для выражения регулярных, повторяющихся действий, привычек, расписаний или общеизвестных научных фактов.',
      ),
      DefinitionItem(
        term: 'Present Continuous',
        definition: 'Время для выражения действия, происходящего прямо в момент речи, временных ситуаций или запланированных действий на ближайшее будущее.',
      ),
      DefinitionItem(
        term: 'Stative Verbs (Глаголы состояния)',
        definition: 'Глаголы, обозначающие чувства, мысли и состояния (like, love, hate, know, understand, believe, want), которые обычно НЕ употребляются в форме Continuous.',
      ),
    ],
    rules: [
      'Глаголы с третьим лицом единственного числа (he, she, it) в Present Simple получают окончание -s или -es (he works, she watches).',
      'Если глагол обозначает состояние (know, like, belong), используем Present Simple даже со словом "now": "I understand you now" (НЕ "I am understanding").',
      'Фразовый глагол turn: turn on (включить), turn off (выключить), turn into (превратиться в), turn up (сделать громче / внезапно появиться).',
    ],
    lifehacks: [
      'Маркеры времени — ваши лучшие друзья: видите "every Sunday" или "always" -> Present Simple; видите "Look!" или "at the moment" -> Present Continuous.',
      'При добавлении -ing: run -> running (удвоение согласной после краткой гласной), write -> writing (выпадение немой -e).',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: Listen! Somebody (play) the guitar next door. Usually my brother (play) it.',
        steps: [
          'В первом предложении есть восклицание-маркер "Listen!" -> действие происходит прямо сейчас -> Present Continuous: is playing.',
          'Во втором предложении есть маркер регулярности "Usually" -> регулярное действие, подлежащее "brother" (he) -> Present Simple: plays.',
        ],
        answer: 'is playing, plays',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 1',
      'Present Simple',
      'Present Continuous',
      'phrasal verbs',
    ],
  ),

  Topic(
    id: 'eng_7_mod02',
    title: 'Module 2. Tale time (Время историй. Прошедшее простое время)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Literary genres and famous authors (Jules Verne, Agatha Christie, Sir Arthur Conan Doyle), feelings and emotions; Grammar: Past Simple (regular and irregular verbs), used to; Phrasal verb: run (out of, into, over, away).',
    formulas: [
      FormulaItem(
        title: 'Past Simple (Completed action in the past)',
        formula: '(+) S + V2 / V-ed \\quad (-) S + did not + V1 \\quad (?) Did + S + V1?',
        description: 'Keywords: yesterday, last night/week/year, two days ago, in 1998, when I was a child',
      ),
      FormulaItem(
        title: 'Конструкция used to (Привычки в прошлом)',
        formula: '(+) S + used to + V1 \\quad (-) S + didn\'t use to + V1 \\quad (?) Did + S + use to + V1?',
        description: 'Для действий, которые регулярно происходили в прошлом, но больше не совершаются',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Past Simple (Прошедшее простое)',
        definition: 'Время для описания единичных, завершенных действий в прошлом, последовательности событий или прошлых привычек.',
      ),
      DefinitionItem(
        term: 'Irregular Verbs (Неправильные глаголы)',
        definition: 'Глаголы, образующие формы прошедшего времени не по правилу добавления -ed, а путем изменения основы (go -> went, see -> saw, buy -> bought).',
      ),
    ],
    rules: [
      'В отрицательных предложениях и вопросах вспомогательный глагол DID забирает прошедшее время на себя, а смысловой глагол возвращается в начальную форму (инфинитив V1): "He didn\'t go" (НЕ "didn\'t went").',
      'Правильные глаголы: play -> played, stop -> stopped (удвоение согласной), study -> studied (y меняется на i после согласной).',
      'Фразовый глагол run: run out of (закончиться — о запасах), run into (случайно встретить кого-то), run away (убежать), run over (переехать, сбить).',
    ],
    lifehacks: [
      'Учите 2-ю и 3-ю формы неправильных глаголов рифмованными группами: sing-sang-sung, ring-rang-rung; bring-brought-brought, think-thought-thought.',
      'Used to переводится на русский язык словами "раньше бывало" или "в прошлом имел привычку".',
    ],
    examples: [
      ExampleItem(
        task: 'Поставьте предложение в отрицательную и вопросительную форму: "Tom bought a new detective story yesterday".',
        steps: [
          'Глагол bought — вторая форма глагола buy.',
          'Отрицание: S + did not + V1 -> "Tom didn\'t buy a new detective story yesterday".',
          'Вопрос: Did + S + V1 -> "Did Tom buy a new detective story yesterday?".',
        ],
        answer: 'Tom didn\'t buy... / Did Tom buy...?',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 2',
      'Past Simple',
      'used to',
      'irregular verbs',
      'run',
    ],
  ),

  Topic(
    id: 'eng_7_mod03',
    title: 'Module 3. Profiles (Внешность и характер. Придаточные определительные)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Appearance and character adjectives, inspiring people and hobbies; Grammar: Relative pronouns and adverbs (who, which, whose, where, when), Adjectives ending in -ed and -ing; Phrasal verb: give (up, away, back).',
    formulas: [
      FormulaItem(
        title: 'Relative Pronouns (Относительные местоимения)',
        formula: '\\text{who / that (люди)}, \\quad \\text{which / that (вещи/животные)}, \\quad \\text{whose (чей — принадлежность)}, \\quad \\text{where (место)}',
        description: 'Служат для соединения главного и придаточного определительного предложений',
      ),
      FormulaItem(
        title: 'Adjectives with -ed vs -ing',
        formula: '-ed \\implies \\text{чувство/состояние человека}; \\quad -ing \\implies \\text{свойство предмета/ситуации}',
        description: 'I am bored (Мне скучно) vs The movie is boring (Фильм скучный)',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Relative Clause',
        definition: 'Придаточное определительное предложение, уточняющее информацию о существительном из главного предложения.',
      ),
    ],
    rules: [
      'Who / that относится к людям: "The boy who lives next door is very friendly".',
      'Which / that относится к предметам и животным: "The book which I read was exciting".',
      'Whose выражает принадлежность (чей, чья, чьи): "That is the girl whose dog won the contest".',
      'Причастия на -ed описывают, что человек чувствует (interested, tired, amazed); причастия на -ing описывают источник этого чувства (interesting, tiring, amazing).',
      'Фразовый глагол give: give up (бросить привычку/сдаться), give away (отдать даром/выдать секрет), give back (вернуть владельцу).',
    ],
    lifehacks: [
      'Простое мнемоническое правило: I am tir-ED because the work is tir-ING. Вы чувствуете -ED из-за чего-то -ING.',
    ],
    examples: [
      ExampleItem(
        task: 'Выберите правильное слово: 1) She was (shocked / shocking) by the news. 2) The teacher (who / which) teaches math is very kind.',
        steps: [
          '1) Она испытала потрясение (её чувство) -> shocked.',
          '2) Подлежащее — teacher (человек) -> относительное местоимение who.',
        ],
        answer: '1) shocked; 2) who',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 3',
      'relative pronouns',
      'who',
      'which',
      '-ed/-ing adjectives',
      'give',
    ],
  ),

  Topic(
    id: 'eng_7_mod04',
    title: 'Module 4. In the news (Новости и СМИ. Прошедшее длительное время)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Media, newspapers, TV programmes, interviews and natural disasters; Grammar: Past Continuous, Past Continuous vs Past Simple (interrupted actions); Phrasal verb: break (out, into, down, up).',
    formulas: [
      FormulaItem(
        title: 'Past Continuous (Длительное действие в определенный момент в прошлом)',
        formula: '(+) S + was/were + V-ing \\quad (-) S + was/were + not + V-ing \\quad (?) Was/Were + S + V-ing?',
        description: 'was для I/he/she/it; were для you/we/they. Keywords: at 5 pm yesterday, from 3 to 6, while',
      ),
      FormulaItem(
        title: 'Комбинация Past Continuous и Past Simple (Прерванное действие)',
        formula: '\\text{While / As } S + \\text{was/were } V\\text{-ing (длинное фоновое)}, \\quad S + V2 \\text{ (короткое прерывающее)}',
        description: 'While I was doing homework, the telephone rang',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Past Continuous',
        definition: 'Время для выражения процесса действия, протекавшего в точно указанный момент или период времени в прошлом.',
      ),
    ],
    rules: [
      'Если два длительных действия происходили в прошлом одновременно, оба стоят в Past Continuous: "While Mum was cooking, Dad was reading a newspaper".',
      'Короткое единичное действие, прервавшее длительный процесс, выражается в Past Simple союзом when: "I was sleeping when the alarm went off".',
      'Фразовый глагол break: break down (сломаться — о механизме, машине), break into (ворваться со взломом), break out (внезапно начаться — о войне, пожаре, эпидемии).',
    ],
    lifehacks: [
      'После союза WHILE почти всегда следует Continuous (длительное действие: "пока/в то время как..."). После союза WHEN обычно следует Simple (краткий факт: "когда вдруг...").',
    ],
    examples: [
      ExampleItem(
        task: 'Поставьте глаголы в правильную форму: We (walk) in the park when it suddenly (start) to rain.',
        steps: [
          'Прогулка в парке — фоновый длительный процесс в прошлом -> Past Continuous: were walking.',
          'Дождь пошел внезапно и прервал прогулку -> Past Simple: started.',
        ],
        answer: 'were walking, started',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 4',
      'Past Continuous',
      'Past Simple',
      'while',
      'when',
      'break',
    ],
  ),

  Topic(
    id: 'eng_7_mod05',
    title: 'Module 5. What the future holds (Взгляд в будущее. Способы выражения будущего)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Future predictions, high-tech gadgets, computers and robots; Grammar: Future Simple (will), be going to (intentions), Present Continuous for arrangements, Conditionals 0 and 1; Phrasal verb: look (after, for, forward to, up).',
    formulas: [
      FormulaItem(
        title: 'Future Simple (will)',
        formula: '(+) S + will + V1 \\quad (-) S + will not (won\'t) + V1 \\quad (?) Will + S + V1?',
        description: 'Спонтанные решения (on the spot), прогнозы на основе личного мнения (I think, I believe, probably, maybe)',
      ),
      FormulaItem(
        title: 'Конструкция be going to (Намерения и очевидные факты)',
        formula: 'S + am/is/are + going to + V1',
        description: 'Планы, намерения сделать что-то или прогноз на основе очевидных визуальных признаков (Look at the clouds! It\'s going to rain)',
      ),
      FormulaItem(
        title: 'First Conditional (Реальное условие в будущем)',
        formula: '\\text{If / When} + \\text{Present Simple}, \\quad S + \\text{will} + V1',
        description: 'В придаточном условия после If/When время WILL НЕ ИСПОЛЬЗУЕТСЯ!',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'First Conditional (Условные предложения I типа)',
        definition: 'Сложноподчиненные предложения, выражающие реальные, осуществимые условия и их вероятные последствия в будущем.',
      ),
    ],
    rules: [
      'Золотое правило английской грамматики: в придаточных времени и условия (после If, When, As soon as, Before, Until) будущее время ЗАМЕНЯЕТСЯ на Present Simple: "If it rains, we will stay at home" (НЕ "If it will rain").',
      'Фразовый глагол look: look for (искать), look after (присматривать за кем-то), look forward to + V-ing (с нетерпением ждать чего-то), look up (искать слово в словаре/справочнике).',
    ],
    lifehacks: [
      'Запомните: look forward to требует после себя глагола с окончанием -ing или существительного: "I look forward to hearing from you".',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: If she (study) hard, she (pass) all her exams successfully.',
        steps: [
          'Это условное предложение 1 типа (First Conditional).',
          'После If ставим Present Simple (she -> studies).',
          'В главной части ставим Future Simple: will pass.',
        ],
        answer: 'studies, will pass',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 5',
      'Future Simple',
      'going to',
      'First Conditional',
      'look',
    ],
  ),

  Topic(
    id: 'eng_7_mod06',
    title: 'Module 6. Having fun (Развлечения и отдых. Настоящее совершенное время)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Theme parks, teenage camps, extreme sports and holiday activities; Grammar: Present Perfect (have/has + V3), time markers (just, already, yet, ever, never, since, for); Phrasal verb: come (across, back, out, round).',
    formulas: [
      FormulaItem(
        title: 'Present Perfect (Связь прошлого действия с настоящим результатом)',
        formula: '(+) S + have/has + V3/ed \\quad (-) S + have/has + not + V3/ed \\quad (?) Have/Has + S + V3/ed?',
        description: 'have (I/you/we/they), has (he/she/it). Маркеры: just, already, yet, ever, never, since, for',
      ),
      FormulaItem(
        title: 'Разница предлогов since и for',
        formula: '\\text{since + начальная точка во времени (since 2015, since Monday)}; \\quad \\text{for + период длительности (for 3 years, for 2 hours)}',
        description: 'Ответы на вопросы "с каких пор?" (since) и "как долго?" (for)',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Present Perfect',
        definition: 'Настоящее совершенное время, обозначающее действие, совершенное в прошлом, но имеющее непосредственный результат или важность в настоящем моменте.',
      ),
    ],
    rules: [
      'Already (уже) и just (только что) ставятся между have/has и 3-й формой глагола в утверждениях: "I have already seen this film".',
      'Yet (еще не / уже?) ставится в САМЫЙ КОНЕЦ отрицательных и вопросительных предложений: "Has he arrived yet? — He hasn\'t called yet".',
      'Ever (когда-либо) используется в вопросах о жизненном опыте: "Have you ever been to London?".',
      'Фразовый глагол come: come across (случайно наткнуться), come back (вернуться), come out (выйти в свет — о книге/фильме), come round (зайти в гости).',
    ],
    lifehacks: [
      'Если в предложении указано конкретное прошедшее время (yesterday, in 2020, 5 minutes ago, when I was 10) — ВСЕГДА используется Past Simple, а НЕ Present Perfect!',
      'Have been to (побывал и вернулся) vs Have gone to (уехал и еще не вернулся).',
    ],
    examples: [
      ExampleItem(
        task: 'Выберите правильный маркер времени: 1) I haven\'t finished my project (already / yet). 2) She has lived in this town (since / for) ten years.',
        steps: [
          '1) В конце отрицательного предложения ставится yet.',
          '2) "Ten years" — период времени (продолжительность) -> ставится предлог for.',
        ],
        answer: '1) yet; 2) for',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 6',
      'Present Perfect',
      'since',
      'for',
      'already',
      'yet',
      'come',
    ],
  ),

  Topic(
    id: 'eng_7_mod07',
    title: 'Module 7. In the spotlight (В центре внимания. Степени сравнения прилагательных)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Cinema, movie genres, famous actors, music styles and charts; Grammar: Degrees of comparison of adjectives and adverbs (Comparative and Superlative), as...as, not so...as, much + comparative; Phrasal verb: turn (into, on, off, down).',
    formulas: [
      FormulaItem(
        title: 'Степени сравнения коротких (1-2 слога) прилагательных',
        formula: '\\text{Положительная: } tall \\quad \\implies \\quad \\text{Сравнительная: } tall\\mathbf{er} \\quad \\implies \\quad \\text{Превосходная: the } tall\\mathbf{est}',
        description: 'big -> bigger -> the biggest (удвоение); easy -> easier -> the easiest (y -> i)',
      ),
      FormulaItem(
        title: 'Степени сравнения длинных (3+ слогов) прилагательных',
        formula: 'beautiful \\quad \\implies \\quad \\mathbf{more} \\text{ beautiful} \\quad \\implies \\quad \\mathbf{the\\ most} \\text{ beautiful}',
        description: 'interesting -> more interesting -> the most interesting',
      ),
      FormulaItem(
        title: 'Исключения степеней сравнения',
        formula: 'good \\to better \\to the best; \\quad bad \\to worse \\to the worst; \\quad far \\to farther/further \\to the farthest/furthest',
        description: 'little -> less -> the least; many/much -> more -> the most',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Сравнительная степень (Comparative)',
        definition: 'Форма прилагательного для сопоставления двух предметов или людей (обычно используется с союзом than — "чем").',
      ),
      DefinitionItem(
        term: 'Превосходная степень (Superlative)',
        definition: 'Форма прилагательного, выделяющая предмет с наивысшей степенью качества среди трех и более (всегда с артиклем the).',
      ),
    ],
    rules: [
      'Конструкция `as ... as` ("такой же ... как") используется при равенстве признаков: "He is as tall as his father".',
      'Конструкция `not as/so ... as` ("не такой ... как"): "Comedies are not as serious as dramas".',
      'Для усиления сравнительной степени используются слова much / far / a lot: "This car is much faster than that one".',
      'Фразовый глагол turn down: уменьшить громкость / отклонить предложение; turn up: прибавить звук / появиться.',
    ],
    lifehacks: [
      'Перед превосходной степенью ВСЕГДА ставится определенный артикль THE: the best, the most popular, the tallest.',
    ],
    examples: [
      ExampleItem(
        task: 'Раскройте скобки: This thriller is (interesting) and (good) than the comedy we watched yesterday.',
        steps: [
          'Слово than указывает на сравнительную степень (Comparative).',
          'Interesting — длинное прилагательное -> more interesting.',
          'Good — исключение, вторая форма -> better.',
        ],
        answer: 'more interesting, better',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 7',
      'comparative',
      'superlative',
      'adjectives',
      'as as',
      'good better best',
    ],
  ),

  Topic(
    id: 'eng_7_mod08',
    title: 'Module 8. Green issues (Экология. Настоящее длительное совершенное время)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Environmental problems, pollution, endangered animals, eco-helpers and recycling; Grammar: Present Perfect Continuous, Question Tags (Разделительные вопросы); Phrasal verb: make (out, up, up with).',
    formulas: [
      FormulaItem(
        title: 'Present Perfect Continuous (Действие началось в прошлом и длится до сих пор)',
        formula: '(+) S + have/has + been + V-ing \\quad (-) S + have/has + not + been + V-ing \\quad (?) Have/Has + S + been + V-ing?',
        description: 'Акцент на длительности процесса. Вопрос: How long have you been...? Маркеры: for, since, all morning',
      ),
      FormulaItem(
        title: 'Question Tags (Разделительные вопросы с «хвостиком»)',
        formula: '(+) \\text{Утверждение}, \\quad (-) \\text{вспомогательный глагол + not + местоимение}? \\\\ (-) \\text{Отрицание}, \\quad (+) \\text{вспомогательный глагол + местоимение}?',
        description: 'You like dogs, don\'t you? / She isn\'t sleeping, is she?',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Present Perfect Continuous',
        definition: 'Время для выражения длительного действия, которое началось в прошлом, продолжалось в течение некоторого периода и либо все еще продолжается, либо только что завершилось с очевидным результатом.',
      ),
      DefinitionItem(
        term: 'Question Tag',
        definition: 'Краткий переспрос в конце предложения, эквивалентный русскому "не правда ли?", "не так ли?".',
      ),
    ],
    rules: [
      'Правило разделительного вопроса: если первая часть утвердительная (+), то хвостик отрицательный (-); если первая часть отрицательная (-), то хвостик утвердительный (+).',
      'Особые случаи: I am right, aren\'t I? / Let\'s go, shall we? / Don\'t be late, will you?',
      'Фразовый глагол make: make out (разобрать, с трудом увидеть или понять), make up (придумать историю/помириться), make up for (компенсировать).',
    ],
    lifehacks: [
      'В Present Perfect Continuous глагол обязательно имеет ТРИ элемента: have/has + been + V-ing. Не теряйте been!',
    ],
    examples: [
      ExampleItem(
        task: 'Добавьте правильный "хвостик" к предложению: 1) You haven\'t seen my keys, ...? 2) He works at the hospital, ...?',
        steps: [
          '1) Первая часть отрицательная с глаголом have: "haven\'t seen" -> хвостик утвердительный: "have you?".',
          '2) Первая часть утвердительная в Present Simple: "works" -> вспомогательный глагол does -> отрицательный хвостик: "doesn\'t he?".',
        ],
        answer: '1) have you?; 2) doesn\'t he?',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 8',
      'Present Perfect Continuous',
      'Question Tags',
      'make',
      'ecology',
    ],
  ),

  Topic(
    id: 'eng_7_mod09',
    title: 'Module 9. Shopping time (Покупки и питание. Модальные глаголы)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Food and drinks, supermarkets, packaging, clothes shopping, gifts; Grammar: Quantifiers (much, many, a lot of, a few, a little), Modal verbs of obligation and permission (must, have to, should, can, may); Phrasal verb: take (off, back, away, out).',
    formulas: [
      FormulaItem(
        title: 'Quantifiers (Исчисляемые vs Неисчисляемые существительные)',
        formula: '\\text{Countable (яблоки, книги): } \\mathbf{many}, \\quad \\mathbf{a\\ few} \\text{ (немного, но достаточно)}, \\quad \\mathbf{few} \\text{ (очень мало, не хватает)}',
        description: 'Uncountable (вода, сахар, время): much, a little (немного, достаточно), little (очень мало, мало)',
      ),
      FormulaItem(
        title: 'Modal verbs: must vs have to vs should',
        formula: 'must \\text{ (личное убеждение / строгий запрет mustn\'t)}; \\quad have to \\text{ (внешние правила/обстоятельства)}; \\quad should \\text{ (совет)}',
        description: 'После модальных глаголов используется голый инфинитив V1 без частицы to (кроме have to)',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Исчисляемые существительные (Countable)',
        definition: 'Предметы, которые можно пересчитать поштучно (an apple — three apples).',
      ),
      DefinitionItem(
        term: 'Неисчисляемые существительные (Uncountable)',
        definition: 'Вещества, жидкости, понятия, которые нельзя посчитать без единиц измерения (water, milk, money, advice, information).',
      ),
    ],
    rules: [
      'A lot of используется в утверждениях как с исчисляемыми, так и с неисчисляемыми существительными.',
      'Much и many чаще используются в отрицаниях и вопросах: "How much money do you have? — I don\'t have many friends here".',
      'Mustn\'t выражает строжайший запрет ("нельзя!"), а Don\'t have to выражает отсутствие необходимости ("не обязательно, нет нужды"): "You don\'t have to pay — it\'s free".',
      'Фразовый глагол take: take off (снять одежду / взлететь — о самолете), take back (вернуть в магазин), take away (забрать навынос).',
    ],
    lifehacks: [
      'Money, advice, news, information, furniture в английском языке ВСЕГДА неисчисляемые в единственном числе: "The news IS good", "little money".',
    ],
    examples: [
      ExampleItem(
        task: 'Вставьте a few или a little: 1) I have got ... milk left in the fridge. 2) There are ... apples on the table.',
        steps: [
          '1) Milk — неисчисляемое вещество -> a little.',
          '2) Apples — исчисляемые во множественном числе -> a few.',
        ],
        answer: '1) a little; 2) a few',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 9',
      'quantifiers',
      'much many',
      'a few a little',
      'modal verbs',
      'take',
    ],
  ),

  Topic(
    id: 'eng_7_mod10',
    title: 'Module 10. Healthy body, healthy mind (Здоровье и спорт. Возвратные местоимения)',
    subjectId: 'english',
    grade: 7,
    shortSummary: 'Health, common illnesses, accidents and injuries, healthy lifestyle and fitness; Grammar: Modal verbs for advice (should / shouldn\'t), Reflexive pronouns (myself, yourself, himself...); Phrasal verb: fall (down, off, out with).',
    formulas: [
      FormulaItem(
        title: 'Reflexive Pronouns (Возвратные местоимения)',
        formula: 'I \\to myself, \\quad you \\to yourself / yourselves, \\quad he \\to himself, \\quad she \\to herself, \\quad it \\to itself, \\quad we \\to ourselves, \\quad they \\to themselves',
        description: 'Используются, когда действие субъекта направлено на самого себя (-ся / -сь)',
      ),
      FormulaItem(
        title: 'Дача советов: should / shouldn\'t',
        formula: '(+) S + should + V1 \\text{ (тебе следует)} \\quad (-) S + should\\ not + V1 \\text{ (тебе не следует)}',
        description: 'You should see a doctor. You shouldn\'t eat so much junk food.',
      ),
    ],
    definitions: [
      DefinitionItem(
        term: 'Reflexive Pronoun',
        definition: 'Возвратное местоимение, оканчивающееся на -self (ед. ч.) или -selves (мн. ч.), указывающее, что подлежащее и дополнение обозначают одно и то же лицо.',
      ),
    ],
    rules: [
      'Конструкция `by oneself` означает "в одиночку / самостоятельно": "He did his homework by himself".',
      'Глаголы feel, relax, wash, dress, shave в английском языке обычно употребляются БЕЗ возвратных местоимений (в отличие от русского "чувствовать себя", "одеваться"): "I feel well" (НЕ "I feel myself well").',
      'Фразовый глагол fall: fall off (упасть с чего-то — с велосипеда, лошади), fall down (упасть на землю), fall out with (поссориться с кем-то).',
    ],
    lifehacks: [
      'Будьте осторожны с фразой "I feel myself" — в английском языке она звучит очень странно и двусмысленно! Правильно говорить просто: "I feel good" или "I feel sick".',
    ],
    examples: [
      ExampleItem(
        task: 'Вставьте подходящее возвратное местоимение: 1) Be careful with the knife, you might cut ... . 2) Children, did you paint this picture all by ... ?',
        steps: [
          '1) Подлежащее you (обращение к одному человеку) -> yourself.',
          '2) Подлежащее children (обращение к нескольким детям, множественное число you) -> yourselves.',
        ],
        answer: '1) yourself; 2) yourselves',
      ),
    ],
    tags: [
      'english 7',
      'Spotlight 7',
      'Module 10',
      'health',
      'should',
      'reflexive pronouns',
      'myself',
      'fall',
    ],
  ),

];
