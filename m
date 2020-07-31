Return-Path: <SRS0=14TU=BK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B55C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 15:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95782245C
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 15:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jDxSV54F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGaPHe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 Jul 2020 11:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgGaPHe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 Jul 2020 11:07:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898C7C061574
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2020 08:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=bPkw32L2eZxo0CdCUtSr7jyuXHvHnDBo9dw8maJTEG0=; b=jDxSV54FZq1klhnJ8d40SwR86/
        UJ4hADGz182pGN6vAPmUMaYp4ElfWWe8FoQdZ50KIvc8idZrMScDMBqSUz8ti6eauI16jzGO0My9c
        RtIx3BaaE6gq5nN+o/T7uZWawUsPoMVg/no5j8L9nj7v/kK4URKVbv7NtxVKC6s2vEncVsDoxakhy
        k9Ss4iTC5qhUy4abS0d45nOjnZ31/MeVR+UhGpNayeZnwy7e4Vspmrm01zlZH/QZPobGR7GLM7uLK
        nl2dm3quh7qepl1Qey0AYwG708//F/42LFEHUbk4oMD3VsLgNBtmfvi4N3vZajhLZzEF6kLjk8uSr
        O9oxnv6/D9UJhZ3IOEwa+/akgpRyDLLKHGY6MFkQFGC3kx2pptt0czYa+fCt7Ih8XGPIVM/SKOMz4
        cbMLKlGOmSTBhdyiEwsZSQxd1G8l/8pHsSLSGg/CUodfQQaVIOi69wNkbCJfY6x7dfJTWc7tXQJlQ
        ORGldFbA0KDSR0s1QkzMmPZa;
Received: from [2a01:4f8:192:486::6:0] (port=48260 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k1Wd8-0006uY-8T
        for cifs-qa@samba.org; Fri, 31 Jul 2020 15:07:30 +0000
Received: from [::1] (port=34218 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k1Wd7-007wK4-QL
        for cifs-qa@samba.org; Fri, 31 Jul 2020 15:07:29 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13470] DFS mounted shares do not allow to go subdirectories
Date:   Fri, 31 Jul 2020 15:07:29 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13470-10630-LbtX6Ss0Ew@https.bugzilla.samba.org/>
In-Reply-To: <bug-13470-10630@https.bugzilla.samba.org/>
References: <bug-13470-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13470

--- Comment #6 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Can you open a new bug and attach a network trace of opening the DFS root w=
ith
Dolphin, and another trace of trying to mount the root.

See instructions here: https://wiki.samba.org/index.php/Bug_Reporting#cifs.=
ko

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
