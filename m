Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F52C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12EA9207DA
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NnTUbZqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMPV4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgHMPVz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 11:21:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DBAC061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=5eTAa6Q8UT52pdUW9g5riw8HQeHItwZn6HwHxIBw1SI=; b=NnTUbZqxejKpYevMja2HuumS59
        L7hFuMR1r9ZMXiqsj44NBAJDXntTLcLolXyflB+rPJ3ByN0D8R5SMRoifM2nwXn6D5lLMZ5S6AQ9E
        L02+H/fJNrWwWeGnQZM4vlegxGsYIkiWiAD7sgTWgb3D0iKAH8fMRGApCCkEQpF27CwXC96IbgGAX
        ca3RibBfX7GMRI63xy2q97tfMfF8E0fw/xsi1XqW/YvCBJwPoQrv8ZYhhxsJ05kEpEuJlcFltitvL
        wj78JqJzQWmarJ9yx1e4z3JrSaBRX4AJTJ4whHRKW1oxY7Z1DyQGLat4djiV0rjo7/lz999vCSYhU
        YNt+wYW59QNHBxE8C2Llv2n1iKDZfKit1yL4KYUv4ZvC34Hzp4EPc6mmOIe/rzTLbiehakm6nYbv2
        au6cIDCLxwjyEN5hJDol9TVmla9OJFeih65MYLw6nf3nq11z9CDJkeC+EFNjmDEzEhWHqRvL34YB9
        dOFcr0s/ALuUf50mYIW88yFk;
Received: from [2a01:4f8:192:486::6:0] (port=53802 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6F39-00022v-Fv
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:21:51 +0000
Received: from [::1] (port=39756 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6F38-0092zc-KI
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:21:50 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9032] Errors when accessing CIFS volume mounted with mount.cifs
Date:   Thu, 13 Aug 2020 15:21:47 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status qa_contact resolution
Message-ID: <bug-9032-10630-yXrTRHxFvk@https.bugzilla.samba.org/>
In-Reply-To: <bug-9032-10630@https.bugzilla.samba.org/>
References: <bug-9032-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9032

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         QA Contact|cifs-qa@samba.org           |
         Resolution|---                         |DUPLICATE

--- Comment #2 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---


*** This bug has been marked as a duplicate of bug 8914 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
