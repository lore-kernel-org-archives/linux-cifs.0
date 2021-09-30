Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06653C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 11:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD31E61994
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 11:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350334AbhI3LOc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 07:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350329AbhI3LOc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Sep 2021 07:14:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ABAC06176A
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=UBvBCFScsXc6mpQm2/rx/yPpsdbyo+eae9+F8oWq+1A=; b=hDtYtd9ZU/pFtbf6qOXRfsQ147
        ZWVQI1YPgikA6KMS+XkmIlPYuPHKklYS9K4Nlbc0xH0o6r361gjqJfbrPu3qa8OHpHo7//r/Z0lX4
        /vAud7VODtp9LJ8EcOhHQX3cfH9fHCGpuG8TqZrnKp04NhfE14c5ZWp8dmaLWO1FVnRPE0Gt+GoPX
        wfhxr/alvG+CoLIZPxXJDme7S+gE7jOQ/MACuKH0MH0R8NKUuyQGD9tpVrwP+kG78xL8MufIyhEVw
        kMU/F24ZXry1XXOcv/GnLYBke8WNgVbiXeNUQbNhrjlcP1R+TZ31O3+Gl2KYVDdbhpGi9wHjQZWeS
        m07naB9/Mf9uaWYOHrbkgQyn1LZeTcJgONz7umB7NLSRO9Zr3wCBQE6RrzyamNyn4SkwQkVgQD9Iv
        1GCDdCIuce1lHTLBoX72xMUGhWPukvRfVVi0bohodrBU78KSwtiCcojDaF90Lpg84WFzKXvRqpWJU
        iASPc7GIMHSQZ6D78+lj55Ed;
Received: from [2a01:4f8:192:486::6:0] (port=41866 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVtzb-000s2Z-Be
        for cifs-qa@samba.org; Thu, 30 Sep 2021 11:12:47 +0000
Received: from [::1] (port=52638 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1mVtzW-000Y9J-NM
        for cifs-qa@samba.org; Thu, 30 Sep 2021 11:12:42 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14440] creator owner (S-1-3-0) ACE not honored
Date:   Thu, 30 Sep 2021 11:12:41 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: slow@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-14440-10630-hde6W7ZsX8@https.bugzilla.samba.org/>
In-Reply-To: <bug-14440-10630@https.bugzilla.samba.org/>
References: <bug-14440-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14440

Ralph B=C3=B6hme <slow@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED

--- Comment #3 from Ralph B=C3=B6hme <slow@samba.org> ---
Steve: ping. Any chance you can look into this?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
