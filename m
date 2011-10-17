From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs-utils: mention the required kernel version to make cifs.idmap
 work
Date: Mon, 17 Oct 2011 17:33:47 +0530
Message-ID: <4E9C19A3.8010009@suse.de>
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

.. properly in the "NOTES" section.

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 cifs.idmap.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
index f2fa3b2..7adfdc6 100644
--- a/cifs.idmap.8.in
+++ b/cifs.idmap.8.in
@@ -76,6 +76,9 @@ create      cifs\&.idmap     * * @sbindir@/cifs\&.idmap %k
 See
 \fBrequest-key.conf\fR(5)
 for more info on each field\&.
+.SH "NOTES"
+.PP
+For cifs.idmap to work properly you would need a kernel version 3.0 or above.
 .SH "SEE ALSO"
 .PP
 
