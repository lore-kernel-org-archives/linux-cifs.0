From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: require a uid= or creduid= parm
Date: Mon, 26 Jul 2010 13:05:28 -0400
Message-ID: <1280163930-983-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Even though all known kernels send the uid= parm to userspace,
cifs.upcall doesn't technically require it. It should though. If one
wasn't sent for some reason, then the setuid wouldn't occur. Error out
if there is no uid= or creduid= parm.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 1f4341d..8f7850a 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -707,6 +707,11 @@ int main(const int argc, char *const argv[])
 			goto out;
 		}
 		ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, arg.uid);
+	} else {
+		/* no uid= or creduid= parm -- something is wrong */
+		syslog(LOG_ERR, "No uid= or creduid= parm specified");
+		rc = 1;
+		goto out;
 	}
 
 	host = arg.hostname;
-- 
1.7.1.1
