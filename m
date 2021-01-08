Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004B5C433E0
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 00:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE4C236F9
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 00:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbhAHADg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbhAHADg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 19:03:36 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2931C0612F4
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 16:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=FbxeZPioIpOZYWOVs6ww/9+11jxI15jCmVf7j+2qRPk=; b=2Ur3n7aySS8SaKlv0zmLcgpuqH
        g33GZ0m1AIrThnGPPCP0xGoU4cE8zU0os+oFk8zAgAu+kvVawnhB9em6J4MvuSzjufuoKzBVqXBe3
        s0sxd6XgeABgqpFhAP5RXZbtQ86khMd756NzHUbaZPpT99G87m6a9W1lqLQowgYzgkxENzD3qRLXT
        ZQdbwEfXoIM6XYs8e+yu+olCfsNlEIAD0sjCgM37k0B+r7bmVl+y048IrL53aGxN0vsdsB6/Kwrc1
        oWYlM7zVBmTC6kKD3HlV9jfFYNt0brzUPMiYAq+qB1xQvi2K4zyS6hKAp2YT8xy3jYjICfZNO5TPi
        DABf3mxLEO+7ykDoN0+BqfUEyXK1r8KMFi0Y07DV93JPOIl6eQst4ICPQ3XoQ5W1CINSz0wtydagb
        p0qvIjaXetiVrb6gP7Ncq1l5FKTf4I5S2F7mEYjaBayGKmaAZl/5MMeHe+VnFDu5UsY/g8M6vzske
        tsp3genyXUd27M+H6vN2axGD;
Received: from [2a01:4f8:192:486::6:0] (port=58480 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxfEx-00047N-EA
        for cifs-qa@samba.org; Fri, 08 Jan 2021 00:02:51 +0000
Received: from [::1] (port=27920 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxfEw-0031zn-VE
        for cifs-qa@samba.org; Fri, 08 Jan 2021 00:02:51 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Fri, 08 Jan 2021 00:02:50 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13712-10630-ukJJ6nMmVi@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

--- Comment #7 from Steve French <sfrench@samba.org> ---
Here is the additional patch which helps with the case where the path compo=
nent
with the trailing space or . (period) is not at the end of the path.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/cifs?id=3D57c176074057531b249cf522d90c22313fa74b0b

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
