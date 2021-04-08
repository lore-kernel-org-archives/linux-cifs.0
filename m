Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A5FC433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 02:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB98E6113A
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 02:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhDHC0G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 22:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhDHC0G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 22:26:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9746CC061760
        for <linux-cifs@vger.kernel.org>; Wed,  7 Apr 2021 19:25:55 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id n8so1376147lfh.1
        for <linux-cifs@vger.kernel.org>; Wed, 07 Apr 2021 19:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Mdhhbr66V68Suz8E00mm2NuvBQtef07UF0l2rd8/ok=;
        b=YVp+R6eqF6c5EWdoO6KNIrKUKZAFMANU1fGpjA6HUQTqXE7+ufwN63In66OjivWBzk
         735wDgCl5vRzb737J8Bh92Nn6FSKQxm5QkTSdGweIsriljHfDVQkbaS+GQ7utM8SA4kZ
         ylY7r18MB5xHLQ/pxD4JMYaNaoQSqbIoKshjWhodL2+WhxmHGyGlR2WNzzCvuDJ/niZC
         L6FwbJ2fS3AtAUbPBYdmcxNv2vSyRTmUY7eIN9v9DvuhpzX3b8Vt6V1ranXoJQ3/I7++
         1FUe/C3/BX0vk3gluGRvRJX5TFLTG6Pyd/IyhVVhEKWaiDi8hmBCyOg6ciGzeSdHGNH/
         y+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Mdhhbr66V68Suz8E00mm2NuvBQtef07UF0l2rd8/ok=;
        b=I7MHKqsH0O/Ab+loVVJVckSif3pprHVXy0w8i+6rxKkzdEXIx+EIQLHAcypcB47c6q
         AWzUIzjVRhHa34ZI1gJ1OLtmewUiFLIAed96bqaK0C0LJIQTQdA4nB7hTXcPmQkB6lPL
         OIh7iKpGNdcSekai/+LEUlBjcOlpLPpMLUxOr+tfPQ14EkzhV1oqwSF99AYo4q+Ddd3o
         Es2EleLkOJTtCRgqsnDQZWYVYqKAVjfi9N4HqrFcobAqTpe9/Y7sA+X5SHaK5rTYV65u
         vQq+JVVub+gOkUKbAbWEsGhDRTAI02mrpyGxLCDisB9QcACgi7vlZInMX8mL6h0ITk/t
         LfIw==
X-Gm-Message-State: AOAM532pQXHzplIVk5Jdhv+gW4yM+vcNBKeqvETzt4vJcybiT5ujfXvM
        DWL4aPaZjFN73KD5PkIiw5Oj2EctUJN+T8fr+K8Gr8vpypjfJQ==
X-Google-Smtp-Source: ABdhPJxXfAqh9ABlGSVEo1J9kbxV9uyNcoTUyArGCcDniWm+sBYtd0J6Cvdbh50ucmf6ZPBKQE4H/z3j9VGD2TfB0Mk=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr4514024lfd.175.1617848753889;
 Wed, 07 Apr 2021 19:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
 <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
 <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com> <CAH2r5mtymY0xCWB65=EV5Kh5PiuvuX34Zmd-_Avb-Gc7gWxo-Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtymY0xCWB65=EV5Kh5PiuvuX34Zmd-_Avb-Gc7gWxo-Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Apr 2021 21:25:43 -0500
Message-ID: <CAH2r5mvkrtDnjvyLi_hVo3C-3zPdoaZZGCPbxEGG7fD5y0ntnw@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It was missing a small piece (otherwise could have build failure if
dns_query not available)

$ git diff -a
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index fe03cbdae959..bf52e9326ebe 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -18,6 +18,7 @@ config CIFS
        select CRYPTO_AES
        select CRYPTO_LIB_DES
        select KEYS
+       select DNS_RESOLVER
        help
          This is the client VFS module for the SMB3 family of NAS protocol=
