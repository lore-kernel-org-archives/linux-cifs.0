Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51462CDB465
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Oct 2023 16:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjJNQRz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 14 Oct 2023 12:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjJNQRy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 14 Oct 2023 12:17:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87460AB
        for <linux-cifs@vger.kernel.org>; Sat, 14 Oct 2023 09:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=1hNVIRqsLw38wv7t9mssjGkym4kEzLZLi9ZDTwdpSGo=; b=SU8+6rdt8dNAoglwfR41MSGbCu
        jADt5RxOxiL13Xjq9zeStzG+d9f4+Q2RnaXcLxAEDHr8ALONm0/gXRtLrCoMpxau+OpLdF3hw4Oq7
        9mYiCUdHywBvjVqAkcdKRcLPDJGHScsstWVv9b2tUHNvT+LHAMaHuP7+YAqaZRTiaXFvrB67P9Y9f
        2vbeDjBAUTrPGK0aXfvZTEMQuKmUPYXsG7PML5nUWnRxmoqV2XndfO/35Ytz+K1Cxl4GLe3RHWL2c
        eHKA2mRLGFE8ODsoMsVRn1AelRtV8jspqfdJfuPnVJayedNwJrTRawNSn0aqMhV3PLyYiP5jbQwPe
        YeH+Y8cJwmuWyzk3Dh7lsZ9113epFivWFxAQsX7plVfYcGD+TfnfdEU3LONUU0CKR+YLZLNgY57xf
        bUf14U9V5BPLAz5ZeF/sX9vWp/YV5eMeHLh89qN0Gng76EFQMWAWa1gjMCjkLvJKtrd+QLKgnEVsh
        V3XDbft8CMSLD5kCu2UvddjP;
Received: from [2a01:4f8:192:486::6:0] (port=50622 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qrhKm-000chs-2f
        for cifs-qa@samba.org;
        Sat, 14 Oct 2023 16:17:49 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qrhKi-000KAQ-C5
        for cifs-qa@samba.org;
        Sat, 14 Oct 2023 16:17:44 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14476] Cannot set timestamp of Minshall-French symlinks from a
 CIFS mount
Date:   Sat, 14 Oct 2023 16:17:43 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14476-10630-hGnnyw1b0c@https.bugzilla.samba.org/>
In-Reply-To: <bug-14476-10630@https.bugzilla.samba.org/>
References: <bug-14476-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14476

--- Comment #3 from Steve French <sfrench@samba.org> ---
This change fixes it:

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 22869cda1356..ea3a7a668b45 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1191,6 +1191,7 @@ const char *cifs_get_link(struct dentry *dentry, stru=
ct
inode *inode,

 const struct inode_operations cifs_symlink_inode_ops =3D {
        .get_link =3D cifs_get_link,
+       .setattr =3D cifs_setattr,
        .permission =3D cifs_permission,
        .listxattr =3D cifs_listxattr,
 };

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
