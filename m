Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8BEC2B9F8
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5280A613A9
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 19:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhEYTPX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 15:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEYTPX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 15:15:23 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F458C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 12:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=WsywdaU56r4CgcmV+2nqwUtOKb2/0lC7xpCZS9gJIwE=; b=2dP/LO9Db6FcLDg3HXl6xPXOAw
        i4Q4sF2p6eyW9yCl7ZrKd69Ez1R/DDQnl8q8n1y+0t6iGRB23htnyzoy27Ed+/1KMPumWw/9Oo0Fy
        NLmiC7claN73VCLWqzCGyjaigeLrFHyuvYrfE5NKQGPdW6DKIKGj4ktZ1UMzCeoJYtZkGl8Sv2nEP
        GjXHxJZlMCr2ueyb8YbyBvrOR6k2lwWGZh12vfrGrl9LQwqFetTpGbOzWgkSqESg3JAQKLBaGsB4d
        pUDgdhkushHnn2FQAQVIezcekaK4RRodAnwiA1KM57tAmm1fVcvuGBCjnigSsuSG+kvxlPX7hg9rC
        Ft83GzV84VRxaW8aLAgg9ju/iWNv+QNHG+kwexNc8lVxYDKKlF/AT8Ei8MQpZ2pz993FplabijXbC
        ZmPGTWZWZ94Klys5fIQtijXsfKHRXv8TJN1fbmNjd8wpQBMAngx002389KKcpjDaX9nTqbsRNznk6
        S3zcMtKsl7B7QPDcPyA6e/iX;
Received: from [2a01:4f8:192:486::6:0] (port=55940 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llcUx-0006d8-7F
        for cifs-qa@samba.org; Tue, 25 May 2021 19:13:51 +0000
Received: from [::1] (port=33826 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llcUw-008jvx-VZ
        for cifs-qa@samba.org; Tue, 25 May 2021 19:13:51 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 19:13:50 +0000
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
Message-ID: <bug-14713-10630-2l9sazLBEo@https.bugzilla.samba.org/>
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

--- Comment #13 from Steve French <sfrench@samba.org> ---
Will be interesting to see which crypto algorithm they negotiate - but at l=
east
one way around this is to mount with vers=3D2.1 or change the config line:
        server_encrypt_data=3Dtrue
so that it doesn't end up causing SMB3.0 and later to encrypt until we figu=
re
out where the bug is in encryption (presumably is on the server side since
encrypted mounts work to every other server from Linux).

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
