Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F9C2BA83
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 16:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4390824650
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698898;
	bh=R2pN4Djw7Hf+vxMaEYlVNvZnSL03bd+Tff0IkCl14nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JE1LJrj9pYAbGcGEt/2Wj7CqTlaZW5eGyQx6DrGVKobUyGVhTdPrglGM+yCvBfZOx
	 bN5MFPcLxxpkioGS4A4AtJyRGRT4GU76jVtuR4ST3ZFdZSWB1AwFx9kA6y6vZV3x71
	 T5HtAw/M6IyLhg+eqEwlTVR2kx/i8iPcBCC7Sp8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391473AbgBNQsA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:48:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392891AbgBNQUs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC5324739;
        Fri, 14 Feb 2020 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697247;
        bh=R2pN4Djw7Hf+vxMaEYlVNvZnSL03bd+Tff0IkCl14nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uACVJCWGfyFvf8j+X3o1GGyisDuXRemf3qRqFAokWfb1BAdYaQhSpakJPacsxshSA
         RgNYZxNAV7KeMxFsKoS0JQi2AwQ+XUH2Q0Uts9nO8p9D77Qg6UkiYtVUomAzZFhOog
         A2Yt9TvY7c1EBC2BR0VTZXose4FPWu+bz1PuKuKQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 165/186] cifs: fix NULL dereference in match_prepath
Date:   Fri, 14 Feb 2020 11:16:54 -0500
Message-Id: <20200214161715.18113-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit fe1292686333d1dadaf84091f585ee903b9ddb84 ]

RHBZ: 1760879

Fix an oops in match_prepath() by making sure that the prepath string is not
NULL before we pass it into strcmp().

This is similar to other checks we make for example in cifs_root_iget()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f0b1279a7de66..6e5ecf70996a0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3047,8 +3047,10 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
-	bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
+	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		old->prepath;
+	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		new->prepath;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
 		return 1;
-- 
2.20.1

