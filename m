Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E76C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 12:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3C4613C3
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 12:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhEDMot (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 May 2021 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhEDMot (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 May 2021 08:44:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4187C061574;
        Tue,  4 May 2021 05:43:53 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t18so9271672wry.1;
        Tue, 04 May 2021 05:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UkcPfOw1zL7OvDlpQg+xfIeD/O5P0yQ5Qy64lO5GzLE=;
        b=cYGmmOIL0DZvq0tOcTQpB6OosRqnot+QaUnl0KYl+CG77yzYbkAaerHcRzXja5Xhr1
         lS8xJhxjpAzhKvgWXfWhb+q9ZezccnHFUwm2cU1UuQry//iJUl2XAyVmxqeIyd1shS/f
         UbLGgUnWbv43d6fjU9plVAo7QcXFHyJJZ4wN/Dizsqs/rBlMDOPbYzWsYHMD70HJnGv0
         xJ9rGFQiU0grCfgMgh/Q0MCHUvzkPGdjRGNx4prjKwtucYTITy3UfSdhWzZ7SNt6EoNM
         KXSev60Cv33V4ecm6ZYtrlsUQb9QN+7w21equ4WgQaRddF8WBp7DTeH2BcDxjjkn3pPl
         0mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UkcPfOw1zL7OvDlpQg+xfIeD/O5P0yQ5Qy64lO5GzLE=;
        b=Oqok33nEbDIFl4danWfJ9rKA81uHUuJQzt1Uo4r4wTbcwHlEN0nB2Z9TRjf4RftRwm
         Qod5heiHLPbG6FYJ5XH7l5Iw01nNH6/pfcht/4dFjsLsCp908cx+LVbyby0Tlav+UdK6
         U6PfHLYexqxzzIhqFsHKPeEBe/BX6CQ8g8g7pNh6Y4a+eygAPFOKKrbCvBbjiPDsHCu2
         7jZcC465FcXUk/wculbhns0+0euJagj2EiLVftJPEKvAuGP2VMHSzGE+tqwJeBiz68dM
         VYx5okIPsXD6xZQb6APdTwQBJohcv7+SJ0m834RMBAUlMaFI8/SNgWLvcgcabYOBFBzF
         pwKA==
X-Gm-Message-State: AOAM532asTrSgoK/yJ6gFNt3y4v80puxwkuscJlhe3oas6AAi398ssMs
        UmTLdz9bmnpVZPDKoUcDINo=
X-Google-Smtp-Source: ABdhPJwBEUAltlS9MdL420XVTKnQOM1FVxbisDjEDRdT/oObO9i972dnrB9jZUTfEYQ3frGwvXLvPw==
X-Received: by 2002:a5d:53c3:: with SMTP id a3mr14349476wrw.376.1620132232466;
        Tue, 04 May 2021 05:43:52 -0700 (PDT)
Received: from localhost.localdomain ([197.2.237.199])
        by smtp.gmail.com with ESMTPSA id f25sm16627965wrd.67.2021.05.04.05.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 05:43:52 -0700 (PDT)
From:   Khaled ROMDHANI <khaledromdhani216@gmail.com>
To:     sfrench@samba.org
Cc:     Khaled ROMDHANI <khaledromdhani216@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH-next] fs/cifs: Fix resource leak
Date:   Tue,  4 May 2021 13:43:43 +0100
Message-Id: <20210504124343.22611-1-khaledromdhani216@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The -EIO error return path is leaking memory allocated
to page. Fix this by invoking the free_dentry_path before
the return.

Addresses-Coverity: ("Resource leak")
Signed-off-by: Khaled ROMDHANI <khaledromdhani216@gmail.com>
---
 fs/cifs/link.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 1cbe7ec73728..1485c6095ba1 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -686,8 +686,10 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
 	void *page = alloc_dentry_path();
 	struct inode *newinode = NULL;
 
-	if (unlikely(cifs_forced_shutdown(cifs_sb)))
+	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
+		free_dentry_path(page);
 		return -EIO;
+	}
 
 	xid = get_xid();
 
-- 
2.17.1

