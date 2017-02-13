From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH] cifs.upcall: convert several flags from int to bool
Date: Mon, 13 Feb 2017 09:46:59 -0500
Message-ID: <20170213144659.10812-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index cc9ecf0d1fed..e94087cec9dd 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -810,7 +810,8 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	unsigned int have;
 	long rc = 1;
-	int c, try_dns = 0, legacy_uid = 0, env_probe = 0;
+	int c;
+	bool try_dns = false, legacy_uid = false, env_probe = false;
 	char *buf;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
@@ -833,10 +834,10 @@ int main(const int argc, char *const argv[])
 			break;
 		case 'e':
 			/* do an environmental probe to get the credcache */
-			env_probe++;
+			env_probe = true;
 			break;
 		case 't':
-			try_dns++;
+			try_dns = true;
 			break;
 		case 'k':
 			if (setenv("KRB5_CONFIG", optarg, 1) != 0) {
@@ -848,7 +849,7 @@ int main(const int argc, char *const argv[])
 			keytab_name = optarg;
 			break;
 		case 'l':
-			legacy_uid++;
+			legacy_uid = true;
 			break;
 		case 'v':
 			rc = 0;
@@ -1071,7 +1072,7 @@ retry_new_hostname:
 		if (rc)
 			break;
 
-		try_dns = 0;
+		try_dns = false;
 		host = hostbuf;
 		goto retry_new_hostname;
 	default:
-- 
2.9.3
