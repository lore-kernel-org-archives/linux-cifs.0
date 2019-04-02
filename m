Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5D8C4360F
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 11:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983D320857
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 11:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfDBLAj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Apr 2019 07:00:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:41942 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfDBLAi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 2 Apr 2019 07:00:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF792AEBB;
        Tue,  2 Apr 2019 11:00:37 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1] CIFS: check CIFS_MOUNT_NO_DFS when trying to reuse existing sb
Date:   Tue,  2 Apr 2019 13:00:33 +0200
Message-Id: <20190402110033.1433-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

if we mount A then mount A again with nodfs, we shouldn't reuse the
superblock. document the purpose of the defines as well.

there are most likely more flags that needs to be added to this mask,
in fact the logic to find them should be which flag should
be *ignored* when trying to reuse an existing sb.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsglob.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 779ceb1f0412..0dc55f4e6929 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -596,6 +596,10 @@ struct smb_vol {
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
 };
 
+/**
+ * CIFS superblock mount flags (mnt_cifs_flags) to consider when
+ * trying to reuse existing superblock for a new mount
+ */
 #define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID | \
 			 CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | \
 			 CIFS_MOUNT_NO_XATTR | CIFS_MOUNT_MAP_SPECIAL_CHR | \
@@ -606,8 +610,13 @@ struct smb_vol {
 			 CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC | \
 			 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
 			 CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
-			 CIFS_MOUNT_CIFS_BACKUPUID | CIFS_MOUNT_CIFS_BACKUPGID)
+			 CIFS_MOUNT_CIFS_BACKUPUID | CIFS_MOUNT_CIFS_BACKUPGID | \
+			 CIFS_MOUNT_NO_DFS)
 
+/**
+ * Generic VFS superblock mount flags (s_flags) to consider when
+ * trying to reuse existing superblock for a new mount
+ */
 #define CIFS_MS_MASK (SB_RDONLY | SB_MANDLOCK | SB_NOEXEC | SB_NOSUID | \
 		      SB_NODEV | SB_SYNCHRONOUS)
 
-- 
2.16.4

