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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA43CC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 02:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B1A60C3F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 02:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhHRCrA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHRCq7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Aug 2021 22:46:59 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851DCC061764;
        Tue, 17 Aug 2021 19:46:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id k5so1377151lfu.4;
        Tue, 17 Aug 2021 19:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c2nGkp2pO28MJRzTFh6Ka89xAPD7DAQakuOyZH1yyPs=;
        b=qh1y8agNpNkt0u3hDMltHMeuOa1zDwc+PSEgyXPU+Kl4+YEYxysyyaRbYLwsSVzvD6
         4UJXUV/6j+BSFgX1Mi+F2jKYzlcJz6UzsTKMXydi4VddeHagJ3+IogQti/X8VyCmlx5z
         2gPI0Ov204md7HGwzEvGeO+EE9Po7QWfrkmwp6EjC7U9KMBN0kcDeaVGyC+9tKUFAdAq
         fcl06nfzceZiyCwT1GM1GtS7mnAoGi/Hxyh8hTI0jbzZYeMZcenFDASN5bj332Zn/mPR
         RGh3GzBQ6ZVmeD8HPMJaGW0OkPcGfLzsXkydSb2ffhWQw9dQ8y8ldRrtyQJUTfIBnr4k
         2mlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2nGkp2pO28MJRzTFh6Ka89xAPD7DAQakuOyZH1yyPs=;
        b=XJgv1WNT9H4Lz97dxgR3CX6YBw83Buppgd3fhIKRCvTTop1AvkSzO77WZsu1umUmZ8
         7HpwrI5C1s6nPIQEzc62p2Z/U8HUk/vABDCHa0+PCJOcReXW7q3Vse+y323KigfctV+H
         dkhVud0k0ioqclecLT9nXGsiNZEe9nKBX+tdzV5LZu+44/h4FeFVa0/bn71yv3onMQ5U
         HTZZd3LdubtRhn2zjnRnfWZdYgE8odEe++ncm/OL8diatfDV/CB/wrpv8JubyTVifa68
         JC3FxF2MwWVDRgZh5qApe361Pr3Nj+q2Agwgtu6weuhAxhca+RhulFgHN2AJBdKAnNa+
         cljw==
X-Gm-Message-State: AOAM530YfjnYfvHDGnTStr+lSgovxCsIfosWaR7Yt8xWa7YEet88Gk7k
        pDl/KgU+PNvkRR5qzFw8orF5/Zytf64bq4OF2Bt4nrkZsYs=
X-Google-Smtp-Source: ABdhPJyqX4PNnFM3uy8n4gtEWd/ECyFT14HG7SXlJ/4l9ydlIL43HQMtidgxK+h3pV9p1isZ0JV7+pgS6fpI5l0te7o=
X-Received: by 2002:ac2:4350:: with SMTP id o16mr4888984lfl.184.1629254783804;
 Tue, 17 Aug 2021 19:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145510.639-1-dinghui@sangfor.com.cn> <87fsv7h9wm.fsf@cjr.nz>
In-Reply-To: <87fsv7h9wm.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Aug 2021 21:46:12 -0500
Message-ID: <CAH2r5mvT115ikGHAtpoLmHSn9yJ16iJDexgdUCv32ZAL4+HNKA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix wrong release in sess_alloc_buffer() failed path
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ding Hui <dinghui@sangfor.com.cn>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Tue, Aug 17, 2021 at 7:33 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ding Hui <dinghui@sangfor.com.cn> writes:
>
> > smb_buf is allocated by small_smb_init_no_tc(), and buf type is
> > CIFS_SMALL_BUFFER, so we should use cifs_small_buf_release() to
> > release it in failed path.
> >
> > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > ---
> >  fs/cifs/sess.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
