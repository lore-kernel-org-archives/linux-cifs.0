Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6167EB64DA
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jul 2023 06:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjGVGvS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jul 2023 02:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGVGvR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jul 2023 02:51:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE94270B
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 23:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=j/cm+ZR0oGASc65FGJInIEb2UAaOGwqalZBjGZlbRw0=; b=TAvUYfcnNrmw226EbNMvhaDANU
        48zJB7fy4+kpvHflfJ8Y5H2qGOo3X8Yh2Kjmg46+XpUDVWby1znspt3i1H/1dFJ6gumVC/vjQiuP6
        Zj6A7+3PYhf85o5EhCUzlqBUz0+l1MWccZwNios8V9wRsmZJdfm1ctPIzbInt19bL2uVfON6W+l0d
        7Qpl1t1yRrKvDHI2XnwVWQ8PEp71/ijPjVMw5tCD4+fCVZFib5EjOpBx6S2H751pnvqK2iHJ2ZK86
        orbTVzi05eEa7e8Z23EORYeg3qkMUXe3wVfHejAw0u4cXJad97rOR4p0Cj6PJYKpeIY/qg5jWPoQ2
        KhOcdWxLushO3V1vCHJeA6l8qKmehB2P/KLjvkDCRnd8rlwBLhblh2z4yvBsPsfO9F3IkrlQMCnal
        H4J+AtYENZKVJlyrFWUCR2CW0KoycQY+jNFkVa+88TAIzyxXTQwIBeeL/RJvzmo79UnhGqRhvEToU
        +zn/D/lPd0tYTSyj56yhpqL1;
Received: from [2a01:4f8:192:486::6:0] (port=26088 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qN6SP-003TXR-0G
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 06:51:13 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qN6SO-001fEI-FP
        for cifs-qa@samba.org;
        Sat, 22 Jul 2023 06:51:12 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Sat, 22 Jul 2023 06:51:09 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: rpenny@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15428-10630-eEiwnKQmlt@https.bugzilla.samba.org/>
In-Reply-To: <bug-15428-10630@https.bugzilla.samba.org/>
References: <bug-15428-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15428

--- Comment #2 from Rowland Penny <rpenny@samba.org> ---
You will either need to patch your version of Samba or wait until Clear OS
provides new packages that use the the latest Samba version 4.18.5 , releas=
ed
for security purposes, the patch is also in that release.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
