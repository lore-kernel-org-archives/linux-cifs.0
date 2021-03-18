Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39609C433E9
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 07:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D1D64F41
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 07:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhCRHeG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 03:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhCRHdv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 03:33:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5580AC06174A
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 00:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=HZC2bIbrRrrAg5S7JK3/yiEwZzBGAl3elPO39xstJO0=; b=09COsQnHiNMVAATfOTJEw1U9QP
        RdMzBDhNOUKzWBFzVkTX9xDTR0g+3uPGh1LyR+VS8yN4vmFHTHj+zDfFp88A87VgR+1U0VhwlHHnu
        tpWc9iw1iN3Q5VnhbbKI9mBQd3+6K6RavOFbrhvYRd+q+mSQ9Xu511hXGJM8LcF3VKUoEtlvkaev5
        QIhzLyXOpFUY6mxS6Q4dpv7+g3xAq/bIIbIkNpMd2aGMOEBEkcWCmjpAV7tJleUw0vwfavqAXLwXu
        t/tIh7xSyz86+QZeqak+g0vlf3EXCbLnE2NINBDSMt+INa7k+Xy5xiS0teKggjBlWXIJ+dfSoNS/i
        5Lq+oXFLXHoOO9UHm9S/uVATMIKa3q3h5eUbNDrRTpdkTCad65qq3W3phtmDBGRokyDznRU7Gwb55
        PtwW9wc5ziaM1Qb5G3nLTZKwiJZqnAZadttPWhycVA57SexvXKa3IbTO2g2eumimgnswwq3AYLexr
        rz+NDO3zr8NDD9EMzObXnCqX;
Received: from [2a01:4f8:192:486::6:0] (port=38182 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMnAD-0005Zh-5n
        for cifs-qa@samba.org; Thu, 18 Mar 2021 07:33:49 +0000
Received: from [::1] (port=63604 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lMnAC-002iWp-Ly
        for cifs-qa@samba.org; Thu, 18 Mar 2021 07:33:48 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14494] "setcifsacl" confuses "R" permission with "RX"
Date:   Thu, 18 Mar 2021 07:33:48 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: version
Message-ID: <bug-14494-10630-dugIJZXmUw@https.bugzilla.samba.org/>
In-Reply-To: <bug-14494-10630@https.bugzilla.samba.org/>
References: <bug-14494-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14494

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Version|3.x                         |5.x

--- Comment #1 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
can someone of the cifs vfs developers please have a look?

Generlly much of the cifsacl stuff is really nice bug with the outstanding
bugs, some of those that Micah  reported, cifs vfs with NT ACLs is just not
usable and people who *need* to use full NT ACLs with a POSIX client have no
other option than using a different OS with native NFS4 ACLs support like
FreeBSD currently.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
