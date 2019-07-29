Return-Path: <SRS0=0u7K=V2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D89C433FF
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 21:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D67A92067D
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 21:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzkmLlG0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfG2VCU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jul 2019 17:02:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45736 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfG2VCU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Jul 2019 17:02:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so28625959pfq.12
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jul 2019 14:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCNpzuwWUsosGTYsf9wMIecEjNAuFa1FuOjErmGyzTY=;
        b=IzkmLlG01iGRvF1fuT9sUpcTZ8HNaMRFXgkiuyHjOlv1v4e80dFXcDNCkJSpgbHviS
         66yN76dRHF2Z1+udiS8D7QUlQWUq76W0yvUwff+NjEdKXMA4lm/uLdoWeMXEY/JIz35a
         9CfxeSht5hm73ZHRBWBZvkLUDqkDb6nYIVlGkEHts1IoMp1SfIvtXJTJfVQLISCyWiFr
         8FWXJsmGqDXWnwFNSu28tjSTfXXYJjg5HqH0VdfUCo4o0hMsNSL00dDZ7/8WC2XHm0aw
         FCVx1e5xJunWEy+gbKuZr3Ag2L1BboIkDZldQD3fAR5o5Z3pA79jwqk2ww3C7rzjqjks
         RRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCNpzuwWUsosGTYsf9wMIecEjNAuFa1FuOjErmGyzTY=;
        b=MkWpxSpr/kin0nA75+1+yDHbzpnLQ82W50LEgtRSuBm6LBKFXQoXBHYbPtkV9Cx2j+
         o1erFRQrKFitaquyLGTJ1fH4B5gy/HjcKzbfeRgRu1QAubBv5klS9p/fNdVw2UThU9ye
         8duDNRH3oYt28T6Q/F0+qkA8iDIchS2DRgJYzTPLHftWVZ6aMlZLo5qHF2aZa9ZooGcT
         Xyvx5UBC1tMFksNGbuyxWvGNE11F1Ocz76QJ2BIZMI/dyGEppDm7FqiCVFEEtI4vk5+h
         YEgo0v1Nw5J4fkT5//7xLaXgbOn2bnEFIXV7pV6fBDQLjz/kV18FefwdvbUhAhuUUDCX
         uZWQ==
X-Gm-Message-State: APjAAAVMvTQScnmhZQTd5qq9a3nxb0KzjTq54cb1LHjqxabuJ0w2hhpi
        SYza4odydATnnED8XcfUBKpyBEITS9TQj/v42PXh07Ys
X-Google-Smtp-Source: APXvYqxDtZjmODAKtklRhXQGC9Kd6fBk52lB5D4XWhYnxwECEfhajzkSfeG+l0H6OXO4Hp/CHLdhk7XmV3RFasbI5bI=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr115548659pjb.30.1564434139195;
 Mon, 29 Jul 2019 14:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com>
 <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com> <e6246145-8143-ea69-6471-6cc593c95324@wallix.com>
In-Reply-To: <e6246145-8143-ea69-6471-6cc593c95324@wallix.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 29 Jul 2019 16:02:07 -0500
Message-ID: <CAH2r5mva1S6Z=4fiQ986Hv8dA81Liy1C7FGK7UoyvNmt5ZqWoA@mail.gmail.com>
Subject: Re: PROBLEM: Kernel oops when mounting a encryptData CIFS share with CONFIG_DEBUG_VIRTUAL
To:     Cyrille Mucchietto <cmucchietto@wallix.com>
Cc:     Pavel Shilovsky <pavel.shilovsky@gmail.com>,
        Sebastien Tisserant <stisserant@wallix.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Cristian Popi <cpopi@wallix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the patch is an improvement - I am ok with it.  Unless one of the
mm experts has better idea

On Fri, Jul 26, 2019 at 1:28 AM Cyrille Mucchietto
<cmucchietto@wallix.com> wrote:
>
> On 7/25/19 10:35 PM, Pavel Shilovsky wrote:
> ...
> >> mount works without CONFIG_DEBUG_VIRTUAL
> >>
> >> If we don't set CONFIG_VMAP_STACK mount works with CONFIG_DEBUG_VIRTUAL
> >> We have the following (very quick and dirty) patch :
> >> ...
> > Thanks for reporting this. The patch looks good to me. Did you test
> > your scenario all together with it (not only mounting)?
> >
> >
> > Best regards,
> > Pavel Shilovskiy
>
> We've done some tests (mount/unmount, copy/delete/move files) and it seems
> to be OK.
>
> We aren't sure that our patch corrects the root cause of this issue, as
> for our
> understanding, kernel stack with VMAP_STACK enabled might not be contiguous.
> If the stack is too big to be on one page and data are splitted accross non
> contiguous pages it might not work.
>
> Regards
>
> Cyrille Mucchietto
>
>


-- 
Thanks,

Steve
