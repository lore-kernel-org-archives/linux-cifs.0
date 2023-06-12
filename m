Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA366C7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 08:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjFLIAr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 04:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbjFLIAP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 04:00:15 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EE21729
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 00:59:40 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b1a46ad09fso46138411fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 00:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556775; x=1689148775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4U2/DVyE9N4cpXy/o52JEtnijmnD1GJKs7d1ZHBHs1g=;
        b=jH7lLL4BJAM/fcppqsE3Hqzdt0UXXANQjKuhdI8wSrk379xiJJYafeWRyiYdlBFpbO
         z2fgaaqMeahEHyA9vxK1xEy1qIphLw9D3iocPUGi0srHIECAxszEPyz1nIibdF1hDvJG
         slpEYk5OfVFLOJufbHZkxrZvcCYUgE4J4jIBW9tHsAg/ZD9pJMVRJda+OBB+LABuE98d
         rKetKaUs/8EooynlDcovlUb+Rsx/nAxlJaSxjNcDXAlmw36MQHPTNGnVnVLTKike5mWF
         68+nh6F+EN49eS3YB4ZLCv/nY8FM8fZrMG4aj6ZdoBhyCUGZKOTXmphLnmGuDYTtaFM2
         RjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556775; x=1689148775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4U2/DVyE9N4cpXy/o52JEtnijmnD1GJKs7d1ZHBHs1g=;
        b=b2BPVWpWEy28HM8KuS11xHoIxZdULErKxx8XBuZrWpWKbs3ErR7EKzgyBOofj6w1iN
         w5v4M6/qwSmM2L4zTe/NBlJSK2Epxvzk+3HotYEfLzZMBvxCH5sUU2dOdMAAZiktTJR0
         Xakg1H1IHlwLDG5zp1nTg7pJNW8w/HJKuPqSCOmue4po25pWE9sgKm+q4VvtLimzd77P
         9tkAKHuKX2r7vEmqTZwrZS4vce591F/UxvbljyITosbWy/hIkMhX/+acP4PZfPnkq6hJ
         t/pQlk2+Z143um7oJncaXUGEPWvOUA8lj5rjVv20fdQPZikuOxqmuZ0pOHL2QuLA2+j6
         DW9A==
X-Gm-Message-State: AC+VfDwFLjqJC6LjMTA4ck2oneCqxtZHhlX6OpzNEJ5aRhVFPN7Q62h2
        N/RHyv2/iSvrC43H3wlKDH5lMDf8zMKzuCmhmoM=
X-Google-Smtp-Source: ACHHUZ7kTl3wtrbTfwgIYRr/lKTLfyak9TMSYjaI3Ir4f3cbTwHcMaj5YlmyO6WF+H64r6jQL/kMhkYdHjfCQ7rRSFM=
X-Received: by 2002:a2e:9dca:0:b0:2a8:a651:8098 with SMTP id
 x10-20020a2e9dca000000b002a8a6518098mr2278355ljj.38.1686556774558; Mon, 12
 Jun 2023 00:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p> <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
In-Reply-To: <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 12 Jun 2023 13:29:23 +0530
Message-ID: <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
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

