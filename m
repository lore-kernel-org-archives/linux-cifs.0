Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF52C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 15:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9CE72076A
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 15:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sOAq2vHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGQPC1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 11:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgGQPC0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jul 2020 11:02:26 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7579FC0619D2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Ztmi7AeowaCzIqCzTWGiIXCx4bh/BFscYcxYh21N2W4=; b=sOAq2vHKUGHOv6Yc0LNYUphFTY
        RqE2DIITT0rMglSEfMalXFJJvMf8T8uqHFEXTRXaKEXIu4++jkSxOk4KWTpKDWzGLgeg8HbBnUIqO
        ROd0KFUt3By/ZcQN5ZokN5PL2anh+PzUGz+vmh7lKpIsWOTU4dKvSv7z+pFnkCvra57zwZKoKZK4S
        Kv1KeqkDia/n1g9Sw/rnp65G9mytEYaN0yorDGJO2K6nlQtG5x84BZR3QG5g77ga47su0FI/t6tG9
        7f1ThTWstJYk+yittvv2TGhRPglVnugPGlhRaXf8YU7rjc9KvHfv/ekIYex8VO+Rn5xT+JaLR631W
        w3TaI6MlkuecNcuMPZlWEHMoH+dO0xWXgy8K3cx/8oT4bdtgKZ/GS554owaVOw2b1xqtvRUCyj6zs
        JnePlYPvHm0Vjfy45J+QWI0IcrhhrzlgncuWxVHIVDzoEt0baXG/Ic//TpD9Zosv8v4r/IJ+rs+Vo
        ns3DSkEPYDQ9GZj3ep1EXeKl;
Received: from [2a01:4f8:192:486::6:0] (port=40828 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwRsW-0003DM-DK
        for cifs-qa@samba.org; Fri, 17 Jul 2020 15:02:24 +0000
Received: from [::1] (port=26784 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwRsW-006TuV-56
        for cifs-qa@samba.org; Fri, 17 Jul 2020 15:02:24 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Fri, 17 Jul 2020 15:02:23 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-IXV0H5JnXO@https.bugzilla.samba.org/>
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

--- Comment #4 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
I think Paulo's patch idea is good, it fixes the shell injection issue.
Some little changes are needed:
- close(fd[0]) after read()
- check return code of wait() and execlp()
- exit(1) after execlp()

regarding Vadim last comment:

If you can change systemd-ask-password (it doesn't matter if its a shell sc=
ript
or not) or edit PATH to make it point to something else, no privilege
escalation happens as mount.cifs drops setuid privileges in
assemble_mountinfo(). You will have the same rights as you had before.

But maybe I'm overlooking something, can you show an example scenario?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
