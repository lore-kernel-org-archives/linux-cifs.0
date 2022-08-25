Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF887C32774
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 14:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbiHYO5X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 10:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbiHYO5V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 10:57:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6779198595
        for <linux-cifs@vger.kernel.org>; Thu, 25 Aug 2022 07:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=7MlNH3zvS8lkNVucWfCoAvHHuncTns6ptv68zxW2CMo=; b=JzD6JeGamzk2BOWtP7j0xwogRq
        hQCuIxGPa9b4tyImup0jUhMfGVCabQASV+VZ+Kphj0VW409Utrsen6e/KIag82yX/VjaD5tGMmPws
        bQp1uFE53muIoMWs6oJLHSI31OU1+KSjxuU8QNybEQfqbSB9AcyDDscStpPMbH6QZfwT+vS9H56Ln
        UR4x5py49dHmbUuxjndrnFHo1eM7HqibZfGQaCIcU0UovulknTYtIWHM1JyjzpfXqtnnkyv6QGkT4
        a1+RwlccLIQIWzV2410iSTvXzowZz+v4GYN6hWo2IrUAPVTIQxd62Da8yrH7AvVx8Z7z2tPb+LQ7b
        y39iNa0BCvHbMSk0irjil2Yqb0EooGthGVIam74fArBTyhG6rUOZkAMSzqjccmiF6RbfVyfjchMCc
        wXnKdJbXdcM0qjt/CShE9HKF77ra71ZosG541FRy1lOrqBkekKLBHndTSZIqUSfsliYT/vzM2caxo
        0Jk2O6JMwJjk0UN205TQDe/b;
Received: from [2a01:4f8:192:486::6:0] (port=33886 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oREIH-001if0-LR
        for cifs-qa@samba.org; Thu, 25 Aug 2022 14:57:17 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oREIH-0016uL-08
        for cifs-qa@samba.org; Thu, 25 Aug 2022 14:57:17 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Thu, 25 Aug 2022 14:57:16 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ematsumiya@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13570-10630-CNTYW3BYi5@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

--- Comment #4 from Enzo Matsumiya <ematsumiya@suse.de> ---
Hi Terrance. Can you provide a network trace of the timeframe when you do a=
 "df
-h" please?

This way we can check if:

- the server sends unexpected info and the client just pass it on as-is to
userspace
- the server sends expected info, but the client modifies it somehow
- the server sends unexpected info and the client modifies it to something =
else
even

Thanks!

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
