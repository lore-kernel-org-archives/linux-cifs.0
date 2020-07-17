Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B40AC433E3
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 14:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372612070E
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 14:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="izvQg7YG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGQOvH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQOvF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jul 2020 10:51:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90907C0619D2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=cAeu+aqd6SEnkJW3hR5I07e5mNQtCm8aFSe7RzC5D/M=; b=izvQg7YGI7nxaK+CnAhxFx6T0+
        iNmSyiF6nnwHNXVjnZ2OoRxLoSVdhX717azqJ/xc+LPwvtCa1hESWDt6YMqcMRM58DIQE0i+S31Yq
        1ppNRhad+eOLr3+YvoUMB+drq1piXCMSR/+pIgD8giSaH93mZ80dLpLF6ZQFRPgZmBGcIbgHIzjMW
        SJ8G+H6vkqdkMUjbfgc3hoD1JBGzCRdVOkU8KOausObH4kZ7hZzwlN+sEa7tJoGrcNbEEOgREp1WC
        MNXzetb1TVRcpcVHG5Ma/KIjgE7rqZcqtgy7HW3P0iu7cvN5SDMBzHYcI5JBseFWwVT/gb8GP0WY5
        B6xHIFuXLJRWZ0tklLzCV3BY8u7syetfkd7Q9hHUaLbAYG617HCo8kkLCjMz+jkCVZUEUGEar/q33
        nOFzz4ZEQ6gNpl66caVSDgQwKv+WtldU51Tr6xlf9CzPJXNlWp58y+jkifpCi5G7XezJn6PL/kiyS
        VzzDZAL30owx9xiZaQ5bLZf2;
Received: from [2a01:4f8:192:486::6:0] (port=40820 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwRhW-000385-Lx
        for cifs-qa@samba.org; Fri, 17 Jul 2020 14:51:02 +0000
Received: from [::1] (port=26776 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwRhW-006Tte-C6
        for cifs-qa@samba.org; Fri, 17 Jul 2020 14:51:02 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Fri, 17 Jul 2020 14:51:01 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: lancelot.bogard@orange.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-ajea2bbUs9@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

--- Comment #3 from Lancelot Bogard <lancelot.bogard@orange.com> ---
Hello,

Thanks Paulo for your patch. It seem to be good for me.

@Vadim, I tested the case when systemd-ask-password is a shell script with
(#!/bin/sh). All Arguments are sent correctly and not executed by a shell w=
here
the bug was. Maybe I'm wrong.

Regards,
-- Lancelot Bogard

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
