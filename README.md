# HQuery - JQuery for Heaps

But not really. This isn't about QUERYING the dom or CHAINING the methods. This is about having a simplified interface for creating heaps objects. 

```haxe

var o = new HQuery(); //HQuery is just an abstract wrapping h2d.Object. Minimally invasive and can be used everywhere
o.x(50);
o.y(50);
o.width(100);
o.height(100);
o.background(Res.sunface1.toTile());
o.frame((o, dt) -> {
	o.x(o.x() + 1);
	if(o.x() > 100){
		o.fadeTo(0.5);
	}
});
s2d.add(o);

var existingObj = new MyObject();
var o2 = new HQuery(existingObj);
o2.click((e) -> {
	o2.popup();
});

```

Included code works but the internals need a redesign and more rigorous testing before public release.
