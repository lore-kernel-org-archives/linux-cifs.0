From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH v4 1/4] cifs.upcall: convert two flags from int to bool
Date: Wed, 15 Feb 2017 11:15:19 -0500
Message-ID: <20170215161522.17063-2-jlayton@samba.org>
References: <20170215161522.17063-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215161522.17063-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 8f146c92b4a5..418b179d7f29 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -685,7 +685,8 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	unsigned int have;
 	long rc = 1;
-	int c, try_dns = 0, legacy_uid = 0;
+	int c;
+	bool try_dns = false, legacy_uid = false;
 	char *buf;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
@@ -705,7 +706,7 @@ int main(const int argc, char *const argv[])
 			/* legacy option -- skip it */
 			break;
 		case 't':
-			try_dns++;
+			try_dns = true;
 			break;
 		case 'k':
 			if (setenv("KRB5_CONFIG", optarg, 1) != 0) {
@@ -717,7 +718,7 @@ int main(const int argc, char *const argv[])
 			keytab_name = optarg;
 			break;
 		case 'l':
-			legacy_uid++;
+			legacy_uid = true;
 			break;
 		case 'v':
 			rc = 0;
@@ -899,7 +900,7 @@ retry_new_hostname:
 		if (rc)
 			break;
 
-		try_dns = 0;
+		try_dns = false;
 		host = hostbuf;
 		goto retry_new_hostname;
 	default:
-- 
2.9.3
