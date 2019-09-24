Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0278EC432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 18:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C65F0214AF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 18:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qz96Mlo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfIXSML (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 14:12:11 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:39631 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730328AbfIXSML (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 14:12:11 -0400
Received: by mail-io1-f50.google.com with SMTP id a1so6773307ioc.6
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2019 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=smuayUEU8rmhnRLjhl24Yn31b44MmB9vFUlaX2MYpBI=;
        b=qz96Mlo/8cOOWUprC64jaYDAmTPUaJ670ZZjBkTM+7JshZcRE4gfFTXZaxsXMN8TBn
         PX8cb8HkUotg/MQHmDgXgcLO52oCxmWontxBo/iGRBAMFK5CnJkyZNxe8qLqJFetUIHM
         ZFGDsG8AdAs50bEKKbfs8UERFa0Ftpt2tfC4V/Qfi2a+G/+zAtSmdLAb+7WmWqexZ7cq
         AYLY57dFsuwUGuU1633qQLK8SjABsLlVKAzDMSC4jUagtVfX0xx4uUK1XpNfhNyQmWWk
         XPq0kDsQZid2a/3m81JC7Yxt7ZThaSmoalLeT1v2yOuXFa8zPw8oXPjaOb+RAze5ifnM
         i4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=smuayUEU8rmhnRLjhl24Yn31b44MmB9vFUlaX2MYpBI=;
        b=VBPOwSHT/2SctyZCx0id7b6a+LEmk9Mgo6wFh305/Y8gpYgnDCLcYn0nPcKQkdnrXz
         sgb4H73YzlmoNdPhwL4EMVy3kwX6Ur9S5kpsLHCqPKuWHmD/v7kN4yrpIKU8mOng0TKh
         SPqqK6dyWaG6uG+MJgbh/MmZN8BWBkmPNmtqoDSHxo23c6AZvxbj8k79yFEHsKFL+MHP
         bsgpp9JHFkHYhEa+V5lnPYJh6FTDoQKdNAjUX10pCpfyr7k9WiYfIw8cGzQ3YGa2KZRz
         OLM9lbN5fgcMQrAES8zZppyOlgheA7M+LeK3pk2BEHfSB1SCiXIT6OM22oSrphRNlAy/
         X5Gg==
X-Gm-Message-State: APjAAAXkX3gheHkzImuf1dBXoas9bij5cbQftKARAa6kkTXBjfz8TDCM
        FI8MjcVKUg35uyOwCkmAPPxjEb+S1IMqOc/FRAo=
X-Google-Smtp-Source: APXvYqxaOuMODj/dg67TD/hpgKtoU8d78Ebu2xth69rNXTczGZtz5AhV1CL7MRe2s4K6EN6EiXmCleX06ekz6wkMh7I=
X-Received: by 2002:a02:7044:: with SMTP id f65mr74022jac.37.1569348727629;
 Tue, 24 Sep 2019 11:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com> <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee>
In-Reply-To: <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 24 Sep 2019 11:11:56 -0700
Message-ID: <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

That pcap shows a problem with the lease break.

I just tried your python reproducer with the current cifs upstream
kernel and the problem does not manifest.
There were oplock related fixes in the cifs.ko module a while ago that
might have fixed the problem you see.

Which kernel version are you using ?


On Tue, Sep 24, 2019 at 10:53 AM Moritz M <mailinglist@moritzmueller.ee> wrote:
>
> Hi Pavel,
> >
> >
> > Could you please enable debugging logging
> > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging),
> > reproduce the problem and send us the kernel logs? A network capture
> > of a repro could also be useful
> > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures).
>
> see the debug output and the pcap file attached.
>
> Best regards
> Moritz
>
