From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] setcifsacl: add fallback for when plugin can't be loaded
Date: Mon, 15 Jul 2013 10:47:43 -0400
Message-ID: <1373899663-4384-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allow setcifsacl to function even in the case where the plugin can't
be initialized. ID mapping of course won't work, but we can still allow
it to accept "raw" SID strings.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 5 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 4b38459..ce8c137 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -48,6 +48,7 @@ enum setcifsacl_actions {
 };
 
 static void *plugin_handle;
+static bool plugin_loaded;
 
 static void
 copy_cifs_sid(struct cifs_sid *dst, const struct cifs_sid *src)
@@ -534,6 +535,83 @@ verify_ace_mask(char *maskstr, uint32_t *maskval)
 	return 0;
 }
 
+#define AUTHORITY_MASK (~(0xffffffffffffULL))
+
+static int
+raw_str_to_sid(const char *str, struct cifs_sid *csid)
+{
+	const char *p;
+	char *q;
+	unsigned long long x;
+
+	/* Sanity check for either "S-" or "s-" */
+	if ((str[0] != 'S' && str[0] != 's') || (str[1]!='-')) {
+		plugin_errmsg = "SID string does not start with \"S-\"";
+		return -EINVAL;
+	}
+
+	/* Get the SID revision number */
+	p = str + 2;
+	x = strtoull(p, &q, 10);
+	if (x == 0 || x > UCHAR_MAX || !q || *q != '-') {
+		plugin_errmsg = "Invalid SID revision number";
+		return -EINVAL;
+	}
+	csid->revision = (uint8_t)x;
+
+	/*
+	 * Next the Identifier Authority. This is stored in big-endian in a
+	 * 6 byte array. If the authority value is > UINT_MAX, then it should
+	 * be expressed as a hex value.
+	 */
+	p = q + 1;
+	x = strtoull(p, &q, 0);
+	if ((x & AUTHORITY_MASK) || !q || *q !='-') {
+		plugin_errmsg = "Invalid SID authority";
+		return -EINVAL;
+	}
+	csid->authority[5] = (x & 0x0000000000ff);
+	csid->authority[4] = (x & 0x00000000ff00) >> 8;
+	csid->authority[3] = (x & 0x000000ff0000) >> 16;
+	csid->authority[2] = (x & 0x0000ff000000) >> 24;
+	csid->authority[1] = (x & 0x00ff00000000) >> 32;
+	csid->authority[0] = (x & 0xff0000000000) >> 48;
+
+	/* now read the the subauthorities and store as __le32 vals */
+	p = q + 1;
+	csid->num_subauth = 0;
+	while (csid->num_subauth < SID_MAX_SUB_AUTHORITIES) {
+		x = strtoul(p, &q, 10);
+		if (p == q)
+			break;
+		if (x > UINT_MAX) {
+			plugin_errmsg = "Invalid sub authority value";
+			return -EINVAL;
+		}
+		csid->sub_auth[csid->num_subauth++] = htole32((uint32_t)x);
+
+		if (*q != '-')
+			break;
+		p = q + 1;
+	}
+
+	/* IF we ended early, then the SID could not be converted */
+	if (q && *q != '\0') {
+		plugin_errmsg = "Invalid sub authority value";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+setcifsacl_str_to_sid(const char *str, struct cifs_sid *sid)
+{
+	if (plugin_loaded)
+		return str_to_sid(plugin_handle, str, sid);
+	return raw_str_to_sid(str, sid);
+}
+
 static struct cifs_ace **
 build_cmdline_aces(char **arrptr, int numcaces)
 {
@@ -564,7 +642,7 @@ build_cmdline_aces(char **arrptr, int numcaces)
 			goto build_cmdline_aces_ret;
 		}
 
-		if (str_to_sid(plugin_handle, acesid, &cacesptr[i]->sid)) {
+		if (setcifsacl_str_to_sid(acesid, &cacesptr[i]->sid)) {
 			printf("%s: Invalid SID (%s): %s\n", __func__, arrptr[i],
 				plugin_errmsg);
 			goto build_cmdline_aces_ret;
@@ -765,9 +843,11 @@ main(const int argc, char *const argv[])
 	}
 
 	if (init_plugin(&plugin_handle)) {
-		printf("ERROR: unable to initialize idmapping plugin: %s\n",
-			plugin_errmsg);
-		return -1;
+		fprintf(stderr, "WARNING: unable to initialize idmapping "
+				"plugin: %s\n", plugin_errmsg);
+		plugin_loaded = false;
+	} else {
+		plugin_loaded = true;
 	}
 
 	numcaces = get_numcaces(ace_list);
@@ -827,7 +907,8 @@ cifsacl:
 		goto setcifsacl_facenum_ret;
 	}
 
-	exit_plugin(plugin_handle);
+	if (plugin_loaded)
+		exit_plugin(plugin_handle);
 	return 0;
 
 setcifsacl_action_ret:
-- 
1.8.3.1
