Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F5DC77B73
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Apr 2023 18:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDPSik (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Apr 2023 14:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjDPSik (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Apr 2023 14:38:40 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15A0E74
        for <linux-cifs@vger.kernel.org>; Sun, 16 Apr 2023 11:38:38 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1681670316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XqYZTZ7p3mWV+RM7d3tX+kjGhZ8pkE0g3WAwyoOBrmo=;
        b=hpKxPoOYuLy5r8hKrORJplW/2E/f86FAgsQCcqib9w6iL+7kSQyzdmEAZnUhBASIKwba7s
        b20WxEoqW91DOXDuYYJtVqYnkTa9c/S6HlnNjK7v/8bj9P4znNDdtJGKQtk60p6YVSGxw0
        Cu0lCnYkoJ+rz0hiCq7jYyx1Q8apUkfjs5z+hs2bAcaDvgLu6Yl+1yvsio2FnbgPtFsSl8
        ywoIDbicj6RWz+ij6IV5ZFZX9wdb0oS0mc+MA5+LGE5FR/3tj0CwAsvOl6Ux95zqYVGHSt
        D8CTy6WIN9eekpHb8sO3U3xTsl+rEZk9Xcxz7xPl9CMDtx3ewNGH2UOMX30bmA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1681670316; a=rsa-sha256;
        cv=none;
        b=cnTXnyDl0v1XPIeQKwr+A0sGItLKUkPL/HyPydlNu5FUKzjqsx0EXTFWV4L/wR48EYxWNe
        kZm26whWu3h1NXkYUZ1n/o/No9p/XOUKvDn+AwYxhihEHPSpc8GGVIn6Vqgiz/Qtuqm58y
        sir+V+lbYVYWWI0uXfNhuaNYFAU1dnuyUyQoEbJyTYVnX55ew2OHUwkxcVMPhnXZKArCZW
        CN41q/dYLXlca6BJG41tm6knrSStQ5+c5C9xhdzIGGeJPmaznSbu0MxUS0T6vv0XVtJB/m
        sztz7afWtv+8/mbIfC8jS8clx1XCEV/i1RIKaOwExIn+41GZ2Tzcb2B5Gh8eHw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1681670316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XqYZTZ7p3mWV+RM7d3tX+kjGhZ8pkE0g3WAwyoOBrmo=;
        b=EsGmIT+UJEzfjDLEqab2mvhicbkPrzRMDhtF1ExfgH20ThPoVAjCQyciHiWnnRqJLRkxuB
        QMxf17G6PAdv6UlLlhrPFxrV8Vijq+qMkyxjM6OMf0TmHscda2hUV4XYbqyHzGksr6IrhF
        TqnJII8otOvUhBIUW0kleijcVlA1/lnXxduTLm7kRDJYFef949HZqJ8s21czGGdOgQcqDF
        jXQUV7c4T4AT53bp06WE5cJMR3IeQhpbKcfQR9FvKQ860O2YG6fSROZpCCBlLWDPtPQ6NV
        xeVLyZCNuY4oM2foNvpr7IHizrFFuETJKsiXkxbl2Fn4fg4wQ/XUnrArLnBo6g==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] cifs: avoid dup prefix path in dfs_get_automount_devname()
Date:   Sun, 16 Apr 2023 15:38:28 -0300
Message-Id: <20230416183828.18174-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

@server->origin_fullpath already contains the tree name + optional
prefix, so avoid calling __build_path_from_dentry_optional_prefix() as
it might end up duplicating prefix path from @cifs_sb->prepath into
final full path.

Instead, generate DFS full path by simply merging
@server->origin_fullpath with dentry's path.

This fixes the following case

	mount.cifs //root/dfs/dir /mnt/ -o ...
	ls /mnt/link

where cifs_dfs_do_automount() will call smb3_parse_devname() with
@devname set to "//root/dfs/dir/link" instead of
"//root/dfs/dir/dir/link".

Fixes: 7ad54b98fc1f ("cifs: use origin fullpath for automounts")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
FYI, updated DFS tests to include the above case and avoid regressions.

 fs/cifs/cifs_dfs_ref.c |  2 --
 fs/cifs/dfs.h          | 22 ++++++++++++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index cb40074feb3e..0329a907bdfe 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -171,8 +171,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 		mnt = ERR_CAST(full_path);
 		goto out;
 	}
-
-	convert_delimiter(full_path, '/');
 	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	tmp = *cur_ctx;
diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
index 13f26e01f7b9..0b8cbf721fff 100644
--- a/fs/cifs/dfs.h
+++ b/fs/cifs/dfs.h
@@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
 			      cifs_remap(cifs_sb), path, ref, tl);
 }
 
+/* Return DFS full path out of a dentry set for automount */
 static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	size_t len;
+	char *s;
 
 	if (unlikely(!server->origin_fullpath))
 		return ERR_PTR(-EREMOTE);
 
-	return __build_path_from_dentry_optional_prefix(dentry, page,
-							server->origin_fullpath,
-							strlen(server->origin_fullpath),
-							true);
+	s = dentry_path_raw(dentry, page, PATH_MAX);
+	if (IS_ERR(s))
+		return s;
+	/* for root, we want "" */
+	if (!s[1])
+		s++;
+
+	len = strlen(server->origin_fullpath);
+	if (s < (char *)page + len)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	s -= len;
+	memcpy(s, server->origin_fullpath, len);
+	convert_delimiter(s, '/');
+	return s;
 }
 
 static inline void dfs_put_root_smb_sessions(struct list_head *head)
-- 
2.40.0

