---
layout: home
title: 
canonical_url: petercarragher.com
---
{::options parse_block_html="true" /}
{: .bio}
{{ site.data.about.bio }}

## Publications
{: #publications}

<div class="publications">
{% for pub in site.data.publications %}
{% if pub.links.scholar %}[{{ pub.title }}]({{ pub.links.scholar }}){% else %}{{ pub.title }}{% endif %}
{{ pub.authors }}  
*{{ pub.venue }}*. {{ pub.year }}.
<br>
<span class="badge {{ pub.type | replace: ' ', '-' }}">{{ pub.type }}</span>
{% if pub.links.pdf %}[pdf]({{ pub.links.pdf }}){% endif %}{% if pub.links.code %} . [code]({{ pub.links.code }}){% endif %}{% if pub.links.data %} . [data]({{ pub.links.data }}){% endif %}{% if pub.links.slides %} . [slides]({{ pub.links.slides }}){% endif %}
<hr>
{% endfor %}
</div>