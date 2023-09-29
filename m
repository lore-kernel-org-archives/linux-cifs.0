Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17955E743D0
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Sep 2023 00:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjI2AS1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Sep 2023 20:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2AS1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Sep 2023 20:18:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC3598
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 17:18:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E111C433C9
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 00:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695946704;
        bh=jvqYQYuLRbxtRr1dWjrqf3kNxsmZlobYt6zGnzmyU+g=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gvGvnEesG+MvQv93qK4mPCROFfLTV1Sr1oIr7E58zGCRrm5rVLgTpB7+2hvxM6qSd
         qlK+n6BVBvwDGUQKr0k+KuqNDVrsjRuqb+p6agY9lLf48mF/Q43hdTSGhHpmVQalbL
         7dDOfG/OSU9ECcla+dRlQ5f0gbDWyRUlaMd4cEDUE6/jzJISNU0Z7/rx4aD+FabpLK
         r1ItbSshalgCFSTBtZHn44v2o5x0pW/RMh21+hidfjddHKqFyGQs81Drk/Pc6q3SnL
         oV2Dz6k23m3CgrdIzq3qCc0BG6biM3SueSz8WEpzjMLL/CuVRYh5XOPx8IyX8mvPOq
         AQ/YtvXV9+NaQ==
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-57babef76deso4879218eaf.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 17:18:24 -0700 (PDT)
X-Gm-Message-State: AOJu0YwdLnHddt2JhoZwI2tXph8h5x3MQf08A7Gkb5zXGuWlILdll4uI
        rCbQ9FbnbpaGEaMJJmfNLruY6XBi+Q/t6GpZlt0=
X-Google-Smtp-Source: AGHT+IH+XRxMc3pGLOmor/z2qp6KdBIxePnJFgkGo2Es6GTh8iRQKin6Blhx8K1y4bkyN/xGREJaFDtIDotO+2e9OnA=
X-Received: by 2002:a4a:2503:0:b0:57d:e5e7:6d02 with SMTP id
 g3-20020a4a2503000000b0057de5e76d02mr2706520ooa.5.1695946703744; Thu, 28 Sep
 2023 17:18:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:4ce:0:b0:4fa:bc5a:10a5 with HTTP; Thu, 28 Sep 2023
 17:18:22 -0700 (PDT)
In-Reply-To: <d7dd886e-0669-b3b5-5561-638b78dadbc4@talpey.com>
References: <20230927143009.8882-1-linkinjeon@kernel.org> <6f702d13-6473-844a-5873-9c70c909ca8b@talpey.com>
 <CAKYAXd8T7Rc1wh_aM0wyz7L7Mc-g0AYfbqHfjQ8mBe7fmMmYaQ@mail.gmail.com> <d7dd886e-0669-b3b5-5561-638b78dadbc4@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 29 Sep 2023 09:18:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8GKDRQ_WJj-kaa67kHM4dX0V2GK37zkbt=nW=D3cE4qw@mail.gmail.com>
Message-ID: <CAKYAXd8GKDRQ_WJj-kaa67kHM4dX0V2GK37zkbt=nW=D3cE4qw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: not allow to open file if delelete on close bit is set
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-29 1:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/28/2023 11:51 AM, Namjae Jeon wrote:
>> 2023-09-29 0:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/27/2023 10:30 AM, Namjae Jeon wrote:
>>>> Cthon test fail with the following error.
>>>>
>>>> check for proper open/unlink operation
>>>> nfsjunk files before unlink:
>>>>     -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>>>> ./nfs2y8Jm9 open; unlink ret =3D 0
>>>> nfsjunk files after unlink:
>>>>     -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>>>> data compare ok
>>>> nfsjunk files after close:
>>>>     ls: cannot access './nfs2y8Jm9': No such file or directory
>>>> special tests failed
>>>>
>>>> Cthon expect to second unlink failure when file is already unlinked.
>>>> ksmbd can not allow to open file if flags of ksmbd inode is set with
>>>> S_DEL_ON_CLS flags.
>>>>
>>>> Reported-by: Tom Talpey <tom@talpey.com>
>>>
>>> I don't remember reporting this.
>> You told me basic test of cthon run fine but special test fail.
>
> Well yes but I didn't say the failure was incorrect. Connectathon is
> a useful test, but it's not a protocol test. What makes it handy for
> me is that it's easy to deploy and run, and it is not a synthetic
> client, that is, it makes ordinary syscalls and exercices the local
> in-kernel client code.
>
> The "special" tests in particular are about NFS client quirks, and
> specifically quirks that were interesting in, like, 1999. They need
> to be taken with a huge lump of salt, and an even larger lump today.
>
> It's ok, I'm not concerned that you added my Reported-by. But it needs
> a lot more research before pushing this upstream.
I started looking into this problem because you described it as if
ksmbd was having problems even on TCP when running a special test. And
the op_unk test, one of the special tests in cthon, passed against
samba but failed against ksmbd, so I was trying to figure out the
cause. The cthon test does not appear to be test for only NFS. Because
these tests exclude NFS (and Posix) semantics depending on the WIN32
and CIFS configure.
>
> Tom.
>
>>> But more fundamentally, the Connectathon test is an NFS exerciser, and
>>> specific to NFS (and Posix) semantics. Delete-on-last-close is not one
>>> of them.
>>>
>>> Won't failing a new open break Windows semantics if it's enforced by
>>> default? Normally Windows checks for FILE_SHARE_DELETE before deciding
>>> this. Maybe other checks as well...
>>>
>>> Tom.
>>>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/smb/server/vfs_cache.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>>>> index f41f8d6108ce..f2e2a7cc24a9 100644
>>>> --- a/fs/smb/server/vfs_cache.c
>>>> +++ b/fs/smb/server/vfs_cache.c
>>>> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_wor=
k
>>>> *work, struct file *filp)
>>>>    		goto err_out;
>>>>    	}
>>>>
>>>> +	if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
>>>> +		ret =3D -ENOENT;
>>>> +		goto err_out;
>>>> +	}
>>>> +
>>>>    	ret =3D __open_id(&work->sess->file_table, fp,
>>>> OPEN_ID_TYPE_VOLATILE_ID);
>>>>    	if (ret) {
>>>>    		ksmbd_inode_put(fp->f_ci);
>>>
>>
>
