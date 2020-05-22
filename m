Return-Path: <SRS0=EXIk=7E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E7AC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 May 2020 14:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32A9820756
	for <linux-cifs@archiver.kernel.org>; Fri, 22 May 2020 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590159118;
	bh=bHFNpJmKmHKprftzIGOaRHADYjg7o8+IY4OvdCrstTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B/KRrQgihg/JzX9Q/6z/nNisJ+hMA1zOUwzISQLO7lmCP/17HuXvvYdkG2CctZAGn
	 DLrZdfie7gJ1GZfIpkd2kO5b/NO6ROtCYmFKcO/cA+t5mT7ZxsD7lSMu1wWY24Wvva
	 4VRyUK6rNYaiNlrYNsdVtH1Uq9hcDHbZ874YzkUs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgEVOv5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 May 2020 10:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731135AbgEVOv4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 May 2020 10:51:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D392072C;
        Fri, 22 May 2020 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159116;
        bh=bHFNpJmKmHKprftzIGOaRHADYjg7o8+IY4OvdCrstTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNXL0oMD9uh+HNJbXQ1nqy09QPQVGiCNgaLlPuSYTUSLJDCVeJx/a8Zuujp0c/E0I
         eUxTll7y6/VvivYHx52C6blwHyiodcARAnxI2dYc4TjBdZctapz3EKKLo5BmrTsAiy
         Ex9ZUwOXdLqVDh4zcjduZD1z+llty4CX5US7xUv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Coverity <scan-admin@coverity.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 12/13] cifs: Fix null pointer check in cifs_read
Date:   Fri, 22 May 2020 10:51:41 -0400
Message-Id: <20200522145142.435086-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145142.435086-1-sashal@kernel.org>
References: <20200522145142.435086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 9bd21d4b1a767c3abebec203342f3820dcb84662 ]

Coverity scan noted a redundant null check

Coverity-id: 728517
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 662977b8d6ae..72e7cbfb325a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3496,7 +3496,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 			 * than it negotiated since it will refuse the read
 			 * then.
 			 */
-			if ((tcon->ses) && !(tcon->ses->capabilities &
+			if (!(tcon->ses->capabilities &
 				tcon->ses->server->vals->cap_large_files)) {
 				current_read_size = min_t(uint,
 					current_read_size, CIFSMaxBufSize);
-- 
2.25.1

