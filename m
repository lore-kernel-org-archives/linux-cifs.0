Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2118C04A95
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 14:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiIYOXZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 10:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiIYOXY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 10:23:24 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B07E3F
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 07:23:23 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w8so7128375lft.12
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 07:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1MJy5vAFaELd9vC8RWET550vFadM7bYElmH/CDcDkug=;
        b=AUqDg1Xz4eVyxVFGVVVVe8DtCWomzFC3xUBi9sHj5nPXkI8Wrd9WxEC5te7PaRjWoC
         kznbh+llUhPeyDSEESteGhU9SaGCl3dQ2BwsVnxnTygZbV7pGnoZP71Fj20/6GsPIDvA
         A0TDAkot2w1JoeD2Ti6eU3VXAKDzpqYHws6oOFfNCfs0cMDsqOK3SW7qlTQkJ+tC7tDf
         XDm2MTevVCvx6UkCxRjPVbxc+xcxwcVVoQjOHIKK8RM4F4Wu1xOUkc6x9EVSZK6gChDu
         ESxYSeR7o6gyZ8cDAUNeXnU2ClveDxO4ln6rBFtV/HG0Q1dUWF8uv7mPJbG2pkUHy17l
         /e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1MJy5vAFaELd9vC8RWET550vFadM7bYElmH/CDcDkug=;
        b=GfkDNSSJMEPVzMRtzugLyVXy4azL9ReC/ff5KPV5P8mmgrvCb1crt+VuE9Cz2SjIfJ
         OwboQ4fYc2BNjFBk3GE82k+zIKCJygzV2nA9UZJ9i8VqWT7gYUgl9/AHTuDnsovUSjSG
         4F68RU3m5AcHukoXAiSFel4T57c6qL4UvYZkCSbvn/+lhxmYO6oEFfGDSC9P9LTAwAis
         plsPhSoWKSREtatTb8zl1Zmvv+6QrhNhW2414B5OhAcfZfSdDFUR8yvB2l874Us2bCUH
         VRXblP5Z1sOkj2qKwO4y9VHrF3x6noU18LsheN61YHPcEU4Vh32jyBRj/qpX81IPapUk
         VadA==
X-Gm-Message-State: ACrzQf2TGbf2U2otMQF4ovSUjFB/mTvzuKwLna4yI9cSh0QYwks4WOAZ
        OxnPwh6rkOiP+VYY0zSX35w=
X-Google-Smtp-Source: AMsMyM572cSbVRXVIr0iBQarPKQ4GLU84E7yx48AZEMk39WG3+wcQSFrIAnI/m6kl3NN+4NSwS4Ixw==
X-Received: by 2002:a05:6512:261e:b0:4a1:8b6:86bb with SMTP id bt30-20020a056512261e00b004a108b686bbmr2976895lfb.334.1664115801432;
        Sun, 25 Sep 2022 07:23:21 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e2-144.dhcp.inet.fi. [193.210.226.144])
        by smtp.gmail.com with ESMTPSA id 9-20020ac25f09000000b00492e5d31201sm2224778lfq.7.2022.09.25.07.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 07:23:19 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linkinjeon@kernel.org
