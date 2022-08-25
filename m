Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D06AC04AA5
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 01:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHYBAL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 21:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiHYBAJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 21:00:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369BE1147F
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 18:00:06 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id a4so22742572wrq.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 18:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=6I6Fd/6tV1T9nqYZUAjhY8AfGvSDZnF8gZN8dKlQzfY=;
        b=ROw1QO6JgUFuye0c/p4oqx9mvdhy7geZj4Sego80cdbEa6LdEALf7JyfF3DxWcXV+K
         Qq/LFD7mXU+vLJug8I7ky1K+QH1COIsZ7xY4kkNk1yqZIqNX25yf0P2XhtlSMm9jEUZj
         l3Sj9ScT27h5VjpRDk19Cl6MwIkgmAufgnQi7XhGTdphcKnjQJZ/DJPdkDg5oAu+CraC
         cmE1UHrCUqiguZglaoaI62oMUfnBQE4X90h8m6D/p6SbChNgL6OgXeloHSPUQnbe0QOE
         uk7hl93+wbhJ20rq+ax02gWUTdtTuMuVKP4Tn60YhcjHQy8WH4eA5J2xwy/S8LOKZ3Zi
         kmqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=6I6Fd/6tV1T9nqYZUAjhY8AfGvSDZnF8gZN8dKlQzfY=;
        b=HVbRaz+UXTTR/0M+qz/uNBNgOunOgDYULzWnuqk7Nc46sxfvWKzEkB1RSbnh5lSWrN
         zg9ACkCXnKXWBL2achno4irBT3kNM6kZlCESNYp+zS1DYZx0lgBsIwVqEWfmVDBg6u4K
         kVbaIgApSDNUQE3kdolOaiOxqEcRM9x9tFQH9Y3sbslkVX7lqD9BVm7THBCKlgkJ2jhN
         WkK77SbpLqszVOzvSzKXZw3QxJoICB/35gigBWe/ce7TAa66TKr+YdMuox+w1mErwbFA
         GBn/aYDi63+3Z7FccyaC+ORdzNC7oRCp+OUSTWV/lua8HzMvQ7tgL78OrJ0OdXRgTY7p
         uNGQ==
X-Gm-Message-State: ACgBeo0UI6Uv9UibhKoXUlj19hlyGoXRpcuBzi6zQffwWuziCvdE7pMA
        B65+R7Z1LnmIASIwFS//n+38wNAEcIMHBiOWKJY=
X-Google-Smtp-Source: AA6agR5DASaEPWxgVRN/vlbv3CxzrJJIezL07VDt2SLF3jGVI9Nxsj9tgAhB3A/f7sI/th6c0FBAaPjAm+ZppnIwe8U=
X-Received: by 2002:a5d:534e:0:b0:225:2c0b:9b08 with SMTP id
 t14-20020a5d534e000000b002252c0b9b08mr771305wrv.136.1661389204799; Wed, 24
 Aug 2022 18:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220812021132.35077-1-hyc.lee@gmail.com> <CAKYAXd8SRsvxxCckYPQRMxRHKiHQNQY7WvbSCKZiy4fJK4sOyQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8SRsvxxCckYPQRMxRHKiHQNQY7WvbSCKZiy4fJK4sOyQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 25 Aug 2022 09:59:53 +0900
Message-ID: <CANFS6bbnGjM3hG+75wHrXPvj=GGvnHMAfjF1Phs+faGO1Q8eCw@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 24=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 11:09, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-12 11:11 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Remove unnecessary generic_fillattr to fix wrong
> > AllocationSize of SMB2_CREATE response, And
> > Move the call of ksmbd_vfs_getattr above the place
> > where stat is needed because of truncate.
> >
> > This patch fixes wrong AllocationSize of SMB2_CREATE
> > response. Because ext4 updates inode->i_blocks only
> > when disk space is allocated, generic_fillattr does
> > not set stat.blocks properly for delayed allocation.
> > But ext4 returns the blocks that include the delayed
> > allocation blocks when getattr is called.
> >
> > The issue can be reproduced with commands below:
> >
> > touch ${FILENAME}
> > xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
> > xfs_io -c "stat" ${FILENAME}
> >
> > 40KB are written, but the count of blocks is 8.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> This patch seems to cause the smb2.create.open test in smbtorture to
> fail. Can you reproduce it too?

Yes, this issue can be reproduced. I will look into this.

--=20
Thanks,
Hyunchul
