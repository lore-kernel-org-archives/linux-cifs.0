Return-Path: <SRS0=e1Ds=BJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8068C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 21:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD162084D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 21:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1UOXzbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgG3Vek (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jul 2020 17:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730551AbgG3Vej (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jul 2020 17:34:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE15C061574
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2020 14:34:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l1so29743288ioh.5
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2020 14:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EunlAgoqBt42GDjowuQaaJ7+uHu6iz5Z4lH8zxUwYY8=;
        b=h1UOXzbJn+t12r0lLEuGIbIURVoGvuVyzwQPjPko9rQqAr48DPYgvvSRwaTFW2Hjjg
         XIchBCmFH/IaH1jyRe1EhW927yYGIgvSf9meqJueKzj1vbrC4bKiHWWx903cP2V2FDim
         4kQqG8i1KWeCmDGdX7BPdjxO4sryiESf/GFAnDtEZvVdGo/CGshLy/ds/gs+aObdPY9r
         mZUNcswMOqNP2MtAJ7OqWV2QUYS8ueG40SfsHDRqIrx1ppGswt7Jq6mdhUMQZGCHwTC4
         KrQ59gyjv9iFPlBwY5wowTXl5Iya1w8v237VCDCLV7s1Pa5j7R6rFEw1JmUY7KlgVqLj
         Sg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EunlAgoqBt42GDjowuQaaJ7+uHu6iz5Z4lH8zxUwYY8=;
        b=UaGLTH6lLFaHL0T7jQ5cp4H4wh5icfgm++A9W8467GWlxu0mTjLwRfMSzvnYXa2FLq
         jYKqxYQONqrVeRMVUAdY6ncs9jZZpkxJb67048cFVsIxn/on800G7X4mEDKoqiyXUXfG
         51w5cLMfEctJEZnwMggZyczVxmWGzMXc3t3PRhQixKBXR1244xNNJV2ZavLu6uBxwItu
         tGHAquwvKNzV/YE5U0XVNmflvUdvH41TXlyeoKVhNwi4wi1S6XBgaMgUYSRjkIXb5UOi
         R6GTxoRlP3vFq7W4m6lQEtDPaH1/VNy7PmOUPpCt4NHxtDgSAcr8WdbKwyEdfUfY4+l3
         3DmA==
X-Gm-Message-State: AOAM532XhmXfyU54PPUq649nJQN8WdThNfRkU6wA0rg042h1fKlgKq9/
        dzytwAEwaWu/yB0uyyVQxAuxT9zjU6GbbvJJnmg=
X-Google-Smtp-Source: ABdhPJxu1njNRk70hxSr8m6W1kzlISPC5GExvpmx6wBgpp4o55hnvXHNrYH0eOwPdIbwiJDqYGr1mXmsemxtEEmtczg=
X-Received: by 2002:a02:9f17:: with SMTP id z23mr1425980jal.63.1596144879140;
 Thu, 30 Jul 2020 14:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200721123644.14728-1-pc@cjr.nz> <87zh7h9p0r.fsf@suse.com>
In-Reply-To: <87zh7h9p0r.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Jul 2020 16:34:28 -0500
Message-ID: <CAH2r5mueQwtn6_-4VKSd60pZiGfqTstmxJgg8pTdECxZTAaoGw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] DFS fixes
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

First five of these seven now tentatively merged into cifs-2.6.git
for-next pending more testing

(waiting on a little more review feedback on last two ... or time to
look in more detail)

On Thu, Jul 30, 2020 at 7:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> I'm not sure I fully understand what is going on in patch 6 & 7 but we
> have tested this locally and seems to work properly. These changes make
> edge cases DFS link targets work, fixes reconnection/failover where
> there are mixups between netbios/fqdn host from mount call or link
> targets, and other things (null ptr deref?).
>
> So AFAIC you can merge with
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
