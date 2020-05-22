Return-Path: <SRS0=EXIk=7E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA35C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 22 May 2020 14:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41029206C3
	for <linux-cifs@archiver.kernel.org>; Fri, 22 May 2020 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590159444;
	bh=XTK4PTgbowt2TP7bgKTHwyjcQMJPwmm0A2xMP+LiFEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=x5FPMWwpXGYq6gxfnF+fPTztnycxSk3SBPT0SjO0Q9x0prYIqMHmeNuUzzbRlkSS2
	 zzN2UYtzfDdxunsAf0Yl3fUxyyQsv+xxLvwnoGo9LJIt+ZPJeHryG+ERoVzuYm13Hk
	 VWj0EZMSC6N0je9bimEBSKe/2uCQDZGoSOuDDHi0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgEVO5X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 May 2020 10:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730089AbgEVOul (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 May 2020 10:50:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 514E122256;
        Fri, 22 May 2020 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159041;
        bh=XTK4PTgbowt2TP7bgKTHwyjcQMJPwmm0A2xMP+LiFEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSbJTlyuY30/z3FjkGI868ZUeY01wIjyL/wlYaNek8yqc9H32PzAmj0CxE9DkKjji
         FL1cnrpXnQPuDNVwP37dEwF/HzQCid8v8sSss1yjIfEpKRX/tkaiczh7Qwd3nYrpdi
         alG1o+/WvLvefyIYiA+uVj+7LVdvUXtXqiFZO2uU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Coverity <scan-admin@coverity.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.6 38/41] cifs: Fix null pointer check in cifs_read
Date:   Fri, 22 May 2020 10:49:55 -0400
Message-Id: <20200522144959.434379-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
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
index 5920820bfbd0..b30b03747dd6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4060,7 +4060,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
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

