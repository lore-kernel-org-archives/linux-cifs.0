Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED35C43465
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 15:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA0720758
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 15:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUPA4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgIUPA4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Sep 2020 11:00:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6137C061755
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2020 08:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=dHAZp5OpiHK2nNFdbEGVtugF0IvNOcoEFM5AauRyNE4=; b=r9KIcVoee7q9Evjof6w5bXjq1a
        NiVsbHJl/7DIoNQo1hSdVp3O4f8fgo0ac91uja4d5IYCOxreY2iKCgwcgSndKRCFfrCXjAAWzxbpj
        B3jUXCmS7yntJ8ZUI3sZdFgQ213N+VyrRY/jvgJ7Puwi9qmmKTeUaz4sHogwxLIOst5rPOw20WeHa
        fjXrf2URFSzSX7nDgVusi/lxcbqfvo2ChVaQvPz7jBkGuek46YgTnuho9LjO2kY8rY0TLWMwSFVYY
        a2Yn5o4AolkhlrdmiLRTWIetGf1ofFgMYeh2QOMmRXNk425yGDoz4lekSfw4pEmf40tV2cTAvn3VR
        OK/xcsa40LPhUyrXPkzTyWtFbzrxjwk6scqsOjq3WT4T4winC1NRzMosVumd1YN8F2vesWKz0R0zf
        gTq/pcl/axBMyTVGMfW/or3o+ZPjYfzvMxsUWPDkxl0xgwlTTJxFEyWu0DWxbVsFJZoXzKumMJZ8I
        WTrOA3sZqEYUJaJQ3XvL9Ef/;
Received: from [2a01:4f8:192:486::6:0] (port=18458 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKNJF-00069p-EF
        for cifs-qa@samba.org; Mon, 21 Sep 2020 15:00:53 +0000
Received: from [::1] (port=31138 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKNJE-002v1B-Me
        for cifs-qa@samba.org; Mon, 21 Sep 2020 15:00:52 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14498] Why is mount -a is not detecting an already mounted DFS
 share endpoint
Date:   Mon, 21 Sep 2020 15:00:52 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: Chris@craftypenguins.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14498-10630-BlS4cUESrT@https.bugzilla.samba.org/>
In-Reply-To: <bug-14498-10630@https.bugzilla.samba.org/>
References: <bug-14498-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14498

--- Comment #3 from Chris Pickett <Chris@craftypenguins.net> ---
The kernel version is the same on both systems. They are LCX containers run=
ning
on Proxmox kernel version 4.15.18-30-pve. However, they are on separate
hypervisors.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
