Return-Path: <SRS0=hW7M=4I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C283C11D27
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Feb 2020 22:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F43207FD
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Feb 2020 22:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="gv219Q35"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgBTWt5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Feb 2020 17:49:57 -0500
Received: from mx.cjr.nz ([51.158.111.142]:17558 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbgBTWt5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 20 Feb 2020 17:49:57 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1AD4280877;
        Thu, 20 Feb 2020 22:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1582238996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUFWfJQqZ00c86GxSBBcNlGZBqPqAThgqG+VyAYLld0=;
        b=gv219Q35rmTi26VkYtHBlbn90ggOxK+ti+vhIumhVOVfUC2wrknizRfz7j1Qw0OU2f3/tj
        AYWuO+bTRTb2lqt579R2aw8GVYhfIE1WTahrEBa+sQ0+plUJxE26idNHtUyVTytguwIbvK
        AmN9z+9o5k6xADqUFXtotIXbMZRWorBL/YhJyE2D8vY6SHRrgUgOBizLslbtQHg/CtG12m
        2DY3jJ12z45HGVb2jjV20SfbtceqPow/1tfby4SDrT+m/QdXdv5/FfAKTASzgR6KsVLsHM
        foipbgzSmNkiUVGSX4rLaH9hTkq3USUf58Fenz6B9JtiWui/mpGxPE4swvMwCw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: fix potential mismatch of UNC paths
Date:   Thu, 20 Feb 2020 19:49:35 -0300
Message-Id: <20200220224935.12541-2-pc@cjr.nz>
In-Reply-To: <20200220224935.12541-1-pc@cjr.nz>
References: <20200220224935.12541-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ensure that full_path is an UNC path that contains '\\' as delimiter,
which is required by cifs_build_devname().

The build_path_from_dentry_optional_prefix() function may return a
path with '/' as delimiter when using SMB1 UNIX extensions, for
example.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_dfs_ref.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 606f26d862dc..cc3ada12848d 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -324,6 +324,8 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	if (full_path == NULL)
 		goto cdda_exit;
 
+	convert_delimiter(full_path, '\\');
+
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	if (!cifs_sb_master_tlink(cifs_sb)) {
-- 
2.25.0

