From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifsidmap: clean up comments on API description
Date: Tue,  8 Jan 2013 10:04:56 -0500
Message-ID: <1357657496-15867-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...typo and grammatical fixes, mostly.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifsidmap.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/cifsidmap.h b/cifsidmap.h
index 656df86..3c074ae 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -129,11 +129,11 @@ struct cifs_uxid {
  * This function should map an array of struct cifs_sids to an array of
  * struct cifs_uxids.
  *
- * Returns 0 if at least one conversion was successful and success and
- * non-zero on error. Any that were not successfully converted will have a
- * cuxid->type of CIFS_UXID_TYPE_UNKNOWN.
+ * Returns 0 if at least one conversion was successful and non-zero on error.
+ * Any that were not successfully converted will have a cuxid->type of
+ * CIFS_UXID_TYPE_UNKNOWN.
  *
- * On error, the plugin should reset the errmsg pointer passed to the
+ * On any error, the plugin should reset the errmsg pointer passed to the
  * init_plugin function to an error string. The caller will not free the error
  * string.
  *
@@ -151,10 +151,10 @@ struct cifs_uxid {
  *
  * This function should map an array of cifs_uxids an array of struct cifs_sids.
  * Returns 0 if at least one conversion was successful and non-zero on error.
- * Any sids that were not successfully converted will have a revision number of
- * 0.
+ * Any sids that were not successfully converted should have their revision
+ * number set to 0.
  *
- * On error, the plugin should reset the errmsg pointer passed to the
+ * On any error, the plugin should reset the errmsg pointer passed to the
  * init_plugin function to an error string. The caller will not free the error
  * string.
  *
-- 
1.7.11.7
