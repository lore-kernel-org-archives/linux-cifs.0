Return-Path: <SRS0=hVAP=CX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FF5C43461
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Sep 2020 17:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83654206F4
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Sep 2020 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600103330;
	bh=/TgvuTtu3dB+kip6pfwy4beQVD01+cDItXjAMGkkd/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kPgpFjxO2Qntcd7IL8ZDicCrORkDM7/UbMlHampTRnRsVw7o+zNQBUscM2TCnUtKv
	 72RaBLCw9ozA6jL5bG/2QA4f74olUJlns0Z4VsgxwaRerhiq9Pv5faIK0n+P76fEL9
	 4vGTaS09fFLBYSrU7ENVtddO4Y2dkk9L/TQxGc1A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgINRIt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Sep 2020 13:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbgINNFF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001C1221E7;
        Mon, 14 Sep 2020 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088657;
        bh=/TgvuTtu3dB+kip6pfwy4beQVD01+cDItXjAMGkkd/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYXdKhyR4nDLwcJUEk8geGl+ddqxHWDkH43EkCPXYxfgbVsbwVIEnhbkFHkJcvcev
         mqW95GrGc00RMD7yzh5OslsyLaF5U5bGK7+/qT/9WT+k63BUtr+uSW1WwO8gBvO/px
         xNZJ2wPNPRGUykqDG7aOiOvyukFEEKFs2SWI9cf4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.8 16/29] cifs: fix DFS mount with cifsacl/modefromsid
Date:   Mon, 14 Sep 2020 09:03:45 -0400
Message-Id: <20200914130358.1804194-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 01ec372cef1e5afa4ab843bbaf88a6fcb64dc14c ]

RHBZ: 1871246

If during cifs_lookup()/get_inode_info() we encounter a DFS link
and we use the cifsacl or modefromsid mount options we must suppress
any -EREMOTE errors that triggers or else we will not be able to follow
the DFS link and automount the target.

This fixes an issue with modefromsid/cifsacl where these mountoptions
would break DFS and we would no longer be able to access the share.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ce95801e9b664..7708175062eba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1017,6 +1017,8 @@ cifs_get_inode_info(struct inode **inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
 				 __func__, rc);
@@ -1025,6 +1027,8 @@ cifs_get_inode_info(struct inode **inode,
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
 				       full_path, fid);
+		if (rc == -EREMOTE)
+			rc = 0;
 		if (rc) {
 			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
 				 __func__, rc);
-- 
2.25.1

