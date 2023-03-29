Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D047AC6FD18
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjC2UOm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjC2UOl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:14:41 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D8C4ED5
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:14:39 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R1xP26q+B0iKEnLoXzJoz3Z/hIUQJdqBUNJ4ookh6c4=;
        b=AZBtvbcmP0wMRGwN7W+bU+0dwJ5OHeFHmm9PokI1/MBQ4YQZwctEd1J0pYshedVp6Sq+gw
        EuzpJWIaVXr6QOc/AGfXiuQZ0Wr58TXHWudzpLTYsILkFgSsO16B7jKD6CUNZfXLeHqzLF
        Z58tvzNaUigLcEmmP9aKP9ogd2E6YYyoKLbBUySHa68cznbSrmSnIJdXmSdBmci2pmBGmX
        ktSoTTMsdEyDLNm5+Nobugqwy4Qmdo1aj9unUhM2/XbnNqM7byyWrBn5qdZxA+i07iW6cT
        XseHptCsMs05CrYPbqsRFLHzmRQghPDwL3Gt9DSAVsPB3KPZKjRITgFdODh/+g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1680120877; a=rsa-sha256;
        cv=none;
        b=dCuFe9Rz45sWRPtpDiVFuzvMaoJGKuqT8lVyAdr3RfeavwpAOe17MrNRGhHqe1YzBiZigT
        7sctq7Tg6ueYn8n1X3tuQAZnDtMpLfWlcg4s+HJsYqikRC2yXYm8SehPPQWK7JO4WDHpKH
        uiZO9ET9dmoQUBfiL8BRj9CmDmp/IDv4hCchT/1qO/K+HzmgoqHNWb8KBw03QrkceLL95R
        jPfido4RNGg8VQPnoHAE8CZRhVd9XUBu15JXnKFMsQJ76TTG+0I3kLYrZILOewx+3odWDx
        PhpEWjaTkXKlQiMr5Rk0ZJDcOg29Vn7k4OSXiTGIb6IfXErP9eD32o5UF0HW/g==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1680120877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R1xP26q+B0iKEnLoXzJoz3Z/hIUQJdqBUNJ4ookh6c4=;
        b=obKOFToe/mRa/JfwF8sgkztsVuT2P97c3f4Kltmpfd+boya+Yx+yKMugcR+WaUIuHg/0JA
        PqkWxZZhCmNeDlJBcXMQ+j44jX/iwfg1zUrFoXHDbqjRQF8GpeBhpCD0/v6CoE1LiIcaJr
        2AfR9JmaVSaumtPfj1GWpW0SLwhRxPxSg5LzJpvhFb/dV7Fgvochs5AwwPKjAwcJZS8Bds
        W8OShmDJcL/e+DcFGK60ihoHMdia7ttV5QzYkmNrbJ53tQ2BLdPWJOfEA3a6V7SjTlo/3p
        jDmHqE8auG0uGk7fh9n4ho4VXuG1rliNrgQXJjkjBxXuWXEeHyQxN8UiBNPHeA==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/5] cifs: get rid of cifs_mount_ctx::{origin,leaf}_fullpath
Date:   Wed, 29 Mar 2023 17:14:19 -0300
Message-Id: <20230329201423.32134-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

leaf_fullpath is now part of smb3_fs_context structure, while
origin_fullpath is just a variable in __dfs_mount_share() that is used
when final tcon is available.

Get rid of those fields in cifs_mount_ctx structure and no-op
kfree()'s.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsglob.h | 1 -
 fs/cifs/connect.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 08a73dcb7786..c5e3a0fc7983 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1750,7 +1750,6 @@ struct cifs_mount_ctx {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	char *origin_fullpath, *leaf_fullpath;
 	struct list_head dfs_ses_list;
 };
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1cbb90587995..ef50f603e640 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3454,8 +3454,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 
 error:
 	dfs_put_root_smb_sessions(&mnt_ctx.dfs_ses_list);
-	kfree(mnt_ctx.origin_fullpath);
-	kfree(mnt_ctx.leaf_fullpath);
 	cifs_mount_put_conns(&mnt_ctx);
 	return rc;
 }
-- 
2.40.0

