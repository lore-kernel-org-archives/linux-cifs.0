Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE39C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 14:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794C622EBF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 14:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbhAGOrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 09:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbhAGOrP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 09:47:15 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0319BC0612F4
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 06:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=lmreDrnOFHsgnUPi6z262sw/V8MEHztbVMsNCg2n8rA=; b=teu1O7bsGkOVHcSvF4hRn73ktr
        zRVpK8itO1sbyYJPZ4i5VhaZt6jlDUoSoOQDM/jo4oNuOzMjMy/jlMt+MnfvFa+DqQIZTIkT3KUKf
        E5IjEIggN1nJvaviQVTXkfueTkqWqv55fEqxED+/vqvfkUKU5UKiqaUP1LjWOURupTHIm7vBjWD05
        Kb7JGIBLtn1q9lLm37/klLDxfE7V9yAgZ7WgO0vsIbF8pm/ZTSVR/IVJ5arl/qrumQDp7RstIwNka
        DVDknyRaegyBgkN/V4+qX2kc6+kkl4V91lo+e8zqR/Ccv+wofyPwi8qviTSzV7cp9VvxQFy2Mx5q9
        k0TYShGwjyruhd+eaiydOlIjeoh0yWBBrQsuffVGlhf9pSHGHKAE8M14ge+R6r3Z4MPIStJucrdD+
        KEBHWiKokG+GAGEZaa+DyzPE3k+KLgG30wJ48FAWy05uLYOW2ChD9/qtZZ5DuFk5K/XwKZ5YjRXj2
        1N2veHFBhmR9oNgrY4GhDwxw;
Received: from [2a01:4f8:192:486::6:0] (port=58016 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxWYZ-0000HJ-Sd
        for cifs-qa@samba.org; Thu, 07 Jan 2021 14:46:32 +0000
Received: from [::1] (port=27452 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxWYY-002xmj-Nj
        for cifs-qa@samba.org; Thu, 07 Jan 2021 14:46:30 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Thu, 07 Jan 2021 14:46:29 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-13712-10630-Rt1EnjSfgU@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |DUPLICATE
             Status|NEW                         |RESOLVED

--- Comment #2 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
resolving this as a dup of bug 11206 - with kernel 5.8 this is working fine=
. If
the old kernel od CentOS/RHEL doesn't have the fix you need to file a bug
report in their bug tracker.

*** This bug has been marked as a duplicate of bug 11206 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