Cc:     atteh.mailbox@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
Date:   Sun, 25 Sep 2022 17:23:13 +0300
Message-Id: <20220925142313.17966-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <CAKYAXd8MtTXfzm16a1+f=dCR4VVLx5Hre9rQqh4Z5cA=B_hr0Q@mail.gmail.com>
References: <CAKYAXd8MtTXfzm16a1+f=dCR4VVLx5Hre9rQqh4Z5cA=B_hr0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 25 Sep 2022 22:18:19 +0900, Namjae Jeon wrote:
> 2022-09-24 11:23 GMT+09:00, Atte Heikkilä <atteh.mailbox@gmail.com>:
>> Case-insensitive file name lookups with __caseless_lookup() use
>> strncasecmp() for file name comparison. strncasecmp() assumes an
>> ISO8859-1-compatible encoding, which is not the case here as UTF-8
>> is always used. As such, use of strncasecmp() here produces correct
>> results only if both strings use characters in the ASCII range only.
>> Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
>> failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
>> Also, as we are adding an include for `linux/unicode.h', include it
>> in `fs/ksmbd/connection.h' as well since it should be explicit there.
>>
>> Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
>> ---
>>  fs/ksmbd/connection.h |  1 +
>>  fs/ksmbd/vfs.c        | 20 +++++++++++++++++---
>>  fs/ksmbd/vfs.h        |  2 ++
>>  3 files changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
>> index 41d96f5cef06..3643354a3fa7 100644
>> --- a/fs/ksmbd/connection.h
>> +++ b/fs/ksmbd/connection.h
>> @@ -14,6 +14,7 @@
>>  #include <net/request_sock.h>
>>  #include <linux/kthread.h>
>>  #include <linux/nls.h>
>> +#include <linux/unicode.h>
>>
>>  #include "smb_common.h"
>>  #include "ksmbd_work.h"
>> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
>> index 4fcf96a01c16..a3269df7c7b3 100644
>> --- a/fs/ksmbd/vfs.c
>> +++ b/fs/ksmbd/vfs.c
>> @@ -1145,12 +1145,23 @@ static int __caseless_lookup(struct dir_context
>> *ctx, const char *name,
>>  			     unsigned int d_type)
>>  {
>>  	struct ksmbd_readdir_data *buf;
>> +	int cmp;
> cmp should be initialized with -EINVAL to fallback strncasecmp() ?

Please see below for the explanation.
>
>>
>>  	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
>>
>>  	if (buf->used != namlen)
>>  		return 0;
>> -	if (!strncasecmp((char *)buf->private, name, namlen)) {
>> +	if (IS_ENABLED(CONFIG_UNICODE) && buf->um) {
>> +		const struct qstr q_buf = {.name = buf->private,
>> +					   .len = buf->used};
>> +		const struct qstr q_name = {.name = name,
>> +					    .len = namlen};
>> +
>> +		cmp = utf8_strncasecmp(buf->um, &q_buf, &q_name);
>> +	}
>> +	if (!(IS_ENABLED(CONFIG_UNICODE) && buf->um) || cmp < 0)
> I wonder why ->um is checked with CONFIG_UNICODE.

If !(IS_ENABLED(CONFIG_UNICODE) && buf->um) is true, then utf8_strncasecmp()
was not called. If !(IS_ENABLED(CONFIG_UNICODE) && buf->um) is false, then
utf8_strncasecmp() was called and we check for an error with `cmp < 0'.
Alternatively, `cmp' can be initialized to -EINVAL and then
!(IS_ENABLED(CONFIG_UNICODE) && buf->um) can be removed.
The latter is preferred, right?
>
> Thanks.
>> +		cmp = strncasecmp((char *)buf->private, name, namlen);
>> +	if (!cmp) {
>>  		memcpy((char *)buf->private, name, namlen);
>>  		buf->dirent_count = 1;
>>  		return -EEXIST;
>> @@ -1166,7 +1177,8 @@ static int __caseless_lookup(struct dir_context *ct> x,
>> const char *name,
>>   *
>>   * Return:	0 on success, otherwise error
>>   */
>> -static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
>> size_t namelen)
>> +static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
>> +				   size_t namelen, struct unicode_map *um)
>>  {
>>  	int ret;
>>  	struct file *dfilp;
>> @@ -1176,6 +1188,7 @@ static int ksmbd_vfs_lookup_in_dir(const struct pat> h
>> *dir, char *name, size_t na
>>  		.private	= name,
>>  		.used		= namelen,
>>  		.dirent_count	= 0,
>> +		.um		= um,
>>  	};
>>
>>  	dfilp = dentry_open(dir, flags, current_cred());
>> @@ -1238,7 +1251,8 @@ int ksmbd_vfs_kern_path(struct ksmbd_work *work, ch> ar
>> *name,
>>  				break;
>>
>>  			err = ksmbd_vfs_lookup_in_dir(&parent, filename,
>> -						      filename_len);
>> +						      filename_len,
>> +						      work->conn->um);
>>  			path_put(&parent);
>>  			if (err)
>>  				goto out;
>> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
>> index d7542a2dab52..593059ca8511 100644
>> --- a/fs/ksmbd/vfs.h
>> +++ b/fs/ksmbd/vfs.h
>> @@ -12,6 +12,7 @@
>>  #include <linux/namei.h>
>>  #include <uapi/linux/xattr.h>
>>  #include <linux/posix_acl.h>
>> +#include <linux/unicode.h>
>>
>>  #include "smbacl.h"
>>  #include "xattr.h"
>> @@ -60,6 +61,7 @@ struct ksmbd_readdir_data {
>>  	unsigned int		used;
>>  	unsigned int		dirent_count;
>>  	unsigned int		file_attr;
>> +	struct unicode_map	*um;
>>  };
>>
>>  /* ksmbd kstat wrapper to get valid create time when reading dir entry *> /
>> --
>> 2.37.3
>>
>>
>
