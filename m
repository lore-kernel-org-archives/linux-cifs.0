Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D31EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 18:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjFVSQU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjFVSQT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 14:16:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D721FF0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-666ecf9a081so5585884b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687457778; x=1690049778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7lXteBg2E4gDENb3x9RL2pvskXHgp5VsHkqQb2YtFE=;
        b=Ei83WuwrlqiIP/dYjUGlMSYveEpBXhi4y34VO3zHU1rU4LyZqagXbp18W0PZM1X4CE
         9Ym/mVAbLyjy8Z9o1oU6CH0iEqvxikZ1fx/UoFkXv/lDeKAewuC3ZlYkZCr/Ofiina8U
         oSLNw/rpDqwqhIa/4E20VS1IbnOCBW9cb3rekdKwoT27JtloEIaneKuenG7fXczDTO6t
         6L8Jt02+uZVgvTldur6v83xdGiBY4HLLIfoTRrS1+yB0z0GsokikuntkoKOnDqa+FbDP
         an4mIibmWBWQbVvxhBUJzTUi3eakNTI1PdbyoANY1M62MMyXjNCqcUPLj1egnrGy57EX
         uRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687457778; x=1690049778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7lXteBg2E4gDENb3x9RL2pvskXHgp5VsHkqQb2YtFE=;
        b=ie8VQeDT7LRh9DJSkb8ZbSmC7vWk5Y5njEgireH+3V6mnjvRPTeqtd8TOzKlgWxwX+
         mi2FCCnjB+JKHEE/ovZ4KvoN4wfq4mW0RcIbDRxtZ/KQLmeVzB+uUeFhubME/GgElefN
         Dg9T5CRLE0L6GN5J69dMmg0zWjLFr9AjE/wHFsQKnO2w/YVDi4NyfyY0thLGhNlPvNQ2
         yCVYe8WagxOVcVuO5bcrnBcJzLfVzNjSAnNKKs/OJm7Kh9whBMhAAmP2rpETCoSa0zq5
         M8PcBqls7HHxl4wwtsIg9t3YTCMY/bV5kfYrkmS/pQ0IF9ywYRTvDQ9cFc8fETAkCPQk
         jJCw==
X-Gm-Message-State: AC+VfDzfTiLGKv8JHGP5dGD4XKPWbDxo479MSLl1CWBQwTwUah5vXYh1
        iv3IVdoVD6u8KHn4dV4JsywBMrYZaB9wDCGd
X-Google-Smtp-Source: ACHHUZ5L2/N4O/zJH1piEYGjyPG7slNetWS/WQzQYdjy/p5SwFWLJaFFjhIFnlq8tqp5WVLTJX/VkA==
X-Received: by 2002:a05:6a00:2d0e:b0:668:96c8:a8ee with SMTP id fa14-20020a056a002d0e00b0066896c8a8eemr9781217pfb.30.1687457777923;
        Thu, 22 Jun 2023 11:16:17 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h4-20020aa786c4000000b0064fdf576421sm4996536pfo.142.2023.06.22.11.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 11:16:17 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/3] cifs: prevent use-after-free by freeing the cfile later
Date:   Thu, 22 Jun 2023 18:16:03 +0000
Message-Id: <20230622181604.4788-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622181604.4788-1-sprasad@microsoft.com>
References: <20230622181604.4788-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In smb2_compound_op we have a possible use-after-free
which can cause hard to debug problems later on.

This was revealed during stress testing with KASAN enabled
kernel. Fixing it by moving the cfile free call to
a few lines below, after the usage.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
CC: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 163a03298430..7e3ac4cb4efa 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -398,9 +398,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					rsp_iov);
 
  finished:
-	if (cfile)
-		cifsFileInfo_put(cfile);
-
 	SMB2_open_free(&rqst[0]);
 	if (rc == -EREMCHG) {
 		pr_warn_once("server share %s deleted\n", tcon->tree_name);
@@ -529,6 +526,9 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		break;
 	}
 
+	if (cfile)
+		cifsFileInfo_put(cfile);
+
 	if (rc && err_iov && err_buftype) {
 		memcpy(err_iov, rsp_iov, 3 * sizeof(*err_iov));
 		memcpy(err_buftype, resp_buftype, 3 * sizeof(*err_buftype));
-- 
2.34.1

