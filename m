From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/8] cifs-utils: cifsacl utilities: Add man pages for setcifsacl (try #5)
Date: Tue, 23 Aug 2011 14:04:10 -0500
Message-ID: <1314126250-12061-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Man pages for utility setcifsacl.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 setcifsacl.8.in |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)
 create mode 100644 setcifsacl.8.in

diff --git a/setcifsacl.8.in b/setcifsacl.8.in
new file mode 100644
index 0000000..98ab0ac
--- /dev/null
+++ b/setcifsacl.8.in
@@ -0,0 +1,104 @@
+'\" t
+.\"     Title: cifs.idmap
+.\"    Author: [see the "AUTHOR" section]
+.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
+.\"      Date: 08/19/2011
+.\"    Manual: System Administration tools
+.\"    Source: cifs-utils 4.0
+.\"  Language: English
+.\"
+.TH "SETCIFSACL" "8" "08/19/2011" "cifs-utils 4\&.0" "System Administration tools"
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
+setcifsacl \- Userspace helper to alter an ACL in a security descriptor for Common Internet File System (CIFS)
+.SH "SYNOPSIS"
+.HP \w'\ 'u
+setcifsacl [\-v|\-a|\-D|\-M|\-S] "{one or more ACEs}" {file system object}
+.SH "DESCRIPTION"
+.PP
+This tool is part of the cifs-utils suite\&.
+.PP
+setcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to alter an ACL of a security descriptor for a file system object.  It is best utilized when an option of cifsacl is specified when mounting a cifs share in conjunction with winbind facility of Samba suite.  Whether a security descriptor to be set is applied or not is determined by the CIFS/SMB server.
+.SH "OPTIONS"
+.PP
+\-v
+.RS 4
+Print version number and exit\&.
+.RE
+\-a
+.RS 4
+Add one or more ACEs to an ACL of a security descriptor.
+An ACE is added even if the same ACE exists in the ACL.
+.RE
+\-D
+.RS 4
+Delete one or more ACEs from an ACL of a security descriptor.
+Entire ACE has to match in an existing ACL for the listed ACEs to be deleted.
+.RE
+\-M
+.RS 4
+Modify one or more ACEs from an ACL of a security descriptor.
+SID and type are used to match for existing ACEs to be modified with the list of ACEs specified.
+.RE
+\-S
+.RS 4
+Set an ACL of security descriptor with the list of ACEs
+Existing ACL is replaced entirely with the specified ACEs.
+.RE
+.PP
+Every ACE entry starts with "ACL:"
+One or more ACEs are specified within double quotes.
+Multiple ACEs are separated by a comma.
+.PP
+Following fields of an ACE can be modified with possible values:
+.PP
+SID: Either a name or a raw SID value.
+.PP
+type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (0x5), OBJECT_DENIED (0x6)
+.PP
+flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these values.
+.PP
+mask: Either one of FULL, CHANGE, READ, a combination of R W X D P O, or a hex value
+.SH "SEE ALSO"
+.PP
+\fBmount.cifs\fR(8),
+\fBwinbindd\fR(8),
+\fBgetcifsacl\fR(8)
+.PP
+.SH "EXAMPLES"
+.PP
+Add an ACE
+.br
+setcifsacl -a "ACL:CIFSTESTDOM\\user2:DENIED/0x1/D" <file_name>
+setcifsacl -a "ACL:CIFSTESTDOM\\user1:ALLOWED/OI|CI|NI/D" <file_name>
+.PP
+Delete an ACE
+.br
+setcifsacl -D "ACL:S-1-1-0:0x1/OI/0x1201ff" <file_name>
+.PP
+Modify an ACE
+.br
+setcifsacl -M "ACL:CIFSTESTDOM\\user1:ALLOWED/0x1f/CHANGE" <file_name>
+.PP
+Set an ACL
+.br
+setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
+.br
+ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
+.PP
+.SH "AUTHOR"
+.PP
+Shirish Pargaonkar wrote the setcifsacl program\&.
+.PP
+The
+Linux CIFS Mailing list
+is the preferred place to ask questions regarding these programs\&.
-- 
1.6.0.2
