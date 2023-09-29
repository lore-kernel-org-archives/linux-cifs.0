Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E1CE743D2
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Sep 2023 00:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjI2AEm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Sep 2023 20:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjI2AEm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Sep 2023 20:04:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB8AF3
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 17:04:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A6C433C7
        for <linux-cifs@vger.kernel.org>; Fri, 29 Sep 2023 00:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695945880;
        bh=UIlzZry14zLzYGIQTR1kfwq59JNmXY2K1hrWm/A+REo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=urRnhfR6sTF/8MjIthLY7WS/xL0cCyC887ZVNJcdEAD/v+n/lBqiXOpEJQ+zz1uyy
         SMQgwbcuoW09gf3jzVi+RfT+Nm9Ree9NR0+fZsAjF5fudeNCVQHrtbzFxX3obYXqlZ
         zz7B8/2ZGF4mwMZzkzYJCY3Fi5W7nIzCTLjQ6JEtx8oQ03RuvkkvsdK7jWvhLs9Lqz
         ocNzBlJXKRQSCIzFSQyamaqyJf4PdqxFDXaUBvMbX18w5sjCVst0LaFaDG6Qk0ltkn
         N4CSBQN27NsdSUaCDxERZtdwJEs92ynyR3BoqMym/txxgdnCtZivCjIdxsi2OZNjTB
         ZZzt3ZODVCdmA==
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-57b5f0d658dso6773637eaf.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 17:04:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YyRCua7lZrYjNCI2Vcs6rtXXf8OwzWiljzy5mzYoVYDf/CaRIN5
        dCk8+f8OuspQxxUhv7fvUVUJDqtsmcnMesEYPWI=
X-Google-Smtp-Source: AGHT+IHIcvsmn1GuanrYe9jsmeuzCy/VZjxB0N676jOvMq2WjAR8U5Pn9gIV/vWkGVuYrUrr/iagwICGOUkJB1CyLWo=
X-Received: by 2002:a4a:9b0b:0:b0:57b:5a55:2bba with SMTP id
 a11-20020a4a9b0b000000b0057b5a552bbamr2679619ook.2.1695945879570; Thu, 28 Sep
 2023 17:04:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:4ce:0:b0:4fa:bc5a:10a5 with HTTP; Thu, 28 Sep 2023
 17:04:38 -0700 (PDT)
In-Reply-To: <6f702d13-6473-844a-5873-9c70c909ca8b@talpey.com>
References: <20230927143009.8882-1-linkinjeon@kernel.org> <6f702d13-6473-844a-5873-9c70c909ca8b@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 29 Sep 2023 09:04:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9LMfwzvZejTD3Uh5t9kUvYmCXBJVN4dKfA0g--sUHKVQ@mail.gmail.com>
Message-ID: <CAKYAXd9LMfwzvZejTD3Uh5t9kUvYmCXBJVN4dKfA0g--sUHKVQ@mail.gmail.com>
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

2023-09-29 0:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/27/2023 10:30 AM, Namjae Jeon wrote:
>> Cthon test fail with the following error.
>>
>> check for proper open/unlink operation
>> nfsjunk files before unlink:
>>    -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>> ./nfs2y8Jm9 open; unlink ret =3D 0
>> nfsjunk files after unlink:
>>    -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
>> data compare ok
>> nfsjunk files after close:
>>    ls: cannot access './nfs2y8Jm9': No such file or directory
>> special tests failed
>>
>> Cthon expect to second unlink failure when file is already unlinked.
>> ksmbd can not allow to open file if flags of ksmbd inode is set with
>> S_DEL_ON_CLS flags.
>>
>> Reported-by: Tom Talpey <tom@talpey.com>
>
> I don't remember reporting this.
>
> But more fundamentally, the Connectathon test is an NFS exerciser, and
> specific to NFS (and Posix) semantics. Delete-on-last-close is not one
> of them.
>
> Won't failing a new open break Windows semantics if it's enforced by
> default? Normally Windows checks for FILE_SHARE_DELETE before deciding
> this. Maybe other checks as well...
cifs.ko send smb2 create with FILE_SHARE_DELETE to ksmbd.
If sent without it,  ksmbd return STATUS_SHARING_VIOLATION error to client.
I have tested it against samba. ssamba handle it as STATUS_DELETE_PENDING e=
rror.
>
> Tom.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/smb/server/vfs_cache.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>> index f41f8d6108ce..f2e2a7cc24a9 100644
>> --- a/fs/smb/server/vfs_cache.c
>> +++ b/fs/smb/server/vfs_cache.c
>> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work
>> *work, struct file *filp)
>>   		goto err_out;
>>   	}
>>
>> +	if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
>> +		ret =3D -ENOENT;
>> +		goto err_out;
>> +	}
>> +
>>   	ret =3D __open_id(&work->sess->file_table, fp,
>> OPEN_ID_TYPE_VOLATILE_ID);
>>   	if (ret) {
>>   		ksmbd_inode_put(fp->f_ci);
>
