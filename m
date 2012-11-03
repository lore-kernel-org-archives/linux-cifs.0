From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 06/17] setcifsacl: fix up getopt() usage
Date: Sat,  3 Nov 2012 08:50:23 -0400
Message-ID: <1351947034-18876-7-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

'?' has a special meaning in getopt(). It means that the option
character was not recognized. You can override that behavior by making
':' the first character of the optstring, but that wasn't done here. I'm
not sure what the effect of having '?' in the actual optstring is in
this case, but it's probably best not to put it in there.

Remove '?' from the optstring and replace it 'h'. Also add '-h' as a
valid option to the manpage.

'-v' doesn't require an argument, so fix the optstring to reflect that.

Finally declare a new variable to hold optarg. Currently we only call
getopt() once, which is a little odd. Eventually we may want to make it
call it more than once, in which case we'll need some way to store the
optarg on each pass.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.1 |  4 ++++
 setcifsacl.c | 25 +++++++++++++++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/setcifsacl.1 b/setcifsacl.1
index 550d23d..3dd755c 100644
--- a/setcifsacl.1
+++ b/setcifsacl.1
@@ -30,6 +30,10 @@ This tool is part of the cifs-utils suite\&.
 setcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to alter an ACL of a security descriptor for a file system object.  It is best utilized when an option of cifsacl is specified when mounting a cifs share in conjunction with winbind facility of Samba suite.  Whether a security descriptor to be set is applied or not is determined by the CIFS/SMB server.
 .SH "OPTIONS"
 .PP
+-h
+.RS 4
+Print usage message and exit.
+.RE
 \-v
 .RS 4
 Print version number and exit\&.
diff --git a/setcifsacl.c b/setcifsacl.c
index 71b065c..4c09345 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -779,7 +779,7 @@ main(const int argc, char *const argv[])
 	int i, rc, c, numcaces, numfaces;
 	enum setcifsacl_actions maction = ActUnknown;
 	ssize_t attrlen, bufsize = BUFSIZE;
-	char *filename, *attrval, **arrptr = NULL;
+	char *ace_list, *filename, *attrval, **arrptr = NULL;
 	struct cifs_ctrl_acl *daclptr = NULL;
 	struct cifs_ace **cacesptr = NULL, **facesptr = NULL;
 	struct cifs_ntsd *ntsdptr = NULL;
@@ -788,43 +788,49 @@ main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	c = getopt(argc, argv, "v:D:M:a:S:?");
+	c = getopt(argc, argv, "hvD:M:a:S:");
 	switch (c) {
-	case 'v':
-		printf("Version: %s\n", VERSION);
-		goto out;
 	case 'D':
 		maction = ActDelete;
+		ace_list = optarg;
 		break;
 	case 'M':
 		maction = ActModify;
+		ace_list = optarg;
 		break;
 	case 'a':
 		maction = ActAdd;
+		ace_list = optarg;
 		break;
 	case 'S':
 		maction = ActSet;
+		ace_list = optarg;
 		break;
-	case '?':
+	case 'h':
 		setcifsacl_usage();
 		return 0;
+	case 'v':
+		printf("Version: %s\n", VERSION);
+		return 0;
 	default:
-		break;
+		setcifsacl_usage();
+		return -1;
 	}
 
+	/* We expect 1 argument in addition to the option */
 	if (argc != 4) {
 		setcifsacl_usage();
 		return -1;
 	}
 	filename = argv[3];
 
-	numcaces = get_numcaces(optarg);
+	numcaces = get_numcaces(ace_list);
 	if (!numcaces) {
 		printf("%s: No valid ACEs specified\n", __func__);
 		return -1;
 	}
 
-	arrptr = parse_cmdline_aces(optarg, numcaces);
+	arrptr = parse_cmdline_aces(ace_list, numcaces);
 	if (!arrptr)
 		goto setcifsacl_numcaces_ret;
 
@@ -878,7 +884,6 @@ cifsacl:
 		printf("%s: setxattr error: %s\n", __func__, strerror(errno));
 	goto setcifsacl_facenum_ret;
 
-out:
 	return 0;
 
 setcifsacl_action_ret:
-- 
1.7.11.7
