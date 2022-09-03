Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D9FC6FA82
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 21:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiICV4u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 17:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiICV4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 17:56:49 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FED7481D8
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 14:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=BISe4+XSQZqDYwXzcCrQJGjnCia8ot4Qk/NRslS6Hoc=; b=p6DXMYLLynCxFRTwbc7rWzPAnq
        qAG/20GLHIirGYFIdxRLlhEqOegy8bGYXvm1LIubCRq8PU3KQZku1b2KassMzvRAxKrM1aKvRvROm
        c4JKqLaI69Sniglxeql7dZoTshjtgLl2z6NzQ1a+CtAWEBMnKARyzCSJuGWobm8riBOpYvIfceiqc
        6itu+WmKtCeXoAx0jhBX3tsqqs+sVPDNggKPuXieYdOrVpYldLVHuLnRQHCnsiKoOxqtMeeZyHw/4
        GTI6DLRpydZ+iAF5ZZIn1nfZjEX3W7z+HdeJSUVsazW7t6ELoiGW/MM7iccaA/d+bO3RgLqqV0zHk
        TFJhE2NVdZqwEkAQkNR6R5Tv/Vvg4mgDYEfx4yEq+SwJNKRHHwQMfFQs1z4TZJDJr05ltPUWdhBfm
        0+QsURAi3jAJIKk8xTY9K4b/bKKkU7y/Ek8L0tyWrvjV+SlSSjHYF+UfNsNGE/S+3WXsQqCMoO7IM
        nbToB3nTTHI+mcUIpFCc9LYV;
Received: from [2a01:4f8:192:486::6:0] (port=36234 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oUb8A-002x6c-B8
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:56:46 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oUb8A-000B26-0e
        for cifs-qa@samba.org; Sat, 03 Sep 2022 21:56:46 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Sat, 03 Sep 2022 21:56:45 +0000
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
Message-ID: <bug-13570-10630-58Lr0lnlto@https.bugzilla.samba.org/>
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

--- Comment #9 from Terrance <kato223@gmail.com> ---
Sorry, NFS share is correct.

terrance@terrance-ubuntu:~$ ssh 10.0.0.220 'df -h'
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           368M  3.3M  364M   1% /run
/dev/md0        455G  320G  112G  75% /
tmpfs           1.8G   16K  1.8G   1% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
/dev/md1p1       15T  8.3T  5.5T  61% /media/storage
tmpfs           368M  120K  367M   1% /run/user/1000

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
