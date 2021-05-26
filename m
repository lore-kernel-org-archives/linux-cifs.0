Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A96C2B9F7
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 09:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D35516128B
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 09:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhEZJCk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 05:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhEZJCa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 05:02:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B83C061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 02:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=LTts8OwQbdApvEzR/FZ9QaJfLR/7RYo7fk/VMqDNAko=; b=pttABFofBF39Nl9Ly6MgRQry5R
        vO3t/mBk780tYn7NKe6QMyGXYfljzh0c9NYKfeSCY/2rdgu3V2C9Dz8+rCMHiLvLJKsgdcdUkupLi
        QDzWJa01Qymhb8f5x9kgA/j9CwtUFJPmmwbtYtr8FMDsD14KT+6ifKPHWH815A2fqVl1cs5EnULI3
        QvEO+eJ/h5tY0WM3+iQwWeTcwSda2enRFpJR9TS+7u86LUm+6+GpnIwsQSMJcUEP8DyCYBfaTvAIA
        8jgFiGDiJJPH+Mm9kkDJPIousxyg0ksfxwSe2SZmNCVwSxtlyKDD9/5fujjjQf8DjlM8/CFFm9GXW
        A+5PMH3JfnsveexeQ84Wib/y0kLuurYq2kqfXryEcYcR2kwrgWVs4V0bl6yVtIH9yOz1neY2FwbcQ
        ankK9v+XFaTGR++lpZU+PhbamJVtNJCo4zWEeVG0B4mX+6+DnFRd68ILl6X+/3mxzLQnqaQR2wDe4
        tqcgH+PsMLC5b0ncHUA4H/rn;
Received: from [2a01:4f8:192:486::6:0] (port=56160 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llpP4-0005e0-PI
        for cifs-qa@samba.org; Wed, 26 May 2021 09:00:38 +0000
Received: from [::1] (port=34044 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llpP4-008ofy-KF
        for cifs-qa@samba.org; Wed, 26 May 2021 09:00:38 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 09:00:38 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-1eMU7STg4W@https.bugzilla.samba.org/>
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

--- Comment #26 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Ah sorry, this script assumes you have a successful mount point. If mount f=
ails
it won't be of any use.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
