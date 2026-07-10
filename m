Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2845E3DB629
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675076; cv=none; b=cZoS+erxYapDAH7w2cRGuz/j+/94tAsyBtx+TOJ8VNjQw9TcE5nhmod5F5DBf/hlXhM4VjZ20SRIUa5isZldU3w/DWchgkJz0doPbh6stt3HTuyZ5E/I5n0gQUOaK4+fD5zSOklMyQZWMhCupJ9Sc0uI99oKyPqZFA4lrqBHbxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675076; c=relaxed/simple;
	bh=jCCgiBH7Azj5ajL/mZ0CGAkyGtguoCWMmgwjLneF7tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8UlF9kh9hxCuza6GHFbSedYCfPfBTWLUuFN4IKzMdIRgGdJmufFAA065xOPFTBkX7XIE9opeYDBH9pTaubMgwWq05L+Yg1PEu48nf1uuEretiezNRbvxKw3696iJrwkvnMBwAV6WmLqtPAH/eDOrMfPKI4GxpzkUgYc1jBt2n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FB9176398;
	Fri, 10 Jul 2026 09:17:07 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 887E4779BE;
	Fri, 10 Jul 2026 09:17:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yONnHpK4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:06 +0000
From: Samuel Cabrero <scabrero@suse.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de,
	Samuel Cabrero <scabrero@suse.com>
Subject: [PATCH 14/18] smb:client: Cache auth info
Date: Fri, 10 Jul 2026 11:16:33 +0200
Message-ID: <20260710091637.58873-15-scabrero@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710091637.58873-1-scabrero@suse.com>
References: <20260710091637.58873-1-scabrero@suse.com>
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
X-Rspamd-Queue-Id: 2FB9176398
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

Continue reducing dependency from tcon. Now the registration have all
required information to operate on its own and register/unregister as
necessary.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 153 +++++++++++++++++++++++++++++++++++----
 1 file changed, 138 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 7e665b657f8d..6d8e3b94a432 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -30,6 +30,18 @@ struct cifs_swn_reg {
 	bool share_name_notify;
 	bool ip_notify;
 
+	/* Need to keep this information to re-register when reconnecting */
+	enum securityEnum auth_type;
+	union {
+		struct {
+		} kerberos;
+		struct {
+			const char *domain_name;
+			const char *user_name;
+			const char *password;
+		} ntlm;
+	} authinfo;
+
 	struct cifs_tcon *tcon;
 
 	unsigned long check_interval;
@@ -54,7 +66,92 @@ struct cifs_swn_notification {
 	struct cifs_swn_reg *swnreg;
 };
 
-static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
+static int cifs_swn_reg_set_auth(struct cifs_swn_reg *swnreg,
+				 const struct cifs_tcon *tcon)
+{
+	swnreg->auth_type =
+		cifs_select_sectype(tcon->ses->server, tcon->ses->sectype);
+	switch (swnreg->auth_type) {
+	case Kerberos:
+		break;
+	case NTLMv2:
+	case RawNTLMSSP:
+		if (tcon->ses->user_name != NULL) {
+			swnreg->authinfo.ntlm.user_name =
+				kstrdup(tcon->ses->user_name, GFP_KERNEL);
+			if (swnreg->authinfo.ntlm.user_name == NULL)
+				return -ENOMEM;
+		}
+		if (tcon->ses->domainName != NULL) {
+			swnreg->authinfo.ntlm.domain_name =
+				kstrdup(tcon->ses->domainName, GFP_KERNEL);
+			if (swnreg->authinfo.ntlm.domain_name == NULL) {
+				kfree(swnreg->authinfo.ntlm.user_name);
+				return -ENOMEM;
+			}
+		}
+		if (tcon->ses->password != NULL) {
+			swnreg->authinfo.ntlm.password =
+				kstrdup(tcon->ses->password, GFP_KERNEL);
+			if (swnreg->authinfo.ntlm.password == NULL) {
+				kfree(swnreg->authinfo.ntlm.user_name);
+				kfree(swnreg->authinfo.ntlm.domain_name);
+				return -ENOMEM;
+			}
+		}
+		break;
+	default:
+		cifs_dbg(VFS, "%s: secType %d not supported!\n", __func__,
+			 swnreg->auth_type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static bool cifs_swn_str_equal(const char *a, const char *b)
+{
+	if (a == b)
+		return true;
+
+	if (a == NULL || b == NULL)
+		return false;
+
+	return strcmp(a, b) == 0;
+}
+
+static bool cifs_swn_auth_info_equal(const struct cifs_swn_reg *swnreg,
+				     const struct cifs_tcon *tcon)
+{
+	enum securityEnum auth_type =
+		cifs_select_sectype(tcon->ses->server, tcon->ses->sectype);
+	if (swnreg->auth_type != auth_type)
+		return false;
+
+	switch (auth_type) {
+	case Kerberos:
+		break;
+	case NTLMv2:
+	case RawNTLMSSP:
+		if (!cifs_swn_str_equal(tcon->ses->user_name,
+					swnreg->authinfo.ntlm.user_name))
+			return false;
+		if (!cifs_swn_str_equal(tcon->ses->domainName,
+					swnreg->authinfo.ntlm.domain_name))
+			return false;
+		if (!cifs_swn_str_equal(tcon->ses->password,
+					swnreg->authinfo.ntlm.password))
+			return false;
+		break;
+	default:
+		cifs_dbg(VFS, "%s: secType %d not supported!\n", __func__,
+			 auth_type);
+		return false;
+	}
+
+	return true;
+}
+
+static int cifs_swn_auth_info_krb(struct sk_buff *skb)
 {
 	int ret;
 
@@ -65,24 +162,28 @@ static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
 	return 0;
 }
 
-static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
+static int cifs_swn_auth_info_ntlm(struct cifs_swn_reg *swnreg,
+				   struct sk_buff *skb)
 {
 	int ret;
 
-	if (tcon->ses->user_name != NULL) {
-		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_USER_NAME, tcon->ses->user_name);
+	if (swnreg->authinfo.ntlm.user_name != NULL) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_USER_NAME,
+				     swnreg->authinfo.ntlm.user_name);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (tcon->ses->password != NULL) {
-		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_PASSWORD, tcon->ses->password);
+	if (swnreg->authinfo.ntlm.password != NULL) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_PASSWORD,
+				     swnreg->authinfo.ntlm.password);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (tcon->ses->domainName != NULL) {
-		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_DOMAIN_NAME, tcon->ses->domainName);
+	if (swnreg->authinfo.ntlm.domain_name != NULL) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_DOMAIN_NAME,
+				     swnreg->authinfo.ntlm.domain_name);
 		if (ret < 0)
 			return ret;
 	}
@@ -160,6 +261,10 @@ static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
 	else
 		tcon_dstaddr = &tcon->ses->server->dstaddr;
 
+	/* Auth info must match */
+	if (!cifs_swn_auth_info_equal(swnreg, tcon))
+		return false;
+
 	/* Address must always match */
 	if (!cifs_match_ipaddr((struct sockaddr *)&swnreg->addr,
 			       (struct sockaddr *)tcon_dstaddr))
@@ -193,7 +298,6 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg,
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
-	enum securityEnum authtype;
 	int ret;
 
 	skb = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -241,10 +345,9 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg,
 			goto nlmsg_fail;
 	}
 
