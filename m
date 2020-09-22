Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385BAC2D0E2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 21:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CE82371F
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 21:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVV0S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 17:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIVV0S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 17:26:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083BEC061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 14:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=DA6pTWiQ9DVxT349jKhM33TI0P3cul9W3kWuaku74Zw=; b=nG3EB0H0A4sDU1ZuDQ7BUxDtkm
        PX1ewIfsfupvSn3Mkxf9pRsyQWs/kQqecWnOhnt7/xheyhjGyEPKF53z38tIlvhNkdH8jv7BehoQP
        WyJPytqCeyMKDg8gEQMeDyia65Lo981aIBeiESi93g2VeVD26qStrJaV9qjKHWHUSlVA4jI9KQJKV
        ms2hUHNw+aQb7mjyX3x2UFDVOWJuE7LUoPy+2eFiP5LzMCfQy/YFwT8OsMGYNlLsx3LkjeRNs81On
        zxoz0gTkMMv8XqwBMOg1m3rbzFl962sppqKhrHrHAJMWJw95mhfSTEYZpk1iGpdhImy+8rwJxx1HW
        sk5fGpORE6TCTWDn+yE2qAMcOkcgftNheB/avreOHaw5DJf20X2pphrm3arowoEVIkUzHoalTifkV
        s2TjswfXiZ10nww0n/EP1YsCEQfZZhSNF1g9pIxaI13xIYhwrzrrJFN2h7kmVj4PW54V1a3HCz2Tx
        ZofYq3Z6ypsELKcW7CMESTik;
Received: from [2a01:4f8:192:486::6:0] (port=19004 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKpni-00038H-JS
        for cifs-qa@samba.org; Tue, 22 Sep 2020 21:26:14 +0000
Received: from [::1] (port=31682 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKpnX-0032Yq-Os
        for cifs-qa@samba.org; Tue, 22 Sep 2020 21:26:03 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 21:26:03 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14509-10630-UislFxlEmJ@https.bugzilla.samba.org/>
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

--- Comment #5 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
https://docs.microsoft.com/de-de/openspecs/windows_protocols/ms-fscc/2917da=
5c-253c-4c0e-aaf6-9dddc37d2e6e

2.1.5.2 Filename
 A filename MUST be at least one character but no more than 255 characters =
in
length.

Also if Windows 10 ignores such an illegal file with 0 character filename
length, I'm not sure if this is better than returning an I/O error in that
case. I tend to say, the I/O error is the better choice. You should get the
people doing that samba port to fix it.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
