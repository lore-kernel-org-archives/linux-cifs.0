Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB11AC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 08:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9530B21852
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 08:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgEO9Va9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfCNIDc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:03:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40199 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfCNIDc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 04:03:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id u9so3439160pgo.7;
        Thu, 14 Mar 2019 01:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D08xpENjvwwapHL2xkx7NbHxXgA5o6HYh4aCvs0ptjc=;
        b=VgEO9Va9g75+SKCnkC2oDfheOYuy86ZwpAFofVH90SiN8FYu9u/m587pRA4R2mT4cX
         9nA3hw6/3pjAOcRN1jzIx1tmPCxnfV5z4Xvd8lD3NSyIpSlEEqPt8xu8TFm7cLvls245
         akOnLrPbzvYNmJj5peO0mCG73YgJBdeFSUhd2ld60sBwdxoCc/gflqmfNcTsourFs3+Q
         uiYlJ6jfsUnIVLBdTmy+66AnDip0ASsaUd3pp4L50mFlE380YzzsbTG/sRcKoVLlb553
         UBx+H9jtP0+WMOYFPvNw7AleaUW3ZT0gQ5PTSGGYm5IgvoG4D/PoqDUs5NjfpHAqDOuv
         ccDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D08xpENjvwwapHL2xkx7NbHxXgA5o6HYh4aCvs0ptjc=;
        b=Xi5L5Z670pZz1f1mMbhUDU0/wz0TYh2xVNIbxp3tsEUhJE4OHMFwKuXCKTVn+eccgN
         tAtlfanN+UnBM42lhBOJ7D4IoUdAb6Q/wmcYHEMF3XSHPLLZ0sTOmNRWLBi+vjyQIyIJ
         IJH0ainJegTZ9OcntoMZtyyfwHS1oc13Rb4wrPFqdbgUKRvbR37y/qIrCm0iVlNJ7B2b
         WESG/+cuhSsEcCcCgVQCCiS0hMSlLNqFZWPVftudUOavGPlcspzM13ODfaGF1IFPfY2H
         uoOl/ZiYOL1ogv4B6TxfCY1DKvf0CTu1Q+TCFpaYS3WFvDJomOLsvkuTbQWgllx6VZTy
         6yFw==
X-Gm-Message-State: APjAAAWHpQfvp+7xfzneL9YT/jolLv+8LG2jGTBvUPCB9KJ+CkhO9Kfa
        GzlxPIQOdMhOqVa88dmqG3fIufPQ1bOqGKV8OCM=
X-Google-Smtp-Source: APXvYqx+3eNuyj38X0tvmcOBieGtbfAm515zdYmDVqlTPkEPhLoASXiX8eLC1nOBVTLGTtSWO3IZTc4ny11cpPtxVok=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr49519524pli.24.1552550611032;
 Thu, 14 Mar 2019 01:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
 <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com>
 <20190314071245.GA2001@jagdpanzerIV> <CAH2r5ms3sdFx864M4se0V1eCAj_x8_3xyyRxoxqS52_UQNNjaA@mail.gmail.com>
 <20190314073954.GA5272@jagdpanzerIV>
In-Reply-To: <20190314073954.GA5272@jagdpanzerIV>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 03:03:18 -0500
Message-ID: <CAH2r5msU25CMDfTON2fSTpg5tmt7O_2sguFDL96b=vys5u+ViQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am fine with taking a patch to get rid of __constant_cpu_to_XXX
(and converting to the same cpu_to_XXX with the "__constant")  in
fs/cifs  (assuming that that is still recommended).

On Thu, Mar 14, 2019 at 2:39 AM Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
>
> On (03/14/19 02:19), Steve French wrote:
> > All of those uses of __constant_cpu_to_le32 apparently (at least
> > according to checkpatch) should be changed (someday) to cpu_to_le32
> > but I didn't research why the change from __constant_cpu_to_le32
> > --->   cpu_to_le32
>
> Probably historic reasons.
>
> Looking at linux 2.4.21
>
> /*
>  * Allow constant folding
>  */
> #if defined(__GNUC__) && (__GNUC__ >= 2) && defined(__OPTIMIZE__)
> #  define __swahw32(x) \
> (__builtin_constant_p((__u32)(x)) ? \
>  ___swahw32((x)) : \
>  __fswahw32((x)))
>
>
> My assumption would be that __GNUC__ < 2 did no support
> __builtin_constant_p?
>
>
> > If it has benefit - and checkpatch is right (it warned about
> > __constant_cpu_to_le32 being no longer preferred) ... perhaps would be
> > worth a followup patch to clean the rest of them up?   If you have any
> > context on why kernel code has moved away from using the older format
> > of __constant_cpu_to_.... would be useful to know if any benefit to
> > the change
>
> Right, that's what I'm going to do - send out patches and update the rest
> of __constant_cpu_to_XX users; so, eventually, __constant_cpu_to_XX
> can be removed.
>
>         -ss



-- 
Thanks,

Steve
