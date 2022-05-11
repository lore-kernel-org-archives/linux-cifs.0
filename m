Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C216BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 11 May 2022 18:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346456AbiEKSrK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 May 2022 14:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiEKSrK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 May 2022 14:47:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744FA154B22
        for <linux-cifs@vger.kernel.org>; Wed, 11 May 2022 11:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=RaQvyIECO9+XHrLuFCdIZbyw0athkzHwv8kGmfV7+kg=; b=X6Th5xx9JeTL/lvULqUsUmkKfc
        asGhSQgXbjNBrt6K+z1uGgfhhcxtpgPUIs4+EqgPG/e6J1+spehJjkxLoh37xml4a1DkKsoGXkuHO
        +/ZzZnPHpZRUV1E3EWDb0uRSK4+RDHiu/ao23lMzweRUJjb9gYt9KpB9NYavjNIerBM5h2JGsdXF1
        eTwNid4j41RkBRjAen5TJOQebb6iPsOmhAXDG2NVPEmsJgaTIEfvg4QpZBXqPhM0OqhBxU9a53x/b
        TfPJH6KlBt3XwvpjpXT85+bG9cqGvzlYV4U1Dlr8EF/fbSqSTrgrpIO/daiE5+8qSUDy+jOt2MCtd
        MjGUfvXuo7vYFArhZb1ZTLLOa6xfx3QNqkpgUNLqDYxL+XawM3cp3t9uUwiut8LqEDwm2CxCCzAey
        NNrBDoJ3rpZgx8D7wnPdLCb7Aqqq1RQz5ZeFr5D5cRPfGvQk/7NvxLBNx7mGwrPURvq5LxPK8dJGo
        2TulaFi/ovOTo69jeygJulJe;
Received: from [2a01:4f8:192:486::6:0] (port=39256 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1norMX-000PRG-MW
        for cifs-qa@samba.org; Wed, 11 May 2022 18:47:05 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1norMQ-000Gv9-PI
        for cifs-qa@samba.org; Wed, 11 May 2022 18:46:58 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 11 May 2022 18:46:58 +0000
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
Message-ID: <bug-14713-10630-NQiRo3WRtP@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #40 from Steve French <sfrench@samba.org> ---
Richard, If CentOS stream is missing backporting a fix for the past year to
their 4.18 kernel (which is fairly old), would be less confusing to follow =
up
with them. Do you remember if we narrowed down on the email thread what the
change was that fixed this?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
