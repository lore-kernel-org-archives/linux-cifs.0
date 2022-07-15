Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3F9C43334
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jul 2022 21:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiGOVXn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOVXl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Jul 2022 17:23:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E601D5F
        for <linux-cifs@vger.kernel.org>; Fri, 15 Jul 2022 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=bp29qAa2qOJAUxeu4WGuK0Br0K+CnhGvQtYwx2rhC1g=; b=XlcYf2R5mZIWHyHBxLdZXs34Ex
        MzOVHW0qqREym+aQEnfgVU+UOU5CbiQs47Bvgmu5Jrjt+eb8LYMXbWID2vRb86b/s/IfIzZ0BfdhY
        FTBJjThE0uLwfjc+pDn+uRkChWr8vSJOs2oPWonkhvzF1+69USoHQBZHVN/IVgmzicnFomG5ozolB
        VlfaksRdVBZ35fiANt1zMP2evwpqOw8CbvRG9r8b9x6bvQ7QB/q9uJWnu22yigFnzxAaen2cihb1r
        pn8Bwu46EtDbk1+PIeejaLETC+ZWf5ZKGLXy7h8M06xRGu1Y2vpOMQD0sSsqidamMbH/yrSFQhtdp
        UCTs4pL7tcIJ/FGrJE3b7ejURtcOsnPNCGnzPRQCL6ALkS1imWuGYNHmAPJnS58rLVRn+S5k22zbs
        3cddadRTfbbceGop7iE1nODgJbnjUB3RI+VUjbn04Ht4iZWE2AhwRfpAufK1ezEhJ4L+hxD7ySqAu
        Hl9eJeuycSx6aJb0jIydnwR6;
Received: from [2a01:4f8:192:486::6:0] (port=53618 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oCSmd-004vgk-W9
        for cifs-qa@samba.org; Fri, 15 Jul 2022 21:23:36 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oCSmd-000tg8-DB
        for cifs-qa@samba.org; Fri, 15 Jul 2022 21:23:35 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15123] getxattr() on cifs sometimes hangs since kernel 5.14
Date:   Fri, 15 Jul 2022 21:23:35 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: forestix@sonic.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15123-10630-zpEHmlqsiC@https.bugzilla.samba.org/>
In-Reply-To: <bug-15123-10630@https.bugzilla.samba.org/>
References: <bug-15123-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15123

--- Comment #1 from Forest <forestix@sonic.net> ---
I can reliably reproduce it booting from this live USB image:
kubuntu-22.04-desktop-amd64.iso

My setup steps when using that live USB environment:

sudo mount.cifs //myserver/dir ~/mnt/dir -o username=3Dmyuser,uid=3D999,gid=
=3D999
touch ~/mnt/dir/test{1..5}

Tests and results:
(My reproducer program is called xattrtest in these command lines.)

# 1 thread is fast
# (note the system call duration reported by strace in <> brackets)
$ time ./xattrtest ~/mnt/dir/test{1..5}
real    0m0.079s
user    0m0.003s
sys     0m0.000s
$ strace -Te getxattr ./xattrtest ~/mnt/dir/test1
getxattr("/home/myuser/mnt/dir/test1", "user.baloo.rating", NULL, 0) =3D -1
ENODATA (No data available) <0.008482>

# 2+ threads are slow
$ time ./xattrtest -t 2 ~/mnt/dir/test{1..5}
real    0m5.118s
user    0m0.005s
sys     0m0.000s
$ strace -Te getxattr ./xattrtest -t 2 ~/mnt/dir/test1
getxattr("/home/myuser/mnt/dir/test1", "user.baloo.rating", NULL, 0) =3D -1
ENODATA (No data available) <1.018507>

# 2+ threads are fast if I remount with the nouser_xattr option
$ time ./xattrtest -t 2 ~/mnt/dir/test{1..5}
real    0m0.061s
user    0m0.002s
sys     0m0.000s
$ strace -Te getxattr ./xattrtest -t 2 ~/mnt/dir/test1
getxattr("/home/myuser/mnt/dir/test1", "user.baloo.rating", NULL, 0) =3D -1
EOPNOTSUPP (Operation not supported) <0.000048>

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
