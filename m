Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DBCC47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 09:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E586142D
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 09:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhEZJt1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 05:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhEZJt1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 05:49:27 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53599C061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 02:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=IAUIXew+ZQ/LwCwwsOKQDZpWtrBZFK3mJfBy8olTYWo=; b=Kfhd7Y5CMYjYWCYP5HD0rAxhUr
        L8wxbecFl1BOOGkF9Ql3W4jsfkP16dPEhEu4FYzSLsgm3GxjyKO0b41inAaJAYrPxlsB9wXltgk22
        7eQi2F1ADL3xV25uARTCIDCGcZ0Y3j3WdfV5wZwio8QR8zq86MDU49RBwtzeZ3BxaVeIYSithPsyH
        j9oiDLYDY6GSQBZTW1gbPYjLLMnKALkVw4ir1U4C9Jg9ndz8ptRQTvselbsEfcdEXZ5SLF9Hpg3Ek
        U3Z3TXomWg/CwuxDBKiXDxRbS2xaw2TS8wPZkWCgoyUL6SrziWeTEN6UOpTreH5Ia+vZaOQGq4JvY
        wq8EFwggbwsDRDO1lBtJK9tyQkKMAyZ11wMQjUoTefEl5OguHChQvVsWxF89+h+WPtx7pAg1YpJML
        +gU8tEKO/bT4rtSe54BhBy+Fnk6GVc/3FyESiVgBqahQIqgKUf+tMIIzCH7icfO3mxFgqfZcCqYW3
        0pevgMGiIphcDkYTSlZR9xfA;
Received: from [2a01:4f8:192:486::6:0] (port=56172 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llq8n-0005yw-MW
        for cifs-qa@samba.org; Wed, 26 May 2021 09:47:53 +0000
Received: from [::1] (port=34056 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llq8n-008oi6-3L
        for cifs-qa@samba.org; Wed, 26 May 2021 09:47:53 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 09:47:52 +0000
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
Message-ID: <bug-14713-10630-lh4eqiHpl0@https.bugzilla.samba.org/>
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

--- Comment #27 from Richard Flint <richard.flint@gmail.com> ---
I will look into getting the decryption keys. I thought maybe I could dump =
the
TreeConnect on the Solaris side using the Dtrace capability but if it's
possible I haven't figured it out yet.=20

I'm baffled as to how MacOS and smbclient work fine but Linux kernel mounts
don't.
I guess my fear is that some flag is set wrong, maybe during negotiation, a=
nd
there is no simple knob we can turn to set it just to test.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
