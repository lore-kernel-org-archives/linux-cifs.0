Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D816C47084
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB7F61404
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEYS2J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 14:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbhEYS2J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 14:28:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA037C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=KE3PkKGH/pQY9Cd72yhtqUsq7MkPAO4Hk6PR10s2Ku8=; b=FuA84R6Q6PA0sA6yBXcwFmO50t
        oDbGLOfwD66Zkd8BeErZhKsfqQCVFhrZPsrJd376sL6Re91bwC1AR5nHaRlzsEhrVK8WG7m6b6AaN
        kSm63d//0XWaafDKJ3mKMXQfUvLvcOiIGnhVb9RI70Xk+1kqSd6VydMPhuKo71X3QBfBi2rriFXqX
        zN0wbViIOyG7drhQA3PJWg3R0pPNvFBVskgPDW3A45kW9MASXYfJ7MhywytuMf9SERHTZy6Srh6y+
        oOOZ+x8M9lkeIXa5Ccuf3tcq2NzQGTX2Py7ht27npHRCQDaT7ZT8MY5aqiZKZ1tmFZ/845frv0COD
        qVTasXJD+T/epI/nz36VYERos66NPV95SoPSnioGpFSskfkNjBq/lhtXWKTChMtr+ajsuVXOUahqG
        4NS/+svgdguCf9Twqz3m71x9SIsidGmh/nigpsfhqMiJ9nI73xcC0ZY5AB58mVtQUFCeZ0J+wpR8P
        lovio5gl1q4Ee7ofzXhHSCHd;
Received: from [2a01:4f8:192:486::6:0] (port=55906 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llblE-0006J6-R6
        for cifs-qa@samba.org; Tue, 25 May 2021 18:26:36 +0000
Received: from [::1] (port=33790 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llblE-008jt9-AX
        for cifs-qa@samba.org; Tue, 25 May 2021 18:26:36 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 18:26:35 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-TRNs5vXyRL@https.bugzilla.samba.org/>
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

--- Comment #8 from Steve French <sfrench@samba.org> ---
Two additional questions:
1) As long as you are running a reasonably recent kernel or distro update (=
5.0
or later kernel should be fine, and current RHEL/CentOS/Oracle client ie
RHEL/CentOS/Oracle 8.4 or 8.3 should be fine as well since Redhat backports
many fixes to their older kernel) can you try not specifying "vers=3D" at a=
ll and
see what it negotiates with the server?  (should be 3.1.1 - you can see in
/proc/fs/cifs/DebugData)

2) Does mounting with "vers=3D2.1" work?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
