Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF42DEB64D8
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jun 2023 10:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbjFPKqw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jun 2023 06:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345498AbjFPKqi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jun 2023 06:46:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5C2137C6
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 03:39:07 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666ac5b63beso530348b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 03:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686911878; x=1689503878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFwRTsPx/fKZbFo0BvjGltjWzdgasTKdpCqJRJ0WPj0=;
        b=mJ6WYi9vc5Ay5y2+jOvcVnRk2wj7I0EkLiVaUUgoWT5+9ePiPszouTnSIRdMu5iThU
         +gbDbrsQCn00CAWVz3FYpOE+YVYUQX0saWClAYNMMpNWWd67B2puYdlyRwbFDrRak9np
         QAjVAy5L+E4pgatBVQFtOPt9XZYE3WSGrQmpa/0b81a2/GNMyf60PgfLFxdrTM0bQ+sF
         BxVA/OrKbN2niR5Q3Sn6L2z7yPE3iHblfghgXsWJAe0JqC6YMtKI7AY+d6LcQmgysOdi
         /zdxv+HxPRNFF3Ehx06tFGt0HnoiEAUwLC3HYe2dyudRZRhr5DinWOUlcoUVEFofOIKY
         ZkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911878; x=1689503878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFwRTsPx/fKZbFo0BvjGltjWzdgasTKdpCqJRJ0WPj0=;
        b=U/a67L1zaGlKMLK/f1nb7JPu6a/ZXwLUc+j1cyhEzo0VpnPhwHSAZ8gIwQf179MTgg
         8Z7KhmBfmCZV26tTEGDP214pGxTRc7+4cz5Q2VqmtGETFw6/v0mK+EP7tt8M8ldtdZuH
         EsSrORiqT3GyAaA2zlnyTT/4fDBFxVQCECN5DDisZJlZOgbje+gCs+qfktBNch2Txehy
         +Mia+kogzCDnAj9QTB4/q/lLPI0Sqws4HjS9e5Zzhg3wUUznx12V+8LnPnbNA6hmK0Hm
         TdU6vH/liEq2adttDvO0WaBIwixOr3adqkeZtFpeMzWcPMzlbXLn53vR2rf8oh3rtE7C
         VXsg==
X-Gm-Message-State: AC+VfDyORbN1ZJBReYVY+Wq3/DQ8u3TB7Jh8RC/bSR2utqkmfXBd4bVl
        k4PdKcofqwq6dQa7k+P3fxcyLaCzQM64Mg==
X-Google-Smtp-Source: ACHHUZ6ViQxKpq45qUZMbwZ54yAcbcv8iKQjHuwpbC7UUcyH4jGJCOm69+4YQX3nENfOvw29UBrAKA==
X-Received: by 2002:a05:6a20:9381:b0:119:fffb:e37f with SMTP id x1-20020a056a20938100b00119fffbe37fmr2200972pzh.10.1686911878143;
        Fri, 16 Jun 2023 03:37:58 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709027fcf00b001b3d4d74749sm8958129plb.7.2023.06.16.03.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:37:57 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz, ematsumiya@suse.de
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/2] cifs: allow dumping keys for directories too
Date:   Fri, 16 Jun 2023 10:37:46 +0000
Message-Id: <20230616103746.87142-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616103746.87142-1-sprasad@microsoft.com>
References: <20230616103746.87142-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dumping the enc/dec keys is a session wide operation.
And it should not matter if the ioctl was run on
a regular file or a directory.

Currently, we obtain the tcon pointer from the
cifs file handle. But since there's no dir open call
in cifs, this is not populated for dirs.

This change allows dumping of session keys using ioctl
even for directories. To do this, we'll now get the
tcon pointer from the superblock, and not from the file
handle.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/ioctl.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index fff092bbc7a3..e1904b86ed96 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -433,16 +433,21 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 * Dump encryption keys. This is an old ioctl that only
 			 * handles AES-128-{CCM,GCM}.
 			 */
-			if (pSMBFile == NULL)
-				break;
 			if (!capable(CAP_SYS_ADMIN)) {
 				rc = -EACCES;
 				break;
 			}
 
-			tcon = tlink_tcon(pSMBFile->tlink);
+			cifs_sb = CIFS_SB(inode->i_sb);
+			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink)) {
+				rc = PTR_ERR(tlink);
+				break;
+			}
+			tcon = tlink_tcon(tlink);
 			if (!smb3_encryption_required(tcon)) {
 				rc = -EOPNOTSUPP;
+				cifs_put_tlink(tlink);
 				break;
 			}
 			pkey_inf.cipher_type =
@@ -459,6 +464,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				rc = -EFAULT;
 			else
 				rc = 0;
+			cifs_put_tlink(tlink);
 			break;
 		case CIFS_DUMP_FULL_KEY:
 			/*
@@ -470,8 +476,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				rc = -EACCES;
 				break;
 			}
-			tcon = tlink_tcon(pSMBFile->tlink);
+			cifs_sb = CIFS_SB(inode->i_sb);
+			tlink = cifs_sb_tlink(cifs_sb);
+			tcon = tlink_tcon(tlink);
 			rc = cifs_dump_full_key(tcon, (void __user *)arg);
+			cifs_put_tlink(tlink);
 			break;
 		case CIFS_IOC_NOTIFY:
 			if (!S_ISDIR(inode->i_mode)) {
-- 
2.34.1

