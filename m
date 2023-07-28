Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7037AC001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjG1TWI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjG1TWH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:22:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD4419BA
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=DiLgvdALtiwMLdT8YhBe/ESr6Iej676exO4+2tJbqBs=; b=g/pjmY6w3EeNK16osW5zTpJN6i
        n0kJtmq2je1Cdl3JUVddi+b9nXPPRWYc5C/tgkqB98feasR/HDP4CYHWiBU7mkW5iGo9H7ul2yAnX
        vAsnp/meqNbOGRWCyVCrhqzZ9YinP7Fy2UvCspTc67TgxKSZSxqdhCXcGJTz/HjFAZclmu6GCdWkv
        WHf34Wl/1lrSojLHKevN+BL05wDzq4b40WWj4hmZM7P9KGwYjhQ2Q/RPjoq5hnJsVxk1aqgWC4hhl
        iqb3D13tqqOJM/rAoklIjmNGKQi5tmDchhYY5Tii12QMqgI1Fcgl/hJWQ/TF07tGVgNipFSKF4gO8
        9L8FrSMQYZuQPjfM99VlDwHk3SO5YdxxY0Guze4eXhiwLEtegQ8qlfsTFnxQZ1pVds0eDg2oA2XWv
        hO+8ZnGr5+JFKADQvmqDFs8U1B53IUzWLDa3NmJAYEREKAOer1r+2hCWESUC0dz30bUcBFSXRFQJt
        h0RFCz0poNBU6w6zMvLCv65I;
Received: from [2a01:4f8:192:486::6:0] (port=41532 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPT2K-004kM1-1I
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:22:04 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPT2K-000OYw-0g
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:22:04 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 19:21:59 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sbharvey@verizon.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15428-10630-njZynMQfgu@https.bugzilla.samba.org/>
In-Reply-To: <bug-15428-10630@https.bugzilla.samba.org/>
References: <bug-15428-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15428

--- Comment #12 from Scott Harvey <sbharvey@verizon.net> ---
Comment on attachment 18012
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18012
pcapng trascript shows successful Linux mount of Windows 10/11 shares

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Fri Jul 28 08:53:53 AM PDT 2023
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Version of software=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Server:
swupd info
Distribution:      Clear Linux OS
Installed version: 39690
Version URL:       https://cdn.download.clearlinux.org/update
Content URL:       https://cdn.download.clearlinux.org/update

samba --version
Version 4.18.5

krb5-config --all
Version:     Kerberos 5 release 1.21.1
Vendor:      Massachusetts Institute of Technology
Prefix:      /usr
Exec_prefix: /usr

uname -a
Linux clr-linux-srv 6.4.5-1338.native #1 SMP Sun Jul 23 06:26:44 PDT 2023
x86_64 GNU/Linux

Other server setup information
When looking a Wireshark pcapng files the ip addresses are

win10-testhost.tst-domain.net 10.0.0.49
win10-testhost.tst-domain.net 10.0.0.29

clr-linux-srv.tst-domain.net  10.0.0.1

Samba is setup as server role =3D active directory domain controller
Internal DNS is enabled
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Windows 10 host KB5028816 re-installed=20

Edition Windows 10 Pro
Version 22H2
Installed on    8/11/2022
OS build        19045.3208
Experience      Windows Feature Experience Pack 1000.19041.1000.0

wmic qfe list brief /format:table
Description      FixComments  HotFixID   InstallDate  InstalledBy=20=20=20=
=20=20=20=20=20=20
InstalledOn  Name  ServicePackInEffect  Status
Update                        KB5028849               NT AUTHORITY\SYSTEM=20
7/18/2023
Update                        KB5028853               NT AUTHORITY\SYSTEM=20
7/18/2023
Update                        KB5003791=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
10/6/2021
Update                        KB5011048               NT AUTHORITY\SYSTEM=20
7/18/2023
Security Update               KB5012170               NT AUTHORITY\SYSTEM=20
8/12/2022
Update                        KB5015684               NT AUTHORITY\SYSTEM=20
7/17/2023
Security Update               KB5028166               NT AUTHORITY\SYSTEM=20
7/28/2023
Update                        KB5015895               NT AUTHORITY\SYSTEM=20
8/11/2022
Update                        KB5016705               NT AUTHORITY\SYSTEM=20
9/13/2022
Update                        KB5026879               NT AUTHORITY\SYSTEM=20
7/17/2023
Update                        KB5028318               NT AUTHORITY\SYSTEM=20
7/17/2023
Security Update               KB5005699=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
10/6/2021

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Windoww 11 host All latest update installed

Edition Windows 11 Pro
Version 22H2
Installed on    7/26/2023
OS build        22621.2070
Experience      Windows Feature Experience Pack 1000.22659.1000.0

wmic qfe list brief /format:table
Description  FixComments  HotFixID   InstallDate  InstalledBy=20=20=20=20=
=20=20=20=20=20
InstalledOn  Name  ServicePackInEffect  Status
Update                    KB5028851               NT AUTHORITY\SYSTEM=20
7/27/2023
Update                    KB5029517               NT AUTHORITY\SYSTEM=20
7/26/2023
Update                    KB5028254               NT AUTHORITY\SYSTEM=20
7/27/2023
Update                    KB5025351                                    5/5/=
2023
Update                    KB5028756               NT AUTHORITY\SYSTEM=20
7/27/2023

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Other window operational notes with samba when not running=20
samba version 4.18.5 or above:

In addition to Remote Desktop (RDP) authentication between=20
Windows Hosts failing and Linux servers not being able to=20
mount Windows shares, running utilities compmgmt.msc will=20
indicate problems.  When compmgmt.msc is run=20
(As Domain Administrator on member Windows client) will not=20
show a SID number instead of the qualified name such as=20
TST-DOMAIN\Domain User for example.  If you are seeing SID numbers,
that means there is some kind of Domain TRUST issue at play,=20
Remote Desktop between Windows host will start to fail, and=20
mounting of Windows shares from Linux will not work and=20
possibly other issues.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
