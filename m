Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82B2C41513
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjG1TQF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjG1TQE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:16:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EA13588
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=1D5Hf7A1dMkdxk+yN32U75qs3BFb1Km10Ei1e+Qz2z0=; b=FbGqlNlMGy54kj/YoEkktdIutG
        YW57AvJfl2kiWeFzf5o6O8oBHO7N1AcJC6Z6xU4MH16CfL+qlgTM2ZjEMl5UFjav3999QQYDxziZk
        aa29ibHfgjv5QVBO9d2dU/iircFrhfNX/VdoJfmJU237ZnX/EN0eIfpPX7Mx4RxVTOhZqtwxovezO
        UTGhTiQ3ehhEy914/gXNZonb/gcOTKPHvIT1XNmj98F2OEgaalWELBKrybNz7Ix9UzaAw6rQCPP+q
        0nz8/yXcDYZM7NInIS/n8GOXs8h2SGvurye/K+1eletcBImZcLWoTW2iIvhcOiD79j/mRZkromH9a
        wobQCXUo0vVOlAGO0+NFk34hDlBLEBs0MabaJI9wCYEwMGndZlQqTQpnE8zAxJoqUX5X9O3JatkZp
        FVgQt51yBVecMBhULbaiCfwtLR3IgBmm8KFzbo7OGmVy6UWBkQUCdMGJOeT4Rd5B0WmmAd7lTwv2A
        dsSGzEGP68p39bSw28OGN1nh;
Received: from [2a01:4f8:192:486::6:0] (port=35130 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qPSwT-004kGk-03
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:16:01 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qPSwS-000OY1-Du
        for cifs-qa@samba.org;
        Fri, 28 Jul 2023 19:16:00 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Fri, 28 Jul 2023 19:16:00 +0000
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
Message-ID: <bug-15428-10630-jF5dOYcotY@https.bugzilla.samba.org/>
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

--- Comment #9 from Scott Harvey <sbharvey@verizon.net> ---
Comment on attachment 18009
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18009
Successful mount.smb3 prior to windows update(s)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Thu Jul 27 09:26:48 PM PDT 2023
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

Windows 10 host KB5028816 re-installed=20

Edition Windows 10 Pro
Version 22H2
Installed on    8/11/?2022
OS build        19045.3208
Experience      Windows Feature Experience Pack 1000.19041.1000.0

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Windoww 11 host All latest update installed

Edition Windows 11 Pro
Version 22H2
Installed on    7/26/2023
OS build        22621.2070
Experience      Windows Feature Experience Pack 1000.22659.1000.0

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
