Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45858C432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 21:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 142632068E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 21:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uP0PSg2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfKUVyS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:54:18 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38945 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUVyS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 16:54:18 -0500
Received: by mail-io1-f67.google.com with SMTP id k1so5335382ioj.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 13:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=42KSX+YjKWmU3m3lWymAlr/1QX2odj2xqVRijTpCtxo=;
        b=uP0PSg2mdiTMrRO1DmE+6P9Hi6eCr+saH9jO+pRkpMo9aBfgyBeTf0cIMn6IT+VqTj
         A/7sOofT2SqimDUAKrzfjO9mlfGVQ8mgLyI3XyPtuJ0r7+jjToXSnDPs6mnqRNi5xyYC
         adOo33y5Umu4McwCGnf8CXRJJ+enad53bSzYa7T/zZmCWTbOOb0fsz5Y8Ss1QtFmm4wf
         rGfyRGvs38PaPC5qo3lMPrkDwCHohvwdVbA4bBAtFsDLd0sFPbnco+1fF9KTPUMcX3aq
         uz5PAn1x4R5neHBq+OkNDjfbS2gJWS6vUpxvie+vdR7Kw5EVdE0DrkXiAb4aSSoJBeNB
         HHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=42KSX+YjKWmU3m3lWymAlr/1QX2odj2xqVRijTpCtxo=;
        b=cv+72wZ+yVDqPFnWsJP9D+ErZdwrEOCxcpUJ7QgKB6oBGHGNi3tsRYNLBUi71MUMdP
         IcmeTuiarit8lsjD+tOWJjeGmHRqHuhfirY8fE4tN/Pa6jJmbZ3rcayTy1wTZUvZ5asO
         gvKz/3smYLWvGIG6Vl5kIHHAtn1vjD+enQP/urNcNbimkvTGtLeq8ZXZjDH1dGhgAU0M
         nBV6M6jSJCvwQth/niUyIhzxEBVM4yQ0vtgeYPYHeZ+N7CiwUUKM2YhpAzZx4AtjaomH
         DM8iqtOwYJ20/G9qP5nlosXNZh34am2GGn5SSotOknBa1n+sXo0t7S7O/c6VKsOHRKxt
         gk5A==
X-Gm-Message-State: APjAAAX7huTwC57MZcVWgETK4y6EsT0/e8Z4wYxua34J0vnJeriKm7lu
        +w8bRKxmEJGwocAoL1sqmVDdFnZhbfWfXAAAkxg=
X-Google-Smtp-Source: APXvYqzTuP4IY7oDlXxt3pFfdOg7x1QkaYixcZG/2rh4ZnnS0V7iPCafLpxTFv4HLJ6sf28FXPrO5yOfyJ6ocXbrZVQ=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr9278688iom.5.1574373257582;
 Thu, 21 Nov 2019 13:54:17 -0800 (PST)
MIME-Version: 1.0
References: <20191120161559.30295-1-aaptel@suse.com>
In-Reply-To: <20191120161559.30295-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Nov 2019 15:54:06 -0600
Message-ID: <CAH2r5ms90gOG9JdiC20YcOaTajnmhHLP6j3aAiVO+FD9c7TmmA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: dump channel info in DebugData
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With current for-next got:

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/cifs_debug.c
/home/smfrench/cifs-2.6/fs/cifs/cifs_debug.c:141:39: error: no member
'in_send' in struct TCP_Server_Info
  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/cifs_debug.o
/home/smfrench/cifs-2.6/fs/cifs/cifs_debug.c: In function =E2=80=98cifs_dum=
p_channel=E2=80=99:
/home/smfrench/cifs-2.6/fs/cifs/cifs_debug.c:141:25: error: =E2=80=98struct
TCP_Server_Info=E2=80=99 has no member named =E2=80=98in_send=E2=80=99
  141 |      atomic_read(&server->in_send),
      |                         ^~
/home/smfrench/cifs-2.6/fs/cifs/cifs_debug.c:142:25: error: =E2=80=98struct
TCP_Server_Info=E2=80=99 has no member named =E2=80=98num_waiters=E2=80=99
  142 |      atomic_read(&server->num_waiters));

On Wed, Nov 20, 2019 at 10:16 AM Aurelien Aptel <aaptel@suse.com> wrote:
>
> * show server&TCP states for extra channels
> * mention if an interface has a channel connected to it
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifs_debug.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index efb2928ff6c8..c2dd07903d56 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -121,6 +121,27 @@ static void cifs_debug_tcon(struct seq_file *m, stru=
ct cifs_tcon *tcon)
>         seq_putc(m, '\n');
>  }
>
> +static void
> +cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
> +{
> +       struct TCP_Server_Info *server =3D chan->server;
> +
> +       seq_printf(m, "\t\tChannel %d Number of credits: %d Dialect 0x%x =
"
> +                  "TCP status: %d Instance: %d Local Users To Server: %d=
 "
> +                  "SecMode: 0x%x Req On Wire: %d In Send: %d "
> +                  "In MaxReq Wait: %d\n",
> +                  i+1,
> +                  server->credits,
> +                  server->dialect,
> +                  server->tcpStatus,
> +                  server->reconnect_instance,
> +                  server->srv_count,
> +                  server->sec_mode,
> +                  in_flight(server),
> +                  atomic_read(&server->in_send),
> +                  atomic_read(&server->num_waiters));
> +}
> +
>  static void
>  cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
>  {
> @@ -377,6 +398,13 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>                         if (ses->sign)
>                                 seq_puts(m, " signed");
>
> +                       if (ses->chan_count > 1) {
> +                               seq_printf(m, "\n\n\tExtra Channels: %lu\=
n",
> +                                          ses->chan_count-1);
> +                               for (j =3D 1; j < ses->chan_count; j++)
> +                                       cifs_dump_channel(m, j, &ses->cha=
ns[j]);
> +                       }
> +
>                         seq_puts(m, "\n\tShares:");
>                         j =3D 0;
>
> @@ -415,8 +443,13 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>                                 seq_printf(m, "\n\tServer interfaces: %zu=
\n",
>                                            ses->iface_count);
>                         for (j =3D 0; j < ses->iface_count; j++) {
> +                               struct cifs_server_iface *iface;
> +
> +                               iface =3D &ses->iface_list[j];
>                                 seq_printf(m, "\t%d)", j);
> -                               cifs_dump_iface(m, &ses->iface_list[j]);
> +                               cifs_dump_iface(m, iface);
> +                               if (is_ses_using_iface(ses, iface))
> +                                       seq_puts(m, "\t\t[CONNECTED]\n");
>                         }
>                         spin_unlock(&ses->iface_lock);
>                 }
> --
> 2.16.4
>


--=20
Thanks,

Steve
