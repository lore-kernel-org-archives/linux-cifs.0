Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E02C61DA4
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 18:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBISbK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBISbJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 13:31:09 -0500
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2F666F8D
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 10:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:
        Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZgPJdTKkEchtjoJUkGlRi6UhHvhUQpp6GWyrjdQqLWY=; b=lJDV56WW5mhPMGKxyYXqv7gVyv
        cELMar5yM8mPWacx+4OEJ81bldEjvNdimGTwVxX9GtAjzXvDzg+icQA2jC5KuU+T4d3aCJ8xCExu2
        UXkMPr37Y+Xmosbkg/SXUTnIedKF+YGTNPzAcgkUruUuGooIV31Ez47tI9Tr2FWK18LPSyj+TgBFz
        gUHu+yoGMYi4aemSVgaTN5DFRax1ye6OzCGQVniG68aRRWiTWsBgv+lYU8V50D+BliTd6csXFSz8U
        EW1PrH8DQgmNWVsr/DBqwKz4kF4WM7rrUYbzPbVB6PYEUvmqCuNDrH/Tn3m96gJppwjthPFjMYiz/
        frhPGHIw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Type:MIME-Version:
        References:Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZgPJdTKkEchtjoJUkGlRi6UhHvhUQpp6GWyrjdQqLWY=; b=flY5fcDw8IKYsRpRe0pnKfJFUm
        2dXYVIlbLrV6COl6iso51Wb2qrYK1VcR5k9cVUIVVIJDORzSg1W9+LKRTJAw==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1pQBhD-00GcO0-Qj; Thu, 09 Feb 2023 19:30:59 +0100
Received: by intern.sernet.de
        id 1pQBhD-009fL9-GA; Thu, 09 Feb 2023 19:30:59 +0100
Date:   Thu, 9 Feb 2023 19:30:55 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
Message-ID: <Y+U732UR3W6ueVBn@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <Y+UrrjvGrOT6Bcmy@sernet.de>
 <87lel6enq6.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RIFQJ5k1SsU4Y9Et"
Content-Disposition: inline
In-Reply-To: <87lel6enq6.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--RIFQJ5k1SsU4Y9Et
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am Thu, Feb 09, 2023 at 02:46:09PM -0300 schrieb Paulo Alcantara:
> Please go through all of them.

Attached. I've used an emacs macro, so I'm pretty convinced I did not
change semantics, but this kind of sweeping change needs close review
obviously.

> Perhaps initialise those structures as below
> 
>         struct cifs_open_parms oparms = {};
> 
> and then avoid any uninitialised data to be sent.

For easier review I've not touched the variable declarations yet but
only changed the initialization to use a struct init.

> Patch looks good.

Thanks,

Volker


--RIFQJ5k1SsU4Y9Et
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch.txt"
Content-Transfer-Encoding: quoted-printable

=46rom e1c035f8b7e2a989034af67a2b135fdd1c2d1bf7 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Wed, 11 Jan 2023 12:37:58 +0100
Subject: [PATCH] cifs: Fix uninitialized memory reads for oparms.mode

