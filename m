Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3215AC19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 06:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiHKGUp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 02:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHKGUo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 02:20:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CEF4F6A1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:20:43 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i128-20020a1c3b86000000b003a536d58f73so2181900wma.4
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 23:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=3QLJ61Glp2mehFvVofdH35oSDVVR/FpkivlsI/vM3n8=;
        b=aSs1ERCvJ5RaQuTaCMlGT+87vYsV9t+R0wxVOYrOSG8U93Dsv2Rcm1OBQ1s1ayTaEn
         NbJRK0AJcB7ZM0GtbLjy99uXkmTlA0BLHTm/XD+gtVmwhVyj0kG1pHOS2dlgMvWj+BmO
         IDVYhwt5Y5IGqHR8YcVsRMFz386vzfpKSLIoyIu/TVqHW03q1T3Va9m5/aHrrGQwNIPu
         3mdEjTZHBrw7M/dQLeIIX9ZFeOa3gRy+EGw21P4eT44x5eWjMEemL3qSb3UukOc/iY6L
         +05SP/i7hkCCjeFQZbRS3LYtNbPv3ZHuCc/OUvFhKR3qwWT+HHXZpIAV6bmm31xPRKaA
         62pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=3QLJ61Glp2mehFvVofdH35oSDVVR/FpkivlsI/vM3n8=;
        b=GJGDhQk3IfAaAWwHoy+lAtuKfcrTLNEQ4ZafMO7ZoFX7OottMHfP+P6DhXC4nOCDjd
         ZE6Au4MRE0NIvS2Ee8CPMlnImD1kaI8SSrs4NaIUcivN8sym6vzeGpwtK6rYJQ1lUZ6T
         wvD/BiotmD06L8wNTRtpceC/vOgzfh1iIH8+N1no6FA0qm7zgF0De9ynkIEuXOBFxNKi
         mQM9ay36Ft4gyZccLtDMleBvVu7x68QRPXHIvbAlSOEAWhMwcjdyod61bN3Jq9Ldch28
         +TiY7LVuHpRQl+x7m1ZSHqdU8N84llxCulCDYvmJpjbQ7QRMQYJr2dMBHGjWtBXMQeQv
         +T8w==
X-Gm-Message-State: ACgBeo2fC+lIakZvap2hDIrhgQ3jCTta/YaYXUtbkVE0JOa+7ECepZj3
        s2fgfUD2Le3+qJfE1Lx1tticOCw6KThQ+VzL7h0=
X-Google-Smtp-Source: AA6agR7pAGiDiTDWfW/lx9Wbs7AnI85Iy+SUxUXkT8NntqMj+yUCXlyft76NYtB6rmkzzuWtUQLH4G+o/drZ1Lh92vA=
X-Received: by 2002:a1c:2582:0:b0:3a5:1453:ca55 with SMTP id
 l124-20020a1c2582000000b003a51453ca55mr4371228wml.68.1660198841794; Wed, 10
 Aug 2022 23:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220810010446.9229-1-hyc.lee@gmail.com> <CAKYAXd8vXKY2mp58zc3epFxS7Pp4AZ+ggKh0Rv-rXCLAaQAW1w@mail.gmail.com>
 <CAKYAXd9vaV2dqt=OBP2B_gWHmG16ZYwe0Gts2xxjJto3PuZk6Q@mail.gmail.com>
 <CANFS6bZd5E395Vdfa8Wh2DZkFdxgUxsO=M4kCEpJ2s6OUKW73A@mail.gmail.com>
 <CANFS6bZ3EqBhFCHU=Bhgx+CVMg4Ug7orQSYTagKXCVrLezRxUQ@mail.gmail.com> <CAKYAXd-qMaYVinB-gCVE2GUN_fsBUyThd_kJrT-N53Yy59ew2A@mail.gmail.com>
In-Reply-To: <CAKYAXd-qMaYVinB-gCVE2GUN_fsBUyThd_kJrT-N53Yy59ew2A@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 11 Aug 2022 15:20:30 +0900
Message-ID: <CANFS6bZnYQYHJAEfTCfov5b69vvZs2CQ4ukSwGoDjPxh8GKi_w@mail.gmail.com>
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

