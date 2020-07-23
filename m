Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68373C433E4
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B08820768
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 12:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IoTNCtCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGWMDU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgGWMDT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 08:03:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B530C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 05:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=2u3Hb+vsyH+Z/RJGajKEipQ44k9T2ku/7PDCYqKuSW8=; b=IoTNCtCQTTNIBlrxt/38wGMS3y
        /dSnuOS5MXNc+OIdkjrJ+IzwSpvjLHP5d/zNFdjjNY0ntfoXKo7X4F3QQt9i/3W7uezkgud+JfiVL
        4w+ZI8Af4vgZ73xSxX7gX2UbzaLe7mNE0HvvSEUSjD5U+//2zkykvT0eHr/ZAuCgA7BxX20kyljuZ
        yCPWugTcRcVSXYdbmTSNSgHUsrtI7ZkamvzB+wUZydG9XBmTJzsJMiY3Q8TiND5iahpVpLWeOdDU5
        FGLfKa+D0JnFG+uYjkVQlM9aA3pyMOKcRlMao+YnZvb1qO6Lizz4Edh/O87noECW7+I7/XBbGdFVf
        Rq68IRx+f/AEbqUHDJLGeIFMW/YZckjAnqKofrllVdRM9K8pDhOWeQVn6xkM9ERFlQ2bRMuOyUQhN
        HEl3jLHy16jATzJ3PThrzidpDWy2Kb6O/O90Tkk0JOuZQzqP6m3OCyjkf6GPYyagQDegRaAT6itOx
        BIVmf4NOjf4mav1ReXgYYMs+;
Received: from [2a01:4f8:192:486::6:0] (port=43216 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyZwT-0003to-Cn
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:03:17 +0000
Received: from [::1] (port=29170 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyZwS-00714r-OS
        for cifs-qa@samba.org; Thu, 23 Jul 2020 12:03:17 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13107] Missing directories with smbv2: with smbv1, they show up
Date:   Thu, 23 Jul 2020 12:03:15 +0000
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
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-13107-10630-KQgsNZWvuF@https.bugzilla.samba.org/>
In-Reply-To: <bug-13107-10630@https.bugzilla.samba.org/>
References: <bug-13107-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13107

Aur=C3=A9lien Aptel <aaptel@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |FIXED

--- Comment #11 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
I could reproduce the bug and the fix worked, closing.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
