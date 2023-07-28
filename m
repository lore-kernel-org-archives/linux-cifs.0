Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8F6C001E0
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbjG1Tuc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbjG1Tu3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:29 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2FE422C
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:27 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wvr0CYyrF9RDIB+pxGpzdN0545sG7gzbj9nL0xYlrK8=;
        b=JoBHwviUmDwK40qqH9IvfEkkNOKiQ+AwXSo4VzJrvlfocWmAuQcSqjrIPi06YX1sMvKlhU
        HSIz4IEr1lHWJsNRpJwRIqnLL0Ksw7mNz00FbHCiX8G+EhbBJb0KVxIJhqM5Fncv1qtMA3
        JPYOdngnSYlYftd0zTgUXVawhgcgeGl0eXGlyPLSkTJIYG6YWcomDL4YhREgFdorEXp3lT
        Or+/y3eZdW9hkwQ/qPcaTZtoE9PrQz/QqQJ7CcLWrlV+twIPLEMBh5gvFXgq3tUOcVhOuh
        NL3sHhp+uz4Pgr7TNj/Yllp5KRpCfUo4WcyaZwMFXDIS0Sq0M7Rz65V9Xy2zMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wvr0CYyrF9RDIB+pxGpzdN0545sG7gzbj9nL0xYlrK8=;
        b=qQ+1gKcU0DO8xmqcT7lTLC+tQLLOpqKM3Bz22w38gk1oFs/X0pgZx8G5GY2P87ivkGvSY/
        dNAxmn7J0jpzkAnW6NB5xEVJGCXlesm/GNjb6Rb+KbMQ06Uz774ivba36XO3LL6jb+Zq35
        WmDgBRdfvuTYDCgxLxTIlxV5TgVHR+Cs1r7UQYMzMr6Kud/8Gja39/2Ha7kozmguh5I+Vu
        0GN4bfctp+jB4qpzUFBtycylCwi2cH/SbErTvjxVJ3fWh3Z+AYVfSTiyP1VsF1FkZZgtv8
        qHZZh/QeQqNPxMFcCYhCZOE/2GtQz26a4qHzuoHc0DWrHmEW3r5pUFXhhpYBBQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573826; a=rsa-sha256;
        cv=none;
        b=g13UJjlioGtSa+BEKOBHFjUBnxie7oa0ysIhG0Jb3F9vqym4/Pnyujv5EDu5+nv+g4Df+X
        n/pJ8spO0Wer+QmC1/ubQZljNRfGGO6dtY1uOivvYbUUMqPyZdPhognSK+UNafDFzDwrJt
        02I1sc9OlyKjJBVHhMcw8Wj0DMFULmcNhM7DXBnhvHVnYOLYWSqj2Ho6AS/nux9Qixrn44
        1evDXIssL5lqsjJszLU/jsy6W0bFMAuUQJGt9S8s+VRFPaH6l9nk37xnVGu7jf8wkvz+t2
        sdLBpi688y0Fsfap2Edinyzu1VZxyP436kLYugaWCs1RCONfOrIcADhTq4s1+w==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 5/8] smb: client: reduce stack usage in smb2_query_info_compound()
Date:   Fri, 28 Jul 2023 16:50:07 -0300
Message-ID: <20230728195010.19122-5-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:2530:1: warning: stack frame size (1336)
  exceeds limit (1024) in 'smb2_query_info_compound'
  [-Wframe-larger-than]

Fix this by allocating a qi_vars structure that will hold most of the
large structures.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5c8bcaf41556..d16036c86aa4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2522,6 +2522,14 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	shdr->NextCommand = cpu_to_le32(len);
 }
 
+struct qi_vars {
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qi_iov;
+	struct kvec close_iov;
+};
+
 /*
  * Passes the query info response back to the caller on success.
  * Caller need to free this with free_rsp_buf().
@@ -2536,15 +2544,13 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec close_iov[1];
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
+	struct smb_rqst *rqst;
 	struct cifs_fid fid;
+	struct qi_vars *vars;
+	struct kvec *rsp_iov;
 	int rc;
 	__le16 *utf16_path;
 	struct cached_fid *cfid = NULL;
@@ -2558,9 +2564,15 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		rc = -ENOMEM;
+		goto out_free_path;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
 
 	/*
 	 * We can only call this for things we know are directories.
@@ -2569,8 +2581,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		open_cached_dir(xid, tcon, path, cifs_sb, false,
 				&cfid); /* cfid null if open dir failed */
 
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -2588,8 +2599,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qic_exit;
 	smb2_set_next_command(tcon, &rqst[0]);
 
-	memset(&qi_iov, 0, sizeof(qi_iov));
-	rqst[1].rq_iov = qi_iov;
+	rqst[1].rq_iov = &vars->qi_iov;
 	rqst[1].rq_nvec = 1;
 
 	if (cfid) {
@@ -2616,8 +2626,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		smb2_set_related(&rqst[1]);
 	}
 
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
@@ -2648,7 +2657,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	*buftype = resp_buftype[1];
 
  qic_exit:
-	kfree(utf16_path);
+
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
@@ -2656,6 +2665,9 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	if (cfid)
 		close_cached_dir(cfid);
+	kfree(vars);
+out_free_path:
+	kfree(utf16_path);
 	return rc;
 }
 
-- 
2.41.0

