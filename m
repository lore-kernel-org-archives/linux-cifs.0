Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F235C6FD1F
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Mar 2023 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCSTVE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Mar 2023 15:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjCSTUp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Mar 2023 15:20:45 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC91E9FC
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 12:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=Content-Type:MIME-Version:Reply-To:Message-ID:Subject:Cc:To
        :From:Date:Sender:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rXJ4Tjmmv4FKWq5bLcUkClc3YOxMPVygW616mRMmOko=; b=e3f4vgWiK/Jcw1OsAr/ez5q9Ze
        qkRbvd3KPVQBeiREL1l3NVx6oB6ifgQBXCSzeQuUUSa/QGKNor66hTy7rTQs4wxveZlpOK/nKPcgG
        tL7q/DgRmx4+Ild9j9cp7xpQtYg0uQDWEj2QVAskseYwfz/WjWRkLPpe7s1/tIYmFcJHYF4aKHlrV
        ZEFXPOJ+5kF449NdjbaxS5RDrPxS376IfF2dZDViRecv0u/B8FHW7ozAqD+FTehcJp0JqK1Gb9TJ2
        5WAVZrIhO0F96z3VDONs9pcoPg19FEDy1Gn234hWjnVWLrBZo+5HQHExyNHDZSJ59XyQif7QBEWGo
        9QsPbG+w==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=Content-Type:MIME-Version:Reply-To:
        Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rXJ4Tjmmv4FKWq5bLcUkClc3YOxMPVygW616mRMmOko=; b=cJPgBU1mT5fwRI3ALug0G7Phkg
        j66Q0Jf/GErsC2aTi+0Kl2N9mN8DP/fxiqlNOBtkt3aIc/n45vVmZWQyWBBQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1pdyYU-00878D-NH; Sun, 19 Mar 2023 20:18:58 +0100
Received: by intern.sernet.de
        id 1pdyYU-00FeG8-Dz; Sun, 19 Mar 2023 20:18:58 +0100
Date:   Sun, 19 Mar 2023 20:18:52 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Cc:     Paulo Alcantara <pc@manguebit.com>,
        Steve French <smfrench@gmail.com>
Subject: Helper functions for smb2 compound ops
Message-ID: <ZBdgHL3J+UVViuOI@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Z+tfZXSlSSTpyS5"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--4Z+tfZXSlSSTpyS5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

This is not a formal patchset, more a request for comments.

In fs/cifs when doing compound operations I see a lot of fiddly
boilerplate code. Attached find a little patchset that introduces a
struct smb2_compound_op capturing most of that boilerplate code, along
with a few sample uses.

Is that worth exploring further?

Thanks,

Volker

--4Z+tfZXSlSSTpyS5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="smb2_compound_op.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 171cceab65b87153d165ffb86c7bd218facb3e51 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 16:53:18 +0100
Subject: [PATCH 1/6] cifs: Add required includes to cifsfs.h

struct file and a few others are referenced in prototypes.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/cifsfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 71fe0a0a7992..23391162391e 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -9,6 +9,9 @@
 #ifndef _CIFSFS_H
 #define _CIFSFS_H
=20
+#include <linux/dcache.h>
+#include <linux/fs.h>
+
 #include <linux/hash.h>
=20
 #define ROOT_I 2
--=20
2.30.2


=46rom ab37ec994a2d6f5e98760b85c3cb31582676e322 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 16:54:50 +0100
Subject: [PATCH 2/6] cifs: Add struct smb2_compound_op

Infrastructure to make handling of open/<op>/close easier

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/Makefile       |   1 +
 fs/cifs/smb2compound.c | 200 +++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2compound.h |  33 +++++++
 3 files changed, 234 insertions(+)
 create mode 100644 fs/cifs/smb2compound.c
 create mode 100644 fs/cifs/smb2compound.h

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 304a7f6cc13a..ece58d2e3712 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -10,6 +10,7 @@ cifs-y :=3D trace.o cifsfs.o cifs_debug.o connect.o dir.o=
 file.o \
 	  cached_dir.o cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
 	  smb2ops.o smb2maperror.o smb2transport.o \
