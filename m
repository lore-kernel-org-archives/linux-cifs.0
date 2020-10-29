Return-Path: <SRS0=/3sc=EE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B96FC4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Oct 2020 14:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8110220825
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Oct 2020 14:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgJ2OgN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Oct 2020 10:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgJ2OgM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Oct 2020 10:36:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DF4C0613CF
        for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2020 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=VPiXMNIDyEa863NEu0OKYvF0krS/eH/qd4NE6XjxR8Q=; b=O0a/33vqVqLQDqK2w8ExIx3yKb
        g1PA4XurjWcL/BFzHwzLfADfqWn9zVsHnFHMANUPrzGBFjgWyp6oHtMllR/uxMrp4aV7IgxOrJa0v
        UoR0T94TUuV374RJMVdPJpvgNwwjFQY3AtUmq8Yeo+/5bxe7FotMBImvT4aaLWS50/zsSwMAkSx/G
        e6b+bvisnTmHxSa94LaRVzuxWbR8fL6OWaP8QPx0ESKE+eV7SorSz3N8XHVj79zZX6BDX8w9P2SCL
        2g1zuVneXilzqK15QUpjjy/b6rkCqHkjORk5MdxgTwADsCt68ZQXyftQxoDjeVuTZL6R1khZ8KW7F
        SeBX0/qFLRqvhemzXwPOfBEMQRisiT5o47rf9wqJYaGq1xHLHqDP//eZxWiQNbM7qc/YD6LiH7PdU
        APmuEPwawdbihBMRa2kSKR0924uOmudc5rtlCLfiMnFQv27bsmSnCJgBQFfT7JEMCApEb+tPcXUEU
        h3iWTTP8o3VCjGiigDX/k0gq;
Received: from [2a01:4f8:192:486::6:0] (port=41960 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kY928-0005Tl-V0
        for cifs-qa@samba.org; Thu, 29 Oct 2020 14:36:09 +0000
Received: from [::1] (port=38144 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kY928-0007qf-No
        for cifs-qa@samba.org; Thu, 29 Oct 2020 14:36:08 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Thu, 29 Oct 2020 14:36:08 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kato223@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13570-10630-FT31bkda1u@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

--- Comment #2 from Terrance <kato223@gmail.com> ---
Just checked with Ubuntu 20.04 LTS and it too has the exact same issue even
with a newer version:

apt-cache policy cifs-utils
cifs-utils:
  Installed: 2:6.9-1ubuntu0.1
  Candidate: 2:6.9-1ubuntu0.1
  Version table:
 *** 2:6.9-1ubuntu0.1 500
        500 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64
Packages
        100 /var/lib/dpkg/status
     2:6.9-1 500
        500 http://us.archive.ubuntu.com/ubuntu focal/main amd64 Packages

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
