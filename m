Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF756C7618A
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjCONF5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjCONFv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F6757D03
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=eeAnBm6rZ/lfUfeN7eeTm3Ui1YOIY1DcyIgKdyum0Vk=; b=sr6Xt3M4h94MKxjlLj8/x0A9A6
        UxAsvcIXbZVTVgxcdvSVhHAkuUyeqyY/DHkJ+5cBDSeQZFC8QWZkXwWxOn9tyIxdMRo4QlPEWSch2
        EBlG/FOyfRYrBLJ2XMjC/ascwypiiuXOVLwTQ8bCO/v00hlWU3raR1c0IszZoQvTiY4Kek0MTbkGv
        JFIa6EMfDlED1ovH/GKkl9JqlD1xp8uIll67tFfCH0tJdYXtSlchUefMaV0lXKG4pJ8mnUWjnDvAn
        13E3xIUnrnWlZJmdnsmEuF7vkSmCqUEMIbLx4gOX5DMOLs4WEPmjTregTa6yYT0wcmtyRR7YOBYiq
        TWnkn6LYh6Uj9Y3OFcHoeWw6bTQSuoF/y1gDNPPO+kbEJ6VFxkZ47zcUBErWKK9kjD7ZLgdhZiBnc
        I39dVtiSaCCPxlElPSvltb5ZtIFCwmsdLYvO9j2KA/HUc/1N5C2s9wuVHDtIBZmH61VNmE3VPsJUX
        NaQKYO9VKrq2QoJWUY2Klyjm;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp7-003KNd-7e; Wed, 15 Mar 2023 13:05:45 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 07/10] cifs: Reduce copy&paste in smb2_compound_op()
