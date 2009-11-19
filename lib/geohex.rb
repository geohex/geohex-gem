#
# ported from perl libraries http://svn.coderepos.org/share/lang/perl/Geo-Hex/trunk/lib/Geo/Hex.pm
# author Haruyuki Seki 
#
class GeoHex
  H_KEY       = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX';

  MIN_X_LON   = 122930; #与那国島
  MIN_X_LAT   = 24448;
  MIN_Y_LON   = 141470; ##南硫黄島
  MIN_Y_LAT   = 24228;
  H_GRID      = 1000;
  H_SIZE      = 0.5;
  

  def self.encode(lat,lon,level=7)
    raise ArgumentError, "latitude must be between -90 and 90" if (lat < -90 || lat > 90)
    raise ArgumentError, "longitude must be between -180 and 180" if (lon < -180 || lon > 180)
    raise ArgumentError, "level must be between 1 and 60" if (level < 1 || level > 60)
    
    lon_grid = lon * H_GRID
    lat_grid = lat * H_GRID
    unit_x   = 6.0  * level * H_SIZE
    unit_y   = 2.8  * level * H_SIZE
    h_k      = (( (1.4 / 3) * H_GRID).round.to_f / H_GRID)

    base_x   = ( (MIN_X_LON + MIN_X_LAT / h_k      ) / unit_x).floor
    base_y   = ( (MIN_Y_LAT - h_k      * MIN_Y_LON) / unit_y).floor
    h_pos_x  = ( lon_grid + lat_grid / h_k     ) / unit_x - base_x
    h_pos_y  = ( lat_grid - h_k      * lon_grid) / unit_y - base_y
    h_x_0    = h_pos_x.floor
    h_y_0    = h_pos_y.floor
    h_x_q    = ((h_pos_x - h_x_0) * 100).floor / 100
    h_y_q    = ((h_pos_y - h_y_0) * 100).floor / 100
    h_x      = h_pos_x.round
    h_y      = h_pos_y.round

      
    if ( h_y_q > -h_x_q + 1 ) 
      
      if ( h_y_q < (2 * h_x_q ) and  h_y_q > (0.5 * h_x_q ) )
        h_x = h_x_0 + 1
        h_y = h_y_0 + 1
      end
    elsif ( h_y_q < -h_x_q + 1 ) 
      if( (h_y_q > (2 * h_x_q ) - 1 ) && ( h_y_q < ( 0.5 * h_x_q ) + 0.5 ) ) 
        h_x = h_x_0;
        h_y = h_y_0;
      end
    end
    return self.__hyhx2geohex( h_y, h_x, level );
  end

  private
  def self.__hyhx2geohex(h_y,h_x,level) 
    
    h_x_100 = ( h_x / 3600).floor
    h_x_10  = ((h_x % 3600) / 60).floor
    h_x_1   = ((h_x % 3600) % 60).floor
    h_y_100 = ( h_y / 3600).floor
    h_y_10  = ((h_y % 3600) / 60).floor
    h_y_1   = ((h_y % 3600) % 60).floor
    
    code = nil
    if ( level < 7 ) 
      code = H_KEY[ level % 60 ,1] + H_KEY[ h_x_100 ,1] + H_KEY[ h_y_100,1 ] +
        H_KEY[ h_x_10,1 ] + H_KEY[ h_y_10,1 ] + H_KEY[ h_x_1,1 ] + H_KEY[ h_y_1,1 ]
    elsif ( level == 7 ) 
      code = H_KEY[ h_x_10,1 ] + H_KEY[ h_y_10 ] + H_KEY[ h_x_1,1 ] + H_KEY[ h_y_1,1 ];
    else 
      code = H_KEY[ level % 60, 1 ] + H_KEY[ h_x_10,1 ] + H_KEY[ h_y_10,1 ] + H_KEY[ h_x_1,1 ] + H_KEY[ h_y_1,1 ]
    end
    return code;
  end
end
