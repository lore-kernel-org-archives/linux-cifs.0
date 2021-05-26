Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7BAC47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 19:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA36613CA
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 19:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhEZTBg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 15:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbhEZTBc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 15:01:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA7EC06175F
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 11:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=35RvJkl5xngRjdqy9CUn8GXeJkD9RaGXHscumDCEmus=; b=r6TjzZysy4THkl/AYqN4Fw265K
        LlURbCd8ejqMs3IX6euEUIRFKQc3M2snKErhdJX4ctDb8qHzw8dSExVHl2MDTP8mciO1CMSmK6SaT
        i4nXyKkjL0qgtGXTHZXsiwizuTlpmCxiDfF2keV7R4CC8HiAwQacKUWGLH6EtVxpzds6FD1ARuWsF
        cSUlsXys9N/yknbi478RhyDc+MLqcoqWMLfcJt8nZ50nzRwjCU+zoRvh4k2nnaCrgd2ccQeCGGpXy
        l4/ZwuDZbMpzAvb5i0ctuqOjFF4HNeAprQsAkyIOCvxKRw2Q5jCgs4cTJcBk4hn2gcydORL6TN4YT
        JOVeOg/eg81rC6LjcU3+VhRSXBrI+xyAU3E3ZGaPkklxj0ABVBBNxIJeYL9Re1a8Tb7xJwzOEHlsS
        qXCXuX3za/Z6iAnBeMibY0w5bdxg3Yb7AN7Kd7ZBuswWVmQC5SJnpRsGSfrtc/ns9cKhz8EtRaU/k
        sfqGo1f9eDhmWAbt0ykwQ1Mu;
Received: from [2a01:4f8:192:486::6:0] (port=56346 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llyl2-0002s8-Sl
        for cifs-qa@samba.org; Wed, 26 May 2021 18:59:56 +0000
Received: from [::1] (port=34230 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llyl2-008pAC-HB
        for cifs-qa@samba.org; Wed, 26 May 2021 18:59:56 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 18:59:56 +0000
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
Message-ID: <bug-14713-10630-PO8Nql0Izy@https.bugzilla.samba.org/>
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

--- Comment #29 from Richard Flint <richard.flint@gmail.com> ---
Unfortunately, as I mentioned by email. The connection does indeed also fail
with server_encrypt_data=3Dfalse.

After setting server_encrypt_data=3Dfalse I try to mount with vers=3D3.1.1 =
and
without the seal option (since encryption is off on the server). This resul=
ts
in the following mysterious error:

mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log
messages (dmesg)

[249955.014343] CIFS: Attempting to mount //nonsuch/myshare
[249955.020762] CIFS: VFS: \\nonsuch failed to connect to IPC (rc=3D-13)
[249955.023383] CIFS: VFS: cifs_mount failed w/return code =3D -13

see wireshark trace in your email "3.1.1_encryptionoff.pcap".

Trying with smbclient on the same share with the same user and same password
with server_encrypt_data=3Dfalse on the server and no --encrypt option resu=
lts in
success:

smbclient //nonsuch/myshare --debuglevel=3D10 --user=3Dmyuser

see wireshark trace in your email "3.1.1_smbclient.pcap".

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
