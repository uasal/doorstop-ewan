% rebase('base.tpl')
<H1>Pearl Requirements - List of Documents</H1>
<P>
<ul>
{{! "".join('<li><a href="{0}">{0}</a></li>'.format(p) for p in prefixes) }}
</ul>
</code>
