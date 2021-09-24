Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5447CC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 01:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E7660EDF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 01:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbhIXBgi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:36:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240863AbhIXBgi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632447305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WfZS7NxlfPRW0+vqMdPWzqIIFcJ9jdqf9XK/SdnXhPQ=;
        b=TdlSDVBwG7fOTrJJoEbvAIBXx1fBK6Dt/nzd09BhcxfxltzbxDwgTeDuRgzjRqoV/J0eVx
        7+gptjU6mhj/JVkV38QUS8KNxqRMFXMyDJTwmE30jUb7pwSTdDsKAkOO4gMgDek5qQLGAt
        fHdfNTn3TnrtLIY0igPlNOyFXvlX50Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Hn7sImuLM92gGUMY8r3_RA-1; Thu, 23 Sep 2021 21:35:04 -0400
X-MC-Unique: Hn7sImuLM92gGUMY8r3_RA-1
Received: by mail-ed1-f70.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so8596060edx.19
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 18:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WfZS7NxlfPRW0+vqMdPWzqIIFcJ9jdqf9XK/SdnXhPQ=;
        b=qx3pgFTe/ittvEEsc2pydqkDIDmIff/DPQopD/zJESF7fXEGufn0HtX0oeBSlZA+wA
         fqwzDGp1joVsbdOVPYw15ykS41ui6nPedErusZl1I9kZbk+w7Y7pYN4na3yDZlcsG+fw
         n6p+yS9ynf3loGYqbZ/V9HvkYUmW23oC73X+ZbARGutvj16wI3fojpUFeDegri80Xxau
         i0AvebVkVSBxts+oM53qbm417A4ol6s781+U6kXSBGICv2OwZXZzM4tlWfP6O57+9rnL
         2xcrBGj3oeAQ0bv/OLQp0X64bKArglBI6hmwmtXK+yEEhjfmX1P7sIFEOWL4bm8nMuvy
         ueag==
X-Gm-Message-State: AOAM530tgnQvVCT0K+voRyakd5dMIhNOJVgLkxH7l0EhPPJxbc2V5m+y
        vfGUkz59g0lGXOyAXkoY6pv4OAa5ZxQGTzf+CjfDGS0xb4uWU0z82xgPUWZvHQ0g1IWcHqEFcPT
        KE9nuNqBA9RJ/MCyFDzCrNniv1fZZV+Qh31ypcg==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr8668925ejc.553.1632447302931;
        Thu, 23 Sep 2021 18:35:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHOsGvURjp8l1JIyS1P5pGgLaAp+Zeabiw3FjMXuZw3NRsd0Igb+1vDUtlIufNzDa8kfn1MgRXvVFe+/hZNrU=
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr8668918ejc.553.1632447302749;
 Thu, 23 Sep 2021 18:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt6whs+-2LKYCZ_jHpFY27mK84gAJZqqOLCx4ReB62fEw@mail.gmail.com>
In-Reply-To: <CAH2r5mt6whs+-2LKYCZ_jHpFY27mK84gAJZqqOLCx4ReB62fEw@mail.gmail.com>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Fri, 24 Sep 2021 11:34:51 +1000
Message-ID: <CAGvGhF4rxuO83+xvvLeyZYCmD4uDZqtn2GknAD=VJK3zROPe=A@mail.gmail.com>
Subject: Re: Two more CIFS patches pointed out by Dan Carpenter using smatch
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

They both look good to me.
Acked by me.

On Fri, Sep 24, 2021 at 11:30 AM Steve French <smfrench@gmail.com> wrote:
>
> Marked one of them for stable.  Both small and seem like low risk fixes.
>
> See attached.
>
> --
> Thanks,
>
> Steve

