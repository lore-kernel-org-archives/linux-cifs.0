Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3DBC3DA42
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352349AbjHQPgQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353232AbjHQPfz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:55 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3F02D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:54 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihyqdEpH/tR/SzrTJNg73Nvb1SClEaj0kTlurvLe2w4=;
        b=Unx9mNtc1BNpf25Tld8Gunxu7Dx9AfMfOeIRC67YF1TCTi5WlgoKz+UagLDH+ppiQ0Xrey
        9Pup4RubVAavXFgQaK7mUL5ELcupyDdIycxEiWhnUEUL9fMDDGxkvyiGh9nXs0llGdLv0c
        P/481hxmfMX3A2VSE+QrZZzKOIm4S904bO2TGK+Lodhuxh1Its8tUzrn/3c4H3qG+1nzil
        PhsTUUIwl8bzZYvAhR8AORLUdzAywfmjq8U3NSrWtVdL9uJ+SKgKxLw9vLX+UGN7KRwqaZ
        uQSdunwiMp86aQBfHKGzU3nb0PaDFI2RE2j2Ot1uGqJHjP3U4NdLH3PT+W3YFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihyqdEpH/tR/SzrTJNg73Nvb1SClEaj0kTlurvLe2w4=;
        b=dxdcvYfEAIlv2KJsg1FwWZAkQrgqUx0wbyLsJ9Nvcw/WvU9d2tVsQxlg7P+Ucc4Hsjzg0k
        ngjUVEdyZPsXfivWDCDAMWvgURGxUDTSrQ2UWMogI02DGqbrBG0mpNsVdHryptmvT9w6Gp
        ZO/sGjkSP4nUhAe9JxY2nZbkO7fyd8kOu/FZ6LDRuSBSrJoEy3Hv/qyKsuvA5Gbk+AwoPz
        BZ7b23lO8UwoooFT2wF19LWZHMoAakoxu/dmc3G81+NOaiw1K357es0RrHqYrBc/HP/l/l
        VeI7liKIDOiO9E9AVRDN8x+5qSiMGXhgTz6c2V4So+3my+TO8pwFprPO4eA7NQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286552; a=rsa-sha256;
        cv=none;
        b=Q6cBPrQ6OPDfY6+AwI5rHTokicEMgEGT/8GxBK+YTs9/4RNFLhWmBrrBTPzXKIUTHGNUo6
        9X2pZuLvfgjHFBmX7FrnlnnzucQOi1hI/TltYig+jPHAfp16CCDRZ+bML0crJ03QscwHlR
        0S/Zmd0wwfYLrMGu9vkIfk4OXg7FmxsT0b11Wx5idT8KGqwy58RnoK3x00Jcva4JExgPuD
        aPHA8r4NK8ATfU0ezb6/U31LoVGNLYXbzrTO3ee8+prz02arPVZseE22YRS4gYlSJSazeF
        uhQgFnc3U+jMArGCvCbNmZmFalrO4smckE3LzqHLcdmgJdYlVmjyKQ5v6VZOIQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 17/17] smb: client: reduce stack usage in smb2_query_reparse_point()
Date:   Thu, 17 Aug 2023 12:34:15 -0300
Message-ID: <20230817153416.28083-18-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:2973:12: warning: stack frame size (1336)
  exceeds limit (1024) in 'smb2_query_reparse_point'
  [-Wframe-larger-than]

Fix this by allocating a structure that will hold most of the large
variables.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 015d13d9054d..38bc92371560 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2965,6 +2965,7 @@ static int smb2_query_reparse_point(const unsigned int xid,
 				    u32 *tag, struct kvec *rsp,
 				    int *rsp_buftype)
 {
+	struct smb2_compound_vars *vars;
 	int rc;
 	__le16 *utf16_path = NULL;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
@@ -2972,12 +2973,9 @@ static int smb2_query_reparse_point(const unsigned int xid,
 	struct cifs_fid fid;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
+	struct smb_rqst *rqst;
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec close_iov[1];
+	struct kvec *rsp_iov;
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
 	u32 plen;
@@ -2987,20 +2985,24 @@ static int smb2_query_reparse_point(const unsigned int xid,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
-
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
+	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		rc = -ENOMEM;
+		goto out_free_path;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
+
 	/*
 	 * setup smb2open - TODO add optimization to call cifs_get_readable_path
 	 * to see if there is a handle already open that we can use
 	 */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -3020,8 +3022,7 @@ static int smb2_query_reparse_point(const unsigned int xid,
 
 
 	/* IOCTL */
-	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov = io_iov;
+	rqst[1].rq_iov = vars->io_iov;
 	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
@@ -3036,10 +3037,8 @@ static int smb2_query_reparse_point(const unsigned int xid,
 	smb2_set_next_command(tcon, &rqst[1]);
 	smb2_set_related(&rqst[1]);
 
-
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
@@ -3080,13 +3079,15 @@ static int smb2_query_reparse_point(const unsigned int xid,
 	}
 
  query_rp_exit:
-	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_ioctl_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	kfree(vars);
+out_free_path:
+	kfree(utf16_path);
 	return rc;
 }
 
-- 
2.41.0

