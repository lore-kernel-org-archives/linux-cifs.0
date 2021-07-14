Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412DAC47E55
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 19:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2870F613E8
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 19:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhGNToT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 15:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhGNTnf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD64613E8;
        Wed, 14 Jul 2021 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291634;
        bh=q2Px6zKs/i7okRqz6Z6BNxv5W0pDtSNaUU/oHMVllOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adEl85eIy/xRoqN8qXQh3xvDlDtzDOQONjeG8yHAX5oOZUiP3WMc7QB9bGepBeAKU
         f7fPbqo9uWg0KF1UCSWc1oE7ci0jcOREDnQIkI/SxOfMjj5hm6XVmI8oXabTfEr5TA
         Ld5t4HUCAym3a2IagzmBjEP/xdlklPJBt8VWMdpCr6fMBkbJYffG1NiEIKc9KAZUrn
         /ZHtJ+u5NczlaNLGN3UleXCuwVnzqTyAXsXx6zFQTOPYzBIxgZiZ/cPoggRO1yJtrc
         dtNaALfM5G47R5TslWSfs2Sdk605zsvl9Pf5pqxnDFUCUrTus8TYAcN/MJNrIzhpxF
         xTV7/+Mr2N4Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 108/108] cifs: prevent NULL deref in cifs_compose_mount_options()
Date:   Wed, 14 Jul 2021 15:38:00 -0400
Message-Id: <20210714193800.52097-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 03313d1c3a2f086bb60920607ab79ac8f8578306 ]

The optional @ref parameter might contain an NULL node_name, so
prevent dereferencing it in cifs_compose_mount_options().

Addresses-Coverity: 1476408 ("Explicit null dereferenced")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index c87c37cf2914..4e3c15cd403a 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -151,6 +151,9 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		return ERR_PTR(-EINVAL);
 
 	if (ref) {
+		if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < 0))
+			return ERR_PTR(-EINVAL);
+
 		if (strlen(fullpath) - ref->path_consumed) {
 			prepath = fullpath + ref->path_consumed;
 			/* skip initial delimiter */
-- 
2.30.2

