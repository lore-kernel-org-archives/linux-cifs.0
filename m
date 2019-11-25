Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5275C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A89F2068E
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="Dl9vmphD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbfKYQ6r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:58:47 -0500
Received: from mx.cjr.nz ([51.158.111.142]:22816 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfKYQ6r (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 11:58:47 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3332680A5A;
        Mon, 25 Nov 2019 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574701125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ix0Iktx0qBl5olZaVTf2RZcQs3IqaAZGabXBU25Eldw=;
        b=Dl9vmphDWDNJCcF4lCEftTt6PXSIVNdWr7Q2F+T0IDmw11uxZR8Qzj5MwlzuYXqtLGFHiT
        2Cr0Lzu20zxNHvGfZjzRSFgiL0/X2tSd30FmtNivt9zcU14PShNsvLZbe0dkyHVfgMuBzc
        tu1nB9ZJsNLNdbaDCznxnuswhrg3lFdXq9HggsRMhSgAncg4eSNlFPkCednRXgXMNsjFPK
        RUxBbD30utqw451B7CrXa32+D9lguphe/j4sLdNLbPPGElTTjphaWO8ODr+zMnwzCCuq2G
        qlfISJbhKlQ4ViRttnA6OuZDbxosuMzNcrGYJxJ3yzshTgwkAHw5u/Frb0bu9A==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com, aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v2 7/7] cifs: Always update signing key of first channel
Date:   Mon, 25 Nov 2019 13:57:58 -0300
Message-Id: <20191125165758.3793-8-pc@cjr.nz>
In-Reply-To: <20191125165758.3793-1-pc@cjr.nz>
References: <20191125165758.3793-1-pc@cjr.nz>
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

