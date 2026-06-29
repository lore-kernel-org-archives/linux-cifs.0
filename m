Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C137FF63
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 20:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782764536; cv=none; b=mf5h5Nt5a1W8+/JWh460+lcebA3THTeQRzVl51bdiFpxXiuxJbEHvytyMPy9K6Id8FD2cco1Mcfww7eCETVP/idl06dxaBZQmmoP2U2loEY31efeRdzRwFcnj7iHyRA9OajjfqH9vPTlOcxdGKXDfv4lRWKcfqAqAEvt1fZQCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782764536; c=relaxed/simple;
	bh=extsBbDksySzyER9Yh5UQXw0x8ciETcX/xCZ41TD0lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXypHpUdYy3+vp4V9HuxaiPRkXNNzR5bFKZP0w7jIVouF9LCvHWkJJuWRQuVQOj5ajAia/yqKngw2PpHD7s2koVjoMclxUfpXMonD94iAA41DE34XdxvBjhO05JhIQF/b/BKHNyyovkIswlNg9rqcJZ6BSlQJ8WYOWwQXBc9JwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B92AB7142A;
	Mon, 29 Jun 2026 20:22:12 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44E84779A8;
	Mon, 29 Jun 2026 20:22:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NydUA/TTQmpJYwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Jun 2026 20:22:12 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 3/3] cifs.upcall: add support for different PID namespaces
Date: Mon, 29 Jun 2026 17:21:45 -0300
Message-ID: <20260629202145.97856-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629202145.97856-1-ematsumiya@suse.de>
References: <20260629202145.97856-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: B92AB7142A
X-Rspamd-Action: no action

Currently, applications are not able to access multiuser mounts from
different PID namespace (e.g. docker/podman containers).

That's because arg->pid is set in the kernel, who uses host PID NS
(init_pid_ns) value, so cifs.upcall fails when opening/parsing
/proc/<arg->pid>/* entries for proper setup (because that path
doesn't exist on the target PID NS, or points to a different task).

Add get_ns_pid() helper to parse the 'NSpid' field from
/proc/<arg->pid>/status (before changing NS) in order to get the
corresponding NS PID.

* Note: nested/shared namespaces are unsupported for now

Changes:
- rename in_same_user_ns() to in_same_ns(); also, it now takes an
  @nsname string to check arbitrary namespace names
- add 'struct pid_status_field' and parse_proc_pid_status() as a
  common helper for get_ns_pid() and get_uidgid()

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 cifs.upcall.c | 296 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 223 insertions(+), 73 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 3f56c69cae28..a233553ad824 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -302,26 +302,25 @@ static struct namespace_file {
 #define NS_PATH_MAXLEN (6 + 10 + 4 + 6 + 1)
 
 /**
- * in_same_user_ns - return true if two processes are in the same user
- *                   namespace.
+ * in_same_ns - Return true if two processes are in the same namespace.
+ * @nsname: namespace name
  * @pid_a: the pid of the first process
  * @pid_b: the pid of the second process
  *
- * Works by comparing the inode numbers for /proc/<pid>/user.
+ * Works by comparing the inode numbers for /proc/<pid>/ns/@nsname.
  */
