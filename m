Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDB3C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28D8F21927
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550198184;
	bh=YizPXQ9O2g4UGq3v7B2rEW7KqMxKK/TFvRQi63R+Jzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QO/vxybypUs0ERUNhHWFjIMiD7bQoNDjWN+NxWOf1b+OIUn9XRKBR7+Z39qAdp6jh
	 R5E58QGyoXRhN7A7zeqYNWIUP/9+SIYoXi7hVOmbH8CWCxve4MC8mh+QZSQFmrD8Hz
	 YTuO7ez7C9JD0YYmgonh+GkGkae6dbboaY03ABYA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfBOCK5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbfBOCKx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 21:10:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 546AA222A1;
        Fri, 15 Feb 2019 02:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196653;
        bh=YizPXQ9O2g4UGq3v7B2rEW7KqMxKK/TFvRQi63R+Jzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crQpU7ywiPa9JcRXTJNO4/QWIHsHi8kuPyo+Ksf1LEGMU56Srue0Ey/vLkwqRlyX8
         B2zg0xgBNtU+t0cLZNoEitwjQ5ZDEoqSkV+SDK26sq8OqZN8BkVocUjAB948BWuZSl
         IlE68J076tIRHwPQicnKO+JNALdV2x8x/VGcgbDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 66/77] CIFS: Fix mounts if the client is low on credits
Date:   Thu, 14 Feb 2019 21:08:44 -0500
Message-Id: <20190215020855.176727-66-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215020855.176727-1-sashal@kernel.org>
References: <20190215020855.176727-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

[ Upstream commit 6a9cbdd1ceca1dc2359ddf082efe61b97c3e752b ]

If the server doesn't grant us at least 3 credits during the mount
we won't be able to complete it because query path info operation
requires 3 credits. Use the cached file handle if possible to allow
the mount to succeed.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a8999f930b22..057d2034209f 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -294,6 +294,8 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 	__u32 create_options = 0;
+	struct cifs_fid fid;
+	bool no_cached_open = tcon->nohandlecache;
 
 	*adjust_tz = false;
 	*symlink = false;
@@ -302,6 +304,21 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
+
+	/* If it is a root and its handle is cached then use it */
+	if (!strlen(full_path) && !no_cached_open) {
+		rc = open_shroot(xid, tcon, &fid);
+		if (rc)
+			goto out;
+		rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
+				     fid.volatile_fid, smb2_data);
+		close_shroot(&tcon->crfid);
+		if (rc)
+			goto out;
+		move_smb2_info_to_cifs(data, smb2_data);
+		goto out;
+	}
+
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-- 
2.19.1

