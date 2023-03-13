Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0E0C74A4B
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Mar 2023 15:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCMPnN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Mar 2023 11:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCMPnG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Mar 2023 11:43:06 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB113D67
        for <linux-cifs@vger.kernel.org>; Mon, 13 Mar 2023 08:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tfqGrZXisno5OZFClFE/jUAxA+F0S/pxsX710geJ6UA=; b=aR1I/0VKc0gbapH8rB6oYumGl4
        dxdMuxYzk3UXIpQZR4JJ9G29Sa5xdDU+SN8O7om2HtZQGsla0GvzhS0rUgbranh2eTyT+eZQl+Y7Z
        fz7dKSBEh9CmXrOgcvRp3zF2FSejzOXqK5ue2py9E36vv4r/pWlq3QZWIT6qm/wf96spn2n9bAUra
        XTngkNFJj8DtWOYxhmIls4X7YEOhwyf5UySF1nREDGaqvGQmULbK/nbwPS2k4nYoCPzZOTrA27z/n
        3Zf4sxTk3ZVKW0DB1JShS2rpOMMxDj3Npv7VQzuXVSG3a6ZPWGKASWjMrbZgc/r2zX84N+NbrtNr+
        xuU2DWIQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Type:MIME-Version:
        References:Reply-To:Message-ID:Subject:To:From:Date:Sender:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tfqGrZXisno5OZFClFE/jUAxA+F0S/pxsX710geJ6UA=; b=WRiG5FydsH4yJRtXUP8LTCRnQu
        9VMWw2KpeXXHgG9BjGh4B+Y/ypv+aCpLANi2Pmk7r5k9SdQytyxzI8671jDw==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1pbkKD-001JsZ-Jt; Mon, 13 Mar 2023 16:43:01 +0100
Received: by intern.sernet.de
        id 1pbkKD-00DtUG-AF; Mon, 13 Mar 2023 16:43:01 +0100
Date:   Mon, 13 Mar 2023 16:42:57 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Re: Fix setting EOF
Message-ID: <ZA9EgUzqLhHGfTPZ@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <ZA8/B2wzQP8mEtRn@sernet.de>
 <ZA9ASbdsD0AJH6wV@sernet.de>
 <ZA9BJaoO4TJfjh3C@sernet.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pZdtV1WWVRTI3L8w"
Content-Disposition: inline
In-Reply-To: <ZA9BJaoO4TJfjh3C@sernet.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--pZdtV1WWVRTI3L8w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am Mon, Mar 13, 2023 at 04:28:37PM +0100 schrieb Volker Lendecke:
> Here's the updated version.
> 
> Sorry for the noise,

It's not my day today, V3....

Volker

--pZdtV1WWVRTI3L8w
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-cifs-Fix-smb2_set_path_size.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 41e6250b60b5ba3d262b50f97e8b01df67ccecc4 Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Mon, 13 Mar 2023 16:09:54 +0100
Subject: [PATCH] cifs: Fix smb2_set_path_size()

If cifs_get_writable_path() finds a writable file, smb2_compound_op()
must use that file's FID and not the COMPOUND_FID.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9b956294e864..8dd3791b5c53 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -234,15 +234,32 @@ static int smb2_compound_op(const unsigned int xid, s=
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
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
--=20
2.30.2


--pZdtV1WWVRTI3L8w--
