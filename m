Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A6BC3A59F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 23:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09648233FF
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 23:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfH2Xwk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 19:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfH2Xwk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Aug 2019 19:52:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 037AD107DD00;
        Thu, 29 Aug 2019 23:52:40 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F4F260605;
        Thu, 29 Aug 2019 23:52:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: use existing handle for compount_op(OP_SET_INFO) when possible
Date:   Fri, 30 Aug 2019 09:52:33 +1000
Message-Id: <20190829235233.7749-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 29 Aug 2019 23:52:40 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we already have a writable handle for a path we want to set the
attributes for then use that instead of a create/set-info/close compound.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 939fc7b2234c..6aeb2950382c 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -192,14 +192,27 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = sizeof(FILE_BASIC_INFO);
 		data[0] = ptr;
 
-		rc = SMB2_set_info_init(tcon, &rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_BASIC_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile)
+			rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
+				cfile->fid.persistent_fid,
+				cfile->fid.volatile_fid, current->tgid,
+				FILE_BASIC_INFORMATION,
+				SMB2_O_INFO_FILE, 0, data, size);
+		else {
+			rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
+				COMPOUND_FID,
+				COMPOUND_FID, current->tgid,
+				FILE_BASIC_INFORMATION,
+				SMB2_O_INFO_FILE, 0, data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
+
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_info_compound_enter(xid, ses->Suid, tcon->tid,
 						   full_path);
 		break;
@@ -231,8 +244,10 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					COMPOUND_FID, COMPOUND_FID,
 					current->tgid, FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
-			smb2_set_next_command(tcon, &rqst[num_rqst]);
-			smb2_set_related(&rqst[num_rqst]);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
 		}
 		if (rc)
 			goto finished;
@@ -475,6 +490,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 {
 	FILE_BASIC_INFO data;
 	struct cifsInodeInfo *cifs_i;
+	struct cifsFileInfo *cfile;
 	u32 dosattrs;
 	int tmprc;
 
@@ -482,10 +498,11 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	cifs_i = CIFS_I(inode);
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
+	cifs_get_writable_path(tcon, name, &cfile);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				 CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO,
-				 NULL);
+				 cfile);
 	if (tmprc == 0)
 		cifs_i->cifsAttrs = dosattrs;
 }
@@ -570,6 +587,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink;
+	struct cifsFileInfo *cfile;
 	int rc;
 
 	if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
@@ -581,9 +599,11 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 
+	cifs_get_writable_path(tlink_tcon(tlink), full_path, &cfile);
+
 	rc = smb2_compound_op(xid, tlink_tcon(tlink), cifs_sb, full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
-			      SMB2_OP_SET_INFO, NULL);
+			      SMB2_OP_SET_INFO, cfile);
 	cifs_put_tlink(tlink);
 	return rc;
 }
-- 
2.13.6

