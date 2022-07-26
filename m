Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EABDC43334
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 13:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiGZNPH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiGZNPG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jul 2022 09:15:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFC127FD1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 06:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=fw+bRGknhc9xiIQbaqgi2Yw/qsbhOvYhbI4rXEQgMxE=; b=SEqDz4cm8EcjcMAdmGT6Zcnfo0
        qfk4qMTuDupf9lKuLt7JR6EBki3S1htNuosVvTayKnkooTUXvmLCWzrsNxT9LYfqBBpnO5F1VrkJW
        ctd3E+224jXbk/AQF61wR5LELxe0ld6yVAyyHWre/7V0CcYdSBK0V6S20k9g6P24yxveZlz+pY72K
        2BIc6OzanqzkbHuqAB1H0piScxv/uBXZ02SwmTZJkg9ceMoPLpf9+S6At2pKDV2fH45ALSkgJGSTZ
        n/ZwXQuLQnwSlKxzOPCBWonTaGCErFfx1jGUgRbKGQb9hb9VQuWSXqDkTgQtZaKSYbsCKMfZWQLIR
        xSMBb2UAD/NVZE1BjC9i4vc3MZFZz6ic0xTsXJcCEgsIrQMRO+bkW0DPS4oXwj8t/sqMFP6kiiJ9d
        0t/sqkLK5BIE5Ms8iRy0H5g3rkeTbH5X+BvP7wFK5TDvPKtBEReCylkYI+ZeKkCpTkSTtn1iox0t1
        zwI3cADQBL9+OzIRzZCcrBkr;
Received: from [2a01:4f8:192:486::6:0] (port=54774 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oGKOs-006Zxc-OE
        for cifs-qa@samba.org; Tue, 26 Jul 2022 13:15:02 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oGKOs-001rbs-B2
        for cifs-qa@samba.org; Tue, 26 Jul 2022 13:15:02 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14201] DFS mount does not pass context option to actual share
 mounts
Date:   Tue, 26 Jul 2022 13:15:01 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: palcantara@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14201-10630-lvZYBgBjtF@https.bugzilla.samba.org/>
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

--- Comment #4 from Paulo Alcantara <palcantara@samba.org> ---
Hi Patrick,

It's OK, no problem :-)  Some distros generally have their own packages to
easily tests latest kernels in case you don't want to build your own.

There were several DFS related patches since the last version you tested
(4.18), so yes, some of them might have fixed your last issue.

Can we close this bug now?

In case you are able to reproduce it again, feel free to reopen it.  Thanks.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
