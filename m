Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E478C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 09:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379566AbhLCJ0a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 04:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351316AbhLCJ03 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 04:26:29 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC3C06173E
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 01:23:05 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so8767831eda.11
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 01:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=j27payZnbMPznvXusDuTVgaJvzoMKNS6XqlWtcSodTI=;
        b=Gg/v4j+/K0vRpHQBd5HygDB7JzyAY/0RcI75f/CzjkTjXKysNByp4Qw0wgr41TZyiM
         ZnMmZnEwxvd7y3H1HuM00p1fuJEFigUwcu4/JlInG+PmzWsPiO602aiUIveYSlSgfyvx
         EipW67umUEmIrgzrq8F+VgkOJkRxNJgBMGJ/ODXxoMMm7fQXFQC4rsODsuBzy5IG9V2x
         8h2P9KXFK5IJ2xKgt+az9Evh8MhnwWnUYTUyeogn97O9EXLpMjwhzIAd2M6B5OwD459o
         12sJ5AtJNb0mNN6oFrTWHBE6qQl8/UYW/mMX3DE7Kx2CxZWwp/WtPuB79mDpMHBZ5ttX
         /Edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=j27payZnbMPznvXusDuTVgaJvzoMKNS6XqlWtcSodTI=;
        b=JFZZ73jsxxxWlFR04EuYDYCBUcmhJSVnOYYDjztao/9jCy1Vj9zg5iJa/YdOM+tzV/
         prC/hV3CIGW4lxwyTpOCKuaL1+1dK4sgFsNdrwa2wOxvSxMuQcB8jI95LmyoiwOlNZNC
         J0SvgqSfURTLkGFGe1/QcBQAhtJdoM0h92im8/wDzxr5BXIT8cBkGRvCLLJOTLSuhsLB
         BNtLlurGUuiMzuhDcW59UqmeEJjyBbcUNfUT+qDtmnkg/Utu5KmsBiiQd9cJcPGCnNTU
         XNp+p7MN0DCCoYSKzq5voUSQTZ/VNJYwJzu5kX368GwFh1ggK02IUC1GgQPYuitSEuCJ
         /hkg==
X-Gm-Message-State: AOAM531aGEGtwelJhVuu0hxrUUAzBpatPjaBCZoFSbFfirJ0Ohqu3Np3
        C1+0Pu/wVJm9S0jN5I+BdWEWw8I9FjGEFUDDcJqAMVnEljATduhE
X-Google-Smtp-Source: ABdhPJxC6LryHGqjtNB+BOM6xDEMswi78yhQYrIc7+oDrGxIIxZZnxmjxbKPa59lJRe3llBKXp/S7LSbbkpRsbDDYVM=
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr21790957ejc.536.1638523384191;
 Fri, 03 Dec 2021 01:23:04 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 3 Dec 2021 14:52:53 +0530
Message-ID: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
Subject: [PATCH] cifs: wait for tcon resource_id before getting fscache super
To:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The logic for initializing tcon->resource_id is done inside
cifs_root_iget. fscache super cookie relies on this for aux
data. So we need to push the fscache initialization to this
later point during mount.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/connect.c | 6 ------
 fs/cifs/fscache.c | 2 +-
 fs/cifs/inode.c   | 7 +++++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6b705026da1a3..eee994b0925ff 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3046,12 +3046,6 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
  cifs_dbg(VFS, "read only mount of RW share\n");
  /* no need to log a RW mount of a typical RW share */
  }
- /*
- * The cookie is initialized from volume info returned above.
- * Inside cifs_fscache_get_super_cookie it checks
- * that we do not get super cookie twice.
- */
- cifs_fscache_get_super_cookie(tcon);
  }

  /*
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 7e409a38a2d7c..f4da693760c11 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -92,7 +92,7 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
  * In the future, as we integrate with newer fscache features,
  * we may want to instead add a check if cookie has changed
  */
- if (tcon->fscache == NULL)
+ if (tcon->fscache)
  return;

  sharename = extract_sharename(tcon->treeName);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 82848412ad852..96d083db17372 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
  inode = ERR_PTR(rc);
  }

+ /*
+ * The cookie is initialized from volume info returned above.
+ * Inside cifs_fscache_get_super_cookie it checks
+ * that we do not get super cookie twice.
+ */
+ cifs_fscache_get_super_cookie(tcon);
+
 out:
  kfree(path);
  free_xid(xid);
