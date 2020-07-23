Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A419C433E4
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC4220792
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fGxESore"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGWMBo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgGWMBo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 08:01:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FF3C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 05:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=a+Rg7Lw8LH9pIyRumvuDCMcBnVqmuTxA9VlLYA93Y08=; b=fGxESoreREeeBCfmP+rqSb3J6r
        PPko7LTg9Ts0Vuj5KIkN91ywRfquV3hxuK+RuO6NK1Powu+TnMq6qL25WNlzZ7CDsfbhFAxHFPhuC
        aCWvkt2gob5LqkDBnuEFzCmt4D/FBgl8zPEM2NQ2xo5nH0iJCDRmUeRJDFpyFedFklOOYyZqH9tOX
        RfaUj3OrQzfVRHZ5JV7Laa6tGDQY3y+B8NtGqshVRS1nT4fiXdZIeMf9kg9DC+GOdggYFCT2QnHNf
        po8j2AxHV5bTYIuY83BH+bT3QW9r5DRsVR1Y4oGR0u3wS5RW9kJEHEXoLG/YWxeXC+/6cEm9ZzVyM
        i2amTFYsRliJ9i7Uc5Hyyp3CMDOepLuiw91J5h3jDploZeBtrnb0WforbE22kapl+4wKVBDKlaT/I
        tooJqwGsOfbx0RCVmdRf1/3EdYqBf5zdamBUYiG2TD4w7dpqHH8ri+O7uZXyURsMF3JnTScxk6COH
        UGbEEKp+s9nFE4KelZjdWQnO;
Received: from [2a01:4f8:192:486::6:0] (port=43190 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyZuv-0003rQ-Np
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:01:41 +0000
Received: from [::1] (port=29150 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyZuv-00714O-G9
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:01:41 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9635] C : missing directories
Date:   Thu, 23 Jul 2020 12:01:41 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-9635-10630-rEe4VhacQ5@https.bugzilla.samba.org/>
In-Reply-To: <bug-9635-10630@https.bugzilla.samba.org/>
References: <bug-9635-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9635

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |aaptel@samba.org
         Resolution|---                         |DUPLICATE

--- Comment #1 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---


*** This bug has been marked as a duplicate of bug 13107 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
