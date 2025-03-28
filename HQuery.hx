import h2d.Flow;
import h2d.RenderContext;
import h2d.Object;
import ludi.commons.util.UUID;

typedef HQueryField<T> = {
    val: T,
    prevVal: T,
    isDirty: Bool
}

typedef HQueryObjectData = {
    _object: h2d.Object,
    _events: EventDispatcher,
    _interactive: Null<h2d.Interactive>,
    _needsRefresh: Bool,
    ?width: HQueryField<Int>,
    ?height: HQueryField<Int>,
    ?x: HQueryField<Float>,
    ?y: HQueryField<Float>,
    ?onClick: HQueryField<(hxd.Event) -> Void>,
    ?onDblClick: HQueryField<(hxd.Event) -> Void>,
    ?onMouseDown: HQueryField<(hxd.Event) -> Void>,
    ?onMouseUp: HQueryField<(hxd.Event) -> Void>,
    ?onMouseOver: HQueryField<(hxd.Event) -> Void>,
    ?onKeyDown: HQueryField<(hxd.Event) -> Void>,
    ?onKeyUp: HQueryField<(hxd.Event) -> Void>,
    ?onResize: HQueryField<() -> Void>,
    ?background: HQueryField<h2d.Tile>,
    ?_backgroundBitmap: h2d.Bitmap,
    ?_scrollable: h2d.Flow,
    ?scrollableOptions: HQueryField<{ horz: Bool, vert: Bool }>,
    ?_frameBehavior: Behavior,
    ?onFrame: HQueryField<(HQuery, Float) -> Void>,
    ?isFrameActive: Bool,
    ?_fadeBehavior: Behavior,
    ?fadingTo: HQueryField<Float>,
    ?isFading: HQueryField<Bool>
}

class EventDispatcher {
    public function new() {
        
    }

    public function subscribe(event:String, handler:Dynamic -> Void) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unsubscribe(event:String) {
        throw new haxe.exceptions.NotImplementedException();
    }
}

class Node extends h2d.Object {
    
    public function new(?parent: Object) {
        super(parent);
        this.visible = false;
    }

    override function set_visible(b) {
		return false;
	}
}

class Behavior extends Node {
    public var active: Bool = true;
    public override function sync(ctx:RenderContext) {
        super.sync(ctx);
        if(active) {
            onFrame(ctx.elapsedTime);
        }
    }

    public dynamic function onFrame(dt:Float) {}
}