+	  smb2compound.o \
 	  smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o fs_context.o \
 	  dns_resolve.o cifs_spnego_negtokeninit.asn1.o asn1.o
=20
diff --git a/fs/cifs/smb2compound.c b/fs/cifs/smb2compound.c
new file mode 100644
index 000000000000..ef64db12cb44
--- /dev/null
+++ b/fs/cifs/smb2compound.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Copyright (c) 2023, Volker Lendecke <vl@samba.org>
+ */
+
+#include "cifsfs.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "smb2pdu.h"
+#include "smb2proto.h"
+#include "smb2compound.h"
+
+struct smb2_compound_op *smb2_compound_op_init(bool openclose,
+					       int num_ops,
+					       int *num_rqst_iovs,
+					       int *op_idx)
+{
+	int num_rqst =3D num_ops;
+	int num_rqst_iov =3D 0;
+	struct smb_rqst *rqst;
+	struct kvec *rqst_iov;
+	struct smb2_compound_op *op;
+	int i;
+
+	if (openclose) {
+		num_rqst +=3D 2;
+		num_rqst_iov +=3D SMB2_CREATE_IOV_SIZE + 1; /* open+close */
+	}
+
+	for (i =3D 0; i < num_ops; i++)
+		num_rqst_iov +=3D num_rqst_iovs[i];
+
+	/*
+	 * For now use a simple approach of multiple allocs. As a
+	 * valid optimization allocate all sub-structures of "op" from
+	 * one kzalloc.
+	 */
+
+	op =3D kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op)
+		return NULL;
+
+	op->num_rqst =3D num_rqst;
+
+	op->rqst =3D kcalloc(num_rqst, sizeof(*op->rqst), GFP_KERNEL);
+	if (!op->rqst)
+		goto nomem;
+
+	op->rqst_iov =3D kcalloc(num_rqst_iov, sizeof(*op->rqst_iov), GFP_KERNEL);
+	if (!op->rqst_iov)
+		goto nomem;
+
+	op->resp_buftype =3D kcalloc(num_rqst,
+				   sizeof(*op->resp_buftype),
+				   GFP_KERNEL);
+	if (!op->resp_buftype)
+		goto nomem;
+
+	op->rsp_iov =3D kcalloc(num_rqst, sizeof(*op->rsp_iov), GFP_KERNEL);
+	if (!op->rsp_iov)
+		goto nomem;
+
+	/*
+	 * Fill all op->rqst->rqst_iov structures
+	 */
+
+	rqst =3D op->rqst;
+	rqst_iov =3D op->rqst_iov;
+
+	if (openclose) {
+		/* open request */
+		rqst->rq_iov =3D rqst_iov;
+		rqst->rq_nvec =3D SMB2_CREATE_IOV_SIZE;
+		rqst_iov +=3D SMB2_CREATE_IOV_SIZE;
+		rqst++;
+	}
+
+	for (i =3D 0; i < num_ops; i++) {
+		rqst->rq_iov =3D rqst_iov;
+		rqst->rq_nvec =3D num_rqst_iovs[i];
+		rqst_iov +=3D num_rqst_iovs[i];
+		rqst++;
+	}
+
+	if (openclose) {
+		/* close request */
+		rqst->rq_iov =3D rqst_iov;
+		rqst->rq_nvec =3D 1;
+		rqst_iov +=3D 1;
+		rqst++;
+	}
+
+	if (op_idx)
+		*op_idx =3D openclose ? 1 : 0;
+
+	return op;
+nomem:
+	smb2_compound_op_free(op);
+	return NULL;
+}
+
+void smb2_compound_op_free(struct smb2_compound_op *op)
+{
+	for (int i =3D 0; i < op->num_rqst; i++) {
+		struct smb_rqst *rqst =3D &op->rqst[i];
+		struct smb2_hdr *hdr =3D rqst->rq_iov[0].iov_base;
+
+		switch (hdr->Command) {
+		case SMB2_CREATE:
+			SMB2_open_free(rqst);
+			break;
+		case SMB2_QUERY_INFO:
+			SMB2_query_info_free(rqst);
+			break;
+		case SMB2_SET_INFO:
+			SMB2_set_info_free(rqst);
+			break;
+		case SMB2_IOCTL:
+			SMB2_ioctl_free(rqst);
+			break;
+		case SMB2_CLOSE:
+			SMB2_close_free(rqst);
+			break;
+		}
+	}
+
+	if (op->rsp_iov && op->resp_buftype) {
+		for (int i =3D 0; i < op->num_rqst; i++)
+			free_rsp_buf(op->resp_buftype[i],
+				     op->rsp_iov[i].iov_base);
+	}
+
+	kfree(op->rsp_iov);
+	kfree(op->resp_buftype);
+	kfree(op->rqst_iov);
+	kfree(op->rqst);
+	kfree(op);
+}
+
+int smb2_compound_openclose(struct smb2_compound_op *op,
+			    struct cifs_sb_info *cifs_sb,
+			    struct cifs_tcon *tcon,
+			    struct TCP_Server_Info *server,
+			    __u8 *oplock, struct cifs_open_parms *oparms,
+			    const char *path)
+{
+	__le16 *utf16_path =3D NULL;
+	u8 none_oplock =3D SMB2_OPLOCK_LEVEL_NONE;
+	int rc;
+
+	utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	if (!oplock)
+		oplock =3D &none_oplock;
+
+	oparms->fid =3D &op->fid;
+
+	rc =3D SMB2_open_init(tcon, server, &op->rqst[0], oplock, oparms,
+			    utf16_path);
+
+	kfree(utf16_path);
+
+	if (rc)
+		return rc;
+
+	rc =3D SMB2_close_init(tcon, server, &op->rqst[op->num_rqst-1],
+			     COMPOUND_FID, COMPOUND_FID, false);
+	return rc;
+}
+
+static void smb2_compound_set_related(struct cifs_tcon *tcon,
+			       struct smb2_compound_op *op)
+{
+	smb2_set_next_command(tcon, &op->rqst[0]);
+
+	for (int i =3D 1; i < op->num_rqst; i++) {
+		smb2_set_next_command(tcon, &op->rqst[i]);
+		smb2_set_related(&op->rqst[i]);
+	}
+}
+
+int smb2_compound_send_recv(const unsigned int xid,
+			    struct cifs_tcon *tcon,
+			    struct cifs_ses *ses,
+			    struct TCP_Server_Info *server,
+			    struct smb2_compound_op *op)
+{
+	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
+
+	if (smb3_encryption_required(tcon))
+		flags |=3D CIFS_TRANSFORM_REQ;
+
+	smb2_compound_set_related(tcon, op);
+
+	return compound_send_recv(xid, ses, server, flags,
+				  op->num_rqst, op->rqst,
+				  op->resp_buftype, op->rsp_iov);
+}
diff --git a/fs/cifs/smb2compound.h b/fs/cifs/smb2compound.h
new file mode 100644
index 000000000000..0a4116ef32ba
--- /dev/null
+++ b/fs/cifs/smb2compound.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *  Copyright (c) 2023, Volker Lendecke <vl@samba.org>
+ */
+
+struct smb2_compound_op {
+	struct cifs_fid fid;
+	int num_rqst;
+	struct smb_rqst *rqst;
+	struct kvec *rqst_iov;
+	int *resp_buftype;
+	struct kvec *rsp_iov;
+};
+
+struct smb2_compound_op *smb2_compound_op_init(bool openclose,
+					       int num_ops,
+					       int *num_rqst_iovs,
+					       int *op_idx);
+
+void smb2_compound_op_free(struct smb2_compound_op *op);
+
+int smb2_compound_openclose(struct smb2_compound_op *op,
+			    struct cifs_sb_info *cifs_sb,
+			    struct cifs_tcon *tcon,
+			    struct TCP_Server_Info *server,
+			    __u8 *oplock, struct cifs_open_parms *oparms,
+			    const char *path);
+
+int smb2_compound_send_recv(const unsigned int xid,
+			    struct cifs_tcon *tcon,
+			    struct cifs_ses *ses,
+			    struct TCP_Server_Info *server,
+			    struct smb2_compound_op *op);
--=20
2.30.2


