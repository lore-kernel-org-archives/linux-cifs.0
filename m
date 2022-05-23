Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58E8C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 02:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353110AbiEWCbG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 22:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353024AbiEWCbD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 22:31:03 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52CFD6
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 19:31:02 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id m18so4752281uao.9
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 19:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=mbf42gDmgCtMH2dbkGgqrrzqSHACWAKwUGK+qLyDKhE=;
        b=hUnu/WSE5DdU2nrl6ClC4Mo9FR1ngffNOGbqKQfNeTtXCTtHMj5TSg45xfc9Py0Czo
         Q96JYaJjUNHtcRrNju+FW5XbPN/61vOkchMh2WxUVbWsiF8z5gG80/wMxx6KS9BrNcUZ
         6YPTJCY/aHUOjau529Jp1O5R3ZpjDkP6VtJQfHidm73XljMKG+JuLNVXKoQ0h9S1oDc6
         vHeLbnbP+pHpjs5Cxj1Bnwgc4mapzc2FnJwz+IhJGu5RgEZQwFyjlgJ/45n/CZvu4pgB
         GEuUrdJ91ckJFRnq9f709m8H7RfTz5DS3NaQZ1g/s6S60x5hQHLoCxgE4WiDuQbHblGl
         9WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mbf42gDmgCtMH2dbkGgqrrzqSHACWAKwUGK+qLyDKhE=;
        b=K+2+CZycVI1MWtjTce7OTKJbW49j+CL2TEBSaPwfCYzKecNUHT8bexTtuP6PUBxn7W
         /E/xLkosuPjSj50+qqSOZfAh6K1vYIAlLS3fgeS/ae809nGhMK16ZqMsPtW+Z5u8HfIr
         6I9VULpgrMQfkAf6TudHnnH1H+ZF1s5eZA63PiFMUMQOEGcl4yc0fclAXrgJLmgmIx9p
         w3VXyazShBCSbG7BUDOlswbZQ9QdmIVzR41nuuFRP3L03Lqw24jFyPN4+BabgyX98JFn
         QaR45YxReJt+2TZB96EbVWb825bEK5qPNOTC4m5YPav8WUvKPXM1Ctemg6+gSrdmQhD1
         OvKg==
X-Gm-Message-State: AOAM531wp0GHbv8Qtj7kLoQqqRBA0+9pOhJSA8jBNYba6Ou9cvDcFLF0
        D8zoBW4zTJS4B4j69ty09ucW9XsuqOVRkG2CfeV2/NEYoFc=
X-Google-Smtp-Source: ABdhPJzD7ITUzrTksw10ZH8OBlG8fg73pKyLGhBAdI/OXaB6MpfoVQkZFM/1WFbcyprHG/yIGpjzeBcaC8mafdoQh94=
X-Received: by 2002:a9f:354f:0:b0:368:c2c0:f2b5 with SMTP id
 o73-20020a9f354f000000b00368c2c0f2b5mr6542845uao.96.1653273061011; Sun, 22
 May 2022 19:31:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 May 2022 21:30:50 -0500
Message-ID: <CAH2r5msUe_HnNY7ZsdYoBp1ertK=4jLLxiBCxUbUTP1X00+Z=A@mail.gmail.com>
Subject: [PATCH][SMB3] Fix trivial unused variable compile warning
To:     CIFS <linux-cifs@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Author: Steve French <stfrench@microsoft.com>
Date:   Sun May 22 21:25:24 2022 -0500

    cifs: fix minor compile warning

    Add ifdef around nodfs variable from patch:
      "cifs: don't call cifs_dfs_query_info_nonascii_quirk() if nodfs was set"
    which is unused when CONFIG_DFS_UPCALL is not set.

    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 44dc66f21d83..0b08693d1af8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3433,7 +3433,9 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
        struct cifs_tcon *tcon = mnt_ctx->tcon;
        struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
        char *full_path;
+#ifdef CONFIG_CIFS_DFS_UPCALL
        bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
+#endif

        if (!server->ops->is_path_accessible)
                return -EOPNOTSUPP;


-- 
Thanks,

Steve
