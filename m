Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2909CA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 14:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE39222BE
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 14:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572012317;
	bh=bF77Zw/5cdGAn3080C6Xdx/ktL7Ruz/ZbJHIi4/G2Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RM65XFDhPJWtNixV7G1h4VsjkaqAfvhOp+opEOuICvJZdyZZDbiRsmn6XALjGtxqB
	 n2idOWDuN7US5+CsaYCFvD7COf4dzf4b/4MaInsfNHjjqZxOjdKx8/nYIBw3Y3wEgG
	 oHIUFjcCnFu8f8O1mR7v4u3E6Dj/JvbfWrRc36EI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395262AbfJYOFQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733183AbfJYN4R (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B9521E6F;
        Fri, 25 Oct 2019 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011777;
        bh=bF77Zw/5cdGAn3080C6Xdx/ktL7Ruz/ZbJHIi4/G2Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2SyMDbSQJDAxUL5O73Hf4eoLCMrw9+7Pznxk/rV64TeigQpUPU0CElv94g91MHoe
         APW/7VzBsJy9/rcSLHqG1yp1d15jzgYsU/j8dqqWXqToxjoZUYnaC/6vW1O87aUWxX
         eRUovRfsCjpcLCCMiY08B1zc9lnGqUL8DE4Ea4u0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kovtunenko Oleksandr <alexander198961@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/37] Fixed https://bugzilla.kernel.org/show_bug.cgi?id=202935 allow write on the same file
Date:   Fri, 25 Oct 2019 09:55:31 -0400
Message-Id: <20191025135603.25093-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Kovtunenko Oleksandr <alexander198961@gmail.com>

[ Upstream commit 9ab70ca653307771589e1414102c552d8dbdbbef ]

Copychunk allows source and target to be on the same file.
For details on restrictions see MS-SMB2 3.3.5.15.6

Signed-off-by: Kovtunenko Oleksandr <alexander198961@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d5457015801d8..146a766cb86f3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1049,11 +1049,6 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 	cifs_dbg(FYI, "copychunk range\n");
 
-	if (src_inode == target_inode) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
-- 
2.20.1

