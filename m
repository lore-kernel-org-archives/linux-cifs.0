Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E49EB64D8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 19:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjFVTNu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjFVTNt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 15:13:49 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544D21A3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 12:13:48 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b44d77e56bso12088791fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687461226; x=1690053226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQQxUkFPCIN2tJE5cnuNf7OQBjL0qT3mQ9umTlOrXUo=;
        b=InDOuVuoVRfbne4xGufVduKEIPk2BQbsgTUYCXz13W4aVy1mEYeR/hIRigpbJUSSFv
         EaOKkSTMpy6zrkLM6V9Bw6yxHEoRhH+vHLhL0q877LyoIwYEFX+nO6RA2TQoKycElH58
         iDiRhEXIB1GGeN0PTHsyrbJt2Py1Yt9HAgFE3YojQIIqEH8QImWpLNsit3hYTPUz20d0
         rxF+vsOTfeX49IaakuJiqWKV4b3bWzOrYtaUQU9mefVCMt8WADSnTpXsAm+kFPLI48en
         p94HPRY9iTUeJYN3b121QZRVCnrzjPy/zhmkBn1abFOPsEwL0GiqhbdNIK+CjRsXsP0w
         HTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687461226; x=1690053226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zQQxUkFPCIN2tJE5cnuNf7OQBjL0qT3mQ9umTlOrXUo=;
        b=KJATiPnRyCOGN+OMqo7V6jdkgcSHlqQn9C1ZsgxWxSVI6gInc3Jtg0njQGGbQGxFQP
         Bby+9gGbgWYVvG4iMhiVvjV0Kj5+eaWNUS6dSStzuruvzQWiTC9S0QBj+Ws3EbjtKzGc
         yfuK6vlM1grfsS4YmiwH0ZwX8m6OF2iYvzVQR6yWdDYeXH8vpoAKNwBgaLtyV3J6VUMZ
         BgkURIpXr+c9OSORZfqrPU/gucfMlcm9BL6bvWPw8MlqLrT4H7RhcgrkqyXM5PPbu53H
         T52QagstF2oS+J1pGEkQnMIi1de1pIY+E4MHae20CiZB1Uqgp6S3TV2ooCmUyHkOisgg
         a1wA==
X-Gm-Message-State: AC+VfDxQ3sZi57s0jxKRagj68tkkpFliXB49EhiWWdv08nDdbWh2w+sR
        9WH5rCdLwdaau/upplByVXYZRSZu4gYyAM3LVWY=
X-Google-Smtp-Source: ACHHUZ7kR6PuXIOJWk9sfqYw0zQj2FJYaPAyhQC0xj8zPgf3JEjM/bOxPHdUq0OzwkSqEm9OcoXSwd7Ui1aqPtV/qt8=
X-Received: by 2002:a2e:b806:0:b0:2b4:79d4:b8e3 with SMTP id
 u6-20020a2eb806000000b002b479d4b8e3mr4500748ljo.20.1687461226268; Thu, 22 Jun
 2023 12:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230622181604.4788-1-sprasad@microsoft.com> <20230622181604.4788-2-sprasad@microsoft.com>
 <34cffb207bfa6afe2b92b15355471e48.pc@manguebit.com>
In-Reply-To: <34cffb207bfa6afe2b92b15355471e48.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jun 2023 14:13:34 -0500
Message-ID: <CAH2r5mtZd3BHhZkFYGua+K+nFfdSjJQxpS9UWYVLeGG5oz3OVA@mail.gmail.com>
Subject: Re: [PATCH 2/3] cifs: prevent use-after-free by freeing the cfile later
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, ematsumiya@suse.de,
        bharathsm.hsk@gmail.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jun 22, 2023 at 1:46=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > In smb2_compound_op we have a possible use-after-free
> > which can cause hard to debug problems later on.
> >
> > This was revealed during stress testing with KASAN enabled
> > kernel. Fixing it by moving the cfile free call to
> > a few lines below, after the usage.
> >
> > Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> > CC: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/smb2inode.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
