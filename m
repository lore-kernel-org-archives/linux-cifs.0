Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB9BCA9EBD
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 14:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E12F21D7B
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572012197;
	bh=SuwhAPmZXkC90NZr8WtJCfCL/WyjuLfEJKv88AocDD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q2rmNKHd0UAZDUl699OEShZGIFmC0TvN2eiooyfAKoyzhitn7LTawVDo6/D/B3eAN
	 ikX5/e3dEMiIOXqOjIC3224jLoyBpEdrFQyzmTIYbma7q6MSeW0+aoFBsMxsduFVQw
	 7e6/U9DEzm3CgoIG2PM+9+XAC3w5BvoSzNefJNsI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395086AbfJYODH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505306AbfJYN5W (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 25 Oct 2019 09:57:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C53222BE;
        Fri, 25 Oct 2019 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011841;
        bh=SuwhAPmZXkC90NZr8WtJCfCL/WyjuLfEJKv88AocDD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4Ymthp2to8j6oJngzrMDuxQo/AJ4QYG22yoLPqhdKkX9g07RX5iBwJH+QKyuESf7
         e8kyGhvpOj/LrB8GeQAJrU765atoTNQPsmCEVAQBTyz7+5kur5kwRQmEok6lPxoTXn
         0+S7uU6X06ZgfVAPhJIhr2sOnm8GYbu2okex8xP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kovtunenko Oleksandr <alexander198961@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/25] Fixed https://bugzilla.kernel.org/show_bug.cgi?id=202935 allow write on the same file
Date:   Fri, 25 Oct 2019 09:56:52 -0400
Message-Id: <20191025135715.25468-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135715.25468-1-sashal@kernel.org>
References: <20191025135715.25468-1-sashal@kernel.org>
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
index c5fd5abf72069..262048e6073f3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -998,11 +998,6 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
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