On Sun, Jun 11, 2023 at 1:32=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, Jun 9, 2023 at 11:32=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > Hi Shyam,
> >
> > On 06/09, Shyam Prasad N wrote:
> > >With multichannel, it is useful to know the src port details
> > >for each channel. This change will print the ip addr and
> > >port details for both the socket dest and src endpoints.
> > >
> > >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > >---
> > > fs/smb/client/cifs_debug.c | 46 +++++++++++++++++++++++++++++++++++++=
+
> > > 1 file changed, 46 insertions(+)
> > >
> > >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> > >index 17c884724590..d5fd3681f56e 100644
> > >--- a/fs/smb/client/cifs_debug.c
> > >+++ b/fs/smb/client/cifs_debug.c
> > >@@ -12,6 +12,7 @@
> > > #include <linux/module.h>
> > > #include <linux/proc_fs.h>
> > > #include <linux/uaccess.h>
> > >+#include <net/inet_sock.h>
> > > #include "cifspdu.h"
> > > #include "cifsglob.h"
> > > #include "cifsproto.h"
> > >@@ -146,6 +147,30 @@ cifs_dump_channel(struct seq_file *m, int i, stru=
ct cifs_chan *chan)
> > >                  in_flight(server),
> > >                  atomic_read(&server->in_send),
> > >                  atomic_read(&server->num_waiters));
> > >+
> > >+#ifndef CONFIG_CIFS_SMB_DIRECT
> > >+      if (server->ssocket) {
> > >+              if (server->dstaddr.ss_family =3D=3D AF_INET6) {
> > >+                      struct sockaddr_in6 *ipv6 =3D (struct sockaddr_=
in6 *)&server->dstaddr;
> > >+                      struct sock *sk =3D server->ssocket->sk;
> > >+                      struct inet_sock *inet =3D inet_sk(server->ssoc=
ket->sk);
> > >+                      seq_printf(m, "\n\t\tIPv6 Dest: [%pI6]:%d Src: =
[%pI6]:%d",
> > >+                                 &ipv6->sin6_addr,
> > >+                                 ntohs(ipv6->sin6_port),
> > >+                                 &sk->sk_v6_rcv_saddr.s6_addr32,
> > >+                                 ntohs(inet->inet_sport));
> > >+              } else {
> > >+                      struct sockaddr_in *ipv4 =3D (struct sockaddr_i=
n *)&server->dstaddr;
> > >+                      struct inet_sock *inet =3D inet_sk(server->ssoc=
ket->sk);
> > >+                      seq_printf(m, "\n\t\tIPv4 Dest: %pI4:%d Src: %p=
I4:%d",
> > >+                                 &ipv4->sin_addr,
> > >+                                 ntohs(ipv4->sin_port),
> > >+                                 &inet->inet_saddr,
> > >+                                 ntohs(inet->inet_sport));
> > >+              }
> > >+      }
> > >+#endif
> > >+
> > > }
> > >
> > > static void
> > >@@ -351,6 +376,27 @@ static int cifs_debug_data_proc_show(struct seq_f=
ile *m, void *v)
> > >                       atomic_read(&server->smbd_conn->mr_ready_count)=
,
> > >                       atomic_read(&server->smbd_conn->mr_used_count))=
;
> > > skip_rdma:
> > >+#else
> > >+              if (server->ssocket) {
> > >+                      if (server->dstaddr.ss_family =3D=3D AF_INET6) =
{
> > >+                              struct sockaddr_in6 *ipv6 =3D (struct s=
ockaddr_in6 *)&server->dstaddr;
> > >+                              struct sock *sk =3D server->ssocket->sk=
;
> > >+                              struct inet_sock *inet =3D inet_sk(serv=
er->ssocket->sk);
> > >+                              seq_printf(m, "\nIPv6 Dest: [%pI6]:%d S=
rc: [%pI6]:%d",
> > >+                                         &ipv6->sin6_addr,
> > >+                                         ntohs(ipv6->sin6_port),
> > >+                                         &sk->sk_v6_rcv_saddr.s6_addr=
32,
> > >+                                         ntohs(inet->inet_sport));
> > >+                      } else {
> > >+                              struct sockaddr_in *ipv4 =3D (struct so=
ckaddr_in *)&server->dstaddr;
> > >+                              struct inet_sock *inet =3D inet_sk(serv=
er->ssocket->sk);
> > >+                              seq_printf(m, "\nIPv4 Dest: %pI4:%d Src=
: %pI4:%d",
> > >+                                         &ipv4->sin_addr,
> > >+                                         ntohs(ipv4->sin_port),
> > >+                                         &inet->inet_saddr,
> > >+                                         ntohs(inet->inet_sport));
> > >+                      }
> > >+              }
> > > #endif
> > >               seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x=
%x",
> > >                       server->credits,
> >
> > You could save a lot of lines by using the generic formats for IP
> > addresses (Documentation/printk-formats.txt, look for "IPv4/IPv6
> > addresses (generic, with port, flowinfo, scope)").
> >
> > e.g. using %pISpc will give you:
> > 1.2.3.4:12345 for IPv4 or [1:2:3:4:5:6:7:8]:12345 for IPv6, just by
> > passing &server->dstaddr (without any casts), and you don't have to
> > check address family every time as well.
> >
> > And to properly get the source IP being used by the socket there's
> > kernel_getpeername().
> >
> > e.g.:
> > {
> >         ...
> >         struct sockaddr src;
> >         int addrlen;
> >
> >         addrlen =3D kernel_getpeername(server->ssocket, &src);
> >         if (addrlen !=3D sizeof(struct sockaddr_in) && addrlen !=3D siz=
eof(struct sockaddr_in6))
> >                 continue; // skip or "return addrlen < 0 ? addrlen : -E=
AFNOSUPPORT;"
> >         ...
> >         seq_print(m, "IP: src=3D%pISpc, dest=3D%pISpc", &server->dstadd=
r, &src);
> >         ...
> > }
> >
> >
> > Cheers,
> >
> > Enzo
>
> Hi Enzo,
>
> Thanks for the review. Very good points.
> Let me test out with these changes.
>
> --
> Regards,
> Shyam

Hi Enzo,

Attached the updated patch. Please review.
I had to use kernel_getsockname to get socket source details, not
kernel_getpeername.

Here's what the new output looks like:
IP addr: dst: 192.168.10.1:445, src: 192.168.10.12:57966

--=20
Regards,
Shyam
