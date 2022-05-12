Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0F9C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 22:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349708AbiELWaL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 18:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiELWaG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 18:30:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC14B281369
        for <linux-cifs@vger.kernel.org>; Thu, 12 May 2022 15:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=Oz5ymPO9+DBh72JCqh/gtQ+mjTF/ca+y7Xk0EhRabUo=; b=xTpJ6HlZBnHOvz84QZPmDGMhkM
        vrRmpWGyGlZ/vhWp1H/UkEa4JZZIINW6Wi1ERE1mKKhJis9bbRD//RnS2HwOJoa9FbbvCmeHFnqov
        eqluIZOoANueoFUmx9k/eV8xO456QFBrzYMq2YzgxWFd+iFsIl3LnlGkZjT11XlOf03KL4XxsLohI
        JMlA90Mi0stGsdSd48TER/BZQRKE4piR6p0PaTkqEVelq3HOINov9OWlXsRDL0yk3mZbMl2SHT6b/
        svAkl98L411zC9GmWXzpb+XxVUwQXPpEl55lyWOhKMSSOG+WoTH3cLc3sW49xp7IvubKL3HgGFES3
        OWbF/6wYDGHD4ektBVFqwYw002eJ7BjcRo8LQ5guhdldbVH7Mxeg0ZSdmi/vSlXRLJNAWIca5hevJ
        SmZA8fNpA0iz+q1kCSItGAO0+bJhNwfcxeGqXzOem0aFZTd+J2ueZIdS6wfK3mJdKjzThtxGzCOl3
        0p5Bu935j4yo7rTKNNhgZ07W;
Received: from [2a01:4f8:192:486::6:0] (port=39328 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1npHJp-000b7K-Lz
        for cifs-qa@samba.org; Thu, 12 May 2022 22:30:01 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1npHJp-000Myo-Af
        for cifs-qa@samba.org; Thu, 12 May 2022 22:30:01 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 4194] Can't read directories with many files+directories
Date:   Thu, 12 May 2022 22:30:00 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ronniesahlberg@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: samba-bugs@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-4194-10630-Q0CM194dV6@https.bugzilla.samba.org/>
In-Reply-To: <bug-4194-10630@https.bugzilla.samba.org/>
References: <bug-4194-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D4194

--- Comment #7 from Ronnie Sahlberg <ronniesahlberg@gmail.com> ---
This was fixed more than a decade ago. Lets close it.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
