Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC76DC433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Nov 2022 17:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiKDRz7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Nov 2022 13:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKDRzz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Nov 2022 13:55:55 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C53E2ED77;
        Fri,  4 Nov 2022 10:55:53 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C75D37FC21;
        Fri,  4 Nov 2022 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1667584549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q1Dy8m8CsJkIJ0vL9UqbIPKGPHuWYevvTp/f6vZV0pM=;
        b=pW6sPzhPrB5TXSoZipU1GaNRjF7yspEEjL4QX3KVHm8sRdQhsonojI5CWnutDj9nBFkRX/
        FJMRlg1f7y3QdZA6B/XsqRiK0lGjSdBKjTB9re1e1LVqo2UUrDDULdpkRNpOgaDpWfAJuK
        jq0dtIxOdBMjq0/R31fetPo7pdnXwJEQWt9Ohk0sfJmcoqLW7ofhY+mIVprTqxHnGyM61R
        KWpJbs5gxRt0b1VDtULMzCF7u/iALCq+UJG6/6AguPO6VrVMMsQ52PexFKYCRVc8akBMm4
        KIbXtm6L1Z/GNau2DuwqwNz1ocBoKNe2NDVJ2UzwY7sKWmN6j3F6YyvixeoApA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     ChenXiaoSong <chenxiaosong2@huawei.com>, sfrench@samba.org,
        lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, chenxiaosong2@huawei.com,
        yi.zhang@huawei.com, zhangxiaoxu5@huawei.com
Subject: Re: [PATCH v2] cifs: fix use-after-free on the link name
In-Reply-To: <20221104074441.634677-1-chenxiaosong2@huawei.com>
References: <20221104074441.634677-1-chenxiaosong2@huawei.com>
Date:   Fri, 04 Nov 2022 14:56:57 -0300
Message-ID: <871qqi1u3a.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ChenXiaoSong <chenxiaosong2@huawei.com> writes:

> When opened a symlink, link name is from 'inode->i_link', but it may be
> reset to a new value when revalidate the dentry. If some processes get the
> link name on the race scenario, then UAF will happen on link name.
>
> Fix this by implementing 'get_link' interface to duplicate the link name.
>
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> ---
>  fs/cifs/cifsfs.c | 26 +++++++++++++++++++++++++-
>  fs/cifs/inode.c  |  5 -----
>  2 files changed, 25 insertions(+), 6 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
