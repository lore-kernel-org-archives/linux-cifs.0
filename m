Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040E4C77B73
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 12:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjEHM6s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 May 2023 08:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbjEHM6r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 May 2023 08:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43AE35B2C
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 05:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AC19615A5
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 12:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B655FC4339B
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683550725;
        bh=9pTuvXYAUmjevDbCw+rNAySfZRNYNN905kHvHn3ykoQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tnVhFMQUH0ka7QkMED3MC7vHFGgZiGWWFHFfiQeJk3Y2FG8otbnlQ2kbiT16QhWVA
         hNxGaltE7BlFJPBX468gRN90k5iKtibWIuCYFLGc55gyecqXvRooKeS2KS8nXBNhfW
         7riE4kJXdwCbAN/dHr1tpRo9bbbYFs2a1X7qKX75n6lpiGcmCRP+leK3ykUzwPSbWN
         Jotl/vG4UvNHrlfV7aeryGZ8F+w4VzCBsUvBfkubTibyG8DDzmjWAKIbAfGacha6Z/
         Qlw46Pn42r37VlGa1C3xyNM9h7PPIB3MkpPSxJAGDw+lOgqZxHb2RDx9LQpBgqDz9n
         Q4qXE1GpuAibA==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1929818d7faso31282811fac.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 May 2023 05:58:45 -0700 (PDT)
X-Gm-Message-State: AC+VfDwKCI1gTcVlYAPC0fXD3spK0geCKjRJ7LpUqirse/E0p4QdHRQb
        Ps1cyrP8N19mSSYm32N39TosiVghHupegIa+GGk=
X-Google-Smtp-Source: ACHHUZ6x/d9Xov7ljC6YuFRUsTdklsWja7DtJeyMUqxPJtmPIqBhOS0NOTOEkYnIcO/oVHlfyzo/Hg6HJmltt3w1dZI=
X-Received: by 2002:aca:c0c1:0:b0:387:31fd:1782 with SMTP id
 q184-20020acac0c1000000b0038731fd1782mr6503876oif.28.1683550724865; Mon, 08
 May 2023 05:58:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:981:0:b0:4d3:d9bf:b562 with HTTP; Mon, 8 May 2023
 05:58:44 -0700 (PDT)
In-Reply-To: <20230508010506.GA11511@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org> <20230508010506.GA11511@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 8 May 2023 21:58:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-upEqLP8zSqZbR0FcznGfWLejkqQ6QKLh=taxb0mMiLQ@mail.gmail.com>
Message-ID: <CAKYAXd-upEqLP8zSqZbR0FcznGfWLejkqQ6QKLh=taxb0mMiLQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] ksmbd: fix global-out-of-bounds in smb2_find_context_vals
To:     Pumpkin <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-08 10:05 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/05/06 00:11), Namjae Jeon wrote:
>> From: Pumpkin <cc85nod@gmail.com>
>>
>> If the length of CreateContext name is larger than the tag, it will
>> access
>> the data following the tag and trigger KASAN global-out-of-bounds.
>>
>> Currently all CreateContext names are defined as string, so we can use
>> strcmp instead of memcmp to avoid the out-of-bound access.
Hi Chih-Yen,

Please reply to Sergey's review comment. If needed, please send v2
patch after updating it.

Thanks.
>
> [..]
>
>> +++ b/fs/ksmbd/oplock.c
>> @@ -1492,7 +1492,7 @@ struct create_context *smb2_find_context_vals(void
>> *open_req, const char *tag)
>>  			return ERR_PTR(-EINVAL);
>>
>>  		name = (char *)cc + name_off;
>> -		if (memcmp(name, tag, name_len) == 0)
>> +		if (!strcmp(name, tag))
>>  			return cc;
>>
>>  		remain_len -= next;
>
> I'm slightly surprised that that huge `if` before memcmp() doesn't catch
> it
>
> 		if ((next & 0x7) != 0 ||
> 		    next > remain_len ||
> 		    name_off != offsetof(struct create_context, Buffer) ||
> 		    name_len < 4 ||
> 		    name_off + name_len > cc_len ||
> 		    (value_off & 0x7) != 0 ||
> 		    (value_off && (value_off < name_off + name_len)) ||
> 		    ((u64)value_off + value_len > cc_len))
> 			return ERR_PTR(-EINVAL);
>
> Is that because we should check `name_len` instead of `name_off +
> name_len`?
> IOW
>
> 		if (name_len != cc_len)
> 			return ERR_PTR();
>
