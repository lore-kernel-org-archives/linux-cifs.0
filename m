Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71021C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Feb 2021 18:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FAFC64E20
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Feb 2021 18:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhBOSko (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Feb 2021 13:40:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhBOSjU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 15 Feb 2021 13:39:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A759464E53;
        Mon, 15 Feb 2021 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414239;
        bh=1pQvcjsLn1hyuWuG3IYWJqdnk198cx+QlxgmKMLq+pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8eHVbs/Jre6vRwAQkmMKSKw2Ht2hJO1kyTtEyPWa7FDps5RjYDxORHUVRqIl6k4l
         4xaP8uWy0BqFYkn52jMbBwaRYibATSMSDpHYWXs1WeeNFfxRrCNhHxCrKHUZBapYSc
         xEOhChD/99sUFdJ22ncn48xGwZrPxFvy+vOo4OQ5D44Y6rnS6QPygVtyoQ5vwhdk8z
         Ok8xuvdy6h0xiEbcD2SYryWTZboYqRCud149t/ypXTCoc8EwmBr4wmT5EHtTgJb4kf
         10NxtxlSzKo3I5MB7fldFgOR+b8LqHQA3ZrgLtBhQNZH/lByLYfOZhQDdhizlpxzxy
         2aT+rfMJZB+ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.9 2/3] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Mon, 15 Feb 2021 13:37:15 -0500
Message-Id: <20210215183716.122333-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183716.122333-1-sashal@kernel.org>
References: <20210215183716.122333-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b ]

While debugging another issue today, Steve and I noticed that if a
subdir for a file share is already mounted on the client, any new
mount of any other subdir (or the file share root) of the same share
results in sharing the cifs superblock, which e.g. can result in
incorrect device name.

While setting prefix path for the root of a cifs_sb,
CIFS_MOUNT_USE_PREFIX_PATH flag should also be set.
Without it, prepath is not even considered in some places,
and output of "mount" and various /proc/<>/*mount* related
options can be missing part of the device name.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index af78de9ef036c..8508dc8270593 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3488,6 +3488,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;
-- 
2.27.0

