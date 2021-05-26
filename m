Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B594DC47082
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE12613CA
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhEZWlb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 18:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhEZWlb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 18:41:31 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FD1C061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 15:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=HGCcIRRYMfCpovsmcLl7SP/Ei0ZIntd8rTZt9geF2MI=; b=EXJ0/UQKEzFFwtY/J2xzla/hD4
        3XhXMmfiEs8zEnHcgHxZz4TnbsP5apQ/Yb48Q00C6p4kataHrGJoXMmyWx7h4s5uFBfgnv5YIckuJ
        avaP5I0JiXTMYS8/K7nM2u8GXvwlT/F2cN6d6zhu+eUXsbgHaHr9VPRPjH/P1CyZ2P3Y9B1k53YU3
        9p23ckrSoPmedeJeDbdpxhgPwNh4FF344iJPZWR6kjgA6MJe2XYV5A17LLM40D3i6IWAMKvhrhxLM
        WudmeDTKUP+FzL+DnA/pbLHWRgKDfw4xs7kAa95/RAx0pWMG2R31jX/KVQoS/yhu6KYpm8KVmugeU
        icCQ2EwW/Ryc7A1/75j9lDYIj0azlup8pdyKtSbiEBO6Gdzj1faUsCQ/xXuw3BVMaLgOByW/l0Qdi
        IGpPM7Mg7gHleGCy6KVR28Bv69EgvvMHnKKKi4nyrLa3CNBqmRsT4Z0mXo9aKOeR+zEDlDzSeCpsh
        L1SPIpegIey6RVLw4278SLW3;
Received: from [2a01:4f8:192:486::6:0] (port=56410 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lm2Bw-0004ag-NB
        for cifs-qa@samba.org; Wed, 26 May 2021 22:39:56 +0000
Received: from [::1] (port=34294 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lm2Bw-008pKC-74
        for cifs-qa@samba.org; Wed, 26 May 2021 22:39:56 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 22:39:55 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ronniesahlberg@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-l1JCiYZOAg@https.bugzilla.samba.org/>
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

--- Comment #34 from Ronnie Sahlberg <ronniesahlberg@gmail.com> ---
Signing.  It is not required on the server config,

BUT in 3.1.1 signing is required for all TreeConnect calls (0x03) always, by
the protocol.

In 3.0 and 3.0.2 signing is required for all
Ioctl:fsctl_validate_negotiate_info calls. Also by protocol requirements.

The command code for Ioctl is 0x0b, which you saw in the log.


At least it got the mount process a bit further by using vers=3D3.0 since w=
e got
past the TreeConnect.   I forgot that in 3.0 we have that Ioctl call.
It could have worked, but I forgot about the Ioctl :-(


Anyway, this is another datapoint that tells us that the issue is that it is
related to the session key imo.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
