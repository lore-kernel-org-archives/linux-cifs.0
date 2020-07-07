Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B3BC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 23:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B728206E2
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 23:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+i5dIwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgGGXN5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 19:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGGXN4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jul 2020 19:13:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D3BC061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 16:13:56 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 133so4112045ybu.7
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2020 16:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SGFaxHJanXRmTgFwVHh0v9ngrvqc7/QU5CarZw5fU94=;
        b=G+i5dIwSZ35Yy9SAiUNr9Z7sPS9JJbqYomAUywKG3lGz/xHsobH1HV5iAsY1t1k+R2
         kgyUR92sDoC+4N68VLQaE80zEn+h08LAM7j5NUSZWYP3k34Z1oXX1j5xyHzuYDzjaGEW
         Y3zLOwBRiTYtlv1Hq2ys+iLyhZymDUu3fI+VaX9bJk+e3IST9ypBVEunxdQAb4AK6V0C
         fGGcVG8HY+B1rq1MLCv45zQIm2goJP5v0UxfpGhlb2Jw1EswdWqu0cT7poyPQS5zqNau
         P4bqeni7O5ggawZvkXXsaHKCco/WXHY1iBOjuz0RvsC0ZGRid1pBtb3NSOHxQQmDaPpF
         hI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SGFaxHJanXRmTgFwVHh0v9ngrvqc7/QU5CarZw5fU94=;
        b=mG9DKyJFmormSM1barYsPECIp1+0Xm0sLABbFjZw/2eIee0iFgzoOaZiMMSp9eyCjA
         v+ZUPdfGfJy3V6aFQfRUKWcG9JbsIgvZsT3qZgp6d0L1XqaDdDBZ2IARx8xCruvpC1wo
         mP0mbV03gLRTtTFdz6Qc+EdGmgOZ7rQ2xLSpK7ZpEMAtijc/XF5lAOgbEzf2WOfjKVSM
         UicL4zZAJo2gNEC1uT7GDRmeTlsqYln4AjUvouAysM4g1MlBWcngFVMdgLC18ffnU3Ec
         1m9GV0B/xArblGib8y6FqmUlHEZX8lCgbUAJ+TfZ0EAfgCfdh5X27zOFuZ4AetqDvCb6
         BAmw==
X-Gm-Message-State: AOAM530lypbmlIPPPA8OHwt7a/DDdlWs/Jyn+Igs8nF6mIFtMjyraXMl
        g64RaqJaLVeMmS+1SEBEuuzSL9fkkzAIkZvQ3V+HiUYJ6vM=
X-Google-Smtp-Source: ABdhPJxncw89hsBHerX2oZy+sVuh2FiveJYJfoffDi8bnvn9RMPhO4rcfGf2erVb5x6pZTLyT/5XAUQzdEuCafc/6YY=
X-Received: by 2002:a25:56c3:: with SMTP id k186mr63692005ybb.183.1594163635416;
 Tue, 07 Jul 2020 16:13:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 Jul 2020 18:13:44 -0500
Message-ID: <CAH2r5mvgtg0QdikUa78ZwCRG7Lx1-v=XKhnVWGVqqi=JMzKA4A@mail.gmail.com>
Subject: [SMB3][PATCH] smb3: fix access denied on change notify request to
 some  servers
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

read permission, not just read attributes permission, is required
on the directory.

See MS-SMB2 (protocol specification) section 3.3.5.19.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org> # v5.6+
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d9fdafa5eb60..32f90dc82c84 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2148,7 +2148,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,

  tcon = cifs_sb_master_tcon(cifs_sb);
  oparms.tcon = tcon;
- oparms.desired_access = FILE_READ_ATTRIBUTES;
+ oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
  oparms.disposition = FILE_OPEN;
  oparms.create_options = cifs_create_options(cifs_sb, 0);
  oparms.fid = &fid;
-- 
2.25.1


-- 
Thanks,

Steve
