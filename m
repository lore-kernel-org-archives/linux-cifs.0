Return-Path: <SRS0=IOoX=BH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978DEC433E1
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 19:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7686A20656
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 19:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3eEMfapR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732842AbgG1Teo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jul 2020 15:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729646AbgG1Ten (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Jul 2020 15:34:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C5DC061794
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2020 12:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=LvT1mIp8tK68V9x/tA0nC6FSJm3nEB1/KdYrhKD0tlA=; b=3eEMfapRAUJm8z9YZ2JF5uOOCS
        fHSvGQTIVv1NIjze7A4BpyfbPrI6kCr5d/nOmdpujAd1PmrnqPNnzJNwQiQJYvUO3JTfauuZaETQ3
        POCyhlrcrnplZVK9K6TWESTnZ5Ksc0/DcJTfmsA3dzPYWDqAtO1wGFWtaGvK8cz5QIXBifXYmRNjn
        4Wbvw8vp6FedoiT60u9w8Dw6Kpz1ClnNXXUJUjmhw7hLSda1i+MRiXqAmuxo0jIctxTja0F4IvVix
        ztdZFHFlnotzTyGq1TOhFootsVJHqTEhkOz8YSzcbvEUPFVXxVA7cyNs10EREvhT8DRAtCk4uzDjN
        jFI3SGzC0WMIs4YIszadregNYM0wRKwClQNC60RKTAEJPBwlIwm7DhuUFKUy5Sqm1NbKAt/EYopCX
        G20sWwB2IRi1ixsngsL3raTJJorgwtSNtOGTC2CQ59O7QCcpadiWAMkyF8ItHmsoB2o8gDoUvXQYU
        w9IdTbKFO4qKuDjlTEh7zYPE;
Received: from [2a01:4f8:192:486::6:0] (port=46558 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k0VN3-0000uy-89
        for cifs-qa@samba.org; Tue, 28 Jul 2020 19:34:41 +0000
Received: from [::1] (port=32516 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k0VN2-007fSA-Qt
        for cifs-qa@samba.org; Tue, 28 Jul 2020 19:34:40 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13470] DFS mounted shares do not allow to go subdirectories
Date:   Tue, 28 Jul 2020 19:34:40 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13470-10630-B55hyfQKU4@https.bugzilla.samba.org/>
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

--- Comment #3 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Regarding 1)

You can put multiple nameservers in /etc/resolv.conf but that might not have
the effect you want.

If you have 2 nameserver A and B, it will try to resolve by contacting A fi=
rst.
But if A is *up* and replies that the the domain cannot be found it will st=
op
there.
The nameserver B will only be tried if A is down, not if A replies "doesn't
exist".

What I would suggest you do is setup dnsmasq. It's a tiny dns server proxy
daemon.

You can tell it to forward all domain request for epam.com and any subdomain
(e.g. a.epam.com, a.b.c.epam.com etc) to nameserver A, and forward all the
other request to nameserver B.

To use it, install dnsmasq, and put this in the config file (usually
/etc/dnsmasq.conf)

    # forward *.epam.com requests to 10.0.0.1
    server=3D/epam.com/10.0.0.1
    # forward the rest to 8.8.8.8
    server=3D/#/8.8.8.8

You will also need to set your system dns server to point to the local dnsm=
asq.
This can be done by putting 127.0.0.1 in /etc/resolv.conf (and only one). T=
here
might be cleaner ways to do this depending on your distro as resolv.conf mi=
ght
be overwritten by the system each time you connect to some Wifi network for
example.

----

Alternatively, if setting up dnsmasq is too much and you don't mind hardcod=
ing
the IP of each host used in the DFS namespace, you can simply list them in
/etc/hosts

Regarding 2)

It should be possible to mount the dfs root yes. Once you have DNS working =
it
should all be ok, assuming your kernel is recent enough.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
