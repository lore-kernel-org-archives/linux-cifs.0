From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 3/3] cifs-utils: mention the kernel version that introduced setcifsacl
Date: Tue, 18 Oct 2011 17:09:12 +0530
Message-ID: <1318937952-11201-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 setcifsacl.1 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/setcifsacl.1 b/setcifsacl.1
index 8957512..550d23d 100644
--- a/setcifsacl.1
+++ b/setcifsacl.1
@@ -89,6 +89,9 @@ setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
 .br
 ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
 .PP
+.SH "NOTES"
+.PP
+Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
 .SH "SEE ALSO"
 .PP
 \fBmount.cifs\fR(8),
