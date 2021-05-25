Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD52C2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 14:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3626142C
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 14:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhEYOQX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 10:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhEYOQX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 10:16:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48492C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 07:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=IrXp2CFpAmur8eT2/pkQ1V6di+yOyFslG0qgWCW/4aQ=; b=DP2hEmTiMxPuIVXLBi4oh71PNs
        hbj9+ccoO94m/K9gT61CkxRz4nH9Ez944hmsu7JdOn02ReaTbc992T2OC6QHdFjJx4DqlOmRa2/Tu
        jnY1J7f5Feu0ssWx6rCY3AtXzLOMw698nXAXH97JDZx7OW7MTApZbgWa/3r7IyO3ID3Z7LCuVS4Qi
        pTiJ8xcXWhNzR1/Dr2Tg44KMGf7Z4wO/5yO5FRxgwkteficUFXrAEMKhgiGC7zIHCcvWTmo1AgV5w
        pb69D5RPNg+zpKc+esSe3CzNWTb+oZt7CY4vxvIFZqBg3jtNb062DymEc1gEWqEgYXF+QA4yESeLS
        t2WtBWipUWrZN7xHT4gZyyASS6+3ZBH1SkbsY+ZLQnGZIcqkRIeLqWsC+wMmXz+CMe7ULuohgmeE0
        fWDIVC3YE3CyXiGxAgN1haxOsHVBQZ5aHy5FMoQjpSSYGYlaYTCQSROTj0+Bo9KaV4YtydYbm+NQU
        tBoiR6oiWVQNAH7ZDyqOx3M4;
Received: from [2a01:4f8:192:486::6:0] (port=55738 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llXpY-00031u-A9
        for cifs-qa@samba.org; Tue, 25 May 2021 14:14:48 +0000
Received: from [::1] (port=33622 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llXpU-008jaG-Js
        for cifs-qa@samba.org; Tue, 25 May 2021 14:14:44 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 14:14:44 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: qa_contact version product component
Message-ID: <bug-14713-10630-BeDgleW74g@https.bugzilla.samba.org/>
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

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
            Version|4.13.3                      |5.x
            Product|Samba 4.1 and newer         |CifsVFS
          Component|libsmbclient                |kernel fs

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
