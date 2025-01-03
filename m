Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7121C1AC7
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jan 2025 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735943365; cv=none; b=aWrHRYrHCycSwHDki4datcpDRuM0Vp8d4ut7QVXL085TvEoex1XFnons2TEHn5Aun2+R4i7bztRpCUUEWpymAcH//s8evnY5P1V/yanxnTRRo1uek6dcjQTcQy8veynLD0SROL+xsZIcLNR6OvDkW5hQXK/aJkD23Ktyooxhqjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735943365; c=relaxed/simple;
	bh=KyV78q/IYLA8OV0SwjEvuUIlq1VQOismLBskR3jrq70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAZLbYmlgMlyOL7V+FS4Rn5vkBZ7ht98MjxrHA/DVAsmuBBvGmwDwGsrnptX4kqBu+V/gLHErKG6Fk12Wav3Bn8k6OmC9zzFr3gH+UGPDwhk1KMTnFPN+FxjKGfTV+LYU9YXh/I5NElB0wP7DpBUuyTFEQh5C4L+n95uJHkOIm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=m2UJyPP5; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="m2UJyPP5"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1735943361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPz5FKkx38z1CYegdsq4N3HpyS5qu8iJxq4FTJ06Mac=;
	b=m2UJyPP5BwpuCXPN+E/6FV71gt5h7NEcPUbM6NIWibIu1m/qg+GfQ0b8wX2mkoB+wggiEu
	PFU5NehO6B6+yLAqUqXldLL2N2iP+GPZNj8UgZrhgY2w/kIPvq/sRu2jOiZZ/azu/YZV3+
	hisjVY+94Gjmz9Tu62MNqkzA48+MdowTpTFKmqcZbhIGMWuvsC0IL4HEM5p0f938yb+an2
	IiDm3Ao/F8WxExtzJ3bd4ZFxoWAJlpZ75rT6izh03zFkZAtrVX4NSVoy3nC7AEgkBYLuyj
	6FwxyswlfScSuzL+NREh6qWhDG77pJ59jmLD/JRSqcSSJ5iSeHbyJLunwrLRvQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/4] smb: client: fix DFS mount against old servers with NTLMSSP
Date: Fri,  3 Jan 2025 19:28:57 -0300
Message-ID: <20250103222858.87176-3-pc@manguebit.com>
In-Reply-To: <20250103222858.87176-1-pc@manguebit.com>
References: <20250103222858.87176-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Old Windows servers will return not fully qualified DFS targets by
default as specified in

  MS-DFSC 3.2.5.5 Receiving a Root Referral Request or Link Referral
  Request

    | Servers SHOULD<30> return fully qualified DNS host names of
    | targets in responses to root referral requests and link referral
    | requests.
    | ...
    | <30> Section 3.2.5.5: By default, Windows Server 2003, Windows
    | Server 2008, Windows Server 2008 R2, Windows Server 2012, and
    | Windows Server 2012 R2 return DNS host names that are not fully
    | qualified for targets.

Fix this by converting all NetBIOS host names from DFS targets to
FQDNs and try resolving them first if DNS domain name was provided in
NTLMSSP CHALLENGE_MESSAGE message from previous SMB2_SESSION_SETUP.
This also prevents the client from translating the DFS target
hostnames to another domain depending on the network domain search
order.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h    |  21 +++++++
 fs/smb/client/connect.c     |   5 +-
 fs/smb/client/dfs.c         |  13 ++--
 fs/smb/client/dfs_cache.c   |   3 +-
 fs/smb/client/dns_resolve.c | 118 +++++++++++++++++++++---------------
 fs/smb/client/dns_resolve.h |   3 +-
 fs/smb/client/fs_context.c  |   4 ++
 fs/smb/client/fs_context.h  |   1 +
 fs/smb/client/misc.c        |   3 +-
 9 files changed, 113 insertions(+), 58 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index e5982136e66f..c747b6f9baca 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -828,6 +828,7 @@ struct TCP_Server_Info {
 	 */
 	char *leaf_fullpath;
 	bool dfs_conn:1;
+	char dns_dom[CIFS_MAX_DOMAINNAME_LEN + 1];
 };
 
 static inline bool is_smb1(struct TCP_Server_Info *server)
