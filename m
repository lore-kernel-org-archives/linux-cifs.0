Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A14C4363A
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 17:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 890E6206C3
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 17:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgJERbg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJERbf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Oct 2020 13:31:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74809C0613CE
        for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2020 10:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=7MCCZrRMkUkAlJQOLbZQiyjWk1wxqaVIudlM2jd0jjk=; b=vKUE8o1xnyeXVnxBSWYz4tUWQL
        wfagFFi+Oge/a/RPwFj7ZgcUW8HRnCf3OjnS6h72ZfQKyM2v64SLYZWKWbcPRQhf0+Nf3Xqr4DdNr
        tn0QI+NkTSl2RHqTzdW89927lJarbYLRH6XGUDzNLqIioj0YLq9LZi/OLdJtY8gIfmaQKgFZa6pbw
        Lc9nBoFgTNTSrC2gwTNUQegF6hEKxFMPGb4LOoSBbxqnZoSVVqtidVN9YY3WcWVHZIgtJK3M9rZ8r
        CcEse09y4+8mpHXPWB5SWHjG/qlegEC69FPG2VhkGFhsh+R+TDxYIKsW7m4pjr/l0AqnMHk+VqdJN
        yeGouIZDsdfT9Qt9wcS1axv4OHZETGWg9cu+wtXfIzzcDdFZXFfyg0qC3xuQcdFMn/qMq0Fbfj/dg
        Ue4SsvKbMMQtEGEjEDxGlEX8pgf1sMpzxB6ClKCQBdDcQ0RE2OzPQu5rGqE32PTK+DJxQ46LoO3Q5
        1b6gAKdx+MKSAFVdrDerFjMC;
Received: from [2a01:4f8:192:486::6:0] (port=22944 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kPUKj-00069z-4j
        for cifs-qa@samba.org; Mon, 05 Oct 2020 17:31:33 +0000
Received: from [::1] (port=35624 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kPUKi-0048E9-5v
        for cifs-qa@samba.org; Mon, 05 Oct 2020 17:31:32 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14521] New: CIFS mount shows only "vers=default" instead of
 specific SMB version
Date:   Mon, 05 Oct 2020 17:31:31 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kolAflash@kolahilft.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14521-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14521

            Bug ID: 14521
           Summary: CIFS mount shows only "vers=3Ddefault" instead of
                    specific SMB version
           Product: CifsVFS
           Version: 4.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: kolAflash@kolahilft.de
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

/proc/mounts and the mount command don't show the auto negotiated version a=
fter
mounting with vers=3Ddefault (or without specifying vers=3D).
Instead /proc/mounts just says vers=3Ddefault.
Client OS: openSUSE-LEAP-15.2 with Linux-5.3

This non-public bug seems to be similar.
(I don't habe a RedHat license, so I can't see the details)
https://access.redhat.com/solutions/4592681

I was only able to reproduce with Windows Server 2012.
A Windows Server 2008 and Samba-4.6 (openSUSE-LEAP-42.3) work fine.
(e.g. /proc/mounts shows vers=3D3.11)


Workaround with some help from:
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
echo 7 > /proc/fs/cifs/cifsFYI
mount -t cifs ...
dmesg | grep -E 'cifs.*[123]\.[0-9]'
# -> negotiated smb3.02 dialect

So for me it's actually 3.02 what's been negotiated with Windows Server 201=
2.


P.S.
"man mount.cifs" may seem a little ambiguous about the vers=3Ddefault behav=
ior.
Quote:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
SMB protocol version. Allowed values are:
[...]
  - default - Tries to negotiate the highest SMB2+ version supported by both
the client and server.
[...]
  The default since v4.13.5 is for the client and server to negotiate
  the highest possible version greater than or equal to ``2.1``. In
  kernels prior to v4.13, the default was ``1.0``. For kernels
  between v4.13 and v4.13.5 the default is ``3.0``.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The first one sound more like 2.0 <=3D vers < 3.0.
While the second sounds more like 2.1 <=3D version (without upper limit).
To me it looks like the second (2.1 <=3D version) is what's actually implem=
ented
(at least with Linux-5.3 on openSUSE-LEAP-15.2).

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
