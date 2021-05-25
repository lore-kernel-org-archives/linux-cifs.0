Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92F1C4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A13561401
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhEYToC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhEYToB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:44:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFCFC061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=rlKkeq2p9NnCVnZ7sK9NeqxChMEKSDCZt5iLl2bhDCI=; b=PcSnffFdkpbafpOZ+16ZhHQGYV
        SE7p4SD32AB4YnIPpgnVVDmSg3i8a8jhrC8PsPKtXQtcsnt/qevSpJeaiJBdsZVcVFLJcPA++RUl/
        fj1B+7Aa224gPe5fEQvIcMZbVcUy5UyDpValLhWwJ0mAoal5sLwg0MhBqMIdXYNeQJZ9DxU7mFEBe
        qCAT4L1y4N6QWxx7IkGq6gfuCD12v/BLw4z/HCYp785Xit0RM5We9vAwzLAysVhyTgVcOzZK64VEB
        vsKlGudp1L28N0iV1rnZczaQwg4Kw4V7BHkhJZ+a8tJWb1sYVTGkwFQf9xCpbgf1xFohg0PpB5rbE
        F6QxdZlHWy5ruj4oNc83lAL9ZgFmo9hDS786WjlUo6klcrZ0fr81ErR4wB9sLEAAIV6AXgRd6kF0+
        PjfXBK1KndvPivPhjqA7nKXjtbh8xVuggdqONp4kZHuAX5EwewXIVRN+KE7pjqp7VqTgmNPsBcIjd
        VQMpfXrHdOKDJf0hl5wsPsb5;
Received: from [2a01:4f8:192:486::6:0] (port=55966 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcwe-0006q7-Vx
        for cifs-qa@samba.org; Tue, 25 May 2021 19:42:29 +0000
Received: from [::1] (port=33850 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcwe-008jxM-KA
        for cifs-qa@samba.org; Tue, 25 May 2021 19:42:28 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:42:28 +0000
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
Message-ID: <bug-14713-10630-aPZrdZLXHY@https.bugzilla.samba.org/>
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

--- Comment #17 from Steve French <sfrench@samba.org> ---
In both trace you sent (seal and not specifying seal on the mount) you can =
see
the server is requiring encryption (unless you mount with smb2.1 or earlier=
).=20
See attached screenshot

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
