Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574C3C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 09:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiDMJDb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 05:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiDMJDa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 05:03:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B65252AA
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=0AWihOo9KBWbNXHR8avXUiBWZbosX+McY/wetX2knuI=; b=oXLADYG0aT1/9j5W6y6GTJEInh
        sSlCNU6PaiiWS04gt83RyTq4/Jq2rdA+G2qOdF4f7lUK+TykfJ3+P1Zb4VdhEM+rJsKXpLTvwQVW3
        Y9yxuO2HNM2Yx5XAoc976ey76j3TFmAUwGYxVuddt0g1C+Qhhz3AcYkgfG3SrJYfRdDD9cArH8KAn
        gy8suAxCsEfN6R34/NX7c519T45EJQSgSImtQ9sOTUKRDqptXyhXEfVoegTHJjVPNzBAU85SLHKSs
        8XcGUinLME0s5aMO8DhVgFTfybALTxMSeeL4vRZaZQseWoS1FHwR2cy+8HqZMptsdv+WzQ5MEpWyN
        EU1DxPMwo5RoAL3HsK/NC6NMmebaWqCQeml3Tm4dK5YyPWK/zt1Wx6+0OvG2bqbgJfKNcbjbA6sJx
        MFSzSjzK0hJ4RKhggTH/zz6XyYtSH79sxrwc9LR3TZpKKvsT4AQkH9YJL0dN56LWV2YlpFNFw7tTo
        2vPOEdZfnxnAoohkmqY3To7O;
Received: from [2a01:4f8:192:486::6:0] (port=41076 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1neYs6-000JBx-0W
        for cifs-qa@samba.org; Wed, 13 Apr 2022 09:01:06 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1neYs5-000AuP-M5
        for cifs-qa@samba.org; Wed, 13 Apr 2022 09:01:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15025] CVE-2022-27239: Buffer overflow in mount.cifs options
 parser
Date:   Wed, 13 Apr 2022 09:01:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ddiss@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: ddiss@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-15025-10630-ZVMmaXH811@https.bugzilla.samba.org/>
In-Reply-To: <bug-15025-10630@https.bugzilla.samba.org/>
References: <bug-15025-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15025

David Disseldorp <ddiss@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jbe@improsec.com

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
