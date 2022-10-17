Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C2DC433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJQNwt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiJQNwo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:52:44 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885EA1E701
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:52:43 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5441F7FD02;
        Mon, 17 Oct 2022 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1666014761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=urrCyFqhyOpGSu1lR7xefhRzsMsFKByR2qdyR+1L53Q=;
        b=2ksIOibKRFq4jmi9CWqMpbGSiGEqJhC60k5c/WFUCQ3U0vHhPveyElK/LwkGZcAWhBrXGa
        AbAliG5o+3SB5Gktg2AnWO50gKOeXyR4/saZ89dz0ju7haq4tugKt+mFE6JDqBNSgHT3/f
        zztO5vymQG91uCX2qXT6EpwEiSTQgRXyBhz5oWRxW99EyYeAwcfFaPsc04MgvmL84A1RXK
        0CunS6i9cQEtgRA/BmSM3YaQLjBjMmk93Pg1KUv0+XwAz4rYH0euXvqcE9/7fRDTU9U2uM
        yYCnSqPiF7AbZlSqAQUNZY5Q9hHF+KkTBkko30OD7ASxBhptiBEu766PuYxS6w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, smfrench@gmail.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        aaptel@suse.com
Subject: Re: [PATCH 0/5] cifs: Fix xid leak in cifs
In-Reply-To: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
References: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
Date:   Mon, 17 Oct 2022 10:53:39 -0300
Message-ID: <87o7uad09o.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> Zhang Xiaoxu (5):
>   cifs: Fix xid leak in cifs_create()
>   cifs: Fix xid leak in cifs_copy_file_range()
>   cifs: Fix xid leak in cifs_flock()
>   cifs: Fix xid leak in cifs_ses_add_channel()
>   cifs: Fix xid leak in cifs_get_file_info_unix()
>
>  fs/cifs/cifsfs.c |  7 +++++--
>  fs/cifs/dir.c    |  6 ++++--
>  fs/cifs/file.c   | 11 +++++++----
>  fs/cifs/inode.c  |  6 ++++--
>  fs/cifs/sess.c   |  1 +
>  5 files changed, 21 insertions(+), 10 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
