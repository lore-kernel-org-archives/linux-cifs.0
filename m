Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E10EC4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 20:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201C66140E
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 20:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhEYU5I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 16:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhEYU5H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 16:57:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C45C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 13:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=d78Mg6wo0RUCn0IzgRA0/KN9c4z0uQJcsQks5EbSZoQ=; b=QmGy1TbdIlAGdURv0lkb7rQ6k+
        Zkqay/4wtkep84lFoe5CP+oXy6PcKTZVj96s8b6ownSQiKSGTO/ULTnKk0PKjeuEY1UQS7rSFv2KB
        DETG8G/oNNBK7lbpXcYiT1gp5risusNLearqUvCGIiTL1zvK+XpzNOq5Gy8IFFVQ8TqVIA94Gd3Mz
        Cgyq3otxf24i+v7lPIgvEaKIzj0LLP5RKtP4wlarBvn6AuXRIGsHonl1JpXb8tBYdSNwPuvhjoa9b
        s8ky9ZKFe/A6fKj680neYfmesO80mQ8p6bqIHcj1XJiF7eH4bklfkYllJG/qO7QCphh1F9mLQrTxd
        i+BTpIxJuZPFc+MBcUOByK/j8yz/vho+89X8BCl+S7enwtx+rqhHDTO8agJpgI5Bd04htmPzCBbRf
        nC40yc0y6li2tzlf3p/QiGNJA4XyIxEerfva2fLx1VLYxoa1hlnSHBYZPOuXJPuXfG8QWrCg7wmVj
        a4fWQ+w+W8s/HZeznpOAu+MN;
Received: from [2a01:4f8:192:486::6:0] (port=56004 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lle5O-0007MX-6d
        for cifs-qa@samba.org; Tue, 25 May 2021 20:55:34 +0000
Received: from [::1] (port=33888 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lle5N-008k2y-QP
        for cifs-qa@samba.org; Tue, 25 May 2021 20:55:33 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 20:55:33 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-FTA3DxarlF@https.bugzilla.samba.org/>
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

--- Comment #22 from Richard Flint <richard.flint@gmail.com> ---
I'm sure it won't shock you, but adding domain=3DSAMBA to the mount options
hasn't miraculously fixed this, but at least it's another data point.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
