Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245F2C32771
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 01:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiI0B1f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Sep 2022 21:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiI0B1e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Sep 2022 21:27:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DBA99E5
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 18:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A229B8170D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 01:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4769CC433C1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 01:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664242050;
        bh=9o+kHrI3uhH1b4okKVYGsiazUnPUaPhPSktEQX5h5O4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=q2LJv4BgiDVI/8XJUuN1XqGNLaFUIbQTEl+Nz6PCxCZ2hej6FOhbBP4n+tgEOT8Rx
         zZwcQCcE+/kmYFVoBeALtoPoWcKzfF0G9ZqhIOMbQVvWiiZDfNwyb9+Cfcn0YSLgWn
         mqTLFrugI/+0pGs16MyH/YIvjtHZkYcJpmHyXgdZwF0ztqJdmIEvUBJvilzVEq0lyO
         kZJelKo43FgfhJ7grkNjyt6VX/t0NfR7WHbZrEXYF8SzoOR7xGzJls4uKa0xjlhVKb
         4r0sdFEF2LsKDnw56BswtXp6WIa7I4XuvUw9R+jy5dt5bdTr8+bwvwM6KL4mdO8tVN
         6EZZWyBa0JPnQ==
Received: by mail-ot1-f46.google.com with SMTP id l7-20020a056830154700b0065563d564dfso5567024otp.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 18:27:30 -0700 (PDT)
X-Gm-Message-State: ACrzQf3b6tfh/B6JkbkDtmPd6T28bXv7TYpVY/I8/rPx9c4O59L3Nr9d
        UOjjbt28kDgwPRLyoi0G9q+8YqkQxHlYzHoo5OE=
X-Google-Smtp-Source: AMsMyM7oF67abQS0Kx2pfTeMFCulVHNzSE7DwlbYyZ/wB98l7IbPhz3Gp3bKnf84+gcubdDQItTkU9ICjM0dIJIpaVc=
X-Received: by 2002:a9d:5603:0:b0:639:683b:82c7 with SMTP id
 e3-20020a9d5603000000b00639683b82c7mr11179060oti.187.1664242049334; Mon, 26
 Sep 2022 18:27:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 26 Sep 2022 18:27:28
 -0700 (PDT)
In-Reply-To: <20220925142313.17966-1-atteh.mailbox@gmail.com>
References: <CAKYAXd8MtTXfzm16a1+f=dCR4VVLx5Hre9rQqh4Z5cA=B_hr0Q@mail.gmail.com>
 <20220925142313.17966-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 27 Sep 2022 10:27:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-2C1=aycj-YdJZcBKX0WHGpvxUDV3uWTwmjeXJLt9s3A@mail.gmail.com>
