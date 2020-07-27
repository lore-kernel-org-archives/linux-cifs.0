Return-Path: <SRS0=Ubs5=BG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A16DC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71A3206E7
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TNNNFD8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgG0LdL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgG0LdK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Jul 2020 07:33:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D8EC061794
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2020 04:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=5niMQRnxIbwC1zyuo0URdD8vYQrluMvV+G8/2KfbvOc=; b=TNNNFD8f/qoETgi+Mxj1ywRMfo
        dG7q+QSYNJD0WayCV7hdzPDH/93SfPD5pcBp5rcDJzONWzgbblF2aXl+X86hsb1K5lwX8DmiBHydN
        6HSL5f5HSiRlvwFBx6Bht2C6QSTJpT8S6nkb/o30Q9UIA6M7QEje7kjT9N0aOKs4m8Lxtah5WaGQh
        nRoRxI50m52+Lo4QrebATKGMfXHZ90GfF7KERuWSmvvbsDgA4fNoJ4rf/q97sBRY1QiSqMg34exZZ
        Nj2qdE70acJzjUnbUmJG2BHH2Pyc3XHDaWOzH1A52665mI2ilHmC5HrD94dkSmZGT0rGZmgafWuZd
        C4aIOlgN1ffZf3XkRG7M3wGlrSsKkJDxbVZvek5bhNHIyaUxjjvOvuWUa+ATh5whSXCu9so7rjqa9
        9Nfsio2ZXSUiY/8Q+qejNOjnIWri/PXeF1GDmwlf5ScX5gvU4nTcI+wtHYiaYv0zxnXaeP0ANatKf
        fCo3/mucJikjzyFIsjOdwcRW;
Received: from [2a01:4f8:192:486::6:0] (port=45412 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k01NP-0002AV-L0
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:33:03 +0000
Received: from [::1] (port=31364 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k01NP-007Zb8-2m
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:33:03 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Mon, 27 Jul 2020 11:33:01 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-14442-10630-AFfsYWvei8@https.bugzilla.samba.org/>
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

--- Comment #14 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16138
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16138&action=3Dedit
patch v2 for 6.2-6.10

new version of patch
+ checking non-zero len
- dont add mount.cifs binary... (oops)

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
