Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A38C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Nov 2021 02:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhKXCPO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Nov 2021 21:15:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhKXCPO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 23 Nov 2021 21:15:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F52B60E73
        for <linux-cifs@vger.kernel.org>; Wed, 24 Nov 2021 02:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637719925;
        bh=fWF1FwL98pdgG+6p2d4gFleBFQhqMMtiTh3asxlTzmQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WpAhozz8meixHQeqAZtQmeyou+ovr3w3tskta/Ck/zelP+m3JvKOeL/Rve2Lz983Y
         1gxqmtJJzqc4xfUNVG+QRlkDaomVZUo5FvOm4nUCssc0A4IVzkWYVTOTVVChPGC0Qp
         0+3O2CfH1BNUZSUChOaX0Ag5v6eO9PFQ6qxVHQVf2uEVHOTGnwALqRo72AipFbYRtS
         XWcFTgyfpVYpTLUhuEd9f4IE65m9we6uWhc5LpYCDH3tdxatNwbXHrxRfRtBY0CZsr
         dp4wO0UI3MwOFOoBQW6wc7phMc0AcRKzlnfK6DYYNeI2iBoB1W/Gbaguk8/Ezunnd/
         WUAJKCXEyk1WQ==
Received: by mail-oi1-f178.google.com with SMTP id be32so2019088oib.11
        for <linux-cifs@vger.kernel.org>; Tue, 23 Nov 2021 18:12:05 -0800 (PST)
X-Gm-Message-State: AOAM5315RgcSICP0VoYRtnJ8+oTE/0iaMC+3o0XUq0DuyKzyNudnuX/g
        Nu9gXWWmSVT9kBR/7xsUlJYePjxGwDXy1E+vGSk=
X-Google-Smtp-Source: ABdhPJy528LCuTFhNPv4GjXZhG1aHj2KOrgNIwDlMUb8AOgJ2F6r0tb808InFuS8bnswkN0CRp2+1Jqfzm3dkwQY+4c=
X-Received: by 2002:a05:6808:14c3:: with SMTP id f3mr2074030oiw.51.1637719924434;
 Tue, 23 Nov 2021 18:12:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Tue, 23 Nov 2021 18:12:04
 -0800 (PST)
In-Reply-To: <CAF6XXKUWzukTd4_fLqOjvv3GLQu_DO5g21s9=T3HFTS3-vmreA@mail.gmail.com>
References: <20211121114009.6039-1-linkinjeon@kernel.org> <CAF6XXKWr0w5hsKgs2QLh+W9=+T2xK_OkNM7_cBjKFSpLfN_V4w@mail.gmail.com>
 <CAKYAXd__m2sauDX2kzroAjy+ohydD4L0pnEr8zDxRZG_KPkgjg@mail.gmail.com> <CAF6XXKUWzukTd4_fLqOjvv3GLQu_DO5g21s9=T3HFTS3-vmreA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 24 Nov 2021 11:12:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8zrqScxrbaenLmh+_qKqQqh5z6gUj0AeJAEShkwJCuJQ@mail.gmail.com>
Message-ID: <CAKYAXd8zrqScxrbaenLmh+_qKqQqh5z6gUj0AeJAEShkwJCuJQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: fix file transfer stuck at 99%
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-11-22 21:14 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> On Mon, Nov 22, 2021 at 11:46 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> 2021-11-22 18:28 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
>> > On Sun, Nov 21, 2021 at 12:40 PM Namjae Jeon <linkinjeon@kernel.org>
>> > wrote:
>> >>
>> >> When user set share name included upper character in smb.conf,
>> >> Windows File transfer will stuck at 99%. When copying file, windows
>> >> send
>> >> SRVSVC GET_SHARE_INFO command to ksmbd server. but ksmbd store after
>> >> converting share name from smb.conf to lower cases. So ksmbd.mountd
>> >> can't not find share and return error to windows client.
>> >> This patch find share using name converted share name from client to
>> >> lower cases.
>> >>
>> >> Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
>> >> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
>> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> >> ---
>> >>  mountd/rpc_srvsvc.c | 10 ++++++++--
>> >>  1 file changed, 8 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
>> >> index 8608b2e..f3b4d06 100644
>> >> --- a/mountd/rpc_srvsvc.c
>> >> +++ b/mountd/rpc_srvsvc.c
>> >> @@ -169,8 +169,11 @@ static int srvsvc_share_get_info_invoke(struct
>> >> ksmbd_rpc_pipe *pipe,
>> >>  {
>> >>         struct ksmbd_share *share;
>> >>         int ret;
>> >> +       gchar *share_name;
>> >>
>> >> -       share = shm_lookup_share(STR_VAL(hdr->share_name));
>> >> +       share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
>> >> +                       strlen(STR_VAL(hdr->share_name)));
>> >> +       share = shm_lookup_share(share_name);
>> >>         if (!share)
>> >>                 return 0;
>> >>
>> >> @@ -188,9 +191,12 @@ static int srvsvc_share_get_info_invoke(struct
>> >> ksmbd_rpc_pipe *pipe,
>> >>         }
>> >>
>> >>         if (ret != 0) {
>> >> +               gchar *server_name =
>> >> g_ascii_strdown(STR_VAL(hdr->server_name),
>> >> +                               strlen(STR_VAL(hdr->server_name)));
>> >> +
>> >>                 ret = shm_lookup_hosts_map(share,
>> >>                                            KSMBD_SHARE_HOSTS_DENY_MAP,
>> >> -                                          STR_VAL(hdr->server_name));
>> >> +                                          server_name);
>> >>                 if (ret == 0) {
>> >>                         put_ksmbd_share(share);
>> >>                         return 0;
>> >> --
>> >> 2.25.1
>> >>
>> >
>> > Awesome work tracking this down. This raises a question though: why is
>> > ksmbd.mountd
>> > converting share names to lowercase to begin with ?
>> Windows is case insensitive. So we need it to do a lookup using the
>> share name from windows.
>
> Right. I was thinking about Linux users using autofs (which can automount
> SMB shares). If the latter is configured to mount all shares on a server,
> switching from samba to ksmbd can cause /mnt/Share to become /mnt/share
> (since ksmbd will return lower case names when listing shares). This in
> turn
> can break other software that looks for things in /mnt/Share.
I don't understand exactly how the problem is. Could you please check
if this is actually a problem ? Even better if you can improve it ? :)

>
>
>> > I checked samba, and the share name sent back to the client has the
>> > same
>> > case as
>> > defined in smb.conf.
>> There should be no problems with the current way. And if you test
>> adding multiple case sensitive share names to smb.conf, You will find
>> that only one of them is available.
>> >
>