@@ -2312,4 +2313,24 @@ static inline bool cifs_ses_exiting(struct cifs_ses *ses)
 	return ret;
 }
 
+static inline bool cifs_netbios_name(const char *name, size_t namelen)
+{
+	bool ret = false;
+	size_t i;
+
+	if (namelen >= 1 && namelen <= RFC1001_NAME_LEN) {
+		for (i = 0; i < namelen; i++) {
+			const unsigned char c = name[i];
+
+			if (c == '\\' || c == '/' || c == ':' || c == '*' ||
+			    c == '?' || c == '"' || c == '<' || c == '>' ||
+			    c == '|' || c == '.')
+				return false;
+			if (!ret && isalpha(c))
+				ret = true;
+		}
+	}
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ddcc9e514a0e..d4b571d74191 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -97,7 +97,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	ss = server->dstaddr;
 	spin_unlock(&server->srv_lock);
 
-	rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, NULL);
+	rc = dns_resolve_server_name_to_ip(server->dns_dom, unc,
+					   (struct sockaddr *)&ss, NULL);
 	kfree(unc);
 
 	if (rc < 0) {
@@ -1711,6 +1712,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			goto out_err;
 		}
 	}
+	if (ctx->dns_dom)
+		strscpy(tcp_ses->dns_dom, ctx->dns_dom);
 
 	if (ctx->nosharesock)
 		tcp_ses->nosharesock = true;
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 4647df9e1e3b..09d8808cd2e0 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -9,6 +9,8 @@
 #include "fs_context.h"
 #include "dfs.h"
 
