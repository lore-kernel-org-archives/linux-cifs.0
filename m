Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8C3C433E3
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9198D20825
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FPtfFnuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgGWMBq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgGWMBq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 08:01:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A5EC0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 05:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=4gGY8dJGANf9HbgLyLXYNedRizBdOQP++Bpyme51PJ0=; b=FPtfFnuOYZNGYVR+3JZBpUQbaw
        CwYMoUAHSnj4Id6HhuwX9Ez4wb4ZH5hJrsFC9G0O2TN6m0z9POhllmd62GQL8xjMS+sibN6F8I5UU
        3Q842QsdE5Fj5vh+LsDF6ZiO8p5MBhUM2RExEvqsBnsYFpEPlWkJALmRbgI05/QowdWjN1/yxgahU
        8I+VhjMYU1XYnIwLtCwzHiNkltmvI5HWLdXo2rObzB6jVLqB9Cnl+JhECFyIsK73P27H17hgYyg50
        S++20j3P3V0H3TSAa9mLNB28zFQofFcUYKVlDWI1R7yiD6fhLjz/dWw5T0uf8lDCsIO92ny3HuEH1
        owI8Es7IO+Wf7Ih9ULki3ho2WW40rYkXhD5aAYIIlgfKUnLdAuLIi06jyU7BQJ8UfG/So1mW6f0d+
        Hci5238ELnHb5oihZzoerzAx8bRi8MyjEgakpAGdiwyOiAQEH31sYruIPp61flEQjhsUGpdSY4+Da
        uBWdP3cclXKevEi8ZZFkuRi4;
Received: from [2a01:4f8:192:486::6:0] (port=43198 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyZux-0003rk-MQ
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:01:43 +0000
Received: from [::1] (port=29150 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyZux-00714O-9c
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:01:43 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13107] Missing directories with smbv2: with smbv1, they show up
Date:   Thu, 23 Jul 2020 12:01:41 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-13107-10630-EO4gJMNKz0@https.bugzilla.samba.org/>
In-Reply-To: <bug-13107-10630@https.bugzilla.samba.org/>
References: <bug-13107-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13107

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |zlurps@gmail.com

--- Comment #10 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
*** Bug 9635 has been marked as a duplicate of this bug. ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
