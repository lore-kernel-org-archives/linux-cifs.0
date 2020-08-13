Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF68C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B3C20866
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OGgyUZtK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHMQWl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQWi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 12:22:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6721C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 09:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=oe0BX/rY8gCYLzyu2CHyFaQ2Bmnd3a1rEhjuFuBQlhQ=; b=OGgyUZtK61Yg9h8W4A7lnW5pT8
        +FzCfsbDMutTXGDHbedBUEhGguAsbp9O6tVd/vCLd3tAyj62gjy+tI1Ncs5kuzj3CjAXWwVuq/6JI
        ej2B0n0+dnUuYG3l0Rh6KSKdQDbhR1mtaaP1+PKpUo02+vuZPIWgfjZ/op5bYICGj878KNnF2J/r+
        Jay4/ZOA/Y0pZR6Wjgjc19qjE+qcdfX5CoJPBSAmFXvIoU+UydChETnAI2bwgKMk/whk/mRd6kT7q
        xjka8wbh4CCzTDLjCux24iAaZrz0L0onZ6lOV1VSAobFA9um7g34LxWGR44gpzsIwUv72hi6dTgNH
        D15fyo0fPN6wjmilYB7xFE5Bl2c66gPi80/Im5E6kVils9x6BEwViH2bSu7WkB7Ev1W4mT1hvTyL8
        5+8SbQNeqC3ZXVVZBMwmQMhQ0U9Rx0mSl1l6McUbgpgrW1hObRXiUfTycDdwDnjVMnal/D72PzdH1
        H4kIWmxrrM4Qo5Am8i9gPgKa;
Received: from [2a01:4f8:192:486::6:0] (port=53846 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6Fzv-0002a4-As
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:22:35 +0000
Received: from [::1] (port=39802 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6Fzu-00933I-Vp
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:22:35 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9110] Unexpected SMB signature in case of  coping data from
 domain-included Windows 200x
Date:   Thu, 13 Aug 2020 16:22:34 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-9110-10630-HmZ6O5uXNW@https.bugzilla.samba.org/>
In-Reply-To: <bug-9110-10630@https.bugzilla.samba.org/>
References: <bug-9110-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9110

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |DUPLICATE
             Status|NEW                         |RESOLVED

--- Comment #2 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---


*** This bug has been marked as a duplicate of bug 8245 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
