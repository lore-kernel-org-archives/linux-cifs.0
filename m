Return-Path: <SRS0=n2zt=4A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30439C352A4
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Feb 2020 21:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF14324673
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Feb 2020 21:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JczRxLXh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBLVb5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:31:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727420AbgBLVb5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 12 Feb 2020 16:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581543116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=onsGIkWFBzdfk1KHltW97HcGUAAvBGZFhiHwafDjRZY=;
        b=JczRxLXhuo+Ev8co5b1qv+HE2HMKpfhjtidO9TVnEyG5MTO/dwXO1McLGK3ZqvG0fWTeis
        Gt0t7m9qHypDvEzUkjsi0IWpti1MRjyyvyxqVq2ZXiiwM6Tcq9QFZP0qjE+SoO70dEGFjN
        d6UOFQYzRyEJoY/f0ipu7NeJ/E0v70w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-b6TRqaPFO8O5IPe9RL0ykg-1; Wed, 12 Feb 2020 16:31:54 -0500
X-MC-Unique: b6TRqaPFO8O5IPe9RL0ykg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A062107ACC7;
        Wed, 12 Feb 2020 21:31:53 +0000 (UTC)
Received: from hut.sorensonfamily.com.com (ovpn-116-92.phx2.redhat.com [10.3.116.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90C1D5DA7B;
        Wed, 12 Feb 2020 21:31:50 +0000 (UTC)
From:   Frank Sorenson <sorenson@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, sorenson@redhat.com
Subject: [PATCH] cifs: Fix mode output in debugging statements
Date:   Wed, 12 Feb 2020 15:31:48 -0600
Message-Id: <20200212213148.1143954-1-sorenson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A number of the debug statements output file or directory mode
in hex.  Change these to print using octal.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/cifs/cifsacl.c | 4 ++--
 fs/cifs/connect.c | 2 +-
 fs/cifs/inode.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 96ae72b556ac..58b4014fecb6 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -601,7 +601,7 @@ static void access_flags_to_mode(__le32 ace_flags, in=
t type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) =3D=3D FILE_EXEC_RIGHTS))
 		*pmode |=3D (S_IXUGO & (*pbits_to_set));
=20
-	cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
+	cifs_dbg(NOISY, "access flags 0x%x mode now %04o\n", flags, *pmode);
 	return;
 }
=20
@@ -630,7 +630,7 @@ static void mode_to_access_flags(umode_t mode, umode_=
t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |=3D SET_FILE_EXEC_RIGHTS;
=20
-	cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
+	cifs_dbg(NOISY, "mode: %04o, access flags now 0x%x\n",
 		 mode, *pace_flags);
 	return;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 05ea0e2b7e0e..071f5d6726e5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4149,7 +4149,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info=
,
 	cifs_sb->mnt_gid =3D pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode =3D pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode =3D pvolume_info->dir_mode;
-	cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
+	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
=20
 	cifs_sb->actimeo =3D pvolume_info->actimeo;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ca76a9287456..b3f3675e1878 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1649,7 +1649,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *=
direntry, umode_t mode)
 	struct TCP_Server_Info *server;
 	char *full_path;
=20
-	cifs_dbg(FYI, "In cifs_mkdir, mode =3D 0x%hx inode =3D 0x%p\n",
+	cifs_dbg(FYI, "In cifs_mkdir, mode =3D %04ho inode =3D 0x%p\n",
 		 mode, inode);
=20
 	cifs_sb =3D CIFS_SB(inode->i_sb);
--=20
2.14.4

