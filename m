Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D7FC7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 08:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjFLIBZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 04:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjFLIAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 04:00:50 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F7D2D7E
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 01:00:14 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b1a653b409so49301901fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 01:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556811; x=1689148811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x48g/k9n7AxzNL2cVXHvQ5mO01C130g4rBKRy12mPE8=;
        b=bACCinY4QcocYFxQ69dBZFQHku29tj5X7WaG3neqzoyaVB0pFbR2uH7el6MnalIBuI
         ay/2koWPIUY0sFCHM4Od+OB/WU45ngk3oWRuh71FdT7mHUI0Q0oDDHP1gR9+186cG9D6
         FmYkVIGxjpCC1OgK0ie8nP4KTofHHeCy6RylbNv4BkFB1IlDmYKb0ntajakO+95e35Um
         oTaPR3cZEPPQM7PYmrKfaC5J7nqzBME9m/m0gsRvEDr0ZBx3oD7f8SfP/bqgEuM7Ov98
         Z9GmEXZFUN5fcC5Vr5YI3cfGUMBybWBXF62e8vPMuXbv0mkEisXHQ96AB5Q7tMsatE2S
         hB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556811; x=1689148811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x48g/k9n7AxzNL2cVXHvQ5mO01C130g4rBKRy12mPE8=;
        b=arXsGAq1N8LHrT2SyC6URdr0v94zW7B85n3qek+x/6OWBN+FcIC8xsh1czGimxXMfM
         4WVfhIItUWiv46HiBt+A0wROhH0/GMu/eESXa/ygaQFkVVgpnRfjgWEgAIeeYWpmNC+S
         +7nb/04p77zJ8AQV5hpJIUxnCJSr3qnS/OsvmAoABS+9uPlLh70fyIX1zb69lsl4YoRH
         it0FWk2Dx11trvlhQ0//oZYSCrO+1QXJmJlB3/dhVo0rPpWAfjvS7i1EiekZGzYCZ71X
         9Gu6y27jPqO/VE1PYt65CbdHpvXWMOU806o62ESRqEaD7g2Xaqm6wHfeQMbMTefEGbuN
         Ffcw==
X-Gm-Message-State: AC+VfDxYrjyWbCcN/1EX0oKAPeu65GiuSxBE+uhbsbX0eN1t1DoGCP/D
        xt5hjA5QMBdikgx0ZG18O2wHKCNQ/4pSxxTcL6Ely/Wo4zN4Tg==
X-Google-Smtp-Source: ACHHUZ5/HqJpbAgeCOhWQQZNg1O8f/t2Y+urSPmYq4BNjWHjXCFlXdg9p2sAkQL5aavp6cnofh2sA7T0nSnbg0zjeCk=
X-Received: by 2002:a2e:920a:0:b0:2b3:1e37:6730 with SMTP id
 k10-20020a2e920a000000b002b31e376730mr1774119ljg.16.1686556810563; Mon, 12
 Jun 2023 01:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com> <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
