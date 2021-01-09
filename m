Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C95DC433E0
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Jan 2021 23:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB67229C4
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Jan 2021 23:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbhAIXlP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Jan 2021 18:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIXlO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Jan 2021 18:41:14 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504EC061786
        for <linux-cifs@vger.kernel.org>; Sat,  9 Jan 2021 15:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=oM66zXX5CIeKu6ODzMyl41NTD9pSUhvS1w4j0wNHtxk=; b=JolpkUgROX0zE9rLE2Uw7vXY8Z
        Cr1xRDSmGFF5tXZP86oojYdTAEcy9j4XRQ5icd+jFYYkoD1j0on2BAEH2bD4ODAnSvr2zpAlIZw4s
        /KYSst9jWhcntNsm7yJHN7kubyyZVMY1XkziDST+LwbSeq1QOUzx2h1SLWzOwr6fs+edo65KHfs7Y
        lG2sYsElj4b7lwW/htt5Y325L24F2kfJadpcPTV+DuYQCuNxFqH6IdxRX/0JrkmfokCODTugJi3iE
        FktU3PKjgWkEpiA8TDknP83eXCuPTAZMsSFBmusLXr5XOboZ5y05Bcf5RxWDFjG+VcHMCaOqt8wYb
        /dtzNEjhwqzI5748wKEg7Y0X9gj91Ki2IKBuq1biGYJjdHxua7Ncq4ZCBITAw2ZtT9CxBIRwjzm8v
        ikSpfxvNA5oautjOCmLhnkvYx43XJTgpPowvY71l0gNAaBWIQVTwf4bS0DyyY7b4xMoIIM36qzKLc
        SMEFORYEvASau3WVtGHcKvjO;
Received: from [2a01:4f8:192:486::6:0] (port=59324 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kyNqQ-000573-LP
        for cifs-qa@samba.org; Sat, 09 Jan 2021 23:40:30 +0000
Received: from [::1] (port=28764 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kyNqQ-003APQ-5v
        for cifs-qa@samba.org; Sat, 09 Jan 2021 23:40:30 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Sat, 09 Jan 2021 23:40:29 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13712-10630-0DVNRlKZlh@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

--- Comment #9 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
Steve, it would be very good if you would backport this to all the stable
kernels, which have the unfixed tailing dot behaviour because without the p=
atch
that you mention, cifs vfs behaves completely broken in casees where such a
directory exists.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
