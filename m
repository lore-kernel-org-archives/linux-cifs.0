Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62ADAC0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjG1TRl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjG1TRj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:17:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231C219BA
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=HFPsDuI8b5tasLVaf8s7HpD2g4TT14oryS3RSut/U8A=; b=RwpjPzBOXCzk8LAJz/ZsrHzRQ9
        F8LKiaIUH/IH1CW2pgIL+dws4F2LtcLCLUk4iIJ2+xbNSBD+skN08rmDIG/7nWV8Tpt0JW2gvjTKH
        KmeF2FGeeYVxO46jLv6zthD3bJ37eVuyxP8bZdWlLUn0D3635/AbomT8gHCUy6WuKhbZgXrSg12Y7
        QHX9CswbywVYoEC4NgHqVe623c3cG9b+0UPIY+7yAnRGY4bJjWjqL/bxaf1tbtpbBrtigUG9cxXTW
        wv/amTZM2Qjht6n3mbfP3e5pGm22SDekGMtH3I0oOKo2L5dtYWeY1M6ypwSKQiKQ4jvuANJIJ3/TM
        /XAgcx73oc6x6wZCh5uBqUNqtueKxUHnHBnBxT9Zz+mg3r1V1iwbyreLPWqpPmeoZnxnGRR1SgdCO
        yJaHVC/xdwyFMLPWrvEtzozZ727ibMrK0KSgKa1kL49E2MyfzmJxxuqNTjF/1++e8az6XJPuBQXoV
        yy5yCm6/mq5YxKbNzzzaQTiz;
Received: from [2a01:4f8:192:486::6:0] (port=59860 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSxz-004kI4-31
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:17:36 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSxz-000OYL-Ns
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:17:35 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 19:17:35 +0000
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
Message-ID: <bug-15428-10630-jQxBfbgaGu@https.bugzilla.samba.org/>
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

--- Comment #10 from Scott Harvey <sbharvey@verizon.net> ---
Comment on attachment 18010
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18010
Window 10 not updated, Windows 11 update, Wireshark pcapng trascript

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Thu Jul 27 04:53:48 PM PDT 2023
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Version of software=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Server:=20
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

Windows 10 host KB5028816 "hidden"

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
