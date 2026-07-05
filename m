Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EBA35F193
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783290409; cv=none; b=b12Me6AtMW8ubYylVlThurqLoCRGtgBJcY/7qmyAYJ/CRvwPFsff4qhprhVSbV8NusfI26gMjtllePmys2Ty1FUtJSHQOXtFtZ7PTnY7BtRP/wmghtu18NATq1/Gn/twsYphR2DNm/vwmDSb+AIvbO95kVmnbopKzrOMrfAxIDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783290409; c=relaxed/simple;
	bh=vcCK33VvpoYEFxqI33VRdfWdFshSkGMexqV7CsfnSwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=majn62wT7OvCxQjzrSw2s+wmbEaex1l32juBjwib8FddbSngFsQjSSnh7+fAchlogLmUa/JqMV1FAHVFL3kmTg9oOJ1jKF20Ozzlmc7QT6T+ljR5fqDEbGbp8kmMGZaSDr7FEM5kJdK1SqUOdSxB9BPLezBDnZlmfQ3R8YVGG9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=YJUHA3j6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="YJUHA3j6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=QnlvbEc5Dw8UCJt/Cdg9Xpvl0RU28X6xvTBs/+N0o9Y=; b=YJUHA3j6EIza3bRBHOB+WmGos/
	kU/U97jHWwUBMPhsJTnTGLateGzv/lpjRpH/y6q7X/Siv7DUhTusRdZI35nb8p/JMUZzfqsTyMd4D
	mLlgynLIAfGC9Cv6LPnXrGWeIwdlR+dJkg8Lvp5zSOQ8+nsCHd+Nvg07SE4QgW4sliLuRemQmSp/c
	prDQfhwHmbQMLMhUZXZFfGFashDN9vK2uoybayCiRgXZ51zyTP413X+EPWqwioCkv1WB3ycJJV1jQ
	de50AOfhjX+kYqIPlfXj+/aD9sOf2YSsU1JAX1AON/Wwir1dyoLvlUdPX/SwjpKJm9v8+sD9gJ/MJ
	PclmwedQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wgVIT-00000002jwk-07wX;
	Sun, 05 Jul 2026 19:26:45 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs.upcall: fix regression with krb5 + creduid
Date: Sun,  5 Jul 2026 19:26:44 -0300
Message-ID: <20260705222644.1189288-1-pc@manguebit.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Enzo Matsumiya <ematsumiya@suse.de>

Commit 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
introduced a regression when using creduid != uid (e.g.
"mount.cifs -o sec=krb5,cruid=X"), so 'uid' local var is replaced
with procfs "Uid" value (in the example, the one from mount.cifs).

That commit ignored the fact that:
  mount UID can be different from creds UID, and that calling-app
  process (post-mount) can be different from both

This patch "reverts" 972c5b5ff95e ("cifs.upcall: remove getpwuid()
dependency"); transform the emergencial function get_uidgid() into
map_uidgid(), now only used to do NS UID/GID mapping.

Also add getpwuid() back, but this time called while still on host
namespace, so any possible custom NSS module is ran as allowed by
sysadmin.

Any scenario involving unmapped UIDs or GIDs is unsupported; this
means that any UID:GID in a child user namespace _must_ map back to
a valid and existing host UID:GID.

Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
Reported-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>
---
 cifs.upcall.c | 272 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 170 insertions(+), 102 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 747617790576..8aa0ce605d0c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -52,6 +52,7 @@
 #include <arpa/inet.h>
 #include <ctype.h>
 #include <grp.h>
+#include <pwd.h>
 #include <stdbool.h>
 #include <errno.h>
 #include <sched.h>
@@ -1375,118 +1376,165 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 	return 0;
 }
 
-/* cover worst case/impossible scenarios */
-#define PROC_PID_PATH_MAXLEN	((int)sizeof("/proc/2147483647/status"))
-/* max valid UID/GID is (UINT_MAX - 1) */
-#define INVALID_UIDGID		UINT_MAX
+#define ID_MAP_PATH_MAX ((int)sizeof("/proc/2147483647/uid_map"))
 
