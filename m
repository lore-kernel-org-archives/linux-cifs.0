Return-Path: <SRS0=whkR=QY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAADC43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Feb 2019 00:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD0D21B69
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Feb 2019 00:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pPxcSije"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfBQAqS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Feb 2019 19:46:18 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:34672 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfBQAqS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Feb 2019 19:46:18 -0500
Received: by mail-pg1-f179.google.com with SMTP id i130so6660147pgd.1
        for <linux-cifs@vger.kernel.org>; Sat, 16 Feb 2019 16:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XrbIR8k9Z/UE3nxU1Y4OcyniKZ309sH4q+yqxp/Y7LU=;
        b=pPxcSijeqmv1jWUb/lCHX1vpR4muzHxlDkXIxuenlFHL2EMCSsPqSALxa9Gvr/a02f
         VbrwmL8y3PaBEevQDOr96pim+0srC+PAM9sKrENy4UNjh5fyC3YQ4nXbM4Z5png5sR6w
         gjakdNPe1/5InwYuZhWCXyS8Q0kdqL6DU42ygGMdkUj/56DOGMJtajT87dDCoOL3aW2p
         Ua28yB/qCFtT5FnDtux1ezH4aHcZSplQ2c9SVZkxYRSYImm0rrEDvz+/frVCQHcIgxP/
         IZBchA3udhOA3HCL2uVqnxx7clWrhkm07afGDDxRliZ868Oq+GaJU0hpLuXfQbSE/Oq+
         7DYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XrbIR8k9Z/UE3nxU1Y4OcyniKZ309sH4q+yqxp/Y7LU=;
        b=P7D7+2Q1EiTMvso4SdXPnDTdV9PfdqZvzJ8e++AU8q7wJqgF33aafanXnvXV9W+U3Q
         lC5x55Pj8Y4En3+bMntvGadSCG6R8yKJaglGdmMVq5EUMqDXGjLCpUWFRcK1BRjoJCjf
         eR7G2X9tKti9apMay6zFUdmA1JMTEYxfejA5BBidhST8ACZJXlmS/bA/WAcsaw6nxaTO
         8CVcUayz22pJ/7dEimPKA2GLTYxyxSKt+5OADiAfxPSdGPtHvLGKt8D4x1h71mD3wzX6
         DwgtSh0Z/1T6vqRDVgnjTXCKorP/qqqJp3zrVRIrqiMctPCf4+SOMLn1aRG9JGKh7zzq
         5aNA==
X-Gm-Message-State: AHQUAuZq2r4rvLjHSnSWHFO8qLTllA0EQEzBy2xmBStNIi7AgGoc3G5P
        M++L/hWqRoa27xHWK/l2IWF6rCHL2QZ+I/d0ZMdIjnUa
X-Google-Smtp-Source: AHgI3IZsyaZ8YTV2qW9RwpgPI7b8PcRk7DxLpuf7sViX2pqYCBNxExDL1aq0SHVHJX2MCeUjFyOY5qq1NF9WAl3hZds=
X-Received: by 2002:a65:6684:: with SMTP id b4mr12260902pgw.55.1550364376795;
 Sat, 16 Feb 2019 16:46:16 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
In-Reply-To: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Feb 2019 18:46:05 -0600
Message-ID: <CAH2r5mvi5k3=TgX_aGrjVyMjcLr9QOH+EPquXjwYLEHwZFP3YQ@mail.gmail.com>
Subject: Re: xfstests and current cifs for-next patch set
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Narrowed the xfstest 310 possible regression in current for-next down
to three patches, rerunning with this one of the three added (see
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/85)

Author: Pavel Shilovsky <pshilov@microsoft.com>
Date:   Wed Jan 16 11:12:41 2019 -0800

    CIFS: Respect reconnect in MTU credits calculations

On Sat, Feb 16, 2019 at 1:40 PM Steve French <smfrench@gmail.com> wrote:
>
> With 5.0-rc5 and current for-next (29 paches) two tests 310 (read and
> readdir simultaneously) and 422 (delayed allocation stat, number of
> blocks) fail I see this in the azure test bucket in the buildbot).
> see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/80
>
> These don't fail when I select only the first 8 cifs fixes in for-next
> ontop of 5.0-rc5.  See
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/82
>  so am trying to narrow it down.    This run (in progress)
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/83
> has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mainline
> as with the runs above) so we can bisect which commit causes the
> problem with tests 310 and 422.
>
> This seems unrelated to the problem I see in slightly more current
> mainline (that we can see with no cifs changes) in xfstest 422 that
> was introduced with 5.0-rc6.
>
> Let me know if others (or other scenario problems) see the tests
> 310/422 failure.
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
