Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2DBC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 05:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3820920771
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 05:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nGVrHeLm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgGWFf6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 01:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgGWFf5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 01:35:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2D4C0619DC
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2020 22:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=EdvmQILTm5t2NWeM9s6r6EQnguhcKiV5N+U28RLNNzo=; b=nGVrHeLm4T67TkZoirPR2IT2Rr
        dIk489PgdMtZgOL49sRwip5kHfXm71mKCCd5xmctZYtrzaoHaa2JguR4g1jugAkDimhRCvndDt291
        95gGDQfuD4E+tlPhSP16t2oKy8KNBk04HFjGDKFtgD2j6loQ4PeLeNxkuBQfwWxbuVZh8ixfR3jt7
        H3lXGfEbEDeQm8JOQY2YAaIAbtoEvIUmwKKuNdIWqbTVz1nnTyddB3IOr9Kxxw1Z6obHF/+wnmuNx
        RtKHsgPTgISzP6SA9U16lldv6hVszws2K3QyqXYF3JXXsaBp1RLZtdRaT81kEwsaFgcB80+JU5zsA
        a+LSAEGH0dyZ+PS/OX/sCPCpoxTH8p+zoEiox2w0yfcdgUpGOCJTu42kxNYzeznZ4SZw4Kk8FhMP3
        3zuSXqd7aBzPHMCWLNavOIHLvouMEgIo/hFVdLYgTnkQdL0VE3fxNe0FlMrzwhogyghUl21mZFvqn
        X3ujPwb1ytgCR2v36TV6p5xC;
Received: from [2a01:4f8:192:486::6:0] (port=42964 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyTtZ-0007rW-SG
        for cifs-qa@samba.org; Thu, 23 Jul 2020 05:35:53 +0000
Received: from [::1] (port=28920 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyTtZ-0070b8-72
        for cifs-qa@samba.org; Thu, 23 Jul 2020 05:35:53 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Thu, 23 Jul 2020 05:35:51 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: meissner@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-ySdFs69AHO@https.bugzilla.samba.org/>
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

--- Comment #7 from Marcus Meissner <meissner@suse.de> ---
Looks like a valid CVE scenario. (untrusted users might be asked to input t=
heir
smb sharwe username which is then passed unfiltered into this kind of
mount.cifs construct)

additionaly to the proposed fixes, perhaps also check for valid characters =
and
abort if you encounter an invalid one.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
