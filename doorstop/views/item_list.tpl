% rebase('base.tpl')
<H1>Pearl Requirements - List of Items in {{prefix}}</H1>
<P>
<ul>
{{! "".join('<li><a href="items/{0}">{0}</a></li>'.format(i) for i in items) }}
</ul>
</code>
