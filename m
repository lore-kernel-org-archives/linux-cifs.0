Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4A9C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347514AbiCUMoV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347079AbiCUMoU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:44:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286EB158D85
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=IEUy4SvQ5/pi3lGUEU9Dz386xjfNBjZucv7cz5faDWw=; b=21JQcaQoz9t3mI7kAJ6C1DuW5h
        x+HI+nHcHl75OHj9pEP7y9OrhxhDLi89zRol/yfl+r6Lq+rVGippzLTBGTqc1L+lCwHACjWZEABAN
        nmiQSMm/DIR8nS6i41FpFVxGyXppRA3bg1AGM+1+DLMQCU2j7dfiRhvT5wE0CNkE4Ur/fwWbXj0sh
        P4Y7XQnBpT85/q2moz3HI9YjJgsWRjcILLf3hWcYQCJNxY324zEWeEnhEQKsD6Reqp9Fkk1dWEc4w
        tmG55B2f18sfhNwEh8uyPiRl0Ar2yO+a5xI7hJa+mE8c04OAHSGyQGllyQ8Ywv44BMTggPoO7MTUV
        s7KozLLA8kaBh3h+lxdNM4q95gzwv9wIv7sFwi8Ex6cciS4TjfqPPlKC443Qx95KxAVubK5ukC92u
        h8RHiOVlnpYj1Y+Aa9jrYhIiWIhLLbdOJZTKC2ti302U4tX+9U1oytL+nJkL4N4Iah5eBYoYJcdO1
        RgP1Ji1qL+ynrlS6xX6qyeKR;
Received: from [2a01:4f8:192:486::6:0] (port=56568 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWHN6-002dGX-JQ
        for cifs-qa@samba.org; Mon, 21 Mar 2022 12:42:52 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWHN5-001djV-UC
        for cifs-qa@samba.org; Mon, 21 Mar 2022 12:42:52 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15026] Partial arbitrary file read via mount.cifs
Date:   Mon, 21 Mar 2022 12:42:50 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ddiss@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: longdescs.isprivate
Message-ID: <bug-15026-10630-n79fkhUhms@https.bugzilla.samba.org/>
In-Reply-To: <bug-15026-10630@https.bugzilla.samba.org/>
References: <bug-15026-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15026

David Disseldorp <ddiss@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
      Comment #1 is|1                           |0
            private|                            |

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
