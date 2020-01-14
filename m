Return-Path: <SRS0=t/jT=3D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F6AC33C9E
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jan 2020 23:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D082075B
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jan 2020 23:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoetUD6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgANXpz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jan 2020 18:45:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728757AbgANXpz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jan 2020 18:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579045554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=onsGIkWFBzdfk1KHltW97HcGUAAvBGZFhiHwafDjRZY=;
        b=YoetUD6TAhI+Arw1T1feDD2y5yKbp/5hncJF7LTRX6lms7bNF4Cs0+fJ3/AbXHmvgM3AsQ
        VlV1F5XqqpXzgjXBc/zW1E6we+IsrsnWVT5a9dA1djRTN6nzoOppCSbrcomHyKhI11UHHT
        Su08ynszxE7esVXE51Mi909didPfXR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-zvEsx356OaOfZvYyXXCF7A-1; Tue, 14 Jan 2020 18:45:51 -0500
X-MC-Unique: zvEsx356OaOfZvYyXXCF7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C751189CD20;
        Tue, 14 Jan 2020 23:45:50 +0000 (UTC)
Received: from hut.sorensonfamily.com.com (ovpn-117-144.phx2.redhat.com [10.3.117.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87A5184330;
        Tue, 14 Jan 2020 23:45:45 +0000 (UTC)
From:   Frank Sorenson <sorenson@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     stfrench@microsoft.com, sorenson@redhat.com
Subject: [PATCH] cifs: Fix mode output in debugging statements
Date:   Tue, 14 Jan 2020 17:45:44 -0600
Message-Id: <20200114234544.151108-1-sorenson@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

