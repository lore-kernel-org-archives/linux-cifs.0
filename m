Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6D0C7618A
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjCONFv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E2253734
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=1T5064wioNMrMT6a7WAGlO0/tunVBULwzIMBnfQ8iMY=; b=q1KTaVVz28SlHoCThQxGIUc1Hn
        luAVhK//ST58mb/EzmuVO0YtDCN0hblifmPaYn5zQZ57aEq93OYrlyMzFQyMHnDFeBLM2Dsorqj0G
        LwJQMdnN+AaiqJpuTfHt3SFwvjsNYleADN9iXj+tt8+CdYfgk3tD5B7lNX0Xd+H7i99hnu9phvstO
        y05MMr4004Ud7DTgtmhKcgysVA9tatx7V3iFJVpZ7Mvq0GtSgRSOUG+e6qGvM+fs8k1Ev1NWz+t+u
        X4Nk0jYZcWbcJcFLs2WyPidLhKz8+lyX25CtyQVHDzisY8vQd7p7p3wSKe3upUOW6GyPQV4PG6OSJ
        jtt2TkbX9Sxzqmqrv/Mz0k9bWzFZsMY5N02VIIRLRjOGs1qPH+1pzFuBOd4pvmgd+QqsOWAvyJP0i
        sQt/8FfwgJMqvGotK4VjzWhVR+z3R2JD+a44byk8zQlB5qd5MeI1EGnGbMT65F3z/JRAaqHcTPXh3
        L36F2AclP73ua6aKW+dcfiAT;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-94; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 01/10] cifs: Simplify some callers of compound_send_recv()
Date:   Wed, 15 Mar 2023 13:05:22 +0000
Message-Id: <68f03f480eea3b7404dc644e3dac154e55b210d1.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is the first thing compound_send_recv() does.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/cached_dir.c | 1 -
 fs/cifs/smb2inode.c  | 2 --
 fs/cifs/smb2ops.c    | 7 -------
 3 files changed, 10 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 75d5e06306ea..81316efad731 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -174,7 +174,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	server->ops->new_lease_key(pfid);
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	/* Open */
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8dd3791b5c53..eb288836b06b 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -92,8 +92,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-
 	/* We already have a handle so we can skip the open */
 	if (cfile)
 		goto after_open;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6dfb865ee9d7..c7c35cad1a41 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1053,7 +1053,6 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	if (ses->server->ops->query_all_EAs) {
@@ -1428,8 +1427,6 @@ smb2_ioctl_query_info(const unsigned int xid,
 	rqst = &vars->rqst[0];
 	rsp_iov = &vars->rsp_iov[0];
 
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-
 	if (copy_from_user(&qi, arg, sizeof(struct smb_query_info))) {
 		rc = -EFAULT;
 		goto free_vars;
@@ -2158,7 +2155,6 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	/* Open */
@@ -2484,7 +2480,6 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	/*
@@ -2914,7 +2909,6 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
@@ -3051,7 +3045,6 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
-- 
2.30.2

