package hsl.avm2.data;

enum NetStreamError {
	/**
	 * Attempt to publish a stream which is already being published by someone else.
	 */
	streamPublishBadName;
	/**
	 * An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber
	 * not having read access.
	 */
	streamPlayFailed;
	/**
	 * The FLV passed to the play method can't be found.
	 */
	streamPlayStreamNotFound;
	/**
	 * The application detects an invalid file structure and will not try to play this type of file. For AIR and for Flash
	 * Player 9.0.115.0 and later.
	 */
	streamPlayFileStructureInvalid;
	/**
	 * The application does not detect any supported tracks (video, audio or data) and will not try to play the file. For AIR
	 * and for Flash Player 9.0.115.0 and later.
	 */
	streamPlayNoSupportedTrackFound;
	/**
	 * Attempt to record a stream that is still playing or the client has no access right.
	 */
	streamRecordNoAccess;
	/**
	 * An attempt to record a stream failed.
	 */
	streamRecordFailed;
	/**
	 * The seek fails, which happens if the stream is not seekable.
	 */
	streamSeekFailed;
	/**
	 * For video downloaded with progressive download, the user has tried to seek or play past the end of the video data that
	 * has downloaded thus far, or past the end of the video once the entire file has downloaded. The message.details property
	 * contains a time code that indicates the last valid position to which the user can seek.
	 */
	streamSeekInvalidTime;
	/**
	 * Packet encoded in an unidentified format.
	 */
	connectionCallBadVersion;
	/**
	 * The call method of a net connection was not able to invoke the server-side method or command.
	 */
	connectionCallFailed;
	/**
	 * An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain
	 * as the file containing the code calling the call method of a net connection, or the AMF server does not have a policy file
	 * that trusts the domain of the the file containing the code calling the call method of the net connection.
	 */
	connectionCallProhibited;
	/**
	 * The connection attempt failed.
	 */
	connectionConnectFailed;
	/**
	 * The connection attempt did not have permission to access the application.
	 */
	connectionConnectRejected;
	/**
	 * The specified application is shutting down.
	 */
	connectionConnectAppShutdown;
	/**
	 * The application name specified during connect is invalid.
	 */
	connectionConnectInvalidApp;
	/**
	 * The "pending" status is resolved, but the call to the flush method of a shared object failed.
	 */
	sharedObjectFlushFailed;
	/**
	 * A request was made for a shared object with persistence flags, but the request cannot be granted because the object has
	 * already been created with different flags.
	 */
	sharedObjectBadPersistence;
	/**
	 * An attempt was made to connect to a net connection that has a different URI (URL) than the shared object.
	 */
	sharedObjectUriMismatch;
}