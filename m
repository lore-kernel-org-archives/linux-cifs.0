Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EACC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D15610F7
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbhIYAWh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 20:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhIYAWh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 24 Sep 2021 20:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD589610F7
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 00:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632529263;
        bh=5GDUF9wcO5vZRdIbJd0LdXrPHYtGqSlmtM1mVN2J0FM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=iwwycVZYhllOVx64x0FcMTUvXukpvtgsKvg1RzcFzLtJLaxTTPqsAGUS1MLasTG3S
         nWDANBddzhEypw2tLemDmnA08iXCQ9mFj0ZNqVseN6xDCV3oJOg/18ZY2BKdk7rFiY
         KyOpO0KszIsG4bB0NUFuz8arYPH8BC7F5zTxDEr2LsaE1V7eH06nNJLN7cQc2aAL2S
         a2KnVe6mNh6GxKNDkEB3TwDvBrCX48AD5Uwy4PK9Sr2ZchXt63p4ml8Y2LqwTbTDfB
         KJ7d/e5wZQbSfP02vJFaS7wrgAFtlDzlGVIZtsO+oDQcZdODe71wROy69zvnwR5adf
         RDVHKkQ0TN/+w==
Received: by mail-oi1-f169.google.com with SMTP id s69so16750778oie.13
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 17:21:03 -0700 (PDT)
X-Gm-Message-State: AOAM532QfBRQMIuWgmrdECDM/HFOTc3n8IayrZYz5UMEnPapGSp3pgny
        pebuf33/VWfKGqoBJ72geMOApiuK4J4O+cN18bo=
X-Google-Smtp-Source: ABdhPJyHvdA6JueRutGLIcPX0EK3g0k1fsVXAFPBgHWFgUwjwA7znriQoGLqaQV2C6ogynb7gwYGJzkwYKJk//QNj7c=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr3646542oib.167.1632529263250;
 Fri, 24 Sep 2021 17:21:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 24 Sep 2021 17:21:02
 -0700 (PDT)
In-Reply-To: <CAKYAXd-ujkC3A7KuE7az6-G0SzX4vrt0sC3uPmwTzXxJ3TfdgA@mail.gmail.com>
References: <20210924150616.926503-1-hyc.lee@gmail.com> <YU4I3zUm3UOOXrBz@jeremy-acer>
 <CAKYAXd-ujkC3A7KuE7az6-G0SzX4vrt0sC3uPmwTzXxJ3TfdgA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 09:21:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_det_pupy5eyvxdKS5OQ6KCFcNz__OR7EwzAk0srVLPA@mail.gmail.com>
Message-ID: <CAKYAXd_det_pupy5eyvxdKS5OQ6KCFcNz__OR7EwzAk0srVLPA@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Jeremy Allison <jra@samba.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-25 9:08 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-09-25 2:20 GMT+09:00, Jeremy Allison <jra@samba.org>:
>> On Sat, Sep 25, 2021 at 12:06:16AM +0900, Hyunchul Lee wrote:
>>>instead of removing '..' in a given path, call
>>>kern_path with LOOKUP_BENEATH flag to prevent
>>>the out of share access.
>>>
>>>ran various test on this:
>>>smb2-cat-async smb://127.0.0.1/homes/../out_of_share
>>>smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
>>>smbclient //127.0.0.1/homes -c "mkdir ../foo2"
>>>smbclient //127.0.0.1/homes -c "rename bar ../bar"
>>
>> FYI, MS-FSCC states:
>>
>> "Except where explicitly permitted, a pathname component that is a dot
>> directory name MUST NOT
>> be sent over the wire."
>>
>> so it might be easier to just refuse with an
>> error a pathname containing "." or ".." on input
>> processing rather than try and deal with it.
>>
>> Might be interesting to test this against a
>> Windows server and see what it does here.
> When I have tested it, it's allowed...
>
> $ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/./bar/../
> bar                  DIRECTORY               0 Sat Sep 25 08:50:02 2021
>
> ..                   DIRECTORY               0 Sat Sep 25 09:02:12 2021
>
> .                    DIRECTORY               0 Sat Sep 25 09:02:12 2021
>
>
> When last component is dotdot(..) and first component is dot(.),  it
> seem to refuse connection.
It's not true.. and it is not easy. Using LOOKUP_BENEATH is the easiest choice.
$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/../.
failed to create/open directory (Invalid argument) Opendir failed with
(0xc000000d) STATUS_INVALID_PARAMETER.

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/../foo/
failed to create/open directory (Invalid argument) Opendir failed with
(0xc000000d) STATUS_INVALID_PARAMETER.

>
> $ ./examples/smb2-ls-async smb://172.30.1.42/homes2/../
> failed to create/open directory (Invalid argument) Opendir failed with
> (0xc000000d) STATUS_INVALID_PARAMETER.
>
> $ ./examples/smb2-ls-async smb://172.30.1.42/homes2/./
> failed to create/open directory (Input/output error) Opendir failed
> with (0xc0000033) STATUS_OBJECT_NAME_INVALID.
>
> ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/../
> failed to create/open directory (Invalid argument) Opendir failed with
> (0xc000000d) STATUS_INVALID_PARAMETER.
>
> $ ./examples/smb2-ls-async smb://172.30.1.42/homes2/./foo
> failed to create/open directory (No such file or directory) Opendir
> failed with (0xc000003a) STATUS_OBJECT_PATH_NOT_FOUND.
>
> $ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/.
> bar                  DIRECTORY               0 Sat Sep 25 08:50:02 2021
>
> ..                   DIRECTORY               0 Sat Sep 25 09:02:12 2021
>
> .                    DIRECTORY               0 Sat Sep 25 09:02:12 2021
>
>
>>
>
