package gryffin.io.vv;

/**
  * enum of all possible entry-types in a Virtual Volume file
  */

enum VVEntryType {
	// Directory
	VVDirectory;

	// Standard File
	VVFile;

	// Alias to another File/Directory/Alias
	VVAlias;
}
