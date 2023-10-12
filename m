Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD146CDB46E
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Oct 2023 12:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343872AbjJLMhC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Oct 2023 08:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343824AbjJLMhB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Oct 2023 08:37:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB9AC9
        for <linux-cifs@vger.kernel.org>; Thu, 12 Oct 2023 05:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=Q8a+Gvip7e0WZtd4C8doMruD3hVVgcAhOrYzuYFN5dI=; b=VfniPOJxy30sSJXvC+wIIcYn5o
        2738bkSFeN6YOswV3lBtRtbw37kEGVMTWXH1xYP1RHqPt9sWmhuo9UHoiGWMCR5wPbSM9KKh1bhC/
        vP59H6vzYv7Y2H0KZR9RHIBbzc4UsRmBEpwzmvcgmMAH1NuFxFsKxsec+I4PHTaU5NAjMR/uSPHai
        cza8JUm70zGF43Hq+qS9eeoou7oCPf1YbprAr6R2Ria9q/YUKTqlS4ZCNZoEGfagMaebyD8StwFi5
        Cc3MJBX7OqEdCm0bflTy8/XauTy9VZRhPg7qz2hSqUb0v8MlkK14Bbzdek00yjmTt4f7KzVN7Jr/l
        7hmc1RWZXXdKZT82JjbAnncIrZTxpPif3M9ehDZm5eKBjvEk/PmPsBoK6PFZdE2GQY7oaFNehLlRt
        CPNuuh+d4C6fcTNLFJ6a1rmyaOeVLAcl79NIZ6KHIfN50VNrncNFuwQp+sg9H+TGpSQjTIdPar5bC
        X3u3QjFTLo1XXrNBv9q+J9b4;
Received: from [2a01:4f8:192:486::6:0] (port=56018 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qquvs-000GRQ-2p
        for cifs-qa@samba.org;
        Thu, 12 Oct 2023 12:36:54 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qquvs-0006BY-2u
        for cifs-qa@samba.org;
        Thu, 12 Oct 2023 12:36:52 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14492] Minshall-French symlinks cannot be searched for with
 "find . -type l"
Date:   Thu, 12 Oct 2023 12:36:47 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14492-10630-IHPxUlmcjv@https.bugzilla.samba.org/>
In-Reply-To: <bug-14492-10630@https.bugzilla.samba.org/>
References: <bug-14492-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14492

--- Comment #3 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
Any update on this? Bumped into this again, I thought this would have been
fixed since long.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
