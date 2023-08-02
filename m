Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2645BC001E0
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Aug 2023 16:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjHBQnT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbjHBQnR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Aug 2023 12:43:17 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5BAF7
        for <linux-cifs@vger.kernel.org>; Wed,  2 Aug 2023 09:43:16 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690994595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aoft/CtJqBEqPuJuZG6mUB67E/N26Ju9CbHSgl7S7AE=;
        b=jZS02yAIDVEApjNdmFSOwF4Qop/+FrgfKXpDpvNH7kTODv4ZIWZqrWvYiyB/Vwiex3YOCA
        BoKImdJpfECysm/hfEKyrxI0aNvyWbwcH4sM6SvAypML7BEXqxMf0p4e6qcqP03nbDc+FB
        UFbzux13uOwT4uCR+Q5Yd1rWQ+rRbFQE+cZB0ctam9Q5Gi5juqs44PLp6dLFe1H6Qp6l0Z
        CinET143Qs9MDGwj6QMNtsn694nMYsIbi8CERU/UjtPewnuJrM9dasa/y79Cx4b/UCPdWu
        EwcsNkGk1dGNSYNofZB3IGEf3O/goPBaTbFU897TE/NPloZv+llEHRYdSyGhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690994595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aoft/CtJqBEqPuJuZG6mUB67E/N26Ju9CbHSgl7S7AE=;
        b=hH23iVmFGEOP3XrAvkJqDKFoNHQdvNmTFSg6rH756gO+dzqLdaen4IQqW9yz9zVsp7uH3d
        M0owUgDBQlEqDncB8kUIsmMqjFpsBNYMjaaTtbV81XOyPOOFWBS4MpUXIyHpCeEN1TeNNw
        tv1XuiSZxUdFH42Zcx/wflJFI394hbFzm5STslSlGtpzvNPstQVChmuAUP4Rlt6Lg6VSBn
        MaQo9YvoqrnWCei2V51/FHMDr3ZMj3Sgi+XbdJkHzw8GwgxgYtyT7zpo6Q1L/xcGGt8mjJ
        WmyYjduzsPC3y+EHR87YdSEEEnto6EM9pOE/1vITMUOsMT/8YMzqQNfHcU29Ow==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690994595; a=rsa-sha256;
        cv=none;
        b=jVJFTESiFXZUqBx5OKmS6kbKwvtlKhU/dwzFb9QJbnnmLO13kYawZeNlU3yoNAMjRcyQjT
        XCVttvAlTjvSjQKtk1j5XhqxiTebkxNnEp8dxYGe/Cvxmwa20m9yZ6vAMAh9P1ZIN9+kSK
        ZDG316eZAmZczKDS+qOJY94Vj/G23aFPXVcsz2M8nOulZzvm9HCWBMfb6uApN/BrqSjBq2
        WkpCn+3b/++Qp85dKeA4LMqsIOb3yy2pbw/gLLy1u6wgTuj2Azyt3/ZfIka+RjETdPuj28
        6Gws9tTiCXQifHR5aAgQp6N5f7h8KjrG58egE6/qYvWoZ18xJ2tCit/ftrvzhg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: fix dfs link mount against w2k8
Date:   Wed,  2 Aug 2023 13:43:03 -0300
Message-ID: <20230802164303.14109-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Customer reported that they couldn't mount their DFS link that was
seen by the client as a DFS interlink -- special form of DFS link
where its single target may point to a different DFS namespace -- and
it turned out that it was just a regular DFS link where its referral
header flags missed the StorageServers bit thus making the client
think it couldn't tree connect to target directly without requiring
further referrals.

When the DFS link referral header flags misses the StoraServers bit
and its target doesn't respond to any referrals, then tree connect to
it.

Fixes: a1c0d00572fc ("cifs: share dfs connections and supers")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/dfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index df3fd3b720da..ee772c3d9f00 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -177,8 +177,12 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 		struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
 
 		rc = dfs_get_referral(mnt_ctx, ref_path + 1, NULL, &tl);
-		if (rc)
+		if (rc) {
+			rc = cifs_mount_get_tcon(mnt_ctx);
+			if (!rc)
+				rc = cifs_is_path_remote(mnt_ctx);
 			break;
+		}
 
 		tit = dfs_cache_get_tgt_iterator(&tl);
 		if (!tit) {
-- 
2.41.0

