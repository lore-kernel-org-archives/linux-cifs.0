Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69811C6FD19
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Mar 2023 15:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCMPTy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Mar 2023 11:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCMPTo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Mar 2023 11:19:44 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A807160A85
        for <linux-cifs@vger.kernel.org>; Mon, 13 Mar 2023 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=Content-Type:MIME-Version:Reply-To:Message-ID:Subject:To:
        From:Date:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=67ngwVjtit/QjcpP4ryN2LhKX1YC0NtzDK2n7Gcq+pA=; b=lj5GsiuQ0pBKJXJBN875UQBV7g
        JiHe4OGYDMh5gHYIc9Co5NZ1U3Hl+RwX7u/zrX7hQDN8u45l0PZfwKlQYEI9AA6Mo379Gd1slXuky
        O+vk9ksC+4mg+RwBPcP9v0SUZjX+kWJvpgIZrtvXP1l3xv/OEwOqODnWI63bU6aBqEPPzppitDKQv
        3VUAmPZsJy96OUPCLmsgjE+gC0ajuQj6HSXBba2Jkl04vZAMvrCNtFqEB1GCdb2KHO5pLgAcwCN1B
        RmoJkPdWK0ONkyt8vMCbkjV0GYQyTB5TOcJ53KabSZ9lBZ+rpuEIQGFKebzZlNurh/Hp3//6WEHqZ
        E/0aYTqw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=Content-Type:MIME-Version:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=67ngwVjtit/QjcpP4ryN2LhKX1YC0NtzDK2n7Gcq+pA=; b=uHpl0wYbA49lgw+Ks6Qxdm/W8D
        jdRk95P4dwJ3K9K42+xyES9KtUH2k9V/prrF5cccYlJq0qOXWCbcE0fMT2Bw==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1pbjxd-001Iuk-Fu; Mon, 13 Mar 2023 16:19:41 +0100
Received: by intern.sernet.de
        id 1pbjxd-00DtCH-6w; Mon, 13 Mar 2023 16:19:41 +0100
Date:   Mon, 13 Mar 2023 16:19:35 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Fix setting EOF
Message-ID: <ZA8/B2wzQP8mEtRn@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7e0si7IGX2qE5y3O"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--7e0si7IGX2qE5y3O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

b6f2a0f89d7ed introduced looking for a writable path. This patch
should probably have gone with it.

Volker

--7e0si7IGX2qE5y3O
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-cifs-Fix-smb2_set_path_size.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 4b72cd033b5ad1143b11305b07c9fab5c9b610ca Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Mon, 13 Mar 2023 16:09:54 +0100
Subject: [PATCH] cifs: Fix smb2_set_path_size()

If cifs_get_writable_path() finds a writable file, smb2_compound_op()
must use that file's FID and not the COMPOUND_FID.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9b956294e864..63541ad1bab2 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -234,11 +234,29 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
 		size[0] =3D 8; /* sizeof __le64 */
 		data[0] =3D ptr;
=20
-		rc =3D SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile) {
+			rc =3D SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+		} else {
+			rc =3D SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMPOUND_FID,
+						COMPOUND_FID,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
 		if (rc)
 			goto finished;
 		smb2_set_next_command(tcon, &rqst[num_rqst]);
--=20
2.30.2


--7e0si7IGX2qE5y3O--
