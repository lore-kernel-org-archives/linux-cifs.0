Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72904C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505AA610E9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhIGIKS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240557AbhIGIKP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 Sep 2021 04:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4EA61101;
        Tue,  7 Sep 2021 08:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631002149;
        bh=wS5+vNhvHo2yo+lryUf8IHLrr52OMjP8gvUBF+h4y0c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Hpz5C2rd4mnu5DcfXQql8blTkKcL8o+nOwpkFN/t0WC7muNTPKTI9t5xZmcc2ezTG
         VTD7vsbmsv0ftY5DMssNM4W8Q3J1w0qFapQpkZuBi87ebSPm244z3Zzh951W2WL+00
         l5L9GzkGjls31n9MFn+ejUffXN9lQUsP0VwAVwAL5UwAIdJ/M9ueZdAEN8QeFYTUMW
         fTefVGY9lK9Jhq0aKgjmkG9ekFqMdpAXdfoB1a1CNHj0chJYUMs/dter9jvfgBiHmA
         V0XVifN6WVdBnBzRdeHzjgETQTpoWpxyhTSOq1DH4vL3sHiGUolsgqNzVcgszaQw+p
         FljhCii1Cc+kA==
Received: by mail-ot1-f51.google.com with SMTP id x10-20020a056830408a00b004f26cead745so11763631ott.10;
        Tue, 07 Sep 2021 01:09:09 -0700 (PDT)
X-Gm-Message-State: AOAM533JKAOMIT5mx3kQ77YMm2FWCLPZRxeysO0scByPX7IAs5LWtqwf
        mANTd8VYpNv2JuUeS8tL1t+3N7n7rg1RKpK0gbU=
X-Google-Smtp-Source: ABdhPJwxyGUQvU2FYL9SCmgKzfrj3MsfRA9+5L2alGeMzHqXgCBbPrFSz1Ge0ncsqrOWtzOJG6pibQ+zkKE6nseUxqo=
X-Received: by 2002:a9d:6c04:: with SMTP id f4mr13755850otq.185.1631002149169;
 Tue, 07 Sep 2021 01:09:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Tue, 7 Sep 2021 01:09:08 -0700 (PDT)
In-Reply-To: <YTccRzi/j+7t2eB9@google.com>
References: <20210907073340.GC18254@kili> <YTccRzi/j+7t2eB9@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 7 Sep 2021 17:09:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
Message-ID: <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: potential uninitialized error code in set_file_basic_info()
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-07 17:01 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (21/09/07 10:33), Dan Carpenter wrote:
>>
>> Smatch complains that there are some paths where "rc" is not set.
>>
>> Fixes: eb5784f0c6ef ("ksmbd: ensure error is surfaced in
>> set_file_basic_info()")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>>  fs/ksmbd/smb2pdu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index a350e1cef7f4..c86164dc70bb 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -5444,7 +5444,7 @@ static int set_file_basic_info(struct ksmbd_file
>> *fp, char *buf,
>>  	struct file *filp;
>>  	struct inode *inode;
>>  	struct user_namespace *user_ns;
>> -	int rc;
>> +	int rc = 0;
>>
>>  	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
>>  		return -EACCES;
>
> It sort of feels like that `rc' is not needed there at all. It's being used
> in
>
>                rc = ksmbd_vfs_set_dos_attrib_xattr(user_ns,
>                                                    filp->f_path.dentry,
> &da);
>                if (rc)
>                       ksmbd_debug(SMB,
>                                  "failed to restore file attribute in
> EA\n");
>
> and in
>
>                rc = setattr_prepare(user_ns, dentry, &attrs);
>                if (rc)
>                         return -EINVAL;
>
> Either it should be used more, and probably be a return value, or we can
> just remove it.
This patch is correct. But I have already fixed it.
You can understand it if you check #ksmbd-for-next branch, not master.

https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next

Thanks!
>
