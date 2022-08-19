Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECC4C28B2B
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 18:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350714AbiHSSvY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 14:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350882AbiHSSvW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 14:51:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A13D758B
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=dZr9OTdcfRzbfnX2guoW+PMLwwcOeqKgQC/XMhpt+Hs=; b=x99w1v+eqU3/iRVLGkOqK8DZNz
        Zxo2uyeVLZl42WcgTtnTWp65OBRk+THO/sUd/y+Xj7wQzkJEbhcUbD91o/6tfT0J5XBupgK74fcMS
        HE2SBBHixAp9iLAjE5ekLzJJSoMqUnSdhWgF6zBI+eOfBpsdwoojwTBcFyjnPWaWOaetniv6smImk
        u1w8Z2cso/1r5q98c7UoErWW3EFQjQRSRPKCLd3JBi1jrMUY1Ckx8k1/nlUw0t7IL5333vyZfLOEq
        lyQwP5k79/o+OUs0eRjXBlohQWY65zVZqFvlUcdtcqRl3MusGDXdwfju127qRfUuc+/2M/oxGWYK9
        Dff5v19K9i4xEUNh+QeGhT14CDESZKbZ1UhKnTJyM/NP2PxYapBy5pLCnCaPDjWgspukjwyAigC/f
        SbgffeadmV30oZ7Fo7zHjhiWPqXTkJBoKa+30KAAuw5WVkxOwZWCCwf1Pt0L8zsZuItGDgDJ7JwaM
        FthhFd9Ks8mcSsoYkB/je7XX;
Received: from [2a01:4f8:192:486::6:0] (port=32620 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oP75T-000t5E-41
        for cifs-qa@samba.org; Fri, 19 Aug 2022 18:51:19 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oP75S-000XeB-UE
        for cifs-qa@samba.org; Fri, 19 Aug 2022 18:51:18 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Fri, 19 Aug 2022 18:51:18 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
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
Message-ID: <bug-13570-10630-D3IBUi1liS@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

--- Comment #3 from Terrance <kato223@gmail.com> ---
Still occurring in Ubuntu 22.04 LTS

smbd --version
Version 4.15.9-Ubuntu

apt-cache policy cifs-utils
cifs-utils:
   Installed:  2:6.14-1ubuntu0.1
   Candidate:  2:6.14-1ubuntu0.1

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
