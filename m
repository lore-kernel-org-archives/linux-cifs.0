Return-Path: <SRS0=0xI7=SB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA0FC10F05
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9153E2183F
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553909743;
	bh=+VIIgFlXfqldsNDNi6GUWQoRwvXcI2ASgOGIi6l84hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fflq3ocajnupFo4W/Wri5qzBgGZedsyF7LpPkNZwmYMmWhphaC+UqcGG7lh+75IBi
	 9E1t9QUG0/igmluoPi7H1wOHOcsxH4tNRLnkYT3AP5OP5i3CzUR9YwOVWotbM0YIYU
	 z+zEpWkPr1ND0AxpdYTUXLC+pY8jS0rn0wKSdhZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfC3Bbj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732080AbfC3Bbi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 29 Mar 2019 21:31:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EFB21773;
        Sat, 30 Mar 2019 01:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553909497;
        bh=+VIIgFlXfqldsNDNi6GUWQoRwvXcI2ASgOGIi6l84hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDFwQsxyCzrXl+baT2NJCWlUrVZMsX+PRtF6cEuSY1+m/wo+hzcgTZAFfR6H8EGXH
         VVjcoeh6dT5IqqUYebhLRnO02pAz2M5TlFFKckmR0EB18r8+COwXwBD3LRuakeRvqj
         Xhc3oZ8S3lEsXQIklfJTfLs4OUYHoi/hK70Lu9GE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/21] cifs: fallback to older infolevels on findfirst queryinfo retry
Date:   Fri, 29 Mar 2019 21:31:01 -0400
Message-Id: <20190330013112.784-10-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330013112.784-1-sashal@kernel.org>
References: <20190330013112.784-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 3b7960caceafdfc2cdfe2850487f8d091eb41144 ]

In cases where queryinfo fails, we have cases in cifs (vers=1.0)
where with backupuid mounts we retry the query info with findfirst.
This doesn't work to some NetApp servers which don't support
WindowsXP (and later) infolevel 261 (SMB_FIND_FILE_ID_FULL_DIR_INFO)
so in this case use other info levels (in this case it will usually
be level 257, SMB_FIND_FILE_DIRECTORY_INFO).

(Also fixes some indentation)

See kernel bugzilla 201435

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 67 +++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 57c938ffeb6e..a8a2fc9ae056 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -771,43 +771,50 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	} else if ((rc == -EACCES) && backup_cred(cifs_sb) &&
 		   (strcmp(server->vals->version_string, SMB1_VERSION_STRING)
 		      == 0)) {
-			/*
-			 * For SMB2 and later the backup intent flag is already
-			 * sent if needed on open and there is no path based
-			 * FindFirst operation to use to retry with
-			 */
+		/*
+		 * For SMB2 and later the backup intent flag is already
+		 * sent if needed on open and there is no path based
+		 * FindFirst operation to use to retry with
+		 */
 
-			srchinf = kzalloc(sizeof(struct cifs_search_info),
-						GFP_KERNEL);
-			if (srchinf == NULL) {
-				rc = -ENOMEM;
-				goto cgii_exit;
-			}
+		srchinf = kzalloc(sizeof(struct cifs_search_info),
+					GFP_KERNEL);
+		if (srchinf == NULL) {
+			rc = -ENOMEM;
+			goto cgii_exit;
+		}
 
-			srchinf->endOfSearch = false;
+		srchinf->endOfSearch = false;
+		if (tcon->unix_ext)
+			srchinf->info_level = SMB_FIND_FILE_UNIX;
+		else if ((tcon->ses->capabilities &
+			 tcon->ses->server->vals->cap_nt_find) == 0)
+			srchinf->info_level = SMB_FIND_FILE_INFO_STANDARD;
+		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
 			srchinf->info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
+		else /* no srvino useful for fallback to some netapp */
+			srchinf->info_level = SMB_FIND_FILE_DIRECTORY_INFO;
 
-			srchflgs = CIFS_SEARCH_CLOSE_ALWAYS |
-					CIFS_SEARCH_CLOSE_AT_END |
-					CIFS_SEARCH_BACKUP_SEARCH;
+		srchflgs = CIFS_SEARCH_CLOSE_ALWAYS |
+				CIFS_SEARCH_CLOSE_AT_END |
+				CIFS_SEARCH_BACKUP_SEARCH;
 
-			rc = CIFSFindFirst(xid, tcon, full_path,
-				cifs_sb, NULL, srchflgs, srchinf, false);
-			if (!rc) {
-				data =
-				(FILE_ALL_INFO *)srchinf->srch_entries_start;
+		rc = CIFSFindFirst(xid, tcon, full_path,
+			cifs_sb, NULL, srchflgs, srchinf, false);
+		if (!rc) {
+			data = (FILE_ALL_INFO *)srchinf->srch_entries_start;
 
-				cifs_dir_info_to_fattr(&fattr,
-				(FILE_DIRECTORY_INFO *)data, cifs_sb);
-				fattr.cf_uniqueid = le64_to_cpu(
-				((SEARCH_ID_FULL_DIR_INFO *)data)->UniqueId);
-				validinum = true;
+			cifs_dir_info_to_fattr(&fattr,
+			(FILE_DIRECTORY_INFO *)data, cifs_sb);
+			fattr.cf_uniqueid = le64_to_cpu(
+			((SEARCH_ID_FULL_DIR_INFO *)data)->UniqueId);
+			validinum = true;
 
-				cifs_buf_release(srchinf->ntwrk_buf_start);
-			}
-			kfree(srchinf);
-			if (rc)
-				goto cgii_exit;
+			cifs_buf_release(srchinf->ntwrk_buf_start);
+		}
+		kfree(srchinf);
+		if (rc)
+			goto cgii_exit;
 	} else
 		goto cgii_exit;
 
-- 
2.19.1

