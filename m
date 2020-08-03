Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD5CC433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C5C2064B
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SOXgjXyK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgHCMT2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCMTZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 08:19:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85C0C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 05:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=3NUkXRrxfrXHFFuZaL5KVph5YZDi760IDrRUJOJkgMk=; b=SOXgjXyKu6/3HRiC1mfqkXe1NP
        ul4V7+9mV2S7HwrK5E+vtR/Pr/iaVOCv1ZskO9t3hoPJiQ5UupYvRPtvYxdRGSWtPsIn3vhRa7FLg
        6pmEMVYwwDu9Lkr9zlcLs6+ZvgJXt9/Fj+YPCM5tDFqrUJbG0gmarlT7UuEdf6eULDIooeOeLTJFr
        JEmwh/Q816YTIH8mGdWQMAyW50gjJD1x3mX8hoNvkx3ZXpOVL/9Cn7E9VSby3a5cZwQ/fUcrUUrs5
        cc5x3M3PkhA53/XFIhEtFJmP5HDLKujoQ1yaSClvl9IULXjqD4Oub5DhU4xbSOwnXAMtYo82lrKpO
        cuwvLDvOGcHhlcH21L5f5wkdncO2TfMw+B5svWYnS2IsbD7n773ZJ9TqqtCrkiXsfXzen7lnuYUpW
        l2Cl66TlG9sqZ/FUxP+xySbtoAF+sHEKcAkWUOw5dJiYeeuvMQDpksJvpyNuv7/+J8PB/GbUB9Dwp
        vBWuWuB9YeWUp9wSc4E6qhEu;
Received: from [2a01:4f8:192:486::6:0] (port=49310 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k2ZR3-0007wX-1J
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:19:21 +0000
Received: from [::1] (port=35268 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k2ZR2-008Cbn-PE
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:19:20 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14454] New: cannot get symlink file attributes and target with
 cifsacl mount option
Date:   Mon, 03 Aug 2020 12:19:20 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14454-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14454

            Bug ID: 14454
           Summary: cannot get symlink file attributes and target with
                    cifsacl mount option
           Product: CifsVFS
           Version: 3.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: aaptel@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

On a Windows Server 2019 share with symlinks:

    C:\shares\data> dir
    ...
    12/16/2019  08:04 AM    <SYMLINKD>     DIR [sub\dir]
    12/16/2019  08:04 AM    <SYMLINK>      foolink.txt [sub\dir\foo.txt]
    ...

Mounting without cifsacl kind of works (still missing mode bits):

    # mount //nuc.test/data /mnt -o username=3Duser1,password=3Duser1,vers=
=3D3.0
    # ls -la /mnt
    total 3148410
    ...
    l---------  1 root root          0 Dec 16  2019 DIR -> sub/dir
    l---------  1 root root          0 Dec 16  2019 foolink.txt ->
sub/dir/foo.txt

Mounting with cifsacl (with working idmap):

    # mount //nuc.test/data /mnt -o
username=3Duser1,password=3Duser1,vers=3D3.0,cifsacl
    # ls -la /mnt
    ls: cannot access '/mnt/DIR': Operation not supported
    ls: cannot access '/mnt/foolink.txt': Operation not supported
    ...
    d?????????  ? ?         ?                         ?            ? DIR
    -?????????  ? ?         ?                         ?            ?
foolink.txt

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
