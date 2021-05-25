Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C210FC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A252D613F5
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhEYTjR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbhEYTjR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:39:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F1AC061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=4I4UbSOwaXMNeD33PAj2M6TiLTAsiWJBg1jm2+VnLow=; b=ZGfNKnMMauWKSNQ6wShZnhEdSm
        ccA+tsqFQvUCuVIar4is5LdRBeFyfSX3bUam+z1mLy5PcX0F3zT6O6gc6FJpRaIlUrgMy2p9VfE2x
        3qR/VIqRR7QwwhNhyB1JsPpprOtLJ34xDaPg9iqRpxjghKEfPxU5Ut9mTqUUWEuvnWOXQH6Z12zyu
        yWV3adoU59DTH145PwSdsVAvUchVh4J4g9aJqkykrTMjd6YkHRFLU/xzmQKFqAqOJ4aZxlYhRn+jj
        m3vCteaQ0ltNeESUSyGbc04Y+IHrI5jf2NhWgkL3TVyKGUAfi0dONnJsNTuneOSMGMVYkUoA5IIRN
        xZaYQwZOOx9jpbzrYPjE1m9hFAOtVhE2XnyE+wBJPpv9B5YN3ynZ19CxIb3Y6zcI1m1mUkX9F9fwL
        ZqaEkeD+rdbKEptQsl7P0OAYIP7UZQ0yr6p/vG6AA8epbdU+kBB6mRO7YgAy9fGESW5xXEXaRzhyh
        xIG28JkgjK2WKAzPUvGQhths;
Received: from [2a01:4f8:192:486::6:0] (port=55958 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcs4-0006ns-Kc
        for cifs-qa@samba.org; Tue, 25 May 2021 19:37:44 +0000
Received: from [::1] (port=33844 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcs4-008jx7-6W
        for cifs-qa@samba.org; Tue, 25 May 2021 19:37:44 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:37:44 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-GFQX6gKkt2@https.bugzilla.samba.org/>
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

--- Comment #16 from Steve French <sfrench@samba.org> ---
Based on the trace you sent - can see that when mounting with 3.1.1 (or def=
ault
which ends up the same thing), the server responds with
SMB2_ENCRYPTION_CAPABILITIES set to CipherId: AES-128-GCM which is interest=
ing
because that is the 'normal' case we see (Windows, Azure, current Samba ser=
ver
etc.) so this is less likely to be a bug in the client due to falling back =
to
something different than the more common GCM.

Do you have the equivalent trace from smbclient (the Samba userspace tool) =
to
the same share (trying to negotiate SMB3.1.1) for comparison?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
