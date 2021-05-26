Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF5CC47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 21:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91633613D7
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 21:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhEZVzu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 17:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhEZVzu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 17:55:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F12C061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 14:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Wxo9ULxNwc9N0vdWq3qef+Rs1KOAXLdi23KqPmBucuQ=; b=PijwO0uSv4QWHZN4YoNWOnT/my
        DCXelz1KIODRPBjd+mC5yJTEA2QON8HmWZHn1ZNXlarcbaD501kMlhntZ1jmebyNBhyPKmkTAtTHD
        89Al/ZmVrP7pZRT2ijInk0I/x00m2N3oSWVTZCRA/r4JzHlVyFeUxUEWPJNyXDbmdXNtgui7IHat8
        GLu5khlgrmdoD8z22wHHanyppfB607hRnDTCOoIhWMiEGTJxELEEmZaSo759ObNvSkzt2VVfxesRS
        aSTeZjYl+Sz0cWo+ex7m8c424Q5vZIn2x/3B4XSgAEtcXYvFoVxg/UZz1ujsiCQStTE58bIyLZzg8
        k2CllLTa2tc6Kwg1IL84s9itazU+gjxmvIx6XPdtlddMocV8wUw9g0AYMWI8NHkhPo7NR1SKpaScT
        SrS0cgTTVYlQXtSOr+VhN4Jx/NSELHJnxOGcJ5FZWLd0XmGRpLV/ItmqXHfZDdqIm05O/3VXLtdLb
        K8nvc0bcNExUB69vlM19KYyU;
Received: from [2a01:4f8:192:486::6:0] (port=56380 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lm1Ti-0004Gi-In
        for cifs-qa@samba.org; Wed, 26 May 2021 21:54:14 +0000
Received: from [::1] (port=34262 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lm1Ti-008pHT-4P
        for cifs-qa@samba.org; Wed, 26 May 2021 21:54:14 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 21:54:13 +0000
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
Message-ID: <bug-14713-10630-PT6yUGExES@https.bugzilla.samba.org/>
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

--- Comment #31 from Richard Flint <richard.flint@gmail.com> ---
The server says:

May 26 19:53:58 nonsuch smbsrv: [ID 211007 kern.warning] WARNING: bad
signature, cmd=3D0x3

so you are right, it doesn't like the signature.

I will obtain wireshark traces with vers=3D3.0 (and equivalent smb.conf
option for smbclient) set for comparison.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
