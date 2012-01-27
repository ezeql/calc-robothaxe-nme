package hsl.haxe.data.progress;
import hsl.haxe.Signaler;

interface Completable {
	public var completedSignaler(default, null):Signaler<Void>;
}