Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EF2C6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 14:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCWOEP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 10:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCWOEO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 10:04:14 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C619119
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 07:03:11 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bi9so27853772lfb.12
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 07:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679580190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOQetMaSZJeNzVjClm+fyta6IWYDYNGcO8Ll5rNU0Rg=;
        b=RrlNG0U+jDtZkeulhvHpLMUDCxk0SXpsIHK71lf1mX2OZ2tjEeMIBIQqV6UT7vFh2E
         GfLDu6S78BnVpK269bDpjWbzXjke9WTw6NlfzkxGvBQ8cJNiupzHaTmjT5/ogLRVtaCt
         Wl20ed9pwpImcLI6TB5WbV8iQT+3z/QHFl5TSr6Rk8vwkXvaEcq7WYKyUbD+njnMuqkC
         0HafRRWpwlmFJheTydrV/+F7j7BK5StMRJksOYbl8Pw/XyC7dIiILfant15ozYGS/G4C
         4kmJMtMQ3kqvUFKMN0PuXqDKWDW1w2PKSfoX5j6xJX7v6o3IPcHdjORRMMnTC8qahxwy
         3JcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679580190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOQetMaSZJeNzVjClm+fyta6IWYDYNGcO8Ll5rNU0Rg=;
        b=pQheVx3Gfw3I8G/QJtEkmli8Mbb0OVrIPFim6Dhk5JPTuNbPtngWr6cdH9l8A+535o
         UNmVgeIcr8yr0V2uH+XPVGdALPjqv2rYdAURKOP3JvIwSArUR4f5jFMEwioAeniufG1a
         rhHEKB+5WG+MYkTs94SiKEJc9VelUEE92zbac3LTREDrk2Ys0c7YKTHLvYnLDWSEV5ob
         sfrmVBFa5KI4FEo/oKeAdbLboCJY3C8di43IsZVWb3Ii1EIVZz72eWHDmwAOMifBYGkO
         kToPxVzyACiZh3jVqb0g+UpHzN5J/PtqBx03z9HiWKE4JNfimiuJjGw/q6oB9iGOV2PT
         N/DA==
X-Gm-Message-State: AO0yUKWxC9l09/Tf1VsNfBr9MygVqKbtK2dlI0qdQuNfqwG82IRKtAuG
        697WwXzElHYYf6HGC6Oqq7MXudb384/T/QeXk0olx5VAo2AI132l
X-Google-Smtp-Source: AK7set8TYyLqEFaEsXNIHMHmfwHG4jXQs5rhwOxsSONSO+PY1C+M5g0CYUEscmGIoG8RcCwuK6ml9AC+MkSx4gZ3xao=
X-Received: by 2002:a05:6512:2803:b0:4e8:49cc:6744 with SMTP id
 cf3-20020a056512280300b004e849cc6744mr3298073lfb.1.1679580189398; Thu, 23 Mar
 2023 07:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <13de0bf0-aa74-46a3-8389-3c70fe77be1f@kili.mountain> <bbb33b9e-570f-8d02-1162-fa93fbe006dd@talpey.com>
In-Reply-To: <bbb33b9e-570f-8d02-1162-fa93fbe006dd@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 23 Mar 2023 19:32:58 +0530
Message-ID: <CANT5p=rTryD+hrQTnSMJkp61zPTdphNZqraazHYD2FK02B4YVw@mail.gmail.com>
Subject: Re: [cifs:for-next 3/8] fs/cifs/connect.c:1303 cifs_ipaddr_cmp()
 error: memcmp() '&saddr4->sin_addr.s_addr' too small (4 vs 16)
To:     Tom Talpey <tom@talpey.com>
Cc:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
        Shyam Prasad N <sprasad@microsoft.com>, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 23, 2023 at 7:10=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/23/2023 5:40 AM, Dan Carpenter wrote:
> > tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> > head:   96114df697dfaef2ce29c14089a83e4a5777e915
> > commit: 010c4e0a894e6a3dee3176aa2f654fce632d0346 [3/8] cifs: fix sockad=
dr comparison in iface_cmp
> > config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/2=
0230323/202303230210.ufS9gVzi-lkp@intel.com/config)
> > compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Link: https://lore.kernel.org/r/202303230210.ufS9gVzi-lkp@intel.com/
> >
> > New smatch warnings:
> > fs/cifs/connect.c:1303 cifs_ipaddr_cmp() error: memcmp() '&saddr4->sin_=
addr.s_addr' too small (4 vs 16)
> > fs/cifs/connect.c:1318 cifs_ipaddr_cmp() error: memcmp() '&saddr6->sin6=
_addr' too small (16 vs 28)
> >
> > Old smatch warnings:
> > fs/cifs/connect.c:1303 cifs_ipaddr_cmp() error: memcmp() '&vaddr4->sin_=
addr.s_addr' too small (4 vs 16)
> > fs/cifs/connect.c:1318 cifs_ipaddr_cmp() error: memcmp() '&vaddr6->sin6=
_addr' too small (16 vs 28)
> > fs/cifs/connect.c:2937 generic_ip_connect() error: we previously assume=
d 'socket' could be null (see line 2925)
> >
> > vim +1303 fs/cifs/connect.c
> >
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1279  int
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1280  cifs_ipaddr_cmp(struct=
 sockaddr *srcaddr, struct sockaddr *rhs)
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1281  {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1282       struct sockaddr_i=
n *saddr4 =3D (struct sockaddr_in *)srcaddr;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1283       struct sockaddr_i=
n *vaddr4 =3D (struct sockaddr_in *)rhs;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1284       struct sockaddr_i=
n6 *saddr6 =3D (struct sockaddr_in6 *)srcaddr;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1285       struct sockaddr_i=
n6 *vaddr6 =3D (struct sockaddr_in6 *)rhs;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1286
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1287       switch (srcaddr->=
sa_family) {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1288       case AF_UNSPEC:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1289               switch (r=
hs->sa_family) {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1290               case AF_U=
NSPEC:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1291                       r=
eturn 0;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1292               case AF_I=
NET:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1293               case AF_I=
NET6:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1294                       r=
eturn 1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1295               default:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1296                       r=
eturn -1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1297               }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1298       case AF_INET: {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1299               switch (r=
hs->sa_family) {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1300               case AF_U=
NSPEC:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1301                       r=
eturn -1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1302               case AF_I=
NET:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27 @1303                       r=
eturn memcmp(&saddr4->sin_addr.s_addr,
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1304                        =
      &vaddr4->sin_addr.s_addr,
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1305                        =
      sizeof(struct sockaddr_in));
> >
> > saddr4 and vaddr4 are type sockaddr_in.  But sin_addr.s_addr is an
> > offset into the struct.  This looks like a read overflow.  I would thin=
k
> > it should be sizeof(struct in_addr).
>
> Oh, definitely. It's more than a read overflow, it's an incorrect
> comparison which will lead to creating new and unnecessary channels.
> Two bugs here.
>
> Tom.
>
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1306               case AF_I=
NET6:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1307                       r=
eturn 1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1308               default:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1309                       r=
eturn -1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1310               }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1311       }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1312       case AF_INET6: {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1313               switch (r=
hs->sa_family) {
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1314               case AF_U=
NSPEC:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1315               case AF_I=
NET:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1316                       r=
eturn -1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1317               case AF_I=
NET6:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27 @1318                       r=
eturn memcmp(&saddr6->sin6_addr,
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1319                        =
             &vaddr6->sin6_addr,
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1320                        =
             sizeof(struct sockaddr_in6));
> >
> > Same.
> >
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1321               default:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1322                       r=
eturn -1;
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1323               }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1324       }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1325       default:
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1326               return -1=
; /* don't expect to be here */
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1327       }
> > 010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1328  }
> >

Thanks for catching this Dan.
I will fix this and send an updated patch.

--=20
Regards,
Shyam