Use a struct assignment with implicit member initialization

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/cached_dir.c |  13 +--
 fs/cifs/cifsacl.c    |  34 ++++----
 fs/cifs/cifssmb.c    |  17 ++--
 fs/cifs/dir.c        |  19 ++--
 fs/cifs/file.c       |  35 ++++----
 fs/cifs/inode.c      |  53 +++++------
 fs/cifs/link.c       |  66 +++++++-------
 fs/cifs/smb1ops.c    |  72 +++++++--------
 fs/cifs/smb2inode.c  |  17 ++--
 fs/cifs/smb2ops.c    | 204 +++++++++++++++++++++++--------------------
 10 files changed, 281 insertions(+), 249 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 60399081046a..b36ae64034a3 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -181,12 +181,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	oparms.tcon =3D tcon;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_FILE);
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.fid =3D pfid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_FILE),
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.fid =3D pfid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bbf58c2439da..3cc3471199f5 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1428,14 +1428,15 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struc=
t cifs_sb_info *cifs_sb,
 	tcon =3D tlink_tcon(tlink);
 	xid =3D get_xid();
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D READ_CONTROL;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D READ_CONTROL,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.disposition =3D FILE_OPEN,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (!rc) {
@@ -1494,14 +1495,15 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 ac=
llen,
 	else
 		access_flags =3D WRITE_DAC;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D access_flags;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D access_flags,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.disposition =3D FILE_OPEN,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc) {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 23f10e0d6e7e..8c014a3ff9e0 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5372,14 +5372,15 @@ CIFSSMBSetPathInfoFB(const unsigned int xid, struct=
 cifs_tcon *tcon,
 	struct cifs_fid fid;
 	int rc;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_WRITE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D fileName;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_WRITE,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.disposition =3D FILE_OPEN,
+		.path =3D fileName,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ad4208bf1e32..1bf61778f44c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -304,15 +304,16 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
 	if (!tcon->unix_ext && (mode & S_IWUGO) =3D=3D 0)
 		create_options |=3D CREATE_OPTION_READONLY;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D desired_access;
-	oparms.create_options =3D cifs_create_options(cifs_sb, create_options);
-	oparms.disposition =3D disposition;
-	oparms.path =3D full_path;
-	oparms.fid =3D fid;
-	oparms.reconnect =3D false;
-	oparms.mode =3D mode;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D desired_access,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.disposition =3D disposition,
+		.path =3D full_path,
+		.fid =3D fid,
+		.mode =3D mode,
+	};
 	rc =3D server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 22dfc1f8b4f1..e68930176e60 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -260,14 +260,15 @@ static int cifs_nt_open(const char *full_path, struct=
 inode *inode, struct cifs_
 	if (f_flags & O_DIRECT)
 		create_options |=3D CREATE_NO_BUFFER;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D desired_access;
-	oparms.create_options =3D cifs_create_options(cifs_sb, create_options);
-	oparms.disposition =3D disposition;
-	oparms.path =3D full_path;
-	oparms.fid =3D fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D desired_access,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.disposition =3D disposition,
+		.path =3D full_path,
+		.fid =3D fid,
+	};
=20
 	rc =3D server->ops->open(xid, &oparms, oplock, buf);
 	if (rc)
@@ -848,14 +849,16 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can=
_flush)
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D desired_access;
-	oparms.create_options =3D cifs_create_options(cifs_sb, create_options);
-	oparms.disposition =3D disposition;
-	oparms.path =3D full_path;
-	oparms.fid =3D &cfile->fid;
-	oparms.reconnect =3D true;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D desired_access,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.disposition =3D disposition,
+		.path =3D full_path,
+		.fid =3D &cfile->fid,
+		.reconnect =3D true,
+	};
=20
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f145a59af89b..7d0cc39d2921 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -508,14 +508,15 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *p=
ath,
 		return PTR_ERR(tlink);
 	tcon =3D tlink_tcon(tlink);
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_READ;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_READ,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	if (tcon->ses->server->oplocks)
 		oplock =3D REQ_OPLOCK;
@@ -1518,14 +1519,15 @@ cifs_rename_pending_delete(const char *full_path, s=
truct dentry *dentry,
 		goto out;
 	}
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D DELETE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D full_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D DELETE | FILE_WRITE_ATTRIBUTES,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.path =3D full_path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc !=3D 0)
@@ -2112,15 +2114,16 @@ cifs_do_rename(const unsigned int xid, struct dentr=
y *from_dentry,
 	if (to_dentry->d_parent !=3D from_dentry->d_parent)
 		goto do_rename_exit;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	/* open the file to be renamed -- we need DELETE perms */
-	oparms.desired_access =3D DELETE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D from_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		/* open the file to be renamed -- we need DELETE perms */
+		.desired_access =3D DELETE,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.path =3D from_path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc =3D=3D 0) {
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index a5a097a69983..d937eedd74fb 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -271,14 +271,15 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_t=
con *tcon,
 	int buf_type =3D CIFS_NO_BUFFER;
 	FILE_ALL_INFO file_info;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_READ;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_READ,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, &file_info);
 	if (rc)