2022=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 2:46, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-11 14:32 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2022=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 8:1=
8, Hyunchul Lee <hyc.lee@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >> 2022=EB=85=84 8=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 5:=
00, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >> >
> >> > 2022-08-10 16:58 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> >> > > 2022-08-10 10:04 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > >> Move the call of ksmbd_vfs_getattr above the place
> >> > >> where stat is needed, and remove unnecessary
> >> > >> the call of generic_fillattr.
> >> > >>
> >> > >> This patch fixes wrong AllocationSize of SMB2_CREATE
> >> > >> response. Because ext4 updates inode->i_blocks only
> >> > >> when disk space is allocated, generic_fillattr does
> >> > >> not set stat.blocks properly for delayed allocation.
> >> > And how can I reproduce problem and make sure that it is improved?
> >>
> >> This issue can be reproduce with commands below:
> >>
> >> touch ${FILENAME}
> >> xfs_io -c "pwrite -S 0xAB 0 40k" ${FILENAME}
> >> xfs_io -c "stat" ${FILENAME}
> >>
> >> 40KB are written, but the number of blocks are 8
> >> stat.size =3D 40960
> >> stat.blocks =3D 8
> >>
> >> > > So what causes delay allocation between the lines you moved this
> >> > > code?
> >>
> >> For the example above, the second command writes 40KB but
> >> inode->i_blocks is not  updated because of delayed allocation.
> >> And when the third command is executed, in smb2_open
> >> ksmbd_vfs_getattr returns stat.blocks which is 80, but
> >> the following generic_fillattr returns stat.blocks which
> >> 8.
> >>
> >> With this patch applied, the third command returns stat.blocks
> >> which is 88, not 80.
> >> I will look into this.
> >>
> >
> > This is not a problem and happens only when acl_xattr config is enabled=
.
> > If the config is enabled. The security descriptor is written to xattr
> > as not inline,
> > and the blocks for xattr are counted.
> Okay, The The patch description seems to be wrong.
> You describe that unneeded generic_fillattr call cause this problem,
> not moving the call of ksmbd_vfs_getattr() in patch description. Right
> ?

Right, I will update the description.

> >
> >>
> >>
> >> > >
> >> > >> But ext4 returns the blocks that include the delayed
> >> > >> allocation blocks when getattr is called.
> >> > >>
> >> > >> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> > >> ---
> >> > >> Changes from v1:
> >> > >>  - Update the commit description.
> >> > >>
> >> > >>  fs/ksmbd/smb2pdu.c | 15 ++++++---------
> >> > >>  1 file changed, 6 insertions(+), 9 deletions(-)
> >> > >>
> >> > >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> > >> index e6f4ccc12f49..7b4bd0d81133 100644
> >> > >> --- a/fs/ksmbd/smb2pdu.c
> >> > >> +++ b/fs/ksmbd/smb2pdu.c
> >> > >> @@ -3022,12 +3022,6 @@ int smb2_open(struct ksmbd_work *work)
> >> > >>      list_add(&fp->node, &fp->f_ci->m_fp_list);
> >> > >>      write_unlock(&fp->f_ci->m_lock);
> >> > >>
> >> > >> -    rc =3D ksmbd_vfs_getattr(&path, &stat);
> >> > >> -    if (rc) {
> >> > >> -            generic_fillattr(user_ns, d_inode(path.dentry), &sta=
t);
> >> > >> -            rc =3D 0;
> >> > >> -    }
> >> > >> -
> >> > >>      /* Check delete pending among previous fp before oplock brea=
k
> >> > >> */
> >> > >>      if (ksmbd_inode_pending_delete(fp)) {
> >> > >>              rc =3D -EBUSY;
> >> > >> @@ -3114,6 +3108,12 @@ int smb2_open(struct ksmbd_work *work)
> >> > >>              }
> >> > >>      }
> >> > >>
> >> > >> +    rc =3D ksmbd_vfs_getattr(&path, &stat);
> >> > >> +    if (rc) {
> >> > >> +            generic_fillattr(user_ns, d_inode(path.dentry), &sta=
t);
> >> > >> +            rc =3D 0;
> >> > >> +    }
> >> > >> +
> >> > >>      if (stat.result_mask & STATX_BTIME)
> >> > >>              fp->create_time =3D ksmbd_UnixTimeToNT(stat.btime);
> >> > >>      else
> >> > >> @@ -3129,9 +3129,6 @@ int smb2_open(struct ksmbd_work *work)
> >> > >>
> >> > >>      memcpy(fp->client_guid, conn->ClientGUID,
> >> > >> SMB2_CLIENT_GUID_SIZE);
> >> > >>
> >> > >> -    generic_fillattr(user_ns, file_inode(fp->filp),
> >> > >> -                     &stat);
> >> > >> -
> >> > >>      rsp->StructureSize =3D cpu_to_le16(89);
> >> > >>      rcu_read_lock();
> >> > >>      opinfo =3D rcu_dereference(fp->f_opinfo);
> >> > >> --
> >> > >> 2.17.1
> >> > >>
> >> > >>
> >> > >
> >>
> >>
> >>
> >> --
> >> Thanks,
> >> Hyunchul
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--=20
Thanks,
Hyunchul
