From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] cifs-utils: mention the kernel version that introduced cifs.idmap
Date: Mon, 17 Oct 2011 17:50:04 +0530
Message-ID: <4E9C1D74.8010204@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

.. in the "NOTES" section.

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 cifs.idmap.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
index f2fa3b2..a6d9ccb 100644
--- a/cifs.idmap.8.in
+++ b/cifs.idmap.8.in
@@ -76,6 +76,9 @@ create      cifs\&.idmap     * * @sbindir@/cifs\&.idmap %k
 See
 \fBrequest-key.conf\fR(5)
 for more info on each field\&.
+.SH "NOTES"
+.PP
+Support for upcalls to cifs.idmap was initially introduced in the 3.0
kernel.
 .SH "SEE ALSO"
 .PP
