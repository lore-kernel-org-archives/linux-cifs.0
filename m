Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5E0C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 03:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70212064B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 03:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RJ1BxOlW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgGQDu2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jul 2020 23:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgGQDu2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jul 2020 23:50:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAEAC061755
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2020 20:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=eIaKDw3tpCKVQalXQDcVP0ptdPeUR7Jw986BpseLzeE=; b=RJ1BxOlW8i+Ax0n82J+cKgwB5w
        Rb8dXbY4DkRja8QAnGBRaX3Ve9yepeLYYzzSvWFob+FNgXdccn24f+V5z/LBSMiWpTyB6IWwU8d6G
        y+hwuakM7bV6ve3GCGWlzFiddFXQjo1SJwBWc8cKOaeOniuDCCFZVaGL6s3cYDMCQNxXHDsGAUHDA
        eO2nJ8LhxgjpCdNX2Sud4TwZtzkEFcIRlh+SNjN5zYoiOfA+RxeOzOyBWtCN52q79jStrTWtUEk+Z
        uxLo5I0LXOUO5iFs6YbO/M1LcdJJjOEwwLQTLMhXqCd6kHnpYtkaa9f36Fo8Whxhs0HH41EL96gVi
        7a1IAQ82DlxHF7xGtSrVmkAGca2VXlVXuJ2uISugu6LSUmTmbhpDTBepTwGyRhOn5fGaUPNJxh3ea
        VfhdrXkSajArRQOfyDNrjW4U1USkcxw3Mh/Iqc918VkDQa//I38GYfrQcsmi6vDEZA/PpeW/4Z3j8
        /3PHzC794UQnMrTqECA2tRR7;
Received: from [2a01:4f8:192:486::6:0] (port=40462 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwHOD-0005c7-8v
        for cifs-qa@samba.org; Fri, 17 Jul 2020 03:50:25 +0000
Received: from [::1] (port=26422 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwHOB-006SpI-M6
        for cifs-qa@samba.org; Fri, 17 Jul 2020 03:50:23 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Fri, 17 Jul 2020 03:50:23 +0000
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
Message-ID: <bug-14442-10630-mT15qbhR1C@https.bugzilla.samba.org/>
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

--- Comment #2 from Vadim Lebedev <vadim@mbdsys.com> ---
It's a step in the right direction,
but consider the case when systemd-ask-password is a shell script with(
#!/bin/sh)
I believe the vulnerability will be still present....
Maybe the best way will be to scan the option string for presence of "$(" a=
nd
prefix the '$' by '\' or abort the operation?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
