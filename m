Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD39C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 15 May 2022 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiEOUTO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 May 2022 16:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiEOUTN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 May 2022 16:19:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5CA1EAF0
        for <linux-cifs@vger.kernel.org>; Sun, 15 May 2022 13:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=Z6J3+cW6tiToJeIxBVyhqRmOQaEwX3qAFAYBPyNYsTQ=; b=VOW05TV7UNbJfwuDmzIlLvxXcd
        aLDLvpABHBtAYCwymLgFs1Gs95dESA2qzwWULfAaoZD2yIRj+KyWoQY5RQtKpYAaZrxIJDY6op+MT
        a9IkR2rRvQABmUSb6lJy0hZ9k+ng58jen8nglJKQahazYcqXrsIM9j/JyOxX2SZAh2MRfR8xx1JO1
        nNJYOAQ3tSOH2lXec6Mz2nUKPSa8UHto7NssJGhS02pCQ2f/vo077iYZWdjowtnXhIg2jMCWfIixB
        /imYrQsAp3Xg+WDBuVXZbK4Gar7E+8CPeS82dcGtunb6Sz5+MncRDUAIuJc72nJf1n+4KR5WWHZJM
        wOrz1ZEutV6KmHFBADRwYr0XHhpGAofpfPb2bD1tWMBQSe0JZ8L2k6KlLtKwF6G6gsmIOuMXqfLbL
        1yUeYHSxrcWkd0EhNndf/NPGkWx4r+NdVAF9PEvN6T9HA9Jb6ptIQye3CctPhaZMjyrJzryx+h4ea
        FVUAMAjiQSNpQvJo+RMNmKqo;
Received: from [2a01:4f8:192:486::6:0] (port=39410 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nqKhn-0012Fi-K3
        for cifs-qa@samba.org; Sun, 15 May 2022 20:19:07 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nqKhm-000cvr-UD
        for cifs-qa@samba.org; Sun, 15 May 2022 20:19:06 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 4194] Can't read directories with many files+directories
Date:   Sun, 15 May 2022 20:19:06 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: samba-bugs@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-4194-10630-d90IUkssA5@https.bugzilla.samba.org/>
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

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |FIXED

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
