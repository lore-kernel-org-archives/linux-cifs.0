Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30E9C43334
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 19:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbiFCTNO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jun 2022 15:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348990AbiFCTNN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Jun 2022 15:13:13 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD33BA70
        for <linux-cifs@vger.kernel.org>; Fri,  3 Jun 2022 12:13:12 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 264D17FC02;
        Fri,  3 Jun 2022 19:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654283589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7xoHhEUTBg7P/UAWNdvY68YHm3QoY1/hP2r1xOhtVGA=;
        b=xwPC5oAKDnwKuIqqTmn0kFo25WQINz+o2J+MbBMsTn6vmpS7tgLB+v3tDjnmNqv5u9JAH/
        K+2yP9P4e2QJu6OwzDNrFdMcr4+mvAUVZ2Bvb23emqghaiNMJPusLd+n+jQK/7otYg2lFK
        C/dE3CfHtKOLjFL7ljft+ydUXdmgotgAJTiuYxNGgR4CJySwn4WtvmHgcc9xkZqJhRefjE
        mTLNs8rze7uBEgbB02mniP9AQ3C4IpCEu1bVR8XRywWUrJNnOA0yAp7XkRTxfD6XyQQHxf
        lRKatwwzomdwtWaB+8bkh3+ZY0fxOOoR83sFz91bIJDfdrdcQc1u9nEl/dceJg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: skip trailing separators of prefix paths
Date:   Fri,  3 Jun 2022 16:13:02 -0300
Message-Id: <20220603191302.9640-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

During DFS failover, prefix paths may change, so make sure to not
leave trailing separators when parsing thew in
dfs_cache_get_tgt_share().  The separators of prefix paths are already
handled by build_path_from_dentry_optional_prefix().

Consider the following DFS link:

  //dom/dfs/link: [\srv1\share\dir1, \srv2\share\dir1]

Before commit:

  mount.cifs //dom/dfs/link
  tree connect to \\srv1\share; prefix_path=dir1
  disconnect srv1; failover to srv2
  tree connect to \\srv2\share; prefix_path=dir1\
  mv foo bar

  ...
  SMB2 430 Create Request File: dir1\\foo;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
  SMB2 582 Create Response File: dir1\\foo;GetInfo Response;Close Response
  SMB2 430 Create Request File: dir1\\bar;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
  SMB2 286 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;GetInfo Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;Close Response, Error: STATUS_OBJECT_NAME_NOT_FOUND
  SMB2 462 Create Request File: dir1\\foo;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:dir1\\bar;Close Request
  SMB2 478 Create Response File: dir1\\foo;SetInfo Response, Error: STATUS_OBJECT_NAME_INVALID;Close Response

After commit:

  mount.cifs //dom/dfs/link
  tree connect to \\srv1\share; prefix_path=dir1
  disconnect srv1; failover to srv2
  tree connect to \\srv2\share; prefix_path=dir1
  mv foo bar

  ...
  SMB2 430 Create Request File: dir1\foo;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
  SMB2 582 Create Response File: dir1\foo;GetInfo Response;Close Response
  SMB2 430 Create Request File: dir1\bar;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
  SMB2 286 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;GetInfo Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;Close Response, Error: STATUS_OBJECT_NAME_NOT_FOUND
  SMB2 462 Create Request File: dir1\foo;SetInfo Request FILE_INFO/SMB2_FILE_RENAME_INFO NewName:dir1\bar;Close Request
  SMB2 478 Create Response File: dir1\foo;SetInfo Response;Close Response

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 85 ++++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index aa7d00b5b3e7..7b978a126268 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1229,6 +1229,30 @@ void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id)
 	kref_put(&mg->refcount, mount_group_release);
 }
 
+/* Extract share from DFS target and return a pointer to prefix path or NULL */
+static const char *parse_target_share(const char *target, char **share)
+{
+	const char *s, *seps = "/\\";
+	size_t len;
+
+	s = strpbrk(target + 1, seps);
+	if (!s)
+		return ERR_PTR(-EINVAL);
+
+	len = strcspn(s + 1, seps);
+	if (!len)
+		return ERR_PTR(-EINVAL);
+	s += len;
+
+	len = s - target + 1;
+	*share = kstrndup(target, len, GFP_KERNEL);
+	if (!*share)
+		return ERR_PTR(-ENOMEM);
+
+	s = target + len;
+	return s + strspn(s, seps);
+}
+
 /**
  * dfs_cache_get_tgt_share - parse a DFS target
  *
@@ -1242,56 +1266,45 @@ void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id)
 int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
 			    char **prefix)
 {
-	char *s, sep, *p;
-	size_t len;
-	size_t plen1, plen2;
+	char sep;
+	char *target_share, *ppath;
+	const char *target_ppath, *dfsref_ppath;
+	size_t target_pplen, dfsref_pplen;
+	size_t len, c;
 
 	if (!it || !path || !share || !prefix || strlen(path) < it->it_path_consumed)
 		return -EINVAL;
 
-	*share = NULL;
-	*prefix = NULL;
-
 	sep = it->it_name[0];
 	if (sep != '\\' && sep != '/')
 		return -EINVAL;
 
-	s = strchr(it->it_name + 1, sep);
-	if (!s)
-		return -EINVAL;
+	target_ppath = parse_target_share(it->it_name, &target_share);
+	if (IS_ERR(target_ppath))
+		return PTR_ERR(target_ppath);
 
-	/* point to prefix in target node */
-	s = strchrnul(s + 1, sep);
+	/* point to prefix in DFS referral path */
+	dfsref_ppath = path + it->it_path_consumed;
+	dfsref_ppath += strspn(dfsref_ppath, "/\\");
 
-	/* extract target share */
-	*share = kstrndup(it->it_name, s - it->it_name, GFP_KERNEL);
-	if (!*share)
-		return -ENOMEM;
+	target_pplen = strlen(target_ppath);
+	dfsref_pplen = strlen(dfsref_ppath);
 
-	/* skip separator */
-	if (*s)
-		s++;
-	/* point to prefix in DFS path */
-	p = path + it->it_path_consumed;
-	if (*p == sep)
-		p++;
-
-	/* merge prefix paths from DFS path and target node */
-	plen1 = it->it_name + strlen(it->it_name) - s;
-	plen2 = path + strlen(path) - p;
-	if (plen1 || plen2) {
-		len = plen1 + plen2 + 2;
-		*prefix = kmalloc(len, GFP_KERNEL);
-		if (!*prefix) {
-			kfree(*share);
-			*share = NULL;
+	/* merge prefix paths from DFS referral path and target node */
+	if (target_pplen || dfsref_pplen) {
+		len = target_pplen + dfsref_pplen + 2;
+		ppath = kzalloc(len, GFP_KERNEL);
+		if (!ppath) {
+			kfree(target_share);
 			return -ENOMEM;
 		}
-		if (plen1)
-			scnprintf(*prefix, len, "%.*s%c%.*s", (int)plen1, s, sep, (int)plen2, p);
-		else
-			strscpy(*prefix, p, len);
+		c = strscpy(ppath, target_ppath, len);
+		if (c && dfsref_pplen)
+			ppath[c] = sep;
+		strlcat(ppath, dfsref_ppath, len);
 	}
+	*share = target_share;
+	*prefix = ppath;
 	return 0;
 }
 
-- 
2.36.1

