Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4FEC001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbjG1Tue (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbjG1Tub (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:31 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5C2423C
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:29 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew33RdJsaf/1Ko58ba2y0RGKPZGcDWQ86Nfx7Gd2Vys=;
        b=j+dildJ8a7kah4ZptU9J44tIzllHc0ST77YAbtzDKplYqtmsmb3hHM/hn2aLVYzP2/qD/1
        8opdPJch4Pj9xoRIkFz6JDu4CV+cxInO2SE3RVoWQ4m2n42do0W3BhiDEkWd0Fbo4LIdl/
        fCR67LeiEDo0HncpBGkY77g4JaiU/TXg9W0vsLKQ5gNAM8so9QL9SSVn5mxDxpepYPd5zY
        t+S8+5JpBMAeMg3DHyv3rwssqiC2fILjpKlUeQ1s8gJZzduJgSoNhcxUCE5Ooh1R05wKNO
        JXCWIiuSWxrrnXce0M/UwJlRWoepIHK2FDuDkQ3TT0XeMV0zGdT5IMtKKIqM6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew33RdJsaf/1Ko58ba2y0RGKPZGcDWQ86Nfx7Gd2Vys=;
        b=SWLzAa+QxJjyHDv43zKhSScNiQKImDznEioYZ80rox/kMEXtcIS6kif7+ZeBXRUkkWEpxC
        HVOKGamVppehoxisEQSO0sCh8EqLGhiXYiQkU/xiFX6CBNUEEmtUizljyxJZtc8urxklEK
        N3qrSVUcqGPdLjrjAEyE50c7hxatKrmdPtFhmzIWehl0aNDIx8Ic8MpDGf99yWr1+j2o2R
        JJPyu0N3RIjM4G2+Dgwg8X6HF2gz7l9QfTtN9BP/YVOA1oB/Hh9JjY1wQCXNDs/pOcRvCB
        /rKXwvkss13K5HU3W4uZRVaZzH2YyHvDwceRM3UbHPe2I4YRbwq2BJnqEDWs8Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573828; a=rsa-sha256;
        cv=none;
        b=ZpigDEB98nxqWMigR1FE8iSkgprSi/JfQjwEImkm/lDrI6JqZFEN/qvivkedZonFJye5Ex
        iqOROXpDnqgQpT+XjD8K74+JegqX9tttLNkFaUlXhkx2stX6UUEYBO3lFncX8D0Yqwzzxu
        D9j3nqiCo/YjZ42Uhnl1lljX2AiYRFVx2oEgcUiwMMGYLvaep9S9zbaTABeR2fygkcXt6w
        630Coxza0GpYU3Hy3tI8XapliEnhipGMexKxtMs6bxhFSOOOBGk2iry1Qt9t+qyUPDUOQN
        MkvP6cCio3l3RYhuCn2Um8XtXo7gapTPR9LsI7fbXlpd1yiMcUBrxRY9LQtW7g==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 6/8] smb: client: reduce stack usage in smb2_query_reparse_tag()
Date:   Fri, 28 Jul 2023 16:50:08 -0300
Message-ID: <20230728195010.19122-6-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:3117:1: warning: stack frame size (1336)
  exceeds limit (1024) in 'smb2_query_reparse_tag'
  [-Wframe-larger-than]

Fix this by allocating a qr_vars structure that will hold most of the
large structures.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 44 ++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d16036c86aa4..d6a15d5ec4d2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3113,6 +3113,14 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+struct qr_vars {
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec close_iov;
+};
+
 int
 smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path,
@@ -3124,13 +3132,11 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
+	struct smb_rqst *rqst;
+	struct qr_vars *vars;
+	struct kvec *rsp_iov;
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec close_iov[1];
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
 	u32 plen;
@@ -3140,20 +3146,25 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
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
+
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
@@ -3173,8 +3184,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* IOCTL */
-	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov = io_iov;
+	rqst[1].rq_iov = vars->io_iov;
 	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
@@ -3191,8 +3201,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
@@ -3230,13 +3239,16 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
  query_rp_exit:
-	kfree(utf16_path);
+
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

