From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Create man pages for cifs.idmap program
Date: Thu, 26 May 2011 18:37:55 -0500
Message-ID: <1306453075-30274-1-git-send-email-shirishppargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Create man pages for program cifs.idmap
Enable cifs.idmap config option by default.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am     |    7 +++++
 cifs.idmap.8.in |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac    |    4 +-
 3 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 cifs.idmap.8.in

diff --git a/Makefile.am b/Makefile.am
index 6046369..9066531 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,4 +37,11 @@ if CONFIG_CIFSIDMAP
 sbin_PROGRAMS += cifs.idmap
 cifs_idmap_SOURCES = cifs.idmap.c
 cifs_idmap_LDADD = -lkeyutils $(WINB_LDADD)
+man_MANS += cifs.idmap.8
+
+cifs.idmap.8: cifs.idmap.8.in
+	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+
+clean-local:
+	rm -f cifs.idmap.8 cifs.idmap.8-t
 endif
diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
new file mode 100644
index 0000000..9f4680e
--- /dev/null
+++ b/cifs.idmap.8.in
@@ -0,0 +1,79 @@
+'\" t
+.\"     Title: cifs.idmap
+.\"    Author: [see the "AUTHOR" section]
+.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
+.\"      Date: 05/26/2011
+.\"    Manual: System Administration tools
+.\"    Source: cifs-utils 4.0
+.\"  Language: English
+.\"
+.TH "CIFS\&.IDMAP" "8" "05/26/2011" "cifs-utils 4\&.0" "System Administration tools"
+.\" -----------------------------------------------------------------
+.\" * set default formatting
+.\" -----------------------------------------------------------------
+.\" disable hyphenation
+.nh
+.\" disable justification (adjust text to left margin only)
+.ad l
+.\" -----------------------------------------------------------------
+.\" * MAIN CONTENT STARTS HERE *
+.\" -----------------------------------------------------------------
+.SH "NAME"
+cifs.idmap \- Userspace helper for mapping ids for Common Internet File System (CIFS)
+.SH "SYNOPSIS"
+.HP \w'\ 'u
+cifs\&.idmap [\-\-version|\-v] {keyid}
+.SH "DESCRIPTION"
+.PP
+This tool is part of the cifs-utils suite\&.
+.PP
+cifs\&.idmap is a userspace helper program for the linux CIFS client filesystem\&. There are a number of activities that the kernel cannot easily do itself\&. This program is a callout program that does these things for the kernel and then returns the result\&.
+.PP
+cifs\&.idmap is generally intended to be run when the kernel calls request\-key(8)
+for a particular key type\&. While it can be run directly from the command\-line, it is not generally intended to be run that way\&.
+.PP
+cifs\&.idmap works in conjuction with winbind facility of Samba suite to map owner and group SIDs to uids and gids respectively.  It is best utilized when a mount option of cifsacl is specified when mounting a cifs share, winbind is specified as one of the search entries for passwd and group databases in file /etc/nsswitch.conf, file smb.conf has winbind specific entries, and winbind daemon program is running. It is also strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs respectively in case services of winbind facility are unavailable.
+.SH "OPTIONS"
+.PP
+\-\-version|\-v
+.RS 4
+Print version number and exit\&.
+.RE
+.SH "CONFIGURATION FOR KEYCTL"
+.PP
+cifs\&.idmap is designed to be called from the kernel via the request\-key callout program\&. This requires that request\-key be told where and how to call this program\&. Currently cifs\&.idmap handles a key type of:
+.PP
+cifs\&.idmap
+.RS 4
+This keytype is for mapping a SID to either an uid or a gid
+.RE
+.PP
+To make this program useful for CIFS, you will need to set up entry for it in request\-key\&.conf(5)\&. Here is an example of an entry for this key type:
+.sp
+.if n \{\
+.RS 4
+.\}
+.nf
+#OPERATION  TYPE           D C PROGRAM ARG1 ARG2\&.\&.\&.
+#=========  =============  = = ================================
+create      cifs\&.idmap    * * @sbindir@/cifs\&.idmap %k
+.fi
+.if n \{\
+.RE
+.\}
+.PP
+See
+\fBrequest-key.conf5\fR()
+for more info on each field\&.
+.SH "SEE ALSO"
+.PP
+
+\fBrequest-key.conf\fR(5),
+\fBmount.cifs\fR(8)
+.SH "AUTHOR"
+.PP
+Shirish Pargaonkar wrote the cifs\&.idmap program\&.
+.PP
+The
+Linux CIFS Mailing list
+is the preferred place to ask questions regarding these programs\&.
diff --git a/configure.ac b/configure.ac
index 6cac703..d7e21c9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,7 +26,7 @@ AC_ARG_ENABLE(cifsidmap,
 	[AC_HELP_STRING([--enable-cifsidmap],
 			[Create cifs.idmap binary @<:@default=no@:>@])],
 	enable_cifsidmap=$enableval,
-	enable_cifsidmap="no")
+	enable_cifsidmap="maybe")
 
 # Checks for programs.
 AC_PROG_CC
@@ -152,7 +152,7 @@ LIBS=$cu_saved_libs
 
 AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
-AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" = "yes"])
+AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
 
 LIBCAP_NG_PATH
 
-- 
1.6.0.2
