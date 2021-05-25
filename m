Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE6EC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB2E613D2
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEYTVF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEYTVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:21:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B974C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=5lFUicFBA/onvw62yY3OIb025k4ulCiH7O9cZRGgiEU=; b=wkrnDVWmSv4k+1o9vInSeSXCDV
        bGXtV3XbXVSHOPnhXnYKEw13C7naVYVemB/TNemPsQQ/g1XukT+OwjuhemmnNFNGl8Gx9cf7sCG1f
        /T/5UbqV1VKcIY5Bru/AFSBEikDuI8sczuGOaRMFkawjx5EbfsOG9wRHZx6IMIVULCSENkiDRMwLL
        wrC1rERPDKe3jdiU2X12obi+gQyYI5yeRvhO8ZNWPZjlR4KthFfXdF2fZfcAwctZHch0jrmz7hqcp
        IWfoyBdCYYWqkm1HKs/gexgnXuqJyeWJ88ukhxSnXRWfO5vqW72Mb20koinMa4i7Go23akNsozdl+
        D0xE4Hn2/Uk1OQu7unAbPodTCDN1I60pfkHV/476LPICzFjqUIEyPWubv8kHiJftIJTEdogHkvK42
        dIdfCH5B0d9u6bjMcK3oIDrr54T8pfCS6v81kxNy1OyWZ+QRzb8SqYO/TLNHVwCXaO2BPJ/RqgklA
        vCnHmDaQ+mbIsKZ2nEVnc7iT;
Received: from [2a01:4f8:192:486::6:0] (port=55948 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcaR-0006fk-JJ
        for cifs-qa@samba.org; Tue, 25 May 2021 19:19:31 +0000
Received: from [::1] (port=33832 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcaR-008jwC-63
        for cifs-qa@samba.org; Tue, 25 May 2021 19:19:31 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:19:30 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-qKZKiL0FcN@https.bugzilla.samba.org/>
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

--- Comment #14 from Richard Flint <richard.flint@gmail.com> ---
Unfortunately, I spent quite a bit of time trying various combination of
options and I have to say I have never managed to get SMBv3 to work between
Linux and Solaris with or without encryption. E.g. setting vers=3D3.1.1 wit=
hout
seal and with server_encrypt_data=3Dfalse on Solaris does not result in
successful mounting:

[164849.013736] CIFS: VFS: \\seraphix-3.achelon.net failed to connect to IPC
(rc=3D-13)
[164849.015760] CIFS: VFS: cifs_mount failed w/return code =3D -13


But let's try and debug one test case at a time so things don't get confusi=
ng.
I have a wireshark dump with vers=3D3.1.1 and seal options. I will email to=
 your
gmail.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
