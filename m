Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA4BC4743E
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B4D613AD
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhFDW17 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:59 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9546 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhFDW14 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:56 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2352C80BAC;
        Fri,  4 Jun 2021 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2i273zsMj3/gTRtdjOQ8QLcihSFruo4ix++n43fKbk=;
        b=DPCtqGfKYwFwpMsd6UkjDyCGZ04rER+tJ/PVjXg2H7oL4/kG9ZLY+Fu+lNu2VKeA8Qj2ec
        8AkxprPSpEl8/8OZGsBlzibELFyDig4o8dDEe0SBm/8hL8wiEqeIEdfDIipddnMvCxUs8r
        8tCdPKdoECFcgn/dQuzkCvwUNPggKnSBT7y7ceKv1wCMAuqZ9oj845em8K7xvtvMp1u82r
        kFeAJgtB3Kpoa8Vna+irghtkOj/MJuBWkGZAOHocbtpu+g8p6ICVqUfbvpNsiAHvOURkbr
        JiSESWwWna+VcLdwvEWtuuAcF+DyBjatgjG5ApgC6Eg+fqZB7NmI0rCdtOpgPg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 7/7] cifs: do not share tcp servers with dfs mounts
Date:   Fri,  4 Jun 2021 19:25:33 -0300
Message-Id: <20210604222533.4760-8-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It isn't enough to have unshared tcons because multiple DFS mounts can
connect to same target server and failover to different servers, so we
can't use a single tcp server for such cases.

For the simplest solution, use nosharesock option to achieve that.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cece0c2249c3..05f5c84a63a4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1938,10 +1938,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (tcon->dfs_path)
-			continue;
-#endif
+
 		if (!match_tcon(tcon, ctx))
 			continue;
 		++tcon->tc_count;
@@ -3406,6 +3403,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 
+	ctx->nosharesock = true;
+
 	/* Get path of DFS root */
 	ref_path = build_unc_path_to_root(ctx, cifs_sb, false);
 	if (IS_ERR(ref_path)) {
-- 
2.31.1

