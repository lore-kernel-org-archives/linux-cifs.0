Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E4BC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E45416140F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEYTEn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhEYTEm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:04:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079D3C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=BuPVE7OYWRZYiPYgxtTc7UVTHSwxeK80vkbIRYTzU68=; b=VgRsYmljYvI5c+NaLthgMhdlez
        YkjQ1BUGj8nPf70pyGogQdtWVWuk76LQXh9b50+6y3DUa+IQcpGtte0aHVjScMf9EaIwvfQ2XdFtH
        e3Bepib9EKVHHUt1K3dT/zM6ZT0BTSIv0/zBTaVydcXzskd4KU3qvGDE3fGRltBcM3RfBvEHVFVaa
        A3p3dy50Xh6pa57GWodljir7eAtTlkGhcSaWBOwZNzwvmca/tCL8K/V6KX8zfWGJ3DzaxbUCD0pux
        lFgrm9g5iv/1JgP+hV7X3QbLsV7bYrhfNohBjjsFZIzagzHSC0Hpmj3UPSjGgjRKLA02poCJJC9cc
        zrfdgi+HNXIKyQto/RK0fSb/dOx9WJKUZAYbxHb7k228YamdQ3yYkQxbKoVgz29HNLMTaPkK4VAXt
        R18olQUzz/+vyEuMMcExlbLJS/45IAwwYq36jGKc2jMoiU1iQHBmybRaulcXa/52ExH42Pk9iUqkd
        ibNiRv0F1Xu5iPYoefGKnYx9;
Received: from [2a01:4f8:192:486::6:0] (port=55920 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcKb-0006Xo-Ob
        for cifs-qa@samba.org; Tue, 25 May 2021 19:03:09 +0000
Received: from [::1] (port=33806 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcKb-008jvC-60
        for cifs-qa@samba.org; Tue, 25 May 2021 19:03:09 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:03:09 +0000
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
Message-ID: <bug-14713-10630-KXEmdYSK05@https.bugzilla.samba.org/>
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

--- Comment #10 from Steve French <sfrench@samba.org> ---
Since the Solaris server logs:


May 24 23:09:46 nonsuch smbcmn: [ID 997540 kern.warning] WARNING:
../../common/fs/smbsrv/smb2_dispatch.c:smb2_dispatch_message:134:Decryption
failure (71)!

are you sure that you mounted without encryption (ie did not specify "seal=
=3D" on
mount)?

If this connection is defaulting to encryption whether or not the client
specifies it on mount, that implies that the server is configured with
encryption as required ... which is odd - because the server allowed vers=
=3D2.1
(which is not encrypted, encryption was added in the SMB3 and later version=
s of
the protocol and not supported with SMB2.1) but fails with vers=3D3.0 or 3.=
1.1
(smb3.1.1 is the typical default) which presumably means the server is
negotiating with encryption required (but only for a subset of dialects).=20
Strange server configuration.

Can you send or attach the vers=3D3.1.1 (or default with no vers=3D specifi=
ed)
wireshark trace so we can see what crypto algorithm the server is defaultin=
g to
(even if we can't see the keys - we can see how it is trying to encrypt/dec=
rypt
if smb3.1.1 is used instead of smb3.0)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
