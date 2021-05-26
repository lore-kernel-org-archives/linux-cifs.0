Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22BFC47082
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 08:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C7161355
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 08:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhEZI7B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhEZI6y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 04:58:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1079AC061761
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 01:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=i4Pa+yIZy3dMHYeAFQsh9myh9sgfg/DxmnigI/PHPp0=; b=iB83wKHVyHslTDj3dxpAZZRzWG
        GWW9Krmpc/31o+PdNQzqDRnzq/5FfhttEbGnq7q8QWoHMh6bw2MSwvyNYshYTJo9VN99QOI9mak9c
        UiTDJmsQchSLU7HjBT+RA/w6U/cZqTNWBq+FrdtR+xJbkwIA2Qe6zcLaDOH5UPulq6X5y0z67cjUr
        yTDTAnFlDR0ruWMhM2mAd2uKklhibfO9QUoyidALb8Uk/TEKBgykGgC3GGmz0MWM4H9vuJ+tnzS6m
        jXYzW+5g+9yBMhoQ22OvsK84EksWKrnolCJayGn3mJ4gbw8egu6JlXvouy/YTmiTv8Y0/H/ae4REG
        C1D2cgqSwgq5jz3/4p0N2rmT/+BlIHPn1/feIHI68mrFCd9Dy1Ly+pepVAvwiuyIS5KHRRV6RP8N0
        GgZZN5PH44chMPnoVTjyx29j8qRIYH3B+GqU36aXki0Wv+aPEuJvj0xLcJy356DWpmhpOSW7LpXft
        W72kSnTyPx3ufcuTG2QwM7Vh;
Received: from [2a01:4f8:192:486::6:0] (port=56150 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llpLq-0005c3-Rv
        for cifs-qa@samba.org; Wed, 26 May 2021 08:57:18 +0000
Received: from [::1] (port=34036 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llpLm-008of3-Gt
        for cifs-qa@samba.org; Wed, 26 May 2021 08:57:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 08:57:13 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-14713-10630-Q8SYb4K9lx@https.bugzilla.samba.org/>
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

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aaptel@samba.org

--- Comment #25 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
You might not need to recompile your kernel.

I have a GDB script (made for 4.4) you might be able to run as root

https://lists.samba.org/archive/samba-technical/attachments/20170524/295014=
0e/cifs_dump_keys.py

It reads the keys from kernel memory. The offset (OFF var) might have to be
updated for your kernel (or not) but it's worth a try.

(this script just reads from memory, worst case it prints garbage)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
