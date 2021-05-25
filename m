Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B046C4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 176CA61413
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhEYTt0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhEYTt0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:49:26 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D54C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=6LFLtUXCSK4uSpb29KIiPIO+ajSlAQZTNN/dGHmfUTU=; b=nGevLCjH/NZdun1Fs5SiNsgsej
        15U9WQqIjn8/7Fi0fDWpH9vc0p++nUbPVC61G6A5wC1FDAdvCV8st9r066TuTeH+U+sDViUzxfqaa
        wNGeUcSISAJRrYDtaMvbOWavT+Kkvq1oRf7czrqp/97B7+8OhtWYbM9N5C+O0kK1KbG2lXkh6iE6O
        jETB52QbL3sSOCAT8dknuZ+TFcXD1yfcwSm/Bit+qZ1FE8/PEGLWI16anwZczpt3q2p+GfIFma3WR
        isgCG+Q5pIj8+ivHDDaVsMpgEKdWo86pNTeT0h7P+1yRFhi5mGc+45t4mjqSg8gOxHwmefqZw0Sq8
        6o31E6QVb/TacGnbGz8V4WDcrtqfjb3jajmymYMjpubfwzmQlwAoxOostI/f5L/vQAgL10qxrxUvy
        hnZvPkbDWcEzklIQHW5ACJI/hArORi+W5uk6qNTrvxN5GhBaCQtrp11EXv8lWHh5b7OVJgTxno3bO
        K0mHBJJODJcUhvipKPd51WVS;
Received: from [2a01:4f8:192:486::6:0] (port=55978 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lld1t-0006sd-Oe
        for cifs-qa@samba.org; Tue, 25 May 2021 19:47:53 +0000
Received: from [::1] (port=33862 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lld1t-008jxj-FO
        for cifs-qa@samba.org; Tue, 25 May 2021 19:47:53 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:47:53 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-givIk7uMNB@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #19 from Richard Flint <richard.flint@gmail.com> ---
Understood. Please see your gmail for a pcap and a debug level 10 trace of
smbclient successfully negotiating an encrypted SMB 3.1.1 connection with t=
he
same Solaris share, whereas the kernel mount for the same failed.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
