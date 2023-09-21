Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B16AE7D0A6
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjIUTZY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjIUTZX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Sep 2023 15:25:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4553EEA626
        for <linux-cifs@vger.kernel.org>; Thu, 21 Sep 2023 12:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=AakB+shhdtKVpRoTqlncKd40Fvwtb1jf9hBBNJoRMTs=; b=jIUtjV17Mt6NdKv6n78QN9krwV
        AEPAzjLf/ZEaWDcSBlpXOydmoT0SPRudFpNpHe/VDWu+6wvJZn1buh1uBvYALoZRsi70NGNtvhkbC
        m1HIXdW5+lvJ8MrNO3J73zUhB8pC9oZrPuyLM705zPi7gkqGkhPy2xl2idvEKCXInRWPE3+wEuhBn
        HfPtXXKnQot2XjRMmBKupVfpfWgmw0i4jbe99uScRz9m+gIjIKaq4JGuOUlPF7gLy7XJCCKYld2M9
        ccabZQf2AnQdSjHlykmpfd8h3Dzmp3PO0+CGdYvWOrz7PAOtcYfZffS/dO/SCCWG7Blrq+0CuFpm5
        XdoOWMo145CHAHDy+ae8PPS56ag6tMEJ7xEi9iCw6DTvaF5bqxZKTUcPrYb20DlZ0uMone23jEliV
        PKiXzMJieyfuhRB3IRb21inEvQWFRmSoKkwItpGXwTLRez9Gby7ABuq6GFQAzw10Pq3AuI9TLULsc
        xGSAqJqhIO8tKWVO7JkEzkSS;
Received: from [2a01:4f8:192:486::6:0] (port=36752 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qjEAt-00EdNI-1v
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 07:32:35 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qjEAr-001RPT-Sl
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 07:32:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Thu, 21 Sep 2023 07:32:33 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sverrir.jonsson@thyssenkrupp-materials.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-qKraM7BSXx@https.bugzilla.samba.org/>
In-Reply-To: <bug-15480-10630@https.bugzilla.samba.org/>
References: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

--- Comment #3 from Yonz <sverrir.jonsson@thyssenkrupp-materials.com> ---
Kernel is=20
5.15.0-83-generic #92-Ubuntu SMP Mon Aug 14 09:30:42 UTC 2023 x86_64 x86_64
x86_64 GNU/Linux

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
