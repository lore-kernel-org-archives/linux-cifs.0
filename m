Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B61C00140
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Aug 2022 02:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiHVCrr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Aug 2022 22:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiHVCrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Aug 2022 22:47:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25E3240BF
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 19:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A2BFCE0E04
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 02:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CABC433C1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661136461;
        bh=lGud2A5qm38W7wLmuJW4W5FndrEc0HWprdf35x8GMzU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=XaE7bViobmIXS4bgeKygWTrdAfYBiZ2uj7nHo62e1Ssak0W3e+cft1U+79zolfIu9
         M/fqETZUZnaLoFUmhWs2WtBXFw1N4wYKvYudgmOgw1hJDwHWNz0CoUUJrVBs0wtLcS
         ZRl9KO0PjuhuKitqByjxIvgSRRRPvJqftFoOasm7UY7/iKIk/bIG6FiursoVzgGoyX
         pU8d/rAxxDeh8WEwKxF4EL8L3Fb7Bcitb7fds08arYKNrWswaE3C1ST3TRMtMNN5EQ
         uiBy3CyGsnXOAYFKWabBlgDDuL0+ObmY9RbPpYtVE4jtCOj55Ct57HhD2UUDt46AI6
         dEbmwYPTEO/7w==
Received: by mail-oi1-f173.google.com with SMTP id w196so10765252oiw.10
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 19:47:41 -0700 (PDT)
X-Gm-Message-State: ACgBeo031JLmbaJGLju1IGmoPMj0KmzqB2Nb70vtmop60tyesh0BStN/
        DplQOlG2gTqAWsm6yJEI0aNpLKkycTJyuxCQcKM=
X-Google-Smtp-Source: AA6agR50M2Y1kM9DT7Z1mDjlFLnEnw6w+a8mKjs4sq2bVBLgELf2TVlqsKRNvQKprJzxEymfHxUIrnZuBqvbGFQw94E=
X-Received: by 2002:a54:4696:0:b0:343:46c5:9b2c with SMTP id
 k22-20020a544696000000b0034346c59b2cmr10545862oic.8.1661136460497; Sun, 21
 Aug 2022 19:47:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 21 Aug 2022 19:47:40
 -0700 (PDT)
In-Reply-To: <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 22 Aug 2022 11:47:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
Message-ID: <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-22 11:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 9:51,=
 Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > if iterate_dir() returns non-negative value,
>> > caller has to treat it as normal and
>> > check there is any error while populating
>> > dentry information. ksmbd doesn't have to
>> > do anything because ksmbd already
>> > checks too small OutputBufferLength to
>> > store one file information.
>> >
>> > And because ctx->pos is set to file->f_pos
>> > when iterative_dir is called, remove
>> > restart_ctx().
>> Shouldn't we get rid of the useless restart_ctx() ?
>>
>
> There is one place to call this function. We can
> replace that with ctx->pos =3D 0 and remove this function.
Why should we do ctx->pos =3D 0 there ?
>
>> >
>> > This patch fixes some failure of
>> > SMB2_QUERY_DIRECTORY, which happens when
>> > ntfs3 is local filesystem.
>> >
>> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> > ---
>> >  fs/ksmbd/smb2pdu.c | 6 ++----
>> >  1 file changed, 2 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> > index 53c91ab02be2..6716c4e3c16d 100644
>> > --- a/fs/ksmbd/smb2pdu.c
>> > +++ b/fs/ksmbd/smb2pdu.c
>> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
>> >        */
>> >       if (!d_info.out_buf_len && !d_info.num_entry)
>> >               goto no_buf_len;
>> > -     if (rc =3D=3D 0)
>> > -             restart_ctx(&dir_fp->readdir_data.ctx);
>> > -     if (rc =3D=3D -ENOSPC)
>> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
>> Do you know why -ENOSPC error is ignored ?
>>
>
> I don't know why and can't find the commit history
> for this.
After checking if -ENOSPC error is returned, there is no need to leave
it if it is not needed.
>
>> Thanks.
>> >               rc =3D 0;
>> > -     if (rc)
>> > +     else if (rc)
>> >               goto err_out;
>> >
>> >       d_info.wptr =3D d_info.rptr;
>> > --
>> > 2.17.1
>> >
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
