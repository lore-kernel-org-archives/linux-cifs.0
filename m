From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] setcifsacl: fix infinite loop in getnumcaces
Date: Tue, 29 Jan 2013 07:17:29 -0500
Message-ID: <1359461849-9164-1-git-send-email-jlayton@samba.org>
Cc: jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jian pointed out that this loop can cycle infinitely when the string
contains a ','.

Also, fix typo in manpage that shows a trailing ',' in one example.

Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.1.in | 2 +-
 setcifsacl.c    | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.1.in b/setcifsacl.1.in
index 5ede36a..d53a6ec 100644
--- a/setcifsacl.1.in
+++ b/setcifsacl.1.in
@@ -94,7 +94,7 @@ Set an ACL
 .br
 setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
 .br
-ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
+ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL" <file_name>
 .PP
 .SH "NOTES"
 .PP
diff --git a/setcifsacl.c b/setcifsacl.c
index 211c1af..7f92b91 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -642,8 +642,10 @@ get_numcaces(const char *aces)
 	const char *current;
 
 	current = aces;
-	while((current = strchr(current, ',')))
+	while((current = strchr(current, ','))) {
+		++current;
 		++num;
+	}
 
 	return num;
 }
-- 
1.7.11.7
