Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48857C4646B
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 21:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1818A204FD
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 21:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilmf6fGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbfFXVl1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 17:41:27 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:34901 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfFXVl1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 17:41:27 -0400
Received: by mail-io1-f52.google.com with SMTP id m24so1670420ioo.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 14:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ww83orLgDhYYq1rwPjnguW7XEtyJHhRZRrehTG7Vok=;
        b=ilmf6fGPkRI8jXOddsH4m97YedEc3pk9GPZsgnwD9OLt2KFFzGAdX6xBtzjcpwARo+
         x4EHFt0XfSxYJDQAGFud6Z2R7kd7LuDQKV2iwYOHAIFs79vmIWwciWEb9C3HMJyPpp4K
         2KpL3UWDwSEm4CS8U4SPSufBhEk4p/ZBDhFQeBGFPqc6eKLGsLlMvEWalUh9diAYsPtT
         Ma7bXxrW3Wj6bGmOV91VSLRaFk35Z7m/y3YuTyrs06ER11MTF1ZzNoqU0OydLFBzb6LA
         X0F+BKObRxCfalETyG6KYXWIqHhGcPE1j/swJRpiNxsABcdwQ0dVQhDlt4MkF8xj1qwW
         pzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ww83orLgDhYYq1rwPjnguW7XEtyJHhRZRrehTG7Vok=;
        b=m6mGZd4xQrzd5DtwtxuzNTGKK8qk/SC+4uXT/RMEmhLaDtdAQF7LFOaQMFAxYipsUo
         ExImF0JUivTaqSIKeTCXJIFHjfcc3ddLJQifnYef94nvavklf7b92rzDZbHVFSQkjPPa
         whdXVDOnbkp36D7xC0NjZYYjzB4gWAN3hZFNaszJw91myk/lr5SQ1kfecrlNQobFFvib
         b3lPXjqSiAcMnsRMLfZFiV93I7cCuD3ExA6URpSjho9XpBs9O9M6jADTr3TdSXqMge6r
         OcbmPM1BR/VOWG0GzVcDC0debMhT0nQWDADDdIIkbpED5Qshtez7+LP/V/OXJ+jKEfoc
         YffA==
X-Gm-Message-State: APjAAAUB76z0Ae9bUFvexDvICRNSiCwShzcYqRnta+d7Drl8/bq7rluj
        CaO5AJMcRwYoVNJzSFS5e5JSYHdLDRvn1V/BYC4=
X-Google-Smtp-Source: APXvYqzXz3cPZz2KY4LXduMHEe6aPau9OZUYEo5Qlk/zWZsbzaDqz8AFCZTLrLTnrVol0pKHWYI6D2MwlX3V3/Gljek=
X-Received: by 2002:a02:9f84:: with SMTP id a4mr32688517jam.20.1561412486784;
 Mon, 24 Jun 2019 14:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvobnG1wvyk-ymMKKUCRsAzn2ky8jA8YguFFaUjsVihGw@mail.gmail.com>
In-Reply-To: <CAH2r5mvobnG1wvyk-ymMKKUCRsAzn2ky8jA8YguFFaUjsVihGw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 25 Jun 2019 07:41:15 +1000
Message-ID: <CAN05THSyPoune8RoZ27Az42Os+1chJWWrRwZn9KTmQ3iHJV2EA@mail.gmail.com>
Subject: Re: Minor cleanup of compound_send_recv
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 25, 2019 at 7:24 AM Steve French <smfrench@gmail.com> wrote:
>
> In Aurelien's earlier patch series I noticed a cleanup (converting
> ses->server to a local variable server=ses->server) which made code
> easier to read in this function.  This doesn't require compounding but
> probably helps his
>

LGTM.

Possibly initialize server where you declare it as we do that for
*server almost everywhere else :

+ struct TCP_Server_Info *server = ses->server;

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

>
>
> --
> Thanks,
>
> Steve
