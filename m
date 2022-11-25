Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D852AC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Nov 2022 14:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKYOIF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Nov 2022 09:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKYOIE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Nov 2022 09:08:04 -0500
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Nov 2022 06:08:01 PST
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613F612D36
        for <linux-cifs@vger.kernel.org>; Fri, 25 Nov 2022 06:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=Content-Type:MIME-Version:Reply-To:Message-ID:Subject:To:
        From:Date:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dBrOuf2m9gUejq/W8uMRaFBTa8jzAbnb1ZV1KZkjps4=; b=rsvEKHh6gKPIzaajZi9IdOSdbf
        i/ODPEgFsFiVM/O2Q/KaeJu/Dt8NCndeeHRu5AZPIym/4b4PM5j6UEDXyWElSiXAMGoDupQ83xaxv
        p1Uz9YA5bdxOwVyD3M+yxBEuXvaDM6WTWaq7H8ICP+AaEU5pOUAg4WcEerFsj1MrnmgAjGkBRCLSv
        lK4+IQwETvQX5XLqwTxJjJegye0smLkLGCv25G5+zo+wquRMXcovun0+eOSSAGwbm7u151mxcYpql
        LzOJYvwnsF6llbFFKfBZlhfm3PY+P/C9VrNwDqy7zamGX4Uz05dq8dv5f/bEWZ9JsaYT8byPT5Y01
        7no48pMw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=Content-Type:MIME-Version:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dBrOuf2m9gUejq/W8uMRaFBTa8jzAbnb1ZV1KZkjps4=; b=NuBdQNI8VC+n08NNXh4t/KczAY
        X7BEj4WbubteYcu/toXRMZpMo0BJT3/1ggLnOLEbdfCZpLGzXd0VxlNAMfBA==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1oyZDD-0078F5-Kp; Fri, 25 Nov 2022 14:57:51 +0100
Received: by intern.sernet.de
        id 1oyZDD-000lSi-ML; Fri, 25 Nov 2022 14:57:51 +0100
Date:   Fri, 25 Nov 2022 14:57:46 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Parse owner and group sids from smb311 posix extension qfileinfo call
Message-ID: <Y4DJ2o6w+SxIH7Yl@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="N4dM0t8o7i/ylWYm"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--N4dM0t8o7i/ylWYm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

Attached find a patch that aligns "stat /mnt/file"'s owner and group
info with the readdir call.

Fixes a TODO from 6a5f6592a0b60.

Volker

--N4dM0t8o7i/ylWYm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="posix_info_stat.diff"
Content-Transfer-Encoding: quoted-printable

=46rom 428f3739880f5f4653946188a55725ba170167ea Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Fri, 25 Nov 2022 12:26:00 +0100
Subject: [PATCH 1/2] cifs: Add "extbuf" and "extbuflen" args to
 smb2_compound_op()

Will carry the variable-sized reply from SMB_FIND_FILE_POSIX_INFO

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 68e08c85fbb8..1be86ba950b3 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -59,6 +59,7 @@ static int smb2_compound_op(const unsigned int xid, struc=
t cifs_tcon *tcon,
 			    struct cifs_sb_info *cifs_sb, const char *full_path,
 			    __u32 desired_access, __u32 create_disposition, __u32 create_option=
s,
 			    umode_t mode, void *ptr, int command, struct cifsFileInfo *cfile,
+			    __u8 **extbuf, size_t *extbuflen,
 			    struct kvec *err_iov, int *err_buftype)
 {
 	struct cop_vars *vars =3D NULL;
@@ -539,7 +540,7 @@ int smb2_query_path_info(const unsigned int xid, struct=
 cifs_tcon *tcon,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUT=
ES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
-			      err_iov, err_buftype);
+			      NULL, NULL, err_iov, err_buftype);
 	if (rc =3D=3D -EOPNOTSUPP) {
 		if (err_iov[0].iov_base && err_buftype[0] !=3D CIFS_NO_BUFFER &&
 		    ((struct smb2_hdr *)err_iov[0].iov_base)->Command =3D=3D SMB2_CREATE=
 &&
@@ -555,7 +556,7 @@ int smb2_query_path_info(const unsigned int xid, struct=
 cifs_tcon *tcon,
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBU=
TES,
 				      FILE_OPEN, create_options, ACL_NO_MODE, data,
-				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL);
+				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL, NULL, NULL);
 	}
=20
 out:
@@ -589,7 +590,7 @@ int smb311_posix_query_path_info(const unsigned int xid=
, struct cifs_tcon *tcon,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUT=
ES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_POSIX_QUERY_INFO, cfil=
e,
-			      err_iov, err_buftype);
+			      NULL, NULL, err_iov, err_buftype);
 	if (rc =3D=3D -EOPNOTSUPP) {
 		/* BB TODO: When support for special files added to Samba re-verify this=
 path */
 		if (err_iov[0].iov_base && err_buftype[0] !=3D CIFS_NO_BUFFER &&
@@ -606,7 +607,7 @@ int smb311_posix_query_path_info(const unsigned int xid=
, struct cifs_tcon *tcon,
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBU=
TES,
 				      FILE_OPEN, create_options, ACL_NO_MODE, data,
-				      SMB2_OP_POSIX_QUERY_INFO, cfile, NULL, NULL);
+				      SMB2_OP_POSIX_QUERY_INFO, cfile, NULL, NULL, NULL, NULL);
 	}
