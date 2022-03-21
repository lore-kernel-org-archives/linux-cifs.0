Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6068C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 16:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244965AbiCUQiR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241534AbiCUQiR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 12:38:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1216BDDB
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 09:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=t1/H8nwpx5umauyPZTQKzVmc2OxG4IjnPmitmSrCMto=; b=L9QgO23b24j3TA8PA9leSFzXPK
        b90AvhymXhwqyPHc8RQcUh1QUekgAsIPXz91OPSVhFY4Kvj0I+ptdnpW5d47ZjUNIqWNXdE4T/2Iv
        5ijKuivq4hk/q7ndfer45agvInWEkAY1zovUc6S76utONA0qfC5WD0aPvxeTqQ4ifs3f7rk5kdPJI
        /KkvXEqGKZn8dM47gLqzjYXkQ/yKyWpWkUpMuAwGDZ0QRQT49FHvU6e4GyjOc2OiRc0+XAgSZakQ2
        NNCGGume9Kwog1doZ3PRN80ulEfaxz0AvAYgG9LG4dbm6hSKG0+6UNat0AzB9gJ76+RK7hqTr7XSF
        0tqKPUdj+pwJQM0o1t/NMc1FYrRjZ6j4cLbjoDGhUsQLmTM9hYvQ9MiINRnDCtSQNeadMhaK+Mbxm
        ITHeLhNCtLRg9xHcaUlBpsKrIAE9GyYM/K1lToO7UXP1q0W+RWOenxUionqZNHENN4cR/EuXpWYIp
        O5RT2l5ReTPRzwNVQchOoQJj;
Received: from [2a01:4f8:192:486::6:0] (port=56598 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWL1V-002f9W-I1
        for cifs-qa@samba.org; Mon, 21 Mar 2022 16:36:49 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWL1U-001e59-Rm
        for cifs-qa@samba.org; Mon, 21 Mar 2022 16:36:48 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15026] Partial arbitrary file read via mount.cifs
Date:   Mon, 21 Mar 2022 16:36:48 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ddiss@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15026-10630-Rz7JhL3pu6@https.bugzilla.samba.org/>
In-Reply-To: <bug-15026-10630@https.bugzilla.samba.org/>
References: <bug-15026-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15026

--- Comment #3 from David Disseldorp <ddiss@samba.org> ---
(In reply to Jeffrey Bencteux from comment #2)
> (In reply to David Disseldorp from comment #1)
>=20
> > Please correct me if I'm wrong, but I don't expect that this would be e=
xploitable
> > on regular systems unless mount.cifs is installed with setuid-root, or =
an attacker
> > somehow has access to the "credentails" path fed into a mount.cifs invo=
cation.
>=20
> That is partially correct, note that on a vanilla Debian 10, mount.cifs is
> setuid-root by default:
>=20
> $ ls -l /usr/sbin/mount.cifs=20
> -rwsr-xr-x 1 root root 35600 Jun 17  2018 /usr/sbin/mount.cifs

Ouch. I assume Ubuntu inherits this default setting.

> And likely it is the case on other distributions as otherwise the followi=
ng
> message is returned:
>=20
> $ ./mount.cifs //127.0.0.1/share /mnt/share -v -o credentials=3D/etc/sudo=
ers
> This program is not installed setuid root -  "user" CIFS mounts not
> supported.
>=20
> It however seems needed to either:
>=20
> 1) have privileged user rights to trigger the bug, such as the below line=
 in
> /etc/sudoers:
>=20
> testuser ALL=3DNOPASSWD: /usr/sbin/mount.cifs
>=20
> Which is less likely but possible.
>=20
> 2) Have the scenario you depict where a user can tamper a mount with a ro=
gue
> "credentials" option value.
>=20
> This greatly reduce the risk IMO.
>=20
> I think the explanation is in these lines of mount.cifs.c:
>=20
>  115  * When an unprivileged user runs a setuid mount.cifs, we set certain
> mount
>  116  * flags by default. These defaults can be changed here.
>  117  */
>  118 #define CIFS_SETUID_FLAGS (MS_NOSUID|MS_NODEV)
>=20
> I expect some people to use rules such as the above sudo one to circumvent
> the problem.

I don't completely follow - so for the setuid-root case, can root-readable
files be dumped by regular users (ignoring apparmor/selinux) using
credentials=3D<root-only-path>, or do the dropped privileges mean that a
different approach (sudo) is needed?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
