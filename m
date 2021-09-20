Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F51C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E90061074
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 04:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhITEtY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 00:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhITEtX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 00:49:23 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A54AC061574
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:47:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so62310112lfu.5
        for <linux-cifs@vger.kernel.org>; Sun, 19 Sep 2021 21:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7jB7JpTM7X5il2V2y73Z4rY51s4dPtqhcS/w6E9ZUE=;
        b=Kgyq7xaXMvvEJ2oaoI6l5aEU73XuQSSfXITvpygArQqFJ+WEqc3XhZy+9vN9k+9/wE
         JFfwECVZiwPwsp0WFSl2pA8gIOti8jeQcqWf4H6uItWNPM7CCP3zm/hAoeYTxran8Blb
         g99vx7WN7yHGdjcoERhM27VF4SgIuPW/bkVxj7MDFSisYIah4JlRiACc0ALeYNEiQPvf
         wLWtjCjPbB0pQSw0vmbwZx6whE7419tHLOKmT2ID5Oo4E04u4GA3xeR5fGO/PK7mkEgC
         9TW2cRf4tfWC9QkYLZevBLqbpb3qTcAkuDY9JRmR/9iuil8kAYuZ7FDBjcsdSDVLASSA
         zklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7jB7JpTM7X5il2V2y73Z4rY51s4dPtqhcS/w6E9ZUE=;
        b=PSPrvtAt9RN8CLQMqPi0PTUcuDSsc1sa6vsupRG/40MBMQSs3nImwuQuJF/E+0rpT7
         mEdzZSW5w/ff6wJiEKOypZhZ9EqVr0ktq89cvWiw0+K9l0eP08zrcBZbUKy0/sR48ch9
         GI5mnOv4xcXOIZ5TZ25NNyXVfa7DSHF/MMqziPNDj2sah+JEWpXmxZudg7VQvVwmYXbG
         FiC+AVZwiZwuezQR2YAYPgVttdZAzycSyZ45bLti+gOg0vFW7EtZ1fu5Wu89L+YwZwwM
         V7iN2k3OWzPy+fanGRDsa4+94eb1OyAesL7aXf1Yl24YAGuGfgnTp998jK8I37BJaLJq
         PlnA==
X-Gm-Message-State: AOAM5306a4Qqcs5Um97+kh3NUaT1BY3zABBk4VH+PjSdK2RG3tjozXcH
        sXtOGXj3fIIjJiBAkSIyo4Zs8efS07lOAsjgeT40HxD4xdo=
X-Google-Smtp-Source: ABdhPJx1+tDJfACG1FwKXanaf8XCuSeW54txHq7/DEm278sPdbY14VYyZeQ1czY7T5hLfJNczxMurMs1ognm4bYn7KQ=
X-Received: by 2002:a2e:a549:: with SMTP id e9mr21798124ljn.500.1632113273848;
 Sun, 19 Sep 2021 21:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
In-Reply-To: <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Sep 2021 23:47:43 -0500
Message-ID: <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Sep 18, 2021 at 9:06 PM Tom Talpey <tom@talpey.com> wrote:
>
> This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
> There, it appears to call for returning an empty stream list,
> and STATUS_SUCCESS, when no streams are present.

I tried a quick test to Windows and it does appear to return $DATA
stream by default:

# ./smbinfo filestreaminfo /mnt/junk
Name: ::$DATA
Size: 179765 bytes
Allocation size: 196608 bytes

when I tried the same thing to a directory on a share mounted to Windows 10
(NTFS), I get no streams returned.

So it does look like default stream ($DATA) is only returned for files

> Also, why does the code special-case directories? The conditionals
> on StreamSize and StreamAllocation size are entirely redundant,
> after the top-level if (!S_ISDIR...), btw.
>
> I'd suggest asking Microsoft dochelp for clarification before
> implementing this.
>
> Tom.
>
> On 9/18/2021 8:02 AM, Namjae Jeon wrote:
> > Windows client expect to get default stream name(::DATA) in
> > FILE_STREAM_INFORMATION response even if there is no stream data in file.
> > This patch fix update failure when writing ppt or doc files.




-- 
Thanks,

Steve
