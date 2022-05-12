Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EE2C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 15:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356108AbiELPuz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 11:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356112AbiELPuy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 11:50:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD331D7356
        for <linux-cifs@vger.kernel.org>; Thu, 12 May 2022 08:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=ApRRWVgJHCTaKfBRqat2tKmmW4aS2lyNjXtVsiV9R7w=; b=uUQggyAod7nZ+ecQAie7ojkHWj
        nSx40LZ9IXUZFHcTJ9JLDUcBrlj5AgK41bMcdPPuM/TDxiaSrrPkEW5H/5k/12YBb6j7scHGTcBIR
        Ia66h2bt3q2XGILQljHO7Mwb1tS+oVSv7jnPHLv6zzZQMOhkX/oC6mtU0kDT3glXo4cAHzriaiBFZ
        CJKVmhNLAOMBbqNejA0f+beVTuHaUqwxf/TBuJ+hifgEH836Ffxv3YQqBu/GffzsddCsBQaHUPbfm
        E6NUSpgxt+BF4MO6znFUugk2u9wP3oT8fdFEmcm+6Z5LgfIGeyqmvdG+2IKZW7I75O0lwPoZOg1Bm
        dHwDmJ8xqvuShMTx6a+bld6SpL4Ue6zmgjhq+xyIFQww+5dsMDi9bOfxZn4zbsROtnQndWyAv4hoC
        lgXAfgqiLEhmrdNYV7LJzNbkDemRYTzokDMRT0vN9r8IbCauPY0hIKur5zTLAWneTu8+IFxNt1J8b
        0ctY6ZRroshVt8f6Yz3AUj3y;
Received: from [2a01:4f8:192:486::6:0] (port=39318 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1npB5V-000XBm-Q2
        for cifs-qa@samba.org; Thu, 12 May 2022 15:50:49 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1npB5V-000MXF-Js
        for cifs-qa@samba.org; Thu, 12 May 2022 15:50:49 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15051] EBADF/EIO errors in rename/open caused by race condition
 in smb2_compound_op
Date:   Thu, 12 May 2022 15:50:49 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15051-10630-ICuXxsNe8c@https.bugzilla.samba.org/>
In-Reply-To: <bug-15051-10630@https.bugzilla.samba.org/>
References: <bug-15051-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15051

--- Comment #3 from Steve French <sfrench@samba.org> ---
Running regression tests on the patch now

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
