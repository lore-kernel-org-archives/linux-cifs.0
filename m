Return-Path: <SRS0=Z9xR=A3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AC3C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 02:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563A42076C
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 02:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Q/jYdPky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGPCuf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jul 2020 22:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgGPCuf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jul 2020 22:50:35 -0400
X-Greylist: delayed 2101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Jul 2020 19:50:35 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2394BC061755
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2020 19:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=KU5gfwd1mOi+mYHsGZlB/3HXIY5DD454pDU+wM2bdwI=; b=Q/jYdPkyH61b8yi51BXVNLWgJg
        Afcw6i3wNkEBeaXDkzYfmhYXQ/FXsLMwOAzReytZAiomp90uy5496jeNE9jJuRi8tES7yPFSS87Pz
        azqL09zCJol4ti1MWU3lg86XbiGEomvybLiokvID93ZavHKP1sFceXrl6VlD7BKpoTM/hAH4rRG4f
        lCq/sV1FekjL/pic27JAkoMM/k6uIKYKa2kF/n25j+HW/1Th1m06Dv0ftzQfrFqshhoJJ5lZL4+xT
        0XQmH9J1NDTzGJ6egppVLPNTEjL2y1HBpqQ4ewP9oD8T+K881gnZ2SzHQJER8zC/TIxzHd1xWTg0I
        lEraYdbfw/NTtGIk+9pMWfXcaidkdMQ4yMJptoOyluhX/PdFkaH1PZ17bE5gYbhzn7IACr6E1VPVY
        8IP0mzLFJYFr6PzYWsEpKTgTqX7LS6smpph+Ws2c64z0JFB6QaCAk/6WKafkPw8IKP2cM2vnVomdX
        GfWMBwz2u67CiMdDKU0xyNc7;
Received: from [2a01:4f8:192:486::6:0] (port=40066 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jvtQp-0002Sp-Nz
        for cifs-qa@samba.org; Thu, 16 Jul 2020 02:15:32 +0000
Received: from [::1] (port=26020 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jvtQm-006NbL-Bs
        for cifs-qa@samba.org; Thu, 16 Jul 2020 02:15:28 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 7699] Linux client slow against samba server compared to
 Windows 7
Date:   Thu, 16 Jul 2020 02:15:27 +0000
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
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-7699-10630-Kxh5vuBrHX@https.bugzilla.samba.org/>
In-Reply-To: <bug-7699-10630@https.bugzilla.samba.org/>
References: <bug-7699-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D7699

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |FIXED

--- Comment #13 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
with recent kernels and smb3 the performance is much better

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
