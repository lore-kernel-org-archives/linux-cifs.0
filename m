Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCB0C77B7A
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Jun 2023 08:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjFKICs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Jun 2023 04:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjFKICs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Jun 2023 04:02:48 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F9430D2
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:02:46 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1a66e71f9so36016301fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 11 Jun 2023 01:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686470565; x=1689062565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fW0jMaqX09j+leRNNCystKnsznf15MjlwaRACrzrx+o=;
        b=DvbLcODza5YL0SYho6Nvi/BwBQu+nJVaCWle34++5hveGo73dN4xlVbVgFABr+7jWU
         BBhLnvhI/H2J+wCdwezkdabMqXEbVuhovK/WIqJ3SJQXdbh8U+0r4wjyyBcMs7Un8i+q
         qFQe0f4SjLQlWDZgIeULeGALPTEbOJCM8VZd/t6VosbahzdpqV8vMrPFu7sRNV9cI8S0
         NcRyZfBWeJZwoRJHEuQuG96TRzSB0qwt9nljdmjwxi7oVvPYkYItbKYt96h7SY/OUmVM
         iYoBJbIgcZWG4rWFfmLKgmEhq76s8rH0V4llEG9qFNK3KHk5G2zoI14LEe9B8pTvAvjX
         naTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686470565; x=1689062565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fW0jMaqX09j+leRNNCystKnsznf15MjlwaRACrzrx+o=;
        b=Xk2dPmn0U2rxvRPnlWMKXIZM8hI/H5R3YGn99S63XGGHQgeq6rUGn+nDA5abZ9sieZ
         z+0vtX4d0DxXOneB6xcTpfNH6iM9k0EmAQpCnigg6sRknnptoBaWEQrRy+npyDaOFnI8
         Sg7oBvekbSUTJcRPN6Cz15v4mO1Q+NeRFSucvVDKV4qcL400231QFTuq//w51+GfoP5Y
         tPzXh6L9UcHFPLafLMBAF1N0PnRT22y6eqat0a8dmn4mk4ip7dhcSnDVZVzwN43Ezn/E
         o2wUOpwUXg3NgB/tT4XU3+23bIZvNIH4we+WmFzrPRLk72802aPpHkbQH61GB8RG5fOj
         ei6A==
X-Gm-Message-State: AC+VfDwnkL01B0wrLblo3KC5hsDu5MdL+2o9VqKYx4QVFh2BXCFqrDov
        g8mb1mda90wmoFnzDNXn2dHA20i3YaQ3DsnckzE0GRWvk4iQ3Q==
X-Google-Smtp-Source: ACHHUZ6HPJ/QJsYyElwEVWkcYfom/thQlinVKNh9M0QEWcvBqyVy2NCTKBU7b22e2qaMtN/BlOPS3T9+W8n8+5KAfMw=
X-Received: by 2002:a19:ca45:0:b0:4f1:1de7:1aaf with SMTP id
 h5-20020a19ca45000000b004f11de71aafmr2527912lfj.69.1686470565095; Sun, 11 Jun
 2023 01:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
In-Reply-To: <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 11 Jun 2023 13:32:33 +0530
Message-ID: <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 9, 2023 at 11:32=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi Shyam,
>
> On 06/09, Shyam Prasad N wrote:
> >With multichannel, it is useful to know the src port details
> >for each channel. This change will print the ip addr and
> >port details for both the socket dest and src endpoints.
> >
> >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >---
> > fs/smb/client/cifs_debug.c | 46 ++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 46 insertions(+)
> >
> >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> >index 17c884724590..d5fd3681f56e 100644
> >--- a/fs/smb/client/cifs_debug.c
> >+++ b/fs/smb/client/cifs_debug.c
> >@@ -12,6 +12,7 @@
> > #include <linux/module.h>
> > #include <linux/proc_fs.h>
> > #include <linux/uaccess.h>
> >+#include <net/inet_sock.h>
> > #include "cifspdu.h"
> > #include "cifsglob.h"
> > #include "cifsproto.h"
> >@@ -146,6 +147,30 @@ cifs_dump_channel(struct seq_file *m, int i, struct=
 cifs_chan *chan)
