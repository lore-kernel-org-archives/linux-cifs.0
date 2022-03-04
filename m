Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B43C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 15:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbiCDPlp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Mar 2022 10:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiCDPlo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Mar 2022 10:41:44 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40156E295
        for <linux-cifs@vger.kernel.org>; Fri,  4 Mar 2022 07:40:56 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9193F808C1;
        Fri,  4 Mar 2022 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1646408454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJHIhZ4HjFMTEQqgBTGqX8ROfU+FZ672ace3jkOQ0eQ=;
        b=uF8r6oRNOgUCtSXT3+AwogIeNf9OUX9SYxvmblhGeCTRkO0qK0/Kq8gfSml0a7YZhdzIbo
        CFvMC2AxenCSbW401xzGnGd6sMg5xTHpP9F70bNYaUOa/kEWlFLdwafhdbZoZpZlvyZD4J
        8tidQYeabxKjCAU8wUGecL/lbIyLg1fn6KVmeSKvmYqXvTARmYIUP+jaqzskA5C5p10Hya
        lhfBRXQL+KaV3WNakM6FwhKmuPofSnjF8J+TLnjsuX7o1H8Tl0StEzuCQvre1ZbFuutvpm
        7buekyT8rgVxsvmQbuv6Tp00mDKey9HYTc56bnyOqoDdtgHHp4jCpvaN3qSB7Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix handlecache and multiuser
In-Reply-To: <20220304003149.299182-1-lsahlber@redhat.com>
References: <20220304003149.299182-1-lsahlber@redhat.com>
Date:   Fri, 04 Mar 2022 12:40:49 -0300
Message-ID: <87ee3h20am.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> In multiuser each individual user has their own tcon structure for the
> share and thus their own handle for a cached directory.
> When we umount such a share we much make sure to release the pinned down dentry
> for each such tcon and not just the master tcon.
>
> Otherwise we will get nasty warnings on umount that dentries are still in use:
> [ 3459.590047] BUG: Dentry 00000000115c6f41{i=12000000019d95,n=/}  still in use\
>  (2) [unmount of cifs cifs]
> ...
> [ 3459.590492] Call Trace:
> [ 3459.590500]  d_walk+0x61/0x2a0
> [ 3459.590518]  ? shrink_lock_dentry.part.0+0xe0/0xe0
> [ 3459.590526]  shrink_dcache_for_umount+0x49/0x110
> [ 3459.590535]  generic_shutdown_super+0x1a/0x110
> [ 3459.590542]  kill_anon_super+0x14/0x30
> [ 3459.590549]  cifs_kill_sb+0xf5/0x104 [cifs]
> [ 3459.590773]  deactivate_locked_super+0x36/0xa0
> [ 3459.590782]  cleanup_mnt+0x131/0x190
> [ 3459.590789]  task_work_run+0x5c/0x90
> [ 3459.590798]  exit_to_user_mode_loop+0x151/0x160
> [ 3459.590809]  exit_to_user_mode_prepare+0x83/0xd0
> [ 3459.590818]  syscall_exit_to_user_mode+0x12/0x30
> [ 3459.590828]  do_syscall_64+0x48/0x90
> [ 3459.590833]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
