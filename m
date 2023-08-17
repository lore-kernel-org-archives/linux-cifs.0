Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FB9C3DA42
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352677AbjHQPfo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353243AbjHQPfe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:34 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3B52D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:32 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrZMOK4/QrgBa6EaAvtHiDfPReQxxc2saqf8lIctoRQ=;
        b=WaQa/eX22X4WoxlKvzaaWNYEpOaeYJBbs4rqz/BBp73sCijd3v/JfHdhdGfoPBaerjR0xF
        FWTgNa7nfJs4CjMZTOnHnwPjVVvzzx+vnxYPw5wCgD4uyQXbaJL7xo9UO/IDv6e5Wjt4T7
        HX4HzNn9ZBrQCETv+negQj45jSv63L7HbHQ9fSvJsXBuFdJXVkjDvAN7von4fh/f8HgIdK
        kvvrCiC1O6G9G75kDaMhWPMCdLRQWJyBCJkhQFncgDqu6wvTsmdqY0PuMDfy7Ol4TPv4QC
        NZa+9Lf4VN72fEytAgc5lb4LiL3urabFLaNj/kq1l3Pp9VSLp3afositY7BUbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LrZMOK4/QrgBa6EaAvtHiDfPReQxxc2saqf8lIctoRQ=;
        b=ay99Dx0f0E70ohe0MT+MD9OOtiaDR+YHYttD4pH5a09raDgChfyZtEsfIgdfZ8xebCY/1r
        MqIuTB3SQkgmWHWThzccluvHy9+QqVBa0kq4y4pfrDaAGeNxIUNjO7zPfIkX1jBljFhSko
        qvwWHoRqF4v8gMz1MtVJNQcrq4eaSZrzwmgLTkvnXNi+vCHp8iKqIl9Wa5j2jtgWWM8WM8
        dS5cGFntiyjXiZs9RqBxTiVlAzyDZMFQR38svvmHNdnQsyal5i1eL7l6VLQc46BToItOfc
        gXmv2cgmTnxKM/JC7qHzAljUbCV1i5jsjb8aFb1gMC8tcuqo360gXGI7OwCyyg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286531; a=rsa-sha256;
        cv=none;
        b=DSEbZOALuzZtblLkauLXxx1NtdTGTLoQdZtdlpBPp+1WJNhvWEz4TFi1LiHJCYLSaDUiJP
        jmCbfbt+4ZwxGaLJyGIOkMuh+mhNo902CDJzjxilqfjqMxCAfbLtXqSYCQ5kbkxHMigQsp
        nsr11oy5veK7XQXSxZ9pmcH1r7a3hqXDzhm8fPmxvDRQqxscIj1c8EwCCUGAAHt/wBF9gu
        GKlPEL62YcmXi4ll4Ufkk3Zd4ciWszngUsrKBl/26/NXWYaFTebr7S+sTGP1Kqr70203F9
        uAiFBzN629ZtsDJlAzzXWxthtwfkLMyjvhpMN7TpR3FsI4KiIY1RsYL0r5Pepw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 04/17] smb: client: make smb2_compound_op() return resp buffer on success
Date:   Thu, 17 Aug 2023 12:34:02 -0300
Message-ID: <20230817153416.28083-5-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If @out_iov and @out_buftype are passed, then return compounded
responses regardless whether the request failed or not.  This will be
useful for detecting reparse points on SMB2_CREATE responses as
specified in MS-SMB2 2.2.14.

No functional changes.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2inode.c | 52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 260b2ed23cbd..69a2969ecdf5 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -52,15 +52,16 @@ struct cop_vars {
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
  *
- * If passing @err_iov and @err_buftype, ensure to make them both large enough (>= 3) to hold all
- * error responses.  Caller is also responsible for freeing them up.
+ * If passing @out_iov and @out_buftype, ensure to make them both large enough
+ * (>= 3) to hold all compounded responses.  Caller is also responsible for
+ * freeing them up with free_rsp_buf().
  */
 static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    struct cifs_sb_info *cifs_sb, const char *full_path,
 			    __u32 desired_access, __u32 create_disposition, __u32 create_options,
 			    umode_t mode, void *ptr, int command, struct cifsFileInfo *cfile,
 			    __u8 **extbuf, size_t *extbuflen,
-			    struct kvec *err_iov, int *err_buftype)
+			    struct kvec *out_iov, int *out_buftype)
 {
 	struct cop_vars *vars = NULL;
 	struct kvec *rsp_iov;
@@ -529,9 +530,9 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfile)
 		cifsFileInfo_put(cfile);
 
