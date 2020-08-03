Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE738C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C25F72064B
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 12:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GzakYoQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHCMUG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgHCMUB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 08:20:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA641C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 05:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=FeBJBc+97H7WabFO98Agt3Bmtxp26ZXCVsERwFdzBl8=; b=GzakYoQ3b50hd/fbznnARIZ9UT
        9YuyOfh+EYH8WuWcVntxJNBFoI91NvEZn2cYmWK7ZOS32dYXbsknJofZ7YUNVi2qWu+X8RHCX9nSL
        ssFlG+8MXURUx63ONt5pvNHqaEYQCCpaN7y/QFxSIrJ3TaEG3QbmjMsfYuGhz9MROJX+oelPbdRrD
        oM9OHU0OYumKgXP6hVp9wAasbHK9IA6vVMqKMAXK2PkQi96rx/+EdB6J0utR8xvcu/Rnai7KW9tgW
        m8EBf4sm+0kytMpPFETFr5wX/BH9e6pVNL5gS2ORdENA8Tlbn+BYuyoux1XuuliiuI4Koo2YH3yjB
        nXVlaAhF/PnFu1cirLeoBDbicXpd3AONHLIV6dIs8NklTHXEqMG513QV9qSYAPVvSLYxYovKcqPmf
        GlPHE9wq/Paxgeige0YcT9+JpLZoZx/GrNqgzBti18MAecpb2ke4nAOxxef4eeo7t9RHnqyj2xz/n
        0SbQsZuHOt1daoAGoNjd1kWx;
Received: from [2a01:4f8:192:486::6:0] (port=49316 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k2ZRe-0007x5-B7
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:19:58 +0000
Received: from [::1] (port=35274 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k2ZRe-008Cbv-6A
        for cifs-qa@samba.org; Mon, 03 Aug 2020 12:19:58 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14454] cannot get symlink file attributes and target with
 cifsacl mount option
Date:   Mon, 03 Aug 2020 12:19:57 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-14454-10630-cAZ5gLU8GS@https.bugzilla.samba.org/>
In-Reply-To: <bug-14454-10630@https.bugzilla.samba.org/>
References: <bug-14454-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14454

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aaptel@samba.org

--- Comment #1 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16158
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16158&action=3Dedit
dmesg smb3.0 with cifsacl

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
