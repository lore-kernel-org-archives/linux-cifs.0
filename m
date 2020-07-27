Return-Path: <SRS0=Ubs5=BG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9409C433EA
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A076820714
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Jul 2020 11:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ddZPdORS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgG0Lro (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgG0Lrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Jul 2020 07:47:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA9AC061794
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2020 04:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=SivQWwOVq50liNRJdWIt/gyAc5sos3zpvFeKl49Wr8o=; b=ddZPdORSx0hh7lsep9bqh6TWqQ
        qZkk3/C/FVIzsZ9c4RgvrjPINlZvci/LlkeDvPxdnbXLS3gmowIKw77ZP4Y6pDH/zUt706uSJUw7z
        kqlLyyy0lCytyCX3UrUH/h5CrZuTP8/9mtuBtdq9YLCehG2uI/n2SppINUylHO5lCN0gmK5Pj9mbh
        kV2u8i1mDDF5iYaSBdyqCYN0r/svx76y9wgf41hxdQDzg0+iRChFqwGEVcmUaZ39AoYX8oB1SYEzT
        yoEMt2Nqnv8CRryLZAjSiq9Bz6AFQbs+etpe/tuQP3zOJEUSOlxDmmKHjOhITkpGxt9RhSuU/Q+tf
        HJl8ZMeTcrudGYM5t62ymyRKQTCIIQp1XKo3021yyloiekCiwaY6zoORuC88lB20CUxlk8tq6Uu8z
        +8i2Ci/ldQ2MW6rr3+EAFORLpfgDAmSNgtUMYwbX4MxWeAfqYuOPfg5nJKkFAYy8UCdsQmEdbBfF5
        h0GitI/LV8ZKlkVEb5TnqX+B;
Received: from [2a01:4f8:192:486::6:0] (port=45464 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k01bZ-0002II-5Q
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:47:41 +0000
Received: from [::1] (port=31418 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k01bY-007Zdd-PF
        for cifs-qa@samba.org; Mon, 27 Jul 2020 11:47:40 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] CVE-2020-14342: Shell command injection vulnerability in
 mount.cifs
Date:   Mon, 27 Jul 2020 11:47:40 +0000
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
X-Bugzilla-Changed-Fields: attachments.isprivate
Message-ID: <bug-14442-10630-aaSwHSFcep@https.bugzilla.samba.org/>
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
  Attachment #16137|1                           |0
         is private|                            |

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
