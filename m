Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4697AC7EE21
	for <linux-cifs@archiver.kernel.org>; Sat,  6 May 2023 04:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjEFEvv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 May 2023 00:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjEFEvu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 May 2023 00:51:50 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099125FEC
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 21:51:49 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4efd6e26585so2901041e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 21:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683348707; x=1685940707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kB79iXMO9CyecyXes/5tugqLjS0XaqJrSrZzLS7qBbM=;
        b=WuK5FqAhsfVMlFerRxINzPC7HdvpsPYmCI/m5XE/p/GRiC/2O6J+bt5+UZwCLaaIVL
         RFvnBMsOCfzWQlPQaq3J4PBDt4S8iFNwoBm6Wy8PLLi1wH05LYnR45y/NVzl46KCa9Aa
         cJIpBgLkm4snh/HQNLbdMT84wj5WCoOxEvwlfznZKPng/BIEeW6JtRpwjwvVAnJfSALn
         0IAIVUtUb466xsH2esiAkw3/tsBw7JFog8bcvEv90pwc4OGkRIayAYNc/9W7gYvSy5aV
         YXHxW+Ru1MkDA6YsilBsHjId4UZxUFJllvWQD3znfFH8+xShQB4QuqiVoLAiY2qAWdyU
         tzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683348707; x=1685940707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kB79iXMO9CyecyXes/5tugqLjS0XaqJrSrZzLS7qBbM=;
        b=EWRRXkfsG2bczVkuO1nxWKqTpsIn0Iv7HuoZQ5nUbD5969xMUH2Jp8iWa3wvRUpFc1
         Upi6XGgc7KKUAdsnBiXPURU4yLtxrdHfF/0V/SivdMLHlvbtpxTXvTe0TR1fZl2IxRGG
         rS5R7jL+G3ACilOvNo0Uaus0Yl6soK9vQoBTrEw4ptm9g/MOXsOkJuSUAFIkkn3RipGH
         mwpxDe3shLRAo39yNjmxnZbEpmmgC5VpaSYN3UnJJ4F7hz+yOcLyUGOaYeV2wgYpPVDo
         9RzfoeErNQAuQJ8Yy51nYolF1Rt8rpXwKf24F8snoH4eR9H8TAfUC0Ntrk3DqnbKl3CW
         KBrg==
X-Gm-Message-State: AC+VfDz/wz3jh4fUFs7hvpzsJpMh2MBaXfqCWvnawB4mTKVb7PWJ/oBw
        ytsivImgUG/JhltJg7u9i5Bw3HUDuFu/75yEB3k=
X-Google-Smtp-Source: ACHHUZ6kh9t/PmS0Aj9HrEi0janpKofn53HPt9zpG/egUpPZZjPZaJfNyK6tvmZkyBnJ8hnXrQGZMADruKKu9oyP6pI=
X-Received: by 2002:a05:6512:3742:b0:4e8:43e2:a8 with SMTP id
 a2-20020a056512374200b004e843e200a8mr981627lfs.8.1683348707050; Fri, 05 May
 2023 21:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com>
 <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
 <824c8a05-4c68-119e-45a9-504ea0aa8583@gmail.com> <CAH2r5mvCCY=VT9ZUkjz4c+QGZ0MjR4ggdG56QUa-apZ7eoeo0A@mail.gmail.com>
 <CAH2r5muOMc1ks+RJeC0uV30pwgH7iaUeag0C5=4biy8dHURkdA@mail.gmail.com>
In-Reply-To: <CAH2r5muOMc1ks+RJeC0uV30pwgH7iaUeag0C5=4biy8dHURkdA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 May 2023 23:51:35 -0500
Message-ID: <CAH2r5muUUTxNesxPRO=2TRDSZ7GFqTLJxEpmaYWj2aTzEps1Ng@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To:     Pawel Witek <pawel.ireneusz.witek@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was also able to reproduce it by using xfs_io to execute copy_range
on a file of exactly 4GB and verified that the patches (both versions)
fix it.

On Fri, May 5, 2023 at 11:49=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Wouldn't it be safer (since pcchunk->Length is a u32 to do the
> following minor change to your patch
>
>                 pcchunk->Length =3D
> -                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk=
));
> +                       cpu_to_le32(min_t(u64, len, tcon->max_bytes_chunk=
));
>
> Also added Cc: stable and Fixes: tags.  See attached.
>
> On Fri, May 5, 2023 at 2:48=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > Good catch
> >
> > On Fri, May 5, 2023, 14:31 Pawel Witek <pawel.ireneusz.witek@gmail.com>=
 wrote:
> >>
> >> I've tried to copy a 5 GB file which resulted in -EINVAL (same for lar=
ger
> >> files). After wiresharking the protocol I've observed that one packet
> >> requests ioctl with 'Transfer Length: 0', to which the server responde=
d
> >> with an error. Some investigation showed, that this happens when
> >> len=3D4294967296.
> >>
> >> On 5/5/23 18:47, Steve French wrote:
> >> > since pcchunk->Length is a 32 bit field doing cpu_to_le64 seems wron=
g.
> >> >
> >> > Perhaps one option is to split this into two lines do the minimum(u6=
4, len, tcon->max_bytes_chunk) on one line and the cpu_to_le32 of the resul=
t on the next
> >> >
> >> > What is "len" in the example you see failing?
> >> >
> >> > On Fri, May 5, 2023 at 10:15=E2=80=AFAM Pawel Witek <pawel.ireneusz.=
witek@gmail.com <mailto:pawel.ireneusz.witek@gmail.com>> wrote:
> >> >
> >> >     Change type of pcchunk->Length from u32 to u64 to match
> >> >     smb2_copychunk_range arguments type. Fixes the problem where per=
forming
> >> >     server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in =
incomplete
> >> >     copy of large files while returning -EINVAL.
> >> >
> >> >     Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com <mail=
to:pawel.ireneusz.witek@gmail.com>>
> >> >     ---
> >> >      fs/cifs/smb2ops.c | 2 +-
> >> >      1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> >     diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> >> >     index a81758225fcd..35c7c35882c9 100644
> >> >     --- a/fs/cifs/smb2ops.c
> >> >     +++ b/fs/cifs/smb2ops.c
> >> >     @@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xi=
d,
> >> >                     pcchunk->SourceOffset =3D cpu_to_le64(src_off);
> >> >                     pcchunk->TargetOffset =3D cpu_to_le64(dest_off);
> >> >                     pcchunk->Length =3D
> >> >     -                       cpu_to_le32(min_t(u32, len, tcon->max_by=
tes_chunk));
> >> >     +                       cpu_to_le64(min_t(u64, len, tcon->max_by=
tes_chunk));
> >> >
> >> >                     /* Request server copy to target from src identi=
fied by key */
> >> >                     kfree(retbuf);
> >> >     --
> >> >     2.40.1
> >> >
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
