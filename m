Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C21E7D0C8
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Sep 2023 03:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjIVDhs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Sep 2023 23:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVDhr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Sep 2023 23:37:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39582CE
        for <linux-cifs@vger.kernel.org>; Thu, 21 Sep 2023 20:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=jc0MZpMstdZLTk5vWHHpUwNC3J1HN0SQ4lG/tOEembw=; b=wFcFlOimD3nSvtMuKbn2M5TcxZ
        TBf7PJjAilUaCoFy+Xc/+f5F51/NPwu4c2yFN1MY8Z/o2AAU0KAED2C5+UmeW8UkXmE8VPKJ/O/2M
        39KRZUhp5XIn5Dg5hK2YVTK3YJRprro4uv8XHA90qOnY0azI2F9r2yysyv/gXOaczREYXYskSL39S
        vhb+xafbjzd5bZJBpElM8FumG3UOSHYe2DTs8FnPo6X8i6Ljin2tX2my841jFh43VhWO1y3+fpiPu
        FV8IWTexzPRHs37g0HoDCPAoU0M5XzywFBvVgf/qjhlu/ekEXDDNJ35Sqmj4svJk4SIqjjbTvr903
        PYqUA2xgOLmcVkmTF7iDDJfLC6ZQc7OW6/0mktQe/U952f7KtLOVMxZVcwy2MApFDu8fQ2x1AHwgM
        t88+aaC5dTuC4Qtr2FqAxMPfS+Dh5pFZG6tDoPDxbFSTOa2YKibsyVXdQQdxgdXC2X583x7pd9KXk
        ABHCgbyr4+1/yKTrrOgBjix+;
Received: from [2a01:4f8:192:486::6:0] (port=31654 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qjWz3-00EmJX-1m
        for cifs-qa@samba.org;
        Fri, 22 Sep 2023 03:37:37 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qjWz2-001WiW-2C
        for cifs-qa@samba.org;
        Fri, 22 Sep 2023 03:37:36 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Fri, 22 Sep 2023 03:37:35 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: slow@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-GHSCUaJ4yn@https.bugzilla.samba.org/>
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

--- Comment #5 from Ralph B=C3=B6hme <slow@samba.org> ---
(In reply to Steve French from comment #4)
Maybe lets just start with a network trace? Yonz, can you please do a netwo=
rk
capture port 445 and upload it to the bugreport? Thanks!

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