=46rom a6deeaeddba1be71d8feca93579bbd128db682c3 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 16:25:07 +0100
Subject: [PATCH 3/6] cifs: Use smb2_compound_op in smb2_query_info_compound

Remove special-case code

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2ops.c | 120 +++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 87 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6dfb865ee9d7..bf539c9d2cf8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -28,6 +28,7 @@
 #include "fscache.h"
 #include "fs_context.h"
 #include "cached_dir.h"
+#include "smb2compound.h"
=20
 /* Change credits for different ops and return the total number of credits=
 */
 static int
@@ -2460,32 +2461,16 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 {
 	struct cifs_ses *ses =3D tcon->ses;
 	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
-	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
-	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec close_iov[1];
-	u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
-	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
+	__u64 persistent_fid =3D COMPOUND_FID;
+	__u64 volatile_fid =3D COMPOUND_FID;
+	struct smb2_compound_op *op =3D NULL;
+	int num_qi_iov =3D 1;
+	int op_idx =3D 0;
 	int rc;
-	__le16 *utf16_path;
 	struct cached_fid *cfid =3D NULL;
=20
 	if (!path)
 		path =3D "";
-	utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
-
-	if (smb3_encryption_required(tcon))
-		flags |=3D CIFS_TRANSFORM_REQ;
-
-	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_NO_BUFFE=
R;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
=20
 	/*
 	 * We can only call this for things we know are directories.
@@ -2494,73 +2479,38 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 		open_cached_dir(xid, tcon, path, cifs_sb, false,
 				&cfid); /* cfid null if open dir failed */
=20
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov =3D open_iov;
-	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
-
-	oparms =3D (struct cifs_open_parms) {
-		.tcon =3D tcon,
-		.desired_access =3D desired_access,
-		.disposition =3D FILE_OPEN,
-		.create_options =3D cifs_create_options(cifs_sb, 0),
-		.fid =3D &fid,
-	};
-
-	rc =3D SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, utf16_path);
-	if (rc)
+	op =3D smb2_compound_op_init(!cfid, 1, &num_qi_iov, &op_idx);
+	if (!op) {
+		rc =3D -ENOMEM;
 		goto qic_exit;
-	smb2_set_next_command(tcon, &rqst[0]);
-
-	memset(&qi_iov, 0, sizeof(qi_iov));
-	rqst[1].rq_iov =3D qi_iov;
-	rqst[1].rq_nvec =3D 1;
+	}
=20
 	if (cfid) {
-		rc =3D SMB2_query_info_init(tcon, server,
-					  &rqst[1],
-					  cfid->fid.persistent_fid,
-					  cfid->fid.volatile_fid,
-					  class, type, 0,
-					  output_len, 0,
-					  NULL);
+		persistent_fid =3D cfid->fid.persistent_fid;
+		volatile_fid =3D cfid->fid.volatile_fid;
 	} else {
-		rc =3D SMB2_query_info_init(tcon, server,
-					  &rqst[1],
-					  COMPOUND_FID,
-					  COMPOUND_FID,
-					  class, type, 0,
-					  output_len, 0,
-					  NULL);
-	}
-	if (rc)
-		goto qic_exit;
-	if (!cfid) {
-		smb2_set_next_command(tcon, &rqst[1]);
-		smb2_set_related(&rqst[1]);
-	}
-
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov =3D close_iov;
-	rqst[2].rq_nvec =3D 1;
+		struct cifs_open_parms oparms =3D {
+			.tcon =3D tcon,
+			.desired_access =3D desired_access,
+			.disposition =3D FILE_OPEN,
+			.create_options =3D cifs_create_options(cifs_sb, 0),
+		};
+		rc =3D smb2_compound_openclose(op, cifs_sb, tcon, server, NULL,
+					     &oparms, path);
+		if (rc)
+			goto qic_exit;
+	};
=20
-	rc =3D SMB2_close_init(tcon, server,
-			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
+	rc =3D SMB2_query_info_init(tcon, server, &op->rqst[op_idx],
+				  persistent_fid, volatile_fid,
+				  class, type, 0,
+				  output_len, 0,
+				  NULL);
 	if (rc)
 		goto qic_exit;
-	smb2_set_related(&rqst[2]);
=20
-	if (cfid) {
-		rc =3D compound_send_recv(xid, ses, server,
-					flags, 1, &rqst[1],
-					&resp_buftype[1], &rsp_iov[1]);
-	} else {
-		rc =3D compound_send_recv(xid, ses, server,
-					flags, 3, rqst,
-					resp_buftype, rsp_iov);
-	}
+	rc =3D smb2_compound_send_recv(xid, tcon, ses, server, op);
 	if (rc) {
-		free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 		if (rc =3D=3D -EREMCHG) {
 			tcon->need_reconnect =3D true;
 			pr_warn_once("server share %s deleted\n",
@@ -2568,16 +2518,12 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 		}
 		goto qic_exit;
 	}
-	*rsp =3D rsp_iov[1];
-	*buftype =3D resp_buftype[1];
+	*rsp =3D op->rsp_iov[1];
+	*buftype =3D op->resp_buftype[1];
+	op->resp_buftype[1] =3D CIFS_NO_BUFFER; /* don't free here */
=20
  qic_exit:
-	kfree(utf16_path);
-	SMB2_open_free(&rqst[0]);
-	SMB2_query_info_free(&rqst[1]);
-	SMB2_close_free(&rqst[2]);
-	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	smb2_compound_op_free(op);
 	if (cfid)
 		close_cached_dir(cfid);
 	return rc;
--=20
2.30.2


=46rom c22a9bffca9b804d838bd176785d4c886b0938d4 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 17:50:59 +0100
Subject: [PATCH 4/6] cifs: Use smb2_compound_op in smb2_unlink()

Reduce use of smb2_compound_op()

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2glob.h  |  1 -
 fs/cifs/smb2inode.c | 54 +++++++++++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 82e916ad167c..d9e7c122eee5 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -29,7 +29,6 @@
 #define SMB2_OP_QUERY_DIR 4
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
-#define SMB2_OP_DELETE 7
 #define SMB2_OP_HARDLINK 8
 #define SMB2_OP_SET_EOF 9
 #define SMB2_OP_RMDIR 10
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8dd3791b5c53..d1529ade2e58 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -25,6 +25,7 @@
 #include "smb2proto.h"
 #include "cached_dir.h"
 #include "smb2status.h"
+#include "smb2compound.h"
=20
 static void
 free_set_inf_compound(struct smb_rqst *rqst)
@@ -199,9 +200,6 @@ static int smb2_compound_op(const unsigned int xid, str=
uct cifs_tcon *tcon,
 		num_rqst++;
 		trace_smb3_posix_query_info_compound_enter(xid, ses->Suid, tcon->tid, fu=
ll_path);
 		break;
-	case SMB2_OP_DELETE:
-		trace_smb3_delete_enter(xid, ses->Suid, tcon->tid, full_path);
-		break;
 	case SMB2_OP_MKDIR:
 		/*
 		 * Directories are created through parameters in the
@@ -473,14 +471,6 @@ static int smb2_compound_op(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 		else
 			trace_smb3_posix_query_info_compound_done(xid, ses->Suid, tcon->tid);
 		break;
-	case SMB2_OP_DELETE:
-		if (rc)
-			trace_smb3_delete_err(xid,  ses->Suid, tcon->tid, rc);
-		else
-			trace_smb3_delete_done(xid, ses->Suid, tcon->tid);
-		if (rqst[1].rq_iov)
-			SMB2_close_free(&rqst[1]);
-		break;
 	case SMB2_OP_MKDIR:
 		if (rc)
 			trace_smb3_mkdir_err(xid,  ses->Suid, tcon->tid, rc);
@@ -748,9 +738,45 @@ int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *na=
me,
 	    struct cifs_sb_info *cifs_sb)
 {
-	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, NULL, NULL, NULL, NULL);
+	struct cifs_ses *ses =3D tcon->ses;
+	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
+	struct cifs_open_parms oparms =3D {
+		.tcon =3D tcon,
+		.desired_access =3D DELETE,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb,
+						      CREATE_DELETE_ON_CLOSE |
+						      OPEN_REPARSE_POINT),
+		.mode =3D ACL_NO_MODE,
+		.cifs_sb =3D cifs_sb,
+	};
+	struct smb2_compound_op *op =3D NULL;
+	int rc;
+
+	trace_smb3_delete_enter(xid, ses->Suid, tcon->tid, name);
+
+	op =3D smb2_compound_op_init(true, 0, NULL, NULL);
+	if (!op) {
+		rc =3D -ENOMEM;
+		goto fail;
+	}
+
+	rc =3D smb2_compound_openclose(op, cifs_sb, tcon, server, NULL, &oparms,
+				     name);
+	if (rc)
+		goto fail;
+
+	rc =3D smb2_compound_send_recv(xid, tcon, ses, server, op);
+
+fail:
+	smb2_compound_op_free(op);
+
+	if (rc)
+		trace_smb3_delete_err(xid,  ses->Suid, tcon->tid, rc);
+	else
+		trace_smb3_delete_done(xid, ses->Suid, tcon->tid);
+
+	return rc;
 }
=20
 static int
--=20
2.30.2


=46rom 71c8b6024ad6438712e0a0ab35710fa6ea7bc3f2 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 19:02:36 +0100
Subject: [PATCH 5/6] cifs: Use smb2_compound_op in smb2_set_path_size()

Avoid boilerplate code

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2glob.h  |   1 -
 fs/cifs/smb2inode.c | 101 ++++++++++++++++++++++++--------------------
 2 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index d9e7c122eee5..897c16c4ea69 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -30,7 +30,6 @@
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_HARDLINK 8
-#define SMB2_OP_SET_EOF 9
 #define SMB2_OP_RMDIR 10
 #define SMB2_OP_POSIX_QUERY_INFO 11
=20
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index d1529ade2e58..787d17d0c6db 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -225,41 +225,6 @@ static int smb2_compound_op(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 		smb2_set_related(&rqst[num_rqst++]);
 		trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
-	case SMB2_OP_SET_EOF:
-		rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
-		rqst[num_rqst].rq_nvec =3D 1;
-
-		size[0] =3D 8; /* sizeof __le64 */
-		data[0] =3D ptr;
-
-		if (cfile) {
-			rc =3D SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst],
-						cfile->fid.persistent_fid,
-						cfile->fid.volatile_fid,
-						current->tgid,
-						FILE_END_OF_FILE_INFORMATION,
-						SMB2_O_INFO_FILE, 0,
-						data, size);
-		} else {
-			rc =3D SMB2_set_info_init(tcon, server,
-						&rqst[num_rqst],
-						COMPOUND_FID,
-						COMPOUND_FID,
-						current->tgid,
-						FILE_END_OF_FILE_INFORMATION,
-						SMB2_O_INFO_FILE, 0,
-						data, size);
-			if (!rc) {
-				smb2_set_next_command(tcon, &rqst[num_rqst]);
-				smb2_set_related(&rqst[num_rqst]);
-			}
-		}
-		if (rc)
-			goto finished;
-		num_rqst++;
-		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
-		break;
 	case SMB2_OP_SET_INFO:
 		rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec =3D 1;
@@ -500,13 +465,6 @@ static int smb2_compound_op(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 			trace_smb3_rmdir_done(xid, ses->Suid, tcon->tid);
 		free_set_inf_compound(rqst);
 		break;
-	case SMB2_OP_SET_EOF:
-		if (rc)
-			trace_smb3_set_eof_err(xid,  ses->Suid, tcon->tid, rc);
-		else
-			trace_smb3_set_eof_done(xid, ses->Suid, tcon->tid);
-		free_set_inf_compound(rqst);
-		break;
 	case SMB2_OP_SET_INFO:
 		if (rc)
 			trace_smb3_set_info_compound_err(xid,  ses->Suid,
@@ -830,13 +788,64 @@ smb2_set_path_size(const unsigned int xid, struct cif=
s_tcon *tcon,
 		   const char *full_path, __u64 size,
 		   struct cifs_sb_info *cifs_sb, bool set_alloc)
 {
+	struct cifs_ses *ses =3D tcon->ses;
+	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
+	__u64 persistent_fid =3D COMPOUND_FID;
+	__u64 volatile_fid =3D COMPOUND_FID;
+	struct smb2_compound_op *op =3D NULL;
+	int num_si_iov =3D 1;
+	int op_idx =3D 0;
+	int rc;
+	struct cifsFileInfo *cfile =3D NULL;
 	__le64 eof =3D cpu_to_le64(size);
-	struct cifsFileInfo *cfile;
+
+	unsigned int sizes =3D sizeof(eof);
+	void *data =3D &eof;
+
+	trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
=20
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
-	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
-				FILE_WRITE_DATA, FILE_OPEN, 0, ACL_NO_MODE,
-				&eof, SMB2_OP_SET_EOF, cfile, NULL, NULL, NULL, NULL);
+
+	op =3D smb2_compound_op_init(!cfile, 1, &num_si_iov, &op_idx);
+	if (!op) {
+		rc =3D -ENOMEM;
+		goto fail;
+	}
+
+	if (cfile) {
+		persistent_fid =3D cfile->fid.persistent_fid;
+		volatile_fid =3D cfile->fid.volatile_fid;
+	} else {
+		struct cifs_open_parms oparms =3D {
+			.tcon =3D tcon,
+			.desired_access =3D FILE_WRITE_DATA,
+			.disposition =3D FILE_OPEN,
+			.create_options =3D cifs_create_options(cifs_sb, 0),
+			.mode =3D ACL_NO_MODE,
+		};
+		rc =3D smb2_compound_openclose(op, cifs_sb, tcon, server, NULL,
+					     &oparms, full_path);
+		if (rc)
+			goto fail;
+	}
+
+	rc =3D SMB2_set_info_init(tcon, server, &op->rqst[op_idx],
+				persistent_fid, volatile_fid,
+				current->tgid, FILE_END_OF_FILE_INFORMATION,
+				SMB2_O_INFO_FILE, 0, &data, &sizes);
+	if (!rc)
+		goto fail;
+
+	rc =3D smb2_compound_send_recv(xid, tcon, ses, server, op);
+fail:
+	smb2_compound_op_free(op);
+
+	if (rc)
+		trace_smb3_set_eof_err(xid,  ses->Suid, tcon->tid, rc);
+	else
+		trace_smb3_set_eof_done(xid, ses->Suid, tcon->tid);
+
+	return rc;
 }
=20
 int
--=20
2.30.2


=46rom 35f02f7d37624e37f33eb53a4071c156a8d422a8 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Sun, 19 Mar 2023 19:22:23 +0100
Subject: [PATCH 6/6] cifs: Use smb2_compound_op in smb2_query_symlink()

Avoid boilerplate code

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2ops.c | 83 +++++++++--------------------------------------
 1 file changed, 16 insertions(+), 67 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bf539c9d2cf8..43b59b33d308 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2832,20 +2832,14 @@ smb2_query_symlink(const unsigned int xid, struct c=
ifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path,
 		   char **target_path, bool is_reparse_point)
 {
+	struct cifs_ses *ses =3D tcon->ses;
+	struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
+	struct smb2_compound_op *op =3D NULL;
+	int num_ioctl_iov =3D SMB2_IOCTL_IOV_SIZE;
+	int op_idx =3D 0;
 	int rc;
-	__le16 *utf16_path =3D NULL;
-	__u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
 	struct kvec err_iov =3D {NULL, 0};
-	struct TCP_Server_Info *server =3D cifs_pick_channel(tcon->ses);
-	int flags =3D CIFS_CP_CREATE_CLOSE_OP;
-	struct smb_rqst rqst[3];
-	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec close_iov[1];
 	struct smb2_create_rsp *create_rsp;
 	struct smb2_ioctl_rsp *ioctl_rsp;
 	struct reparse_data_buffer *reparse_buf;
@@ -2856,75 +2850,37 @@ smb2_query_symlink(const unsigned int xid, struct c=
ifs_tcon *tcon,
=20
 	*target_path =3D NULL;
=20
-	if (smb3_encryption_required(tcon))
-		flags |=3D CIFS_TRANSFORM_REQ;
-
-	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_NO_BUFFE=
R;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
-
-	utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
-	if (!utf16_path)
+	op =3D smb2_compound_op_init(true, 1, &num_ioctl_iov, &op_idx);
+	if (!op)
 		return -ENOMEM;
=20
-	/* Open */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov =3D open_iov;
-	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
-
 	oparms =3D (struct cifs_open_parms) {
 		.tcon =3D tcon,
 		.desired_access =3D FILE_READ_ATTRIBUTES,
 		.disposition =3D FILE_OPEN,
 		.create_options =3D cifs_create_options(cifs_sb, create_options),
-		.fid =3D &fid,
 	};
=20
-	rc =3D SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, utf16_path);
+	rc =3D smb2_compound_openclose(op, cifs_sb, tcon, server, NULL,
+				     &oparms, full_path);
 	if (rc)
 		goto querty_exit;
-	smb2_set_next_command(tcon, &rqst[0]);
-
-
-	/* IOCTL */
-	memset(&io_iov, 0, sizeof(io_iov));
-	rqst[1].rq_iov =3D io_iov;
-	rqst[1].rq_nvec =3D SMB2_IOCTL_IOV_SIZE;
=20
 	rc =3D SMB2_ioctl_init(tcon, server,
-			     &rqst[1], fid.persistent_fid,
-			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
+			     &op->rqst[op_idx], COMPOUND_FID,
+			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 	if (rc)
 		goto querty_exit;
=20
-	smb2_set_next_command(tcon, &rqst[1]);
-	smb2_set_related(&rqst[1]);
-
-
-	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov =3D close_iov;
-	rqst[2].rq_nvec =3D 1;
-
-	rc =3D SMB2_close_init(tcon, server,
-			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
-	if (rc)
-		goto querty_exit;
-
-	smb2_set_related(&rqst[2]);
-
-	rc =3D compound_send_recv(xid, tcon->ses, server,
-				flags, 3, rqst,
-				resp_buftype, rsp_iov);
+	rc =3D smb2_compound_send_recv(xid, tcon, ses, server, op);
=20
-	create_rsp =3D rsp_iov[0].iov_base;
+	create_rsp =3D op->rsp_iov[0].iov_base;
 	if (create_rsp && create_rsp->hdr.Status)
-		err_iov =3D rsp_iov[0];
-	ioctl_rsp =3D rsp_iov[1].iov_base;
+		err_iov =3D op->rsp_iov[0];
+	ioctl_rsp =3D op->rsp_iov[1].iov_base;
=20
 	/*
 	 * Open was successful and we got an ioctl response.
@@ -2938,7 +2894,7 @@ smb2_query_symlink(const unsigned int xid, struct cif=
s_tcon *tcon,
 		plen =3D le32_to_cpu(ioctl_rsp->OutputCount);
=20
 		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
-		    rsp_iov[1].iov_len) {
+		    op->rsp_iov[1].iov_len) {
 			cifs_tcon_dbg(VFS, "srv returned invalid ioctl len: %d\n",
 				 plen);
 			rc =3D -EIO;
@@ -2959,13 +2915,6 @@ smb2_query_symlink(const unsigned int xid, struct ci=
fs_tcon *tcon,
=20
  querty_exit:
 	cifs_dbg(FYI, "query symlink rc %d\n", rc);
-	kfree(utf16_path);
-	SMB2_open_free(&rqst[0]);
-	SMB2_ioctl_free(&rqst[1]);
-	SMB2_close_free(&rqst[2]);
-	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	return rc;
 }
=20
--=20
2.30.2


--4Z+tfZXSlSSTpyS5--
