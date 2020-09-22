Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A91C2D0E2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 21:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06BDE20773
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 21:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVVxV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 17:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIVVxV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 17:53:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDABC061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 14:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=daH3BDEH5oZShlEsxL4ACiAQ5E6fFkDfSnXa+4KaQLM=; b=jAVMc+pzYqIR7nxVTuTvNI8LSj
        SptfrvRlvfRugXbA7oHrWVxidUKcc8qWURMU4j4h4Jw2IOW4IQFNsGNmLxzb1KTo9l8b8T9wy9n32
        YqY7tGBaGDXuGPavlpDcp4aWLmcFpIY3arq3m1pcfyIb43u4JuaFG/QC1/0PihJNUkC/gtFD/gzx4
        OxcSKhiQ/vQKqxanXNuvJ3YrbyVNtR8tM6Mo/AbRW8dvMPDPJOVwTXucsH9LZl00I/vx34ctPZa6s
        S0ocTE9opiTaCdIWpJHnOxl/LpAr8Y+sztlptRvkHV3gECwdCHf+urKJDFYHtcgIEVwTZERsMEvCp
        CoDiTnzAx4M3FO74+icmRsx/ZCfbQA4VMa5xBy7em8XfeE4u9xsytKaxjuB3JwZ6LOccXz2zMBoDp
        EYBhhpbTySzPX5s95yfjurhwJ34CgEYYfv0Ain30xj7EnYNEuQQXbJqJzmv8wsI+H2ezq6QdMJYjA
        qSov13/FF3NssJekjPc5buGu;
Received: from [2a01:4f8:192:486::6:0] (port=19022 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKqDu-0003Kj-Hu
        for cifs-qa@samba.org; Tue, 22 Sep 2020 21:53:18 +0000
Received: from [::1] (port=31700 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKqDt-0032a2-UC
        for cifs-qa@samba.org; Tue, 22 Sep 2020 21:53:17 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 21:53:17 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14509-10630-ndK3e9IsI8@https.bugzilla.samba.org/>
In-Reply-To: <bug-14509-10630@https.bugzilla.samba.org/>
References: <bug-14509-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14509

--- Comment #6 from Steve French <sfrench@samba.org> ---
So to be precise:
"DIR" on Windows skips the corrupted (zero length filename) entry in the qu=
ery
directory results, but does not return an error to the user?   That could b=
e a
Windows client bug or it could be preferred behavior - there are tradeoffs.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
