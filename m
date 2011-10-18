From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/3] cifs-utils: manpage: mention the kernel version that introduced getcifsacl
Date: Tue, 18 Oct 2011 17:09:01 +0530
Message-ID: <1318937941-11157-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 getcifsacl.1 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/getcifsacl.1 b/getcifsacl.1
index 7ad7f36..ef0a296 100644
--- a/getcifsacl.1
+++ b/getcifsacl.1
@@ -40,6 +40,9 @@ Print version number and exit\&.
 .RS 4
 Display a security descriptor in raw mode. Values such as type and flags are displayed in hexadecimal format, a SID is not mapped to a name.
 .RE
+.SH "NOTES"
+.PP
+Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
 .SH "SEE ALSO"
 .PP
 \fBmount.cifs\fR(8),
