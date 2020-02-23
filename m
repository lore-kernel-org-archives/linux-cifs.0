Return-Path: <SRS0=0fOs=4L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AD3C35669
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Feb 2020 02:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CE720659
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Feb 2020 02:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582424850;
	bh=2VtHtDsYyS3H5iXlcYpMfL984qgMkhzZ3L+twuNg+SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=pBdpxnFKtfh6oduOoQrhkgJ1JHHqs8DjfahF++oFYNIjGSSm+ekxF1c8ygK6NP+2B
	 TBC0FLpM0r1IvQ0bUGDm89xAhIF748k3+LGKBVb0S04bRmdef8QMzKqsDrO6DdR650
	 zG6JPM3ddIT8nUMI+0PMN/UzWSi/AxeHWXsZKCtQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgBWC1Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:27:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgBWCYf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 22 Feb 2020 21:24:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306F120707;
        Sun, 23 Feb 2020 02:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424674;
        bh=2VtHtDsYyS3H5iXlcYpMfL984qgMkhzZ3L+twuNg+SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfaKvmDYEPx4MaW0v9e4Mu2ZbaP5YfZpsPPaIc3K8Jjl0H2lhAZGuE+iMVYrKPxyj
         sxwBjhJ9lNZOZ/OLZj5ct+H/uupy6JJU6MgTfravb3LUkUTQ7cdaoD5cRsw/CUwZOd
         9UNSzOaBq677/Ho2M1Yj55kbmKgQRYExzwCv6qnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Sorenson <sorenson@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 19/21] cifs: Fix mode output in debugging statements
Date:   Sat, 22 Feb 2020 21:24:09 -0500
Message-Id: <20200223022411.2159-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022411.2159-1-sashal@kernel.org>
References: <20200223022411.2159-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit f52aa79df43c4509146140de0241bc21a4a3b4c7 ]

A number of the debug statements output file or directory mode
in hex.  Change these to print using octal.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 4 ++--
 fs/cifs/connect.c | 2 +-
 fs/cifs/inode.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b98436f5c7c74..73d428af97a9e 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -603,7 +603,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
-	cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
+	cifs_dbg(NOISY, "access flags 0x%x mode now %04o\n", flags, *pmode);
 	return;
 }
 
@@ -632,7 +632,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
-	cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
+	cifs_dbg(NOISY, "mode: %04o, access flags now 0x%x\n",
 		 mode, *pace_flags);
 	return;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f0b1279a7de66..c925ca606b9df 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3519,7 +3519,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
-	cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
+	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	cifs_sb->actimeo = pvolume_info->actimeo;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a35c141059067..3a10d405362e2 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1581,7 +1581,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	struct TCP_Server_Info *server;
 	char *full_path;
 
-	cifs_dbg(FYI, "In cifs_mkdir, mode = 0x%hx inode = 0x%p\n",
+	cifs_dbg(FYI, "In cifs_mkdir, mode = %04ho inode = 0x%p\n",
 		 mode, inode);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
-- 
2.20.1