In-Reply-To: <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 12 Jun 2023 13:29:59 +0530
Message-ID: <CANT5p=qZrNZTzaNVpf6GW5hMDn9npCOM-PXyDXXQPxuETZ4BcA@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000096eab205fdea1b2c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000096eab205fdea1b2c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 1:29=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Sun, Jun 11, 2023 at 1:32=E2=80=AFPM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Fri, Jun 9, 2023 at 11:32=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse=
.de> wrote:
> > >
> > > Hi Shyam,
> > >
> > > On 06/09, Shyam Prasad N wrote:
> > > >With multichannel, it is useful to know the src port details
> > > >for each channel. This change will print the ip addr and
> > > >port details for both the socket dest and src endpoints.
> > > >
> > > >Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > >---
> > > > fs/smb/client/cifs_debug.c | 46 +++++++++++++++++++++++++++++++++++=
+++
> > > > 1 file changed, 46 insertions(+)
> > > >
> > > >diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> > > >index 17c884724590..d5fd3681f56e 100644
> > > >--- a/fs/smb/client/cifs_debug.c
> > > >+++ b/fs/smb/client/cifs_debug.c
> > > >@@ -12,6 +12,7 @@
> > > > #include <linux/module.h>
> > > > #include <linux/proc_fs.h>
> > > > #include <linux/uaccess.h>
> > > >+#include <net/inet_sock.h>
> > > > #include "cifspdu.h"
> > > > #include "cifsglob.h"
> > > > #include "cifsproto.h"
> > > >@@ -146,6 +147,30 @@ cifs_dump_channel(struct seq_file *m, int i, st=
ruct cifs_chan *chan)
> > > >                  in_flight(server),
> > > >                  atomic_read(&server->in_send),
> > > >                  atomic_read(&server->num_waiters));
> > > >+
> > > >+#ifndef CONFIG_CIFS_SMB_DIRECT
> > > >+      if (server->ssocket) {
> > > >+              if (server->dstaddr.ss_family =3D=3D AF_INET6) {
> > > >+                      struct sockaddr_in6 *ipv6 =3D (struct sockadd=
r_in6 *)&server->dstaddr;
> > > >+                      struct sock *sk =3D server->ssocket->sk;
> > > >+                      struct inet_sock *inet =3D inet_sk(server->ss=
ocket->sk);
> > > >+                      seq_printf(m, "\n\t\tIPv6 Dest: [%pI6]:%d Src=
: [%pI6]:%d",
> > > >+                                 &ipv6->sin6_addr,
> > > >+                                 ntohs(ipv6->sin6_port),
> > > >+                                 &sk->sk_v6_rcv_saddr.s6_addr32,
> > > >+                                 ntohs(inet->inet_sport));
> > > >+              } else {
> > > >+                      struct sockaddr_in *ipv4 =3D (struct sockaddr=
_in *)&server->dstaddr;
> > > >+                      struct inet_sock *inet =3D inet_sk(server->ss=
ocket->sk);
> > > >+                      seq_printf(m, "\n\t\tIPv4 Dest: %pI4:%d Src: =
%pI4:%d",
> > > >+                                 &ipv4->sin_addr,
> > > >+                                 ntohs(ipv4->sin_port),
> > > >+                                 &inet->inet_saddr,
> > > >+                                 ntohs(inet->inet_sport));
> > > >+              }
> > > >+      }
> > > >+#endif
> > > >+
> > > > }
> > > >
> > > > static void
> > > >@@ -351,6 +376,27 @@ static int cifs_debug_data_proc_show(struct seq=
_file *m, void *v)
> > > >                       atomic_read(&server->smbd_conn->mr_ready_coun=
t),
> > > >                       atomic_read(&server->smbd_conn->mr_used_count=
));
> > > > skip_rdma:
> > > >+#else
> > > >+              if (server->ssocket) {
> > > >+                      if (server->dstaddr.ss_family =3D=3D AF_INET6=
) {
> > > >+                              struct sockaddr_in6 *ipv6 =3D (struct=
 sockaddr_in6 *)&server->dstaddr;
> > > >+                              struct sock *sk =3D server->ssocket->=
sk;
> > > >+                              struct inet_sock *inet =3D inet_sk(se=
rver->ssocket->sk);
> > > >+                              seq_printf(m, "\nIPv6 Dest: [%pI6]:%d=
 Src: [%pI6]:%d",
> > > >+                                         &ipv6->sin6_addr,
> > > >+                                         ntohs(ipv6->sin6_port),
> > > >+                                         &sk->sk_v6_rcv_saddr.s6_ad=
dr32,
> > > >+                                         ntohs(inet->inet_sport));
> > > >+                      } else {
> > > >+                              struct sockaddr_in *ipv4 =3D (struct =
sockaddr_in *)&server->dstaddr;
> > > >+                              struct inet_sock *inet =3D inet_sk(se=
rver->ssocket->sk);
> > > >+                              seq_printf(m, "\nIPv4 Dest: %pI4:%d S=
rc: %pI4:%d",
> > > >+                                         &ipv4->sin_addr,
> > > >+                                         ntohs(ipv4->sin_port),
> > > >+                                         &inet->inet_saddr,
> > > >+                                         ntohs(inet->inet_sport));
> > > >+                      }
> > > >+              }
> > > > #endif
> > > >               seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect =
0x%x",
> > > >                       server->credits,
> > >
> > > You could save a lot of lines by using the generic formats for IP
> > > addresses (Documentation/printk-formats.txt, look for "IPv4/IPv6
> > > addresses (generic, with port, flowinfo, scope)").
> > >
> > > e.g. using %pISpc will give you:
> > > 1.2.3.4:12345 for IPv4 or [1:2:3:4:5:6:7:8]:12345 for IPv6, just by
> > > passing &server->dstaddr (without any casts), and you don't have to
> > > check address family every time as well.
> > >
> > > And to properly get the source IP being used by the socket there's
> > > kernel_getpeername().
> > >
> > > e.g.:
> > > {
> > >         ...
> > >         struct sockaddr src;
> > >         int addrlen;
> > >
> > >         addrlen =3D kernel_getpeername(server->ssocket, &src);
> > >         if (addrlen !=3D sizeof(struct sockaddr_in) && addrlen !=3D s=
izeof(struct sockaddr_in6))
> > >                 continue; // skip or "return addrlen < 0 ? addrlen : =
-EAFNOSUPPORT;"
> > >         ...
> > >         seq_print(m, "IP: src=3D%pISpc, dest=3D%pISpc", &server->dsta=
ddr, &src);
> > >         ...
> > > }
> > >
> > >
> > > Cheers,
> > >
> > > Enzo
> >
> > Hi Enzo,
> >
> > Thanks for the review. Very good points.
> > Let me test out with these changes.
> >
> > --
> > Regards,
> > Shyam
>
> Hi Enzo,
>
> Attached the updated patch. Please review.
> I had to use kernel_getsockname to get socket source details, not
> kernel_getpeername.
>
> Here's what the new output looks like:
> IP addr: dst: 192.168.10.1:445, src: 192.168.10.12:57966
>
> --
> Regards,
> Shyam

Attached the patch now. :)

