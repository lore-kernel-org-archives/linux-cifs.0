Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A210FC2B9F4
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 08:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65206610A3
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 08:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhFQInw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:43:52 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8253 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQInv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 04:43:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5FlX2WJdz1BNSb;
        Thu, 17 Jun 2021 16:36:40 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 16:41:42 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 16:41:42 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] cifs: remove unnecessary oom message
Date:   Thu, 17 Jun 2021 16:41:22 +0800
Message-ID: <20210617084122.1117-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 fs/cifs/cifsencrypt.c | 4 +---
 fs/cifs/connect.c     | 6 +-----
 fs/cifs/sess.c        | 6 +-----
 fs/cifs/smb2pdu.c     | 2 --
 4 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index b8f1ff9a83f3..74f16730e502 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -787,10 +787,8 @@ calc_seckey(struct cifs_ses *ses)
 	get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
 
 	ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
-	if (!ctx_arc4) {
-		cifs_dbg(VFS, "Could not allocate arc4 context\n");
+	if (!ctx_arc4)
 		return -ENOMEM;
-	}
 
 	arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
 	arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 05f5c84a63a4..b52bb6dc6ecb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -97,10 +97,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	len = strlen(server->hostname) + 3;
 
 	unc = kmalloc(len, GFP_KERNEL);
-	if (!unc) {
-		cifs_dbg(FYI, "%s: failed to create UNC path\n", __func__);
+	if (!unc)
 		return -ENOMEM;
-	}
 	scnprintf(unc, len, "\\\\%s", server->hostname);
 
 	rc = dns_resolve_server_name_to_ip(unc, &ipaddr);
@@ -1758,8 +1756,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	if (is_domain && ses->domainName) {
 		ctx->domainname = kstrdup(ses->domainName, GFP_KERNEL);
 		if (!ctx->domainname) {
-			cifs_dbg(FYI, "Unable to allocate %zd bytes for domain\n",
-				 len);
 			rc = -ENOMEM;
 			kfree(ctx->username);
 			ctx->username = NULL;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index cd19aa11f27e..cc97b2981c3d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -602,10 +602,8 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	if (tilen) {
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cifs_dbg(VFS, "Challenge target info alloc failure\n");
+		if (!ses->auth_key.response)
 			return -ENOMEM;
-		}
 		ses->auth_key.len = tilen;
 	}
 
@@ -1338,8 +1336,6 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
-			 msg->sesskey_len);
 		rc = -ENOMEM;
 		goto out_put_spnego_key;
 	}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c205f93e0a10..2b978564e188 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1355,8 +1355,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
-			cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
-				 msg->sesskey_len);
 			rc = -ENOMEM;
 			goto out_put_spnego_key;
 		}
-- 
2.25.1


