Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF184C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 14:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiHDOFM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 10:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiHDOFJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 10:05:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27DC22B2C
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 07:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=oBUqk+H+X737843KmnTuCqEWP6R2o+zV0qr2TaZHhaY=; b=2U0vEVQg+3uqlKAzLxcJnXulxI
        bvXsv+vSKtis9/fLQBi3haVSv3MvR4BfN8tfvsHuzTEVTHYTEvkNrkBDuvJLfP6B2g+6A6acNKLNq
        j5slVotLxedaehConZKiXngJxHMny4FIXHe/+RhxBUBjaA1OqaMVFvwUko/IcX8bUhkBzAll3L5Rj
        lnAuunB81TaITkGnuWu96xgiIc+leDtMSh12VND9LkvQjzMwePq5RAPF9NaD6RGT+WKAo9aJF4r+D
        RtKRnAHxbRxDD8cvmevPlbBtEnUNwQIIeOKvXD1ToGPOtJI4Xb7+N1/pjc4cOu30Ok7913oON1rqu
        S7+N2gHH6Dh0rvaIRPWRcggDNYdr6jAnMrutGLzb+4rC7LtRvJP1letMS3L/3zVOs+d8vbN/KROYE
        kTYiYPmPY4VZXZP59Y4KljiiSnyTfT6dGfj/gZXORMbxhmYEGZsG+gnH9jTtybpl9Lwrrv7xzGZpF
        FlQhbondK/1heoOojCrhPIvu;
Received: from [2a01:4f8:192:486::6:0] (port=57522 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oJbTG-0085Cg-4I
        for cifs-qa@samba.org; Thu, 04 Aug 2022 14:05:06 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oJbTF-002s3i-L2
        for cifs-qa@samba.org; Thu, 04 Aug 2022 14:05:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15136] Access to cifs gets stuck for a while (>20s) after
 disconnecting from network
Date:   Thu, 04 Aug 2022 14:05:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ematsumiya@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15136-10630-9L4VY2cCTu@https.bugzilla.samba.org/>
In-Reply-To: <bug-15136-10630@https.bugzilla.samba.org/>
References: <bug-15136-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15136

--- Comment #1 from Enzo Matsumiya <ematsumiya@suse.de> ---
Hi, thanks for the patch. This is also a problem I've been trying to solve,=
 but
haven't came up with a good solution so far.

You set SMB_WAIT_RECONNECT_TIMEOUT_MIN to 0, but that would conflict with t=
he
socket timeout which is 7 seconds. This is also stated above the loop in
smb2pdu.c:

> ...
>  189         /*
>  190          * Give demultiplex thread up to 10 seconds to each target a=
vailable for
>  191          * reconnect -- should be greater than cifs socket timeout w=
hich is 7
>  192          * seconds.
>  193          */
>  194         while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> ...

Those 7 seconds are also hardcoded (connect.c):

> 2951         /*
> 2952          * Eventually check for other socket options to change from
> 2953          * the default. sock_setsockopt not used because it expects
> 2954          * user space buffer
> 2955          */
> 2956         socket->sk->sk_rcvtimeo =3D 7 * HZ;

(bear in mind that this value predates the 2.6 kernel, IOW I don't know the
reasoning to choosing such value)

Maybe we could reduce the hardcoded values and/or apply such mount option to
the socket instead, and, then, base the reconnect on sk_rcvtimeo? Just an i=
dea.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
