Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E32C3DA41
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352348AbjHQPgQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353231AbjHQPfx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:53 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5F2D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:52 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NoM8oARTlwjkGW7XsrodOIMPlYfPQYSyAhtX9rK1K4=;
        b=aM+Mnl6bYzi83AD66h+m+QX9Zg+fj5EBtYJTQtcaNKl67YBTk/PIgw0WEDA5DBuB4lKGlR
        0HEpMjZtY9Pc02+ar1204JGYXCakbbOGtnFiDhIjnQgbGgfRYg5DkbxSjF855ogLhsH4Vs
        6CTQe1OsJm8smlawPfSHUz4tI2znDUzUVR5bkTiXUcxG3VxFvF2IDY9N6+3zVXhAyyBxPV
        2A/dn3YbQrTLkJFJ8ehR0wfkUkQYu4mrfUbss1dcT6kBJcOl7CJ8g/QhVqldQeB3ybBcXj
        bbFJ6bC3Kvw1FwM6FnuPicFm7HDtSPsi7XqRdKxOHc7reWZel7ENEVtZPu30ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NoM8oARTlwjkGW7XsrodOIMPlYfPQYSyAhtX9rK1K4=;
        b=BMY2Gsvi3aS0tiaIccAWwB5tuEpVTFD/JqEv/IVvzh01o2427a6X1Qkbf3d54UQNLHen84
        +NlCWJa/qTrq1UlbJnRs+A3F1ctht7m6B8Vo0VN6wcBTqUi8JT8LD8mU8NL9gg26uKrXLG
        9jnYL3bAnH8Tgi+14qZeA0sln5k4TknVTtCiRhsW6OHFjkDhCv7202tCwVNAyiZ0obR83s
        jaAsg3Azz8qMPkeAaeCc1MLDSfaEJxac386jr8BTuJ5Ep3mPI286keETc2WA8GfCBqTmuo
        3BZSSA/Q8R9IZSCunjGaCdYrSC5WclQf4jykyIEkvVMuYLsgXuK7l0R65m4TDg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286551; a=rsa-sha256;
        cv=none;
        b=h0hkJwfoC/lMdPzXw6cayiviB+hIeRtoUZ9eZNOK3PwC2Lw6TpxR1WNjJQ+Bg9pcJsNdI5
        6W/rN8Pe8Gmf1AwvIg8hmW9omfcufGZC3cvaGDHqsfD0bMwcvUgiaIiZNeIi4SPI2JJD6R
        BrdxtHnuRbaWFBGYaRRMvcFEBJveb3fMy9NaO3pCedNpFz+eKjTdFaALGsetwllLfUt7GM
        d3mcL3gaspfzjY3kA+e0h3tNpHr5QJ1qBarroFlalh+0Ykyn36iJoGSCt16RN2c0lo3gFN
        VLTB/U427PY9lPOSNTrtfXaA2KHc5fLeGigHFqnY8pzFBFnboWIJoDGNag02Qw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 16/17] smb: client: reduce stack usage in smb2_query_info_compound()
Date:   Thu, 17 Aug 2023 12:34:14 -0300
Message-ID: <20230817153416.28083-17-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:2521:1: warning: stack frame size (1336)
  exceeds limit (1024) in 'smb2_query_info_compound'
  [-Wframe-larger-than]

Fix this by allocating a structure that will hold most of the large
variables.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d31ea7e7fd84..015d13d9054d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2513,15 +2513,13 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 			 struct kvec *rsp, int *buftype,
 			 struct cifs_sb_info *cifs_sb)
 {
+	struct smb2_compound_vars *vars;
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
+	struct smb_rqst *rqst;
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec close_iov[1];
+	struct kvec *rsp_iov;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
@@ -2538,9 +2536,14 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		rc = -ENOMEM;
+		goto out_free_path;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
 
 	/*
 	 * We can only call this for things we know are directories.
@@ -2549,8 +2552,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		open_cached_dir(xid, tcon, path, cifs_sb, false,
 				&cfid); /* cfid null if open dir failed */
 
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -2568,8 +2570,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qic_exit;
 	smb2_set_next_command(tcon, &rqst[0]);
 
-	memset(&qi_iov, 0, sizeof(qi_iov));
-	rqst[1].rq_iov = qi_iov;
+	rqst[1].rq_iov = &vars->qi_iov;
 	rqst[1].rq_nvec = 1;
 
 	if (cfid) {
@@ -2596,8 +2597,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		smb2_set_related(&rqst[1]);
 	}
 
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
@@ -2628,7 +2628,6 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	*buftype = resp_buftype[1];
 
  qic_exit:
-	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
@@ -2636,6 +2635,9 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
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

