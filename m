Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DA2C432C3
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 621DA20715
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="fXP3+r77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKVPbw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:31:52 -0500
Received: from mx.cjr.nz ([51.158.111.142]:28500 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVPbw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 10:31:52 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0636C80A52;
        Fri, 22 Nov 2019 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574436710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GAH2d6eEHWMxkJtDZKc8DF4ep+TO4uklYfQT19YFnvg=;
        b=fXP3+r777NuELiLo/gBW8B5DPFBdlQ6fS06eRAMQ7bZATIsdGuUGadWDtJ76TYFWpvVIiw
        /aE0pAsKxouaaPB5n5MbsSYkxq2HnEiZ1X43FVJ0DykeFcpCO0qqMwTQQ5DwbMpcL7OtDC
        p7/xP9JihC/0cNG7TaCrXgkBbqQBN5qO8SzLri6IZrg68wD9wLfDhhDPBcczvnhOhsc+pP
        wFpZ5ynwSnDDvLcYDMjMgHw+8x6mvBxqcgHuH4x+UsUAjQRaO5wLCZ7WXYn5Ap2gAi9XUO
        mlo/v208v0TUwcyFdiSW8TDrZ+SbBbpxQCPHxD8JKNciU9Fa8keTlKVTAv9jnQ==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        stable@vger.kernel.org,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: [PATCH 6/7] cifs: Fix retrieval of DFS referrals in cifs_mount()
Date:   Fri, 22 Nov 2019 12:30:56 -0300
Message-Id: <20191122153057.6608-7-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-1-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make sure that DFS referrals are sent to newly resolved root targets
as in a multi tier DFS setup.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Link: https://lkml.kernel.org/r/05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com
Cc: stable@vger.kernel.org
Tested-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 fs/cifs/connect.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 668d477cc9c7..86d98d73749d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4776,6 +4776,17 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
+static inline void set_root_tcon(struct cifs_sb_info *cifs_sb,
+				 struct cifs_tcon *tcon,
+				 struct cifs_tcon **root)
+{
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->tc_count++;
+	tcon->remap = cifs_remap(cifs_sb);
+	spin_unlock(&cifs_tcp_ses_lock);
+	*root = tcon;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 {
 	int rc = 0;
@@ -4877,18 +4888,10 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	/* Cache out resolved root server */
 	(void)dfs_cache_find(xid, ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			     root_path + 1, NULL, NULL);
-	/*
-	 * Save root tcon for additional DFS requests to update or create a new
-	 * DFS cache entry, or even perform DFS failover.
-	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	tcon->tc_count++;
-	tcon->dfs_path = root_path;
+	kfree(root_path);
 	root_path = NULL;
-	tcon->remap = cifs_remap(cifs_sb);
-	spin_unlock(&cifs_tcp_ses_lock);
 
-	root_tcon = tcon;
+	set_root_tcon(cifs_sb, tcon, &root_tcon);
 
 	for (count = 1; ;) {
 		if (!rc && tcon) {
@@ -4925,6 +4928,15 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 			mount_put_conns(cifs_sb, xid, server, ses, tcon);
 			rc = mount_get_conns(vol, cifs_sb, &xid, &server, &ses,
 					     &tcon);
+			/*
+			 * Ensure that DFS referrals go through new root server.
+			 */
+			if (!rc && tcon &&
+			    (tcon->share_flags & (SHI1005_FLAGS_DFS |
+						  SHI1005_FLAGS_DFS_ROOT))) {
+				cifs_put_tcon(root_tcon);
+				set_root_tcon(cifs_sb, tcon, &root_tcon);
+			}
 		}
 		if (rc) {
 			if (rc == -EACCES || rc == -EOPNOTSUPP)
-- 
2.24.0

