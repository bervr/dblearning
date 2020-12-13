import requests
import json

url = 'https://kinopoiskapiunofficial.tech/'
command1 = '/api/v2.1/films/'
id = 263531
header = {'x-api-key': '239d638c-4c96-46a0-8447-47215bc55da7'}  # починить потом
id_movies = []  # собираем id фильмов

# #### gen gsenres
# genres_result = []
# genres_list = []
# for i in range(id, id + 500):
#     r = requests.get(url + command1 + f'{i}', headers=header)
#     if r.status_code == 200:
#         data = (json.loads(r.text)).get('data')
#         genres = data.get('genres')
#         for g in genres:
#             genres_result.append(g.get('genre'))
# genres_result = list(set(genres_result))
# with open('3_ivi_insert_genres.sql', 'a', encoding='utf-8') as f:
#     for num, i in enumerate(genres_result, start=1):
#         # # print(tuple([num, i]))
#         genres_list.append(tuple([i, num]))
#         # f.write(f' INSERT INTO genres (genre) VALUES ("{i}");\n')
# # print(dict(genres_list))
# # done
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
                            f'{(data.get("countries")[0]).get("country")}, STR_TO_DATE({data.get("filmLength")},"%H:%i"), '
                            f'"{data.get("description")}", {data.get("filmId")});\n')
                    for g in data.get("genres"):
                        f1.write(
                            f' INSERT INTO movie_genre(id, movie_id) VALUES ({i}, {genres_list.get(g.get("genre"))});\n')
                    i+=i
                else:
                    i += i
             except IndexError:
                 print("IndexError: list index out of range")
# # print(id_movies)
#
# #
# with open('5_ivi_insert_persons.sql', 'w', encoding='utf-8') as f:
#     with open('6_ivi_insert_casting.sql', 'w', encoding='utf-8') as f2:
#         for id in id_movies:
#             film_staff=[]
#             command1 = 'api/v1/staff/?filmId='
#             r = requests.get(url + command1 + f'{id}', headers=header)
#             # print(r.status_code)
#             # data=(json.loads(r.text)).get('data')
#             a = r.text.strip('[]').replace('},{', '}$!${').split('$!$')
#             # print(len(a))
#             for staff in a:
#                 item = json.loads(staff)
#                 film_staff.append(item.get("staffId"))
#                 # if item.get('professionKey')=='ACTOR' or item.get('professionKey') =='DIRECTOR':
#                 f.write(f' INSERT INTO persons (id, name, original_name, photo_id, description, biography, status) '
#                         f'VALUES ({item.get("staffId")},"{item.get("nameRu")}","{item.get("nameEn")}",'
#                         f' {item.get("staffId")},"{item.get("description")}",{item.get("professionKey")},'
#                         f'{item.get("professionKey")}; \n')
#                 f2.write(f' INSERT INTO casting (person_id, movie_id) VALUES ({item.get("staffId")},"{id}");\n')

# #### gen gsenres
# genres_result = []
# genres_list = []
# for i in range(id, id + 500):
#     r = requests.get(url + command1 + f'{i}', headers=header)
#     if r.status_code == 200:
#         data = (json.loads(r.text)).get('data')
#         genres = data.get('genres')
#         for g in genres:
#             genres_result.append(g.get('genre'))
# genres_result = list(set(genres_result))
# with open('3_ivi_insert_genres.sql', 'a', encoding='utf-8') as f:
#     for num, i in enumerate(genres_result, start=1):
#         # # print(tuple([num, i]))
#         genres_list.append(tuple([i, num]))
#         # f.write(f' INSERT INTO genres (genre) VALUES ("{i}");\n')
# print(dict(genres_list))
# done


