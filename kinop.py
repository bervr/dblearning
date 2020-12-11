import requests
import json

url = 'https://kinopoiskapiunofficial.tech/'
command1 = '/api/v2.1/films/'
id=1311064
header = {'x-api-key':'239d638c-4c96-46a0-8447-47215bc55da7'} # починить потом

with open('2_ivi_insert.sql','a', encoding='utf-8') as f:
     for i in range (id, id+100):
         try:
            r = requests.get(url + command1 + f'{i}', headers=header)
            if r.status_code == 200:
                data = (json.loads(r.text)).get('data')
                f.write(f" INSERT INTO movies (id, name, original_name, year_of, country, duration, description, poster_id) "
                        f"VALUES ({data.get('filmId')}, '{data.get('nameRu')}', '{data.get('nameEn')}', {data.get('year')}, "
                        f"'{(data.get('countries')[0]).get('country')}', STR_TO_DATE('{data.get('filmLength')}','%H:%i'), "
                        f"'{data.get('description')}', {data.get('filmId')});\n")
                i+=i
            else:
                i += i
         except IndexError:
             print("IndexError: list index out of range")



command1 = 'api/v1/staff/?filmId='
r = requests.get(url + command1 + f'{id}', headers=header)
# print(r.status_code)
# data=(json.loads(r.text)).get('data')

a = r.text.strip('[]').replace('},{', '}$!${').split('$!$')
print(len(a))
for staff in a:
    item = json.loads(staff)
    print(item.get('staffId'), item.get('nameRu'), item.get('professionKey'))
# print(data.get('filmId'))
# print(data.get('nameRu'))
# print(data.get('nameEn'))
#
# print(data.get('nameEn'))



# print(dict(api_key))
# print(type(header))