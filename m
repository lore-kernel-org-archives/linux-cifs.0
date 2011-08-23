From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/8] cifs-utils: cifsacl utilities: Add man pages for getcifsacl (try #2)
Date: Tue, 23 Aug 2011 14:04:04 -0500
Message-ID: <1314126244-12038-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Man pages for utility getcifsacl.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 getcifsacl.8.in |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 getcifsacl.8.in

diff --git a/getcifsacl.8.in b/getcifsacl.8.in
new file mode 100644
index 0000000..02e1355
--- /dev/null
+++ b/getcifsacl.8.in
@@ -0,0 +1,55 @@
+'\" t
+.\"     Title: cifs.idmap
+.\"    Author: [see the "AUTHOR" section]
+.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
+.\"      Date: 08/19/2011
+.\"    Manual: System Administration tools
+.\"    Source: cifs-utils 4.0
+.\"  Language: English
+.\"
+.TH "GETCIFSACL" "8" "08/19/2011" "cifs-utils 4\&.0" "System Administration tools"
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
+getcifsacl \- Userspace helper to display an ACL in a security descriptor for Common Internet File System (CIFS)
+.SH "SYNOPSIS"
+.HP \w'\ 'u
+getcifsacl [\-v|\-r] {file system object}
+.SH "DESCRIPTION"
+.PP
+This tool is part of the cifs-utils suite\&.
+.PP
+getcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to display a security descriptor including ACL for a file system object.  It is best utilized when an option of cifsacl is specified when mounting a cifs share in conjunction with winbind facility of Samba suite.
+.PP
+Fields of an ACE such as SID, type, flags, and mask are displayed separated by /.  Numeric values of type, flags, and mask are displayed in hexadecimal format.
+.SH "OPTIONS"
+.PP
+\-v
+.RS 4
+Print version number and exit\&.
+.RE
+\-r
+.RS 4
+Display a security descriptor in raw mode. Values such as type and flags are displayed in hexadecimal format, a SID is not mapped to a name.
+.RE
+.SH "SEE ALSO"
+.PP
+\fBmount.cifs\fR(8),
+\fBwinbindd\fR(8),
+\fBsetcifsacl\fR(8)
+.PP
+.SH "AUTHOR"
+.PP
+Shirish Pargaonkar wrote the getcifsacl program\&.
+.PP
+The
+Linux CIFS Mailing list
+is the preferred place to ask questions regarding these programs\&.
-- 
1.6.0.2
