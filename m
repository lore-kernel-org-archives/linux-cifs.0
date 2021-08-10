Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EF1C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 15:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0598660F38
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 15:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbhHJPCx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:02:53 -0400
Received: from mx.cjr.nz ([51.158.111.142]:51428 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242013AbhHJPCw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 10 Aug 2021 11:02:52 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id AEAB67FCFE;
        Tue, 10 Aug 2021 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1628607749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WFcKXy34Iz7QIJsENeYSOV1tBgxEs0De3BZfHVJek3c=;
        b=xxhLeTn8qoRJlzrU/aJ7Xgg+LfG8hieWybRESa3chueXouhNn1solXSAqS66srpgDui6/M
        ts4bR85UCBsPK+5Sz/L6EuCXOKShy0Gjh5vVbWstdXaO/LAewWtU/9XcWo0E1k35phGpN0
        hcOz9qplqY1RBfVv5yg1/ni92k21zzg4M4/Rl/svffgq3tP3rVZbM5o76jbVDPt2hwRJsE
        3uRBbNGLDS7QnfgRJTHyBJAG/F/QF0JMuDcL2Gd3nFVh4oLguqjbL10tkLqCkHarDIscNV
        IzjixpxLTOmeYiY3N5CXoePkspFOMGuJj26YeZ+U02lJhOGBUjYmI1tU7mzyDA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Thomas Werschlein <thomas.werschlein@geo.uzh.ch>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel lockup upon dfs_cache_update
In-Reply-To: <C36709C4-A89B-40A8-819B-F54828F8788D@geo.uzh.ch>
References: <C36709C4-A89B-40A8-819B-F54828F8788D@geo.uzh.ch>
Date:   Tue, 10 Aug 2021 12:02:21 -0300
Message-ID: <87wnotmjgi.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thomas Werschlein <thomas.werschlein@geo.uzh.ch> writes:

> Hi
>
> We are mounting SMB shares from Windows and FreeBSD servers to AD-joined (Ubuntu) Linux clients, using DFS and Kerberos.
>
> A sample /etc/fstab entry looks like this:
> //files.d.example.com/shared /files/shared cifs defaults,sec=krb5i,vers=3,seal,multiuser,noserverino,username=LINUXCLIENT$ 0 0
>
> The machine account LINUXCLIENT$ is able to browse the DFS tree and mount the shares.
> The credentials for the principal LINUXCLIENT$@D.EXAMPLE.COM are stored in the default keytab (/etc/krb5.keytab).
> In order to access a share a user needs a personal KRB ticket (either through kinit or GSSAPI delegated credentials upon ssh login).
>
> This works fine on Ubuntu 18.04 (4.15.0-153-generic Kernel, 2.10 cifs.ko), but doesn't on Ubuntu 20.04 (5.4.0-80-generic, 2.23).
> To be precise: it works for the first 10 hours (the ticket lifetime) even on Ubuntu 20.04.
>
> My findings so far:
> - this lockup (after 10h) *only* occurs when DFS is involved. Mounting a target share directly "survives" the ticket expiry
> - this problem does *not* manifest with the newest kernel/cifs.ko combo (5.14.0-051400rc5-generic/2.33)
>
> Therefore:
> Could it be, that the DFS patches contributed by Paulo Alcantara on June 4 2021 (https://www.spinics.net/lists/linux-cifs/msg21999.html)
> fixed this problem?

Yes, that is possible.  We found out some deadlock and race scenarios
but couldn't remember if the above was one of them.  Still worth having
those commits backported.

>
> Two of his comments point into that direction: 
>   [...]
>   - keep SMB sessions alive as long as dfs mounts are actives in order
>     to refresh cached entries by using IPC tcons.
>   [...]
>   - skip unnecessary tree disconnect of IPCs when shutting down SMB
>     sessions (it didn't even work before).
>
> Am I on the right track here? And if so: are there any plans to backport Paulo's patches to current kernels?

Yes.  I don't know if there any plans, but the only tricky part is
changing the commits to work with the old mount api on <5.11 kernels.
