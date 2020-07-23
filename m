Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FA2C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 09:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82BFB2084D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 09:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fPIRTIOR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgGWJmC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 05:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgGWJmC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 05:42:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667E4C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 02:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=vn47ZJ9ICs/ZPTeqcSIG0PBtwWv6EtP3UXFUT0LQ9VQ=; b=fPIRTIOR2W8r2GLi1rnjjKQLUL
        ka9p8pxXpR/9ZCmdtCsRgrCpXzIOgzW4qe/kjnIHnjIBbJXjMP31nN3AaAkQ8qCgIeO/C7qCoJGRb
        Oqe2484AsQudmabzJlddUQ5/v2LOY8j6ptOe0wVWz+k/RF5fa3y+QFhZ3JVrYzLermbdtLHG1CD2S
        Y3MqNa5lm8Dwyq/MSKzB85KjTtHG5shEv+eSf1XvedDyPGZ7EBL/Z6nIZdvQHqBYMODku6mJqXKMB
        FueNmQENDjm5QlPQHHCXjRMTeY7jq98MfmBKQpkZxyfSIspd0HhFdCw9Uhq6rolxgKxbqK2wv3rKZ
        9GyfQachG2j2ctjYYfDU6e/mFldpX8bJGhS3MnuK6Ji2tyAtXyw8xIEBx335Ih3BnA62I8jffzkMp
        fkK7JE0DwKqR4HD+Y5m93QTiFQVV3jt4VeEDVGV0k6LAjWW59S/gxmI38ChiYhKV3LsiW63vAqCnS
        iEiSLUO4R77kAJiS+4h/p2jC;
Received: from [2a01:4f8:192:486::6:0] (port=43128 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyXjj-0002hz-PX
        for cifs-qa@samba.org; Thu, 23 Jul 2020 09:41:59 +0000
Received: from [::1] (port=29088 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyXjj-0070vt-FX
        for cifs-qa@samba.org; Thu, 23 Jul 2020 09:41:59 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Thu, 23 Jul 2020 09:41:59 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: vadim@mbdsys.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-1DgGPKan14@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

--- Comment #9 from Vadim Lebedev <vadim@mbdsys.com> ---
(In reply to Marcus Meissner from comment #7)
This was EXACTLY the context where we discovered it

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
