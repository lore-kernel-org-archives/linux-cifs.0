Return-Path: <SRS0=hquX=DI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C70C4727F
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 10:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFA12087E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Oct 2020 10:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgJAKDO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Oct 2020 06:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgJAKDO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Oct 2020 06:03:14 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4218C0613D0
        for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2020 03:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=8j3k4b5uBM9t5xmLSGcaN3qQEH+z4XqCyiM+MrAZ9sI=; b=q7n9UQRACRrGr1OhIql/6s2MDB
        IxZOvUSHZcOwc3BerqKRnVcuF0ekjlXvdMuUXGkIbaxf7g95uT+dbzxLlRExpiM+2W8rCIrRJZU9E
        +j9wmmglYpLm1SGhgo/1oRsWQB3kpZY8FP3xa+3yIVwN8FmcFh9oTa5yOHs7+t4UTaTDZtdnNtYlq
        nAEKzFiGr3GIgdHow2YVdtGDWDr/p1s+nPGnoxNywSbOzJ3Aq0hdylNNdlI0lFA3qkuVZaLYA+axv
        WhCewBuMHFkU52l4wysWLRqSyzKQThcMAPOuXRWokavddSriePe/penqBsSdjcGmYmPsLq9PjZnwA
        +3iovBEd6W6bIPEchYtXArcQFndIJ4+z6emrAQzpyqDZIfuEFrpdCMfei/91nvFI7jqcE2xT5oa6M
        er1efd2m/llhP+LpTLeCN7CiIJE3+VskmMsXhau7pN3nkw+P8aKc9SILq0xVaEjjBIjUCew3eErXZ
        zjJ+8kS6wFfpE25ApHb3y27z;
Received: from [2a01:4f8:192:486::6:0] (port=21366 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kNvQc-00077r-Vb
        for cifs-qa@samba.org; Thu, 01 Oct 2020 10:03:11 +0000
Received: from [::1] (port=34044 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kNvQc-003nr4-Jk
        for cifs-qa@samba.org; Thu, 01 Oct 2020 10:03:10 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Thu, 01 Oct 2020 10:03:09 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: john.dite@compinia.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14509-10630-zdISVe52Is@https.bugzilla.samba.org/>
In-Reply-To: <bug-14509-10630@https.bugzilla.samba.org/>
References: <bug-14509-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14509

--- Comment #10 from John Dite <john.dite@compinia.de> ---
RE: Comment 8. On OpenVMS it is very easy to create a "." file.
$ CREATE .
CTRL^Z
It is most probably an application such as DECwindows that is causing such a
behaviour of leaving "." files.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
