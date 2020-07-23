Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FA7C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5D6A206D7
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bgSAjYvv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgGWM2N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbgGWM2N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 08:28:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB3C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 05:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ClY8Gbp0uSb8jAgeSdmUsUi1uPKIRyUYbfLYVeaFEWQ=; b=bgSAjYvv1qfhW6MpdBWzUz5JDC
        VSHhFlqWNmvFgg7jMJI/ap7ZAV6A/gO56PWH8/ahMsDfOiRRaQY3RP9A9kCRnj1grYk4ReCNmmAUK
        exEqmX2XwUrywX9/OsIPu0n6Zvyf0u0aHSjUIIlcE0iDw/s16IGIzwrTOZxIWwsRpc1NH1UGNYP5b
        ydA9pN3bnB4T4g+C8VSZPbEYEevIgpqhDWy9DUzVg0KBPstyB7/vgs72e8vHiBF2I5dxKpakSUmVV
        KFBOBgrBzwUJl1SQYWCz2jnMoHDmUWWqPH7rBeen6a0/QWR4rVwbyYlugzIVvJQdPOAhtxVnyYt7Q
        V7mkZ8sNjYE4nvNBuMwY0o6m7KIadG+kaLCeOFV+cPuaCVUUgJCPSYeopHuAUPIxyldbOMn9IkZ5l
        cV5pf1Ci1bN7UwyUxqQqa62J+paUzvzW0IOVnWiHNftKgskTSIUnqdVVLKPq2E81OtZVZuB+OC37+
        flI4wiOwCdIUgNbdVpgr3GON;
Received: from [2a01:4f8:192:486::6:0] (port=43240 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyaKX-0004Bg-AD
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:28:09 +0000
Received: from [::1] (port=29192 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyaKW-00716Q-LZ
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:28:08 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 7325] linux-cifs download page is out of date
Date:   Thu, 23 Jul 2020 12:28:07 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status cc
Message-ID: <bug-7325-10630-ety5ESjHt5@https.bugzilla.samba.org/>
In-Reply-To: <bug-7325-10630@https.bugzilla.samba.org/>
References: <bug-7325-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D7325

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |FIXED
             Status|ASSIGNED                    |RESOLVED
                 CC|                            |aaptel@samba.org

--- Comment #5 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
old site has link to the wiki. closing.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