Message-ID: <CAKYAXd-2C1=aycj-YdJZcBKX0WHGpvxUDV3uWTwmjeXJLt9s3A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-25 23:23 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> On Sun, 25 Sep 2022 22:18:19 +0900, Namjae Jeon wrote:
>> 2022-09-24 11:23 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>=
:
>>> Case-insensitive file name lookups with __caseless_lookup() use
>>> strncasecmp() for file name comparison. strncasecmp() assumes an
>>> ISO8859-1-compatible encoding, which is not the case here as UTF-8
>>> is always used. As such, use of strncasecmp() here produces correct
>>> results only if both strings use characters in the ASCII range only.
>>> Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
>>> failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
>>> Also, as we are adding an include for `linux/unicode.h', include it
>>> in `fs/ksmbd/connection.h' as well since it should be explicit there.
>>>
>>> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
>>> ---
>>>  fs/ksmbd/connection.h |  1 +
>>>  fs/ksmbd/vfs.c        | 20 +++++++++++++++++---
>>>  fs/ksmbd/vfs.h        |  2 ++
>>>  3 files changed, 20 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
>>> index 41d96f5cef06..3643354a3fa7 100644
>>> --- a/fs/ksmbd/connection.h
>>> +++ b/fs/ksmbd/connection.h
>>> @@ -14,6 +14,7 @@
>>>  #include <net/request_sock.h>
>>>  #include <linux/kthread.h>
>>>  #include <linux/nls.h>
>>> +#include <linux/unicode.h>
>>>
>>>  #include "smb_common.h"
>>>  #include "ksmbd_work.h"
>>> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
>>> index 4fcf96a01c16..a3269df7c7b3 100644
>>> --- a/fs/ksmbd/vfs.c
>>> +++ b/fs/ksmbd/vfs.c
>>> @@ -1145,12 +1145,23 @@ static int __caseless_lookup(struct dir_context
>>> *ctx, const char *name,
>>>  			     unsigned int d_type)
>>>  {
>>>  	struct ksmbd_readdir_data *buf;
>>> +	int cmp;
>> cmp should be initialized with -EINVAL to fallback strncasecmp() ?
>
> Please see below for the explanation.
>>
>>>
>>>  	buf =3D container_of(ctx, struct ksmbd_readdir_data, ctx);
>>>
>>>  	if (buf->used !=3D namlen)
>>>  		return 0;
>>> -	if (!strncasecmp((char *)buf->private, name, namlen)) {
>>> +	if (IS_ENABLED(CONFIG_UNICODE) && buf->um) {
>>> +		const struct qstr q_buf =3D {.name =3D buf->private,
>>> +					   .len =3D buf->used};
>>> +		const struct qstr q_name =3D {.name =3D name,
>>> +					    .len =3D namlen};
>>> +
>>> +		cmp =3D utf8_strncasecmp(buf->um, &q_buf, &q_name);
>>> +	}
>>> +	if (!(IS_ENABLED(CONFIG_UNICODE) && buf->um) || cmp < 0)
>> I wonder why ->um is checked with CONFIG_UNICODE.
>
> If !(IS_ENABLED(CONFIG_UNICODE) && buf->um) is true, then
> utf8_strncasecmp()
> was not called. If !(IS_ENABLED(CONFIG_UNICODE) && buf->um) is false, the=
n
> utf8_strncasecmp() was called and we check for an error with `cmp < 0'.
> Alternatively, `cmp' can be initialized to -EINVAL and then
> !(IS_ENABLED(CONFIG_UNICODE) && buf->um) can be removed.
> The latter is preferred, right?
Yes:) The latter would be better.

>>
>> Thanks.
>>> +		cmp =3D strncasecmp((char *)buf->private, name, namlen);
>>> +	if (!cmp) {
>>>  		memcpy((char *)buf->private, name, namlen);
>>>  		buf->dirent_count =3D 1;
>>>  		return -EEXIST;
>>> @@ -1166,7 +1177,8 @@ static int __caseless_lookup(struct dir_context
>>> *ct> x,
>>> const char *name,
>>>   *
>>>   * Return:	0 on success, otherwise error
>>>   */
>>> -static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
>>> size_t namelen)
>>> +static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
>>> +				   size_t namelen, struct unicode_map *um)
>>>  {
>>>  	int ret;
>>>  	struct file *dfilp;
>>> @@ -1176,6 +1188,7 @@ static int ksmbd_vfs_lookup_in_dir(const struct
>>> pat> h
>>> *dir, char *name, size_t na
>>>  		.private	=3D name,
>>>  		.used		=3D namelen,
>>>  		.dirent_count	=3D 0,
>>> +		.um		=3D um,
>>>  	};
>>>
>>>  	dfilp =3D dentry_open(dir, flags, current_cred());
>>> @@ -1238,7 +1251,8 @@ int ksmbd_vfs_kern_path(struct ksmbd_work *work,
>>> ch> ar
>>> *name,
>>>  				break;
>>>
>>>  			err =3D ksmbd_vfs_lookup_in_dir(&parent, filename,
>>> -						      filename_len);
>>> +						      filename_len,
>>> +						      work->conn->um);
>>>  			path_put(&parent);
>>>  			if (err)
>>>  				goto out;
>>> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
>>> index d7542a2dab52..593059ca8511 100644
>>> --- a/fs/ksmbd/vfs.h
>>> +++ b/fs/ksmbd/vfs.h
>>> @@ -12,6 +12,7 @@
>>>  #include <linux/namei.h>
>>>  #include <uapi/linux/xattr.h>
>>>  #include <linux/posix_acl.h>
>>> +#include <linux/unicode.h>
>>>
>>>  #include "smbacl.h"
>>>  #include "xattr.h"
>>> @@ -60,6 +61,7 @@ struct ksmbd_readdir_data {
>>>  	unsigned int		used;
>>>  	unsigned int		dirent_count;
>>>  	unsigned int		file_attr;
>>> +	struct unicode_map	*um;
>>>  };
>>>
>>>  /* ksmbd kstat wrapper to get valid create time when reading dir entry
>>> *> /
>>> --
>>> 2.37.3
>>>
>>>
>>
>
