Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE247C3DA79
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 15:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiL2PeV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 10:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiL2PeT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 10:34:19 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848D2DE80
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 07:34:18 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id ECDBB7FC20;
        Thu, 29 Dec 2022 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1672328056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qIVL1dYqSND5WJXPHLhFC0w+9pk39a9v6K8JlF8lvlA=;
        b=XvbbYOTHhtN69y4wURCEPrLmKemOvTRfz+tt7m+ME7PgaSR20MKYkLVt+uf4/WqydNLsd/
        OGpAirG/yNUU2I9xRX9JzHOzHblQmZXIDu9j04R2eHFdCEcnLBUJD6xrg43CY9tDUp7oUj
        bNzGGKA3A1UDgXL8T4+pwE4WMsa6T07JjW1zBtPiYLaf4c4ICPtQ2kkLZAk7LdcGdXwiD9
        ImGDM7+bN43bExajEmZ51VcitjsUtP8+m9BhySD3RHQM/zNZEPRzn9Dam+7Z4UvcDh5VrK
        F60PEe1FcwDKpLruPByMXmu67R2OY8rHt8t2sLYNkL0I3MRUq4buft4DcgGYow==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: ignore ipc reconnect failures during dfs failover
Date:   Thu, 29 Dec 2022 12:33:55 -0300
Message-Id: <20221229153356.8221-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If it failed to reconnect ipc used for getting referrals, we can just
ignore it as it is not required for reconnecting the share.  The worst
case would be not being able to detect or chase nested links as long
as dfs root server is unreachable.

Before patch:

  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
    -> target share: /fs0/share

  disconnect root & fs0

  $ ls /mnt
  ls: cannot access '/mnt': Host is down

  connect fs0

  $ ls /mnt
  ls: cannot access '/mnt': Resource temporarily unavailable

After patch:

  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
    -> target share: /fs0/share

  disconnect root & fs0

  $ ls /mnt
  ls: cannot access '/mnt': Host is down

  connect fs0

  $ ls /mnt
  bar.rtf  dir1  foo

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index b541e68378f6..30086f2060a1 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -401,8 +401,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		if (ipc->need_reconnect) {
 			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
 			rc = ops->tree_connect(xid, ipc->ses, tree, ipc, cifs_sb->local_nls);
-			if (rc)
-				break;
+			cifs_dbg(FYI, "%s: reconnect ipc: %d\n", __func__, rc);
 		}
 
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
-- 
2.39.0

