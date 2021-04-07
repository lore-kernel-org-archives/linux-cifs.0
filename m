Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFE8C433ED
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 19:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F8F61245
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 19:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355527AbhDGTBE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355515AbhDGTBC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 15:01:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E7CC06175F
        for <linux-cifs@vger.kernel.org>; Wed,  7 Apr 2021 12:00:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id r8so12669461lfp.10
        for <linux-cifs@vger.kernel.org>; Wed, 07 Apr 2021 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yKftuOzfnDeyydXKohiChUiDYgyXfsV6qKqcpTqYrwo=;
        b=EVZeAPosned9jsYtoM+ta+tIB312TldtSNMygZykBFmEc5WKs44rIxSjL++tXH45gC
         6Ngb+0DCgHZWlFXHGZl3vWpBuFoQ9Y9uXhDCxt7Aj6iYTCO0JIZwtBYGmGz518S/2gZb
         xtsDJHgQnUjtZn8gNwJThGQ4bAqMaedJYcUpaKLrsGxOZNtt5VkRnGOHDeF8zE6BPPbW
         +z6W/qb80i1eUrYi7xl8kqSkjLUfZRE0yHh3BYfHG/vloQADFqlALWNx5YA+EROqF9pP
         F25yFwcjd5w0QXRjGQ4GwC9l25fLH/jIm1zHB5OBJM0gEr6RpYD+oWx1NlmED/Py/HnN
         G4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yKftuOzfnDeyydXKohiChUiDYgyXfsV6qKqcpTqYrwo=;
        b=NQXE+46YVYTygMVapeKqnyLnAmt5N00j0egxO1A72f7iYa2EvDDkELemJlB5pBG3Ry
         5UH65YKqaXwVwbnA46q7zmnpBoJEwrLYRejJ17JASnjRCq6fQNkD7A9QtDFJTCbE/kby
         CNJNWt1Huks/q2yWKTZ80MgcuVmzGzW7on9OYZZsNv+zI7ZKa/oP1eH+KMjcQCy8HkV3
         uxpDtmNXuFDhZ/xzWbfZRplJsKXGenRUkZmB+Hm99CtxaQp/b8wh2TLOIrG02jOZ/EoD
         E1QDnxQYca3b0FQ3QKIxkqC4AeEXgmjFd4rMhb1C01ikD8pCsotTTJdgn/1pfzz57/SL
         45Pw==
X-Gm-Message-State: AOAM532yA9CP1g5hj21DbqkxTONMkOWTNM8lGxwEaG9gRLZuexXNDv18
        YEYeTM1tGM/VJIK26N/pSvS5KHlefMiWeIjCGyKUKX3fetM=
X-Google-Smtp-Source: ABdhPJy7ZTx9NnEnrLHULRQMUgdYx6nZM1XwWzxb6RyynLBy5rMchLl+PW1QsV0r/fzecgWpVVQ4mQxvxmrf/ajtr4M=
X-Received: by 2002:ac2:4148:: with SMTP id c8mr2846751lfi.307.1617822050196;
 Wed, 07 Apr 2021 12:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
 <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com> <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com>
In-Reply-To: <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Apr 2021 14:00:39 -0500
Message-ID: <CAH2r5mtymY0xCWB65=EV5Kh5PiuvuX34Zmd-_Avb-Gc7gWxo-Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated cifs-2.6.git for-next with newer version of this patch

On Wed, Apr 7, 2021 at 12:43 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> The intel bot identified an issue with the earlier version of the fix,
> when not compiled with DFS.
> Here's an updated version with that fix too.
>
> Regards,
> Shyam
>
> On Wed, Apr 7, 2021 at 9:13 AM Steve French <smfrench@gmail.com> wrote:
> >
> > merged into cifs-2.6.git for-next
> >
> > On Tue, Apr 6, 2021 at 11:34 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Looks good!
> > >
> > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >
> > > CC: <stable@vger.kernel.org> # 5.11+
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D0=BF=D0=BD, 5 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 19:07, Shyam =
Prasad N <nspmangalore@gmail.com>:
> > > >
> > > > Hi Paulo,
> > > >
> > > > Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS_U=
PCALL.
> > > > Fixed it, added CC for stable.
> > > > Attached updated patch.
> > > >
> > > > Regards,
> > > > Shyam
> > > >
> > > > On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > > > >
> > > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > >
> > > > > > Please consider the attached patch for performing the DNS query=
 again
> > > > > > on reconnect.
> > > > > > This is important when connecting to Azure file shares. The UNC
> > > > > > generally contains the server name as a FQDN, and the IP addres=
s which
> > > > > > the name resolves to can change over time.
> > > > > >
> > > > > > After our last conversation about this, I discovered that for t=
he
> > > > > > non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> > > > > > mount.cifs already resolves the name and passes the "addr=3D" a=
rg during
> > > > > > mount.
> > > > >
> > > > > Yeah, this should happen for both cases.  Good catch!
> > > > >
> > > > > > I noticed that you had a patch for this long back. But I don't =
see
> > > > > > that call happening in the latest code. Any idea why that was d=
one?
> > > > >
> > > > > I don't know.  Maybe some other patch broke it.
> > > > >
> > > > > We should probably mark it for stable as well.
> > > > >
> > > > > > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:=
00 2001
> > > > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > > > > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > > > > > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname =
again.
> > > > > >
> > > > > > On cifs_reconnect, make sure that DNS resolution happens again.
> > > > > > It could be the cause of connection to go dead in the first pla=
ce.
> > > > > >
> > > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > > > ---
> > > > > >  fs/cifs/connect.c | 15 +++++++++++++++
> > > > > >  1 file changed, 15 insertions(+)
> > > > >
> > > > > This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
> > > > >
> > > > > Please declare reconn_set_ipaddr_from_hostname() outside the "#if=
def
> > > > > CONFIG_CIFS_DFS_UPCALL" in connect.c.
> > > > >
> > > > > Otherwise,
> > > > >
> > > > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > > >
> > > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
