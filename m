From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/7] cifs.idmap: add a --help option for cifs.idmap
Date: Sat, 27 Oct 2012 07:20:22 -0400
Message-ID: <1351336822-16425-8-git-send-email-jlayton@samba.org>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To make it print the usage message and exit.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.idmap.8.in |  7 ++++++-
 cifs.idmap.c    | 10 ++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
index 152046b..c022402 100644
--- a/cifs.idmap.8.in
+++ b/cifs.idmap.8.in
@@ -22,7 +22,7 @@
 cifs.idmap \- Userspace helper for mapping ids for Common Internet File System (CIFS)
 .SH "SYNOPSIS"
 .HP \w'\ 'u
-cifs.idmap [--timeout|-t] [--version|-v] {keyid}
+cifs.idmap [--help|-h] [--timeout|-t] [--version|-v] {keyid}
 .SH "DESCRIPTION"
 .PP
 This tool is part of the cifs-utils suite\&.
@@ -46,6 +46,11 @@ cifs\&.idmap works in conjuction with winbind facility of Samba suite to map own
 In case winbind and cifs.idmap facilities are unavailable, file objects in a mounted share are assigned uid and gid of the credentials of the process that mounted the share\&. So it is strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs respectively in case services of winbind and cifs.idmap facility are unavailable\&.
 .SH "OPTIONS"
 .PP
+--help|-h
+.RS
+Print the usage message and exit.
+.RE
+.PP
 --timeout|-t
 .RS 4
 Set the expiration timer, in seconds on the key. The default is 600 seconds (10 minutes). Setting this to 0 will cause the key to never expire.
diff --git a/cifs.idmap.c b/cifs.idmap.c
index 0d51ff6..6e71efd 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -45,6 +45,7 @@
 static const char *prog = "cifs.idmap";
 
 static const struct option long_options[] = {
+	{"help", 0, NULL, 'h'},
 	{"timeout", 1, NULL, 't'},
 	{"version", 0, NULL, 'v'},
 	{NULL, 0, NULL, 0}
@@ -52,7 +53,7 @@ static const struct option long_options[] = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: %s key_serial\n", prog);
+	fprintf(stderr, "Usage: %s [-h] [-v] [-t timeout] key_serial\n", prog);
 }
 
 char *strget(const char *str, const char *substr)
@@ -226,8 +227,13 @@ int main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	while ((c = getopt_long(argc, argv, "t:v", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "ht:v",
+					long_options, NULL)) != -1) {
 		switch (c) {
+		case 'h':
+			rc = 0;
+			usage();
+			goto out;
 		case 't':
 			timeout = atoi(optarg);
 			break;
-- 
1.7.11.7