@@ -313,14 +314,15 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_=
tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms =3D {0};
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_WRITE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_CREATE;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_WRITE,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_CREATE,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -355,13 +357,14 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_t=
con *tcon,
 	__u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
 	struct smb2_file_all_info *pfile_info =3D NULL;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_READ;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_READ,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.fid =3D &fid,
+	};
=20
 	utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path =3D=3D NULL)
@@ -421,14 +424,15 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_=
tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_WRITE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_CREATE;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
-	oparms.mode =3D 0644;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_WRITE,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_CREATE,
+		.fid =3D &fid,
+		.mode =3D 0644,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 4cb364454e13..abda6148be10 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -576,14 +576,15 @@ static int cifs_query_path_info(const unsigned int xi=
d, struct cifs_tcon *tcon,
 		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
 			return 0;
=20
-		oparms.tcon =3D tcon;
-		oparms.cifs_sb =3D cifs_sb;
-		oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-		oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-		oparms.disposition =3D FILE_OPEN;
-		oparms.path =3D full_path;
-		oparms.fid =3D &fid;
-		oparms.reconnect =3D false;
+		oparms =3D (struct cifs_open_parms) {
+			.tcon =3D tcon,
+			.cifs_sb =3D cifs_sb,
+			.desired_access =3D FILE_READ_ATTRIBUTES,
+			.create_options =3D cifs_create_options(cifs_sb, 0),
+			.disposition =3D FILE_OPEN,
+			.path =3D full_path,
+			.fid =3D &fid,
+		};
=20
 		/* Need to check if this is a symbolic link or not */
 		tmprc =3D CIFS_open(xid, &oparms, &oplock, NULL);
@@ -823,14 +824,15 @@ smb_set_file_info(struct inode *inode, const char *fu=
ll_path,
 		goto out;
 	}
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D SYNCHRONIZE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D full_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition =3D FILE_OPEN,
+		.path =3D full_path,
+		.fid =3D &fid,
+	};
=20
 	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not suppor=
ted by this server\n");
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
@@ -998,15 +1000,16 @@ cifs_query_symlink(const unsigned int xid, struct ci=
fs_tcon *tcon,
 		goto out;
 	}
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.create_options =3D cifs_create_options(cifs_sb,
-						    OPEN_REPARSE_POINT);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D full_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.create_options =3D cifs_create_options(cifs_sb,
+						      OPEN_REPARSE_POINT),
+		.disposition =3D FILE_OPEN,
+		.path =3D full_path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -1115,15 +1118,16 @@ cifs_make_node(unsigned int xid, struct inode *inod=
e,
=20
 	cifs_dbg(FYI, "sfu compat create special file\n");
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_WRITE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition =3D FILE_CREATE;
-	oparms.path =3D full_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_WRITE,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition =3D FILE_CREATE,
+		.path =3D full_path,
+		.fid =3D &fid,
+	};
=20
 	if (tcon->ses->server->oplocks)
 		oplock =3D REQ_OPLOCK;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8521adf9ce79..37b4cd59245d 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -105,14 +105,15 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
 		goto finished;
 	}
=20
-	vars->oparms.tcon =3D tcon;
-	vars->oparms.desired_access =3D desired_access;
-	vars->oparms.disposition =3D create_disposition;
-	vars->oparms.create_options =3D cifs_create_options(cifs_sb, create_optio=
ns);
-	vars->oparms.fid =3D &fid;
-	vars->oparms.reconnect =3D false;
-	vars->oparms.mode =3D mode;
-	vars->oparms.cifs_sb =3D cifs_sb;
+	vars->oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D desired_access,
+		.disposition =3D create_disposition,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.fid =3D &fid,
+		.mode =3D mode,
+		.cifs_sb =3D cifs_sb,
+	};
=20
 	rqst[num_rqst].rq_iov =3D &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e6bcd2baf446..36e4bf2b4133 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -729,12 +729,13 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tco=
