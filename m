Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003D5C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D970D61054
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhJLBbC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhJLBbC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 Oct 2021 21:31:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A055661059
        for <linux-cifs@vger.kernel.org>; Tue, 12 Oct 2021 01:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634002141;
        bh=IXNQzOXSjYZO2DiduQw7DMhEx1Aehp2ZAOp15AuB1E8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=bA7f96Ne/bP4aWTc7eLj7BPnKX8oKuXj66jiuGOLn7m2oPWQlv6t5SpQEBVvo5zjv
         7WGFssurIkC+Xo+g6T2YrfnKHLDzUmCpQlK4ezHrwLlKkqEmG4LU7FDk4K1pKTIuuc
         eThYzdQ8c9TiOETRqsZegNd/wcBWNxFXHwTuvItWGDCIH4Q1rIno1wBI7yAH8ktXNw
         JFGwjHsetgaCHlNnEw3gOA/eAM70mQqAU3q43dbysiSvAhCHsNP4Selvo3LLkQkpSX
         u+xuuTNfiItQjNRj+U4zg/2wLZhJiM45IP0E1/p8sNQv8pxFISQ/oErCFDsZvo4hbq
         kBG4sZVrGpCUQ==
Received: by mail-oo1-f44.google.com with SMTP id u5-20020a4ab5c5000000b002b6a2a05065so4808198ooo.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:29:01 -0700 (PDT)
X-Gm-Message-State: AOAM533eEkZZZt19obTd8pD9fRUWmk2jUeGx6gHvJIbe86s8/jONXJXZ
        9P9HPc42DvYZvaqB3D7QA4WkmmhhUf+IEQv0zmg=
X-Google-Smtp-Source: ABdhPJzvqkPOCXAZDSgVETKlF16Yon4v37W0Y9jWESjAR04Al+RmQwjNxjaxGGEgKNT2Qsg59kLAF9A1S1yRdOWl+B8=
X-Received: by 2002:a4a:c18d:: with SMTP id w13mr21653505oop.15.1634002140955;
 Mon, 11 Oct 2021 18:29:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Mon, 11 Oct 2021 18:29:00
 -0700 (PDT)
In-Reply-To: <CA+_sPaq-HaWAieyGksXaBW42PPnUq5K0MOauojv7QP98018mCg@mail.gmail.com>
References: <20211007223103.5340-1-linkinjeon@kernel.org> <CA+_sPaq-HaWAieyGksXaBW42PPnUq5K0MOauojv7QP98018mCg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 12 Oct 2021 10:29:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_EVGARxRNU-0ASmfDTYPb2zaXahn1jAg4MCr2rGVQjkQ@mail.gmail.com>
Message-ID: <CAKYAXd_EVGARxRNU-0ASmfDTYPb2zaXahn1jAg4MCr2rGVQjkQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: limit read/write/trans buffer size not to exceed 8MB
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-12 10:01 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On Fri, Oct 8, 2021 at 7:31 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> ksmbd limit read/write/trans buffer size not to exceed 8MB like samba.
>>
>
> [..]
>
>> @@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
>>
>>  void init_smb2_max_read_size(unsigned int sz)
>>  {
>> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>>         smb21_server_values.max_read_size = sz;
>>         smb30_server_values.max_read_size = sz;
>>         smb302_server_values.max_read_size = sz;
>> @@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
>>
>>  void init_smb2_max_write_size(unsigned int sz)
>>  {
>> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>>         smb21_server_values.max_write_size = sz;
>>         smb30_server_values.max_write_size = sz;
>>         smb302_server_values.max_write_size = sz;
>> @@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
>>
>>  void init_smb2_max_trans_size(unsigned int sz)
>>  {
>> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>>         smb21_server_values.max_trans_size = sz;
>>         smb30_server_values.max_trans_size = sz;
>>         smb302_server_values.max_trans_size = sz;
>
> Does SMB2 support max request size of 8MB or does it support requests
> of only up to 64k in size?
I have sent v3 patch to the list now. Please check it.
This value should be greater than or equal to 65536 and smaller than
max rfc1002 length.

Thanks!
>
