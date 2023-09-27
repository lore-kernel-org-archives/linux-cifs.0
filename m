Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EF1E80AAD
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Sep 2023 14:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjI0ONb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjI0ONa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Sep 2023 10:13:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207F7F3
        for <linux-cifs@vger.kernel.org>; Wed, 27 Sep 2023 07:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=swHfxzTzFmbV3yloZrk0i1wkF8Ev6UlfWTmVLhkjoU4=; b=3QYPbxA86fNmchwQM9Z/cGqbjR
        eWwXogk/8ts+gUflFDNgEaNiYNpjjyiywq7eoZMGW8mBt4mTkZxIRgMvdeTf8xQ7OO5SyiSMreZgs
        V980eiYuh458JqLYQD6ZWyotrOOTEC4Zv7X6FDs62mh3Cej1XedbF8gp0Z9iLnoLjbxLXP9iIEtex
        jD4kCN0EC8jEx1WX6TO+w8pygScUAbd5lBAff5vjAdjluQeL9IPMx8cfJ5S2OCi9wkSPOGj1QT7Db
        XYUIV28ldz1ZrfZ+YD6FIoFHRK1tYvUaDz6bEYotXdLaHVvji64eK6WBCF7f2uYipZnCGbnBavnw2
        ek1XILpQWaeTf0d3L4ELP/x/FZaRIiJXdHSXAzpIAwjprHpZiX8X/DSXueCBjFwYJVVILQ0uPGPxY
        cNbgDxYaWji1jJAgJjTKSLsBA2GnQcWjINUn7br+SzuHHpv5JVbYQWrNAWJIiK9M/3NZ1v953Acqh
        opINWrnSN7UFrwbL2HlpJq3g;
Received: from [2a01:4f8:192:486::6:0] (port=24324 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qlVI6-00Fe92-13
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:13:26 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qlVI5-0021Bd-RD
        for cifs-qa@samba.org;
        Wed, 27 Sep 2023 14:13:25 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Wed, 27 Sep 2023 14:13:25 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sverrir.jonsson@thyssenkrupp-materials.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-15480-10630-ythzAJpJV4@https.bugzilla.samba.org/>
In-Reply-To: <bug-15480-10630@https.bugzilla.samba.org/>
References: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

--- Comment #6 from Yonz <sverrir.jonsson@thyssenkrupp-materials.com> ---
Created attachment 18127
  --> https://bugzilla.samba.org/attachment.cgi?id=3D18127&action=3Dedit
TCPDUMP

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
