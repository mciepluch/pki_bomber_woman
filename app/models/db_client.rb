class DbClient
  REDIS = Redis.new(host: "localhost")

  #TODO: MUTEXES???
  def self.db_get_map
    Marshal.load(REDIS.get("map"))
  end

  def self.db_set_map(map)
    map_marshaled = Marshal.dump(map)
    REDIS.set("map", map_marshaled)
  end
end
