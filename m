Return-Path: <SRS0=IOoX=BH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DFBC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 19:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4818C2075A
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 19:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KiEwpOEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgG1Tuv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jul 2020 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgG1Tuv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Jul 2020 15:50:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A64C061794
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2020 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=m/8hCwZ4+fQ3r0orj0N3ivCTVRyPlYETg4dq5vpxuCY=; b=KiEwpOEve5B5p3P5tyPoZNSsjJ
        hPdxmpopiQ1dGZlPgt8LUNVme5t/NkTVbegg9JsZ0kTTMrP9NCh+utH4DXDTByp9azfmcxcImp5g1
        S7hT59pvZK7k2xrhDUy2HhJwYGF9eGHR9o1dGZvDchGwv0xHHYlhAf8aU7FankdhBGhBvtNLWRYGM
        6XjKeDZQ5N0Kpjtflh5AxBs/PmSUWgDcvVitFpeE/ay+hlN3MSU+s7pPuy03wDvO/5CB8ctGt6VvI
        9pP28DOCG0ahednPhB7i3fi5Jp6HmUN+dE0WOJ0DlsjN8BwlkZeU/yqF992rOgPLR2PMV7s1AUcdO
        jlVHWFxL0pPjcBXDDKtdBQR0fOJ7pDU9pTNt8Kt55HUxIYWvdIdY3s/MjXauJKXhMMiT0MIUhmOUG
        UU28RSgPKOn/OjSERVDhQ2y0qsXXngoZgk5PzsZqQPzPi5fPa/A/33uQWCfgJu6XsUE1yOFSYrHGg
        zDDzfDEYrHEYz2nA/Sxd/tcA;
Received: from [2a01:4f8:192:486::6:0] (port=46568 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k0Vcf-00012n-2L
        for cifs-qa@samba.org; Tue, 28 Jul 2020 19:50:49 +0000
Received: from [::1] (port=32524 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k0Vce-007fSg-RW
        for cifs-qa@samba.org; Tue, 28 Jul 2020 19:50:48 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13470] DFS mounted shares do not allow to go subdirectories
Date:   Tue, 28 Jul 2020 19:50:47 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sergey_ilinykh@epam.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13470-10630-ERNpWzefJD@https.bugzilla.samba.org/>
In-Reply-To: <bug-13470-10630@https.bugzilla.samba.org/>
References: <bug-13470-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13470

--- Comment #4 from Sergey <sergey_ilinykh@epam.com> ---
Thank you very much Aur=C3=A9lien.

I already played with dnsmasq this way for different purposes. I hoped ther=
e is
an easier way. But that's fine.

But mounting dfs root doesn't work for me.
Basically I take the mount line mentioned in the first post and remove MySh=
are.
Then I get something like following in dmesg

[95886.129233] CIFS: Attempting to mount //epam.com/
[95886.171103] CIFS VFS:  BAD_NETWORK_NAME: \\SUBDOMAINX.epam.com\epam.com
[95886.183185] CIFS VFS:  BAD_NETWORK_NAME: \\SUBDOMAINX.epam.com\epam.com
[95886.183836] CIFS VFS: cifs_mount failed w/return code =3D -112

Where SUBDOMAINX.epam.com is listable with smbclient -L

If I remove trailing / then I get next in dmesg

[96140.695029] CIFS VFS: Malformed UNC in devname

kernel 5.7.9

Ok. I think I need to report this under a different number.
Thanks again.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
