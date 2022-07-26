Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FA1C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 12:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiGZMem (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiGZMel (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jul 2022 08:34:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1C127CCB
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 05:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=iDWk29EhchVRskbFCy3lOMCxsncGvqZCR8/LUjz9M+A=; b=nPJsImIteWI8yqscxvevEPFWsM
        RGxFmZkjFJIgj5VoFtZnx2HSA3UxrRFv74nKi7L86SACPXsquzmOuDYDNeP2yvRuVEBFdudsbvp98
        w/9PeSNGDXi0qZXjv15cu0kHYzffx1gy2zTulEZ4g873FT8TkEouoUw5Ztm3WPnppKfpWiCWk6BMH
        NIwzDA559Bm992WxMtpE8xzRfTWRRRcRf8zjWQh1C9Xy29+1s7uKSJxMyZnbrqZhOlzZCqen2smVf
        X0zulyu4o9asik1vPv5uihAolbMyio5HDvAq1GWRnrktE7AKfb06zvCFge/SukWjRcFmH6YwYQNPW
        n94TZT/ngvAy0u0DgcJVfY45blHxSmuQziaiZn0OPM6pz7uyo0U8cmRKhMK7TK12T6jXTZmPC43Lz
        ZX8iSwrR5s4AL/XNDq2yWxHCg6Xxq4f4YXBPlqoXT8jxJWYSG9cqNk/9Yrc8KXUjF5U9oTKqjYFIT
        K4VegRFau6Ik949hoHeHNh7T;
Received: from [2a01:4f8:192:486::6:0] (port=54768 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oGJll-006ZU1-Pn
        for cifs-qa@samba.org; Tue, 26 Jul 2022 12:34:37 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oGJll-001rYb-7J
        for cifs-qa@samba.org; Tue, 26 Jul 2022 12:34:37 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14201] DFS mount does not pass context option to actual share
 mounts
Date:   Tue, 26 Jul 2022 12:34:36 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: patrick.boeker@haltec.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14201-10630-Qf3F5Y9rtX@https.bugzilla.samba.org/>
In-Reply-To: <bug-14201-10630@https.bugzilla.samba.org/>
References: <bug-14201-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14201

--- Comment #3 from Patrick B=C3=B6ker <patrick.boeker@haltec.de> ---
I have tried this again on a fresh Fedora 36 (Kernel 5.17.5). This test sys=
tem
does not show the described behavior anymore.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
