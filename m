Return-Path: <SRS0=Ubs5=BG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D97CC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DA3820714
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0nlYG84f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgG0Llh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgG0Llg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Jul 2020 07:41:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A259BC061794
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2020 04:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ColRboV0G7TQd/OB2p7POG84/J6uXgnPQUnTjzHB1V0=; b=0nlYG84fZLF/u7XMrb2GGoHG4b
        GfHnxoLsD7b9E1x7GAtnVTBWIzklmrKwlpiUebi1963nOxxKnRl1vKpsCxwlgibgJfiVxJeuHDznV
        6nA/pyFN97lU1GjdhndajKQMwLwsjPcAP+shtUiShgMtbHMZrEYRHACakUTryC7pucT0g36ucvube
        Iv9rpzFeuH+wHW4jwg9nT8cmMH/B24ozK548ElaTG8UvOOkuvg+xWhTvKWsizLCArIV4EQhuuylhk
        UYUiwZAL0wbT4qauIYWUnD2d650gPw0OvCau9ee1+jS6e+urJgRfoCT+IwSF6+8hhJjAt6TLTEzJp
        Mf4vHRkwvkhatkDIVL1Wd5RVgWqfU8zLz1YV2GeJZgoRLR5QwxxvUe1up1z6ZltamFrUgQWx97c6M
        oMa0fPJHEgPzFEmakThMwGtrt4x0zXj/12H9xU2DZt0MNEuMDkpljmTgsa2aWJ0zbjXynCGzOnYDs
        3OCjpVyn7CxSgZXtK3VJWSw5;
Received: from [2a01:4f8:192:486::6:0] (port=45442 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k01Ve-0002En-Gb
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:41:34 +0000
Received: from [::1] (port=31400 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k01Vb-007ZdA-4u
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:41:31 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Mon, 27 Jul 2020 11:41:30 +0000
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
Message-ID: <bug-14442-10630-vNX0QzRXUA@https.bugzilla.samba.org/>
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

--- Comment #16 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
Created attachment 16140
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16140&action=3Dedit
bug annoucement

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
