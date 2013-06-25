From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] cifs.upcall: allow users to specify dedicated keytab on command-line
Date: Tue, 25 Jun 2013 11:18:48 -0400
Message-ID: <1372173528-9373-1-git-send-email-jlayton@samba.org>
Cc: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently cifs.upcall only looks at the default system keytab
(/etc/krb5.keytab). It's often the case however that a dedicated keytab
is desirable. Allow administrators to set one on the command-line.

Reported-by: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.8.in | 7 ++++++-
 cifs.upcall.c    | 8 ++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
index 3ae0562..50f79d1 100644
--- a/cifs.upcall.8.in
+++ b/cifs.upcall.8.in
@@ -22,7 +22,7 @@
 cifs.upcall \- Userspace upcall helper for Common Internet File System (CIFS)
 .SH "SYNOPSIS"
 .HP \w'\ 'u
-cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-uid|\-l] [--krb5conf=/path/to/krb5.conf|-k /path/to/...] {keyid}
+cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-uid|\-l] [--krb5conf=/path/to/krb5.conf|-k /path/to/krb5.conf] [--keytab=/path/to/keytab|-K /path/to/keytab] {keyid}
 .SH "DESCRIPTION"
 .PP
 This tool is part of the cifs-utils suite\&.
@@ -44,6 +44,11 @@ This option allows administrators to set an alternate location for the
 krb5.conf file that cifs.upcall will use.
 .RE
 .PP
+\--keytab=/path/to/keytab|-K /path/to/keytab
+.RS 4
+This option allows administrators to specify a keytab file to be used. When a user has no credential cache already established, cifs.upcall will attempt to use this keytab to acquire them. The default is the system-wide keytab /etc/krb5.keytab.
+.RE
+.PP
 \-\-trust\-dns|\-t
 .RS 4
 With krb5 upcalls, the name used as the host portion of the service principal defaults to the hostname portion of the UNC\&. This option allows the upcall program to reverse resolve the network address of the server in order to get the hostname\&.
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 6c0b9de..c16bdfd 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -805,13 +805,14 @@ lowercase_string(char *c)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: %s [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
+	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
 }
 
 const struct option long_options[] = {
 	{"krb5conf", 1, NULL, 'k'},
 	{"legacy-uid", 0, NULL, 'l'},
 	{"trust-dns", 0, NULL, 't'},
+	{"keytab", 1, NULL, 'K'},
 	{"version", 0, NULL, 'v'},
 	{NULL, 0, NULL, 0}
 };
@@ -839,7 +840,7 @@ int main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	while ((c = getopt_long(argc, argv, "ck:ltv", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "ck:K:ltv", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			/* legacy option -- skip it */
@@ -853,6 +854,9 @@ int main(const int argc, char *const argv[])
 				goto out;
 			}
 			break;
+		case 'K':
+			keytab_name = optarg;
+			break;
 		case 'l':
 			legacy_uid++;
 			break;
-- 
1.8.1.4
