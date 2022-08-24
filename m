Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CA2C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 14:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbiHXOJh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 10:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbiHXOJa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 10:09:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EAA7EFEE
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 07:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C72C6174B
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 14:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA130C433C1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661350166;
        bh=fkhvrJVFagDoPjvGJTr16ox9GuvwDjs5eTzNHT3JH3E=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=c+QtLHVrtcw3JGsejlOzRIzgJc3b3vLVc3anJe9Oflvmm4X2rVRnX07Yhbog/4mkE
         WGv2QBBol7fm/Ho4ymB3h0OXpNb65mwMoWUHgXLj6XC7acD37s1cpfg4WsDfb5YCEF
         zhJOaY9/YHB0fccHUC0utKaCnYLabUVP3smIQ2YgAHCcZPKDLJDOVw0xm7mAe0FUBd
         T24xZRMq4Ncy7p8VPWE1gYffvZB8BPTVjJaKHnPKMeyz52yiaa5yXOsQ1WmG1Lay5M
         XNWAVLEfNRPzNq97lpH8UtsmJYvU/nKhV0kMW+lit5dQuHqHA+5rHZYcSdeGCF6l+Q
         MR7VDRY4Y+dng==
Received: by mail-oi1-f174.google.com with SMTP id w196so19549402oiw.10
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 07:09:26 -0700 (PDT)
X-Gm-Message-State: ACgBeo21ZcvVjIGNKzhk2eAwa1cdSk65Fc1PfUCH7hcq5oFUj7jEUhq+
        1rYWLwXbak2BNxMOp0/ar+CEbzX5sDTcZ75SQDM=
X-Google-Smtp-Source: AA6agR7QOGsRjRgktZeUNJYm78w/h0f2VKYj2GjDXXdigoBoQHYkM5WdMed8mD3VlJzu9fSFQAOe99MMOmXhEGKKkZk=
X-Received: by 2002:a05:6808:14d5:b0:344:8f50:1f0f with SMTP id
 f21-20020a05680814d500b003448f501f0fmr3475316oiw.257.1661350165734; Wed, 24
 Aug 2022 07:09:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 24 Aug 2022 07:09:24
 -0700 (PDT)
In-Reply-To: <20220812021132.35077-1-hyc.lee@gmail.com>
References: <20220812021132.35077-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 24 Aug 2022 23:09:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8SRsvxxCckYPQRMxRHKiHQNQY7WvbSCKZiy4fJK4sOyQ@mail.gmail.com>
Message-ID: <CAKYAXd8SRsvxxCckYPQRMxRHKiHQNQY7WvbSCKZiy4fJK4sOyQ@mail.gmail.com>
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
This patch seems to cause the smb2.create.open test in smbtorture to
fail. Can you reproduce it too?
