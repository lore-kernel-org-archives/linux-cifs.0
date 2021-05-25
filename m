Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F16C4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 22:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5006140E
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 22:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhEYWfH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 18:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhEYWfG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 18:35:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C25C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 15:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=dXUfcrHTIwhhy38JvICW6ibZC5+6mTvbnYoZgOeujgM=; b=XYWeX0WXhXrhfS1ufFIA8DUFtH
        ORq9zGtfyfKt3pENx8Us0k1bfWZYb1FTvwKYL1hDBfftDP/bK7AETIJYRaxo+XRlzb+3vMuWugUVC
        rwpb5XDMCK41bOd4VrE2+90Eq7cPt30eO0FPbUFEm0p/ZME6BNTvG+DuXg5pw0Q64dJuhwlDcEDQe
        Mv8YH+ZedlYVbYAPcnRtizCKQfb56q3YRpLAog+I3j6IjhmkUhqTg3j24nThdYgm1g9CQjTvffANK
        Pkyk29rANBw9oEqYKBZSdxlvA8LXF9ymsxei1mkv2eLEUd0fA7F8qmukvWWQ7mlJTj5U48x+dEMz9
        j9gNOe9Wtlu+1NDHfGBgWweh+WbEvGZtOXzs6LKUBG9uHroNkoADvuBXwMFv4R+nitAu1jvn94A4Y
        SDf4p7CeUp/6kZuRAjOecaI66o8UwC7+BK9DkPXXqGdnr49uENybbx9xglspt7t5ZXi9wbogbt6Nf
        scaFIEy4vieD+2yzPoH9NrXY;
Received: from [2a01:4f8:192:486::6:0] (port=56024 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llfcA-00081V-U9
        for cifs-qa@samba.org; Tue, 25 May 2021 22:33:30 +0000
Received: from [::1] (port=33910 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llfcA-008k9D-1w
        for cifs-qa@samba.org; Tue, 25 May 2021 22:33:30 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 22:33:29 +0000
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
Message-ID: <bug-14713-10630-LUJ4iXPkcq@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #24 from Steve French <sfrench@samba.org> ---
The reason that it is of some value is that if wireshark can decrypt it and
shows no errors (ie decrypt the first encrypted frame, the SMB3.1.1 tree
connect request) then it is even more likely a server bug ... (perhaps some
strange case where they expect a padded response that has a length divisibl=
e by
8 or some such bug)

if you have access to the source RPM then rebuilding it might only take a f=
ew
minutes (you could e.g. just remove the 2 ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS=
 in
fs/cifs/smb2transport.c

e.g. remove the ifdef and endif here (and the one before that in the same f=
ile)

#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
        cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func__);
        /*
         * The session id is opaque in terms of endianness, so we can't
         * print it as a long long. we dump it as we got it on the wire
         */
        cifs_dbg(VFS, "Session Id    %*ph\n", (int)sizeof(ses->Suid),
                        &ses->Suid);
        cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
        cifs_dbg(VFS, "Session Key   %*ph\n",
                 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
        cifs_dbg(VFS, "Signing Key   %*ph\n",
                 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
        if ((server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM) ||
                (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM)) {
                cifs_dbg(VFS, "ServerIn Key  %*ph\n",
                                SMB3_GCM256_CRYPTKEY_SIZE,
ses->smb3encryptionkey);
                cifs_dbg(VFS, "ServerOut Key %*ph\n",
                                SMB3_GCM256_CRYPTKEY_SIZE,
ses->smb3decryptionkey);
        } else {
                cifs_dbg(VFS, "ServerIn Key  %*ph\n",
                                SMB3_GCM128_CRYPTKEY_SIZE,
ses->smb3encryptionkey);
                cifs_dbg(VFS, "ServerOut Key %*ph\n",
                                SMB3_GCM128_CRYPTKEY_SIZE,
ses->smb3decryptionkey);
        }
#endif

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
