Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2082C00528
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjG1Tue (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbjG1Tud (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:33 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664DC422C
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:31 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoWtuTQmWodLTCmNngcddTZu4+cn7yVKE2521QaGd7A=;
        b=D7htvM6OZNi87RPZQKhG0ABKFRxZlQ+X4z3XFTyAnURggu2zd0BgQ8Ys8M16ZltYC3UOO6
        U4W0Fc3cH3VMlQBmVIh4vLq2vkiD4oW//dJYGrImZEaI2BbBQy+t5++ed7fTu9RZd2LdSP
        o/nZItwA+jCD+189tVgXVwRmCDgIdC9ReQg31ZBpc26QQNcuBCp4CR7NszO2CLmSeSPQET
        7rxLz6X8w/uMJlHxzis0YeIhGvYyZ9a9FV9PfHe1IGlYPbfFbcWdM1ygDobYId7nXrlQgV
        5hcUHQHkoOY6hrKZYsbWMJJ/40tgdjAaNi4ZE1sFgLkuCemunVZHDhBPeskgCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoWtuTQmWodLTCmNngcddTZu4+cn7yVKE2521QaGd7A=;
        b=OV8OqWcfQyr6MM4J0RYNG+JYvxhLp1srStuC3GohmXtGY/7GcGk9Uz87xB7C5MnhWAKvvk
        SVkqhssmAcINn9BSH9VVVjCN3CpvOWBnBFzQy8+VqIvlTaMBAZREZpQLkiHgwe//AJ1uc4
        A7qtw/Hht8fnnaW5zXW3nrmGd71/MoPizEA+iYPfe9N32uDAXV2yFrrJ2I3q8CeTGK62QN
        aH6ifzDyLlnxM0NoFt8eyF+6BR4DxRA2qGqT3mZL6YEuUQe25mB5+nmqN/Pn5kehocIc9f
        9R1JYkZakW8Ze0Ki/va5EH5NFD1pUK19VW4Cyg6XhwOvrm/xZUgn7NkYLXPWRw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573830; a=rsa-sha256;
        cv=none;
        b=mZtLI88kIytR5dp41DIpzA/xHGtgUpLVpsHiiR8Po4Q5cNZdOymkLRzcB475jDKPbndSYd
        nO13DyuIeVliM+lXV9GvaTFoqvmNacjyszBs01MKQp7+S1GHGnI82GHjwoGqo9g4leGUz9
        bEcEBbq3kemcVhgm3KOZeB+0rWrh1CTNDXPyYtoPXx6ykU79gEXQj6/qBrX5hdqL3483O4
        A/1qEokj8I0bld78b8hd26jZwzoS9RlZWaRI9Ag69GHQ9UlNU/BWsaZ+BVtXh3h9CS3VpK
        AXRuax2gBFTX6iIi1TSIQibwam13DNE8FLXrQKWia4tT5SNCmFrZ3Vns9FPdlw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 7/8] smb: client: reduce stack usage in smb2_query_symlink()
Date:   Fri, 28 Jul 2023 16:50:09 -0300
Message-ID: <20230728195010.19122-7-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:2974:1: warning: stack frame size (1368)
  exceeds limit (1024) in 'smb2_query_symlink' [-Wframe-larger-than]

Fix this by allocating a qs_vars structure that will hold most of the
large structures.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 43 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d6a15d5ec4d2..9136c77cd407 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2970,6 +2970,14 @@ parse_reparse_point(struct reparse_data_buffer *buf,
 	}
 }
 
+struct qs_vars {
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec close_iov;
+};
+
 static int
 smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path,
@@ -2979,16 +2987,14 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	__le16 *utf16_path = NULL;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
+	struct smb_rqst *rqst;
 	struct cifs_fid fid;
+	struct qs_vars *vars;
 	struct kvec err_iov = {NULL, 0};
+	struct kvec *rsp_iov;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec close_iov[1];
 	struct smb2_create_rsp *create_rsp;
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
@@ -3002,17 +3008,22 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
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
 	/* Open */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -3032,8 +3043,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* IOCTL */
-	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov = io_iov;
+	rqst[1].rq_iov = vars->io_iov;
 	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 	rc = SMB2_ioctl_init(tcon, server,
@@ -3050,8 +3060,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
@@ -3103,13 +3112,15 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
  querty_exit:
 	cifs_dbg(FYI, "query symlink rc %d\n", rc);
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

