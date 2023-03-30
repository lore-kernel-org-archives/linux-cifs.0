Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0CCC6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 22:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjC3WZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjC3WZ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 18:25:57 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09792CA30
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:25:56 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id q16so26459685lfe.10
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680215154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmwxld8Bgwb4NFlWgEZQKYg3X7WPadfVq6TfLW9FoZU=;
        b=qs005YK9G9gKXm2aRdRCY+qyEzj0bqEDQUeREVwhnXYnuK+t5EJQHDmscus9CvNsmR
         0/lY/TJibpxAdJhS1sWhVI07wkDM5yA1n8fdXjPRVbKqxArjyeOBRwUvigZr+iiKv8uY
         Eu8cwRNk1uFqKbELMTP9pZT4eM02ONO7bxxXc1Nnuon6QLvZSCU9mSiOYsU9YQYfJrhp
         GJx+TtGP/xJF5PGoLNv0hW5BJuV/QZ1bTaNVbWEg2zJOzpLF7fJ3zkV7RczLxMhlY6UA
         iJFlBwUQscNE5UkjkWThZd73K9wj2o5l5EkjfZRdIeD1oVcjsFruPtCl0DQ/jijqgen3
         zw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680215154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmwxld8Bgwb4NFlWgEZQKYg3X7WPadfVq6TfLW9FoZU=;
        b=efxpG+HHqjuZdFQHu7gSKPXBfr5xPHPrb+ZyZc3jRp0CQqvmaJh9xD7GBO0Tev+Wy1
         7oM6g3a38JDoU4KrSEWcoHPe1Y0a2Xu03mL2DfNeKq9g6BYKwAuBaOmK05u+zYe7Zyrm
         bu4+FS6AaDjchlnfpjqXCBfQxYT6UjSha+01DTWaEmtHChlWJ7gTUvCbapxhiC2wnka/
         eZc11rXe0tZnI9cxzAbIJRpd3sbC3nnxlsQ6H8C5F2GEwI/fR22/FyCOxhE4wyZDIoQY
         CfYMmxw2Oxbcf80fkoWGVzH/mx/lBNPjhrZnIWiYQt3q6X4aY5jFvnp4sFodPCRYiaYk
         mhlw==
X-Gm-Message-State: AAQBX9e9SyzhIs78+3udhG2wyP2Ca5bgZ42Z0dHs3MjLL7TZSYpKxDPn
        nA7FvTabUb7dKhhdsZEuQ/zEJY4mUWlnIN3DcwaWrhgI
X-Google-Smtp-Source: AKy350YP11q5dsJOS0ujlPD7rt1xdYVUd6fHOTzLoTDaIZtFWoIKm/JMHi60Q0+4KmLhPvzDK9fJHOFxlbg/YXPZcL8=
X-Received: by 2002:ac2:5310:0:b0:4eb:1606:48d5 with SMTP id
 c16-20020ac25310000000b004eb160648d5mr3662779lfh.7.1680215154258; Thu, 30 Mar
 2023 15:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680177540.git.vl@samba.org> <20230330222001.5vq5b63lnwcmczr7@suse.de>
In-Reply-To: <20230330222001.5vq5b63lnwcmczr7@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Mar 2023 17:25:44 -0500
Message-ID: <CAH2r5mvQ=dnC20VzTMFNTrk6WyqBLrwrCwiYtU1LWe-nHrVEMg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Simplify SMB2_open_init
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Volker Lendecke <vl@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

My main worry is that these are done in the way that makes it easier
for Ronnie/Enzo/Paulo etc. to backport - since we have plenty of
bugs/features to work on that they will be wanting to backport over
the next few releases - and don't want to make their life too much
harder - but these changes look reasonably small

On Thu, Mar 30, 2023 at 5:21=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi Volker,
>
> On 03/30, Volker Lendecke wrote:
> >Stitching together can be done in one place, there's no need to do
> >this in every add_*_context function.
> >
> >This supersedes the patchet in
> >
> >https://www.spinics.net/lists/linux-cifs/msg28087.html.
> >
> >Volker Lendecke (3):
> >  cifs: Simplify SMB2_open_init()
> >  cifs: Simplify SMB2_open_init()
> >  cifs: Simplify SMB2_open_init()
> >
> > fs/cifs/smb2pdu.c | 106 +++++++++++-----------------------------------
> > 1 file changed, 25 insertions(+), 81 deletions(-)
>
> Would you mind using more descriptive titles please?  To make
> referencing/backporting easier.
>
> Also IMHO patches 1/3 and 3/3 could be merged into a single patch.
>
> Aside from that, Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
> Cheers,
>
> Enzo



--=20
Thanks,

Steve