-static int
-in_same_user_ns(pid_t pid_a, pid_t pid_b)
+static int in_same_ns(const char *nsname, pid_t pid_a, pid_t pid_b)
 {
 	char path[NS_PATH_MAXLEN];
 	ino_t a_ino, b_ino;
 	struct stat st;
 
-	snprintf(path, sizeof(path), NS_PATH_FMT, pid_a, "user");
+	snprintf(path, sizeof(path), NS_PATH_FMT, pid_a, nsname);
 	if (stat(path, &st) != 0)
 		return 0;
 	a_ino = st.st_ino;
 
-	snprintf(path, sizeof(path), NS_PATH_FMT, pid_b, "user");
+	snprintf(path, sizeof(path), NS_PATH_FMT, pid_b, nsname);
 	if (stat(path, &st) != 0)
 		return 0;
 	b_ino = st.st_ino;
@@ -353,7 +352,7 @@ switch_to_process_ns(pid_t pid)
 
 #ifdef CLONE_NEWUSER
 		if (namespace_files[n].nstype == CLONE_NEWUSER
-		    && in_same_user_ns(getpid(), pid)) {
+		    && in_same_ns("user", getpid(), pid)) {
 			/* Switching to the same user namespace is forbidden,
 			   because switching to a user namespace grants all
 			   capabilities in that namespace regardless of uid. */
@@ -1380,6 +1379,72 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 /* max valid UID/GID is (UINT_MAX - 1) */
 #define INVALID_UIDGID		UINT_MAX
 
+struct pid_status_field {
+	const char *name;
+	char *value;
+};
+
+/* Search for @fields[].name in /proc/pid/status, save matching lines in @fields[].value. */
+static int parse_proc_pid_status(pid_t pid, struct pid_status_field *fields, int n)
+{
+	char path[PROC_PID_PATH_MAXLEN] = {}, buf[256];
+	FILE *fp = NULL;
+	int i, ret;
+
+	errno = 0;
+	if (pid < 0 || !fields || n < 1) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	for (i = 0; i < n; i++) {
+		if (!fields[i].name) {
+			errno = EINVAL;
+			return -1;
+		}
+	}
+
+	ret = snprintf(path, PROC_PID_PATH_MAXLEN, "/proc/%d/status", pid);
+	if (ret < 0 || ret >= PROC_PID_PATH_MAXLEN) {
+		if (!errno)
+			errno = ENAMETOOLONG;
+		return -1;
+	}
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+
+	errno = 0;
+	ret = -1;
+	while (fgets(buf, 256, fp)) {
+		for (i = 0; i < n; i++) {
+			size_t len = strlen(fields[i].name);
+
+			if (fields[i].value || strncmp(buf, fields[i].name, len))
+				continue;
+
+			fields[i].value = strdup(buf);
+			if (!fields[i].value)
+				goto out;
+		}
+	}
+out:
+	fclose(fp);
+
+	if (errno)
+		return -1;
+
+	for (i = 0; i < n; i++) {
+		if (!fields[i].value) {
+			errno = ENODATA;
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * get_uidgid - Get @pid's (real) UID and/or GID.
  * @pid: process to get UID/GID from
@@ -1397,94 +1462,161 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
  */
 static int get_uidgid(pid_t pid, uid_t *uidp, gid_t *gidp)
 {
-	char path[PROC_PID_PATH_MAXLEN] = {}, buf[256];
-	FILE *fp = NULL;
+	struct pid_status_field buf[2] = {};
+	unsigned long long val;
 	int ret;
 
 	errno = 0;
-	if (pid < 0 || (!uidp && !gidp)) {
+	if (pid < 0 || !uidp || !gidp) {
 		errno = EINVAL;
 		return -1;
 	}
 
-	if (uidp)
-		*uidp = INVALID_UIDGID;
+	*uidp = INVALID_UIDGID;
+	*gidp = INVALID_UIDGID;
+	buf[0].name = "Uid:";
+	buf[1].name = "Gid:";
 
-	if (gidp)
-		*gidp = INVALID_UIDGID;
+	ret = parse_proc_pid_status(pid, buf, 2);
+	if (ret)
+		goto out;
 
-	ret = snprintf(path, PROC_PID_PATH_MAXLEN, "/proc/%d/status", pid);
-	if (ret < 0 || ret >= PROC_PID_PATH_MAXLEN) {
+	/*
+	 * Example line format (same for both Uid/Gid):
+	 * "Uid:\t%u\t%u\t%u\t%u"
+	 *
+	 * Where the numbers represents:
+	 * <real> <effective> <saved> <fsuid>
+	 *
+	 * We're only interested in the <real> value.
+	 *
+	 * (field names "Uid:"/"Gid:" parsed above, skip it)
+	 */
+	ret = sscanf(buf[0].value + 4, "%llu", &val);
+	if (ret != 1) {
+		ret = -1;
 		if (!errno)
-			errno = ENAMETOOLONG;
-		return -1;
+			errno = ENODATA;
+		goto out;
 	}
 
-	fp = fopen(path, "r");
-	if (!fp) {
+	if (val >= UINT_MAX) {
+		ret = -1;
+		errno = EINVAL;
+		goto out;
+	}
+
+	*uidp = (uid_t)val;
+
+	ret = sscanf(buf[1].value + 4, "%llu", &val);
+	if (ret != 1) {
+		ret = -1;
+		if (!errno)
+			errno = EINVAL;
+		goto out;
+	}
+
+	if (val >= UINT_MAX) {
 		ret = -1;
+		errno = EINVAL;
 		goto out;
 	}
 
-	/* Parse /proc/pid/status fields */
+	*gidp = (gid_t)val;
+	ret = 0;
+out:
+	free(buf[0].value);
+	free(buf[1].value);
+
+	if (ret) {
+		syslog(LOG_DEBUG, "%s(pid=%d): %s", __func__, pid, strerror(errno));
+		*uidp = INVALID_UIDGID;
+		*gidp = INVALID_UIDGID;
+	}
+
+	return ret;
+}
+
+/* cf. kernel's include/threads.h */
+#define PID_MAX		(4 * 1024 * 1024)
+#define INVALID_PID	((pid_t)-1)
+
+/*
+ * get_ns_pid - Map host @pid to target-NS PID.
+ * @pid: host (kernel) PID
+ * @nspidp: pointer to store mapped NS PID
+ *
+ * Note: because /proc/pid/status information is based on the namespace the reader is coming from,
+ * this function must be called _before_ setns() in order to get the PID from the correct PID NS.
+ *
+ * Return: 0 on success, -1 otherwise (errno set).
+ *
+ * On errors, *@nspidp is set to INVALID_PID.
+ */
+static int get_ns_pid(pid_t pid, pid_t *nspidp)
+{
+	struct pid_status_field buf = {};
+	pid_t host_pid, ns_pid;
+	int ret;
+
 	errno = 0;
-	ret = -1;
-	while (fgets(buf, 256, fp)) {
-		unsigned long long val;
+	if (pid < 0 || !nspidp) {
+		errno = EINVAL;
+		return -1;
+	}
 
-		errno = ENODATA;
-		if ((!uidp || strncmp(buf, "Uid:", 4)) && (!gidp || strncmp(buf, "Gid:", 4)))
-			continue;
+	if (in_same_ns("pid", getpid(), pid)) {
+		*nspidp = pid;
+		return 0;
+	}
 
-		errno = 0;
+	*nspidp = INVALID_PID;
+	buf.name = "NSpid:";
 
-		/*
-		 * Example line format (same for both Uid/Gid):
-		 * "Uid:\t%u\t%u\%u\%u"
-		 *
-		 * Where the numbers represents:
-		 * <real> <effective> <saved> <fsuid>
-		 *
-		 * We're only interested in the <real> value.
-		 *
-		 * (field names "Uid:"/"Gid:" parsed above, skip it)
-		 */
-		ret = sscanf(&buf[0] + 4, "%llu", &val);
-		if (ret != 1) {
-			ret = -1;
-			if (errno)
-				break;
-			continue;
-		}
+	ret = parse_proc_pid_status(pid, &buf, 1);
+	if (ret)
+		goto out;
 
+	/*
+	 * NSpid field format:
+	 * "NSpid:\t%d\t%d"
+	 *
+	 * Where the numbers represents:
+	 * (for NS process seen from host NS):
+	 * <host PID> <NS pid>
+	 *
+	 * (for NS process seen from same NS):
+	 * <NS/host pid>
+	 *
+	 * We're only interested in the second value.
+	 * But we still scan the first one so we can check host_pid == @pid.
+	 *
+	 * Note: sscanf() returning 1 is a bug because it means this is being called
+	 * _after_ setns().  Beware.
+	 */
+	ret = sscanf(buf.value + 6, "%d %d", &host_pid, &ns_pid);
+	free(buf.value);
+	if (ret != 2) {
 		ret = -1;
-		if (val >= UINT_MAX) {
+		if (!errno)
 			errno = EINVAL;
-			break;
-		}
-
-		if (uidp && !strncmp(buf, "Uid:", 4))
-			*uidp = (uid_t)val;
-		else
-			*gidp = (gid_t)val;
+		goto out;
+	}
 
-		if ((!uidp || *uidp != INVALID_UIDGID) && (!gidp || *gidp != INVALID_UIDGID)) {
-			errno = 0;
-			ret = 0;
-			break;
-		}
+	if (host_pid < 0 || host_pid >= PID_MAX || host_pid != pid || ns_pid < 0 ||
+	    ns_pid >= PID_MAX) {
+		errno = EINVAL;
+		ret = -1;
+		goto out;
 	}
-out:
-	if (fp)
-		fclose(fp);
 
+	*nspidp = ns_pid;
+	errno = 0;
+	ret = 0;
+out:
 	if (ret) {
 		syslog(LOG_DEBUG, "%s(pid=%d): %s", __func__, pid, strerror(errno));
-		if (uidp)
-			*uidp = INVALID_UIDGID;
-
-		if (gidp)
-			*gidp = INVALID_UIDGID;
+		*nspidp = INVALID_PID;
 	}
 
 	return ret;
@@ -1687,10 +1819,28 @@ int main(const int argc, char *const argv[])
 	 * filesystem and have the correct network configuration.
 	 */
 	if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
-		syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
+		pid_t pid = arg->pid;
+
 		arg->upcall_target = UPTARGET_APP;
-		same_ns = in_same_user_ns(getpid(), arg->pid);
-		rc = switch_to_process_ns(arg->pid);
+		same_ns = in_same_ns("user", getpid(), pid);
+		if (!same_ns)
+			syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
+#ifdef CLONE_NEWPID
+		/*
+		 * arg->pid holds host PID (gotten from kernel).
+		 * If we're going to switch PID namespaces, we need to map the PID from the correct
+		 * target PID NS before switching, so UID/GID are also fetched from the correct NS.
+		 */
+		rc = get_ns_pid(arg->pid, &pid);
+		if (rc) {
+			syslog(LOG_ERR, "get_ns_pid: %s", strerror(errno));
+			rc = 1;
+			goto out;
+		}
+
+		arg->pid = pid;
+#endif /* CLONE_NEWPID */
+		rc = switch_to_process_ns(pid);
 		if (rc == -1) {
 			syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
 			rc = 1;
@@ -1722,8 +1872,8 @@ int main(const int argc, char *const argv[])
 		/*
 		 * For any other case, we need to get UID/GID from procfs.
 		 *
-		 * FIXME: this only works if we haven't switched PID namespaces.
-		 * If we did, /proc/arg->pid/ might not exist, or worse, point to something else.
+		 * If we switched PID namespaces, arg->pid already points to the correct
+		 * NS PID value.
 		 */
 		rc = get_uidgid(arg->pid, &uid, &gid);
 		if (rc) {
-- 
2.54.0

