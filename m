Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D58FC4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 21:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D58F613D5
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 21:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhEYVmU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbhEYVmU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 17:42:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B33C061756
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=qTzEMwO2c6Dp96c7BPOLJI/HesDhy6WgRmHIVN/4pnk=; b=3k0twgb8bLiFHsgv3HbBGrC9Ka
        BEMxQpk6bxmUsnsZIa4fI2C6I5IZxBmLPMswKVdXvwnU9MMPj7zsI+kzeS9GUubvMyqY5aDimQG4y
        R9vawoJ9glO3kmXgbnaJ1rGLH3bbt2r2m0HY1XgMNfc3J6CV7I9xwsu/8wBuDXLSrvBMPvbl7hkRB
        he6O3gHlczdh/IdipVtZvQou5W1yAaui4u9/UtZ1If8k574yIRBLLYUEnc7Kx2SWq857tf+2JELsg
        tO66xA3v0Mf6tw6xU8paG5LCGIHdCGNWRnZ+tBr+JrRbGWkPZNBP1FPW6NQ8zvHlpIE+bgbZKXenL
        FX8XSl2w+Xa5szXkY23vCN7vQv7jZ2rrRpIadGdKwKgkDbb5sl7/VhFklDtNkvx6+Swq1lZs0HoiG
        wgDMVV7Z3p7TaEtzAZUcoE29mEiFbGPgeaQZrxiH+iyuOy0l3tevOLwEGyzFExNZ1e8Gi6VlpFGvu
        WlYGyIOy55L9Iirxh0k9hsFk;
Received: from [2a01:4f8:192:486::6:0] (port=56014 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llen9-0007ft-E8
        for cifs-qa@samba.org; Tue, 25 May 2021 21:40:47 +0000
Received: from [::1] (port=33900 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llen8-008k66-G5
        for cifs-qa@samba.org; Tue, 25 May 2021 21:40:46 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 21:40:46 +0000
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
Message-ID: <bug-14713-10630-KGMiTMJHcv@https.bugzilla.samba.org/>
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

--- Comment #23 from Richard Flint <richard.flint@gmail.com> ---
I am going to see if I can rebuild cifs.ko with the right options to dump t=
he
keys. But this is a lot of work - is it likely to lead to anything useful?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
