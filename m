Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63126C2B9F4
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 11:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4610E61C69
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 11:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhF1MBb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Jun 2021 08:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhF1MB3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Jun 2021 08:01:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7387C061574
        for <linux-cifs@vger.kernel.org>; Mon, 28 Jun 2021 04:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Mm+9/aMiH6I9pFdWXx6x3v335ZXOsQGlo16CQkI75dw=; b=WN/P9lW+tmlavgWf9gsGkfEbA5
        HxHdJNJdtRceW2+eLDkv0/EyfHZL5VLT/8mov00HkDJ8IkvRbQvYYrUt+z9RUfZj1B6svOfEU5KEl
        Aa2cBeiYJxpAiMfhqbuk+aYPAxtQLZYHGXOaST4Ve/azwiNJpeu/QS6K7onejkuSYTzWKkdpg67Ql
        lxlFZKsM7L6c7eG0oaOKdF9HSJcd4fJE06do4W7/lF7CcF83f2o0YiWOSb1SY4lXRe4WieKxkBV0X
        iKrOCezOrDNjj1IrN2DNjSsSMOKjmtW5k2mR1VIT592mUkVx6LQmJ8N2xfLR8rEbcRFWQZOKML+yM
        xoNYfUkZ9bZZ4Lrj/abuXu2XdbIakAnmEhyF5OIDdDUF9ViHBBBjKtUGmI40XKoZj/zw4sWISn3ox
        gCQ51lW9CVPoJGWWk+/KIRos6SeARJgOVtOiAnPLUt1Ol7y+ithVAGgNlCSz9rQdLjSZj9Tx9zFRy
        26w5n/y69JTMPKJhMQb3Fq27;
Received: from [2a01:4f8:192:486::6:0] (port=63946 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lxpum-0001F4-3U
        for cifs-qa@samba.org; Mon, 28 Jun 2021 11:59:00 +0000
Received: from [::1] (port=24184 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lxpul-002guV-Nf
        for cifs-qa@samba.org; Mon, 28 Jun 2021 11:58:59 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9281] cifs kernel client not reporting quotas
Date:   Mon, 28 Jun 2021 11:58:55 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: dep_changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-9281-10630-7TkH826X0g@https.bugzilla.samba.org/>
In-Reply-To: <bug-9281-10630@https.bugzilla.samba.org/>
References: <bug-9281-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9281
Bug 9281 depends on bug 5395, which changed state.

Bug 5395 Summary: Unix Extensions + ext3 quotas + df
https://bugzilla.samba.org/show_bug.cgi?id=3D5395

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |WORKSFORME

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
