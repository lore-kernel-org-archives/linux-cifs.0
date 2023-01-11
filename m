Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCE0C46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 12:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjAKMIE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 07:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjAKMHZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 07:07:25 -0500
X-Greylist: delayed 1422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 Jan 2023 04:06:43 PST
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648371171
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 04:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=Content-Type:MIME-Version:Reply-To:Message-ID:Subject:To:
        From:Date:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+JK7A8PclGSDaImlFVKUH2wXcLUn/BgeCpjYxyTxTMU=; b=XdMSsYhFqtFFhkI9drhY+SQggd
        2AHfyf3jZU7FMOHYFPRD/2aPtaRNZ5vwACIg35Bn15/oOfe3InkA750bbWmt2x9SGSnz44xzVY4XI
        kJbIKYYjEhbtcaK9GR7m5vMyqomn75t31zd1/QnqHzTjIJO8ciHLHXf2T+u+B3A3b45Ky23IwoqZY
        EB7j+SFvoHEx6K0+IT9vLrRthCij410TpJTzr2lpOroCGa/vYGzbhCZp1MDH9Ay97pbjTo7wAp6hG
        IzCjrYkwr64rQzXa5IoPSz/zUklQYP721bew++XE43lU9oMJqMM1Em/9189t8rp2z/8vbjfzKcgzY
        yvLFcfkQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=Content-Type:MIME-Version:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+JK7A8PclGSDaImlFVKUH2wXcLUn/BgeCpjYxyTxTMU=; b=VRnVUjL0uP039WOFrHBIOaM9vM
        Iw/tLXRxg5BPOgLOk54GzRo9fk9CO3NlGkp9i7h+jxjnuP6ftn5NEV4OGEBQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1pFZVR-005N9F-V8; Wed, 11 Jan 2023 12:42:57 +0100
Received: by intern.sernet.de
        id 1pFZVR-00DDSp-M7; Wed, 11 Jan 2023 12:42:57 +0100
Date:   Wed, 11 Jan 2023 12:42:52 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Fix posix 311 symlink creation mode
Message-ID: <Y76gvH9ADxSgAxSw@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NTlW/YCD6xrb4czP"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--NTlW/YCD6xrb4czP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

Attached find a patch that fixes an uninitialized memory read when
creating symlinks using the smb311 posix extensions.

Volker

--NTlW/YCD6xrb4czP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="posix-symlink.diff"
Content-Transfer-Encoding: quoted-printable

=46rom 482fa85ef97505626b6b146155834e6bc36012fa Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Wed, 11 Jan 2023 12:37:58 +0100
Subject: [PATCH] cifs: Fix uninitialized memory read for smb311 posix symli=
nk
 create

If smb311 posix is enabled, we send the intended mode for file
creation in the posix create context. Instead of using what's there on
the stack, create the mfsymlink file with 0644.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index bd374feeccaa..a5a097a69983 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -428,6 +428,7 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tc=
on *tcon,
 	oparms.disposition =3D FILE_CREATE;
 	oparms.fid =3D &fid;
 	oparms.reconnect =3D false;
+	oparms.mode =3D 0644;
=20
 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
--=20
2.30.2


--NTlW/YCD6xrb4czP--
