module Urligence
  def smart_url(*objects)
    urligence *attach_params(nil, :url, *objects)
  end
  
  def smart_path(*objects)
    urligence *attach_params(nil, :path, *objects)
  end
  
  def hash_for_smart_url(*objects)
    urligence *attach_params(:hash_for, :url, *objects)
  end
  
  def hash_for_smart_path(*objects)
    urligence *attach_params(:hash_for, :path, *objects)
  end
  
  # Attaches prefix and suffix and appends params 
  def attach_params(prefix, suffix, *objects)
    params = objects.pop if objects.last.is_a?(Hash)
    objects.unshift(prefix).push(suffix).push(params)
  end
  
  def urligence(*objects)
    only_hash = objects.first == :hash_for
    params = {}
    params.merge!(objects.pop) if objects.last.is_a?(Hash)
    
    objects.reject! { |object| object.nil? }
    
    url_fragments = objects.collect do |obj|
      if obj.is_a? Symbol
        obj
      elsif obj.is_a? Array
        obj.first
      else
        obj.class.name.underscore.to_sym
      end
    end
    
    unless only_hash
      send url_fragments.join("_"), *objects.flatten.select { |obj| !obj.is_a? Symbol }.push(params)
    else
      unparsed_params = objects.select { |obj| !obj.is_a? Symbol }
      unparsed_params.each_with_index do |obj, i|
        unless i == (unparsed_params.length-1)
          params.merge!((obj.is_a? Array) ? {"#{obj.first}_id".to_sym => obj[1].to_param} : {"#{obj.class.name.underscore}_id".to_sym => obj.to_param})
        else
          params.merge!((obj.is_a? Array) ? {:id => obj[1].to_param} : {:id => obj.to_param})
        end
      end
      
      send url_fragments.join("_"), params
    end
  end
end