n *tcon,
 	struct cifs_fid fid;
 	struct cached_fid *cfid =3D NULL;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D open_cached_dir(xid, tcon, "", cifs_sb, false, &cfid);
 	if (rc =3D=3D 0)
@@ -771,12 +772,13 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tco=
n *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -816,12 +818,13 @@ smb2_is_path_accessible(const unsigned int xid, struc=
t cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       &err_iov, &err_buftype);
@@ -1097,13 +1100,13 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_WRITE_EA;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_WRITE_EA,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -1453,12 +1456,12 @@ smb2_ioctl_query_info(const unsigned int xid,
 	rqst[0].rq_iov =3D &vars->open_iov[0];
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon =3D tcon;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, create_options);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.fid =3D &fid,
+	};
=20
 	if (qi.flags & PASSTHRU_FSCTL) {
 		switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
@@ -2088,12 +2091,13 @@ smb3_notify(const unsigned int xid, struct file *pf=
ile,
 	}
=20
 	tcon =3D cifs_sb_master_tcon(cifs_sb);
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
 		       NULL);
@@ -2159,12 +2163,13 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D fid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2490,12 +2495,13 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D desired_access;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D desired_access,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2623,12 +2629,13 @@ smb311_queryfs(const unsigned int xid, struct cifs_=
tcon *tcon,
 	if (!tcon->posix_extensions)
 		return smb2_queryfs(xid, tcon, cifs_sb, buf);
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -2916,13 +2923,13 @@ smb2_query_symlink(const unsigned int xid, struct c=
ifs_tcon *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, create_options);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, create_options),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3056,13 +3063,13 @@ smb2_query_reparse_tag(const unsigned int xid, stru=
ct cifs_tcon *tcon,
 	rqst[0].rq_iov =3D open_iov;
 	rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
=20
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, OPEN_REPARSE_POINT=
);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3196,17 +3203,20 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		return ERR_PTR(rc);
 	}
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D READ_CONTROL;
-	oparms.disposition =3D FILE_OPEN;
-	/*
-	 * When querying an ACL, even if the file is a symlink we want to open
-	 * the source not the target, and so the protocol requires that the
-	 * client specify this flag when opening a reparse point
-	 */
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0) | OPEN_REPARSE_=
POINT;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D READ_CONTROL,
+		.disposition =3D FILE_OPEN,
+		/*
+		 * When querying an ACL, even if the file is a symlink
+		 * we want to open the source not the target, and so
+		 * the protocol requires that the client specify this
+		 * flag when opening a reparse point
+		 */
+		.create_options =3D cifs_create_options(cifs_sb, 0) |
+				  OPEN_REPARSE_POINT,
+		.fid =3D &fid,
+	};
=20
 	if (info & SACL_SECINFO)
 		oparms.desired_access |=3D SYSTEM_SECURITY;
@@ -3265,13 +3275,14 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 		return rc;
 	}
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D access_flags;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.disposition =3D FILE_OPEN;
-	oparms.path =3D path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D access_flags,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.disposition =3D FILE_OPEN,
+		.path =3D path,
+		.fid =3D &fid,
+	};
=20
 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -5134,15 +5145,16 @@ smb2_make_node(unsigned int xid, struct inode *inod=
e,
=20
 	cifs_dbg(FYI, "sfu compat create special file\n");
=20
-	oparms.tcon =3D tcon;
-	oparms.cifs_sb =3D cifs_sb;
-	oparms.desired_access =3D GENERIC_WRITE;
-	oparms.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition =3D FILE_CREATE;
-	oparms.path =3D full_path;
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.cifs_sb =3D cifs_sb,
+		.desired_access =3D GENERIC_WRITE,
+		.create_options =3D cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition =3D FILE_CREATE,
+		.path =3D full_path,
+		.fid =3D &fid,
+	};
=20
 	if (tcon->ses->server->oplocks)
 		oplock =3D REQ_OPLOCK;
--=20
2.30.2


--RIFQJ5k1SsU4Y9Et--
