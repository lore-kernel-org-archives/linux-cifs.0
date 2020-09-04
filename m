Return-Path: <SRS0=kYcK=CN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2406C433E2
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Sep 2020 11:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DCB2074D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Sep 2020 11:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ETN4fu+u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgIDLDC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729882AbgIDLCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Sep 2020 07:02:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FA3C061244
        for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2020 04:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=JQfh/GAUWv8gtWEy66jnpHN0n0QreRzVwIWzPFOAMbE=; b=ETN4fu+uKAyCEM2BsYhjSeYugy
        tgdF53X8VtJ4BWzDgXEsGENsufQMEMlIKvdQLTXNhNOoS2w2FZNrwRXPn9uRV1EA2vGvu/ucgrQJR
        fNNl7AOGdkX573vhn2G6T+IveHryeilrICFJRfT5Z9kzr4ntUGViFBcgWNxYPd2dLPBlkdyvga6uU
        3IvSs536imFsesXbZbqNoGOg+kcadGY/nl35kLydOyEq1CHFYSQ3XYbuOMQKBusHDOZYXUZZoolxt
        YizAqA2nanw3GftVJF1qMGmOlZrmNL+K6+h08IYNz9T/FpYe6pq+QdEbAKndaxQ17dFYnlghKfc5D
        1RuHxFDdZFOHKr09y2+sMrr9iout36g86lGxIgrjpyegl/r4cm/psqcNzKChccCebQLwm4PSBJ/Hy
        N9g5lS802/wBW+laOeZBcw36hw3Zq46sOEolC7UoNwth+KJaeZ7UXsksBC3x7VgwpvYyJ0D/IKekm
        N08hmp8WMEKfzWU7julZtDAK;
Received: from [2a01:4f8:192:486::6:0] (port=54950 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kE9U2-00039a-Qa
        for cifs-qa@samba.org; Fri, 04 Sep 2020 11:02:18 +0000
Received: from [::1] (port=20090 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kE9U2-001NME-G0
        for cifs-qa@samba.org; Fri, 04 Sep 2020 11:02:18 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14476] Cannot set timestamp of Minshall-French symlinks from a
 CIFS mount
Date:   Fri, 04 Sep 2020 11:02:17 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: qa_contact assigned_to component version product
Message-ID: <bug-14476-10630-ZYxfuKCF4N@https.bugzilla.samba.org/>
In-Reply-To: <bug-14476-10630@https.bugzilla.samba.org/>
References: <bug-14476-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14476

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
           Assignee|samba-qa@samba.org          |sfrench@samba.org
          Component|Other                       |kernel fs
            Version|4.12.2                      |3.x
            Product|Samba 4.1 and newer         |CifsVFS

--- Comment #1 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
moving this to the cifsvfs product because the Minshall-French symlink are a
client-only thing.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
