Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D09C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75ADD2087C
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lVkU4+qa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgHMQly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQlx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 12:41:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E27C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 09:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=WEEh9L5m+J3wpW+4cxSkunTwvE1Nmes2OZBDuhXRATQ=; b=lVkU4+qa3q1V/1MTAlyljpJ1UE
        3ROYCA0ZucGBwLXGtr8XIqSmAWbDgHSigAOeQfQnBIq/EOZDwptMce/ZDKvmzZ2A+xg3WOBIb++kE
        /DQhfeOUgMdVZSP/gKv9dmh4rBblSvB+4jQJT9BCt1HtaGzZxtATbCseUS4FDJMx/Ek8oqiQPymav
        acZiXg9puFXBnZ1Yd0HxVWVa10dwbqhCKaYsF9lbI0ezsCD4vGyub2UsWPUPOxx2cZIJZL/dQlNNp
        gisBR7SoyIhOm8XIpfpWCBYgw8O1GEN0hvGbggOV1x5epTJwMEW0CTBo8Yg3PS/bAlMZ1YbAmW2se
        1+OQBVhzOxi2fkC9QoXuqIbPF5bCtBBo0nPFsm0DBhKgUaL5USuepK+65JlRTfU1mfJ2rw2p0w6wX
        XykhL0g/0Fdq/yydjf/n2uzY3k9tunPxRMSyfOFPwfHOKHJxFio8x9AJR9i7RElS0yaq119p9JiQo
        8D6QEIgTsfvJKx87Fd/deQi7;
Received: from [2a01:4f8:192:486::6:0] (port=53880 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6GIY-0002lS-OQ
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:41:50 +0000
Received: from [::1] (port=39832 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6GIY-00934e-Ec
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:41:50 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9484] getcwd does not work with noserverino
Date:   Thu, 13 Aug 2020 16:41:49 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-9484-10630-xzgk2bVqle@https.bugzilla.samba.org/>
In-Reply-To: <bug-9484-10630@https.bugzilla.samba.org/>
References: <bug-9484-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9484

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |email200202@yahoo.com

--- Comment #1 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
*** Bug 9283 has been marked as a duplicate of this bug. ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