=20
 out:
@@ -624,7 +625,7 @@ smb2_mkdir(const unsigned int xid, struct inode *parent=
_inode, umode_t mode,
 	return smb2_compound_op(xid, tcon, cifs_sb, name,
 				FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				CREATE_NOT_FILE, mode, NULL, SMB2_OP_MKDIR,
-				NULL, NULL, NULL);
+				NULL, NULL, NULL, NULL, NULL);
 }
=20
 void
@@ -646,7 +647,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *nam=
e,
 	tmprc =3D smb2_compound_op(xid, tcon, cifs_sb, name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				 CREATE_NOT_FILE, ACL_NO_MODE,
-				 &data, SMB2_OP_SET_INFO, cfile, NULL, NULL);
+				 &data, SMB2_OP_SET_INFO, cfile, NULL, NULL, NULL, NULL);
 	if (tmprc =3D=3D 0)
 		cifs_i->cifsAttrs =3D dosattrs;
 }
@@ -658,7 +659,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tc=
on, const char *name,
 	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_NOT_FILE, ACL_NO_MODE,
-				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL);
+				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NULL, NULL);
 }
=20
 int
@@ -667,7 +668,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *t=
con, const char *name,
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, NULL, NULL);
+				ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, NULL, NULL, NULL, NULL);
 }
=20
 static int
@@ -686,7 +687,7 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_=
tcon *tcon,
 	}
 	rc =3D smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
 			      FILE_OPEN, 0, ACL_NO_MODE, smb2_to_name,
-			      command, cfile, NULL, NULL);
+			      command, cfile, NULL, NULL, NULL, NULL);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
@@ -727,7 +728,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_=
tcon *tcon,
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				FILE_WRITE_DATA, FILE_OPEN, 0, ACL_NO_MODE,
-				&eof, SMB2_OP_SET_EOF, cfile, NULL, NULL);
+				&eof, SMB2_OP_SET_EOF, cfile, NULL, NULL, NULL, NULL);
 }
=20
 int
@@ -754,7 +755,7 @@ smb2_set_file_info(struct inode *inode, const char *ful=
l_path,
 	rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN,
 			      0, ACL_NO_MODE, buf, SMB2_OP_SET_INFO, cfile,
-			      NULL, NULL);
+			      NULL, NULL, NULL, NULL);
 	cifs_put_tlink(tlink);
 	return rc;
 }
--=20
2.30.2


=46rom 6cd04311f18286b45aad5ac41ca73d5065d96669 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Fri, 25 Nov 2022 12:37:44 +0100
Subject: [PATCH 2/2] cifs: Parse owner/group for stat in smb311 posix
 extensions

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/inode.c     | 13 +++++++++----
 fs/cifs/smb2inode.c | 46 ++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2proto.h |  5 ++++-
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 4e2ca3c6e5c0..286a5400b94e 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -632,6 +632,8 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, cons=
t unsigned char *path,
=20
 /* Fill a cifs_fattr struct with info from POSIX info struct */
 static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct ci=