--=20
Regards,
Shyam

--00000000000096eab205fdea1b2c
Content-Type: application/octet-stream; 
	name="0004-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Disposition: attachment; 
	filename="0004-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_liskd0tp0>
X-Attachment-Id: f_liskd0tp0

RnJvbSBmN2I0NjUwMzEyOWFjMTJjZDNjMTI0MGFjNThkN2FjYjA1MGU1NmFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgSnVuIDIwMjMgMTI6NDY6MzQgKzAwMDAKU3ViamVjdDogW1BBVENIIDQv
Nl0gY2lmczogZGlzcGxheSB0aGUgZW5kcG9pbnQgSVAgZGV0YWlscyBpbiBEZWJ1Z0RhdGEKCldp
dGggbXVsdGljaGFubmVsLCBpdCBpcyB1c2VmdWwgdG8ga25vdyB0aGUgc3JjIHBvcnQgZGV0YWls
cwpmb3IgZWFjaCBjaGFubmVsLiBUaGlzIGNoYW5nZSB3aWxsIHByaW50IHRoZSBpcCBhZGRyIGFu
ZApwb3J0IGRldGFpbHMgZm9yIGJvdGggdGhlIHNvY2tldCBkZXN0IGFuZCBzcmMgZW5kcG9pbnRz
LgoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYyB8IDMwICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5j
CmluZGV4IDE3Yzg4NDcyNDU5MC4uYThmN2I0YzQ5YWUzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L2NpZnNfZGVidWcuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYwpAQCAtMTIs
NiArMTIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgogI2luY2x1ZGUgPGxpbnV4L3By
b2NfZnMuaD4KICNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CisjaW5jbHVkZSA8bmV0L2luZXRf
c29jay5oPgogI2luY2x1ZGUgImNpZnNwZHUuaCIKICNpbmNsdWRlICJjaWZzZ2xvYi5oIgogI2lu
Y2x1ZGUgImNpZnNwcm90by5oIgpAQCAtMTQ2LDYgKzE0NywyMiBAQCBjaWZzX2R1bXBfY2hhbm5l
bChzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIGludCBpLCBzdHJ1Y3QgY2lmc19jaGFuICpjaGFuKQogCQkg
ICBpbl9mbGlnaHQoc2VydmVyKSwKIAkJICAgYXRvbWljX3JlYWQoJnNlcnZlci0+aW5fc2VuZCks
CiAJCSAgIGF0b21pY19yZWFkKCZzZXJ2ZXItPm51bV93YWl0ZXJzKSk7CisKKyNpZm5kZWYgQ09O
RklHX0NJRlNfU01CX0RJUkVDVAorCWlmIChzZXJ2ZXItPnNzb2NrZXQpIHsKKwkJc3RydWN0IHNv
Y2thZGRyIHNyYzsKKwkJaW50IGFkZHJsZW47CisKKwkJYWRkcmxlbiA9IGtlcm5lbF9nZXRzb2Nr
bmFtZShzZXJ2ZXItPnNzb2NrZXQsICZzcmMpOworCQlpZiAoYWRkcmxlbiAhPSBzaXplb2Yoc3Ry
dWN0IHNvY2thZGRyX2luKSAmJiBhZGRybGVuICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW42
KSkKKwkJCWdvdG8gc2tpcF9hZGRyX2RldGFpbHM7CisKKwkJc2VxX3ByaW50ZihtLCAiXG5cdFx0
SVAgYWRkcjogZHN0OiAlcElTcGMsIHNyYzogJXBJU3BjIiwgJnNlcnZlci0+ZHN0YWRkciwgJnNy
Yyk7CisJfQorCitza2lwX2FkZHJfZGV0YWlsczoKKyNlbmRpZgorCiB9CiAKIHN0YXRpYyB2b2lk
CkBAIC0zNTEsNiArMzY4LDE5IEBAIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hv
dyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCiAJCQlhdG9taWNfcmVhZCgmc2VydmVyLT5z
bWJkX2Nvbm4tPm1yX3JlYWR5X2NvdW50KSwKIAkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPnNtYmRf
Y29ubi0+bXJfdXNlZF9jb3VudCkpOwogc2tpcF9yZG1hOgorI2Vsc2UKKwkJaWYgKHNlcnZlci0+
c3NvY2tldCkgeworCQkJc3RydWN0IHNvY2thZGRyIHNyYzsKKwkJCWludCBhZGRybGVuOworCisJ
CQlhZGRybGVuID0ga2VybmVsX2dldHNvY2tuYW1lKHNlcnZlci0+c3NvY2tldCwgJnNyYyk7CisJ
CQlpZiAoYWRkcmxlbiAhPSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX2luKSAmJiBhZGRybGVuICE9
IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW42KSkKKwkJCQlnb3RvIHNraXBfYWRkcl9kZXRhaWxz
OworCisJCQlzZXFfcHJpbnRmKG0sICJcbklQIGFkZHI6IGRzdDogJXBJU3BjLCBzcmM6ICVwSVNw
YyIsICZzZXJ2ZXItPmRzdGFkZHIsICZzcmMpOworCQl9CisKK3NraXBfYWRkcl9kZXRhaWxzOgog
I2VuZGlmCiAJCXNlcV9wcmludGYobSwgIlxuTnVtYmVyIG9mIGNyZWRpdHM6ICVkLCVkLCVkIERp
YWxlY3QgMHgleCIsCiAJCQlzZXJ2ZXItPmNyZWRpdHMsCi0tIAoyLjM0LjEKCg==
--00000000000096eab205fdea1b2c--
