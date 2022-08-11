Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2AB8C19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 05:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiHKFqd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 01:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKFqc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 01:46:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF4C86C30
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 22:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B4BFB81EFA
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 05:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E561BC433C1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 05:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660196788;
        bh=oqcvVeI1WeJ8EHpFmq3n0qgKIitHCGGzwv0LMtw0oOo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=j4QEker19C4zVc8EM4kyWZcEQ23JvSwEDKzgRLo9NALc5bU3epPkGJ2z4qdIzAK4u
         3YEYRygEHL0o1jQunyPPJYvQ3LV8/YtQAkZrOJ1sTrQRLxhLyP1xYcvxpyJ9gpNoXh
         WYHprFmqLWltMXksF5LR2URfu4Pc5P1X5uA9IU9PEts3/pmaKb5gJE8jsS9il8mOYC
         vyz4GwYfLwtKB7xe76EJgJlHUAceipjwLtw6/CMH3Jl7bxRrDaXLNMXgqBI4baCt3j
         gRr7FwIF2bNiP0YbjRvgtrCfTXVEnahDA9NxbVWp8f2X4NRfPaENa2XCmeiBGTpJj5
         MhQ+gJXiaGoKg==
Received: by mail-oi1-f174.google.com with SMTP id w196so15182280oiw.10
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 22:46:28 -0700 (PDT)
X-Gm-Message-State: ACgBeo1zkhsZTbOcrAe7e4elBL9ot/ndQXubySLINe72Gybms5D1w+0z
        Fy2SHmBrVa/bklfdmxL9xXhzXjVPeqLWDbsQNFI=
X-Google-Smtp-Source: AA6agR7qxfWKY77jwGQVOMuTxIt9pQ9c7bR9yMYi3WZOHjazLYbjbpCeu6dxevan44laHYiDslhxdrGvfoHfQy2BqOw=
X-Received: by 2002:a54:4696:0:b0:343:46c5:9b2c with SMTP id
 k22-20020a544696000000b0034346c59b2cmr1201602oic.8.1660196788009; Wed, 10 Aug
 2022 22:46:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 10 Aug 2022 22:46:27
 -0700 (PDT)
In-Reply-To: <CANFS6bZ3EqBhFCHU=Bhgx+CVMg4Ug7orQSYTagKXCVrLezRxUQ@mail.gmail.com>
References: <20220810010446.9229-1-hyc.lee@gmail.com> <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
 <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
 <CANFS6bZd5E395Vdfa8Wh2DZkFdxgUxsO=M4kCEpJ2s6OUKW73A@mail.gmail.com> <CANFS6bZ3EqBhFCHU=Bhgx+CVMg4Ug7orQSYTagKXCVrLezRxUQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 11 Aug 2022 14:46:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qMaYVinB-gCVE2GUN_fsBUyThd_kJrT-N53Yy59ew2A@mail.gmail.com>
Message-ID: <CAKYAXd-qMaYVinB-gCVE2GUN_fsBUyThd_kJrT-N53Yy59ew2A@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-11 14:32 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 8:18,=
 Hyunchul Lee <hyc.lee@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2022=EB=85=84 8=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 5:00=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>> >
