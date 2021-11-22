Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E646C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Nov 2021 10:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbhKVKtq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Nov 2021 05:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhKVKtq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Nov 2021 05:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D26CC60F6B
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637577999;
        bh=l1tZIxqL3SgsREC3HueY5lkDpbXf9FTiYZiCeLQF3S8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=W83s30dyH3yf7TSRbpXocHUJ8IWoN5lqr67z+E9P4VS+VVM9Qwp33TauXOapeQAJX
         GuwEgfr/Ej4KcEC8dbJ2yYTsLwxGJRtDGLNu3Q7n8u21vgZQ6ure0uc3nlLpd/vW8q
         1ILftC1wBTqHrrv56/Z7AQJqBbKb/g1OixsXWgoTbKJnTHkYcd6TEQPXSFCGQVTqHH
         8a5y2cJtyXdMYaQCQKhjFgrRonrGjJzl6Zyrqg2mUhP+ff3SDC1m0K3Lv38TdqY3ZW
         XFD3PK7yIfAYMdAVgytkgM5mc06lw7nbc/ztTlGnAyCsp4dRIR0t3tquhi+N0W9ebC
         OnjTh/HL8VS3Q==
Received: by mail-oi1-f172.google.com with SMTP id q25so37133232oiw.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 02:46:39 -0800 (PST)
X-Gm-Message-State: AOAM530qZQ1cy14qWEa40I9vhM5Vq31+hOno3+IO0hISFJCgxUmhcCV2
        EPEbKTVVkOg9PLF4SCKrQ/3fewIl9JQjm7+BZBQ=
X-Google-Smtp-Source: ABdhPJwyhBIDnNIoWwfjJyWmp87HfeUcai/Dm5lSz04rQ1fuB5VZT9ZQL4CP+K2ecw0aAddPZLsKSb0QRxJvcQZTr+g=
X-Received: by 2002:a05:6808:a8f:: with SMTP id q15mr19837489oij.65.1637577999087;
 Mon, 22 Nov 2021 02:46:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Mon, 22 Nov 2021 02:46:38
 -0800 (PST)
In-Reply-To: <CAF6XXKWr0w5hsKgs2QLh+W9=+T2xK_OkNM7_cBjKFSpLfN_V4w@mail.gmail.com>
References: <20211121114009.6039-1-linkinjeon@kernel.org> <CAF6XXKWr0w5hsKgs2QLh+W9=+T2xK_OkNM7_cBjKFSpLfN_V4w@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 22 Nov 2021 19:46:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__m2sauDX2kzroAjy+ohydD4L0pnEr8zDxRZG_KPkgjg@mail.gmail.com>
Message-ID: <CAKYAXd__m2sauDX2kzroAjy+ohydD4L0pnEr8zDxRZG_KPkgjg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: fix file transfer stuck at 99%
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-22 18:28 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> On Sun, Nov 21, 2021 at 12:40 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> When user set share name included upper character in smb.conf,
>> Windows File transfer will stuck at 99%. When copying file, windows send
>> SRVSVC GET_SHARE_INFO command to ksmbd server. but ksmbd store after
>> converting share name from smb.conf to lower cases. So ksmbd.mountd
>> can't not find share and return error to windows client.
>> This patch find share using name converted share name from client to
>> lower cases.
>>
>> Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
>> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  mountd/rpc_srvsvc.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
>> index 8608b2e..f3b4d06 100644
>> --- a/mountd/rpc_srvsvc.c
>> +++ b/mountd/rpc_srvsvc.c
>> @@ -169,8 +169,11 @@ static int srvsvc_share_get_info_invoke(struct
>> ksmbd_rpc_pipe *pipe,
>>  {
>>         struct ksmbd_share *share;
>>         int ret;
>> +       gchar *share_name;
>>
>> -       share = shm_lookup_share(STR_VAL(hdr->share_name));
>> +       share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
>> +                       strlen(STR_VAL(hdr->share_name)));
>> +       share = shm_lookup_share(share_name);
>>         if (!share)
>>                 return 0;
>>
>> @@ -188,9 +191,12 @@ static int srvsvc_share_get_info_invoke(struct
>> ksmbd_rpc_pipe *pipe,
>>         }
>>
>>         if (ret != 0) {
>> +               gchar *server_name =
>> g_ascii_strdown(STR_VAL(hdr->server_name),
>> +                               strlen(STR_VAL(hdr->server_name)));
>> +
>>                 ret = shm_lookup_hosts_map(share,
>>                                            KSMBD_SHARE_HOSTS_DENY_MAP,
>> -                                          STR_VAL(hdr->server_name));
>> +                                          server_name);
>>                 if (ret == 0) {
>>                         put_ksmbd_share(share);
>>                         return 0;
>> --
>> 2.25.1
>>
>
> Awesome work tracking this down. This raises a question though: why is
> ksmbd.mountd
> converting share names to lowercase to begin with ?
Windows is case insensitive. So we need it to do a lookup using the
share name from windows.
>
> I checked samba, and the share name sent back to the client has the same
> case as
> defined in smb.conf.
There should be no problems with the current way. And if you test
adding multiple case sensitive share names to smb.conf, You will find
that only one of them is available.
>
