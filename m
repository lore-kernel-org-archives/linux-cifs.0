Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECBC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jul 2022 21:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiGOVRV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGOVRU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Jul 2022 17:17:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B597D2B620
        for <linux-cifs@vger.kernel.org>; Fri, 15 Jul 2022 14:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=dxlkVL8wwNOvU05BDPZcA5cCL/1fc/XL2Z8r0ODW3Aw=; b=rPzZ0BoUEbsmjS4eeqNbwseLhA
        3nzcmavW08OU09qipOQvNWGfCsdFwyFZ7R0TSB42rOPeJcVo9WNhK0usrjWLZeCu+3FxmxGlvE+xV
        SDo9ZB7TPJA9GzNGgoVWiFahWPHRMXfeqTV7naGA0IP7mZ1vHLPlXDQD0D/36+VGt0LNEF5+h/TOl
        dQkiaA5ssFlLLRGIwuDZ/Yh3VY1tXJeutQAybvCCVxWb+U4F9s2LJbwhTS3wmKuT1xcLBrls3VpMk
        kO/wWy/RwmWJUxPjDbS9ZLaVa30p2e0JEUAyRryxq7+pYnkCHKqL2QgiPDtXFQJq2d6JbjY+xdWs8
        mizm/IFZg/8QsvkXDcCE6SgWHBKhbD87bjgVc/pxlLgTdsEgz4wccEYwO/OAj8v6Bq/U+6Vw0ZbCe
        kWVsPIOyflPzfZeC+TswSc3mSrlfxqq3mYcsQWzR5qt2Wpj36QNHpkjD/+Bms3W9fXwKk6AYHKgtD
        uErTsKuwbq/2MYnKrXJuzFaw;
Received: from [2a01:4f8:192:486::6:0] (port=53614 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oCSgW-004veL-1h
        for cifs-qa@samba.org; Fri, 15 Jul 2022 21:17:16 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oCSgR-000tfd-9j
        for cifs-qa@samba.org; Fri, 15 Jul 2022 21:17:11 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15123] New: getxattr() on cifs sometimes hangs since kernel
 5.14
Date:   Fri, 15 Jul 2022 21:17:10 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone attachments.created
Message-ID: <bug-15123-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15123

            Bug ID: 15123
           Summary: getxattr() on cifs sometimes hangs since kernel 5.14
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: forestix@sonic.net
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

Created attachment 17423
  --> https://bugzilla.samba.org/attachment.cgi?id=3D17423&action=3Dedit
possible reproducer

When running on recent kernel versions, this system call on a cifs-mounted
file sometimes takes an unusually long time:

getxattr("/cifsmount/dir/image.jpg", "user.baloo.rating", NULL, 0)

The call normally returns in under 10 milliseconds, but on kernel 5.14+, it
sometimes takes over 30 seconds with no significant client or server load.

Discovered while using gwenview to browse 100+ 1.5 MiB images on a samba sh=
are
mounted via /etc/fstab. While quickly flipping through the images, the prob=
lem
often occurs within 20 seconds. Gwenview freezes until the call completes.

Client:
  kernel versions 5.14 and later
  mount.cifs 6.11
  Gwenview 20.12.3
  Debian Bullseye
  4-core amd64
Server:
  Samba 4.13.13-Debian
  Debian Bullseye
  6-core arm64=20

A git bisect identified kernel commit 9e992755be8f as the problematic chang=
e.
The problem does not occur when any of the following are true:
- Client is running a kernel from before that commit.
- The nouser_xattr mount option is used on the cifs share.
- Gwenview accesses the files via smb:// URL instead of a cifs mount.

I don't know Gwenview's internals, but using its strace output as a guide, I
have written a potential reproducer. It succeeds at triggering slow getxatt=
r()
calls, though not nearly as slow as those triggered by Gwenview. I will att=
ach
it to this report.

Originally reported in May 2022 on the linux-cifs mailing list:
https://www.spinics.net/lists/linux-cifs/msg25316.html

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
