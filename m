Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF95EC28D13
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 02:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiHWCp5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Aug 2022 22:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiHWCpu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Aug 2022 22:45:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D395C94D
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 19:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 003BC6123D
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 02:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B45C433C1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661222748;
        bh=i56moucexQByL4XzqIMP/pQ1vEPlQdCMKxUH0LIlp1A=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=J2PmVvW85/8lR2tf/Oh5EOVm3akHpK3jL1+6k6bNw0l0fDAgiLH6B99AKHPcc+NCO
         vN9sqsD/qDlH/H1CtYF2GQy8D9HYxazfSwcMrg5J3lEQmkw8r7sqwUrGAx0vgO5nNw
         H2O+5qk/eQrwBG1S7+SfynVVbw9jg4/p1+GeVQWcKWW6teeVfA2fhKI+5NijddO2dy
         RH9IX3vrnZy5z/vrUsaJ6pukIvYh9MTkg6T2Kwg8H454McoDyzL6u9IofmZQjwCJ7R
         80Uq89OJf5OsQBx3tI8uXtUTPJkX13dgx7NRmHbpLtvbpVDzmBWArTtnrOFxZPiJbK
         N1dX+qpb0XnCw==
Received: by mail-ot1-f52.google.com with SMTP id h9-20020a9d5549000000b0063727299bb4so8979349oti.9
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 19:45:48 -0700 (PDT)
X-Gm-Message-State: ACgBeo1HTsv9Dmn/Twv53nupMQT/v5JSxsxmyoOr+e281dAs08VPU5cL
        jjrxxtl+VjJRp20UHxqeg8onECmJc3p+raev2MI=
X-Google-Smtp-Source: AA6agR6Jv56UGsXnpPOMyd/P/kSCjd2qQvzrs0+Sjbe05oP+ClE0FwTG/p5IdgnK0xKEygr0qIuIFhkUp3MRNiT6KJ8=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr8740195otk.339.1661222747548; Mon, 22
 Aug 2022 19:45:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 22 Aug 2022 19:45:47
 -0700 (PDT)
In-Reply-To: <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
 <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com> <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 23 Aug 2022 11:45:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
Message-ID: <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>> >> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> >> > index 53c91ab02be2..6716c4e3c16d 100644
>> >> >> > --- a/fs/ksmbd/smb2pdu.c
>> >> >> > +++ b/fs/ksmbd/smb2pdu.c
>> >> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work
>> >> >> > *work)
>> >> >> >        */
>> >> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
>> >> >> >               goto no_buf_len;
>> >> >> > -     if (rc == 0)
>> >> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
>> >> >> > -     if (rc == -ENOSPC)
>> >> >> > +     if (rc > 0 || rc == -ENOSPC)
>> >> >> Do you know why -ENOSPC error is ignored ?
>> >> >>
>> >> >
>> >> > I don't know why and can't find the commit history
>> >> > for this.
>> >> After checking if -ENOSPC error is returned, there is no need to leave
>> >> it if it is not needed.
>> >
>> > In most cases, -ENOSPC is not returned. Because the value
>> > is set to the return value from filesystems' iterate or iterate_share,
>> > and most file systems don't allocate disk space for this operation.
>> >
>> > But we cannot guarantee this. So how about changing handling
>> > iterate_dir
>> > like gendents system call. Even if an error code is returned by
>> > iterate_dir,
>> > it treats as normal if several child files are iterated and the buffer
>> > is filled with
>> > information about those.
>> Among the errors of the smb2 query directory in the specification,
>> there is a file corruption error response
>> type(STATUS_FILE_CORRUPT_ERROR).
>> Can you check when smb server return that error response for smb2
>> query directory?
>>
>
> According to MS-REREF, it means "The file or directory is corrupt and
> unreadable.
> Run the chkdsk utility". And there is no function to return the error in
> Samba.
Is samba not able to know corruption errors using getdents syscall as you said?
There is no reason to follow it. I think that ksmbd is able to return
this error.
