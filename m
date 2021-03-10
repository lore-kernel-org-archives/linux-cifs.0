Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761DAC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 20:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E22264DFD
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 20:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhCJUHn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhCJUHd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Mar 2021 15:07:33 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E14AC061574
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 12:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=WZgSmZDtt0gVJ5xspZl10g0HBuOX+QB2odikBYY3Je4=; b=I/YHwegTjqkw0JPStyG+Wf9etJ
        /GJ7f3PLpCCOfwx7gT5VimJoPIXTL/hdS56e6rndtfO4wguSipAJCqQXHLqa/06tE1J3XJ79wdTPR
        6Hf8MJdTCsMlGVXwD65/mQeLR89PIjuUhAZ9Hy+WQc3aBRnFbumnkHXk/mx+mvmZrtpU9fSjDzt53
        0M5iDet2LANw8qv03BW69pEeh8JpDzDDPZSm4wTtwpxQO7OUDv3mcI4j9t+q8e5FsAaeCCb/Pg3q4
        RuLRr/58Ab45Xj5IqCyoVdwIkKf7GvAbxOJJbhOLmwzra6bOT1lsDnNMsCcpDmF61U2h1Kb2EAQRU
        4AuGE0qyEirV/1WqaxnlRsUMYVY2QT8of7csZk2VIygemxlDqoQL+J2gmSNjdPbpQE5ruBM7dWS/s
        PBqp9Uq4OeL5y0zVskvH15tW3e98YPbeGC0tRO6C2Pn9v9+LZtqepC7O2lW0/6VpkxbqoQxx9EJIr
        QD1fyyPmGYjQdawcuG3Qkt0O;
Received: from [2a01:4f8:192:486::6:0] (port=33392 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lK57B-0003Bl-Ub
        for cifs-qa@samba.org; Wed, 10 Mar 2021 20:07:30 +0000
Received: from [::1] (port=58810 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lK57A-001yeh-RG
        for cifs-qa@samba.org; Wed, 10 Mar 2021 20:07:28 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 6843] flock's do not get sent to physical file system, causes
 protocol interoperabilitiy issues with NFS
Date:   Wed, 10 Mar 2021 20:07:28 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sprabhu@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: sprabhu@redhat.com
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-6843-10630-XmemSDtJ1M@https.bugzilla.samba.org/>
In-Reply-To: <bug-6843-10630@https.bugzilla.samba.org/>
References: <bug-6843-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D6843

Sachin Prabhu <sprabhu@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |FIXED

--- Comment #5 from Sachin Prabhu <sprabhu@redhat.com> ---
Just noticed that this old bz is still open. The original set of patches I =
had
proposed then wasn't included into the cifs module. This was since provided=
 by
Steve French
https://github.com/torvalds/linux/commit/d0677992d2af3d65f1c1c21de3323d09d4=
891537

Closing this issue.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
