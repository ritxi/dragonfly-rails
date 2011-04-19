require 'dragonfly'
%w(active_model_extension data_storage model_extension railtie version).each{|lib| require File.join %W(kaltha #{lib})}

