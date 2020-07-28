Return-Path: <SRS0=IOoX=BH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832B9C433E4
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 15:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3084B2078E
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jul 2020 15:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iO5WpySU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgG1P4Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgG1P4Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Jul 2020 11:56:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B61EC061794
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2020 08:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=nV++CxA7bKa1cGy/XcbHdLWDO1YsSw2BAmDOw5jNQYY=; b=iO5WpySUtyJgn/AsyBQHz1RN9+
        nKEcoo1WBeQyQ7MFeR6OYMRa+RN9YWlRcMJFzudDfA1OnBWSiz7JbEvNW4wq3DESYv/g1CCJORmT4
        IRhkAsJ04JqxYhxhWr1lP8aC+KgB/StqEjPgQqYUKlulm4NiQR9bW7q68YPbZ2Lj6qfYnTqqNgVLB
        1CPOjOao5VYxWOF4mhP5mv47U5nWWn2ZSHMLLWD4Y0QioTFttuVPikz88H8BthAB1487THxNYQEnp
        eaUTKxgMMWkiWiPgzn21UCoRfejx2uQYR0GrTh60F2SmbcMpRNbwIDSsjpzh3TY7Mh5jBojE07LsM
        f0OSvlL2ZdpHl+TIXePetvknenvn7EE5vZOVbk0c/8ME4MAZXu1aXSjccPGueBk+FYb8bvF5ETh+w
        bFui76tDISjUqxm7++f9nobLmGOG1/+EIGkWBqOT1W3QyKGjhUkDTqfdb78xOu8e+oxYzsOfqUDTs
        4AI8DBvCPQYfX/YYdRgW2pYj;
Received: from [2a01:4f8:192:486::6:0] (port=46416 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k0Rxd-0007n6-F8
        for cifs-qa@samba.org; Tue, 28 Jul 2020 15:56:13 +0000
Received: from [::1] (port=32370 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k0RxT-007fBk-Gw
        for cifs-qa@samba.org; Tue, 28 Jul 2020 15:56:03 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Tue, 28 Jul 2020 15:56:02 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.isobsolete attachments.created
Message-ID: <bug-14442-10630-OGhybn1bpS@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #16138|0                           |1
        is obsolete|                            |

--- Comment #18 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16148
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16148&action=3Dedit
patch v3 for 6.2-6.10

add two memset() to handle empty input and/or bad systemd-ask-password call

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
