Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF14BC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Nov 2021 12:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbhKVMRu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Nov 2021 07:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhKVMRu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Nov 2021 07:17:50 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8284C061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 04:14:43 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so75900028edc.6
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 04:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WfLCEi4rwe11vpnucbb4BluLM034Y13kRQlwMFCQF+I=;
        b=dnO4PXxMnYhJmwQtUP3+JZ+XVNWT03Dk9isAb5K2QBMPNlRy+OAisIhJ3BSfnCExwc
         dJLoN7MuHS3wXTomeUquyEP6RjRH960z6tXNOHhP8HkX8/jrCUBIsDyqP5+9ZkWoVHSV
         FmykVfBPjdiXDMuf+6hoFqQe3DfttwNhEpXog7l0jfbJHJeR3oldhs2YLEwuf7OaLRzH
         4OFwlkj1ow21xpzMdobeVM5CFix3Op16Q/VMdN0yfn3R10KGtIwIdjjVb0RPgK17pIiD
         9H0D7iPPcgLRBz3QooXTkTkGr8gLBUGsEovcNEXE3p87JJ4bQ9hzcbHSyguywZRMsrq4
         OLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WfLCEi4rwe11vpnucbb4BluLM034Y13kRQlwMFCQF+I=;
        b=TsgplXn+qXMKBgV/HPLLvBqPUaBlc4VeeZrIDkrBbuHMLkCWTi7TG7s2D7NVR5A/Or
         HXUlNvLMDbCcIcW39cqkdSTWn2blb78jfLciYTGhgGT168iv4vyfoNxjmzUkOGtSSCYE
         DgaQPHz7+z34znKvTI9WpnwCrHUk2YIO3cDdhvV3xZ2iMYaFiOBRwH1944RSqt+mDtyo
         CZOw67APeHFZRzeWlOit/0SmkVJDFbkeAxyGV4Nm7S5mXLHhpkjm1a+G2bje9FX51muM
         JlWt4+Dr21bgwr5MDldZTlEpu37OFyJKd0AN4wLly1zRL2pkHqGaRK3RjuSR0x/z1iwG
         ACAg==
X-Gm-Message-State: AOAM532givmI9NtAp0yDYTdQr0ZBgU9ptRJaF0ncQQ9KAqq4GJ5l/BsC
        tfrURrzHCxUHwLElUlIWIhA5KizL2i22TaW3ZpLiw3R32YLTRs/7
X-Google-Smtp-Source: ABdhPJy+iPse1bFhdQljVIb7kIVyJwSjSXuo1z348ZaAMFAV/QCSxy1BraNIjS8okElqjCXxxBbXd/PWUw679kFPbtk=
X-Received: by 2002:a17:907:2bd0:: with SMTP id gv16mr38121377ejc.121.1637583282452;
 Mon, 22 Nov 2021 04:14:42 -0800 (PST)
MIME-Version: 1.0
References: <20211121114009.6039-1-linkinjeon@kernel.org> <CAF6XXKWr0w5hsKgs2QLh+W9=+T2xK_OkNM7_cBjKFSpLfN_V4w@mail.gmail.com>
 <CAKYAXd__m2sauDX2kzroAjy+ohydD4L0pnEr8zDxRZG_KPkgjg@mail.gmail.com>
In-Reply-To: <CAKYAXd__m2sauDX2kzroAjy+ohydD4L0pnEr8zDxRZG_KPkgjg@mail.gmail.com>
From:   Marios Makassikis <mmakassikis@freebox.fr>
Date:   Mon, 22 Nov 2021 13:14:31 +0100
Message-ID: <CAF6XXKUWzukTd4_fLqOjvv3GLQu_DO5g21s9=T3HFTS3-vmreA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: fix file transfer stuck at 99%
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 22, 2021 at 11:46 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-11-22 18:28 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> > On Sun, Nov 21, 2021 at 12:40 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >>
> >> When user set share name included upper character in smb.conf,
> >> Windows File transfer will stuck at 99%. When copying file, windows send
> >> SRVSVC GET_SHARE_INFO command to ksmbd server. but ksmbd store after
> >> converting share name from smb.conf to lower cases. So ksmbd.mountd
> >> can't not find share and return error to windows client.
> >> This patch find share using name converted share name from client to
> >> lower cases.
> >>
> >> Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
> >> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >> ---
> >>  mountd/rpc_srvsvc.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
> >> index 8608b2e..f3b4d06 100644
> >> --- a/mountd/rpc_srvsvc.c
> >> +++ b/mountd/rpc_srvsvc.c
> >> @@ -169,8 +169,11 @@ static int srvsvc_share_get_info_invoke(struct
> >> ksmbd_rpc_pipe *pipe,
> >>  {
> >>         struct ksmbd_share *share;
> >>         int ret;
> >> +       gchar *share_name;
> >>
> >> -       share = shm_lookup_share(STR_VAL(hdr->share_name));
> >> +       share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
> >> +                       strlen(STR_VAL(hdr->share_name)));
> >> +       share = shm_lookup_share(share_name);
> >>         if (!share)
> >>                 return 0;
> >>
> >> @@ -188,9 +191,12 @@ static int srvsvc_share_get_info_invoke(struct
> >> ksmbd_rpc_pipe *pipe,
> >>         }
> >>
> >>         if (ret != 0) {
> >> +               gchar *server_name =
> >> g_ascii_strdown(STR_VAL(hdr->server_name),
> >> +                               strlen(STR_VAL(hdr->server_name)));
> >> +
> >>                 ret = shm_lookup_hosts_map(share,
> >>                                            KSMBD_SHARE_HOSTS_DENY_MAP,
> >> -                                          STR_VAL(hdr->server_name));
> >> +                                          server_name);
> >>                 if (ret == 0) {
> >>                         put_ksmbd_share(share);
> >>                         return 0;
> >> --
> >> 2.25.1
> >>
> >
> > Awesome work tracking this down. This raises a question though: why is
> > ksmbd.mountd
> > converting share names to lowercase to begin with ?
> Windows is case insensitive. So we need it to do a lookup using the
> share name from windows.

Right. I was thinking about Linux users using autofs (which can automount
SMB shares). If the latter is configured to mount all shares on a server,
switching from samba to ksmbd can cause /mnt/Share to become /mnt/share
(since ksmbd will return lower case names when listing shares). This in turn
can break other software that looks for things in /mnt/Share.


> > I checked samba, and the share name sent back to the client has the same
> > case as
> > defined in smb.conf.
> There should be no problems with the current way. And if you test
> adding multiple case sensitive share names to smb.conf, You will find
> that only one of them is available.
> >
