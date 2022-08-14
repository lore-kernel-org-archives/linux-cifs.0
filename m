Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CFFC19F2D
	for <linux-cifs@archiver.kernel.org>; Sun, 14 Aug 2022 00:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiHNA70 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Aug 2022 20:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHNA7Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Aug 2022 20:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ACF8286B
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 17:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30A1DB80B22
        for <linux-cifs@vger.kernel.org>; Sun, 14 Aug 2022 00:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9CDC433C1
        for <linux-cifs@vger.kernel.org>; Sun, 14 Aug 2022 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660438761;
        bh=8T28XiopeM1dEwkQWj6MYR3RJq2lTT42Pa1+2CdFIyg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MFo+AxQFrXSTVTETSAONkWHSY9YfnjIWdNqqb6p8gZLiN8zJtoXpbY4J2tJRJY32g
         KXR4imS1wPqEgna+7RFnXjyctls7yys+n5IXKmV61S2ZxOff47R8hNpzILJpQFtHb6
         KcTJc9jUr9bngtHbnT+nnMpXC/EtkFR8V+5l2CmW4iDV6F0jZuNjNrPvpOGCgdFOgq
         kcrL8RGI/TVkeIs1Ym59mqsLyqjK/fj7sFkc91wXwvLNBXowV1xDDf55OWNfDjujgc
         sIS5kLjAcKT5kJ/dxUr8D33wlwBTtjSzp+cu1c7s5G/4xhYINb68JEELMNamlLwPdD
         Ic9/SmKhlFFGg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-10d845dcf92so4781640fac.12
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 17:59:21 -0700 (PDT)
X-Gm-Message-State: ACgBeo1ovPW4KZbp0M9upAGlSuKKQiGn0s8Z1n10GYlkesd+Z1vV6E4Q
        bGdAODIRucjkgVOesMeuw48vplBo7etAizXw2Pc=
X-Google-Smtp-Source: AA6agR6m43riDzMpjg7dqXgRrwTUY2PUTeokV1CnFbxlgmiyZ+ZeuSu5R/3iJw18+zS89n7v3lfnjyPfgrJUvwBeCUg=
X-Received: by 2002:a05:6870:b00b:b0:113:5b32:3d4d with SMTP id
 y11-20020a056870b00b00b001135b323d4dmr8777291oae.8.1660438760920; Sat, 13 Aug
 2022 17:59:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sat, 13 Aug 2022 17:59:20
 -0700 (PDT)
In-Reply-To: <20220812021132.35077-1-hyc.lee@gmail.com>
References: <20220812021132.35077-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 14 Aug 2022 09:59:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9xVt0Qd0SNg87_OuDL1r8LgsRn7k_K5HVbVgMq8kKE8w@mail.gmail.com>
Message-ID: <CAKYAXd9xVt0Qd0SNg87_OuDL1r8LgsRn7k_K5HVbVgMq8kKE8w@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-12 11:11 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Remove unnecessary generic_fillattr to fix wrong
> AllocationSize of SMB2_CREATE response, And
> Move the call of ksmbd_vfs_getattr above the place
> where stat is needed because of truncate.
>
> This patch fixes wrong AllocationSize of SMB2_CREATE
> response. Because ext4 updates inode->i_blocks only
> when disk space is allocated, generic_fillattr does
> not set stat.blocks properly for delayed allocation.
> But ext4 returns the blocks that include the delayed
> allocation blocks when getattr is called.
>
> The issue can be reproduced with commands below:
>
> touch ${FILENAME}
> xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
> xfs_io -c "stat" ${FILENAME}
>
> 40KB are written, but the count of blocks is 8.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
