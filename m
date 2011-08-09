From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: Add uid/gid to SID mapping functions (try #3)
Date: Tue,  9 Aug 2011 12:34:05 -0500
Message-ID: <1312911245-22404-1-git-send-email-shirishpargonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add functions to map a uid and gid to a SID.  These functions are
similar to SID to uid and gid mapping functions.
A SID is what is returned to the cifs module.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 cifs.idmap.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/cifs.idmap.c b/cifs.idmap.c
index 56edb58..80802d7 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -134,6 +134,43 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		goto cifs_idmap_ret;
 	}
 
+	sidstr = strget(key_descr, "oi:");
+	if (sidstr) {
+		uid = atoi(sidstr);
+		syslog(LOG_DEBUG, "SID: %s, uid: %d", sidstr, uid);
+		rc = wbcUidToSid(uid, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "uid %d to SID  error: %d", uid, rc);
+		if (!rc) { /* SID has been mapped to a uid */
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
+	sidstr = strget(key_descr, "gi:");
+	if (sidstr) {
+		gid = atoi(sidstr);
+		syslog(LOG_DEBUG, "SID: %s, gid: %d", sidstr, gid);
+		rc = wbcGidToSid(gid, &sid);
+		if (rc)
+			syslog(LOG_DEBUG, "gid %d to SID error: %d", gid, rc);
+		if (!rc) { /* SID has been mapped to a gid */
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
