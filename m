Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E33C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA550207DA
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:08:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ikz7BX8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHMPIC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgHMPH7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 11:07:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DEFC061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 08:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=c/XEj1F4U2HYE7f9Kk2f1s5/SFgxs7nuVUbJobQ+VBY=; b=Ikz7BX8ZaA1qPPiKRrSR4HDXoY
        99f9tRxriNxix3z8cNrtn63upCvF/nZwC3mM2vF2LRMFvRyLYoQYkFtyY65bDxQbuz8w/wWF8bYcy
        T5yvj4qRoq0P25ulv0pJnJ0HSr8Gd2eKbRXIU9wQNdZSqvWg+C0yAOGa6Ex1OG2pLjVc/dzRIUvLs
        SPOWEQDwAT778cfcSCM71wXQaAEoZ3reJuFezk2cJzQHy2p6wSuT1oLD+EGmiEkCZeoUMSqBxeqoO
        2V5CxWuZ1n7jhc6urn5w+E42OhiQ5apbSGwxzAFgHHjuZLnofoVSbLCV7dnG4lkCNHcXGFOnXXm4X
        MAtY+YkMNAXTytaJNyipQmajS66FBmVyfW9xNgev6KvY2h1nM7AZCXypm2zkaIqyASRCcjLRswnJY
        eQmmXdqwvXfrJFwRDwhm6ML0YN7TEnZzs3u928ul0snkKjIE2TYf5QGR++T+zeWHvc3S0iHY1/Ppf
        xLVvYzYsvA25r1SKNyrwIOwu;
Received: from [2a01:4f8:192:486::6:0] (port=53780 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6Eph-0001xX-3k
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:07:57 +0000
Received: from [::1] (port=39724 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6Epg-0092yV-DW
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:07:56 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13107] Missing directories with smbv2: with smbv1, they show up
Date:   Thu, 13 Aug 2020 15:07:51 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-13107-10630-Xr4LKTo38x@https.bugzilla.samba.org/>
In-Reply-To: <bug-13107-10630@https.bugzilla.samba.org/>
References: <bug-13107-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13107

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |steve.vanderburg@gmail.com

--- Comment #12 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
*** Bug 8044 has been marked as a duplicate of this bug. ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
