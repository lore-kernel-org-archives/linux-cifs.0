Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F5EC46467
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 23:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjAJXgC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjAJXgB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 18:36:01 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EDBB1ED
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 15:35:59 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id BD93B7FC04;
        Tue, 10 Jan 2023 23:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673393757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ECtovnmAmUURqyk3cdJc3eFZcVszgWoDFhKhE+YwmoI=;
        b=mjwjQdfBXS+MO+/y3jfQQMr2U4+q1zwn31vDy2unOGkyAzX6lgADFoq5NU6IUqDDemFLWz
        M4MQpth5kxRmQ0zFH8ERfhIE/+x+p6+F0exv3F8cDQw/ArMIoZKPDynCyY0Hz32l9c9jJx
        5M4Lsh1n2etG3Gno+by5EqMmT7fBrr1bbAbUr+v+U40RHVW3Q5vG+ZgyoVLGkLaUMp+vlm
        zjDLuw2/U4dxpqoy+0kg1ZeIN7hfw41HP1dXxv7r0e2RcSbkRgtBzmycGCGAtPCoaDeP9U
        O5H81PQjwFgVTWDyjAzs2qNFi3EtHNuV7DNUy2+s92ZM/dYCd45zySc0CcXzWQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix potential memory leaks in session setup
Date:   Tue, 10 Jan 2023 20:35:46 -0300
Message-Id: <20230110233546.22910-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make sure to free cifs_ses::auth_key.response before allocating it as
we might end up leaking memory in reconnect or mounting.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsencrypt.c | 1 +
 fs/cifs/sess.c        | 2 ++
 fs/cifs/smb2pdu.c     | 1 +
 3 files changed, 4 insertions(+)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5db73c0f792a..cbc18b4a9cb2 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -278,6 +278,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * ( for NTLMSSP_AV_NB_DOMAIN_NAME followed by NTLMSSP_AV_EOL ) +
 	 * unicode length of a netbios domain name
 	 */
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.len = size + 2 * dlen;
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0b842a07e157..c47b254f0d1e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -815,6 +815,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 		return -EINVAL;
 	}
 	if (tilen) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
@@ -1428,6 +1429,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 727f16b426be..4b71f4a92f76 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1453,6 +1453,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 
 	/* keep session key if binding */
 	if (!is_binding) {
+		kfree_sensitive(ses->auth_key.response);
 		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 						 GFP_KERNEL);
 		if (!ses->auth_key.response) {
-- 
2.39.0

