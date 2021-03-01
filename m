Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A969C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 12:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D57E564E01
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 12:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhCAMzu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbhCAMzu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Mar 2021 07:55:50 -0500
X-Greylist: delayed 2030 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Mar 2021 04:55:09 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C0CC06178A
        for <linux-cifs@vger.kernel.org>; Mon,  1 Mar 2021 04:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=K+wdYBoedspkVFkiZcJ4LHwe1853tdJZQh8IG8Ir0Wk=; b=3gGEZvo0EyKOHg/GrcJLzk6Epb
        e3m3antfi9spXjZUOSgCqM80Z4+X530qAVv1bh2YAAs/9PjDBrIQtnS/Toia38Q8YdAxsBGhmW3+G
        FrL7vYDfoVI/+etzXC5t+X07NzOOPNmAIpWLAA+cdZCsXoWxVkdMT9gJsra7qyqScGuMXyd9W9oov
        UNH3E8oyZulMBBnlingPUQ9zu4w+PyGwIINCmzGwREN7kngWwQjJCODMmOl4y5tdBhXbaXEdfVVu5
        d0tLXBXdiPSWPtDvGjohhog5zOibl5/6kIhAqamWycrrQaiw0MaQQWEpblmv/MUj10w00BUsO/fdd
        CJ6/mbHEX01pTAQGPBRJojt4NezwOE22/7fAOTBsN7+kN2vO9FmN79BIVxJlwsb7efLVhAxWYTHtC
        bQo6aELcQQDAyUHs6VqIo7Z7Htjil2+tvQIz3MJ/IUa/w1y1ATvq84ZdNMVS/71g2j5L8bBzhFtlz
        NMGzGPTTIV+NTpX0PUJd1V/V;
Received: from [2a01:4f8:192:486::6:0] (port=28192 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lGhY2-0001ac-PY
        for cifs-qa@samba.org; Mon, 01 Mar 2021 12:21:14 +0000
Received: from [::1] (port=53614 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lGhY2-001Cyi-52
        for cifs-qa@samba.org; Mon, 01 Mar 2021 12:21:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14651] New: CVE-2021-20208 [SECURITY][EMBARGOED] cifs-utils:
 cifs.upcall kerberos auth leak in container
Date:   Mon, 01 Mar 2021 12:21:13 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone bug_group
Message-ID: <bug-14651-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14651

            Bug ID: 14651
           Summary: CVE-2021-20208 [SECURITY][EMBARGOED] cifs-utils:
                    cifs.upcall kerberos auth leak in container
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: ASSIGNED
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: sfrench@samba.org
          Reporter: aaptel@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---
             Group: cifsvfs-devel, samba-devel

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
