Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364E1C07E94
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 10:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13978613E9
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 10:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFDKTs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 06:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFDKTs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 06:19:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF666C06174A
        for <linux-cifs@vger.kernel.org>; Fri,  4 Jun 2021 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=k5irnM/U4fy7mugAOrsd+JmNsHeMZv50cMGxxlAth8c=; b=Bx0H3UBRLywbqdQ5nMpHI3lI6G
        5i83a+F1G8xAgqBDSzT3zQB4YYLALkQ1Eiy6d4Wto1SfBoTqoQmRsyMoJH9mhWPqD50zt3efm2Nvo
        MEMZ7TGlu9gZLVGAvwMQopSJ/N5Aik06SJDtBj7t4SmIK3wYw9H4jjlW80XklMcMJfdL/gS9PrGXU
        RW61tFHc2ufvCn2vqZzkFqWOt0Dzd19o0w9LKX7Le30jl8fGdYl2BsDOnD+bmvBRO+vKVp9R/e2qO
        9gHmCQgw2df/HPRAQ6RD5JwsyRTKWTJTGk21Wi6wjr3Rw85SjuM/RJHW8EeDjNjHXj0mlU5O3BSdI
        39oaXQQR/3A47NXKiSSyQLgnZMIjJgAcXe8T8qtpO7x0VL2yXuKmnbc/JkupsdxZRBk7zP83Ev9bW
        MWuP5U31oHM19IdR+zOHP34Iav+x1fAsPH5VrKNYwIwsM9PSIcxy4YoRKrlVchfWkjD19ovjCkOhi
        rG1+wCOFVnVXo1pFa57o15S7;
Received: from [2a01:4f8:192:486::6:0] (port=58386 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lp6tr-00021l-6J
        for cifs-qa@samba.org; Fri, 04 Jun 2021 10:17:59 +0000
Received: from [::1] (port=18642 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lp6tp-000S9U-P1
        for cifs-qa@samba.org; Fri, 04 Jun 2021 10:17:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Fri, 04 Jun 2021 10:17:57 +0000
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
Message-ID: <bug-14713-10630-9QFeyMWk5M@https.bugzilla.samba.org/>
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

--- Comment #38 from Richard Flint <richard.flint@gmail.com> ---
Thanks for the correction, you are quite right, the comparison file should =
have
been done with -m SMB3_00 not -m SMB3.

I have created two new files:

SMB3_00_smbclient.pcap created with command:

smbclient //nonsuch/myshare -m SMB3_00 --user=3Dmyuser

and

SMB3_00_encrypt_smbclient.pcap created with command:

smbclient //nonsuch/myshare -m SMB3_00 --encrypt --user=3Dmyuser

I am emailing the traces to Steve French's gmail.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
