Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666D3C433E4
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3130320768
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PPBYxnIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgGWMjT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWMjT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 08:39:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BA6C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 05:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=vik6E1ZhTd3yArnJY+4b9VGJECZEcDDvtNxnwk7m81o=; b=PPBYxnImd5VnbU4aHg5Shojs3f
        fxParBgn2rhHunj4CFt7lKVivhN/5msdDAf5rqL4gkAYNMzpOo+AKvaSe2SaipzBMlICnbMw5dU6L
        dl4CKYCmQmJcM9ATwcyqNzjZHefypSjYkWw06fXK6EYRTVZuUAV5snkTCqEWGPdnbyqqteMCpmJQB
        2vZ0bgxDbcYP7x9Nxp0DhXP6jyO5OAyTXZ8iNQIy3SmgbEuc06DEf09uW2Cvux/ILbiw1NgEfOUDO
        eavz7gTknA3/7Fihg+AEXvQRMJhwRilda/TDsfAoO7sebR1uRwx1ViUcE4L0BG/DhRmeVReBPGWTU
        M9Gc/dE7PAxLT1HBk3z24U8maV9/Otg+ZcuKW9KDHKeIkRKWKpeSJEdznuqhwXmO3j8OD/nbo1BtQ
        i0PwirQ2wPoipYzSvD+Lx2cbhGuCoCZYfeRDe0LzDipzzUJF2sXuNLN17NWiTI5CIRth714/h1Lye
        Bge0h0sAWXO2UrmZJ8tRidS+;
Received: from [2a01:4f8:192:486::6:0] (port=43256 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyaVI-0004Kv-TV
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:39:17 +0000
Received: from [::1] (port=29214 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyaVF-00717T-By
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:39:13 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 12951] mount.cifs fails on DFS share with smb protocol version
 >= 2.0
Date:   Thu, 23 Jul 2020 12:39:12 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aaptel@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-12951-10630-1GHhrUPwcQ@https.bugzilla.samba.org/>
In-Reply-To: <bug-12951-10630@https.bugzilla.samba.org/>
References: <bug-12951-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D12951

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #2 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---


*** This bug has been marked as a duplicate of bug 12917 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
