Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3918DF6D
	for <linux-cifs@vger.kernel.org>; Fri, 16 May 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747408956; cv=none; b=FYxs1aHgBdwlUSNvvrUipsrsKw2Fho8yOeXfNK9lQ9+TF5wYxDcfJfvHI9IRN0r+j0B5c0ufj/fddQVtIy7F9zEoUA6bJMDXGfrVw7fgYgVZbB5JupT/hvcwd+CTFDabpJBJDVEjrRX4oRHwXIm8FZtqEgvL100SL6UWMJci7mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747408956; c=relaxed/simple;
	bh=aADVUwF4leSkw560T6QGOFHoWPfxdIYw+hWriDneMO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fFNpYbSto0NE6Fgl3PN/1cBhD5M+KCH0KGQhPb5wSs9Fy7nvVBbFEFUqdtWUKBwYP6EmmoI/YTey3xKCNiUygaZaL7iS/e1HQ7K7Tybp6vIIFodhqk82ibAXtF/pYtbstCA4sgZSWXN84tXgepGlE7hk2x17AN/jMjUNQdADqR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from lenovo-93812.smb.basealt.ru (unknown [193.43.9.250])
	(Authenticated sender: alekseevamo)
	by air.basealt.ru (Postfix) with ESMTPSA id 3CDF22337B;
	Fri, 16 May 2025 18:22:32 +0300 (MSK)
From: Maria Alexeeva <alxvmr@altlinux.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	pc@manguebit.com
Cc: Maria Alexeeva <alxvmr@altlinux.org>,
	Ivan Volchenko <ivolchenko86@gmail.com>
Subject: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS module to work with domain-based dfs resources with Kerberos authentication
Date: Fri, 16 May 2025 19:22:01 +0400
Message-ID: <20250516152201.201385-1-alxvmr@altlinux.org>
X-Mailer: git-send-email 2.42.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Paths to domain-based dfs resources are defined using the domain name
of the server in the format:
\\DOMAIN.NAME>\<dfsroot>\<path>

The CIFS module, when requesting a TGS, uses the server name
(<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
It then composes an SPN that does not match any entities
in the domain because it is the domain name itself.

To eliminate this behavior, a hostname option is added, which is
the name of the server to connect to and is used in composing the SPN.
In the future this option will be used in the cifs-utils development.

Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
---
 fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
 fs/smb/client/fs_context.h |  3 +++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a634a34d4086..74de0a9de664 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("password2", Opt_pass2),
 	fsparam_string("ip", Opt_ip),
 	fsparam_string("addr", Opt_ip),
+	fsparam_string("hostname", Opt_hostname),
 	fsparam_string("domain", Opt_domain),
 	fsparam_string("dom", Opt_domain),
 	fsparam_string("srcaddr", Opt_srcaddr),
@@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 		return -ENOENT;
 	}
 
+	if (ctx->got_opt_hostname) {
+		kfree(ctx->server_hostname);
+		ctx->server_hostname = ctx->opt_hostname;
+		pr_notice("changing server hostname to name provided in hostname= option\n");
+	}
+
 	if (!ctx->got_ip) {
 		int len;
-		const char *slash;
 
-		/* No ip= option specified? Try to get it from UNC */
-		/* Use the address part of the UNC. */
-		slash = strchr(&ctx->UNC[2], '\\');
-		len = slash - &ctx->UNC[2];
+		/*
+		 * No ip= option specified? Try to get it from server_hostname
+		 * Use the address part of the UNC parsed into server_hostname
+		 * or hostname= option if specified.
+		 */
+		len = strlen(ctx->server_hostname);
 		if (!cifs_convert_address((struct sockaddr *)&ctx->dstaddr,
-					  &ctx->UNC[2], len)) {
+					  ctx->server_hostname, len)) {
 			pr_err("Unable to determine destination address\n");
 			return -EHOSTUNREACH;
 		}
@@ -1518,6 +1526,21 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		ctx->got_ip = true;
 		break;
+	case Opt_hostname:
+		if (strnlen(param->string, CIFS_NI_MAXHOST) == CIFS_NI_MAXHOST) {
+			pr_warn("host name too long\n");
+			goto cifs_parse_mount_err;
+		}
+
+		kfree(ctx->opt_hostname);
+		ctx->opt_hostname = kstrdup(param->string, GFP_KERNEL);
+		if (ctx->opt_hostname == NULL) {
+			cifs_errorf(fc, "OOM when copying hostname string\n");
+			goto cifs_parse_mount_err;
+		}
+		cifs_dbg(FYI, "Host name set\n");
+		ctx->got_opt_hostname = true;
+		break;
 	case Opt_domain:
 		if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
 				== CIFS_MAX_DOMAINNAME_LEN) {
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 9e83302ce4b8..cf0478b1eff9 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -184,6 +184,7 @@ enum cifs_param {
 	Opt_pass,
 	Opt_pass2,
 	Opt_ip,
+	Opt_hostname,
 	Opt_domain,
 	Opt_srcaddr,
 	Opt_iocharset,
@@ -214,6 +215,7 @@ struct smb3_fs_context {
 	bool gid_specified;
 	bool sloppy;
 	bool got_ip;
+	bool got_opt_hostname;
 	bool got_version;
 	bool got_rsize;
 	bool got_wsize;
@@ -226,6 +228,7 @@ struct smb3_fs_context {
 	char *domainname;
 	char *source;
 	char *server_hostname;
+	char *opt_hostname;
 	char *UNC;
 	char *nodename;
 	char workstation_name[CIFS_MAX_WORKSTATION_LEN];

base-commit: bec6f00f120ea68ba584def5b7416287e7dd29a7
-- 
2.42.2

