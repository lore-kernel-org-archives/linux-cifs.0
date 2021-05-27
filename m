Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D330DC4707F
	for <linux-cifs@archiver.kernel.org>; Thu, 27 May 2021 17:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE30C6128B
	for <linux-cifs@archiver.kernel.org>; Thu, 27 May 2021 17:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhE0RfQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 May 2021 13:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhE0RfP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 May 2021 13:35:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEBEC061574
        for <linux-cifs@vger.kernel.org>; Thu, 27 May 2021 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=GMlcKAEpYJmrrvhtXn5rJzK29HpRTeVoaDT4n2GIZUo=; b=Bacngo1dxFnBFyGF5GOwa0zu7y
        JUB8e2xwLdS396yAf1hNlOZaxk4okBtOYdFseewx5VpGYsQFHzgMrCmMjTBLqYQaOctcUXjDHCkWM
        VkmuPJpIILKTzX8ExQ7Cn8HoHMQlT8OuF1Cp26kB7XcnCG5YZgp7H9OA1OVHSc2NSGmVg35wwnb8w
        ddyM8NsBFyFo9GShPFa0xG1uBImq/hv5e7RlTdYOzFnOutTsdklQn313033oAUqmLFr53gTu/5fWD
        aBRsAqgLhtoB8MuTIWYGBHpuhw0TeL3WVJ343fetklplOvX9OC812Hpv1RoEIrp3OhJToFU1B5Cyj
        R1eA/PIjjqoYsSVi+d08V4oY9HxXhivNROLBg5OAYgpr36oyOrEVmbKc0OuSIBOW1FTkUie5q3pOw
        QSWS6vL08N31J5xD18uxCE0W81bJYuJzrKAzgYsPCyvSzzEo4O9yPS3hI2r3BK4gu7jJZCWoi31tE
        /VpTRbnBdUpm00NjxiiAgx4B;
Received: from [2a01:4f8:192:486::6:0] (port=56658 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lmJt1-0006eF-3D
        for cifs-qa@samba.org; Thu, 27 May 2021 17:33:35 +0000
Received: from [::1] (port=34544 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lmJt0-008uHy-8a
        for cifs-qa@samba.org; Thu, 27 May 2021 17:33:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Thu, 27 May 2021 17:33:33 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-elT4Jp3Iez@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #35 from Richard Flint <richard.flint@gmail.com> ---
Thanks for your help it - does seem that you've narrowed down the cause a
little. Is it still required for me to dump those keys?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
