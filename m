Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C21C433E3
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 08:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB0620888
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 08:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="H275vZ/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgGWISv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 04:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgGWISv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 04:18:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF27C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 01:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=EB+DB+tHMg9Z95VITs+T5Crmy1A+G0CU62Ll+SS9bDE=; b=H275vZ/9h20FzsD84EivSNtkQW
        Z+jtssCBcB2blJHZTXgmWmMfHU5QLxuV9HuhGXOgjShZX1XzrdigpUIC99kWPoXQiNoPEDih2oNoW
        2L0xOU6d85ZE7KKKLv/ngqsWGEd7jCuRmp42YNkuW+QE3BcMl1A+qjqjh/7Hrar6mCHdgctP7w8vC
        b0rD1F2NZxwAGns0LisYTNHe9HsYAMpyo1vrkhddfsNmqwNEgX9zfvRDAb/1/SYIVFZ8XR6hmaIM9
        bDt08kMkNg4oNbym6QcGMhX0dXr1Il2C+OOIS/J8mThEanLLHpYxmzMik7KQYkRbL8HE0mP5vX4kt
        gbTA0hdPs6bkgmaHvDYIOPAe6prlzmTSEkoF4Z3+fu9o2Q1WuDibou3dNB/H9u1FalsnD0v3V0mXx
        KyqQyJ7hoB2PrvOo9T+UcWbsyR/DdhIPDp3uU5DsQQ7MtBQw4EUeOQOZGLrwQfk3MLA8gK0G5B7j9
        VouStvVVtqQiiKXh/l7ujhEB;
Received: from [2a01:4f8:192:486::6:0] (port=43016 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jyWRD-0001zW-DC
        for cifs-qa@samba.org; Thu, 23 Jul 2020 08:18:47 +0000
Received: from [::1] (port=28972 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jyWRC-0070oc-PZ
        for cifs-qa@samba.org; Thu, 23 Jul 2020 08:18:46 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Thu, 23 Jul 2020 08:18:46 +0000
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
Message-ID: <bug-14442-10630-bbZePGaQAk@https.bugzilla.samba.org/>
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

--- Comment #8 from Aur=C3=A9lien Aptel <aaptel@samba.org> ---
I'm preparing CVE request.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
