Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C82EC32793
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 00:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiHXAKy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 20:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiHXAKx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 20:10:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3751754A5
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 17:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58FCCB8223C
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 00:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1314AC433B5
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 00:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661299850;
        bh=iFD2O07plg5rISJzKqzScAzT4KZ+8SFcUxbbwlon8Dw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=j7UorFX4Uqa6YoObrRm+4O+GfIv4M9xbrHmz1YN5JCmAIIofVuEYjLYvENBP1De2K
         7F3c+okmbSMNe4lnUPfpbNot/HKY6Qhujx3VaPyCOezL9R8lwZNzYy8KwYGUVrtyIc
         s9vqC2DSlDkgxWZn397mk7WzUgQClaKZKjWzKKgmm7Rl7R4OwVryXEZjt3EjXnokp5
         f09mte59KO5kJ9ab3kCPVMKYo/6Kz1DjdLARsCxE6Ji7HjLula8XH1Z9rdvvv8nVhd
         qM43VKdVl1V6E/xnOsUD9+uuRvZtt06VyMk2xKkhAzIBaUsyToaRwLqkJJwUNseu8P
         i9Rok6vQgrhwg==
Received: by mail-oi1-f178.google.com with SMTP id j5so17887775oih.6
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 17:10:50 -0700 (PDT)
X-Gm-Message-State: ACgBeo2g0hzYiRxZi0XXIIvKNnpLpEe947S1icY2U6GE3nGixrHIpeyn
        4QQ2a5bMBOJFFU2OKj1RejzDNG172gmPwAvlnj0=
X-Google-Smtp-Source: AA6agR4Hvx9LRJk6+GJNfjcbRH3q18DH5LXNguQCkbOA0McC/JPkwumR9F1OkXYSNgHtuW2io9QmLOJCRrZSpevLtXQ=
X-Received: by 2002:a05:6808:14d5:b0:344:8f50:1f0f with SMTP id
 f21-20020a05680814d500b003448f501f0fmr2379103oiw.257.1661299849100; Tue, 23
 Aug 2022 17:10:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 23 Aug 2022 17:10:48
 -0700 (PDT)
In-Reply-To: <CANFS6bbwZDGhB4Dp+A192U=S1VfWa0091OBvmxhTB_C4BPz7sA@mail.gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
 <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
 <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
 <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com> <CANFS6bbwZDGhB4Dp+A192U=S1VfWa0091OBvmxhTB_C4BPz7sA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 24 Aug 2022 09:10:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_7p1gmV+3HZE9v+biUxRPzoNL7-cqRpfY8yCFHik7M5g@mail.gmail.com>
Message-ID: <CAKYAXd_7p1gmV+3HZE9v+biUxRPzoNL7-cqRpfY8yCFHik7M5g@mail.gmail.com>
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

2022-08-23 17:26 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 8=EC=9B=94 23=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 11:45=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> >> >> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> >> >> > index 53c91ab02be2..6716c4e3c16d 100644
>> >> >> >> > --- a/fs/ksmbd/smb2pdu.c
>> >> >> >> > +++ b/fs/ksmbd/smb2pdu.c
>> >> >> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work
>> >> >> >> > *work)
>> >> >> >> >        */
>> >> >> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
>> >> >> >> >               goto no_buf_len;
>> >> >> >> > -     if (rc =3D=3D 0)
>> >> >> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
>> >> >> >> > -     if (rc =3D=3D -ENOSPC)
>> >> >> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
>> >> >> >> Do you know why -ENOSPC error is ignored ?
>> >> >> >>
>> >> >> >
>> >> >> > I don't know why and can't find the commit history
>> >> >> > for this.
>> >> >> After checking if -ENOSPC error is returned, there is no need to
>> >> >> leave
>> >> >> it if it is not needed.
>> >> >
>> >> > In most cases, -ENOSPC is not returned. Because the value
>> >> > is set to the return value from filesystems' iterate or
>> >> > iterate_share,
>> >> > and most file systems don't allocate disk space for this operation.
>> >> >
>> >> > But we cannot guarantee this. So how about changing handling
>> >> > iterate_dir
>> >> > like gendents system call. Even if an error code is returned by
>> >> > iterate_dir,
>> >> > it treats as normal if several child files are iterated and the
>> >> > buffer
>> >> > is filled with
>> >> > information about those.
>> >> Among the errors of the smb2 query directory in the specification,
>> >> there is a file corruption error response
>> >> type(STATUS_FILE_CORRUPT_ERROR).
>> >> Can you check when smb server return that error response for smb2
>> >> query directory?
>> >>
>> >
>> > According to MS-REREF, it means "The file or directory is corrupt and
>> > unreadable.
>> > Run the chkdsk utility". And there is no function to return the error
>> > in
>> > Samba.
>> Is samba not able to know corruption errors using getdents syscall as yo=
u
>> said?
>
> If iterate_dir returns an error and there are files iterated, getdents
> syscall will succeed.
> But if a client requests SMB2_QUERY_DIR again due to STATUS_NO_MORE_FILES
> absence of the last response, iterate_dir returns an error again and
> there are no
> files iterated, getdents syscall will fail. Samba can send a response
> with an error.
Sorry, can't understand. What error ?
>
>> There is no reason to follow it. I think that ksmbd is able to return
>> this error.
>
> Can we determine we should return a response with STATUS_FILE_CORRUPT_ERR=
OR
> if iterate_dir returns -EIO?
STATUS_FILE_CORRUPT_ERROR is still not cleared. want to know how
windows server handle it.
>
> --
> Thanks,
> Hyunchul
>
