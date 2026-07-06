Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE4938238A
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351942; cv=none; b=ia0mIPFy/t+3aSOh0bTCO2QDoFcJV8mgJh8auoiSFuqlMTnP27NyV7pOPymSuv0oN3Yh59aOSAOrskxX5JKqHkk6oyRUgS+9xSFnssjPfdWWZiSt+kAbb/bEMMILsux8X6WMFGyNDx17KewsLoIdjERp9Vmhh3V0koYOznz8Ka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351942; c=relaxed/simple;
	bh=MykPx35h1Xhip2EcE9vUK0mgW1rF9OQSiTX5JuE0RfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FYVueT9eZUUjpU/EZMAORtO9Dz8xaCQHqX3WhBaN50p99gCheSzejl321sbDx614yb9TZ6yA5YiLsU/N/sO0AV05QkCApCQ48oPgsdhezjldkl3BklBVwNajtkchaGHTChkLfmDdt+UXZFrF314nb/+P6gtSBo5j7OiljRJW9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wIJiPdI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8y9i5aCM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wIJiPdI7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8y9i5aCM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wIJiPdI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8y9i5aCM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wIJiPdI7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8y9i5aCM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7923E73C29;
	Mon,  6 Jul 2026 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783351938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lKQO0UnNznkeSLfUbTjpWkNB56Q0mHHEbnN7ixyL+rM=;
	b=wIJiPdI7RxofbDRS4n5XFHdG45rr1kT9jmRs1znP5UX3n3jtElsn07C9WgrTFZAlX6kgvK
	LvWmeBU/7fBSt9wbCgi5lkC4O4YcxisP6m5sBCoK8VffqiLTfraKqcqnyX9xVebBXIEhU5
	ZZ4uyAwO5z3k+ng/0gSovCsFCrfpiOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783351938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lKQO0UnNznkeSLfUbTjpWkNB56Q0mHHEbnN7ixyL+rM=;
	b=8y9i5aCMEDrKzjudddP0vP70JIIm//02A8FdCSOLElzKRQ6xe+KyEVWyqDf80KLFCv10aK
	W90+/lh/xuElfNAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wIJiPdI7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8y9i5aCM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783351938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lKQO0UnNznkeSLfUbTjpWkNB56Q0mHHEbnN7ixyL+rM=;
	b=wIJiPdI7RxofbDRS4n5XFHdG45rr1kT9jmRs1znP5UX3n3jtElsn07C9WgrTFZAlX6kgvK
	LvWmeBU/7fBSt9wbCgi5lkC4O4YcxisP6m5sBCoK8VffqiLTfraKqcqnyX9xVebBXIEhU5
	ZZ4uyAwO5z3k+ng/0gSovCsFCrfpiOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783351938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lKQO0UnNznkeSLfUbTjpWkNB56Q0mHHEbnN7ixyL+rM=;
	b=8y9i5aCMEDrKzjudddP0vP70JIIm//02A8FdCSOLElzKRQ6xe+KyEVWyqDf80KLFCv10aK
	W90+/lh/xuElfNAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02340779AA;
	Mon,  6 Jul 2026 15:32:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A9AhLoHKS2qAQwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 06 Jul 2026 15:32:17 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	smfrench@gmail.com
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] cifs.upcall: fix regression with krb5 + creduid
Date: Mon,  6 Jul 2026 12:32:12 -0300
Message-ID: <20260706153212.839012-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7923E73C29
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,manguebit.org,gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,manguebit.org:email];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_FIVE(0.00)[5];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Commit 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
introduced a regression when using creduid != uid (e.g.
"mount.cifs -o sec=krb5,cruid=X"), so 'uid' local var is replaced
with procfs "Uid" value (in the example, the one from mount.cifs).

That commit ignored the fact that:
  mount UID can be different from creds UID, and that calling-app
  process (post-mount) can be different from both