> >                  in_flight(server),
> >                  atomic_read(&server->in_send),
> >                  atomic_read(&server->num_waiters));
> >+
> >+#ifndef CONFIG_CIFS_SMB_DIRECT
> >+      if (server->ssocket) {
> >+              if (server->dstaddr.ss_family =3D=3D AF_INET6) {
> >+                      struct sockaddr_in6 *ipv6 =3D (struct sockaddr_in=
6 *)&server->dstaddr;
> >+                      struct sock *sk =3D server->ssocket->sk;
> >+                      struct inet_sock *inet =3D inet_sk(server->ssocke=
t->sk);
> >+                      seq_printf(m, "\n\t\tIPv6 Dest: [%pI6]:%d Src: [%=
pI6]:%d",
> >+                                 &ipv6->sin6_addr,
> >+                                 ntohs(ipv6->sin6_port),
> >+                                 &sk->sk_v6_rcv_saddr.s6_addr32,
> >+                                 ntohs(inet->inet_sport));
> >+              } else {
> >+                      struct sockaddr_in *ipv4 =3D (struct sockaddr_in =
*)&server->dstaddr;
> >+                      struct inet_sock *inet =3D inet_sk(server->ssocke=
t->sk);
> >+                      seq_printf(m, "\n\t\tIPv4 Dest: %pI4:%d Src: %pI4=
:%d",
> >+                                 &ipv4->sin_addr,
> >+                                 ntohs(ipv4->sin_port),
> >+                                 &inet->inet_saddr,
> >+                                 ntohs(inet->inet_sport));
> >+              }
> >+      }
> >+#endif
> >+
> > }
> >
> > static void
> >@@ -351,6 +376,27 @@ static int cifs_debug_data_proc_show(struct seq_fil=
e *m, void *v)
> >                       atomic_read(&server->smbd_conn->mr_ready_count),
> >                       atomic_read(&server->smbd_conn->mr_used_count));
> > skip_rdma:
> >+#else
> >+              if (server->ssocket) {
> >+                      if (server->dstaddr.ss_family =3D=3D AF_INET6) {
> >+                              struct sockaddr_in6 *ipv6 =3D (struct soc=
kaddr_in6 *)&server->dstaddr;
> >+                              struct sock *sk =3D server->ssocket->sk;
> >+                              struct inet_sock *inet =3D inet_sk(server=
->ssocket->sk);
> >+                              seq_printf(m, "\nIPv6 Dest: [%pI6]:%d Src=
: [%pI6]:%d",
> >+                                         &ipv6->sin6_addr,
> >+                                         ntohs(ipv6->sin6_port),
> >+                                         &sk->sk_v6_rcv_saddr.s6_addr32=
,
> >+                                         ntohs(inet->inet_sport));
> >+                      } else {
> >+                              struct sockaddr_in *ipv4 =3D (struct sock=
addr_in *)&server->dstaddr;
> >+                              struct inet_sock *inet =3D inet_sk(server=
->ssocket->sk);
> >+                              seq_printf(m, "\nIPv4 Dest: %pI4:%d Src: =
%pI4:%d",
> >+                                         &ipv4->sin_addr,
> >+                                         ntohs(ipv4->sin_port),
> >+                                         &inet->inet_saddr,
> >+                                         ntohs(inet->inet_sport));
> >+                      }
> >+              }
> > #endif
> >               seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x=
",
> >                       server->credits,
>
> You could save a lot of lines by using the generic formats for IP
> addresses (Documentation/printk-formats.txt, look for "IPv4/IPv6
> addresses (generic, with port, flowinfo, scope)").
>
> e.g. using %pISpc will give you:
> 1.2.3.4:12345 for IPv4 or [1:2:3:4:5:6:7:8]:12345 for IPv6, just by
> passing &server->dstaddr (without any casts), and you don't have to
> check address family every time as well.
>
> And to properly get the source IP being used by the socket there's
> kernel_getpeername().
>
> e.g.:
> {
>         ...
>         struct sockaddr src;
>         int addrlen;
>
>         addrlen =3D kernel_getpeername(server->ssocket, &src);
>         if (addrlen !=3D sizeof(struct sockaddr_in) && addrlen !=3D sizeo=
f(struct sockaddr_in6))
>                 continue; // skip or "return addrlen < 0 ? addrlen : -EAF=
NOSUPPORT;"
>         ...
>         seq_print(m, "IP: src=3D%pISpc, dest=3D%pISpc", &server->dstaddr,=
 &src);
>         ...
> }
>
>
> Cheers,
>
> Enzo

Hi Enzo,

Thanks for the review. Very good points.
Let me test out with these changes.

--=20
Regards,
Shyam
