import requests
import json
import json.decoder

url = 'https://kinopoiskapiunofficial.tech/'
command1 = '/api/v2.1/films/'
id = 263531 # для примера начнем с Мстителей

header = {}  # собираем строку авторизации  из файла конфига
with open('conf.py', encoding='utf-8') as f:
    for line in f:
        (key, val) = line.split()
        header[(key)] = val

id_movies = []  # собираем id фильмов

#### gen gsenres
genres_result = []
genres_list = []
for i in range(id, id + 500):
    r = requests.get(url + command1 + f'{i}', headers=header)
    if r.status_code == 200:
        data = (json.loads(r.text)).get('data')
        genres = data.get('genres')
        for g in genres:
            genres_result.append(g.get('genre'))
genres_result = list(set(genres_result))
with open('3_ivi_insert_genres.sql', 'a', encoding='utf-8') as f:
    for num, i in enumerate(genres_result, start=1):
        genres_list.append(tuple([i, num]))
        f.write(f' INSERT INTO genres (genre) VALUES ("{i}");\n')

# done
genres_list = {'': 1, 'фантастика': 2, 'мюзикл': 3, 'военный': 4, 'криминал': 5, 'аниме': 6,
               'комедия': 7, 'мультфильм': 8, 'фэнтези': 9, 'короткометражка': 10, 'вестерн': 11,
               'музыка': 12, 'триллер': 13, 'ужасы': 14, 'драма': 15, 'боевик': 16, 'приключения': 17,
               'документальный': 18, 'мелодрама': 19, 'семейный': 20, 'биография': 21, 'детектив': 22,
               'спорт': 23, 'история': 24
               }

with open('4_ivi_insert_movies.sql','w', encoding='utf-8') as f: # пишем данные о фильмах в файл
    with open('7_ivi_insert_mov_gen.sql', 'w', encoding='utf-8') as f1:
        for i in range (id, id+500):
         try:
            r = requests.get(url + command1 + f'{i}', headers=header)
            if r.status_code == 200:
                data = (json.loads(r.text)).get('data')
                id_movies.append(data.get("filmId"))
                f.write(f' INSERT INTO movies (id, name, original_name, year_of, country, duration, description, poster_id) '
                        f'VALUES ({data.get("filmId")}, "{data.get("nameRu")}", "{data.get("nameEn")}", {data.get("year")}, '
                        f'"{(data.get("countries")[0]).get("country")}", '
                        f'STR_TO_DATE("{(data.get("filmLength") if (data.get("filmLength")) != None else 0)}","%H:%i"), '
                        f'"{data.get("description")}", {data.get("filmId")});\n')
                for g in data.get("genres"):
                    f1.write(
                        f' INSERT INTO movie_genre(movie_id, id) VALUES ({i}, {genres_list.get(g.get("genre"))});\n')
                i+=i
            else:
                i += i
         except IndexError:
             print("IndexError: list index out of range")

all_staff =[]
with open('5_ivi_insert_persons.sql', 'w', encoding='utf-8') as f:
    with open('6_ivi_insert_casting.sql', 'w', encoding='utf-8') as f2:
        for id in id_movies:
            film_staff=[]
            command1 = 'api/v1/staff/?filmId='
            r = requests.get(url + command1 + f'{id}', headers=header)
            a = r.text.strip('[]').replace('},{', '}$!${').split('$!$')
            command1 = 'api/v1/staff/'
            for staff in a:
                item = json.loads(staff)
                staff_id = item.get("staffId")
                film_staff.append(staff_id)
                if staff_id not in all_staff:
                    f.write(f' INSERT INTO persons (id, name, original_name, photo_id, description, status) '
                            f'VALUES ({staff_id},"{item.get("nameRu")}","{item.get("nameEn")}",'
                            f' {staff_id},"{item.get("description")}", "{item.get("professionKey")}"); \n')
                    all_staff.append(item.get("staffId"))
                f2.write(f' INSERT INTO casting (person_id, movie_id) VALUES ({item.get("staffId")},{id});\n')


    command1 = 'api/v1/staff/'
with open('5_1_ivi_insert_persons_facts.sql', 'w', encoding='utf-8') as f3:
    for staff_id in all_staff:
        try:
            r = requests.get(url + command1 + f'{staff_id}', headers=header)
            item = json.loads(r.text)
            facts = item.get("facts")
            for i in facts:
                fact = "".join(i)
            if fact != '':
                f3.write(f' update persons  set biography = "{fact}" where id = {staff_id}; \n')
            fact = ''
        except json.JSONDecodeError as e:
            print(e)


