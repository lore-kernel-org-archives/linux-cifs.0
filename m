Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4600C43461
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 06:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2804320829
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 06:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgIOGtD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgIOGtC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Sep 2020 02:49:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA0C06174A
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2020 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ZGmWz/TKCClrwKN18abG+vk9a3Ed3xewdT/JBFFGUKA=; b=mUpzvp07/Bn7uWJ/u9J3WAPvip
        a1vI+ChgmKZQEYMiNDgZt4Kh3XvHqJ/ljlRaAz/vKj+MQ2N+iKXMUo/fltHiwO/E9nnFTE1wfkiLb
        a3Fwiqb2lWCyqlspv4tLT1tx2X6YujZVsz7cY46OZq1TJpemhWrA0gZZhatB8dWx4I0PmYB+JdSrX
        ofpPn9llOqjy8t1uYiy0BMd2xX3MCuR55tQpDXkHgCa8zbnRYtxocjYEzQ00Md4tykSwGUjZEYQGb
        PzacWt4vzlPSY1f9vy/uwObyfX+KjaJ2ixTOYNszftL9m4fI+ETblG8U1mCIXwCeDHgp2Lf9Gix2/
        HAjnA5w2X0fiodCiEj7inmIzGZhvloq/aUtMO/h9RUrg7cJd0MJPhl+kv522TaJSCYpUqZDRVPax/
        0JrKPi4Sgr0vLQhENwnmt2CXPybAjHHqo9GXV52TgSirq5ZDKSwKjPIuBOIJcWh7xsL9qQP/fkgXw
        gXy66Wpf+TZEoNBeG0Sfnb2N;
Received: from [2a01:4f8:192:486::6:0] (port=60872 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kI4lt-0005Sw-Vr
        for cifs-qa@samba.org; Tue, 15 Sep 2020 06:48:58 +0000
Received: from [::1] (port=26012 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kI4lb-002KfG-TF
        for cifs-qa@samba.org; Tue, 15 Sep 2020 06:48:40 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14493] Conventional tools for managing ACLs can mislead the
 user
Date:   Tue, 15 Sep 2020 06:48:38 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nspmangalore@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14493-10630-PLOKYVFzJ8@https.bugzilla.samba.org/>
In-Reply-To: <bug-14493-10630@https.bugzilla.samba.org/>
References: <bug-14493-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14493

--- Comment #1 from Shyam Prasad N <nspmangalore@gmail.com> ---
Hi Micah,
If you're expecting translation of unix perm bits to ACLs, you need to use =
the
"cifsacl" mount option. Can you try that and see if it helps for you?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
