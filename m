Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF8FC001DC
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Jul 2023 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGZRCZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Jul 2023 13:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjGZRCU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Jul 2023 13:02:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B513D
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:02:19 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686ba29ccb1so842548b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690390939; x=1690995739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5uww9ZO1evp45inXtXx88FlAcfHMBu6ONhEK8hWeoo=;
        b=YP/+Puo77KAJhzVAhT6IdwwYB0QvDZLPGGkSSjO00U8jemCsKrD0BBaalH7yfKIbeN
         rSRFJi0HMdUgCkKAYoxq79Z1YJYjfu9YdJtRP1Raza4z7GWw+i8609PoiTngoZYften5
         BExMMUSZBnl9FXeUm4khoD26H6vH4LBPKQBtoVmmI1Sq/8846pgYvKXoMPiI4cgFcRI5
         LclJDzYN4bh4VySCJBE/ivgdVHIGU5M6PYQZDpoSij9pCERIE7hB8Auu83IMf0f3w4QL
         BxVO3vmJNwLz5soPQAKfwMBYDWWMjJ9XEu0QrKlY+nlMylTUZcfLnrf2oGs4KcL3upEe
         kADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690390939; x=1690995739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y5uww9ZO1evp45inXtXx88FlAcfHMBu6ONhEK8hWeoo=;
        b=N+oe4XMHWOE25XnELq+9MLNUQwBcTZzzdQ3245SmDAOvBCzpLY1bwSbuywIQz7muBt
         zOcuLD3xcM5tuP2+cx20T+7XY8ti7kfyXug3OLyT5IL02qw9hturx9qgaE5XJNAxevaH
         PkjHuV87BMimEBClwDRBgHly98scC0Ngi4hyWs+npVYxlg4lVMIdGk4XnoQolPIsCFHK
         aJxqg5y5rnyht2b/YlKRONWvQlPVgVDDXd+8IeclkTeVSCO0esoTOW4VSpk/Y1LIXbDL
         WcRCY0ZG8x4SjUW963VEe7hEm/yHWU2tNuzQnDM+ILa6JR8Db7MhOUxxVQrVuHVsKnhY
         SNiA==
X-Gm-Message-State: ABy/qLZfYBWpggMRNJTvqoqpPKOIYFJ4ilFMsr+5bMEppxbnW+2ciKQT
        tTqNtp8SNohdhm3PLPR3qWyCf1jSGyg=
X-Google-Smtp-Source: APBJJlEJIfNWb0fxmJ0HMhdLDPC8Ii2MSRM2qmeTQ6n2oC/ZnflObNmmsDSQYZOGfPFfEGSCPV59Hg==
X-Received: by 2002:a05:6a20:8f01:b0:132:d09f:1716 with SMTP id b1-20020a056a208f0100b00132d09f1716mr112784pzk.2.1690390939053;
        Wed, 26 Jul 2023 10:02:19 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id y11-20020aa7854b000000b006687b41c4dasm11640729pfn.110.2023.07.26.10.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 10:02:18 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     dan.carpenter@linaro.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: add missing return value check for cifs_sb_tlink
Date:   Wed, 26 Jul 2023 17:02:11 +0000
Message-Id: <20230726170211.378839-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

Whenever a tlink is obtained by cifs_sb_tlink, we need
to check that the tlink returned is not an error.
It was missing with the last change here.

Fixes: b3edef6b9cd0 ("cifs: allow dumping keys for directories too")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index e1904b86ed96..f7160003e0ed 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -478,6 +478,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 			cifs_sb = CIFS_SB(inode->i_sb);
 			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink)) {
+				rc = PTR_ERR(tlink);
+				break;
+			}
+
 			tcon = tlink_tcon(tlink);
 			rc = cifs_dump_full_key(tcon, (void __user *)arg);
 			cifs_put_tlink(tlink);
-- 
2.34.1

