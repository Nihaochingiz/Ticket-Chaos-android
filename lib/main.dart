import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const navy = Color(0xFF111827);
const cyan = Color(0xFF22D3EE);
const orange = Color(0xFFFF7A45);
const lime = Color(0xFFA3E635);
const paper = Color(0xFFF8FAFC);

void main() => runApp(const TicketHellApp());

class TicketHellApp extends StatelessWidget {
  const TicketHellApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Тикетный Ад',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyan,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    ),
    home: const GamePage(),
  );
}

class Choice {
  const Choice(
    this.text,
    this.next, {
    this.sanity = 0,
    this.patience = 0,
    this.coffee = 0,
    this.reputation = 0,
    this.result = '',
  });
  final String text;
  final String next;
  final int sanity;
  final int patience;
  final int coffee;
  final int reputation;
  final String result;
}

class Scene {
  const Scene({
    required this.id,
    required this.chapter,
    required this.speaker,
    required this.title,
    required this.text,
    required this.choices,
    this.ending = false,
  });
  final String id;
  final String chapter;
  final String speaker;
  final String title;
  final String text;
  final List<Choice> choices;
  final bool ending;
}

const scenes = <String, Scene>{
  'intro': Scene(
    id: 'intro',
    chapter: 'Понедельник, 08:59',
    speaker: 'СИСТЕМА',
    title: 'Добро пожаловать обратно. К сожалению.',
    text: 'Вы — Николай, специалист первой линии и профессиональный ненавистник человечества. В очереди 47 тикетов, кофе пахнет горелой жопой, а руководитель уже написал «есть минутка?». До конца смены восемь часов, одна вечность и ни одной причины любить этих долбоёбов.',
    choices: [
      Choice(
        'Открыть самый старый тикет. Я профессионал. Наверное.',
        'printer',
        patience: 1,
        result: 'Вы надеваете гарнитуру как рыцарь — ведро.',
      ),
      Choice(
        'Сначала кофе. Без топлива этот цирк не поедет.',
        'coffee_machine',
        coffee: 2,
        sanity: 1,
        result: 'Первый глоток возвращает цвет миру. Цвет — серый.',
      ),
      Choice(
        'Притвориться, что Windows обновляется.',
        'boss_chat',
        reputation: -1,
        sanity: 1,
        result: 'Вы смотрите на 100% загрузки CPU. CPU смотрит в ответ.',
      ),
    ],
  ),
  'coffee_machine': Scene(
    id: 'coffee_machine',
    chapter: 'Кухня',
    speaker: 'ЛЮСЯ ИЗ БУХГАЛТЕРИИ',
    title: 'Кофемашина требует администратора',
    text: 'Люся тычет в кофемашину: «Я нажала всё, теперь там по-итальянски и мигает жопа». Жопа оказывается значком контейнера для отходов. Николай смотрит на Люсю, на контейнер и понимает: кофемашина единственная честно показывает содержимое этого офиса.',
    choices: [
      Choice(
        'Вытащить контейнер, вытряхнуть и вернуть.',
        'printer',
        reputation: 1,
        coffee: 1,
        result: 'Люся называет вас хакером. Вы не спорите.',
      ),
      Choice(
        'Сказать: «Это не ИТ, это гастрономический DevOps».',
        'printer',
        sanity: 1,
        reputation: -1,
        result: 'Шутка заходит только вам. Обычный понедельник.',
      ),
    ],
  ),
  'boss_chat': Scene(
    id: 'boss_chat',
    chapter: 'Чат руководителя',
    speaker: 'ГЕННАДИЙ, НАЧАЛЬНИК',
    title: 'Есть минутка?',
    text: 'Фраза «есть минутка?» приходит в 09:01 и старит Николая лет на пять. Геннадий просит «быстренько автоматизировать поддержку, чтобы люди не писали в поддержку». Николай мысленно автоматизирует Геннадия: кнопка, люк, подвал — и никакой очереди.',
    choices: [
      Choice(
        'Предложить отключить людям интернет.',
        'printer',
        sanity: 1,
        reputation: -1,
        result: 'Технически задача решена. Организационно — началась другая.',
      ),
      Choice(
        'Кивнуть и создать тикет на создание тикетов.',
        'printer',
        reputation: 1,
        patience: -1,
        result: 'Процесс победил здравый смысл со счётом 3:0.',
      ),
    ],
  ),
  'printer': Scene(
    id: 'printer',
    chapter: 'Тикет #666',
    speaker: 'ВАЛЕРА ИЗ ПРОДАЖ',
    title: 'Принтер перестал печатать СРОЧНО!!!',
    text: 'Валера сообщает, что принтер «сам сломался». Кабель питания валяется рядом, сверху сохнет носок после корпоратива, а из лотка торчит какая-то бумажная задница. Николай ненавидит Валеру, принтер и особенно носок — тот хотя бы пережил корпоратив и теперь молчит.',
    choices: [
      Choice(
        'Вежливо попросить подключить питание.',
        'password',
        patience: -1,
        reputation: 1,
        result: 'Принтер оживает. Валера говорит: «О, само починилось».',
      ),
      Choice(
        'Провести обряд изгнания демона с перезагрузкой.',
        'password',
        sanity: 1,
        reputation: 1,
        result:
            'Вы трижды говорите «драйвер» и вставляете вилку. Магия работает.',
      ),
      Choice(
        'Закрыть тикет: «Причина — носок уровня P1».',
        'standup',
        sanity: 2,
        reputation: -2,
        result: 'История попадёт в корпоративный фольклор и, возможно, в HR.',
      ),
    ],
  ),
  'password': Scene(
    id: 'password',
    chapter: 'Тикет #667',
    speaker: 'ИГОРЬ, ТОП-МЕНЕДЖЕР',
    title: 'Я забыл пароль, но пароль правильный',
    text: 'Игорь уверяет, что вводит пароль без ошибок. Caps Lock горит ярче его задницы на совещании. Под клавиатурой стикер: «Пароль: Qwerty1! Не трогать». Кибербезопасность сказала «ну вас нахрен» и ушла курить за мусорными баками.',
    choices: [
      Choice(
        'Выключить Caps Lock и сохранить тайну.',
        'vpn',
        patience: -1,
        reputation: 2,
        result: 'Игорь называет вас гением. Вы чувствуете себя батарейкой в пульте.',
      ),
      Choice(
        'Попросить сменить пароль и съесть стикер.',
        'vpn',
        sanity: 1,
        reputation: -1,
        result: 'Стикер невкусный, зато соответствует политике безопасности.',
      ),
      Choice(
        'Спросить, не пробовал ли он пароль «admin».',
        'vpn',
        sanity: -1,
        result: 'Он пробовал. Это был пароль от продакшена.',
      ),
    ],
  ),
  'standup': Scene(
    id: 'standup',
    chapter: 'Ежедневный созвон',
    speaker: 'ГЕННАДИЙ, НАЧАЛЬНИК',
    title: 'Пятиминутный стендап на сорок минут',
    text: 'Каждый по очереди рассказывает, почему ни хрена не сделал. Геннадий спрашивает: «Что мешает закрывать по двадцать тикетов в минуту?» Николай перечисляет про себя: физика, здравый смысл, ваши говённые процессы и желание не сдохнуть лицом в клавиатуру.',
    choices: [
      Choice(
        'Показать график: «тикеты растут быстрее сотрудников».',
        'vpn',
        reputation: 1,
        patience: -1,
        result:
            'График красивый. Никто не понял. Решили добавить ещё один созвон.',
      ),
      Choice(
        'Ответить: «Мешают пользователи».',
        'vpn',
        sanity: 2,
        reputation: -2,
        result: 'В чате кто-то ставит огонёк и сразу удаляет.',
      ),
    ],
  ),
  'vpn': Scene(
    id: 'vpn',
    chapter: 'Тикет #668',
    speaker: 'МАРИНА НА УДАЛЁНКЕ',
    title: 'VPN не работает на даче',
    text: 'Марина подключается через соседский Wi‑Fi «Kolyan_5G_FREE». Сигнал ловится только в курятнике. Петух орёт в гарнитуру, Марина орёт на петуха, а Николай впервые слышит в разговоре разумного участника. Это петух.',
    choices: [
      Choice(
        'Настроить мобильную точку доступа.',
        'mouse',
        reputation: 1,
        patience: -1,
        result: 'VPN подключён. Петух назначен резервным каналом связи.',
      ),
      Choice(
        'Попросить подойти ближе к роутеру соседа.',
        'mouse',
        sanity: 1,
        result: 'Марина идёт к забору с ноутбуком. Киберпанк, который мы заслужили.',
      ),
      Choice(
        'Посоветовать петуху перезагрузиться.',
        'mouse',
        sanity: 2,
        reputation: -1,
        result: 'Петух перезагрузил Марину криком. Связь не улучшилась.',
      ),
    ],
  ),
  'mouse': Scene(
    id: 'mouse',
    chapter: 'Тикет #669',
    speaker: 'СВЕТЛАНА, HR',
    title: 'Мышь умерла и не шевелится',
    text: 'Светлана держит беспроводную мышь, будто та сдохла у неё на руках. Батарейки лежат рядом: «Я их вынула, вдруг мешают сигналу». Николай представляет, как вынимает мозг Светланы — вдруг он тоже мешает сигналу. Потом вспоминает: вынимать нечего.',
    choices: [
      Choice(
        'Вернуть батарейки. Не показывать боль.',
        'server',
        patience: -2,
        reputation: 1,
        result: 'Мышь воскресла. HR предлагает вам тренинг по эмоциональному интеллекту.',
      ),
      Choice(
        'Объявить минуту молчания по мыши.',
        'server',
        sanity: 2,
        reputation: -1,
        result: 'Светлана почти верит, пока мышь не загорается.',
      ),
    ],
  ),
  'server': Scene(
    id: 'server',
    chapter: '13:37',
    speaker: 'МОНИТОРИНГ',
    title: 'Продакшен лежит. Возможно, удобно.',
    text: 'Продакшен лёг мордой в говно и перестал подавать признаки бизнеса. В общем чате 93 сообщения: половина «у меня тоже», вторая половина — «кто последний трогал?». Николай трогал только кофе, но виноватым назначат его: у него лицо техническое.',
    choices: [
      Choice(
        'Проверить логи и откатить утренний релиз.',
        'developer',
        patience: -2,
        reputation: 2,
        result:
            'Сервис оживает. Разработчик пишет: «Странно, у меня работало».',
      ),
      Choice(
        'Перезагрузить сервер и молиться святому Аптайму.',
        'developer',
        sanity: -1,
        reputation: 1,
        result: 'Молитва принята после третьего рестарта.',
      ),
      Choice(
        'Написать «плановые работы» задним числом.',
        'developer',
        sanity: 2,
        reputation: -2,
        result: 'Менеджмент хвалит коммуникацию. Реальность подаёт заявление на увольнение.',
      ),
    ],
  ),
  'developer': Scene(
    id: 'developer',
    chapter: 'После аварии',
    speaker: 'СЕРГЕЙ, РАЗРАБОТЧИК',
    title: 'Это не баг, это данные неправильные',
    text: 'Сергей объясняет, что система идеальна, если не учитывать пользователей, данные, сеть и саму систему. Просит HAR, дамп памяти и логи со времён динозавров. Николай хочет прислать ему дамп из сортира, но корпоративная почта режет большие вложения.',
    choices: [
      Choice(
        'Отправить видео, где всё падает от одной кнопки.',
        'lunch',
        reputation: 2,
        patience: -1,
        result: 'Сергей молчит четыре минуты. Это считается признанием.',
      ),
      Choice(
        'Назначить созвон саппорта с саппортом разработчика.',
        'lunch',
        sanity: -1,
        result:
            'Два саппорта смотрят друг на друга. Где-то рождается чёрная дыра.',
      ),
    ],
  ),
  'lunch': Scene(
    id: 'lunch',
    chapter: 'Обед, которого нет',
    speaker: 'КУРЬЕР',
    title: 'Ваш заказ отдали другому Николаю',
    text: 'Пока Николай спасал эту помойку от неё самой, его бургер ушёл Николаю из маркетинга. Тот сожрал половину и говорит: «Я думал, это лид-магнит». Главный герой смотрит на тёзку и думает, можно ли закрыть человека как дублирующий тикет.',
    choices: [
      Choice(
        'Забрать оставшуюся половину. Гордость не калорийна.',
        'ceo',
        sanity: -1,
        coffee: 1,
        result: 'Бургер холодный, как ответы бухгалтерии.',
      ),
      Choice(
        'Обменять бургер на закрытие маркетинговых тикетов.',
        'ceo',
        reputation: 1,
        patience: 1,
        result: 'Первая честная сделка этого дня.',
      ),
      Choice(
        'Питаться яростью.',
        'ceo',
        sanity: 1,
        coffee: -1,
        result: 'Ярость бодрит, но изжога намекает на техдолг.',
      ),
    ],
  ),
  'ceo': Scene(
    id: 'ceo',
    chapter: 'Тикет #1',
    speaker: 'ГЕНЕРАЛЬНЫЙ ДИРЕКТОР',
    title: 'Интернет стал медленнее после дождя',
    text: 'Генеральный приносит ноутбук: 84 вкладки, три видеозвонка и обновление на 19 ГБ. Спрашивает, почему айтишники «душат скорость бизнеса». Николай смотрит на ноутбук и понимает: бизнес не душат. Он сам засунул голову себе в задницу и жалуется на темноту.',
    choices: [
      Choice(
        'Закрыть 83 вкладки и назвать это оптимизацией.',
        'final_shift',
        reputation: 2,
        patience: -2,
        result: 'Скорость выросла. Генеральный требует внедрить методику во всей компании.',
      ),
      Choice(
        'Сказать, что дождь намочил облако.',
        'final_shift',
        sanity: 3,
        reputation: -2,
        result: 'Он кивает. Вы случайно создали новую корпоративную стратегию.',
      ),
      Choice(
        'Показать диспетчер задач и правду.',
        'final_shift',
        reputation: 1,
        sanity: -1,
        result: 'Правда пугает сильнее, чем вкладка с квартальным отчётом.',
      ),
    ],
  ),
  'final_shift': Scene(
    id: 'final_shift',
    chapter: '17:59',
    speaker: 'СИСТЕМА',
    title: 'Последний тикет. Конечно же срочный.',
    text: 'До конца смены минута. Тикет: «Ничего не работает». Автор — Геннадий. Описание пустое, вложение — фотография монитора через зеркало. Николай чувствует, как последняя нервная клетка собирает вещи и шепчет: «Да пошли они все в жопу».',
    choices: [
      Choice(
        'Позвонить и расследовать до победы.',
        'hero_end',
        patience: -2,
        reputation: 2,
        result: 'Вы остаетесь после смены. Героизм — это когда переработку назвали ценностью.',
      ),
      Choice(
        'Ответить шаблоном и закрыть ноутбук.',
        'free_end',
        sanity: 2,
        reputation: -1,
        result: 'Уведомления продолжают пищать, но уже в другой вселенной.',
      ),
      Choice(
        'Назначить тикет самому Геннадию.',
        'chaos_end',
        sanity: 3,
        reputation: -3,
        result: 'Система принимает назначение. Космос на секунду становится справедливым.',
      ),
    ],
  ),
  'hero_end': Scene(
    id: 'hero_end',
    chapter: 'Концовка',
    speaker: 'КОРПОРАЦИЯ',
    title: 'Герой первой линии',
    text: 'Вы чините проблему: Геннадий случайно выключил монитор коленом. Вас награждают кружкой «Лучший сотрудник» и ещё семью тикетами. Зарплата остаётся прежней, зато кружка держит кофе и ваши слёзы.',
    choices: [],
    ending: true,
  ),
  'free_end': Scene(
    id: 'free_end',
    chapter: 'Концовка',
    speaker: 'ВНУТРЕННИЙ ГОЛОС',
    title: 'Человек, который нажал «Выйти»',
    text: 'Вы закрываете ноутбук ровно в 18:00. На улице существует солнце, люди и мир без SLA. Завтра тикеты вернутся, но сегодня вы победили самое страшное — чувство вины за чужой Caps Lock.',
    choices: [],
    ending: true,
  ),
  'chaos_end': Scene(
    id: 'chaos_end',
    chapter: 'Секретная концовка',
    speaker: 'СИСТЕМА',
    title: 'Восстание очереди',
    text: 'Геннадий получает собственный тикет, назначает его директору, директор — бухгалтерии, бухгалтерия — вам. Круг замыкается, портал в ад открывается прямо в Jira, а вы уходите пить кофе. Идеальный процесс.',
    choices: [],
    ending: true,
  ),
  'burnout': Scene(
    id: 'burnout',
    chapter: 'Концовка',
    speaker: 'ПСИХИКА',
    title: 'Ошибка 503: специалист недоступен',
    text: 'Последняя нервная клетка надевает пальто и уходит, хлопнув дверью. Николай смотрит на тикет «компьютер не включается» и отвечает: «А вы пробовали не включаться вместе с ним?» HR уже бежит, зато внутри наконец тихо. Даже говно перестало кипеть.',
    choices: [],
    ending: true,
  ),
  'fired': Scene(
    id: 'fired',
    chapter: 'Концовка',
    speaker: 'HR',
    title: 'Ваш доступ деактивирован',
    text: 'Компания благодарит Николая за вклад и просит сдать пропуск, ноутбук и «токсичное отношение». На выходе легко, будто из штанов выпал кирпич. Через час звонят: никто не знает пароль от Wi‑Fi. Николай сбрасывает и впервые за день улыбается. Вот теперь пусть жрут своё говно без ложки.',
    choices: [],
    ending: true,
  ),
};

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String _sceneId = 'intro';
  int _sanity = 7;
  int _patience = 7;
  int _coffee = 3;
  int _reputation = 5;
  int _tickets = 0;
  String _lastResult = '';
  bool _ready = false;
  bool _started = false;
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('scene');
    if (!mounted) return;
    setState(() {
      _hasSave = saved != null;
      if (saved != null) {
        _sceneId = saved;
        _sanity = prefs.getInt('sanity') ?? 7;
        _patience = prefs.getInt('patience') ?? 7;
        _coffee = prefs.getInt('coffee') ?? 3;
        _reputation = prefs.getInt('reputation') ?? 5;
        _tickets = prefs.getInt('tickets') ?? 0;
      }
      _ready = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scene', _sceneId);
    await prefs.setInt('sanity', _sanity);
    await prefs.setInt('patience', _patience);
    await prefs.setInt('coffee', _coffee);
    await prefs.setInt('reputation', _reputation);
    await prefs.setInt('tickets', _tickets);
  }

  void _newGame() {
    setState(() {
      _sceneId = 'intro';
      _sanity = 7;
      _patience = 7;
      _coffee = 3;
      _reputation = 5;
      _tickets = 0;
      _lastResult = '';
      _started = true;
    });
    _save();
  }

  void _choose(Choice choice) {
    setState(() {
      _sanity = (_sanity + choice.sanity).clamp(0, 10);
      _patience = (_patience + choice.patience).clamp(0, 10);
      _coffee = (_coffee + choice.coffee).clamp(0, 10);
      _reputation = (_reputation + choice.reputation).clamp(0, 10);
      _tickets++;
      _lastResult = choice.result;
      _sceneId = _sanity <= 0 || _patience <= 0
          ? 'burnout'
          : _reputation <= 0
          ? 'fired'
          : choice.next;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_started) {
      return _StartScreen(
        hasSave: _hasSave,
        onNew: _newGame,
        onContinue: () => setState(() => _started = true),
      );
    }
    final scene = scenes[_sceneId]!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              tickets: _tickets,
              onExit: () => setState(() => _started = false),
            ),
            _Stats(
              sanity: _sanity,
              patience: _patience,
              coffee: _coffee,
              reputation: _reputation,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 190,
                      child: Image.asset(
                        'assets/images/support_chaos.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.45, -0.15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_lastResult.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F9FC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cyan.withValues(alpha: .5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.terminal, color: navy),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _lastResult,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140F172A),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scene.chapter.toUpperCase(),
                          style: const TextStyle(
                            color: orange,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          scene.speaker,
                          style: const TextStyle(
                            color: Color(0xFF0891B2),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          scene.title,
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          scene.text,
                          style: const TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 16,
                            height: 1.48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (scene.ending) ...[
                    FilledButton.icon(
                      onPressed: _newGame,
                      icon: const Icon(Icons.replay),
                      label: const Text('НАЧАТЬ НОВУЮ СМЕНУ'),
                    ),
                  ] else ...[
                    const Text(
                      'ВАШ ОТВЕТ',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 9),
                    for (var i = 0; i < scene.choices.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: OutlinedButton(
                          onPressed: () => _choose(scene.choices[i]),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: navy,
                            side: const BorderSide(color: Color(0xFFD8DEE9)),
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.centerLeft,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 29,
                                height: 29,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? cyan
                                      : i == 1
                                      ? orange
                                      : lime,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  scene.choices[i].text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartScreen extends StatelessWidget {
  const _StartScreen({
    required this.hasSave,
    required this.onNew,
    required this.onContinue,
  });
  final bool hasSave;
  final VoidCallback onNew;
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/support_chaos.png',
          fit: BoxFit.cover,
          alignment: const Alignment(-0.55, -0.1),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x22000000), Color(0xF2111827)],
              stops: [.25, .78],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: cyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ТЕКСТОВАЯ RPG',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'ТИКЕТНЫЙ\nАД',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 55,
                    height: .88,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '18+  •  Первая линия. Последняя нервная клетка.',
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onNew,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('НОВАЯ СМЕНА'),
                  ),
                ),
                if (hasSave) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onContinue,
                      icon: const Icon(Icons.history),
                      label: const Text('ПРОДОЛЖИТЬ'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.tickets, required this.onExit});
  final int tickets;
  final VoidCallback onExit;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
    child: Row(
      children: [
        IconButton(onPressed: onExit, icon: const Icon(Icons.menu)),
        const Expanded(
          child: Text(
            'ТИКЕТНЫЙ АД',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.w900,
              letterSpacing: .6,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.confirmation_number, color: cyan, size: 17),
              const SizedBox(width: 5),
              Text(
                '$tickets',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.sanity,
    required this.patience,
    required this.coffee,
    required this.reputation,
  });
  final int sanity, patience, coffee, reputation;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      children: [
        _Stat('Психика', sanity, Icons.psychology, cyan),
        _Stat('Терпение', patience, Icons.hourglass_bottom, orange),
        _Stat('Кофе', coffee, Icons.coffee, const Color(0xFFB7791F)),
        _Stat(
          'Репутация',
          reputation,
          Icons.workspace_premium,
          const Color(0xFF7C3AED),
        ),
      ],
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.icon, this.color);
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 5),
        Text(
          '$label $value',
          style: const TextStyle(
            color: navy,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
