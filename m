Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE303E7F156
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Sep 2023 10:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjI2Kt2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjI2Kt2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Sep 2023 06:49:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3627139
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 03:49:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA25C433C9
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 10:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695984565;
        bh=BVOZcLRf6OV7BE4aQfaX5rLhfZ1x6z92C9tN8NuM7FY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mJCtNi5mxYF91Csa+j1QBcJ1qaREzdnxxCnVGt1Hke/D6Z9zVW3MzAcXoIcLXgHNi
         6x4cJjlwiNkb0Hq21GXEeFCb2u/e62T6bB01CRpfgGfqezCqNlR6pfejtrE6saIX2A
         6rByR8wMN2GFEno8eKddd3PfBVq/PPGYVj7iA8aK54Qx2n4FzF5V+7m4cZmnrwqszO
         81qEEW3x6D38I61wwa1XimzQGHlarUrAG1MMlNhocCMhe4dYYcXlk6GbFN4d+XmSgz
         goxSlCqCEg6tSukM5DRhUW75YbZD0tbWy5fPqjrDotuf76kZyNw8m+2CMj4Zor8pLr
         KV/lsHDylSLLw==
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-57bbb38d5d4so4687263eaf.2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 03:49:25 -0700 (PDT)
X-Gm-Message-State: AOJu0YwrGoobCS7M2qh6Jy9BmXERnOhqCRHlRIe7r0mkevJ3BnAzWxvV
        XqTUB6GszwQh13gNOWf9FRo0u4lLS94oX5hVyNk=
X-Google-Smtp-Source: AGHT+IEkyL4t6ZJwoMdAweS3mI5HLWjYHJnGWIBVY7D3zisJYjHw/B4wyicfSFFAIi89S6loWrdfVvo7+xKT3xtqRGU=
X-Received: by 2002:a05:6808:b1a:b0:3ae:554b:6c57 with SMTP id
 s26-20020a0568080b1a00b003ae554b6c57mr3482788oij.11.1695984564740; Fri, 29
 Sep 2023 03:49:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6614:0:b0:4fa:bc5a:10a5 with HTTP; Fri, 29 Sep 2023
 03:49:23 -0700 (PDT)
In-Reply-To: <CAN05THR3RJmvqYwjrEY=g0bbVZj-hHNCsRO3o6dt9nrBKjpMsA@mail.gmail.com>
References: <20230927143009.8882-1-linkinjeon@kernel.org> <CAN05THR3RJmvqYwjrEY=g0bbVZj-hHNCsRO3o6dt9nrBKjpMsA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 29 Sep 2023 19:49:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-GYLMO1tHHdEKvM-6aA8mXrvFRjeDZghm9YAUsCKNwHg@mail.gmail.com>
Message-ID: <CAKYAXd-GYLMO1tHHdEKvM-6aA8mXrvFRjeDZghm9YAUsCKNwHg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: not allow to open file if delelete on close bit is set
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-29 10:13 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Thu, 28 Sept 2023 at 00:44, Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> Cthon test fail with the following error.
>>
>> check for proper open/unlink operation
>> nfsjunk files before unlink:
>>   -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>> ./nfs2y8Jm9 open; unlink ret =3D 0
>> nfsjunk files after unlink:
>>   -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>> data compare ok
>> nfsjunk files after close:
>>   ls: cannot access './nfs2y8Jm9': No such file or directory
>> special tests failed
>>
>> Cthon expect to second unlink failure when file is already unlinked.
>> ksmbd can not allow to open file if flags of ksmbd inode is set with
>> S_DEL_ON_CLS flags.
>>
>> Reported-by: Tom Talpey <tom@talpey.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/smb/server/vfs_cache.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>> index f41f8d6108ce..f2e2a7cc24a9 100644
>> --- a/fs/smb/server/vfs_cache.c
>> +++ b/fs/smb/server/vfs_cache.c
>> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work
>> *work, struct file *filp)
>>                 goto err_out;
>>         }
>>
>> +       if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
>> +               ret =3D -ENOENT;
>> +               goto err_out;
>> +       }
>> +
>
> Is enoent the right error here? I assume that the file will still show
No, It should be STATUS_DELETE_PENDING error.
> in a directory listing so maybe eacces would be better?
Right. but it should not be STATUS_ACCESS_DENIED error.
So I will change the patch to return STATUS_DELETE_PENDING error to
client on v2.

Thanks for your review!
>
>
>>         ret =3D __open_id(&work->sess->file_table, fp,
>> OPEN_ID_TYPE_VOLATILE_ID);
>>         if (ret) {
>>                 ksmbd_inode_put(fp->f_ci);
>> --
>> 2.25.1
>>
>
