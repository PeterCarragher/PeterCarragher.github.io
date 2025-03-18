---
title: Publications
permalink: /publications/
layout: home
---
{::options parse_block_html="true" /}
{: .bio}

<div class="publications">
{% for pub in site.data.publications %}
**{{ pub.title }}** 
{{ pub.authors }}  
*{{ pub.venue }}*. {{ pub.year }}.
<br>
<span class="badge {{ pub.type }}">{{ pub.type }}</span>
{% if pub.links.pdf %}[pdf]({{ pub.links.pdf }}){% endif %}
{% if pub.links.code %} . [code]({{ pub.links.code }}){% endif %}
{% if pub.links.data %} . [data]({{ pub.links.data }}){% endif %}
{% if pub.links.slides %} . [slides]({{ pub.links.slides }}){% endif %}
<hr>
{% endfor %}
</div>