-	if (rc && err_iov && err_buftype) {
-		memcpy(err_iov, rsp_iov, 3 * sizeof(*err_iov));
-		memcpy(err_buftype, resp_buftype, 3 * sizeof(*err_buftype));
+	if (out_iov && out_buftype) {
+		memcpy(out_iov, rsp_iov, 3 * sizeof(*out_iov));
+		memcpy(out_buftype, resp_buftype, 3 * sizeof(*out_buftype));
 	} else {
 		free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 		free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
@@ -550,8 +551,8 @@ int smb2_query_path_info(const unsigned int xid,
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
-	struct kvec err_iov[3] = {};
-	int err_buftype[3] = {};
+	struct kvec out_iov[3] = {};
+	int out_buftype[3] = {};
 	bool islink;
 	int rc, rc2;
 
@@ -577,15 +578,15 @@ int smb2_query_path_info(const unsigned int xid,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
-			      NULL, NULL, err_iov, err_buftype);
+			      NULL, NULL, out_iov, out_buftype);
 	if (rc) {
-		struct smb2_hdr *hdr = err_iov[0].iov_base;
+		struct smb2_hdr *hdr = out_iov[0].iov_base;
 
-		if (unlikely(!hdr || err_buftype[0] == CIFS_NO_BUFFER))
+		if (unlikely(!hdr || out_buftype[0] == CIFS_NO_BUFFER))
 			goto out;
 		if (rc == -EOPNOTSUPP && hdr->Command == SMB2_CREATE &&
 		    hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, err_iov,
+			rc = smb2_parse_symlink_response(cifs_sb, out_iov,
 							 &data->symlink_target);
 			if (rc)
 				goto out;
@@ -614,13 +615,12 @@ int smb2_query_path_info(const unsigned int xid,
 	}
 
 out:
-	free_rsp_buf(err_buftype[0], err_iov[0].iov_base);
-	free_rsp_buf(err_buftype[1], err_iov[1].iov_base);
-	free_rsp_buf(err_buftype[2], err_iov[2].iov_base);
+	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
+	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
+	free_rsp_buf(out_buftype[2], out_iov[2].iov_base);
 	return rc;
 }
 
-
 int smb311_posix_query_path_info(const unsigned int xid,
 				 struct cifs_tcon *tcon,
 				 struct cifs_sb_info *cifs_sb,
@@ -632,8 +632,8 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	int rc;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
-	struct kvec err_iov[3] = {};
-	int err_buftype[3] = {};
+	struct kvec out_iov[3] = {};
+	int out_buftype[3] = {};
 	__u8 *sidsbuf = NULL;
 	__u8 *sidsbuf_end = NULL;
 	size_t sidsbuflen = 0;
@@ -652,13 +652,13 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_POSIX_QUERY_INFO, cfile,
-			      &sidsbuf, &sidsbuflen, err_iov, err_buftype);
+			      &sidsbuf, &sidsbuflen, out_iov, out_buftype);
 	if (rc == -EOPNOTSUPP) {
 		/* BB TODO: When support for special files added to Samba re-verify this path */
-		if (err_iov[0].iov_base && err_buftype[0] != CIFS_NO_BUFFER &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Command == SMB2_CREATE &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, err_iov, &data->symlink_target);
+		if (out_iov[0].iov_base && out_buftype[0] != CIFS_NO_BUFFER &&
+		    ((struct smb2_hdr *)out_iov[0].iov_base)->Command == SMB2_CREATE &&
+		    ((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_STOPPED_ON_SYMLINK) {
+			rc = smb2_parse_symlink_response(cifs_sb, out_iov, &data->symlink_target);
 			if (rc)
 				goto out;
 		}
@@ -694,9 +694,9 @@ int smb311_posix_query_path_info(const unsigned int xid,
 
 out:
 	kfree(sidsbuf);
-	free_rsp_buf(err_buftype[0], err_iov[0].iov_base);
-	free_rsp_buf(err_buftype[1], err_iov[1].iov_base);
-	free_rsp_buf(err_buftype[2], err_iov[2].iov_base);
+	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
+	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
+	free_rsp_buf(out_buftype[2], out_iov[2].iov_base);
 	return rc;
 }
 
-- 
2.41.0

