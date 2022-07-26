Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5B5C43334
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 07:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbiGZHds (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jul 2022 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbiGZHdf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jul 2022 03:33:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7C22B25B
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 00:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=XPVv6bCTwttyoRCVVFeI8DBZQdzKU7o2+p3VpCm/gp8=; b=h47NJ/SEkIfnJzU7eZFsglIeQr
        0Blr2anX8jUoJZuv6X59Q2TT6f0VjGBJ7wjNIZTcT05XZU/QXaGiQrqDaLRRDop+wzHF4T1VRYyWu
        +9qe6l8exuYkADjpDt4kelp/W22eQnS1m+XWP/zycDzsKURCX8JLPd5DyF/3+o3A21E5ouZ0jxgl7
        E+2nsoMAUBm7DQoRn7nLxGGeYranaUjCtVcboWhaTY/0W/jv2DKOPxf62O80J4BXiJTzeSBBGRhLE
        p8TUBgBR0Rl4jjVkDI3etPzJyQi7n7U5jhYV4mmIuVFNYIAJhmt1v39hu8K9AoMlC3nBwEE6ANNaD
        d0b1W9OlpYJxDyODZBlCaKsT582Oz1SsTrr7H7OinzOEOAIjC5VwGOq6khUhLnWsy4gavHq7KbPSQ
        3uc9Wy3xGjBTrFtm6wvs5kGKUKmTIciXpGsU9ilK7Wv5jW1J7GjZrz19F64zx5K2zSgKZ22CeVTPg
        Qlqro2uDxbQZKVGIp7w+cFEn;
Received: from [2a01:4f8:192:486::6:0] (port=54752 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oGF0M-006XNP-TP
        for cifs-qa@samba.org; Tue, 26 Jul 2022 07:29:22 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oGF0L-001rFP-Uk
        for cifs-qa@samba.org; Tue, 26 Jul 2022 07:29:22 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14201] DFS mount does not pass context option to actual share
 mounts
Date:   Tue, 26 Jul 2022 07:29:21 +0000
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
Message-ID: <bug-14201-10630-pfTx0HAj8J@https.bugzilla.samba.org/>
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

--- Comment #2 from Patrick B=C3=B6ker <patrick.boeker@haltec.de> ---
Hi Paulo,

have there been patches that could have fixed this? I'm willing to do the
testing. I just looked up what mainline kernel means. Is there a simpler wa=
y to
test mainline than compiling my own? (It's been more than 10 years since I =
last
compiled my own Linux kernel.)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
