Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA313C61DA4
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Mar 2023 15:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjCMP2s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Mar 2023 11:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjCMP2o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Mar 2023 11:28:44 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CA372024
        for <linux-cifs@vger.kernel.org>; Mon, 13 Mar 2023 08:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XWRyo4FzGjLBtX/zWsF7zZ+4vSMxHTCt6QqNQQMWBhU=; b=VXG6ziahZS2blWqS9DIOJSWdHY
        2YlxpVliANbcYJy18e3QW+4rq4621l6upwOUbyTzcLRyJ86QZ6CNblSQFGjzNUSfwS2OfhUUkYU9f
        c7yCCRsnaSU936u/4bJK1xS0NE53u9wsQ2UMNxHVBnBm7JauQzyD9ZJhuxVl+ias//rpTkiTFGScl
        Y2zVWPfMYFGPxh6i3Vo2jsJfcKO4xxNaRlbLjZ+rRmsNDLCZiqx6MzQ5JB+q/tF28ZAlu0y3W2qGq
        3YS8F6WeFdaIogSARDzRe19Uy8kkXACjsc/njZ74MatgHzrFmHdHc5xle03qK/wDAfo0twOzt+w7Z
        DjR4vXQQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Type:MIME-Version:
        References:Reply-To:Message-ID:Subject:To:From:Date:Sender:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XWRyo4FzGjLBtX/zWsF7zZ+4vSMxHTCt6QqNQQMWBhU=; b=IM0WwvQ6dCwpM/SBGg0CrdcJak
        GCZcG1Jh+1f7lPDzkdaVK90iEnfFP4pCHorkivld63HLlIGVw779zN3zxSAQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1pbk6M-001JGM-3D; Mon, 13 Mar 2023 16:28:42 +0100
Received: by intern.sernet.de
        id 1pbk6L-00DtJw-QH; Mon, 13 Mar 2023 16:28:41 +0100
Date:   Mon, 13 Mar 2023 16:28:37 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Re: Fix setting EOF
Message-ID: <ZA9BJaoO4TJfjh3C@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <ZA8/B2wzQP8mEtRn@sernet.de>
 <ZA9ASbdsD0AJH6wV@sernet.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+abdKyKN3bmxre99"
Content-Disposition: inline
In-Reply-To: <ZA9ASbdsD0AJH6wV@sernet.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--+abdKyKN3bmxre99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Am Mon, Mar 13, 2023 at 04:24:57PM +0100 schrieb Volker Lendecke:
> Am Mon, Mar 13, 2023 at 04:19:35PM +0100 schrieb Volker Lendecke:
> > b6f2a0f89d7ed introduced looking for a writable path. This patch
> > should probably have gone with it.
> 
> Skip that, patch is incomplete. Will submit a fixed one v soon.

Here's the updated version.

Sorry for the noise,

Volker

--+abdKyKN3bmxre99
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-cifs-Fix-smb2_set_path_size.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 0c9b00471a53661be91d55928e943eaae0674b2c Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Mon, 13 Mar 2023 16:09:54 +0100
Subject: [PATCH] cifs: Fix smb2_set_path_size()

If cifs_get_writable_path() finds a writable file, smb2_compound_op()
must use that file's FID and not the COMPOUND_FID.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2inode.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9b956294e864..aa67271b3cc9 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -234,15 +234,31 @@ static int smb2_compound_op(const unsigned int xid, s=
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
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
--=20
2.30.2


--+abdKyKN3bmxre99--
