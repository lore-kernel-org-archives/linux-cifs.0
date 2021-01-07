Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBFC433E6
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 16:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3331D23403
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 16:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbhAGQDp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbhAGQDp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 11:03:45 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6F9C0612F4
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 08:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Cj1zzpJ7iZJ3DK25q/2ynF8LzYDfAKEMMUg20kA8zi8=; b=35ZWq1U/WswFK13/zy/zshAYYn
        Fo3hbOWARqwsecYpzMNzFMWM/SHuAXxeQ0NhxuxxFKs7D7b8kvvco0O2dmmNE9KZyhBgNY0LqP/2f
        appxVMWdqpcRh+wDWJY+49QhrHhQ+RQUIpuCdJpz7q1sZ9rTqHjzapGmeXr8tjOFQiWgEaFOtgYHN
        erlkoqtkjqJwJ+qMR1gexGBUmP4H5VW7nUNCOWS9uwN8pGo5Om9K2OOW63R8ABjIIcaXgv0zjYh6i
        Hs2zNqrApz65+NjyPQGpCmope+Fi+wZnSl2dqWgUBBPEijhzlOOChXjN0sk23cN4IAGoyrdg44DPF
        vEYkN3wlB5ABhM/stARtaDXk8feQWFgYyQ/BQK8aJ/qHf/B1A06fjIwHQxKKrHe1pp5e9Gx2e6FP5
        ThkTskjZ1ceqfArHdirq6V7JvqBPXrqPToFoVjiJQY8D4NB8ZHlO6/tbkWLwQHBCXExKAcQNscSGn
        n9XsUe6K5HjSb1bNV758FpYq;
Received: from [2a01:4f8:192:486::6:0] (port=58106 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxXkd-0000sm-80
        for cifs-qa@samba.org; Thu, 07 Jan 2021 16:03:03 +0000
Received: from [::1] (port=27546 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxXkc-002xs3-Ra
        for cifs-qa@samba.org; Thu, 07 Jan 2021 16:03:02 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Thu, 07 Jan 2021 16:03:02 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jan.edler@indexengines.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13712-10630-uo35U9CASl@https.bugzilla.samba.org/>
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

--- Comment #6 from Jan Edler <jan.edler@indexengines.com> ---
The patch I provided in comment 1 only helps if cifsConvertToUTF16() is cal=
led
for a full path, of course.
Perhaps that is not always the case.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
