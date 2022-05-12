Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517D4C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 05:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiELFbW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 01:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349948AbiELFbO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 01:31:14 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306C33EB4
        for <linux-cifs@vger.kernel.org>; Wed, 11 May 2022 22:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=BLLUhuwWUVPyYR1BOGKmDXJB024IY0GFz1K+7lJACNo=; b=LhoNvpRJTe1G2rwmoaDf8xvpqx
        +d2cboJCEb+lVicSCghUrjm9qWVdh5zgidcTgVtk7nKJA/ls8QGzTCMFDXhfQGx5bRG0gCpiA97Zb
        k68N2T65cF9UNJfkZ4Yw3s4RJO9fD5lLMPORCGZaogi0RrX1SxSZNzF7PvAu3yy3zhGdqLAFP3cbk
        x6k5vberEdUAxqT1NKh03a/n+viMVGg5atlUYMqMshn3spX2EaLK0K94eVPo5SdIDZhU8lUOOnjpn
        47DnoY+e/Pdp3v9ZSenB2VmNySoSEwio8VCmMfvluS/KBO76szrg7Kw93LiQ5nLbcfAIP79MN0IX0
        DD3aW/1nuJ1qQAmsYEjzhmLNbMvJkuw2HjbB6jlqzd6eRM+yUCl8F105uje2Q5qNiUGOuNiAMlxJB
        0bJCdi0ucZbWt2YUYdPfgW67L0LV3M5pRLZurTNKZl69O3njoY6uxePd2jXJNNmU4AdEI13MiniSJ
        920swbeCg8SzFEvOaaCBQm0s;
Received: from [2a01:4f8:192:486::6:0] (port=39286 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1np1Pp-000SZ2-46
        for cifs-qa@samba.org; Thu, 12 May 2022 05:31:09 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1np1Po-000Lq7-QI
        for cifs-qa@samba.org; Thu, 12 May 2022 05:31:08 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 4194] Can't read directories with many files+directories
Date:   Thu, 12 May 2022 05:31:08 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: samba-bugs@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: target_milestone product qa_contact version
 component
Message-ID: <bug-4194-10630-30mBqDOFTo@https.bugzilla.samba.org/>
In-Reply-To: <bug-4194-10630@https.bugzilla.samba.org/>
References: <bug-4194-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D4194

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
   Target Milestone|none                        |---
            Product|Samba 3.0                   |CifsVFS
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
            Version|3.0.23c                     |3.x
          Component|Client Tools                |kernel fs

--- Comment #6 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
moving to cifsvfs. I guess this is long fixed and should be closed, right?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
