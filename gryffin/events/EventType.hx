package gryffin.events;

enum EventType {
	MouseEvent;
	KeyboardEvent(up:Bool);
	ResizeEvent;
	ShutdownEvent;

	Custom(data:Dynamic);
}