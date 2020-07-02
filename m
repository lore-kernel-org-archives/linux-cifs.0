Return-Path: <SRS0=xLh5=AN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A7EC433E1
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 01:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28BC206BE
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 01:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593653341;
	bh=MrnB04y5tDP3oh3CHtwgC9d4aQ4bXUX1BfesiJAAPLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kJ7zoZJk7gUOwbWba/WyX77A7aZVjo84Fax12LVtdKIMNEVHXt3VlxcVKWdhmfS1S
	 HvWoR1LdwAy7+9W0e33v1f9DBwyyUCEq97wb2yRmPfUkydLzlqCcuWqI5elyDjYnBE
	 uXsuI5XMESgoMr4KUJzZWP6xBR4iBR9eNrAIb99A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGBB11 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbgGBB1Z (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F382083E;
        Thu,  2 Jul 2020 01:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653245;
        bh=MrnB04y5tDP3oh3CHtwgC9d4aQ4bXUX1BfesiJAAPLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9hyE8M7xVIBrH7z12qCyex24cw/UTYugKLvFDrUX70dpHaMYKplQv/DGPOEdysX1
         KgRsYDUAmIumH8wVTHQOZcVt/rmhA/HTSMDhXyuL037q5L2jQfLAp3jOuzNsO6HMeU
         zJiSawpcJxrU05KL88BgZ52OqEnq5Q5V4K+fV7Gg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.9 10/13] cifs: update ctime and mtime during truncate
Date:   Wed,  1 Jul 2020 21:27:09 -0400
Message-Id: <20200702012712.2701986-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012712.2701986-1-sashal@kernel.org>
References: <20200702012712.2701986-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 5618303d8516f8ac5ecfe53ee8e8bc9a40eaf066 ]

As the man description of the truncate, if the size changed,
then the st_ctime and st_mtime fields should be updated. But
in cifs, we doesn't do it.

It lead the xfstests generic/313 failed.

So, add the ATTR_MTIME|ATTR_CTIME flags on attrs when change
the file size

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dfa85ad5b4814..5478902a01009 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2188,6 +2188,15 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
 		cifs_setsize(inode, attrs->ia_size);
+
+		/*
+		 * The man page of truncate says if the size changed,
+		 * then the st_ctime and st_mtime fields for the file
+		 * are updated.
+		 */
+		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
+		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
+
 		cifs_truncate_page(inode->i_mapping, inode->i_size);
 	}
 
-- 
2.25.1