+#define DFS_DOM(ctx) (ctx->dfs_root_ses ? ctx->dfs_root_ses->dns_dom : NULL)
+
 /**
  * dfs_parse_target_referral - set fs context for dfs target referral
  *
@@ -46,8 +48,9 @@ int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_para
 	if (rc)
 		goto out;
 
-	rc = dns_resolve_server_name_to_ip(path, (struct sockaddr *)&ctx->dstaddr, NULL);
-
+	rc = dns_resolve_server_name_to_ip(DFS_DOM(ctx), path,
+					   (struct sockaddr *)&ctx->dstaddr,
+					   NULL);
 out:
 	kfree(path);
 	return rc;
@@ -59,8 +62,9 @@ static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_path)
 	int rc;
 
 	ctx->leaf_fullpath = (char *)full_path;
+	ctx->dns_dom = DFS_DOM(ctx);
 	rc = cifs_mount_get_session(mnt_ctx);
-	ctx->leaf_fullpath = NULL;
+	ctx->leaf_fullpath = ctx->dns_dom = NULL;
 
 	return rc;
 }
@@ -264,7 +268,8 @@ static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
 	int rc = 0;
 
 	if (!ctx->nodfs && ctx->dfs_automount) {
-		rc = dns_resolve_server_name_to_ip(ctx->source, addr, NULL);
+		rc = dns_resolve_server_name_to_ip(NULL, ctx->source,
+						   addr, NULL);
 		if (!rc)
 			cifs_set_port(addr, ctx->port);
 		ctx->dfs_automount = false;
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 541608b0267e..c0a167c869fb 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1114,7 +1114,8 @@ static bool target_share_equal(struct cifs_tcon *tcon, const char *s1)
 	extract_unc_hostname(s1, &host, &hostlen);
 	scnprintf(unc, sizeof(unc), "\\\\%.*s", (int)hostlen, host);
 
-	rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, NULL);
+	rc = dns_resolve_server_name_to_ip(server->dns_dom, unc,
+					   (struct sockaddr *)&ss, NULL);
 	if (rc < 0) {
 		cifs_dbg(FYI, "%s: could not resolve %.*s. assuming server address matches.\n",
 			 __func__, (int)hostlen, host);
diff --git a/fs/smb/client/dns_resolve.c b/fs/smb/client/dns_resolve.c
index 8bf8978bc5d6..83db27f9c8f1 100644
--- a/fs/smb/client/dns_resolve.c
+++ b/fs/smb/client/dns_resolve.c
@@ -20,69 +20,87 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-/**
- * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
- * @unc: UNC path specifying the server (with '/' as delimiter)
- * @ip_addr: Where to return the IP address.
- * @expiry: Where to return the expiry time for the dns record.
- *
- * Returns zero success, -ve on error.
- */
-int
-dns_resolve_server_name_to_ip(const char *unc, struct sockaddr *ip_addr, time64_t *expiry)
+static int resolve_name(const char *name, size_t namelen,
+			struct sockaddr *addr, time64_t *expiry)
 {
-	const char *hostname, *sep;
 	char *ip;
-	int len, rc;
+	int rc;
 
-	if (!ip_addr || !unc)
-		return -EINVAL;
-
-	len = strlen(unc);
-	if (len < 3) {
-		cifs_dbg(FYI, "%s: unc is too short: %s\n", __func__, unc);
-		return -EINVAL;
-	}
-
-	/* Discount leading slashes for cifs */
-	len -= 2;
-	hostname = unc + 2;
-
-	/* Search for server name delimiter */
-	sep = memchr(hostname, '/', len);
-	if (sep)
-		len = sep - hostname;
-	else
-		cifs_dbg(FYI, "%s: probably server name is whole unc: %s\n",
-			 __func__, unc);
-
-	/* Try to interpret hostname as an IPv4 or IPv6 address */
-	rc = cifs_convert_address(ip_addr, hostname, len);
-	if (rc > 0) {
-		cifs_dbg(FYI, "%s: unc is IP, skipping dns upcall: %*.*s\n", __func__, len, len,
-			 hostname);
-		return 0;
-	}
-
-	/* Perform the upcall */
-	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
-		       NULL, &ip, expiry, false);
+	rc = dns_query(current->nsproxy->net_ns, NULL, name,
+		       namelen, NULL, &ip, expiry, false);
 	if (rc < 0) {
 		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
-			 __func__, len, len, hostname);
+			 __func__, (int)namelen, (int)namelen, name);
 	} else {
 		cifs_dbg(FYI, "%s: resolved: %*.*s to %s expiry %llu\n",
-			 __func__, len, len, hostname, ip,
+			 __func__, (int)namelen, (int)namelen, name, ip,
 			 expiry ? (*expiry) : 0);
 
-		rc = cifs_convert_address(ip_addr, ip, strlen(ip));
+		rc = cifs_convert_address(addr, ip, strlen(ip));
 		kfree(ip);
-
 		if (!rc) {
-			cifs_dbg(FYI, "%s: unable to determine ip address\n", __func__);
+			cifs_dbg(FYI, "%s: unable to determine ip address\n",
+				 __func__);
 			rc = -EHOSTUNREACH;
-		} else
+		} else {
 			rc = 0;
+		}
 	}
 	return rc;
 }
