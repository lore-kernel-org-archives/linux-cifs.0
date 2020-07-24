Return-Path: <SRS0=+hUn=BD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57391C433EC
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jul 2020 14:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 036AF206D8
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jul 2020 14:52:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kBxSMzU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgGXOwh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jul 2020 10:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgGXOwh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jul 2020 10:52:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C35FC0619D3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2020 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=r9Tz1umMd6hmXDCuN4nNQUXEyC5KtDhxKS5JIxMsPWU=; b=kBxSMzU/B+Cw6Tgq/KuvCnzHzQ
        iJp2XgwS6tyjQyDqFqhwmA2rxVUkzh7LnZPP5C57fGeOkrDtCxEKRHvHq5UdjKbYgS5YKBVhbZR+7
        7HRTfs/sllSHr7wjqrE6PpuHcqwjJdtjN7alRYCqf9wZVxSDLOD/VmzeDVHBwtrsMtxrreTci7+YS
        CkAY0fdCyXxmiAws9+bCuPvVJdHCz2ZtGSK5wjUX5tak1kxOrCpR0Vd97EP0IsyQFtPrqUmBx3Adz
        jDMZctIzoQw9hsEzD/sMlquoLym60XRpiNkRWaqTfvuQYprdvnp3AAsXq+I4VeCpCdRRD/FjmgNsf
        AK4dv0IG3QSmwwobiIDKVtHwX7ccstrVNGDF15DMGfCADnYpBjtBvLylgtmNQ23Bub5pdJbXr5IJo
        laZYf5Bwnwzac9VGgkdZvY0bRd/N5KMvUvl3fr1EdbZCwPJzU2LO2kz+qxpRExzNLjCxzHf+DMo4f
        eTlz/udPZbXUgXwNMcI1caow;
Received: from [2a01:4f8:192:486::6:0] (port=43734 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyz3p-0001L7-RP
        for cifs-qa@samba.org; Fri, 24 Jul 2020 14:52:33 +0000
Received: from [::1] (port=29680 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyz3k-007KDA-7l
        for cifs-qa@samba.org; Fri, 24 Jul 2020 14:52:28 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Fri, 24 Jul 2020 14:52:26 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-14442-10630-A940hTDfdp@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Shell command injection     |CVE-2020-14342: Shell
                   |vulnerability in mount.cifs |command injection
                   |                            |vulnerability in mount.cifs

--- Comment #10 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
This bug was assigned CVE-2020-14342.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
