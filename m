Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C97FC4708B
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A26E613B6
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhEZW1o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 18:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbhEZW1l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 18:27:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39347C061760
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 15:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=z2c7cUceaT+6mFAki1ZyQt6Yi9wCFQj7uXBCo7ZC4gQ=; b=zFq0YJ/yFXSAiPZVNlL4/lcLh+
        STLNqEbSE3OmSZQqJXkoBmlkbIsF+XQ9qtVYr18y84/8ReK3JjBzOB/2UjTdJrp64CAAp8cqYb8cz
        ay1WyBjRZ7gr06P0D4cI1HiA1JnKbDBP5jifR/B80d4ESiUh78ZluCFEsKr0IzN8qV3o2WhhukjOn
        wLZt9AjW2BZt3mzgn4eHqfXein1TRIqCprPn5FMkODFg1FwslM2hjIHI9LemyzklD+ivPKJHLl3Y6
        mw9H3sG1u2B5iDOntJfFiVuNK5MBst0sD8MLHoitdSvU6pcLG8GbyjhgVvQYEyRbmj/qg8+1Nu5hF
        rbywnXF3KmQLvzjjXCAs1FmbRthJNoncZVCE2jyfi4toRdSsh4XCQBMaECPjqZQJVz/PGYE7xfcwg
        ckNqJ6A0EV3IyFLxw96Yd48DtfU/ePMbwDdfft/uVE+c6d82ffANyhLjOHJ8Q5Qp7WQqrayPKGKUl
        b7qT+M/1JG67mVr53oWA5SVQ;
Received: from [2a01:4f8:192:486::6:0] (port=56402 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lm1yY-0004Tj-PF
        for cifs-qa@samba.org; Wed, 26 May 2021 22:26:06 +0000
Received: from [::1] (port=34286 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lm1yY-008pJN-E8
        for cifs-qa@samba.org; Wed, 26 May 2021 22:26:06 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 22:26:06 +0000
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
Message-ID: <bug-14713-10630-DStWlY560D@https.bugzilla.samba.org/>
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

--- Comment #33 from Richard Flint <richard.flint@gmail.com> ---
with vers=3D3.0 (and without seal) specified on the client and
server_encrypt_data=3Dfalse specified on the server, the following new fun
happens:

mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log
messages (dmesg)

and dmesg says:=20

[261829.875860] CIFS: Attempting to mount //nonsuch/myshare
[261829.891575] CIFS: VFS: \\nonsuch\IPC$ validate protocol negotiate faile=
d:
-13
[261829.893269] CIFS: VFS: \\nonsuch failed to connect to IPC (rc=3D-5)
[261829.895940] CIFS: VFS: \\nonsuch\myshare validate protocol negotiate
failed: -13
[261829.897752] CIFS: VFS: session 00000000bfe08581 has no tcon available f=
or a
dfs referral request
[261829.900102] CIFS: VFS: cifs_mount failed w/return code =3D -2

I also notice a new message on the server server. Note that cmd=3D0x3 is now
cmd=3D0xb - whatever that signifies.

May 26 23:11:53 nonsuch smbsrv: [ID 211007 kern.warning] WARNING: bad
signature, cmd=3D0xb

A wireshark trace for the above has been emailed to you "3.0_mount.pcap"

As usual, for comparison smbclient works flawless (hopefully -m SMB3 was the
right way to force SMB 3.0 dialect...)
smbclient //nonsuch/myshare -m SMB3 --user=3Dmyuser

A wireshark trace for the above smbclient interaction has been emailed to y=
ou:
"3.0_smbclient.pcap"

Throughout all this dialogue with you, signing on the server has been
'enabled', but not 'required'.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
