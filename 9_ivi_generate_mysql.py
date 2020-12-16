import mysql.connector
import random
import datetime
import string


# да, я знаю что спагетти но переделывать нет времени...
def get_random_string(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str


conct = mysql.connector.connect(host='localhost',
                                database='ivi',
                                user='root',
                                password='1234') # да, в лучших традициях)
if conct.is_connected():
    print('Connected to MySQL database')
movie_id = []
with conct:
    cur = conct.cursor()
    cur.execute("SELECT id FROM accounts")
    accounts_id = cur.fetchall()
    cur.execute("SELECT id, duration FROM movies")
    movie_dur_id = cur.fetchall()
    for id in movie_dur_id:
        movie_id.append(id[0])
    for id in accounts_id:
        create_new_profile= random.randint(0, 2) # добавим новых профилей
        if create_new_profile >0:
            user_id = id[0]
            for new_profile in range(create_new_profile):
                is_active = random.randint(0,1)
                language_set = random.choice(['ru', 'en'])
                adult_restriction = random.choice(['allowed','denied'])
                photo_id = random.randint(29000,55000)
                name = get_random_string((random.randint(5,10)))
                sql = "insert profiles (account_id, name,photo_id,is_active,language_set,adult_restriction) values (%s, %s, %s, %s, %s, %s)"
                val = (user_id, name, photo_id, is_active, language_set, adult_restriction)
                cur.execute(sql, val)
    conct.commit()  # записали
    cur.execute("SELECT id FROM profiles")
    profiles_id = cur.fetchall()
    for id in accounts_id:
        count_purchase = random.randint(0, 3) # добавим оплаченые фильмы
        for i in range(count_purchase):
            purchase_type = random.choice(['temporary', 'permanent'])
            purchase_date = datetime.datetime.fromtimestamp(1420056000 + random.randint(0, 189216) * 1000)
            #c 2015 года + 6 лет
            if purchase_type == 'temporary':
                timebond = datetime.datetime.fromtimestamp(1577822400 + random.randint(0, 63072) * 1000)
                 # c 2020 года + 2 года
            else:
                timebond = 0
            purchased_movie = (random.choice(movie_id))
            user_id = id[0]
            sql = "insert purchases (account_id,movie_id,purchase_date,purchase_type,timebond) values (%s, %s, %s, %s, %s)"
            val = (user_id, purchased_movie, purchase_date, purchase_type, timebond)
            cur.execute(sql, val)
    conct.commit() # зафиксировали
    for id in profiles_id:
        count_rated = random.randint(0, 3)
        # добавим  просмотреные фильмы и если  просмотрено больше 80% то пусть будет как будто пользователь поставил оценку
        for i in range(count_rated):
            viewed_at = datetime.datetime.fromtimestamp(1420056000 + random.randint(0, 189216) * 1000)
            movie_id = (random.choice(movie_dur_id))
            movie = movie_id[0]
            duration = movie_id[1]
            user_id = id[0]
            timeline = datetime.timedelta(seconds=(random.randint(0, int(duration.total_seconds()))))
            sql = "insert views_history (profile_id,movie_id,viewed_at,timeline) values (%s, %s, %s, %s)"
            val = (user_id, movie, viewed_at, timeline)
            cur.execute(sql, val)
            if timeline >= (duration * 0.8):
                rate = random.randint(5, 10)
                sql = "insert rating (profile_id,movie_id,rated_at,rate) values (%s, %s, %s, %s)"
                val = (user_id, movie, (viewed_at + timeline), rate)
                cur.execute(sql, val)
    conct.commit() # зафиксировали
    for id in profiles_id: # еще раз прочешем профили
        count_wanted = random.randint(0, 10)
        # пусть будут фильмы которые пользователь отметил чтобы посмотреть
        for i in range(count_wanted):
            checkup = datetime.datetime.fromtimestamp(1420056000 + random.randint(0, 189216) * 1000)
            movie_id = (random.choice(movie_dur_id))
            movie = movie_id[0]
            user_id = id[0]
            sql = "insert wanted_to_view (profile_id,movie_id,check_up) values (%s, %s, %s)"
            val = (user_id, movie, checkup)
            cur.execute(sql, val)
    conct.commit()  # зафиксировали
