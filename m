Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DADC47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 21:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F89613C5
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 21:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhEZVwl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhEZVwl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 17:52:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A009C061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 14:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=r6gzmxIk8xHik7G+/zX+m60A6R9a0kyIJ20NK3gcjk8=; b=jXq+EMRMLZMwzz2wtnphwiyoBI
        Gau+F/QgtBJC8D2DlJwiSEYnC6jVV0ywsfggXjs9Fp+D0oOu3NtQr8/9HlBI4ehAKf8JbaBj182vo
        IkWMNSRF3kd9NdiH4Ns+kWElxXYzfWrXmaHY6ZEIljWYoOZlPpIanqGuOohAbLMBLcKAMC0w7wnuz
        azZhRXRXhMNRc3BaUmjz5T5tnE+mUaiLqHbYIGsRuNwuzCbfx4DP58kat8jERpVS4rws1TV5lu+qI
        Itscpj4hABiznUQoQAbVtzgAIB3lAG3cFTw7gORkgpeU4L0+FP9ZvOiYa1I8peZ/tuU7p3xWmppBt
        htChBwkxA9cTaxb4mzsptPdQ4qrsG3mGup3mHVwZ2KEgWKywKAcV9CnXnu/l6hLVQ8v/uXJAL0l5m
        RayKTVQlOns/51gQrBp0+Q0a56+OVG2j4ZChLWpi/gfkO+s9pj5rBlvdqJTJ50Nrd+V88sUsI2EzZ
        bvprHkXnHFoV6SzO2BAQLjey;
Received: from [2a01:4f8:192:486::6:0] (port=56372 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lm1Qg-0004EO-HL
        for cifs-qa@samba.org; Wed, 26 May 2021 21:51:06 +0000
Received: from [::1] (port=34254 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lm1Qf-008pHF-Oo
        for cifs-qa@samba.org; Wed, 26 May 2021 21:51:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 21:51:05 +0000
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
Message-ID: <bug-14713-10630-umndq0yJJA@https.bugzilla.samba.org/>
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

--- Comment #30 from Steve French <sfrench@samba.org> ---
Presumably Solaris server doesn't like the signature (which is odd).  Let's
compare with SMB3.0 as well if possible.  Was the SMB2.1 mounts (which
succeeded) signed?  That is weird if signed works with 2.1 and fails with 3=
.0
and 3.1.1

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
