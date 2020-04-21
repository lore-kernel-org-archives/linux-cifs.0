Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB9BC38A30
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0F820781
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="rreTdK+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgDUCo4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Apr 2020 22:44:56 -0400
Received: from mx.cjr.nz ([51.158.111.142]:24678 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDUCo4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Apr 2020 22:44:56 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EEB437FCFC;
        Tue, 21 Apr 2020 02:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1587437095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TiCiiufZTWAJ/cCwkULpqw4f8hT8qJr7SIhDxI9EeP0=;
        b=rreTdK+K5P4FgEy0ekkg1cq3lJHJrbzJiIiqnI7UnmHymsNabSRujnzuJxXWc+afAuWdFm
        7eGxcRf0FTy2CDtl9PMWqXqZ3VhQ98JSaIWE9uMLzKS97Q53QyPvrjyq6b6y54JcH02L53
        HaX5nIutGebCEe3BKucgtH6cde/vinOdvZPZodtHM3zPBmPXvUCmR3m/xwB5VnFFL9PDxv
        lV881m4OSOGR2yx61DzD5Exu7zLg353j306jcXCxFLJtxOlIIPa5Xz6/V8Cckg92T+dbt7
        vYJkgn3FaTempQNDlECbp3E3Dv55mYgdMov/sdSMGgA9xf7MglIn+Cr2nZswJw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        samba-technical@lists.samba.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 1/3] cifs: do not share tcons with DFS
Date:   Mon, 20 Apr 2020 23:44:22 -0300
Message-Id: <20200421024424.3112-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This disables tcon re-use for DFS shares.

tcon->dfs_path stores the path that the tcon should connect to when
doing failing over.

If that tcon is used multiple times e.g. 2 mounts using it with
different prefixpath, each will need a different dfs_path but there is
only one tcon. The other solution would be to split the tcon in 2
tcons during failover but that is much harder.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 95b3ab0ca8c0..ac6d286fe79f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3373,7 +3373,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-		if (!match_tcon(tcon, volume_info))
+		if (!match_tcon(tcon, volume_info) || tcon->dfs_path)
 			continue;
 		++tcon->tc_count;
 		spin_unlock(&cifs_tcp_ses_lock);
-- 
2.26.0