-	authtype = cifs_select_sectype(tcon->ses->server, tcon->ses->sectype);
-	switch (authtype) {
+	switch (swnreg->auth_type) {
 	case Kerberos:
-		ret = cifs_swn_auth_info_krb(tcon, skb);
+		ret = cifs_swn_auth_info_krb(skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get kerberos auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
@@ -252,14 +355,15 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg,
 		break;
 	case NTLMv2:
 	case RawNTLMSSP:
-		ret = cifs_swn_auth_info_ntlm(tcon, skb);
+		ret = cifs_swn_auth_info_ntlm(swnreg, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
 		}
 		break;
 	default:
-		cifs_dbg(VFS, "%s: secType %d not supported!\n", __func__, authtype);
+		cifs_dbg(VFS, "%s: secType %d not supported!\n", __func__,
+			 swnreg->auth_type);
 		ret = -EINVAL;
 		goto nlmsg_fail;
 	}
@@ -354,6 +458,17 @@ static void cifs_swn_reg_release(struct cifs_swn_reg *swnreg)
 	if (ret < 0)
 		cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
 
+	switch (swnreg->auth_type) {
+	case NTLMv2:
+	case RawNTLMSSP:
+		kfree(swnreg->authinfo.ntlm.user_name);
+		kfree(swnreg->authinfo.ntlm.domain_name);
+		kfree(swnreg->authinfo.ntlm.password);
+		break;
+	default:
+		break;
+	}
+
 	kfree(swnreg->net_name);
 	kfree(swnreg->share_name);
 	kfree(swnreg);
@@ -480,6 +595,13 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 		goto fail_net_name;
 	}
 
+	ret = cifs_swn_reg_set_auth(swnreg, tcon);
+	if (ret != 0) {
+		cifs_dbg(VFS, "%s: failed to set auth info: %d\n", __func__,
+			 ret);
+		goto fail_share_name;
+	}
+
 	/*
 	 * If there is an address stored use it instead of the server address, because we are
 	 * in the process of reconnecting to it after a share has been moved or we have been
@@ -506,7 +628,8 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
 	return swnreg;
-
+fail_share_name:
+	kfree(swnreg->share_name);
 fail_net_name:
 	kfree(swnreg->net_name);
 fail_idr:
-- 
2.54.0

