Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4113C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjG1TSf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjG1TSe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:18:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245381BD1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=jq9YGEoqTZ8QjOTtIfusM22X8S5Xqfg73tC1JBTbTm0=; b=Lk9Bb+cXtkTlnUPqcsQePHtlmw
        69PZG+mxzm6GEKQ4oObrnrlSXeYmXl6ZjaPXUzV69P4rC8413cv3wXedFFa0JZOFjbW3dDBHm4S0R
        +b4hSkgNA0cNQiTJ+EDCyCG0uHjGTLje61PEMrdap6pn0LTli+ohi4e6dE2L5xSI4vG7tFxgSUMwv
        VcGQxTHSjz4ckLNip4GHA4/qamJYPu4szHqiu4rVfw3FkPJDobZJk1eyOK44yAiH3EgYRnbWG2+yi
        aOxsWAsNfE1iGq7GnhPcPL9DzeUJMbs2FeRZK0juPBB/vPHG2CMX91HAY7KLwCfJDw4bI2ttdrgKh
        Yb/9N0vN/R2HuObibF17QUPj2dI9KS1HKq0qXTrqaEh7Fcmj7ZU6xIhRE1LDMBBViPP4pFawTqHg7
        YLWHkg9irXY+utlouGRayK3bb5hOski06cJTRCtl5O7lNBY6c0GUrDOpVf7MgQcU/SEn0LFrAkftB
        nABBbQxFZz7CoMDnKHWEUToY;
Received: from [2a01:4f8:192:486::6:0] (port=18782 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSys-004kJQ-2O
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:18:30 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSys-000OYW-Dw
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:18:30 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 19:18:29 +0000
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
Message-ID: <bug-15428-10630-ne5THlH8es@https.bugzilla.samba.org/>
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

--- Comment #11 from Scott Harvey <sbharvey@verizon.net> ---
Comment on attachment 18011
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18011
Windows 11 and Windows 10 host failing to mount Wiresshark pcapng trascript

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Thu Jul 27 09:26:48 PM PDT 2023
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Version of software
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Server:
swupd info
Distribution:      Clear Linux OS
Installed version: 39670
Version URL:       https://cdn.download.clearlinux.org/update
Content URL:       https://cdn.download.clearlinux.org/update

samba --version
Version 4.18.1

krb5-config --all
Version:     Kerberos 5 release 1.21.1
Vendor:      Massachusetts Institute of Technology
Prefix:      /usr
Exec_prefix: /usr

uname -a
Linux clr-linux-srv 6.4.4-1337.native #1 SMP Wed Jul 19 10:29:52 PDT 2023
x86_64 GNU/Linux
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Windows 10 host KB5028816 re-installed

Edition Windows 10 Pro
Version 22H2
Installed on    8/11/?2022
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
7/28/2023 ****
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

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
