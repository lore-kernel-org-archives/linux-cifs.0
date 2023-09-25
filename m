Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA46CE7A97
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Sep 2023 04:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjIYExF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Sep 2023 00:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjIYExE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Sep 2023 00:53:04 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C9DE8BE;
        Sun, 24 Sep 2023 21:52:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 5491A6047A8C6;
        Mon, 25 Sep 2023 12:52:29 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Su Hui <suhui@nfschina.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com
Cc:     Su Hui <suhui@nfschina.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: avoid possible NULL dereference
Date:   Mon, 25 Sep 2023 12:52:21 +0800
Message-Id: <20230925045220.93400-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smatch warn:
fs/smb/client/file.c:4910 cifs_oplock_break() warn:
variable dereferenced before check 'inode' (see line 4881)

If 'inode' is NULL, print some warning and return.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/smb/client/file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 2108b3b40ce9..37eed057ded0 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4878,6 +4878,12 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
+
+	if (!inode) {
+		cifs_dbg(FYI, "%s : failed to find inode\n", __func__);
+		return;
+	}
+
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
@@ -4907,7 +4913,7 @@ void cifs_oplock_break(struct work_struct *work)
 		cinode->oplock = 0;
 	}
 
-	if (inode && S_ISREG(inode->i_mode)) {
+	if (S_ISREG(inode->i_mode)) {
 		if (CIFS_CACHE_READ(cinode))
 			break_lease(inode, O_RDONLY);
 		else
-- 
2.30.2