s,
          (including support for the most recent, most secure dialect SMB3.=
1.1)
@@ -112,7 +113,6 @@ config CIFS_WEAK_PW_HASH
 config CIFS_UPCALL
        bool "Kerberos/SPNEGO advanced session setup"
        depends on CIFS
-       select DNS_RESOLVER
        help
          Enables an upcall mechanism for CIFS which accesses userspace hel=
per
          utilities to provide SPNEGO packaged (RFC 4178) Kerberos tickets
@@ -179,7 +179,6 @@ config CIFS_DEBUG_DUMP_KEYS
 config CIFS_DFS_UPCALL
        bool "DFS feature support"
        depends on CIFS
-       select DNS_RESOLVER
        help
          Distributed File System (DFS) support is used to access shares
          transparently in an enterprise name space, even if the share

On Wed, Apr 7, 2021 at 2:00 PM Steve French <smfrench@gmail.com> wrote:
>
> updated cifs-2.6.git for-next with newer version of this patch
>
> On Wed, Apr 7, 2021 at 12:43 PM Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
> >
> > The intel bot identified an issue with the earlier version of the fix,
> > when not compiled with DFS.
> > Here's an updated version with that fix too.
> >
> > Regards,
> > Shyam
> >
> > On Wed, Apr 7, 2021 at 9:13 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > merged into cifs-2.6.git for-next
> > >
> > > On Tue, Apr 6, 2021 at 11:34 AM Pavel Shilovsky <piastryyy@gmail.com>=
 wrote:
> > > >
> > > > Looks good!
> > > >
> > > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > >
> > > > CC: <stable@vger.kernel.org> # 5.11+
> > > >
> > > > --
> > > > Best regards,
> > > > Pavel Shilovsky
> > > >
> > > > =D0=BF=D0=BD, 5 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 19:07, Shya=
m Prasad N <nspmangalore@gmail.com>:
> > > > >
> > > > > Hi Paulo,
> > > > >
> > > > > Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS=
_UPCALL.
> > > > > Fixed it, added CC for stable.
> > > > > Attached updated patch.
> > > > >
> > > > > Regards,
> > > > > Shyam
> > > > >
> > > > > On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > > > > >
> > > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > > >
> > > > > > > Please consider the attached patch for performing the DNS que=
ry again
> > > > > > > on reconnect.
> > > > > > > This is important when connecting to Azure file shares. The U=
NC
> > > > > > > generally contains the server name as a FQDN, and the IP addr=
ess which
> > > > > > > the name resolves to can change over time.
> > > > > > >
> > > > > > > After our last conversation about this, I discovered that for=
 the
> > > > > > > non-DFS scenario, we never do DNS resolutions in cifs.ko, sin=
ce
> > > > > > > mount.cifs already resolves the name and passes the "addr=3D"=
 arg during
> > > > > > > mount.
> > > > > >
> > > > > > Yeah, this should happen for both cases.  Good catch!
> > > > > >
> > > > > > > I noticed that you had a patch for this long back. But I don'=
t see
> > > > > > > that call happening in the latest code. Any idea why that was=
 done?
> > > > > >
> > > > > > I don't know.  Maybe some other patch broke it.
> > > > > >
> > > > > > We should probably mark it for stable as well.
> > > > > >
> > > > > > > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:0=
0:00 2001
> > > > > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > > > > > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > > > > > > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostnam=
e again.
> > > > > > >
> > > > > > > On cifs_reconnect, make sure that DNS resolution happens agai=
n.
> > > > > > > It could be the cause of connection to go dead in the first p=
lace.
> > > > > > >
> > > > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > > > > ---
> > > > > > >  fs/cifs/connect.c | 15 +++++++++++++++
> > > > > > >  1 file changed, 15 insertions(+)
> > > > > >
> > > > > > This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
> > > > > >
> > > > > > Please declare reconn_set_ipaddr_from_hostname() outside the "#=
ifdef
> > > > > > CONFIG_CIFS_DFS_UPCALL" in connect.c.
> > > > > >
> > > > > > Otherwise,
> > > > > >
> > > > > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Regards,
> > > > > Shyam
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
