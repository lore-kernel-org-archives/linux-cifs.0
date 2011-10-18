From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: move SEE ALSO section in setcifsacl.1 nearer to bottom
Date: Tue, 18 Oct 2011 07:22:49 -0400
Message-ID: <1318936969-8475-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The convention is to have that close to the bottom of the manpage. In
this case, we want it after the EXAMPLES section.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.1 |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/setcifsacl.1 b/setcifsacl.1
index be8af0c..8957512 100644
--- a/setcifsacl.1
+++ b/setcifsacl.1
@@ -68,12 +68,6 @@ type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (0x5), OBJECT_DENIED (0x6)
 flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these values.
 .PP
 mask: Either one of FULL, CHANGE, READ, a combination of R W X D P O, or a hex value
-.SH "SEE ALSO"
-.PP
-\fBmount.cifs\fR(8),
-\fBwinbindd\fR(8),
-\fBgetcifsacl\fR(1)
-.PP
 .SH "EXAMPLES"
 .PP
 Add an ACE
@@ -95,6 +89,12 @@ setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
 .br
 ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
 .PP
+.SH "SEE ALSO"
+.PP
+\fBmount.cifs\fR(8),
+\fBwinbindd\fR(8),
+\fBgetcifsacl\fR(1)
+.PP
 .SH "AUTHOR"
 .PP
 Shirish Pargaonkar wrote the setcifsacl program\&.
-- 
1.7.6.4
