Return-Path: <SRS0=IOoX=BH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46656C433EC
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 18:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2314A2070B
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 18:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uypXU1cL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbgG1SJT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgG1SJS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Jul 2020 14:09:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F42C061794
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2020 11:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ZsXRNo+I9NMwyLylQZDrvIQmL2boeT4ESwZMAYgDk7I=; b=uypXU1cLxzmPK4z3dUhvt5MX9j
        W51eASaXPM/GjcdeDAyxDoJ7QO9ldXZVviD0eXrd+To7qjB789PLBsZY2KpC1zSnTWvd0Hp3Awej4
        PFU/0EZ6bqdWdopLbDATAO9w/y37XdplHrbZYwU3M9dXPrPoHAxrsORBAecyNgKGV9538A71+yTSb
        5woiaxbTeoC0HV97RzyyAd6sYS4c9CrZicui/U71koa4C+WO60541FNp21uDhZwhqhYqc+FvF1TN6
        29TtGtnKdvrO0gl1tQpkf+F+S3wu4CrKh/v95Nm3ZpqMpTVP0Yu9DDYyEnZ8TvPfY0ocpRozxlJWv
        E4OtyPUcvU8obHt9ooCW+uu7TfGcDVKvy9rjjM5ouUAzG3ABYS27ZZi4/Mo6D4AXU2+keImg1nYXV
        0Ei0aP1SurgVTJGdlXAWdDs8d7NQESIWNHh0DOMeuPNUw1L3qSpqYF+hCY1GmAyIZeVusvD5rWmIJ
        G+QlxhTnISAbxRsy97gqELp4;
Received: from [2a01:4f8:192:486::6:0] (port=46540 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k0U2N-0000L6-Sn
        for cifs-qa@samba.org; Tue, 28 Jul 2020 18:09:16 +0000
Received: from [::1] (port=32496 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k0U2N-007fLn-1x
        for cifs-qa@samba.org; Tue, 28 Jul 2020 18:09:15 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13470] DFS mounted shares do not allow to go subdirectories
Date:   Tue, 28 Jul 2020 18:09:14 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sergey_ilinykh@epam.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13470-10630-CUJs0BEogP@https.bugzilla.samba.org/>
In-Reply-To: <bug-13470-10630@https.bugzilla.samba.org/>
References: <bug-13470-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13470

--- Comment #2 from Sergey <sergey_ilinykh@epam.com> ---
Hi Aur=C3=A9lien Aptel,

Following my scenario above I couldn't reproduce it anymore. Seems to work.

btw I have a couple of questions unrelated to this issue:
1. Is it possible to force smbclient/cifs mount to try all nameservers from
/etc/resolv.conf?=20
2. Is it possible to mount dfs root? In my case it's //epam.com

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
