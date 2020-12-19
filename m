Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7499C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Dec 2020 15:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8C722D74
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Dec 2020 15:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgLSPyA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Dec 2020 10:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgLSPx7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Dec 2020 10:53:59 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D09C0613CF
        for <linux-cifs@vger.kernel.org>; Sat, 19 Dec 2020 07:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=/eBjVgyPM3VUPpwVR5qajNTLQi5jDUPbasjeQZwdWVs=; b=JsSeFFRwRNTFK2Y+UiRAEg7oSo
        M8nv5iz4JpCcEa6TrqgPe3lyPibU4c0nzJbXyStzdbmxAqhPwugtFMsuAJNma9pp/U6/Xx78cnMFH
        N97AljxRuhAD4Pqvcu2D3lP+SmsRCdJwpdQMluz6D7pW5rGTWNItQiM3fiW2iVxJMvxHs74Lm7mHt
        nW1b59K39y2FztyUfsx2tttCrHNqiAD9tH1mtmVU+CO36B7LTlU1bwEWchhoz7rXGKLoJVIzJ4JoJ
        Z5kilxH841uHoflsRumwvIfw3AqIe8/Tp67ctNJuoLdiSWT7OJWKkBs//C3VfTFf3lwW6bqudnPnf
        Z5Y285Stu02FJIC6bieNmMf3X7DGD80gpnqHZkrLNutbGnkzwbYWBlZ7YZOf2/sV2vUj+IwouruUy
        roJHsWqS8HBB3gYpsDKzgXmKZ8qYyV8fCo2FyS5xnOI2HElDDJ+YfiyYM+bNAacX9tzV31KUoei0R
        qYE1PmerlcRcAgGdD7AeR6uX;
Received: from [2a01:4f8:192:486::6:0] (port=51366 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kqeXi-0004kW-Vb
        for cifs-qa@samba.org; Sat, 19 Dec 2020 15:53:15 +0000
Received: from [::1] (port=20802 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kqeXi-001IUa-CI
        for cifs-qa@samba.org; Sat, 19 Dec 2020 15:53:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9364] BUG: unable to handle kernel NULL pointer dereference at
 (null); RIP: 0010:[<0000000000000000>] [< (null)>] (null)
Date:   Sat, 19 Dec 2020 15:53:13 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WORKSFORME
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-9364-10630-0YUvL0Z8wZ@https.bugzilla.samba.org/>
In-Reply-To: <bug-9364-10630@https.bugzilla.samba.org/>
References: <bug-9364-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9364

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |WORKSFORME

--- Comment #1 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
Hello Steve - I assume this 8 year old bug is probably fixed by now?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
