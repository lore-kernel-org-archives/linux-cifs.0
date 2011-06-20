From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Add uid/gid to SID mapping functions (try #2)
Date: Mon, 20 Jun 2011 17:01:35 -0500
Message-ID: <1308607295-17087-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add functions to map a uid and gid to a SID.  These functions are
similar to SID to uid and gid mapping functions.

When cifs module make a upcall with an id (in response to a chown
command), an user name associated with that id is obtained.
The user name is looked up using winbind call and if it exists,
the uid returned by winbind is used to obtain SID and if successful,
that SID is returned to the cifs module.

This exercise is needed because it is possible that a user with the
same name exists at both the client and server and we do not want to
change ownership of a file at the server with an SID (winbind
returns a fabricated one for users that it does not recongize
with an authority value of 22 and RID as uid/gid) for an id that
does not exist at the server.

So for an example, there is a user abc with id 1001 and a user
with the same name but with a different SID at the server,
if a command such as
 chown abc <file_on_a_mapped_share_from_server>
is attempted, code successfully maps the name abc of the user on
the server to e.g. 10001 (assuming we have an entry like
idmap uid = 10000-20000 in the smb.conf file), obtains a SID for
that user abc on the server instead of the one like S-1-22-1001
that would have returned by winbind using the scheme above and
stores the mapping of 1001 and that valid SID.

If user attempts a command like this
 chown 10001 <file_on_a_mapped_share_from_server>
a new mapping is also stored for id 10001 and the same valid SID.

What I am not 100% sure is whether to generate and store a
mapping for 1001 (local id) to SID eventhough it is coded that way right now.
Without it, for every  chown abc  command, we would end up making
an upcall. The order of databases in /etc/nsswitch.conf file dicatates
to which id a user name is resolved, e.g. 
	passwd: compat winbind
would always resolve id for user abc to 1001.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 cifs.idmap.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 56edb58..aaab063 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -40,8 +40,12 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <limits.h>
+#include <pwd.h>
+#include <grp.h>
 #include <wbclient.h>
 
+#define INVAV 22 /* This is an invalid authority value */
+
 static const char *prog = "cifs.idmap";
 
 static void usage(void)
@@ -79,8 +83,10 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 	uid_t uid = 0;
 	gid_t gid = 0;;
 	wbcErr rc = 1;
-	char *sidstr = NULL;
+	char *idstr, *sidstr;
 	struct wbcDomainSid sid;
+	struct passwd *pswdptr, *winpswdptr;
+	struct group *grpptr, *wingrpptr;
 
 	/*
 	 * Use winbind to convert received string to a SID and lookup
@@ -134,6 +140,75 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		goto cifs_idmap_ret;
 	}
 
+	idstr = strget(key_descr, "oi:");
+	if (idstr) {
+		uid = atoi(idstr);
+		pswdptr = getpwuid(uid);
+		if (pswdptr) {
+			rc = wbcGetpwnam(pswdptr->pw_name, &winpswdptr);
+			if (rc)
+				syslog(LOG_ERR, "%s: Invalid user: %s",
+						__func__, pswdptr->pw_name);
+			else {
+				rc = wbcUidToSid(winpswdptr->pw_uid, &sid);
+				if (rc)
+					syslog(LOG_ERR, "uid %d to SID err: %d",							winpswdptr->pw_uid, rc);
+			}
+		} else
+			syslog(LOG_ERR, "%s: Invalid uid: %d with error: %s",
+					__func__, uid, strerror(errno));
+		if (!rc) { /* uid has been mapped to a SID */
+			if (sid.id_auth[5] == INVAV) {
+				syslog(LOG_ERR, "%s: Invalid uid %d",
+						__func__, uid);
+				rc = 1; 
+				goto cifs_idmap_ret;
+			}
+			rc = keyctl_instantiate(key, &sid,
+					sizeof(struct wbcDomainSid), 0);
+			if (rc)
+				syslog(LOG_ERR, "%s: key inst: %s",
+					__func__, strerror(errno));
+		}
+
+		goto cifs_idmap_ret;
+	}
+
+	idstr = strget(key_descr, "gi:");
+	if (idstr) {
+		gid = atoi(idstr);
+		grpptr = getgrgid(gid);
+		if (grpptr) {
+			rc = wbcGetgrnam(grpptr->gr_name, &wingrpptr);
+			if (rc)
+				syslog(LOG_ERR, "%s: Invalid user: %s",
+						__func__, grpptr->gr_name);
+			else {
+				rc = wbcGidToSid(wingrpptr->gr_gid, &sid);
+				if (rc)
+					syslog(LOG_ERR, "gid %d to SID err: %d",							wingrpptr->gr_gid, rc);
+			}
+		} else
+			syslog(LOG_ERR, "%s: Invalid gid: %d with error: %s",
+					__func__, gid, strerror(errno));
+		if (!rc) { /* gid has been mapped to a SID */
+			if (sid.id_auth[5] == INVAV) {
+				syslog(LOG_ERR, "%s: Invalid gid %d",
+						__func__, gid);
+				rc = 1; 
+				goto cifs_idmap_ret;
+			}
+			rc = keyctl_instantiate(key, &sid,
+					sizeof(struct wbcDomainSid), 0);
+			if (rc)
+				syslog(LOG_ERR, "%s: key inst: %s",
+					__func__, strerror(errno));
+		}
+
+		goto cifs_idmap_ret;
+	}
+
+
 	syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
 
 cifs_idmap_ret:
-- 
1.6.0.2
