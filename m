Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220D2C10F00
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 18:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E963A2082F
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553711546;
	bh=2djZLjhxwjQjQLMdbIH/XcOtnnDPggClbc/yRZWnTY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UvBrSnssZCFwhAzTslqplVM51XGg29YTFjFrCPMW3XJbiD5C7c18x4j3tIsuX2KjZ
	 CqLZkhmKo/TUVpZGX+F02AM/T6284Xhk6B5m9PRAUAt9HbMT8Y323WRGpuThiRupGf
	 y8x4eHpUF8XHiPjYgEOwyqpm0/QJWy8NUYLGyis4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbfC0ScU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388996AbfC0SZh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:25:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A672177E;
        Wed, 27 Mar 2019 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553711137;
        bh=2djZLjhxwjQjQLMdbIH/XcOtnnDPggClbc/yRZWnTY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHEP20m2OFt/v9/Z4iVsFKJ5caiUFqPw+b68JsYJ2pYFmU/YlT24KfldONC+BRd7d
         LxFGf7E1tnDxWNbue2R2soakFJ+PJtBDsuZNgWcnHh4+dwSLVMkyNysW40+OYHln4J
         qAQnoZY4iFz8dWJ3TjSowoCo4u7f0Bm3q5S4eMUk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Louis Taylor <louis@kragniz.eu>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 08/41] cifs: use correct format characters
Date:   Wed, 27 Mar 2019 14:24:45 -0400
Message-Id: <20190327182518.19394-8-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182518.19394-1-sashal@kernel.org>
References: <20190327182518.19394-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Louis Taylor <louis@kragniz.eu>

[ Upstream commit 259594bea574e515a148171b5cd84ce5cbdc028a ]

When compiling with -Wformat, clang emits the following warnings:

fs/cifs/smb1ops.c:312:20: warning: format specifies type 'unsigned
short' but the argument has type 'unsigned int' [-Wformat]
                         tgt_total_cnt, total_in_tgt);
                                        ^~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:289:4: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->flags, ref->server_type);
                 ^~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:289:16: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->flags, ref->server_type);
                             ^~~~~~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:291:4: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->ref_flag, ref->path_consumed);
                 ^~~~~~~~~~~~~

fs/cifs/cifs_dfs_ref.c:291:19: warning: format specifies type 'short'
but the argument has type 'int' [-Wformat]
                 ref->ref_flag, ref->path_consumed);
                                ^~~~~~~~~~~~~~~~~~
The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for ints and unsigned
ints.

Link: https://github.com/ClangBuiltLinux/linux/issues/378

Signed-off-by: Louis Taylor <louis@kragniz.eu>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c | 4 ++--
 fs/cifs/smb1ops.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b8602f199815..71263ea90810 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -265,9 +265,9 @@ static void dump_referral(const struct dfs_info3_param *ref)
 {
 	cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
 	cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
-	cifs_dbg(FYI, "DFS: fl: %hd, srv_type: %hd\n",
+	cifs_dbg(FYI, "DFS: fl: %d, srv_type: %d\n",
 		 ref->flags, ref->server_type);
-	cifs_dbg(FYI, "DFS: ref_flags: %hd, path_consumed: %hd\n",
+	cifs_dbg(FYI, "DFS: ref_flags: %d, path_consumed: %d\n",
 		 ref->ref_flag, ref->path_consumed);
 }
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b0f973b2b189..2a43aa6d8e87 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -305,7 +305,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	remaining = tgt_total_cnt - total_in_tgt;
 
 	if (remaining < 0) {
-		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%hu\n",
+		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
 			 tgt_total_cnt, total_in_tgt);
 		return -EPROTO;
 	}
-- 
2.19.1

