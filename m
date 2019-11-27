Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015E0C43141
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD16320665
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="hz3z/UQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfK0Ahd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:33 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16248 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfK0Ahd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:33 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E3FCA80A28;
        Wed, 27 Nov 2019 00:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ix0Iktx0qBl5olZaVTf2RZcQs3IqaAZGabXBU25Eldw=;
        b=hz3z/UQK2p0xW10cyLp2A4U9YWcf/rUO79Ab2RgEwzXXpXd6C2dGj4rQUS/bJa9Xr9L6/E
        NUuXO2Bwd0sR2XuiVWsA29NZs7JbGLjhSJE0RupKHOfCo1zYP9qNwlKIXqNsZPIruiVAzP
        WJjPLt7LDg7yLI+lcIRXN4FjTksYfivcFXes4xebmSTaRQBLWbJ9Y9/X1fRh8m6izJL2IJ
        cZeXcL1HfJist7uCM9bHrqOnns1wodZLBVjeFlwyE5ATugKPhBd1UfvzLITnadz3agbOyJ
        XHN8rkNSDMBiM9Wgjf82prS2xzWPnl7KjeHjCX3N9yBieozEJFcdz01+MNJl8Q==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v3 11/11] cifs: Always update signing key of first channel
Date:   Tue, 26 Nov 2019 21:36:34 -0300
Message-Id: <20191127003634.14072-12-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Update signing key of first channel whenever generating the master
sigining/encryption/decryption keys rather than only in cifs_mount().

This also fixes reconnect when re-establishing smb sessions to other
servers.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 86501239cef5..387c88704c52 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -407,6 +407,10 @@ generate_smb3signingkey(struct cifs_ses *ses,
 				  SMB3_SIGN_KEY_SIZE);
 		if (rc)
 			return rc;
+
+		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+		       SMB3_SIGN_KEY_SIZE);
+
 		rc = generate_key(ses, ptriplet->encryption.label,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
-- 
2.24.0