+
+/**
+ * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
+ * @dom: optional DNS domain name
+ * @unc: UNC path specifying the server (with '/' as delimiter)
+ * @ip_addr: Where to return the IP address.
+ * @expiry: Where to return the expiry time for the dns record.
+ *
+ * Returns zero success, -ve on error.
+ */
+int dns_resolve_server_name_to_ip(const char *dom, const char *unc,
+				  struct sockaddr *ip_addr, time64_t *expiry)
+{
+	const char *name;
+	size_t namelen, len;
+	char *s;
+	int rc;
+
+	if (!ip_addr || !unc)
+		return -EINVAL;
+
+	cifs_dbg(FYI, "%s: dom=%s unc=%s\n", __func__, dom, unc);
+	if (strlen(unc) < 3)
+		return -EINVAL;
+
+	extract_unc_hostname(unc, &name, &namelen);
+	if (!namelen)
+		return -EINVAL;
+
+	cifs_dbg(FYI, "%s: hostname=%.*s\n", __func__, (int)namelen, name);
+	/* Try to interpret hostname as an IPv4 or IPv6 address */
+	rc = cifs_convert_address(ip_addr, name, namelen);
+	if (rc > 0) {
+		cifs_dbg(FYI, "%s: unc is IP, skipping dns upcall: %*.*s\n",
+			 __func__, (int)namelen, (int)namelen, name);
+		return 0;
+	}
+
+	/*
+	 * If @name contains a NetBIOS name and @dom has been specified, then
+	 * convert @name to an FQDN and try resolving it first.
+	 */
+	if (dom && *dom && cifs_netbios_name(name, namelen)) {
+		len = strnlen(dom, CIFS_MAX_DOMAINNAME_LEN) + namelen + 2;
+		s = kmalloc(len, GFP_KERNEL);
+		if (!s)
+			return -ENOMEM;
+
+		scnprintf(s, len, "%.*s.%s", (int)namelen, name, dom);
+		rc = resolve_name(s, len - 1, ip_addr, expiry);
+		kfree(s);
+		if (!rc)
+			return 0;
+	}
+	return resolve_name(name, namelen, ip_addr, expiry);
+}
diff --git a/fs/smb/client/dns_resolve.h b/fs/smb/client/dns_resolve.h
index 6eb0c15a2440..64c1dd2ad39b 100644
--- a/fs/smb/client/dns_resolve.h
+++ b/fs/smb/client/dns_resolve.h
@@ -14,7 +14,8 @@
 #include <linux/net.h>
 
 #ifdef __KERNEL__
-int dns_resolve_server_name_to_ip(const char *unc, struct sockaddr *ip_addr, time64_t *expiry);
+int dns_resolve_server_name_to_ip(const char *dom, const char *unc,
+				  struct sockaddr *ip_addr, time64_t *expiry);
 #endif /* KERNEL */
 
 #endif /* _DNS_RESOLVE_H */
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 49123f458d0c..5381f05420bc 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -385,6 +385,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
 	new_ctx->leaf_fullpath = NULL;
+	new_ctx->dns_dom = NULL;
 	/*
 	 * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
 	 */
@@ -399,6 +400,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	DUP_CTX_STR(nodename);
 	DUP_CTX_STR(iocharset);
 	DUP_CTX_STR(leaf_fullpath);
+	DUP_CTX_STR(dns_dom);
 
 	return 0;
 }
@@ -1863,6 +1865,8 @@ smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx)
 	ctx->prepath = NULL;
 	kfree(ctx->leaf_fullpath);
 	ctx->leaf_fullpath = NULL;
+	kfree(ctx->dns_dom);
+	ctx->dns_dom = NULL;
 }
 
 void
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index ac6baa774ad3..8813533345ee 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -295,6 +295,7 @@ struct smb3_fs_context {
 	bool dfs_automount:1; /* set for dfs automount only */
 	enum cifs_reparse_type reparse_type;
 	bool dfs_conn:1; /* set for dfs mounts */
+	char *dns_dom;
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index c23d5ba44cae..0d483cd08354 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1189,7 +1189,8 @@ int match_target_ip(struct TCP_Server_Info *server,
 
 	cifs_dbg(FYI, "%s: target name: %s\n", __func__, target + 2);
 
-	rc = dns_resolve_server_name_to_ip(target, (struct sockaddr *)&ss, NULL);
+	rc = dns_resolve_server_name_to_ip(server->dns_dom, target,
+					   (struct sockaddr *)&ss, NULL);
 	kfree(target);
 
 	if (rc < 0)
-- 
2.47.1

