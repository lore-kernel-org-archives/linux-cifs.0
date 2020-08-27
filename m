Return-Path: <SRS0=9knJ=CF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B3EC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Aug 2020 14:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06CDF2087D
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Aug 2020 14:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="saSJCIgd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgH0Ocu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:32:50 -0400
Received: from mx.cjr.nz ([51.158.111.142]:16948 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgH0OUr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 27 Aug 2020 10:20:47 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id F07A37FCFE;
        Thu, 27 Aug 2020 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1598538043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fMHduV4Ws3TnXU/dM0b9Fnn27uppB/G7T5zpIdna66Q=;
        b=saSJCIgdr1T2GtXAGWWd/HQerRbqV5Dvf49aEk/T9k6xfK49b1PPCLsh7PLtb+HH9HHYHg
        zvmlKLbqDcaH374DHuS1OY4X03LpFio7P+d2I6Y1ll3Ommlu9yfXlFxOak0VSR9hCEcwMp
        +gmpvqjHKZyMs+eZcFYFcvsv7X8G+CW+duoVy/ZTAgnad6IKWbTGFDWO05tfwzuJ60DzB3
        DwnPjonfgzwbNZmmvgkkxX96FlzTPP/hrgJHldHBT+Nxw2NNXAtYOKD/TsCeJdKh/eR3xQ
        Abl13U86/rrY1MvLXYLRNX7bUrwQibZyHqVWEqnMfqqdM0xjwFwlZM+ID8PzjA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix check of tcon dfs in smb1
Date:   Thu, 27 Aug 2020 11:20:19 -0300
Message-Id: <20200827142019.26968-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

For SMB1, the DFS flag should be checked against tcon->Flags rather
than tcon->share_flags.  While at it, add an is_tcon_dfs() helper to
check for DFS capability in a more generic way.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsglob.h | 15 +++++++++++++++
 fs/cifs/connect.c  |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b296964b8afa..b565d83ba89e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2031,4 +2031,19 @@ static inline bool is_smb1_server(struct TCP_Server_Info *server)
 	return strcmp(server->vals->version_string, SMB1_VERSION_STRING) == 0;
 }
 
+static inline bool is_tcon_dfs(struct cifs_tcon *tcon)
+{
+	/*
+	 * For SMB1, see MS-CIFS 2.4.55 SMB_COM_TREE_CONNECT_ANDX (0x75) and MS-CIFS 3.3.4.4 DFS
+	 * Subsystem Notifies That a Share Is a DFS Share.
+	 *
+	 * For SMB2+, see MS-SMB2 2.2.10 SMB2 TREE_CONNECT Response and MS-SMB2 3.3.4.14 Server
+	 * Application Updates a Share.
+	 */
+	if (!tcon || !tcon->ses || !tcon->ses->server)
+		return false;
+	return is_smb1_server(tcon->ses->server) ? tcon->Flags & SMB_SHARE_IS_IN_DFS :
+		tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT);
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a275ee399dce..392c44d64d8a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4909,7 +4909,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 		if (!tcon)
 			continue;
 		/* Make sure that requests go through new root servers */
-		if (tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT)) {
+		if (is_tcon_dfs(tcon)) {
 			put_root_ses(root_ses);
 			set_root_ses(cifs_sb, ses, &root_ses);
 		}
-- 
2.28.0

