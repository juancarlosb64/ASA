class Worklog:

    def __init__(self, dbcon, logger):
        self._dbcon=dbcon
        self._logger=logger

    def find_product(self, vSku):
        sql = """
        select sku
               , description
               , base_price 
        from product 
        where sku="{}";
        """.format(
                vSku)
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        rv = cur.fetchone()
        cur.close()
        self._logger.info(sql)
        self._logger.info(rv)
        return rv

    def find_rules(self, weather_id, **payload):
        sql = """
        select pr.sku
               , pr.description
               , coalesce(rl.country, "{}") as country
               , coalesce(rl.city, "{}") as city
               , pr.base_price
               , coalesce(rl.variation, 1) as variation
        from product as pr
        left outer join rules as rl on pr.sku = rl.sku and "{}" between rl.min_condition and rl.max_condition and rl.country = "{}" and rl.city = "{}"
        where pr.sku = "{}";
        """.format(
                payload['country'],
                payload['city'],
                weather_id,
                payload['country'],
                payload['city'],
                payload['sku'])
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        rv = cur.fetchone()
        cur.close()
        self._logger.info(sql)
        self._logger.info(rv)
        return rv
