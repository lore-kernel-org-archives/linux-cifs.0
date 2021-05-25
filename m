Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0919CC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D532561249
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEYSxe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 14:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhEYSxd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 14:53:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A54C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 11:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=W+MP+n3QvkMTYkuEpwDm4DVwPQ2l6jtVpZ0XyOsmoV4=; b=MthiNQGasU6U3kQUjkjiaSo/Mr
        uLxtKvRO9dmDeYzmTHpIFUqc9Wx+GkCIZJYEIg47clVDCAosiBaqtSryz8NNXeeXhGvIE34ZH/Vmf
        P2ocNA6cHZn1/Rh8nob8egioz7IIKagLVRhqCfBSgoeFaBGoIRs67PsTvHxlndO9bsOby8cvt27DI
        ARF6oc2PQzvkaEeT/bCTa6UozusjdUt8New30XWJJOkyIY6rkRnHCjby2Nnw347pdYqjU1eZ1qLGz
        TBM1lS+FT0Qb6gZAaU3P9XuJ2QMv2ATwDcSVff+KtdiQ7gjphVuLTUYZwyrc9qqA84AIAt2lL5KeO
        8FV8UI9yPbHQX8qT/0ozbYIeeP7wyj+IBfQKH20Oqj3ErAop8O/xElBN/0JYgwRiYaJw/p8rqGnWr
        L8mz96gaKw0F8iS47w7uFKMSNKzU554qYvPlgvS5dY1/mrih/bwTn+pBp4FQ+x9pJwBXlJmNgJtj1
        ERVnM8WY+T0yEVTY51G9IVPb;
Received: from [2a01:4f8:192:486::6:0] (port=55916 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llc9o-0006TO-JF
        for cifs-qa@samba.org; Tue, 25 May 2021 18:52:00 +0000
Received: from [::1] (port=33800 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llc9o-008juE-6s
        for cifs-qa@samba.org; Tue, 25 May 2021 18:52:00 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 18:51:59 +0000
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
Message-ID: <bug-14713-10630-kvGkNHSHah@https.bugzilla.samba.org/>
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

--- Comment #9 from Richard Flint <richard.flint@gmail.com> ---
1) As long as you are running a reasonably recent kernel or distro update (=
5.0
or later kernel should be fine, and current RHEL/CentOS/Oracle client ie
RHEL/CentOS/Oracle 8.4 or 8.3 should be fine as well since Redhat backports
many fixes to their older kernel) can you try not specifying "vers=3D" at a=
ll and
see what it negotiates with the server?  (should be 3.1.1 - you can see in
/proc/fs/cifs/DebugData)

If I fail to specify the vers=3D option. Mounting fails completely. Dmesg s=
ays
our usual:

[162979.482987] CIFS: VFS: \\nonsuch failed to connect to IPC (rc=3D-11)
[162979.484449] CIFS: VFS: session 0000000083b7840c has no tcon available f=
or a
dfs referral request
[162979.485899] CIFS: VFS: cifs_mount failed w/return code =3D -2

and the Solaris server says:

May 24 23:09:46 nonsuch smbcmn: [ID 997540 kern.warning] WARNING:
../../common/fs/smbsrv/smb2_dispatch.c:smb2_dispatch_message:134:Decryption
failure (71)!
May 25 19:44:21 nonsuch smbcmn: [ID 997540 kern.warning] WARNING:
../../common/fs/smbsrv/smb2_dispatch.c:smb2_dispatch_message:134:Decryption
failure (72)!

I have also seen the above Solaris server side messages intermittently and
think they may be related to the issue I am experiencing. But if SMBv3 is
broken on Solaris, I do not understand why it works fine with MacOS.

2) Does mounting with "vers=3D2.1" work?

Yes, it works fine. In fact, it is required to make anything work as omitti=
ng
it results in the above behaviour.


Regarding your other comments about traces and encryption keys, I will need=
 to
time to get these, but will indeed do so.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
