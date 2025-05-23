/* Configure script for modbus_e2e.dll, specific for Windows with Scripting Host.
 *
 * Inspired by configure.js from libxml2
 *
 * oldfaber  < oldfaber _at_ gmail _dot_ com >
 *
 * Copyright © Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contibutors.
 * Copyright © End 2 End Technologies, LLC., 2025.
 *
 */

/* The source directory, relative to the one where this file resides. */
var srcDir = "..";
/* Base name of what we are building. */
var baseName = "modbus_e2e";
/* Configure file template and output file */
var configFile = srcDir + "\\..\\configure.ac";
/* Input and output files for the modbus-version.h include */
var newfile;
/* Version strings for the binary distribution. Will be filled later in the code. */
var verMajor;
var verMinor;
var verMicro;
/* modbus features. */
var dryRun = false;
/* Win32 build options. NOT used yet */
var compiler = "msvc";
/* Local stuff */
var error = 0;
/* Filename */
var newFile;

/* Displays the details about how to use this script. */
function usage() {
    var txt;

    txt = "Usage:\n";
    txt += "  cscript " + WScript.ScriptName + " <options>\n";
    txt += "  cscript " + WScript.ScriptName + " help\n\n";
    txt +=
        "Options can be specified in the form <option>=<value>, where the value is\n";
    txt += "either 'yes' or 'no', if not stated otherwise.\n\n";
    txt +=
        "\nModbus_e2e library configure options, default value given in parentheses:\n\n";
    txt +=
        "  dry-run:  Run configure without creating files (" +
        (dryRun ? "yes" : "no") +
        ")\n";
    txt += "\nWin32 build options, default value given in parentheses:\n\n";
    txt += "  compiler: Compiler to be used [msvc|mingw] (" + compiler + ")\n";
    WScript.Echo(txt);
}

/* read the version from the configuration file */
function readVersion() {
    var fso, cf, ln, s;
    fso = new ActiveXObject("Scripting.FileSystemObject");
    cf = fso.OpenTextFile(configFile, 1);
    while (cf.AtEndOfStream !== true) {
        ln = cf.ReadLine();
        s = new String(ln);
        if (s.search(/^m4_define\(\[libmodbus_e2e_version_major/) != -1) {
            verMajor = s.substr(s.indexOf(",") + 3, 1);
        } else if (s.search(/^m4_define\(\[libmodbus_e2e_version_minor/) != -1) {
            verMinor = s.substr(s.indexOf(",") + 3, 1);
        } else if (s.search(/^m4_define\(\[libmodbus_e2e_version_micro/) != -1) {
			str_start_idx = s.indexOf(",") + 3;
			num_str_length = s.length - str_start_idx - 2;
            verMicro = s.substr(str_start_idx, num_str_length);
        }
    }
    cf.Close();
}

/* create the versioned file */
function createVersionedFile(newfile, unversioned) {
    var fso, ofi, of, ln, s;
    fso = new ActiveXObject("Scripting.FileSystemObject");
    ofi = fso.OpenTextFile(unversioned, 1);
    if (!dryRun) {
        of = fso.CreateTextFile(newfile, true);
    }
    while (ofi.AtEndOfStream !== true) {
        ln = ofi.ReadLine();
        s = new String(ln);
        if (!dryRun && s.search(/\@LIBMODBUS_E2E_VERSION_MAJOR\@/) != -1) {
            of.WriteLine(s.replace(/\@LIBMODBUS_E2E_VERSION_MAJOR\@/, verMajor));
        } else if (!dryRun && s.search(/\@LIBMODBUS_E2E_VERSION_MINOR\@/) != -1) {
            of.WriteLine(s.replace(/\@LIBMODBUS_E2E_VERSION_MINOR\@/, verMinor));
        } else if (!dryRun && s.search(/\@LIBMODBUS_E2E_VERSION_MICRO\@/) != -1) {
            of.WriteLine(s.replace(/\@LIBMODBUS_E2E_VERSION_MICRO\@/, verMicro));
        } else if (!dryRun && s.search(/\@LIBMODBUS_E2E_VERSION\@/) != -1) {
            of.WriteLine(
                s.replace(
                    /\@LIBMODBUS_E2E_VERSION\@/,
                    verMajor + "." + verMinor + "." + verMicro
                )
            );
        } else {
            if (!dryRun) {
                of.WriteLine(ln);
            }
        }
    }
    ofi.Close();
    if (!dryRun) {
        of.Close();
    }
}

/*
 * main(),
 * Execution begins here.
 */

// Parse the command-line arguments.
for (i = 0; i < WScript.Arguments.length && error === 0; i++) {
    var arg, opt;
    arg = WScript.Arguments(i);
    opt = arg.substring(0, arg.indexOf("="));
    if (opt.length > 0) {
        if (opt == "dry-run") {
            var str = arg.substring(opt.length + 1, arg.length);
            if (opt == 1 || opt == "yes") {
                dryRun = true;
            }
        } else if (opt == "compiler") {
            compiler = arg.substring(opt.length + 1, arg.length);
        } else {
            error = 1;
        }
    } else if (i === 0) {
        if (arg == "help") {
            usage();
            WScript.Quit(0);
        }
    } else {
        error = 1;
    }
}

// If we fail here, it is because the user supplied an unrecognised argument.
if (error !== 0) {
    usage();
    WScript.Quit(error);
}

// Read the the version.
readVersion();
if (error !== 0) {
    WScript.Echo("Version discovery failed, aborting.");
    WScript.Quit(error);
}

newfile = srcDir + "\\modbus-version.h";
createVersionedFile(newfile, srcDir + "\\modbus-version.h.in");
if (error !== 0) {
    WScript.Echo("Creation of " + newfile + " failed, aborting.");
    WScript.Quit(error);
}
WScript.Echo(newfile + " created.");

newfile = "modbus_e2e.dll.manifest";
createVersionedFile(newfile, "modbus_e2e.dll.manifest.in");
if (error !== 0) {
    WScript.Echo("Creation of " + newfile + " failed, aborting.");
    WScript.Quit(error);
}
WScript.Echo(newfile + " created.");

newfile = "config.h";
createVersionedFile(newfile, "config.h.win32");
if (error !== 0) {
    WScript.Echo("Creation of " + newfile + " failed, aborting.");
    WScript.Quit(error);
}
WScript.Echo(newfile + " created.");

WScript.Echo("\nlibmodbus_e2e configuration completed\n");
