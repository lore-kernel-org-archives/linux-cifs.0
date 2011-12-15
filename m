From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 10/12] cifscreds: loosen allowed characters in domain names
Date: Thu, 15 Dec 2011 13:12:14 -0500
Message-ID: <1323972736-15804-11-git-send-email-jlayton@samba.org>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As Donald points out, NetBIOS domains are allowed more characters than
the code currently allows. Change the test to one that checks for
disallowed characters instead.

Also, I can't find anything that says that '@' is not allowed in a
username. Might as well allow that too. Worst case, the server will
reject the username.

Reported-by: Donald R. Gray Jr <donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 279517a..cbd431e 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -42,10 +42,13 @@
 #define MOUNT_PASSWD_SIZE 128
 #define MAX_DOMAIN_SIZE 64
 
-/* allowed and disallowed characters for user and domain name */
-#define USER_DISALLOWED_CHARS "\\/\"[]:|<>+=;,?*@"
-#define DOMAIN_ALLOWED_CHARS "abcdefghijklmnopqrstuvwxyz" \
-			     "ABCDEFGHIJKLMNOPQRSTUVWXYZ-."
+/*
+ * disallowed characters for user and domain names. See:
+ * http://technet.microsoft.com/en-us/library/bb726984.aspx
+ * http://support.microsoft.com/kb/909264
+ */
+#define USER_DISALLOWED_CHARS "\\/\"[]:|<>+=;,?*"
+#define DOMAIN_DISALLOWED_CHARS "\\/:*?\"<>|"
 
 /* destination keyring */
 #define DEST_KEYRING KEY_SPEC_USER_KEYRING
@@ -567,7 +570,7 @@ int main(int argc, char **argv)
 		arg.host = argv[optind + 1];
 
 	if (arg.host && arg.keytype == 'd' &&
-	    strspn(arg.host, DOMAIN_ALLOWED_CHARS) != strnlen(arg.host, MAX_DOMAIN_SIZE)) {
+	    strpbrk(arg.host, DOMAIN_DISALLOWED_CHARS)) {
 		fprintf(stderr, "error: Domain name contains invalid characters\n");
 		return EXIT_FAILURE;
 	}
-- 
1.7.1
