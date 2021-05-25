Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27220C4707F
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 20:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0127A61408
	for <linux-cifs@archiver.kernel.org>; Tue, 25 May 2021 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhEYUcr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 May 2021 16:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEYUcq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 May 2021 16:32:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A00C061574
        for <linux-cifs@vger.kernel.org>; Tue, 25 May 2021 13:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Jhj6It2LlKe7YsbJNJLk5rnHr87AJm5pGJBU2zigyDE=; b=xiRuoMJsWR/gKzpKg2viHwVsyQ
        JUyv9qs09kOcYCFbNrYDqQa4/44r+M/XhPQAae9K5iIQ2GBP4U/fOTcKmgb7uXslt202JJfyTHr0T
        fCT0pVV/3enTulSdggfMlK5sDJ4UX/oBhpKpPPkujQYIVGSHtJMe9wB6SxTiN5CTP66P8ZoA4jz58
        WaMs5gnjGzUQ1dXLzMM4Tirc61U2AN2NXbrbTYVesdfomGNqPOWDh/2Pi3M5Yi9MBBVv73uB7OE81
        gQZ3cfxcFj030ZBgGonryx3zCaqdUD3pFTiUUy+RBplWhWJj5g8nhZ+fx6Gn60xrFj3Bg62i3Ki39
        x4VN9bZoO6sxGFV0wSkCUoFs8a9L1BLYW57W0Nbo/75koUaXUk4yQjPVc2Ru1MIaIFwALvSfHtJUc
        l92EvCS5MvdAgzUK2TPmqsUxYyGs+73GEscbwpvi3p9f++5zZeLDZ7M40oyee7JpnX6p3B9JOwTyq
        NLC79B5xPpFClEItpO1NawmH;
Received: from [2a01:4f8:192:486::6:0] (port=55990 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lldhn-0007Aj-Vp
        for cifs-qa@samba.org; Tue, 25 May 2021 20:31:12 +0000
Received: from [::1] (port=33874 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lldhn-008k07-7b
        for cifs-qa@samba.org; Tue, 25 May 2021 20:31:11 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Tue, 25 May 2021 20:31:10 +0000
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
Message-ID: <bug-14713-10630-cWAmgTGHxw@https.bugzilla.samba.org/>
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

--- Comment #20 from Steve French <sfrench@samba.org> ---
Comparing with smbclient, there are a few interesting things which differ:
a) smbclient sets a default domain name ("SAMBA").  To make this identical =
for
the kernel mount ("mount -t cifs ...") case you could try setting domain=3D
parameter to the same.  I doubt this will make a difference because in neit=
her
case does the server indicate in its SessionSetup response that authenticat=
ion
ended up as 'guest' so presumably Solaris server thinks the user authentica=
ted
properly in both cases (albeit it could be a very unlikely case where
"SAMBA/username" is different than "username")
b) there are some NegotiateFlags (NTLMSSP flags) set differently during
negotiation:
     1) smbclient sets "Negotiate Version"
     2) cifs.ko sets "Negotiate Seal" and "Negotiate Target Info" and
"Negotiate 56"
but otherwise the flags look the same.=20=20
c) smbclient sends both an old Lanman (Lanmanv2) and NTLM (NTLMv2) response=
 in
the NTLMSSP_AUTH SessionSetup request, but zeroes the Lanman field, while
cifs.ko doesn't send Lanman.  This is unlikely to be related

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
