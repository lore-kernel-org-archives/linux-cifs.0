Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EAFC0015E
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jul 2023 15:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjGXPos (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGXPos (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jul 2023 11:44:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52C311F
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 08:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=+XSO9kpYWSMjrDyXW65U6xwM6RE9OhfIK16wl424J14=; b=mdnCx/gTgczcvDQIIDp4TCQ0RQ
        qrjs4reZN2Z4G1Df8D7D/PL/35fbFctGFMvudZ1eU7LrJStfwlWPWQNvLB1mM4Zg4WwtBKYWr+Wb3
        YDFmHnErmApzkEm8AzWoIwwoKiyljsFNQRLFPDEC1gQZCoaqlGErSCO3D/AEL+MSDJDM/Kuwl4h+E
        bTt4MPRkTMoODL8AVsd0d0LGT/87flzuixAn4TNuksTdOvV1adz0yRX6JB160+SvajuF9b5Frh+E4
        puGMrW+m85nsQJZlIP6Lb1TylLd84jti/R0bMCtmVXZWPH4EM0bAkbrEr+8ydcmLjYeKouOWvbjdC
        FDu5+t8yfaOykuAxGA59IiD1JupUcP+iOuMjJoZ9UvDLoad5AgNqltikaPAah5Xx4nLPF1sIa1Rwk
        sWF/4cXKiAT30i3QSW/kjLaDomV705dxbiMrT8IcnG5X0ZD8arpHoJVy0bHM7z83voh3Ju0KNZ/ym
        F2oOBC9uPj2Pq4I3CD556oDL;
Received: from [2a01:4f8:192:486::6:0] (port=34924 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qNxjo-003r55-1I
        for cifs-qa@samba.org;
        Mon, 24 Jul 2023 15:44:44 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qNxjl-0000hB-75
        for cifs-qa@samba.org;
        Mon, 24 Jul 2023 15:44:41 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15428] Linux mount.smb3 Fails With Windows Host After Update
 July 2023 Update kb5028166
Date:   Mon, 24 Jul 2023 15:44:41 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sbharvey@verizon.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15428-10630-YzlIKZlQO3@https.bugzilla.samba.org/>
In-Reply-To: <bug-15428-10630@https.bugzilla.samba.org/>
References: <bug-15428-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15428

--- Comment #3 from Scott Harvey <sbharvey@verizon.net> ---
Current Status, Clear Linux has not updated samba beyond version 4.18.1, it=
 is
not certain when they will update Samba.  Meanwhile I am trying to stand up=
 a
working Clear Linux in VMware that emulates my working "production" server.=
=20
This is taking a little longer than expected.  Once that is setup I will ne=
ed
to download the code base for Samba make files etc.. I am thinking there ar=
e=20
robust make files, since Samba has been around for so many years.

Is there a link for a how-to for how apply patches, compile, link and insta=
ll
for samba? I have never done this before.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