>> > 2022-08-10 16:58 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
>> > > 2022-08-10 10:04 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > >> Move the call of ksmbd_vfs_getattr above the place
>> > >> where stat is needed, and remove unnecessary
>> > >> the call of generic_fillattr.
>> > >>
>> > >> This patch fixes wrong AllocationSize of SMB2_CREATE
>> > >> response. Because ext4 updates inode->i_blocks only
>> > >> when disk space is allocated, generic_fillattr does
>> > >> not set stat.blocks properly for delayed allocation.
>> > And how can I reproduce problem and make sure that it is improved?
>>
>> This issue can be reproduce with commands below:
>>
>> touch ${FILENAME}
>> xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
>> xfs_io -c "stat" ${FILENAME}
>>
>> 40KB are written, but the number of blocks are 8
>> stat.size =3D 40960
>> stat.blocks =3D 8
>>
>> > > So what causes delay allocation between the lines you moved this
>> > > code?
>>
>> For the example above, the second command writes 40KB but
>> inode->i_blocks is not  updated because of delayed allocation.
>> And when the third command is executed, in smb2_open
>> ksmbd_vfs_getattr returns stat.blocks which is 80, but
>> the following generic_fillattr returns stat.blocks which
>> 8.
>>
>> With this patch applied, the third command returns stat.blocks
>> which is 88, not 80.
>> I will look into this.
>>
>
> This is not a problem and happens only when acl_xattr config is enabled.
> If the config is enabled. The security descriptor is written to xattr
> as not inline,
> and the blocks for xattr are counted.
Okay, The The patch description seems to be wrong.
You describe that unneeded generic_fillattr call cause this problem,
not moving the call of ksmbd_vfs_getattr() in patch description. Right
?
>
>>
>>
>> > >
>> > >> But ext4 returns the blocks that include the delayed
>> > >> allocation blocks when getattr is called.
>> > >>
>> > >> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> > >> ---
>> > >> Changes from v1:
>> > >>  - Update the commit description.
>> > >>
>> > >>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
>> > >>  1 file changed, 6 insertions(+), 9 deletions(-)
>> > >>
>> > >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> > >> index e6f4ccc12f49..7b4bd0d81133 100644
>> > >> --- a/fs/ksmbd/smb2pdu.c
>> > >> +++ b/fs/ksmbd/smb2pdu.c
>> > >> @@ -3022,12 +3022,6 @@ int smb2_open(struct ksmbd_work *work)
>> > >>      list_add(&fp->node, &fp->f_ci->m_fp_list);
>> > >>      write_unlock(&fp->f_ci->m_lock);
>> > >>
>> > >> -    rc =3D ksmbd_vfs_getattr(&path, &stat);
>> > >> -    if (rc) {
>> > >> -            generic_fillattr(user_ns, d_inode(path.dentry), &stat)=
;
>> > >> -            rc =3D 0;
>> > >> -    }
>> > >> -
>> > >>      /* Check delete pending among previous fp before oplock break
>> > >> */
>> > >>      if (ksmbd_inode_pending_delete(fp)) {
>> > >>              rc =3D -EBUSY;
>> > >> @@ -3114,6 +3108,12 @@ int smb2_open(struct ksmbd_work *work)
>> > >>              }
>> > >>      }
>> > >>
>> > >> +    rc =3D ksmbd_vfs_getattr(&path, &stat);
>> > >> +    if (rc) {
>> > >> +            generic_fillattr(user_ns, d_inode(path.dentry), &stat)=
;
>> > >> +            rc =3D 0;
>> > >> +    }
>> > >> +
>> > >>      if (stat.result_mask & STATX_BTIME)
>> > >>              fp->create_time =3D ksmbd_UnixTimeToNT(stat.btime);
>> > >>      else
>> > >> @@ -3129,9 +3129,6 @@ int smb2_open(struct ksmbd_work *work)
>> > >>
>> > >>      memcpy(fp->client_guid, conn->ClientGUID,
>> > >> SMB2_CLIENT_GUID_SIZE);
>> > >>
>> > >> -    generic_fillattr(user_ns, file_inode(fp->filp),
>> > >> -                     &stat);
>> > >> -
>> > >>      rsp->StructureSize =3D cpu_to_le16(89);
>> > >>      rcu_read_lock();
>> > >>      opinfo =3D rcu_dereference(fp->f_opinfo);
>> > >> --
>> > >> 2.17.1
>> > >>
>> > >>
>> > >
>>
>>
>>
>> --
>> Thanks,
>> Hyunchul
>
>
>
> --
> Thanks,
> Hyunchul
>
