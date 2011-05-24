From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: don't syslog usage message
Date: Tue, 24 May 2011 14:53:14 -0400
Message-ID: <1306263194-28647-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 479517c..de92092 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -749,7 +749,6 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 
 static void usage(void)
 {
-	syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", prog);
 	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
 }
 
-- 
1.7.5.1