Date:   Wed, 15 Mar 2023 13:05:28 +0000
Message-Id: <1abb37fcfdd554e51527d4fd3c1103e66ea455a7.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Don't duplicate calls to inner _init() calls when only the fid differs.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 102 ++++++++++++--------------------------------
 1 file changed, 28 insertions(+), 74 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1aafa79503ce..cc472602daf0 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -38,6 +38,8 @@ free_set_inf_compound(struct smb_rqst *rqst)
 
 struct cop_vars {
 	struct cifs_open_parms oparms;
+	__u64 persistent_fid;
+	__u64 volatile_fid;
 	struct kvec rsp_iov[3];
 	struct smb_rqst rqst[3];
 	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
@@ -92,8 +94,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		flags |= CIFS_TRANSFORM_REQ;
 
 	/* We already have a handle so we can skip the open */
-	if (cfile)
+	if (cfile) {
+		vars->persistent_fid = cfile->fid.persistent_fid;
+		vars->volatile_fid = cfile->fid.volatile_fid;
 		goto after_open;
+	} else {
+		vars->persistent_fid = vars->volatile_fid = COMPOUND_FID;
+	}
 
 	/* Open */
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
@@ -132,26 +139,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
-		if (cfile)
-			rc = SMB2_query_info_init(tcon, server,
-				&rqst[num_rqst],
-				cfile->fid.persistent_fid,
-				cfile->fid.volatile_fid,
-				FILE_ALL_INFORMATION,
-				SMB2_O_INFO_FILE, 0,
-				sizeof(struct smb2_file_all_info) +
-					  PATH_MAX * 2, 0, NULL);
-		else {
-			rc = SMB2_query_info_init(tcon, server,
+		rc = SMB2_query_info_init(tcon, server,
 				&rqst[num_rqst],
-				COMPOUND_FID,
-				COMPOUND_FID,
+				vars->persistent_fid,
+				vars->volatile_fid,
 				FILE_ALL_INFORMATION,
 				SMB2_O_INFO_FILE, 0,
 				sizeof(struct smb2_file_all_info) +
 					  PATH_MAX * 2, 0, NULL);
-		}
-
 		if (rc)
 			goto finished;
 		if (!cfile) {
@@ -166,27 +161,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
-		if (cfile)
-			rc = SMB2_query_info_init(tcon, server,
+		rc = SMB2_query_info_init(tcon, server,
 				&rqst[num_rqst],
-				cfile->fid.persistent_fid,
-				cfile->fid.volatile_fid,
+				vars->persistent_fid,
+				vars->volatile_fid,
 				SMB_FIND_FILE_POSIX_INFO,
 				SMB2_O_INFO_FILE, 0,
 				/* TBD: fix following to allow for longer SIDs */
 				sizeof(struct smb311_posix_qinfo *) + (PATH_MAX * 2) +
 				(sizeof(struct cifs_sid) * 2), 0, NULL);
-		else {
-			rc = SMB2_query_info_init(tcon, server,
-				&rqst[num_rqst],
-				COMPOUND_FID,
-				COMPOUND_FID,
-				SMB_FIND_FILE_POSIX_INFO,
-				SMB2_O_INFO_FILE, 0,
-				sizeof(struct smb311_posix_qinfo *) + (PATH_MAX * 2) +
-				(sizeof(struct cifs_sid) * 2), 0, NULL);
-		}
-
 		if (rc)
 			goto finished;
 		if (!cfile) {
@@ -216,25 +199,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
 
-		if (cfile) {
-			rc = SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst],
-						cfile->fid.persistent_fid,
-						cfile->fid.volatile_fid,
-						current->tgid,
-						FILE_END_OF_FILE_INFORMATION,
-						SMB2_O_INFO_FILE, 0,
-						data, size);
-		} else {
-			rc = SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst],
-						COMPOUND_FID,
-						COMPOUND_FID,
-						current->tgid,
-						FILE_END_OF_FILE_INFORMATION,
-						SMB2_O_INFO_FILE, 0,
-						data, size);
-		}
+		rc = SMB2_set_info_init(tcon, server,
+					&rqst[num_rqst],
+					vars->persistent_fid,
+					vars->volatile_fid,
+					current->tgid,
+					FILE_END_OF_FILE_INFORMATION,
+					SMB2_O_INFO_FILE, 0,
+					data, size);
 		if (rc)
 			goto finished;
 		if (!cfile) {
@@ -252,22 +224,12 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = sizeof(FILE_BASIC_INFO);
 		data[0] = ptr;
 
-		if (cfile)
-			rc = SMB2_set_info_init(tcon, server,
-				&rqst[num_rqst],
-				cfile->fid.persistent_fid,
-				cfile->fid.volatile_fid, current->tgid,
-				FILE_BASIC_INFORMATION,
-				SMB2_O_INFO_FILE, 0, data, size);
-		else {
-			rc = SMB2_set_info_init(tcon, server,
+		rc = SMB2_set_info_init(tcon, server,
 				&rqst[num_rqst],
-				COMPOUND_FID,
-				COMPOUND_FID, current->tgid,
+				vars->persistent_fid,
+				vars->volatile_fid, current->tgid,
 				FILE_BASIC_INFORMATION,
 				SMB2_O_INFO_FILE, 0, data, size);
-		}
-
 		if (rc)
 			goto finished;
 		if (!cfile) {
@@ -294,20 +256,12 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[1] = len + 2 /* null */;
 		data[1] = (__le16 *)ptr;
 
-		if (cfile)
-			rc = SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst],
-						cfile->fid.persistent_fid,
-						cfile->fid.volatile_fid,
-					current->tgid, FILE_RENAME_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
-		else {
-			rc = SMB2_set_info_init(tcon, server,
+		rc = SMB2_set_info_init(tcon, server,
 					&rqst[num_rqst],
-					COMPOUND_FID, COMPOUND_FID,
+					vars->persistent_fid,
+					vars->volatile_fid,
 					current->tgid, FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
-		}
 		if (rc)
 			goto finished;
 		if (!cfile) {
-- 
2.30.2

