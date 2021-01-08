Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A293C433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 00:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5398B236F9
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 00:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbhAHAEF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbhAHAEF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 19:04:05 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA15AC0612F9
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 16:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=QsBTbrzAOv5YakYkcP/SuEPtz38P/KcKMIugJwMipRo=; b=fR98rZx3yEDjA5u7mFQ4yp0wpW
        jV3h24m7Q6Te15ZUIcsNSg2RT8HE/GF0ZwP+q9CH6ED6TpdWpBkURCYYeArrJK1B1n7mVYYq8PW+b
        ne0qi1aoOkz4N6a2V/U8jIzrw4YcdvcRt+XXK7V7Hfs42XKIsu7RqqHbrs9Fdrn8aRKZS21sRjYkm
        PmK5CjrGxZQZm+4xCCl5TYKGiCYHMqNiTwyVNnehloC4yn5lm1j3T83OjIeW3wUWddyT7VYEwLKV2
        qF00BUmiAI/hiDHa+8B8t6bTLlDBkcNec87opk7w2raydcsXjRSYjroKv/Xm4GCBurQayjmlQ6OD3
        0W8jFcT087msgzl09rEZu00RkgsbXBUhDVQT6WlPWN+fkPC4O+PYkk8jpxHqkmxQMtN9lVPnA+JkO
        FrKMAzaVZCWuvDc9IxU9ZUUcPNLX9v4DWN7z9zoXmqppZD+uK3Jm+9JixI7BDgYdGXd8GrmRiytCv
        0Un6X8QJ9Jrs+ieIkGEvUZRn;
Received: from [2a01:4f8:192:486::6:0] (port=58492 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxfFS-00047p-Fc
        for cifs-qa@samba.org; Fri, 08 Jan 2021 00:03:22 +0000
Received: from [::1] (port=27928 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxfFS-0031zx-4a
        for cifs-qa@samba.org; Fri, 08 Jan 2021 00:03:22 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Fri, 08 Jan 2021 00:03:21 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-13712-10630-CCEuwWU1Yk@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

Steve French <sfrench@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |FIXED

--- Comment #8 from Steve French <sfrench@samba.org> ---
The additional fix is in 5.10

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
