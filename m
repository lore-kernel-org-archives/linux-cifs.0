Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C9DC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 07:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1721164F01
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 07:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCRHYm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 03:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCRHYK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 03:24:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577B7C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 00:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=yM7H0ESbl80aNeiTcgrZ2sN2FYU6bqQ2HcEkrpW144U=; b=hhtChp9UoB3Jzh36aKPTv13fXX
        p98E8u+tqOfdKYHFHRn4bFN1E2zyRQyx1XnXP8LVJNUlXlvw8RsJBcCPxuX2fORwz3MG1gnSFc8kh
        dkFV/tcIN59JFL8BALeaiocvVfhlfDMDMmdvaWU1k9Gtzsvw8auglCwO8CIC+HBnWAhJ9O94wyTut
        k2apLv+W156yxZI6yj9POvlFcLNjmGEUG/Qh0rAq03+jPXZdMOGnUq/XvLYHb/qPcf/F7I9VLPWJN
        NrmKHIvOafzFYHYB9GZjUZ0tAKf0VWcFn8Uf+94imgHJ+fSnbIRVhgFcNxyI7M5/dIVtwq7ODpDeJ
        oOdhgdGmO7PZkvNbzjFpPDI2ZZ5h1lseRHUAXxriyuYMNtYJjmTajFgimC4e8bLtd8LI4ZyiHxWnH
        Z5l5TuI2pDs8uGfyPaXi30M629vz506aZVPhtWCRCR8NiXU2/vfCf96ytXR5tx9MiRK6RMRtrGpKD
        na48lsgu6wsZTFzXGcxBMBQH;
Received: from [2a01:4f8:192:486::6:0] (port=38178 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMn0j-0005W3-9p
        for cifs-qa@samba.org; Thu, 18 Mar 2021 07:24:01 +0000
Received: from [::1] (port=63596 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lMn0i-002iWF-PS
        for cifs-qa@samba.org; Thu, 18 Mar 2021 07:24:00 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14476] Cannot set timestamp of Minshall-French symlinks from a
 CIFS mount
Date:   Thu, 18 Mar 2021 07:23:59 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: version
Message-ID: <bug-14476-10630-DvVDRLIoEM@https.bugzilla.samba.org/>
In-Reply-To: <bug-14476-10630@https.bugzilla.samba.org/>
References: <bug-14476-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14476

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Version|3.x                         |5.x

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
