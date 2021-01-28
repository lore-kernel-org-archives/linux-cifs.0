Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C507C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jan 2021 22:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAC7964DE8
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jan 2021 22:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhA1WzE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jan 2021 17:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhA1Wwq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jan 2021 17:52:46 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58783C061574
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 14:52:31 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u4so6810652ljh.6
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jan 2021 14:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PTuCVZBm6h+0ElCYdoSvc+REUGWHTAVr6T8/qEMHZ4U=;
        b=UNt/L1hAjtyltp+/dTRtAlDm1tFNvmn0liy28JM6Jed9WF8548Y2MAinlhV9eTN+Nb
         ulnpxaVeZIA6VxejBfHXMbA+mLrwDz0zrULrvpQcc8+hYxciWl+DNAqJzKn39h8DVIKp
         PIL6eKg/HTLVto88NHIcFoACTvlkKTeICDozE/FW2j5S/5caXpBiNoZj8CXBwNveeUmi
         bJOc7lX2asZN/hO8BYpddYO8DOa6WO2JmKcmVfhcl39sqlYqgVScMl9Abs/X+k+rNvXZ
         u6MKWaMxASeIbUABK5LbuCOk6ufUxDNpoig4c9ZiNZSDIkGZpTfsdnmI7Ph5pACmFC+6
         2TIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PTuCVZBm6h+0ElCYdoSvc+REUGWHTAVr6T8/qEMHZ4U=;
        b=GKGYOOYdy2KginvLqzaHSGwuMD67EQkcvddqgTwnkVNPXyUcPSs5Uwyn19+zFBsd3l
         bikMsFVFicZ6lkYvNjXQCSihoTXFmgYnt3ay0W5BoWjE746NRU+rkWllCAj5zMu/4pBO
         b1MgxQGCvotvchAUxtMI52sxPSy/FtYsUDIRTu5ranrg2n+zjwSQQAUasBY1yj3j0ILO
         wRrjXDRCoepsbUralMSo+h0aDHzUe7+2SYdCLAkQzHZko+O0rL2Ss/Ik/SBfDsyn21ci
         PlormUSuPkvyG8Xpn2SMjSIC0s0oLYEr8Kz9DizLIVh5qmorsIVidOBYUblLo5SJmB47
         wv1A==
X-Gm-Message-State: AOAM530Z0hsDVXK7r7/wan6fA44w0Df2ktKNowK62+duwdqfENcAJ1YP
        /X/sI2eA8ZtKKGbEZKiRPuO4Emb5CPEUcDps2VTQeWr+NW0FKA==
X-Google-Smtp-Source: ABdhPJyQ916BxAa5mCKu4MLlIPPaI2hWN0ncgUgMQaVY7T0r+XrzJH0JhoDqs8+H7eLxe0Wkih7hN7B7MtiN3CfHRJI=
X-Received: by 2002:a05:651c:14a:: with SMTP id c10mr835729ljd.272.1611874349476;
 Thu, 28 Jan 2021 14:52:29 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Jan 2021 16:52:18 -0600
Message-ID: <CAH2r5muGrzDP9FWNed44XpYs3NNbmRt7kzGrwX_+h=Xje8qUfg@mail.gmail.com>
Subject: [PATCH] cifs: returning mount parm processing errors correctly
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

    During additional testing of the updated cifs.ko with the
    new mount API support, we found a few additional cases where
    we were logging errors, but not returning them to the user.

    For example:
       a) invalid security mechanisms
       b) invalid cache options
       c) unsupported rdma
       d) invalid smb dialect requested

    Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
    Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 818c413db82d..27354417e988 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -533,7 +533,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)

        if (ctx->rdma && ctx->vals->protocol_id < SMB30_PROT_ID) {
                cifs_dbg(VFS, "SMB Direct requires Version >=3.0\n");
-               return -1;
+               return -EOPNOTSUPP;
        }

 #ifndef CONFIG_KEYS
@@ -556,7 +556,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
        /* make sure UNC has a share name */
        if (strlen(ctx->UNC) < 3 || !strchr(ctx->UNC + 3, '\\')) {
                cifs_dbg(VFS, "Malformed UNC. Unable to find share name.\n");
-               return -1;
+               return -ENOENT;
        }

        if (!ctx->got_ip) {
@@ -570,7 +570,7 @@ static int smb3_fs_context_validate(struct fs_context *fc)
                if (!cifs_convert_address((struct sockaddr *)&ctx->dstaddr,
                                          &ctx->UNC[2], len)) {
                        pr_err("Unable to determine destination address\n");
-                       return -1;
+                       return -EHOSTUNREACH;
                }
        }

@@ -1265,7 +1265,7 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
        return 0;

  cifs_parse_mount_err:
-       return 1;
+       return -EINVAL;
 }

 int smb3_init_fs_context(struct fs_context *fc)


-- 
Thanks,

Steve
