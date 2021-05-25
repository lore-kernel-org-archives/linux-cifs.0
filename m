Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466BFC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B12613A9
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhEYTLQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEYTLQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:11:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C61C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=mLezMVXmDm2iPQmo7rZl1bUpKAtxY73WSGwTB/Evsts=; b=e1AXOcZFH6Cf7gsL1SKP1cFGfn
        vNLvltSIXR3Fk/G/N8j3R2Bo7wSt6vixtl+rch4CkR9yexu9Y9sXxWigkG6SyHydYwm9E3bI8QOeC
        aw2x4vWKLgmkvld6SFst/bs6z/jKMVQ1YVKHVwYu2eMbtQBFEgo157qsuQxlvpmJ6ghcjbTNXt+fa
        whxS6BQIjIrmJSbM4XkaU3r0gPNrw65fc71pCF2eBAFj7c5zyyqMt6RtZrlqVwm1119Er6qpEeiFZ
        fe6AAVwFpETrTCGigATANjI1TB6IjlDJeuNxuGOBWyumEJv6z6TR0ld6YepYSSNZ2yzeOMNAPYgub
        SG7DB6Nup6It1zkM5m1Wuu7h2rzz+yh/SeBCHYseDcuJ+Cr8UQJqF61XfWxVWyFrAgeZMA2nFVPQE
        FYcGLoLiHtRlRtXhLeohcnZV1NLIFuuk8C0IMwQfbpTUb1qBv5+MAJ4IUfj2xSh1Eu96QlYXto4KG
        9RyprobU1Vo+miYvnkDMGCm6;
Received: from [2a01:4f8:192:486::6:0] (port=55934 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcQx-0006av-Jy
        for cifs-qa@samba.org; Tue, 25 May 2021 19:09:43 +0000
Received: from [::1] (port=33818 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcQx-008jvW-F8
        for cifs-qa@samba.org; Tue, 25 May 2021 19:09:43 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:09:43 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-14713-10630-x0DmrG2k2Q@https.bugzilla.samba.org/>
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

--- Comment #12 from Richard Flint <richard.flint@gmail.com> ---
Created attachment 16628
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16628&action=3Dedit
Solaris server SMB configuration

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
