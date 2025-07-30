Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DB82DFA40
	for <linux-cifs@vger.kernel.org>; Wed, 30 Jul 2025 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753895127; cv=none; b=P4nmy4AswJs7umW2KZ9gO9UwKae9txJJhDZSKE4uhyU67OxHC0km4CtRUnVhNH0YOj0r8ePwmNQUMhG5NqrhoWuxCEtsZmExIB0f7Pml8iWGuIykMtz5KisO61NxRSsWObgU8B1pd61uJKSMitdTtu4sjQBXGcF5SIERBbS6y7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753895127; c=relaxed/simple;
	bh=4NyCl932uc+wUl36eiKnFxXWtPr0MCNqy6OQDpqLyFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GssfbGt7A/kAskwYknJpC/W9zkagPEAo/I6KkH5z4+tpU2cQo1lXN9xt4LP4T/6QCbI1hFTo1Rgc6aqej0dRgZb9/Q6dgjKOTyi69QElh3IqCLk7g/kGKp5H9Zjku3citFy7yie2+mvlIyJNOQHX9kG1n8I4wolQR0w4R7LF8DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from lenovo-93812.smb.basealt.ru (unknown [193.43.9.250])
	(Authenticated sender: alekseevamo)
	by air.basealt.ru (Postfix) with ESMTPSA id 9CF2523372;
	Wed, 30 Jul 2025 20:05:18 +0300 (MSK)
From: Maria Alexeeva <alxvmr@altlinux.org>
To: smfrench@gmail.com
Cc: pc@manguebit.com,
	linux-cifs@vger.kernel.org,
	ivolchenko86@gmail.com,
	samba-technical@lists.samba.org,
	vt@altlinux.org,
	tom@talpey.com,
	Maria Alexeeva <alxvmr@altlinux.org>
Subject: [PATCH v2] fs/smb/client/fs_context: Add dfs_domain_hostname option for CIFS module to work with domain-based dfs resources with Kerberos authentication
Date: Wed, 30 Jul 2025 21:03:48 +0400
Message-ID: <20250730170348.155781-1-alxvmr@altlinux.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
References: <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Paths to domain-based dfs resources are defined using the domain name
of the server in the format:
\DOMAIN.NAME>\<dfsroot>\<path>

The CIFS module, when requesting a TGS, uses the server name
(<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
It then composes an SPN that does not match any entities
in the domain because it is the domain name itself.

To eliminate this behavior, a dfs_domain_hostname option is added, which is
the name of the server to connect to and is used in composing the SPN.
In the future this option will be used in the cifs-utils development.

Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
---
 fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
 fs/smb/client/fs_context.h |  3 +++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 59ccc2229ab3..27df14ea2ced 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("password2", Opt_pass2),
 	fsparam_string("ip", Opt_ip),
 	fsparam_string("addr", Opt_ip),
+	fsparam_string("dfs_domain_hostname", Opt_dfs_domain_hostname),
 	fsparam_string("domain", Opt_domain),
 	fsparam_string("dom", Opt_domain),
 	fsparam_string("srcaddr", Opt_srcaddr),
@@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 		return -ENOENT;
 	}
 
+	if (ctx->got_dfs_domain_hostname) {
+		kfree(ctx->server_hostname);
+		ctx->server_hostname = ctx->dfs_domain_hostname;
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
+	case Opt_dfs_domain_hostname:
+		if (strnlen(param->string, CIFS_NI_MAXHOST) == CIFS_NI_MAXHOST) {
+			pr_warn("host name too long\n");
+			goto cifs_parse_mount_err;
+		}
+
+		kfree(ctx->dfs_domain_hostname);
+		ctx->dfs_domain_hostname = kstrdup(param->string, GFP_KERNEL);
+		if (ctx->dfs_domain_hostname == NULL) {
+			cifs_errorf(fc, "OOM when copying hostname string\n");
+			goto cifs_parse_mount_err;
+		}
+		cifs_dbg(FYI, "Host name set\n");
+		ctx->got_dfs_domain_hostname = true;
+		break;
 	case Opt_domain:
 		if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
 				== CIFS_MAX_DOMAINNAME_LEN) {
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 9e83302ce4b8..da6193cffd09 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -184,6 +184,7 @@ enum cifs_param {
 	Opt_pass,
 	Opt_pass2,
 	Opt_ip,
+	Opt_dfs_domain_hostname,
 	Opt_domain,
 	Opt_srcaddr,
 	Opt_iocharset,
@@ -214,6 +215,7 @@ struct smb3_fs_context {
 	bool gid_specified;
 	bool sloppy;
 	bool got_ip;
+	bool got_dfs_domain_hostname;
 	bool got_version;
 	bool got_rsize;
 	bool got_wsize;
@@ -226,6 +228,7 @@ struct smb3_fs_context {
 	char *domainname;
 	char *source;
 	char *server_hostname;
+	char *dfs_domain_hostname;
 	char *UNC;
 	char *nodename;
 	char workstation_name[CIFS_MAX_WORKSTATION_LEN];

base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.50.1

