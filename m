From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs-utils: mention the kernel version that introduced setcifsacl
Date: Tue, 18 Oct 2011 12:06:25 +0530
Message-ID: <4E9D1E69.6060408@suse.de>
Reply-To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 setcifsacl.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/setcifsacl.8.in b/setcifsacl.8.in
index 98ab0ac..a18b3de 100644
--- a/setcifsacl.8.in
+++ b/setcifsacl.8.in
@@ -68,6 +68,9 @@ type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (0x5), OBJECT_DENIED (0x6)
 flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these values.
 .PP
 mask: Either one of FULL, CHANGE, READ, a combination of R W X D P O, or a hex value
+.SH "NOTES"
+.PP
+Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
 .SH "SEE ALSO"
 .PP
 \fBmount.cifs\fR(8),
