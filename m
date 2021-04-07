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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5816FC433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 03:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ACE26139E
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 03:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344472AbhDGDnn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhDGDnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 23:43:43 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22397C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  6 Apr 2021 20:43:34 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n138so26194422lfa.3
        for <linux-cifs@vger.kernel.org>; Tue, 06 Apr 2021 20:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nn1k1rY/+aywFe1Iz9i2zxKnVrNP1we7BtCEYHeHRRk=;
        b=uwnUWkmAuETe+NrKs/nKi3Ql5USdVdqTNuljU4U3/h2LLDsnDejBmLFcbKElfsZ2Cf
         /YgIvIOucKrtnOe0fW0cyYxiv+KuThH/sTiuE+ASpCLSmJfyHsXoqFHvnGG9wRmIQxo/
         ytRxcQC5QBaC+oaW3uBivazEIJ9CdRKpOM66TfBd3cK6gRwgJBazNMSHs3E0cFjADDsX
         CRE/tIGpjmOoqw9v7oSDa/BJvbdGNrbT9JD2E7jTEbBc3YV31N6V+BhGFIGiaZ0ZKjh2
         d28yZJaiyBI8OOUrHui4SA8srOEsl8ZdAjBAFklx68j5N9VvGcEUrogGjddhiZHvdUiC
         1vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nn1k1rY/+aywFe1Iz9i2zxKnVrNP1we7BtCEYHeHRRk=;
        b=Mg/X94pjoIIXE8F+w1LkV2ECkAcVy6L5AsJL8WauTI8cArO+XIKILvznTBZ8bZB7K6
         9/obPdJWiji5wOF4w6yEgfSbeMGnvZ9q+0K6Hr1DUzFWpe0z3ZECsuKoo48OvBwREJri
         rhF/113I27bCNdjZC/IcEmoCh1aHelaqc1M3jmYEvFkF+lCFuSfybD64vw9UYbe40q9q
         jw99wv10NDdPqgCPZSaN9nimUBz9vycO+BL++pprJtcNI30WXyMTkf2rF2KoMI4P+mx6
         ronmyRmEz0/UW1/EpQgxcSlIyF1B4SE+QNbpCOc75MrtfXXJN+xP4xwrWkSCRzWgXhhO
         JAAw==
X-Gm-Message-State: AOAM531N9kQQN7v8sXsCCJptc6Dvm3g4eeAf8wfv1D+sHjjFg6oRS+56
        w/tC9b9JEn66eeyaX+K/o+HIYktLzYUfQBn2DzDibq6cueE=
X-Google-Smtp-Source: ABdhPJzzOvI3GlhDxKojHgt9+Dq9bhm5wP0u4Xif9hAltLT05P91eE10FRW6MdzdXZjYOIPAxvi1U4XoYPG8/UgsGd4=
X-Received: by 2002:ac2:5f07:: with SMTP id 7mr1043846lfq.313.1617767012459;
 Tue, 06 Apr 2021 20:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
In-Reply-To: <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Apr 2021 22:43:21 -0500
Message-ID: <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Apr 6, 2021 at 11:34 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Looks good!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> CC: <stable@vger.kernel.org> # 5.11+
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 5 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 19:07, Shyam Pras=
ad N <nspmangalore@gmail.com>:
> >
> > Hi Paulo,
> >
> > Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS_UPCAL=
L.
> > Fixed it, added CC for stable.
> > Attached updated patch.
> >
> > Regards,
> > Shyam
> >
> > On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > >
> > > > Please consider the attached patch for performing the DNS query aga=
in
> > > > on reconnect.
> > > > This is important when connecting to Azure file shares. The UNC
> > > > generally contains the server name as a FQDN, and the IP address wh=
ich
> > > > the name resolves to can change over time.
> > > >
> > > > After our last conversation about this, I discovered that for the
> > > > non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> > > > mount.cifs already resolves the name and passes the "addr=3D" arg d=
uring
> > > > mount.
> > >
> > > Yeah, this should happen for both cases.  Good catch!
> > >
> > > > I noticed that you had a patch for this long back. But I don't see
> > > > that call happening in the latest code. Any idea why that was done?
> > >
> > > I don't know.  Maybe some other patch broke it.
> > >
> > > We should probably mark it for stable as well.
> > >
> > > > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:00 2=
001
> > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > > > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname agai=
n.
> > > >
> > > > On cifs_reconnect, make sure that DNS resolution happens again.
> > > > It could be the cause of connection to go dead in the first place.
> > > >
> > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > ---
> > > >  fs/cifs/connect.c | 15 +++++++++++++++
> > > >  1 file changed, 15 insertions(+)
> > >
> > > This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
> > >
> > > Please declare reconn_set_ipaddr_from_hostname() outside the "#ifdef
> > > CONFIG_CIFS_DFS_UPCALL" in connect.c.
> > >
> > > Otherwise,
> > >
> > > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> >
> >
> >
> > --
> > Regards,
> > Shyam



--=20
Thanks,

Steve
