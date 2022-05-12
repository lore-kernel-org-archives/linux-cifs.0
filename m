Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1D9C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 05:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349316AbiELFLK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 01:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349369AbiELFLD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 01:11:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FF028E03
        for <linux-cifs@vger.kernel.org>; Wed, 11 May 2022 22:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=izOO10To1W4qE4gBYVuWa9cr47uMvRAFoYD6S9t0An4=; b=JUSi4xHX2p/HyX1YnGdpr0ZX1f
        2/3LqYwjeNy5SnKKZY7LtzFdVFaXbJ30sfVxjYWoqrmiJ75KYdhbzSA4MBlKv+cI45aYpA3rLeirG
        Ux7eyojIhKvufZG9otu+O9fgXuwfFGmeViclucRCLX08PC8hDwhDf9Mg7kIVpRUXPd8NuFQUEfFqA
        78i2JNLJ2681x/ZjJPx/GPUo0Y9QL4lXnkoEY4H+ruxUztmc8ksqP+COQvkpP3wZeyrmCQu8dHxnt
        F2q3/t1P74ackivJx4ucrZpHHz5kaxkVVdTIUqAvm4Ve30OquzcpUBcOX8DdEug3HeZvNnnlm2qjf
        /CA9t0fK2T0rTUdM86AvvjjgNVgbjNWnMujjytYHE6tC3MZhsQnUWVQ6JLbwBndX8mKAPMtOQrRur
        3WfditH3P9EuXmfMw4JvLaXySaIOlj18wsmyJDY/Xi5nOC3ecX8h1AEnuTW9Ftv/Jk68Ar4BeZAr7
        mGtqdDKLSVBhDHEXV3c9rNV6;
Received: from [2a01:4f8:192:486::6:0] (port=39278 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1np16I-000ST3-1u
        for cifs-qa@samba.org; Thu, 12 May 2022 05:10:58 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1np16H-000LoT-TY
        for cifs-qa@samba.org; Thu, 12 May 2022 05:10:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15051] EBADF/EIO errors in rename/open caused by race condition
 in smb2_compound_op
Date:   Thu, 12 May 2022 05:10:57 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ronniesahlberg@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15051-10630-8JbLKp3lav@https.bugzilla.samba.org/>
In-Reply-To: <bug-15051-10630@https.bugzilla.samba.org/>
References: <bug-15051-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15051

--- Comment #1 from Ronnie Sahlberg <ronniesahlberg@gmail.com> ---
Good analysis, this looks like a genuine race condition.
Reviewed-by me for the suggested patch.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
