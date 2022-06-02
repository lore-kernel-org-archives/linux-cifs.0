Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8C8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 05:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiFBFUL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiFBFUK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 01:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB5C113A0E
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 22:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C02616EE
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 05:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC8C385A5
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 05:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654147208;
        bh=YOKeOL6Qgx3439U10/7zFi//7D/UEfWuIIXrI/fVHF8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=RyfmJ9vm9JM5nEgxJhbD0/XT3VoNlU/Zg/3hJlC7dG7l+1fl3veKKJWDgJr0yyJi9
         0Pnre2YT8ypAzLOG5G/dZ9znBTYYo35deuBJ5MX6pcEsQqAiiUaCjSZUWu4MkJ2HQ1
         d065uXB9EV/c5pBBR/cOH9fvgBa04nru1Mz9LXHfPRMKT3xO0wgZjVR2PVKfdc5HLC
         6R/2JNaTFzSTEm7Jn50tH4mCi/c0Rb4X27CXfZcetJgCr3ErV568jonpHF535MClog
         R532E/KTs0LkTA22GiN5LEqFaDBMq4RDvOG8WSHdnLQmfvcKxZsG8KerIDrXhAaLus
         m7kpXoRWVdUaw==
Received: by mail-wr1-f41.google.com with SMTP id t6so4940017wra.4
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 22:20:08 -0700 (PDT)
X-Gm-Message-State: AOAM532wWR5vMBaxQkBehKV1ew1RuIYEGPnJM/bTu/0vRcNF97VgbMQz
        9pRvpBEQ24uWEAKs284kfMilqKFlHrUyBop0tlg=
X-Google-Smtp-Source: ABdhPJz/E1bYHKCz6kYQ6rJsFqy/F+yvMOWKricqmNDWKpvJxmX0YmtfAa9oMIQzbJz8sTgP2bC8RE8FxGWcgJwlR24=
X-Received: by 2002:a5d:457b:0:b0:210:2101:ef76 with SMTP id
 a27-20020a5d457b000000b002102101ef76mr1967785wrc.401.1654147206464; Wed, 01
 Jun 2022 22:20:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Wed, 1 Jun 2022 22:20:05 -0700 (PDT)
In-Reply-To: <CANFS6bYwq2kjsCXABSVeSU=AMEau1Cd=A_bS7=A-_PRLz=YfqQ@mail.gmail.com>
References: <20220602011410.56202-1-linkinjeon@kernel.org> <CANFS6bYwq2kjsCXABSVeSU=AMEau1Cd=A_bS7=A-_PRLz=YfqQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 2 Jun 2022 14:20:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9NrsvG7pqyXoWtVn=WA_jE8rGEoe_H5+vD6TAw1XCi7w@mail.gmail.com>
Message-ID: <CAKYAXd9NrsvG7pqyXoWtVn=WA_jE8rGEoe_H5+vD6TAw1XCi7w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: add missing long option in adduser/addshare/control
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-02 14:07 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Hi Namjae,
>
> 2022=EB=85=84 6=EC=9B=94 2=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 10:14,=
 Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> Add missing long option in adduser/addshare/control.
>>
>> Reported-by: David Howells <dhowells@redhat.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  addshare/addshare.c | 11 ++++++++++-
>>  adduser/adduser.c   | 12 +++++++++++-
>>  control/control.c   |  9 ++++++++-
>>  3 files changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/addshare/addshare.c b/addshare/addshare.c
>> index 4d25047..a8ba71a 100644
>> --- a/addshare/addshare.c
>> +++ b/addshare/addshare.c
>> @@ -54,6 +54,15 @@ static void usage(void)
>>         exit(EXIT_FAILURE);
>>  }
>>
>> +static const struct option opts[] =3D {
>> +       {"add-share",           required_argument,      NULL,   'a' },
>> +       {"del-share",           required_argument,      NULL,   'd' },
>> +       {"update-share",        required_argument,      NULL,   'u' },
>> +       {"options",             required_argument,      NULL,   'o' },
>> +       {"version",             no_argument,            NULL,   'V' },
>> +       {"verbose",             no_argument,            NULL,   'v' },
>> +};
>
> We have to add the last element, {NULL, 0, NULL, 0} to avoid
> Segment Fault. otherwise Looks good to me.
Good catch. fixed it on v2.

Thanks!
>
>> +
>>  static void show_version(void)
>>  {
>>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
>> @@ -102,7 +111,7 @@ int main(int argc, char *argv[])
>>         set_logger_app_name("ksmbd.addshare");
>>
>>         opterr =3D 0;
>> -       while ((c =3D getopt(argc, argv, "c:a:d:u:p:o:Vvh")) !=3D EOF)
>> +       while ((c =3D getopt_long(argc, argv, "c:a:d:u:p:o:Vvh", opts,
>> NULL)) !=3D EOF)
>>                 switch (c) {
>>                 case 'a':
>>                         arg_name =3D g_ascii_strdown(optarg,
>> strlen(optarg));
>> diff --git a/adduser/adduser.c b/adduser/adduser.c
>> index 88b12db..60a059d 100644
>> --- a/adduser/adduser.c
>> +++ b/adduser/adduser.c
>> @@ -50,6 +50,16 @@ static void usage(void)
>>         exit(EXIT_FAILURE);
>>  }
>>
>> +static const struct option opts[] =3D {
>> +       {"add-user",            required_argument,      NULL,   'a' },
>> +       {"del-user",            required_argument,      NULL,   'd' },
>> +       {"update-user",         required_argument,      NULL,   'u' },
>> +       {"password",            required_argument,      NULL,   'p' },
>> +       {"import-users",        required_argument,      NULL,   'i' },
>> +       {"version",             no_argument,            NULL,   'V' },
>> +       {"verbose",             no_argument,            NULL,   'v' },
>> +};
>> +
>>  static void show_version(void)
>>  {
>>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
>> @@ -102,7 +112,7 @@ int main(int argc, char *argv[])
>>         set_logger_app_name("ksmbd.adduser");
>>
>>         opterr =3D 0;
>> -       while ((c =3D getopt(argc, argv, "c:i:a:d:u:p:Vvh")) !=3D EOF)
>> +       while ((c =3D getopt_long(argc, argv, "c:i:a:d:u:p:Vvh", opts,
>> NULL)) !=3D EOF)
>>                 switch (c) {
>>                 case 'a':
>>                         arg_account =3D g_strdup(optarg);
>> diff --git a/control/control.c b/control/control.c
>> index 780a48a..3dc8c7e 100644
>> --- a/control/control.c
>> +++ b/control/control.c
>> @@ -23,6 +23,13 @@ static void usage(void)
>>         exit(EXIT_FAILURE);
>>  }
>>
>> +static const struct option opts[] =3D {
>> +       {"shutdown",            no_argument,            NULL,   's' },
>> +       {"debug",               required_argument,      NULL,   'd' },
>> +       {"ksmbd-version",       no_argument,            NULL,   'c' },
>> +       {"version",             no_argument,            NULL,   'V' },
>> +};
>> +
>>  static void show_version(void)
>>  {
>>         printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
>> @@ -101,7 +108,7 @@ int main(int argc, char *argv[])
>>         }
>>
>>         opterr =3D 0;
>> -       while ((c =3D getopt(argc, argv, "sd:cVh")) !=3D EOF)
>> +       while ((c =3D getopt_long(argc, argv, "sd:cVh", opts, NULL)) !=
=3D
>> EOF)
>>                 switch (c) {
>>                 case 's':
>>                         ret =3D ksmbd_control_shutdown();
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
