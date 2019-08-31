class Worklog:

    def __init__(self, dbcon, logger):
        self._dbcon=dbcon
        self._logger=logger

    def save_location(self, **kwargs):
        sql = """
        insert into location 
        (country,city,active) 
        values ('{}','{}',false)
        """.format(  
            kwargs['country'],
            kwargs['city'])
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        self._dbcon.connection.commit()
        cur.close()
        self._logger.info(sql)

    def find_location(self, vCountry, vCity):
        sql = """
        select country, city, active from location where country="{}" and city="{}";
        """.format(
                vCountry,
                vCity)
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        rv = cur.fetchone()
        cur.close()
        self._logger.info(sql)
        self._logger.info(rv)
        return rv

    def state_location(self, **kwargs):
        sql = """
        update location 
        set active = "{}"
        where country="{}" and city="{}";
        """.format(
                int(kwargs['active']),
                kwargs['country'],
                kwargs['city'])
        cur = self._dbcon.connection.cursor()
        res = cur.execute(sql)
        self._dbcon.connection.commit()
        cur.close()
        self._logger.info(sql)
        return res
