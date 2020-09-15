Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD03DC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 16:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BACA206B5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 16:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgIOQm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Sep 2020 12:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbgIOQmE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Sep 2020 12:42:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE49AC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2020 09:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=OCCTsY47O3RqUnTb8h3UzOQDgkpicwVO8NOTUR3yTYw=; b=xz664IvaRbK+fRjKPomiAA9zl5
        wStiTv614uTYD5IaUt0N2Gd162m5OJEFmXUx67cO2RdqjI8cFFzWHnHn1tpx2TL17TrMifoCFk8Yl
        h0Ek5Xln7QXZbs6nn0nl6Mn+pXQqnZcVjeWHu8jRLR4J0mNRRiVlbEwvL/YtiKOVqIUHNNGu+2Gfb
        n0kTWYXqsMM6K7P1GQtqpSreem3Mz60HXFyx0NxDWbIVZEZBWUtu74G6qHG33JR1njxhz/hs63ALX
        r2Qab9b3ju7yNJeM9j4I7Y/xayJ2bj/RXhBShzWmxxLR/59CBr/TUMTls+QrMuJwF+RqtPeI3WT7Q
        1C0CjntVw+RfQ0pCIOKmv1kUhiDVCrRA3umM8KxdjcuYC1aHZtdgsxkhd4Zv3eStJNcQ1isD07Bl2
        qlpHv4ytLY6GhsMaRkEMR45eSTMH4t9LEafgo6Wc6ZwJP9pI8km1EfI93IzglpjrWp8dZlzFRjbd5
        mKLksuvC6usqJFAwlbH/amk0;
Received: from [2a01:4f8:192:486::6:0] (port=61014 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kIE1S-0002Sd-Hf
        for cifs-qa@samba.org; Tue, 15 Sep 2020 16:41:38 +0000
Received: from [::1] (port=26158 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kIE1Q-002LE0-P0
        for cifs-qa@samba.org; Tue, 15 Sep 2020 16:41:36 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14493] Conventional tools for managing ACLs can mislead the
 user
Date:   Tue, 15 Sep 2020 16:41:36 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: micah.veilleux@iba-group.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14493-10630-fidR1911OE@https.bugzilla.samba.org/>
In-Reply-To: <bug-14493-10630@https.bugzilla.samba.org/>
References: <bug-14493-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14493

--- Comment #2 from Micah Veilleux <micah.veilleux@iba-group.com> ---
Thanks Shyam, you're right.  The results with the "cifsacl" mount option are
still problematic.  My mount options are now:
------------------------------
mcrw1:/TCS # grep "TCS " /etc/fstab
//mcrs3/TCS /TCS cifs
user=3Dcifsuser,multiuser,domain=3DVPTC3,sec=3Dkrb5,iocharset=3Dutf8,cifsac=
l,mfsymlinks,nobrl,vers=3D3.0
0 0
mcrw1:/TCS #
------------------------------

The "+" is still missing from the output of "ls -l":
------------------------------
mcrw1:/TCS # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrw1:/TCS #
mcrw1:/TCS # ls -l testfile
-rw------- 1 VPTC3\cifsuser VPTC3\domain users 0 Sep 15 16:49 testfile   #
permissions are ok, owner and primary group owner are ok, but no "+" is pre=
sent
to indicate the use of extended ACLs
mcrw1:/TCS #
------------------------------

"chown" fails with error:
------------------------------
mcrw1:/TCS # chown vptc3\\mveil testfile=20
chown: changing ownership of 'testfile': Input/output error
mcrw1:/TCS # smbcacls //mcrs3/TCS /testfile -k yes=20
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser       # no ownership change made, but at least an error
was reported
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrw1:/TCS #
------------------------------

"chmod" makes correct changes to the target user, but also incorrect change=
s to
other users:
------------------------------
mcrw1:/TCS # chmod u+x testfile
mcrw1:/TCS # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\cifsuser:ALLOWED/0x0/FULL             # permissions changed as
expected
ACL:VPTC3\Domain Users:ALLOWED/0x0/0x00120088   # permissions set
unintentionally for "Domain Users", and removed unintentionally for "Domain
Admins"
ACL:Everyone:ALLOWED/0x0/0x00120088             # permissions set
unintentionally
mcrw1:/TCS #
------------------------------

"ls -l" now reports updated information, which is correct within the limits=
 of
what it can convey, though the "+" is of course still missing:
------------------------------
mcrw1:/TCS # ls -l testfile
-rwx------ 1 VPTC3\cifsuser VPTC3\domain users 0 Sep 15 16:49 testfile
mcrw1:/TCS #
------------------------------

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
