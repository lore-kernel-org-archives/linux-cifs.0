From: Nalin Dahyabhai <nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] scan /run/user/${UID} for ccaches, too
Date: Tue, 21 Aug 2012 18:56:48 -0400
Message-ID: <20120821225648.GI9511@redhat.com>
References: <20120821225443.GG9511@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120821225443.GG9511-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When scanning for credential caches, check the user's directory under
/run/user first, then fall back to /tmp as we have previously.  Because
we now call find_krb5_cc() twice (once for each directory), we move its
state to be outside of the function.  We also add a substitution
mechanism to make the process of resolving the location of the user's
home directory before searching it a bit more explicable.
---
 cifs.upcall.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 6f95c1c..598a999 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -53,7 +53,8 @@
 #include "cifs_spnego.h"
 
 #define	CIFS_DEFAULT_KRB5_DIR		"/tmp"
-#define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc_"
+#define	CIFS_DEFAULT_KRB5_USER_DIR	"/run/user/%U"
+#define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc"
 #define CIFS_DEFAULT_KRB5_KEYTAB	"/etc/krb5.keytab"
 
 #define	MAX_CCNAME_LEN			PATH_MAX + 5
@@ -258,14 +259,47 @@ icfk_cleanup:
 	return ccname;
 }
 
+/* resolve a pattern to an actual directory path */
+static char *resolve_krb5_dir(const char *pattern, uid_t uid)
+{
+	char name[MAX_CCNAME_LEN];
+	int i;
+	size_t j;
+	for (i = 0, j = 0; (pattern[i] != '\0') && (j < sizeof(name)); i++) {
+		switch (pattern[i]) {
+		case '%':
+			switch (pattern[i + 1]) {
+			case '%':
+				name[j++] = pattern[i];
+				i++;
+				break;
+			case 'U':
+				j += snprintf(name + j, sizeof(name) - j,
+					      "%lu", (unsigned long) uid);
+				i++;
+				break;
+			}
+			break;
+		default:
+			name[j++] = pattern[i];
+			break;
+		}
+	}
+	if ((j > 0) && (j < sizeof(name)))
+		return strndup(name, MAX_CCNAME_LEN);
+	else
+		return NULL;
+}
+
 /* search for a credcache that looks like a likely candidate */
-static char *find_krb5_cc(const char *dirname, uid_t uid)
+static char *find_krb5_cc(const char *dirname, uid_t uid,
+			  char **best_cache, time_t *best_time)
 {
 	struct dirent **namelist;
 	struct stat sbuf;
-	char ccname[MAX_CCNAME_LEN], *credpath, *best_cache = NULL;
+	char ccname[MAX_CCNAME_LEN], *credpath;
 	int i, n;
-	time_t cred_time, best_time = 0;
+	time_t cred_time;
 
 	n = scandir(dirname, &namelist, krb5cc_filter, NULL);
 	if (n < 0) {
@@ -310,7 +344,7 @@ static char *find_krb5_cc(const char *dirname, uid_t uid)
 			continue;
 		}
 
-		if (cred_time <= best_time) {
+		if (cred_time <= *best_time) {
 			syslog(LOG_DEBUG, "%s: %s expires sooner than current "
 			       "best.", __func__, ccname);
 			free(namelist[i]);
@@ -318,14 +352,14 @@ static char *find_krb5_cc(const char *dirname, uid_t uid)
 		}
 
 		syslog(LOG_DEBUG, "%s: %s is valid ccache", __func__, ccname);
-		free(best_cache);
-		best_cache = strndup(ccname, MAX_CCNAME_LEN);
-		best_time = cred_time;
+		free(*best_cache);
+		*best_cache = strndup(ccname, MAX_CCNAME_LEN);
+		*best_time = cred_time;
 		free(namelist[i]);
 	}
 	free(namelist);
 
-	return best_cache;
+	return *best_cache;
 }
 
 static int
@@ -793,12 +827,13 @@ int main(const int argc, char *const argv[])
 	unsigned int have;
 	long rc = 1;
 	int c, try_dns = 0, legacy_uid = 0;
-	char *buf, *ccname = NULL;
+	char *buf, *ccdir = NULL, *ccname = NULL, *best_cache = NULL;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
 	const char *oid;
 	uid_t uid;
 	char *keytab_name = CIFS_DEFAULT_KRB5_KEYTAB;
+	time_t best_time = 0;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -901,7 +936,12 @@ int main(const int argc, char *const argv[])
 		syslog(LOG_ERR, "setuid: %s", strerror(errno));
 		goto out;
 	}
-	ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid);
+	ccdir = resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid);
+	if (ccdir != NULL)
+		find_krb5_cc(ccdir, uid, &best_cache, &best_time);
+	ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache,
+			      &best_time);
+	SAFE_FREE(ccdir);
 
 	/* Couldn't find credcache? Try to use keytab */
 	if (ccname == NULL && arg.username != NULL)
-- 
1.7.11.5