abstract HQuery(String) {
    private static var HQUERY_OBJECT_DATA_CACHE:Map<String, HQueryObjectData> = [];

    public function get(): h2d.Object {
        return getData()._object;
    }

    public function new(?obj:h2d.Object) {
        if (obj == null) obj = new h2d.Object();
        this = UUID.generate();
        var data = {
            _object: obj,
            _events: new EventDispatcher(),
            _interactive: null,
            _needsRefresh: false,
            width: null,
            height: null,
            x: null,
            y: null,
            onClick: null,
            onDblClick: null,
            onMouseDown: null,
            onMouseUp: null,
            onMouseOver: null,
            onKeyDown: null,
            onKeyUp: null,
            onResize: null,
            background: null,
            _backgroundBitmap: null,
            _scrollable: null,
            scrollableOptions: null,
            _frameBehavior: null,
            onFrame: null,
            isFrameActive: true,
            _fadeBehavior: null,
            fadingTo: null,
            isFading: null
        };
        HQUERY_OBJECT_DATA_CACHE.set(this, data);
    }

    private inline function getData():HQueryObjectData {
        return HQUERY_OBJECT_DATA_CACHE.get(this);
    }

    
    public function width(?w:Int):Int {
        var data = getData();
        if (w == null) {
            return data.width != null ? data.width.val : 0;
        } else {
            if (data.width == null) {
                data.width = { val: w, prevVal: 0, isDirty: true };
            } else if (data.width.val != w) {
                data.width.prevVal = data.width.val;
                data.width.val = w;
                data.width.isDirty = true;
            }
            needsRefresh();
            return w;
        }
    }

    
    public function height(?h:Int):Int {
        var data = getData();
        if (h == null) {
            return data.height != null ? data.height.val : 0;
        } else {
            if (data.height == null) {
                data.height = { val: h, prevVal: 0, isDirty: true };
            } else if (data.height.val != h) {
                data.height.prevVal = data.height.val;
                data.height.val = h;
                data.height.isDirty = true;
            }
            needsRefresh();
            return h;
        }
    }

    
    public function x(?val:Float):Float {
        var data = getData();
        if (val == null) {
            return data.x != null ? data.x.val : data._object.x;
        } else {
            if (data.x == null) {
                data.x = { val: val, prevVal: data._object.x, isDirty: true };
            } else if (data.x.val != val) {
                data.x.prevVal = data.x.val;
                data.x.val = val;
                data.x.isDirty = true;
            }
            needsRefresh();
            return data.x.val;
        }
    }

    
    public function y(?val:Float):Float {
        var data = getData();
        if (val == null) {
            return data.y != null ? data.y.val : data._object.y;
        } else {
            if (data.y == null) {
                data.y = { val: val, prevVal: data._object.y, isDirty: true };
            } else if (data.y.val != val) {
                data.y.prevVal = data.y.val;
                data.y.val = val;
                data.y.isDirty = true;
            }
            needsRefresh();
            return data.y.val;
        }
    }

    
    public function offset():{ x: Float, y: Float } {
        var data = getData();
        var pos = data._object.getAbsPos();
        return { x: pos.x, y: pos.y };
    }

    
    public function show():Void {
        var data = getData();
        data._object.visible = true;
    }

    
    public function hide():Void {
        var data = getData();
        data._object.visible = false;
    }

    
    public function remove():Void {
        var data = getData();
        if (data._object.parent != null) {
            data._object.parent.removeChild(data._object);
        }
        HQUERY_OBJECT_DATA_CACHE.remove(this);
    }

    
    public function empty():Void {
        var data = getData();
        while (data._object.numChildren > 0) {
            data._object.removeChild(data._object.getChildAt(0));
        }
    }

    
    public function size(w:Int, h:Int):Void {
        var data = getData();
        if (data.width == null) {
            data.width = { val: w, prevVal: 0, isDirty: true };
        } else if (data.width.val != w) {
            data.width.prevVal = data.width.val;
            data.width.val = w;
            data.width.isDirty = true;
        }
        if (data.height == null) {
            data.height = { val: h, prevVal: 0, isDirty: true };
        } else if (data.height.val != h) {
            data.height.prevVal = data.height.val;
            data.height.val = h;
            data.height.isDirty = true;
        }
        needsRefresh();
    }

    
    public function background(tile:h2d.Tile) {
        var data = getData();
        if (data.background == null) {
            data.background = { val: tile, prevVal: null, isDirty: true };
        } else if (data.background.val != tile) {
            data.background.prevVal = data.background.val;
            data.background.val = tile;
            data.background.isDirty = true;
        }
        needsRefresh();
    }

    
    public function scrollable(options:{ horz: Bool, vert: Bool }) {
        var data = getData();
        if (data.scrollableOptions == null) {
            data.scrollableOptions = { val: options, prevVal: null, isDirty: true };
        } else {
            if (data.scrollableOptions.val.horz != options.horz || data.scrollableOptions.val.vert != options.vert) {
                data.scrollableOptions.prevVal = data.scrollableOptions.val;
                data.scrollableOptions.val = options;
                data.scrollableOptions.isDirty = true;
            }
        }
        needsRefresh();
    }

    
    public function click(handler:(hxd.Event) -> Void) {
        var data = getData();
        if (data.onClick == null) {
            data.onClick = { val: handler, prevVal: null, isDirty: true };
        } else {
            data.onClick.prevVal = data.onClick.val;
            data.onClick.val = handler;
            data.onClick.isDirty = true;
        }
        needsRefresh();
    }

    
    public function dblClick(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onDblClick == null) {
            data.onDblClick = { val: handler, prevVal: null, isDirty: true };
        } else {
            data.onDblClick.prevVal = data.onDblClick.val;
            data.onDblClick.val = handler;
            data.onDblClick.isDirty = true;
        }
        needsRefresh();
    }

    
    public function mouseDown(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onMouseDown == null) {
            data.onMouseDown = { val: handler, prevVal: null, isDirty: true };
        } else {
            data.onMouseDown.prevVal = data.onMouseDown.val;
            data.onMouseDown.val = handler;
            data.onMouseDown.isDirty = true;
        }
        needsRefresh();
    }

    
    public function mouseUp(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onMouseUp == null) {
            data.onMouseUp = { val: handler, prevVal: null, isDirty: true };
        } else {
            data.onMouseUp.prevVal = data.onMouseUp.val;
            data.onMouseUp.val = handler;
            data.onMouseUp.isDirty = true;
        }
        needsRefresh();
    }

    
    public function mouseOver(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onMouseOver == null) {
            data.onMouseOver = { val: handler, prevVal: null, isDirty: true };
        } else {
            data.onMouseOver.prevVal = data.onMouseOver.val;
            data.onMouseOver.val = handler;
            data.onMouseOver.isDirty = true;
        }
        needsRefresh();
    }

    
    public function keyDown(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onKeyDown == null) {
            data.onKeyDown = { val: handler, prevVal: null, isDirty: false };
        } else {
            data.onKeyDown.val = handler;
        }
    }

    
    public function keyUp(handler:(hxd.Event) -> Void):Void {
        var data = getData();
        if (data.onKeyUp == null) {
            data.onKeyUp = { val: handler, prevVal: null, isDirty: false };
        } else {
            data.onKeyUp.val = handler;
        }
    }

    
    public function onResize(handler:() -> Void):Void {
        var data = getData();
        if (data.onResize == null) {
            data.onResize = { val: handler, prevVal: null, isDirty: false };
        } else {
            data.onResize.val = handler;
        }
    }

    
    public function on(event:String, handler:(Dynamic) -> Void):Void {
        var data = getData();
        data._events.subscribe(event, handler);
    }

    
    public function off(event:String):Void {
        var data = getData();
        data._events.unsubscribe(event);
    }

    
    public function frame(callback:(HQuery, Float) -> Void):Void {
        var data = getData();
        if (data.onFrame == null) {
            data.onFrame = { val: callback, prevVal: null, isDirty: true };
        } else {
            data.onFrame.prevVal = data.onFrame.val;
            data.onFrame.val = callback;
            data.onFrame.isDirty = true;
        }
        needsRefresh();
    }

    
    public function stop():Void {
        var data = getData();
        data.isFrameActive = false;
    }

    
    public function start():Void {
        var data = getData();
        data.isFrameActive = true;
    }

    
    public function fadeOut():Void {
        var data = getData();
        if (data.fadingTo == null) {
            data.fadingTo = { val: 0.0, prevVal: data._object.alpha, isDirty: true };
        } else {
            data.fadingTo.prevVal = data.fadingTo.val;
            data.fadingTo.val = 0.0;
            data.fadingTo.isDirty = true;
        }
        if (data.isFading == null) {
            data.isFading = { val: true, prevVal: false, isDirty: true };
        } else {
            data.isFading.val = true;
            data.isFading.isDirty = true;
        }
        needsRefresh();
    }

    
    public function fadeIn():Void {
        var data = getData();
        if (data.fadingTo == null) {
            data.fadingTo = { val: 1.0, prevVal: data._object.alpha, isDirty: true };
        } else {
            data.fadingTo.prevVal = data.fadingTo.val;
            data.fadingTo.val = 1.0;
            data.fadingTo.isDirty = true;
        }
        if (data.isFading == null) {
            data.isFading = { val: true, prevVal: false, isDirty: true };
        } else {
            data.isFading.val = true;
            data.isFading.isDirty = true;
        }
        needsRefresh();
    }

    
    public function fadeTo(alpha:Float):Void {
        var data = getData();
        if (data.fadingTo == null) {
            data.fadingTo = { val: alpha, prevVal: data._object.alpha, isDirty: true };
        } else {
            data.fadingTo.prevVal = data.fadingTo.val;
            data.fadingTo.val = alpha;
            data.fadingTo.isDirty = true;
        }
        if (data.isFading == null) {
            data.isFading = { val: true, prevVal: false, isDirty: true };
        } else {
            data.isFading.val = true;
            data.isFading.isDirty = true;
        }
        needsRefresh();
    }

    
    private function needsRefresh():Void {
        var data = getData();
        data._needsRefresh = true;
    }

    
    public function refresh():Void {
        var data = getData();
        if (!data._needsRefresh) return;

        
        if (data.x != null && data.x.isDirty) {
            data._object.x = data.x.val;
            data.x.isDirty = false;
        }
        if (data.y != null && data.y.isDirty) {
            data._object.y = data.y.val;
            data.y.isDirty = false;
        }

        
        if (data.background != null && data.background.isDirty) {
            if (data.background.val != null) {
                if (data._backgroundBitmap == null) {
                    data._backgroundBitmap = new h2d.Bitmap(data.background.val, data._object);
                } else {
                    data._backgroundBitmap.tile = data.background.val;
                }
                if (data.width != null) data._backgroundBitmap.width = data.width.val;
                if (data.height != null) data._backgroundBitmap.height = data.height.val;
            } else if (data._backgroundBitmap != null) {
                data._backgroundBitmap.remove();
                data._backgroundBitmap = null;
            }
            data.background.isDirty = false;
        }

        
        if (data.scrollableOptions != null && data.scrollableOptions.isDirty) {
            if (data._scrollable == null) {
                data._scrollable = new Flow(data._object);
                data._scrollable.overflow = Scroll;
            }
            var opts = data.scrollableOptions.val;
         
          
            var childrenToMove = [];
            @:privateAccess for (child in data._object.children) {
                if (child != data._interactive && child != data._scrollable) {
                    childrenToMove.push(child);
                }
            }
            for (child in childrenToMove) {
                data._scrollable.addChild(child);
            }
            if (data.width != null) data._scrollable.minWidth = data.width.val;
            if (data.height != null) data._scrollable.minHeight = data.height.val;
            data.scrollableOptions.isDirty = false;
        }

        
        var needsInteractive = (data.onClick != null && data.onClick.val != null) ||
                               (data.onDblClick != null && data.onDblClick.val != null) ||
                               (data.onMouseDown != null && data.onMouseDown.val != null) ||
                               (data.onMouseUp != null && data.onMouseUp.val != null) ||
                               (data.onMouseOver != null && data.onMouseOver.val != null);
        if (needsInteractive && data._interactive == null) {
            var w = data.width != null ? data.width.val : 0;
            var h = data.height != null ? data.height.val : 0;
            data._interactive = new h2d.Interactive(w, h, data._object);
        }
        if (!needsInteractive && data._interactive != null) {
            data._interactive.remove();
            data._interactive = null;
        }
        if (data._interactive != null) {
            if (data.onClick != null && data.onClick.isDirty) {
                data._interactive.onClick = data.onClick.val;
                data.onClick.isDirty = false;
            }
            if (data.onDblClick != null && data.onDblClick.isDirty) {
                data._interactive.onClick = data.onDblClick.val;
                data.onDblClick.isDirty = false;
            }
            if (data.onMouseDown != null && data.onMouseDown.isDirty) {
                data._interactive.onPush = data.onMouseDown.val;
                data.onMouseDown.isDirty = false;
            }
            if (data.onMouseUp != null && data.onMouseUp.isDirty) {
                data._interactive.onRelease = data.onMouseUp.val;
                data.onMouseUp.isDirty = false;
            }
            if (data.onMouseOver != null && data.onMouseOver.isDirty) {
                data._interactive.onOver = data.onMouseOver.val;
                data.onMouseOver.isDirty = false;
            }
        }

        
        if (data.onFrame != null && data.onFrame.isDirty) {
            if (data._frameBehavior == null) {
                data._frameBehavior = new Behavior(data._object);
                data._frameBehavior.onFrame = (dt) -> {
                    if (data.isFrameActive && data.onFrame != null && data.onFrame.val != null) {
                        data.onFrame.val(abstract, dt);
                    }
                };
                data._object.addChild(data._frameBehavior);
            }
            data.onFrame.isDirty = false;
        }

        
        if (data.isFading != null && data.isFading.val && data.fadingTo != null) {
            if (data._fadeBehavior == null) {
                data._fadeBehavior = new Behavior(data._object);
                data._fadeBehavior.onFrame = (dt) -> {
                    var target = data.fadingTo.val;
                    var current = data._object.alpha;
                    if (Math.abs(current - target) < 0.01) {
                        data._object.alpha = target;
                        data.isFading.val = false;
                        data._fadeBehavior.active = false;
                    } else {
                        data._object.alpha += (target - current) * dt * 5; 
                    }
                };
                data._object.addChild(data._fadeBehavior);
            }
            
        }

        
        if (data.width != null && data.width.isDirty) {
            if (data._interactive != null) data._interactive.width = data.width.val;
            if (data._backgroundBitmap != null) data._backgroundBitmap.width = data.width.val;
            if (data._scrollable != null) data._scrollable.minWidth = data.width.val;
            data.width.isDirty = false;
        }
        if (data.height != null && data.height.isDirty) {
            if (data._interactive != null) data._interactive.height = data.height.val;
            if (data._backgroundBitmap != null) data._backgroundBitmap.height = data.height.val;
            if (data._scrollable != null) data._scrollable.minHeight = data.height.val;
            data.height.isDirty = false;
        }

        
        var sizeChanged = (data.width != null && data.width.isDirty) || 
                          (data.height != null && data.height.isDirty);
        if (sizeChanged && data.onResize != null && data.onResize.val != null) {
            data.onResize.val();
        }

        data._needsRefresh = false;
    }

    
    public static function refreshAll():Void {
        for (key in HQUERY_OBJECT_DATA_CACHE.keys()) {
            var data = HQUERY_OBJECT_DATA_CACHE.get(key);
            if (data._needsRefresh) {
                var hquery:HQuery = cast key;
                hquery.refresh();
            }
        }
    }
}