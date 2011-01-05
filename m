From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: fix crash when trying to free uninitialized var
Date: Wed,  5 Jan 2011 10:37:31 -0500
Message-ID: <1294241851-10013-1-git-send-email-jlayton@samba.org>
Cc: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If cifs.upcall is passed an invalid argument then it will "goto out".
The decoded_args struct however is uninitialized at that point so it
will usually segfault when trying to free fields in it. Move the
initialization up in the function.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 1ffcd7c..34b0638 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -677,6 +677,7 @@ int main(const int argc, char *const argv[])
 	const char *oid;
 
 	hostbuf[0] = '\0';
+	memset(&arg, 0, sizeof(arg));
 
 	openlog(prog, 0, LOG_DAEMON);
 
@@ -731,8 +732,6 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	memset(&arg, 0, sizeof(arg));
-
 	have = decode_key_description(buf, &arg);
 	SAFE_FREE(buf);
 	if ((have & DKD_MUSTHAVE_SET) != DKD_MUSTHAVE_SET) {
-- 
1.7.3.4