-/*
- * get_uidgid - Get @pid's (real) UID and/or GID.
- * @pid: process to get UID/GID from
- * @uidp: pointer to store @pid's UID (can be NULL)
- * @gidp: pointer to store @pid's GID (can be NULL)
- *
- * Extract "Uid:" and "Gid:" fields from /proc/@pid/status.
- * Do so based on whether @uidp or @gidp are NULL.
- *
- * This function assumes we're on the same namespace as @pid.
- *
- * Return: 0 on success, -1 otherwise (errno set).
- *
- * On errors, *@uidp and *@gidp are set to INVALID_UIDGID.
- */
-static int get_uidgid(pid_t pid, uid_t *uidp, gid_t *gidp)
+static int map_id(pid_t pid, const char *map, unsigned int *idp)
 {
-	char path[PROC_PID_PATH_MAXLEN] = {}, buf[256];
+	unsigned long long ns_start, host_start, range;
+	char map_path[ID_MAP_PATH_MAX];
+	int map_path_size = sizeof(map_path);
+	unsigned int id;
 	FILE *fp = NULL;
-	int ret;
+	int ret = 1;
 
-	errno = 0;
-	if (pid < 0 || (!uidp && !gidp)) {
-		errno = EINVAL;
-		return -1;
-	}
+	errno = EINVAL;
+	if (pid < 0 || !map || !idp || *idp == UINT_MAX)
+		goto out;
 
-	if (uidp)
-		*uidp = INVALID_UIDGID;
-
-	if (gidp)
-		*gidp = INVALID_UIDGID;
-
-	ret = snprintf(path, PROC_PID_PATH_MAXLEN, "/proc/%d/status", pid);
-	if (ret < 0 || ret >= PROC_PID_PATH_MAXLEN) {
-		if (!errno)
+	ret = snprintf(map_path, map_path_size, "/proc/%d/%s", pid, map);
+	if (ret < 0 || ret >= map_path_size) {
+		if (ret >= map_path_size)
 			errno = ENAMETOOLONG;
-		return -1;
+		ret = 1;
+		goto out;
 	}
 
-	fp = fopen(path, "r");
-	if (!fp) {
-		ret = -1;
+	ret = 1;
+	fp = fopen(map_path, "r");
+	if (!fp)
 		goto out;
-	}
 
-	/* Parse /proc/pid/status fields */
-	errno = 0;
-	ret = -1;
-	while (fgets(buf, 256, fp)) {
-		unsigned long long val;
+	/*
+	 * The map files have the same format:
+	 *   <NS ID start> <host ID start> <range>
+	 *   ... (<multiple entries are supported) ...
+	 *
+	 * Formula and validation:
+	 *   <final NS ID> = (*@idp - <host ID start>) + <NS ID start>
+	 *
+	 * - IDs: [0, UINT_MAX - 1]
+	 * - range: [1, UINT_MAX], where range == UINT_MAX requires both ID ranges to start at 0,
+	 *   which then means this is an init host NS mapping (and that's ok)
+	 *
+	 * The formula itself would be enough to "validate" a matching NS ID, but we don't want to
+	 * keep parsing a malformed map file, no matter how unlikely/impossible it is to happen.
+	 * Same reason values are parsed as 'unsigned long long', so we can check for bogus data.
+	 */
+	id = *idp;
+	errno = ENODATA;
+	while (fscanf(fp, "%llu %llu %llu", &ns_start, &host_start, &range) == 3) {
+		errno = EINVAL;
+		if (ns_start >= UINT_MAX || host_start >= UINT_MAX ||
+		    range > UINT_MAX || range == 0)
+			break;
 
-		errno = ENODATA;
-		if ((!uidp || strncmp(buf, "Uid:", 4)) && (!gidp || strncmp(buf, "Gid:", 4)))
-			continue;
+		if (range == UINT_MAX && (ns_start != 0 || host_start != 0))
+			break;
 
-		errno = 0;
+		if (host_start + range > UINT_MAX)
+			break;
 
 		/*
-		 * Example line format (same for both Uid/Gid):
-		 * "Uid:\t%u\t%u\%u\%u"
+		 * Check if host ID fits this line.
+		 * Our desired NS ID may be in any line of the file.
 		 *
-		 * Where the numbers represents:
-		 * <real> <effective> <saved> <fsuid>
+		 * Note: new{uid,gid}map tools (that creates the map files) don't allow multiple
+		 * maps (NS IDs) to the same host ID.
 		 *
-		 * We're only interested in the <real> value.
+		 * If we get a match here, we'll save it, but we continue parsing the file.
+		 * If we happen to find a duplicate, it's possible this is a rogue file trying to
+		 * bypass these checks.
 		 *
-		 * (field names "Uid:"/"Gid:" parsed above, skip it)
+		 * In such cases, discard the match and return EOPNOTSUPP, as returning a
+		 * successful match could lead to disastrous results.
 		 */
-		ret = sscanf(&buf[0] + 4, "%llu", &val);
-		if (ret != 1) {
-			ret = -1;
-			if (errno)
+		if (id >= host_start && id < host_start + range) {
+			/* This means we found a duplicate */
+			if (!ret) {
+				ret = 1;
+				errno = EOPNOTSUPP;
+				syslog(LOG_ERR, "%s has multiple mapped IDs for %u (unsupported)",
+				       map, *idp);
 				break;
-			continue;
-		}
+			}
 
-		ret = -1;
-		if (val >= UINT_MAX) {
-			errno = EINVAL;
-			break;
-		}
-
-		if (uidp && !strncmp(buf, "Uid:", 4))
-			*uidp = (uid_t)val;
-		else
-			*gidp = (gid_t)val;
-
-		if ((!uidp || *uidp != INVALID_UIDGID) && (!gidp || *gidp != INVALID_UIDGID)) {
-			errno = 0;
+			id = (id - host_start) + ns_start;
 			ret = 0;
-			break;
 		}
+
+		errno = ENODATA;
 	}
+
+	if (ret && errno == 0)
+		errno = ENODATA;
 out:
-	if (fp)
+	if (fp) {
+		if (ret)
+			ret = errno;
 		fclose(fp);
+		/* Ignore fclose() errors */
+		if (ret) {
+			errno = ret;
+			ret = 1;
+		}
+	}
 
+	if (!ret) {
+		*idp = id;
+		errno = 0;
+	} else {
+		syslog(LOG_DEBUG, "%s(pid=%d, map=%s, id=%u): %s", __func__, pid, map, *idp,
+		       strerror(errno));
+	}
+
+	return ret;
+}
+
+/*
+ * map_uidgid() - Map (real) UID/GID from init host NS to user NS.
+ * @pid: host NS PID
+ * @uidp: (in) host UID, (out) NS UID
+ * @gidp: (in) host GID, (out) NS GID
+ *
+ * Parse /proc/@pid/{uid,gid}_map files to get NS UID/GID values.
+ * Since @pid is expected to be a host NS PID, this must be called before switching namespaces.
+ *
+ * Note: we can't use /proc/self here because we haven't switched NS yet, so {uid,gid}_map files
+ * would contain host NS values.
+ *
+ * Return: 0 on success, 1 otherwise (errno set).
+ */
+static int map_uidgid(pid_t pid, uid_t *uidp, gid_t *gidp)
+{
+	uid_t orig_uid;
+	gid_t orig_gid;
+	int ret = 1;
+
+	errno = EINVAL;
+	if (!uidp || !gidp)
+		goto out;
+
+	orig_uid = *uidp;
+	orig_gid = *gidp;
+
+	ret = map_id(pid, "uid_map", uidp);
 	if (ret) {
-		syslog(LOG_DEBUG, "%s(pid=%d): %s", __func__, pid, strerror(errno));
-		if (uidp)
-			*uidp = INVALID_UIDGID;
-
-		if (gidp)
-			*gidp = INVALID_UIDGID;
+		if (errno == ENODATA)
+			syslog(LOG_ERR, "UID %u not mapped in this namespace (unsupported)",
+			       orig_uid);
+		goto out;
 	}
 
+	ret = map_id(pid, "gid_map", gidp);
+	if (ret && errno == ENODATA)
+		syslog(LOG_ERR, "GID %u not mapped in this namespace (unsupported)",
+		       orig_gid);
+out:
+	if (ret && errno != ENODATA)
+		syslog(LOG_ERR, "%s: %s", __func__, strerror(errno));
+	else if (!ret)
+		syslog(LOG_DEBUG, "host %u:%u -> NS %u:%u", orig_uid, orig_gid, *uidp, *gidp);
+
 	return ret;
 }
 
@@ -1534,6 +1582,7 @@ int main(const int argc, char *const argv[])
 	const char *oid;
 	uid_t uid;
 	gid_t gid;
+	struct passwd *pw;
 	char *keytab_name = NULL;
 	char *env_cachename = NULL;
 	krb5_ccache ccache = NULL;
@@ -1680,12 +1729,50 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	/*
+	 * 'uid' always points to a host UID, so we must get the corresponding host GID.
+	 * It's safe to call getpwuid() here because we're still on host NS, i.e. caller
+	 * application has no control over custom NSS modules.
+	 *
+	 * FIXME: if UID is from another NS, or a subuid, this will fail on mount.
+	 */
+	pw = getpwuid(uid);
+	if (!pw) {
+		syslog(LOG_ERR, "failed to retrieve gid from uid %u", uid);
+		rc = 1;
+		goto out;
+	}
+
+	gid = pw->pw_gid;
+
+	/*
+	 * We can't reasonably do this for root. When mounting a DFS share,
+	 * for instance we can end up with creds being overridden, but the env
+	 * variable left intact.
+	 *
+	 * Always check this before NS UID mapping.
+	 */
+	if (uid == 0)
+		env_probe = false;
+
 	/*
 	 * Change to the process's namespace. This means that things will work
 	 * acceptably in containers, because we'll be looking at the correct
 	 * filesystem and have the correct network configuration.
 	 */
 	if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
+		/*
+		 * Map host 'uid' and 'gid' to the target user NS.
+		 *
+		 * Any scenario that involves unmapped UIDs or primary GIDs is not supported -- we
+		 * don't have, and can't find, all the info that would be necessary to find a
+		 * UID/GID within all the possible NS combinations.
+		 */
+		if (!in_same_user_ns(arg->pid, getpid())) {
+			rc = map_uidgid(arg->pid, &uid, &gid);
+			if (rc)
+				goto out;
+		}
 		syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
 		arg->upcall_target = UPTARGET_APP;
 		rc = switch_to_process_ns(arg->pid);
@@ -1700,25 +1787,6 @@ int main(const int argc, char *const argv[])
 		syslog(LOG_INFO, "upcall_target=mount, not switching namespaces to application thread");
 	}
 
-	/*
-	 * We can't reasonably do this for root. When mounting a DFS share,
-	 * for instance we can end up with creds being overridden, but the env
-	 * variable left intact.
-	 */
-	if (uid == 0)
-		env_probe = false;
-
-	/*
-	 * FIXME: this only works if we haven't switched PID namespaces.
-	 * If we did, /proc/arg->pid/ might not exist, or worse, point to something else.
-	 */
-	rc = get_uidgid(arg->pid, &uid, &gid);
-	if (rc) {
-		syslog(LOG_ERR, "get_uidgid (NS): %s", strerror(errno));
-		rc = 1;
-		goto out;
-	}
-
 	rc = setgid(gid);
 	if (rc) {
 		syslog(LOG_ERR, "setgid: %s", strerror(errno));
-- 
2.54.0

