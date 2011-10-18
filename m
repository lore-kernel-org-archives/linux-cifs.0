From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs-utils: mention the kernel version that introduced getcifsacl
Date: Tue, 18 Oct 2011 12:06:13 +0530
Message-ID: <4E9D1E5D.4020603@suse.de>
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
 getcifsacl.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/getcifsacl.8.in b/getcifsacl.8.in
index 02e1355..f79f7ff 100644
--- a/getcifsacl.8.in
+++ b/getcifsacl.8.in
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
