Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A601C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Aug 2022 23:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiHJXSt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 19:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiHJXSs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 19:18:48 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73277C191
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 16:18:47 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j7so19490183wrh.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 16:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=uzHleytK8ZmMv6n4+gWW+FC3gRJPjRtdoXy23uTNdhc=;
        b=OuxIRUCawIpL71GlE3P+cOybBr5XtZvJi1Cdl6HZG/h30B9vG0P4UD/lAIN9z07c3n
         BaSLP8VtSehjIKy7ptQB0nAAHGcXLMapvFKPWsh5+Kc4Uf4i/7zIzh2jHY58JZXMRco1
         GZfl9AncZqzO3XPI+5QryKJ/mUCNxzdT6sEdoGDdzL8e+FlAjJvv1Kt+T5VR3Y+NlBeb
         Get2MOo3mVyO5e1NGt5SNgal4NZnsG5wyuSb+RyDTJx/qOtrR3kcfGwnQbKWllcLriDR
         Aj95BfdLKhaQOKpln0ViO86RR575vDsgjkRdaQNrfBastaCkAj3ei0Krumf+kgC8HKjg
         m1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=uzHleytK8ZmMv6n4+gWW+FC3gRJPjRtdoXy23uTNdhc=;
        b=Zv00HNOoLneW5fLK/QNmssQrC49M41lEi8Sn4+cE3TiDLtJ1zVRLvv/uzmopYA+gCb
         lquymPYXB4to2BulAoO1p+kEuP4fTD50gbJDScXZd8ahs7t2IrFl1JtqnyJKF8ODHB9D
         VUJabo1cL/UIS/j7hQtQUeTIHq2ZOhyDA9BDgGjTt8N145EeDGR5pLp8jS4QR26QNj//
         +Q9e4OA0fCHIYoHe+iQjyGtqvNUUpHPPfPniRPFctV58aXyfMqphbPAiJTgP2ki2SIna
         5WhsOSABlO17d+lYddIxEOD+7HD6kfnjErjoCl9YVyjIl/1Sa9ENh1pTvrXqERvuykYS
         cC4g==
X-Gm-Message-State: ACgBeo3Z5Y2O1tlMTedzlTyL9n7yzmq42uWFRZ3/DWHwIUM3+2hyBaYK
        gt1F4zcv9Qg0Uuna7QgwG4xJh0kd1Ijspj7HkeA=
X-Google-Smtp-Source: AA6agR4xuKmrMSgpeN0ZigxG+C975SjQ4/ybGYSgnCWh7QFDiVoULYgsY5zqE6tucz6bmsFC05HdLNHNctqpvReJN3A=
X-Received: by 2002:a05:6000:15c5:b0:220:727a:24bf with SMTP id
 y5-20020a05600015c500b00220727a24bfmr19079373wry.621.1660173526409; Wed, 10
 Aug 2022 16:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220810010446.9229-1-hyc.lee@gmail.com> <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
 <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
In-Reply-To: <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 11 Aug 2022 08:18:35 +0900
Message-ID: <CANFS6bZd5E395Vdfa8Wh2DZkFdxgUxsO=M4kCEpJ2s6OUKW73A@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: remove unnecessary generic_fillattr in smb2_open
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 5:00, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-10 16:58 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> > 2022-08-10 10:04 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> Move the call of ksmbd_vfs_getattr above the place
> >> where stat is needed, and remove unnecessary
> >> the call of generic_fillattr.
> >>
> >> This patch fixes wrong AllocationSize of SMB2_CREATE
> >> response. Because ext4 updates inode->i_blocks only
> >> when disk space is allocated, generic_fillattr does
> >> not set stat.blocks properly for delayed allocation.
> And how can I reproduce problem and make sure that it is improved?

This issue can be reproduce with commands below:

touch ${FILENAME}
xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
xfs_io -c "stat" ${FILENAME}

40KB are written, but the number of blocks are 8
stat.size =3D 40960
stat.blocks =3D 8

> > So what causes delay allocation between the lines you moved this code?

For the example above, the second command writes 40KB but
inode->i_blocks is not  updated because of delayed allocation.
And when the third command is executed, in smb2_open
ksmbd_vfs_getattr returns stat.blocks which is 80, but
the following generic_fillattr returns stat.blocks which
8.

With this patch applied, the third command returns stat.blocks
which is 88, not 80.
I will look into this.



> >
> >> But ext4 returns the blocks that include the delayed
> >> allocation blocks when getattr is called.
> >>
> >> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> ---
> >> Changes from v1:
> >>  - Update the commit description.
> >>
> >>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
> >>  1 file changed, 6 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index e6f4ccc12f49..7b4bd0d81133 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -3022,12 +3022,6 @@ int smb2_open(struct ksmbd_work *work)
> >>      list_add(&fp->node, &fp->f_ci->m_fp_list);
> >>      write_unlock(&fp->f_ci->m_lock);
> >>
> >> -    rc =3D ksmbd_vfs_getattr(&path, &stat);
> >> -    if (rc) {
> >> -            generic_fillattr(user_ns, d_inode(path.dentry), &stat);
> >> -            rc =3D 0;
> >> -    }
> >> -
> >>      /* Check delete pending among previous fp before oplock break */
> >>      if (ksmbd_inode_pending_delete(fp)) {
> >>              rc =3D -EBUSY;
> >> @@ -3114,6 +3108,12 @@ int smb2_open(struct ksmbd_work *work)
> >>              }
> >>      }
> >>
> >> +    rc =3D ksmbd_vfs_getattr(&path, &stat);
> >> +    if (rc) {
> >> +            generic_fillattr(user_ns, d_inode(path.dentry), &stat);
> >> +            rc =3D 0;
> >> +    }
> >> +
> >>      if (stat.result_mask & STATX_BTIME)
> >>              fp->create_time =3D ksmbd_UnixTimeToNT(stat.btime);
> >>      else
> >> @@ -3129,9 +3129,6 @@ int smb2_open(struct ksmbd_work *work)
> >>
> >>      memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
> >>
> >> -    generic_fillattr(user_ns, file_inode(fp->filp),
> >> -                     &stat);
> >> -
> >>      rsp->StructureSize =3D cpu_to_le16(89);
> >>      rcu_read_lock();
> >>      opinfo =3D rcu_dereference(fp->f_opinfo);
> >> --
> >> 2.17.1
> >>
> >>
> >



--
Thanks,
Hyunchul
