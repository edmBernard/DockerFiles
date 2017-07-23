NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif

.PHONY: all all\:cpu all\:gpu clean clean\:cpu clean\:gpu {% for i in images %}{{ i }} {% endfor %} 


all: all\:cpu all\:gpu

all\:cpu: {% for i in images[::-1] %}{% if "cpu" in i %}{{ i }} {% endif %}{% endfor %} 

all\:gpu: {% for i in images[::-1] %}{% if "gpu" in i %}{{ i }} {% endif %}{% endfor %} 


clean:
	docker rmi {% for i in images %}{{ i }} {% endfor %} 

clean\:cpu: 
	docker rmi {% for i in images %}{% if "cpu" in i %}{{ i }} {% endif %}{% endfor %} 

clean\:gpu: 
	docker rmi {% for i in images %}{% if "gpu" in i %}{{ i }} {% endif %}{% endfor %} 


{% for i, f, d in zip(images, filenames, deps) %}
{{ i }}: {% for j in d %}{{ j }} {% endfor %} 
{% if "gpu" in i %}
	nvidia-docker build $(arg_nocache) -t {{ i }} -f {{ f }} {{ f.split("/")[0] }}
{% else %}
	docker build $(arg_nocache) -t {{ i }} -f {{ f }} {{ f.split("/")[0] }}
{% endif %}

{% endfor %}
