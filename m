Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93939C2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CF6613FA
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 18:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhEYSVU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 14:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhEYSVA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 14:21:00 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD90C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 11:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=oJTtgfIylOdVAZkiezOiWRUSoPP7UqCr4q37gdkHiSk=; b=mthIo8bP3gsr4I/fVLRifVY3Bc
        LvmjdntdNagBU5BnkwgMWhhgOgk0HpRBTcinO9DXeAzQo/wKSaSFdgCtt/DGqi7PcPrgAh7Vw6/tE
        IFJ6HTB08s5QrM8eucPxhCfutQ6Z0zWhEsqVfhjdLhPaZgSGV5ocBYPJfi1n7wsefNi8P4ZYsnN8j
        YA01kp3qEiDFuLEOx3niRn0TYCsKpvQw8TS4nTAQF9vvdYCm8MqeBhtGMKtdgHmKq/q3VQ/VXvGXb
        5AjeSFjnWE3rNrOJOI21O6HFXmfar95Im/1hm22cn2EXbVq7O98IP6phhzAsDK1AyZVI3qnDtEdOU
        YbAT8gRwXjvQIJYpjxQ33P4YV65nla81SBW9KujwZOrGk8ihiwa/YO8VMm8uxbMhvhhqx2kX33Y35
        vmSX7Xhi/nRF93gJAk/eJ+sce2q2blXm4DNWwPfF9Sdw2H6p05+HNB5BXSNwxsT8D4SpHHxUIPjMq
        ycYWw1TbCwoZObljNWzgM3mv;
Received: from [2a01:4f8:192:486::6:0] (port=55900 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llbeJ-0006E6-HA
        for cifs-qa@samba.org; Tue, 25 May 2021 18:19:27 +0000
Received: from [::1] (port=33784 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llbeI-008jsw-Sk
        for cifs-qa@samba.org; Tue, 25 May 2021 18:19:26 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 18:19:25 +0000
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
Message-ID: <bug-14713-10630-GrblOoyXph@https.bugzilla.samba.org/>
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

--- Comment #7 from Steve French <sfrench@samba.org> ---
There isn't much we can see in the traces you provide except the following:
1) for the "445broken.pcap" wireshark trace we can see that the server hung=
 up
the session (probably server bug but hard to prove since the request they h=
ung
up on (SMB3 tree connect) is encrypted when you mount with "seal").  If you
have access to that system and can reproduce it, it might be helpful to dump
the decryption keys so we can see the failing request and make sure it is n=
ot
malformed.  See https://wiki.samba.org/index.php/Wireshark_Decryption for
details on how to dump decryption keys

2) for the debug trace you attached all we can see is the "EINVAL" being
returned

   [  205.645184] CIFS: fs/cifs/connect.c: Received no data or error: 0
   [  205.645187] CIFS: fs/cifs/connect.c: cifs_reconnect: will not do DFS=
=20
                  failover: rc =3D -22

presumably the same issue (the server hung up due to a bug processing the t=
ree
connect request (the first encrypted request) when encryption is specified =
on
mount).

Could you retry without specifying "seal" on mount and include (or send to =
my
gmail) the wireshark traces?  In addition the dynamic trace info may be use=
ful:

1) In one process type "trace-cmd record -e cifs"
2) Run the test in another window
3) dump the dynamic trace info "trace-cmd show"
4) kill the trace from step 1

If it can not be tried without encryption ("seal" on mount) then can you du=
mp
the decryption keys for the trace you run (as described in the link above)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
