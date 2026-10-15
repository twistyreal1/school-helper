import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import 'algebra_topics.dart';
import 'geometry_topics.dart';
import 'physics_topics.dart';
import 'russian_topics.dart';
import 'biology_topics.dart';
import 'literature_topics.dart';
import 'history_topics.dart';
import 'geography_topics.dart';
import 'informatics_topics.dart';

class MockDatabase {
  static const List<Subject> subjects = [
    Subject(
      id: 'algebra',
      name: 'Алгебра',
      icon: Icons.functions_rounded,
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF60A5FA),
      description: 'Уравнения, корни, степени, формулы и графики',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'geometry',
      name: 'Геометрия',
      icon: Icons.category_rounded,
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFFA78BFA),
      description: 'Фигуры, площади, теоремы, подобие и окружность',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'physics',
      name: 'Физика',
      icon: Icons.bolt_rounded,
      primaryColor: Color(0xFFF59E0B),
      secondaryColor: Color(0xFFFBBF24),
      description: 'Теплота, электричество, оптика, магнетизм',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'chemistry',
      name: 'Химия',
      icon: Icons.science_rounded,
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFFF472B6),
      description: 'Вещества, реакции, таблица Менделеева, моль',
      grades: [8, 9, 10, 11],
    ),
    Subject(
      id: 'russian',
      name: 'Русский язык',
      icon: Icons.menu_book_rounded,
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF34D399),
      description: 'Синтаксис, пунктуация, обороты, правила',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'literature',
      name: 'Литература',
      icon: Icons.auto_stories_rounded,
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFFB7185),
      description: 'Анализ произведений, сюжеты, герои, цитаты и сочинения',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'biology',
      name: 'Биология',
      icon: Icons.eco_rounded,
      primaryColor: Color(0xFF14B8A6),
      secondaryColor: Color(0xFF2DD4BF),
      description: 'Зоология: строение животных, систематика, поведение, эволюция',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'geography',
      name: 'География',
      icon: Icons.public_rounded,
      primaryColor: Color(0xFF06B6D4),
      secondaryColor: Color(0xFF67E8F9),
      description: 'Природа и население России: рельеф, климат, реки, зоны (§ 1–56)',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'history',
      name: 'История',
      icon: Icons.account_balance_rounded,
      primaryColor: Color(0xFFEA580C),
      secondaryColor: Color(0xFFFB923C),
      description: 'Всеобщая история: Новое время XVIII — начало XIX в. (§ 1–29)',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'informatics',
      name: 'Информатика',
      icon: Icons.terminal_rounded,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF818CF8),
      description: 'Системы счисления, алгебра логики, алгоритмы, Паскаль, Python (§ 1–5.5)',
      grades: [7, 8, 9, 10, 11],
    ),
  ];

  static const List<Topic> topics = [
    // =========================================================================
    // 8 КЛАСС: АЛГЕБРА (по учебнику Ю.Н. Макарычева и др.)
    // =========================================================================
    ...algebraTopics8,

    // =========================================================================
    // 8 КЛАСС: ГЕОМЕТРИЯ (по учебнику Л.С. Атанасяна и др. 2024 г.)
    // =========================================================================
    ...geometryTopics8,

    // =========================================================================
    // 8 КЛАСС: ФИЗИКА (по учебнику И.М. Пёрышкина 2026 г.)
    // =========================================================================
    ...physicsTopics8,

    // =========================================================================
    // 8 КЛАСС: ХИМИЯ
    // =========================================================================
    Topic(
      id: 'chem_8_basic_concepts',
      title: 'Вещества, смеси и химические явления',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Физические и химические явления. Закон сохранения массы веществ (М.В. Ломоносов).',
      definitions: [
        DefinitionItem(
          term: 'Физические явления',
          definition: 'Явления, при которых состав вещества не меняется (таяние льда, испарение воды, измельчение сахара).',
        ),
        DefinitionItem(
          term: 'Химические явления (реакции)',
          definition: 'Явления, при которых из одних веществ образуются другие. Признаки: выпадение осадка, выделение газа, изменение цвета, выделение тепла/света.',
        ),
      ],
      rules: [
        'Закон сохранения массы: Масса веществ, вступивших в реакцию, равна массе образовавшихся веществ.',
      ],
      tags: ['вещества', 'смеси', 'химические явления', 'химия 8'],
    ),
    Topic(
      id: 'chem_8_valence',
      title: 'Валентность и составление формул',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Способность атома образовывать определенное число химических связей. Водород всегда I, кислород всегда II.',
      rules: [
        'Постоянная валентность: I (H, Na, K, Li), II (O, Ca, Mg, Ba, Zn), III (Al).',
        'Алгоритм составления формулы: Находим НОК валентностей элементов и делим НОК на валентность каждого элемента.',
      ],
      example: ExampleItem(
        task: 'Составить формулу оксида алюминия',
        steps: [
          '1. Валентность Al равна III, валентность O равна II: Al^(III) O^(II).',
          '2. Находим НОК(3, 2) = 6.',
          '3. Индекс Al: 6 / 3 = 2. Индекс O: 6 / 2 = 3.',
        ],
        answer: 'Ответ: Al₂O₃',
      ),
      tags: ['валентность', 'индексы', 'формулы веществ'],
    ),
    Topic(
      id: 'chem_8_reaction_types',
      title: 'Типы химических реакций',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: '4 главных типа химических реакций: соединение, разложение, замещение и обмен.',
      definitions: [
        DefinitionItem(term: 'Соединение', definition: 'Из нескольких веществ образуется одно сложное: A + B = AB (например, 2H₂ + O₂ = 2H₂O).'),
        DefinitionItem(term: 'Разложение', definition: 'Из одного сложного образуется несколько: AB = A + B (например, 2H₂O = 2H₂ + O₂).'),
        DefinitionItem(term: 'Замещение', definition: 'Простое вещество замещает атом в сложном: A + BC = AC + B (например, Zn + 2HCl = ZnCl₂ + H₂↑).'),
        DefinitionItem(term: 'Обмен', definition: 'Два сложных вещества обмениваются составными частями: AB + CD = AD + CB (например, NaOH + HCl = NaCl + H₂O).'),
      ],
      tags: ['типы реакций', 'соединение', 'разложение', 'замещение', 'обмен'],
    ),
    Topic(
      id: 'chem_8_mole',
      title: 'Количество вещества: моль, масса и объем газа',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Фундаментальные расчетные формулы химии: n = m/M, n = V/Vm, N = n · Na.',
      formulas: [
        FormulaItem(title: 'Количество вещества через массу', formula: 'n = m / M  (моль = г / (г/моль))'),
        FormulaItem(title: 'Количество вещества через объем газа', formula: 'n = V / V_m  (V_m = 22.4 л/моль при н.у.)'),
        FormulaItem(title: 'Число частиц через число Авогадро', formula: 'N = n · N_A  (N_A = 6.02 · 10²³ моль⁻¹)'),
      ],
      tags: ['моль', 'авогадро', 'молярная масса', 'объем газа'],
    ),
    Topic(
      id: 'chem_8_periodic_law',
      title: 'Периодический закон и строение атома',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Атом состоит из ядра (протоны p⁺, нейтроны n⁰) и электронной оболочки (электроны e⁻).',
      formulas: [
        FormulaItem(title: 'Состав атома', formula: 'Число протонов = Число электронов = Порядковый номер Z\nЧисло нейтронов N = A - Z (где A — атомная масса)'),
      ],
      rules: [
        'Номер периода = число электронных слоев (энергетических уровней).',
        'Номер группы (для главных подгрупп) = число валентных электронов на внешнем слое.',
        'Слева направо по периоду: неметаллические свойства усиливаются, радиус атома уменьшается.',
        'Сверху вниз по группе: металлические свойства усиливаются, радиус атома увеличивается.',
      ],
      tags: ['менделеев', 'атом', 'периодический закон', 'электроны'],
    ),
    Topic(
      id: 'chem_8_classes',
      title: 'Основные классы неорганических веществ',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Оксиды, основания (гидроксиды), кислоты и соли: классификация, свойства и индикаторы.',
      formulas: [
        FormulaItem(title: 'Оксиды', formula: 'ЭₓOᵧ (основные: Na₂O, CuO; кислотные: CO₂, SO₃; амфотерные: Al₂O₃, ZnO)'),
        FormulaItem(title: 'Основания', formula: 'Me(OH)ₙ (щелочи: NaOH, KOH, Ba(OH)₂; нерастворимые: Cu(OH)₂, Fe(OH)₃)'),
        FormulaItem(title: 'Кислоты', formula: 'Hₙ(кислотный остаток) (HCl, H₂SO₄, HNO₃, H₃PO₄)'),
        FormulaItem(title: 'Соли', formula: 'Meₓ(кислотный остаток)ᵧ (NaCl, CaCO₃, FeSO₄)'),
        FormulaItem(title: 'Нейтрализация', formula: 'Кислота + Основание = Соль + H₂O'),
      ],
      rules: [
        'Индикатор фенолфталеин малиновый ТОЛЬКО в щелочах!',
        'Лакмус: в кислоте красный, в щелочи синий, в воде фиолетовый.',
      ],
      tags: ['оксиды', 'кислоты', 'основания', 'соли', 'индикаторы'],
    ),
    Topic(
      id: 'chem_8_solutions',
      title: 'Растворы и массовая доля растворенного вещества',
      subjectId: 'chemistry',
      grade: 8,
      shortSummary: 'Расчет концентрации растворов: ω = (m_вещества / m_раствора) · 100%.',
      formulas: [
        FormulaItem(
          title: 'Массовая доля вещества',
          formula: 'ω = (m_в-ва / m_р-ра) · 100%\nm_раствора = m_в-ва + m_воды',
        ),
      ],
      tags: ['растворы', 'массовая доля', 'концентрация'],
    ),

    // =========================================================================
    // 8 КЛАСС: РУССКИЙ ЯЗЫК (по учебнику С.Г. Бархударова и др.)
    // =========================================================================
    ...russianTopics8,

    // =========================================================================
    // 8 КЛАСС: БИОЛОГИЯ (по учебнику В.В. Пасечника, Зоология, § 1–60)
    // =========================================================================
    ...biologyTopics8,

    // =========================================================================
    // 8 КЛАСС: ЛИТЕРАТУРА (по учебнику В.Я. Коровиной, Часть 1)
    // =========================================================================
    ...literatureTopics8,

    // =========================================================================
    // 8 КЛАСС: ГЕОГРАФИЯ (по учебнику А.И. Алексеева и др. «Полярная звезда»)
    // =========================================================================
    ...geographyTopics8,

    // =========================================================================
    // 8 КЛАСС: ВСЕОБЩАЯ ИСТОРИЯ (по учебнику В.Р. Мединского, А.О. Чубарьяна)
    // =========================================================================
    ...historyTopics8,

    // =========================================================================
    // 8 КЛАСС: ИНФОРМАТИКА (по учебнику Л.Л. Босовой, А.Ю. Босовой ФГОС)
    // =========================================================================
    ...informaticsTopics8,
  ];

  static List<Topic> getTopicsForGradeAndSubject(int grade, String subjectId) {
    return topics.where((t) => t.grade == grade && t.subjectId == subjectId).toList();
  }

  static List<Topic> searchTopics(String query, {int? grade}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    return topics.where((t) {
      if (grade != null && t.grade != grade) return false;
      final inTitle = t.title.toLowerCase().contains(q);
      final inSummary = t.shortSummary.toLowerCase().contains(q);
      final inTags = t.tags.any((tag) => tag.toLowerCase().contains(q));
      final inFormulas = t.formulas.any((f) =>
          f.title.toLowerCase().contains(q) || f.formula.toLowerCase().contains(q));
      final inDefs = t.definitions.any((d) =>
          d.term.toLowerCase().contains(q) || d.definition.toLowerCase().contains(q));
      final inRules = t.rules.any((r) => r.toLowerCase().contains(q));
      final inLifehacks = t.lifehacks.any((lh) => lh.toLowerCase().contains(q));
      final inExamples = t.allExamples.any((e) =>
          e.task.toLowerCase().contains(q) ||
          e.steps.any((s) => s.toLowerCase().contains(q)) ||
          e.answer.toLowerCase().contains(q));
      return inTitle || inSummary || inTags || inFormulas || inDefs || inRules || inLifehacks || inExamples;
    }).toList();
  }
}