This patch "reverts" 972c5b5ff95e ("cifs.upcall: remove getpwuid()
dependency"); transform the "emergency"-added function get_uidgid()
into map_uidgid(), now only used to do NS UID/GID mapping.

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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
v2:
- map_id(): moved 'errno = EINVAL' to the failure blocks and 'errno = 0'
  explicitly into success block, because apparently fscanf() only resets
  errno on glibc
- change range checks and NS mapping to use *idp instead of 'id' (so
  further possible duplicates are found correctly)
- fix errno save/restore on fclose()
- log correct errno if getpwuid() returns NULL; but leaves it as is,
  even if it's 0 (we're exiting anyway)


 cifs.upcall.c | 279 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 177 insertions(+), 102 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 11dbc6186a74..ff5f68f55692 100644
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
@@ -1375,118 +1376,170 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
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
-
-	errno = 0;
-	if (pid < 0 || (!uidp && !gidp)) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	if (uidp)
-		*uidp = INVALID_UIDGID;
+	int ret = 1;
 
-	if (gidp)
-		*gidp = INVALID_UIDGID;
+	errno = EINVAL;
+	if (pid < 0 || !map || !idp || *idp == UINT_MAX)
+		goto out;
 
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
+	id = UINT_MAX;
+	errno = ENODATA;
+	while (fscanf(fp, "%llu %llu %llu", &ns_start, &host_start, &range) == 3) {
+		if (ns_start >= UINT_MAX || host_start >= UINT_MAX ||
+		    range > UINT_MAX || range == 0) {
+			errno = EINVAL;
+			ret = 1;
+			break;
+		}
 
-		errno = ENODATA;
-		if ((!uidp || strncmp(buf, "Uid:", 4)) && (!gidp || strncmp(buf, "Gid:", 4)))
-			continue;
+		if (range == UINT_MAX && (ns_start != 0 || host_start != 0)) {
+			errno = EINVAL;
+			ret = 1;
+			break;
+		}
 
-		errno = 0;
+		if (host_start + range > UINT_MAX) {
+			errno = EINVAL;
+			ret = 1;
+			break;
+		}
 
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
+		if (*idp >= host_start && *idp < host_start + range) {
+			/* This means we found a duplicate */
+			if (!ret) {
+				ret = 1;
+				errno = EOPNOTSUPP;
+				syslog(LOG_ERR, "%s has multiple mapped IDs for %u (unsupported)",
+				       map, *idp);
 				break;
-			continue;
-		}
-
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
+			}
 
-		if ((!uidp || *uidp != INVALID_UIDGID) && (!gidp || *gidp != INVALID_UIDGID)) {
-			errno = 0;
+			id = (*idp - host_start) + ns_start;
 			ret = 0;
-			break;
+			errno = 0;
 		}
 	}
+
+	/* This means errno was reset by fscanf() without finding anything */
+	if (ret && errno == 0)
+		errno = ENODATA;
 out:
-	if (fp)
+	if (fp) {
+		int err = errno;
+
 		fclose(fp);
+		/* Ignore fclose() errors */
+		errno = err;
+	}
 
-	if (ret) {
-		syslog(LOG_DEBUG, "%s(pid=%d): %s", __func__, pid, strerror(errno));
-		if (uidp)
-			*uidp = INVALID_UIDGID;
+	if (!ret) {
+		*idp = id;
+		errno = 0;
+	} else {
+		syslog(LOG_DEBUG, "%s(pid=%d, map=%s, id=%u): %s", __func__, pid, map, *idp,
+		       strerror(errno));
+	}
 
-		if (gidp)
-			*gidp = INVALID_UIDGID;
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
+	if (ret) {
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
 
@@ -1534,6 +1587,7 @@ int main(const int argc, char *const argv[])
 	const char *oid;
 	uid_t uid;
 	gid_t gid;
+	struct passwd *pw;
 	char *keytab_name = NULL;
 	char *env_cachename = NULL;
 	krb5_ccache ccache = NULL;
@@ -1680,12 +1734,52 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	/*
+	 * 'uid' always points to a host UID, so we must get the corresponding host GID.
+	 * It's safe to call getpwuid() here because we're still on host NS, i.e. caller
+	 * application has no control over custom NSS modules.
+	 *
+	 * FIXME: if UID is from another NS, or a subuid, this will fail on mount.
+	 */
+	errno = 0;
+	pw = getpwuid(uid);
+	if (!pw) {
+		syslog(LOG_ERR, "failed to retrieve GID from UID %u: %s", uid,
+		       strerror(errno ?: ENOENT));
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
@@ -1700,25 +1794,6 @@ int main(const int argc, char *const argv[])
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