fs_open_info_data *data,
+				       struct cifs_sid *owner,
+				       struct cifs_sid *group,
 				       struct super_block *sb, bool adjust_tz, bool symlink)
 {
 	struct smb311_posix_qinfo *info =3D &data->posix_fi;
@@ -680,8 +682,8 @@ static void smb311_posix_info_to_fattr(struct cifs_fatt=
r *fattr, struct cifs_ope
 	}
 	/* else if reparse point ... TODO: add support for FIFO and blk dev; spec=
ial file types */
=20
-	fattr->cf_uid =3D cifs_sb->ctx->linux_uid; /* TODO: map uid and gid from =
SID */
-	fattr->cf_gid =3D cifs_sb->ctx->linux_gid;
+	sid_to_id(cifs_sb, owner, fattr, SIDOWNER);
+	sid_to_id(cifs_sb, group, fattr, SIDGROUP);
=20
 	cifs_dbg(FYI, "POSIX query info: mode 0x%x uniqueid 0x%llx nlink %d\n",
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
@@ -1175,6 +1177,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 	struct cifs_fattr fattr =3D {0};
 	bool symlink =3D false;
 	struct cifs_open_info_data data =3D {};
+	struct cifs_sid owner, group;
 	int rc =3D 0;
 	int tmprc =3D 0;
=20
@@ -1192,7 +1195,8 @@ smb311_posix_get_inode_info(struct inode **inode,
 		goto out;
 	}
=20
-	rc =3D smb311_posix_query_path_info(xid, tcon, cifs_sb, full_path, &data,=
 &adjust_tz,
+	rc =3D smb311_posix_query_path_info(xid, tcon, cifs_sb, full_path, &data,
+					  &owner, &group, &adjust_tz,
 					  &symlink);
=20
 	/*
@@ -1201,7 +1205,8 @@ smb311_posix_get_inode_info(struct inode **inode,
=20
 	switch (rc) {
 	case 0:
-		smb311_posix_info_to_fattr(&fattr, &data, sb, adjust_tz, symlink);
+		smb311_posix_info_to_fattr(&fattr, &data, &owner, &group,
+					   sb, adjust_tz, symlink);
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1be86ba950b3..bf0be74752ec 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -431,6 +431,21 @@ static int smb2_compound_op(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 				&rsp_iov[1], sizeof(idata->posix_fi) /* add SIDs */,
 				(char *)&idata->posix_fi);
 		}
+		if (rc =3D=3D 0) {
+			unsigned int length =3D le32_to_cpu(qi_rsp->OutputBufferLength);
+
+			if (length > sizeof(idata->posix_fi)) {
+				char *base =3D (char *)rsp_iov[1].iov_base +
+					le16_to_cpu(qi_rsp->OutputBufferOffset) +
+					sizeof(idata->posix_fi);
+				*extbuflen =3D length - sizeof(idata->posix_fi);
+				*extbuf =3D kmemdup(base, *extbuflen, GFP_KERNEL);
+				if (!*extbuf)
+					rc =3D -ENOMEM;
+			} else {
+				rc =3D -EINVAL;
+			}
+		}
 		if (rqst[1].rq_iov)
 			SMB2_query_info_free(&rqst[1]);
 		if (rqst[2].rq_iov)
@@ -569,13 +584,20 @@ int smb2_query_path_info(const unsigned int xid, stru=
ct cifs_tcon *tcon,
=20
 int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon =
*tcon,
 				 struct cifs_sb_info *cifs_sb, const char *full_path,
-				 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse)
+				 struct cifs_open_info_data *data,
+				 struct cifs_sid *owner,
+				 struct cifs_sid *group,
+				 bool *adjust_tz, bool *reparse)
 {
 	int rc;
 	__u32 create_options =3D 0;
 	struct cifsFileInfo *cfile;
 	struct kvec err_iov[3] =3D {};
 	int err_buftype[3] =3D {};
+	__u8 *sidsbuf =3D NULL;
+	__u8 *sidsbuf_end =3D NULL;
+	size_t sidsbuflen =3D 0;
+	size_t owner_len, group_len;
=20
 	*adjust_tz =3D false;
 	*reparse =3D false;
@@ -590,7 +612,7 @@ int smb311_posix_query_path_info(const unsigned int xid=
, struct cifs_tcon *tcon,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUT=
ES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_POSIX_QUERY_INFO, cfil=
e,
-			      NULL, NULL, err_iov, err_buftype);
+			      &sidsbuf, &sidsbuflen, err_iov, err_buftype);
 	if (rc =3D=3D -EOPNOTSUPP) {
 		/* BB TODO: When support for special files added to Samba re-verify this=
 path */
 		if (err_iov[0].iov_base && err_buftype[0] !=3D CIFS_NO_BUFFER &&
@@ -607,10 +629,28 @@ int smb311_posix_query_path_info(const unsigned int x=
id, struct cifs_tcon *tcon,
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBU=
TES,
 				      FILE_OPEN, create_options, ACL_NO_MODE, data,
-				      SMB2_OP_POSIX_QUERY_INFO, cfile, NULL, NULL, NULL, NULL);
+				      SMB2_OP_POSIX_QUERY_INFO, cfile,
+				      &sidsbuf, &sidsbuflen, NULL, NULL);
+	}
+
+	sidsbuf_end =3D sidsbuf + sidsbuflen;
+
+	owner_len =3D posix_info_sid_size(sidsbuf, sidsbuf_end);
+	if (owner_len =3D=3D -1) {
+		rc =3D EINVAL;
+		goto out;
+	}
+	memcpy(owner, sidsbuf, owner_len);
+
+	group_len =3D posix_info_sid_size(sidsbuf + owner_len, sidsbuf_end);
+	if (group_len =3D=3D -1) {
+		rc =3D EINVAL;
+		goto out;
 	}
+	memcpy(group, sidsbuf + owner_len, group_len);
=20
 out:
+	kfree(sidsbuf);
 	free_rsp_buf(err_buftype[0], err_iov[0].iov_base);
 	free_rsp_buf(err_buftype[1], err_iov[1].iov_base);
 	free_rsp_buf(err_buftype[2], err_iov[2].iov_base);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index be21b5d26f67..d5d7ffb7711c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -277,7 +277,10 @@ extern int smb2_query_info_compound(const unsigned int=
 xid,
 /* query path info from the server using SMB311 POSIX extensions*/
 int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon =
*tcon,
 				 struct cifs_sb_info *cifs_sb, const char *full_path,
-				 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse);
+				 struct cifs_open_info_data *data,
+				 struct cifs_sid *owner,
+				 struct cifs_sid *group,
+				 bool *adjust_tz, bool *reparse);
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
--=20
2.30.2


--N4dM0t8o7i/ylWYm--
