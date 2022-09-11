class UserStatisticsSerializer
  include JSONAPI::Serializer
  attributes :email, :kills, :suicides, :wins, :games_played
end
