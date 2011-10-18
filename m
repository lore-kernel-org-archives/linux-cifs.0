From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/3] cifs-utils: manpage: mention the required kernel version to make cifs.idmap work
Date: Tue, 18 Oct 2011 17:08:40 +0530
Message-ID: <1318937920-11112-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 cifs.idmap.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
index 7e3ab1f..efec7b6 100644
--- a/cifs.idmap.8.in
+++ b/cifs.idmap.8.in
@@ -76,6 +76,9 @@ create      cifs\&.idmap     * * @sbindir@/cifs\&.idmap %k
 See
 \fBrequest-key.conf\fR(5)
 for more info on each field\&.
+.SH "NOTES"
+.PP
+Support for upcalls to cifs.idmap was initially introduced in the 3.0 kernel.
 .SH "SEE ALSO"
 .PP
 
