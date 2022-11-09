Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E10C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 05:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKIFn7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 00:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIFn7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 00:43:59 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC37F015
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 21:43:58 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id l12so13038949lfp.6
        for <linux-cifs@vger.kernel.org>; Tue, 08 Nov 2022 21:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PDUsU5YxhGir5zFKVtLtM7NVgYERqw9Ei1tYWCMxqLY=;
        b=LELcWMXYwPH2ivuCkt0sC1QDUIhY3c9KhE/JkGwUdD7qW/XPC/uxV4/puYBQkeh/lN
         njrI5UtIPVvjTUT9GcNouo4/2x9GOMNN8f1dqHVAk7U7DXHghFl7tZ4lr9nS8SS3Gl4P
         /9dY6AxI85F9xC+yaplL7rj5WlsGjTg6T8pyhY0EHzckx6ly2jJynFCMdmIQQA9imKZZ
         uYfTDkBi2kG27waP9FiRjzIWSENhDjEvoVJEdnXq82o/y5G9PJPohx3S8CqEKxXx40Kr
         EiZm+BNshWP9RSXy3F5wLjt1h02Vx0/dF73B/g8vyxZhVGbkpzvoN2MyPMvFdsSmsPgl
         V9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PDUsU5YxhGir5zFKVtLtM7NVgYERqw9Ei1tYWCMxqLY=;
        b=Uy6pnDr+38g915cSHiIjG8n/AY7DC0jfipJT7aM7Hg2i/sV2qVkOUU1UsIH60/Z2kt
         zxe7S4JxW7xUdwQED909kWq8rDEV/TItAeEqK8E+psyttAKqmei1sJg57A9oFRnSybV3
         QcEXqs+5srxnPEqlkSTWkccprmXYzs0V7G/0hB53jJaogmH6Qc62X99cbmEE4JcBodH0
         QnNsk+rdmY0I3UMPWX53aMEAhe5q9IWnKmkKX13i7vH0RbfnjnqnAMf38iDxHdW1ujpU
         TTlI+rQO2Ied8GXcRfreBF2KilqU5JuJtUg9sXpDDbFtj3O/F00UxHhFDwk8Hw/LrFmZ
         CdKw==
X-Gm-Message-State: ACrzQf3cogjZINnLd0LtqeMktxuwira9aXPXcFghEsMbn3jkGMS9zMZJ
        +5erBNQVFdyGay2ryN0ImqnnUxB0qIdsLiNmb4A=
X-Google-Smtp-Source: AMsMyM7BrOZKwBOe8LgbB9mEdfTT3j2NTHQb2iR8UiquKjoVNAVjhrI0B9RrBw61CQxOOH3L+DaGDAWcFqDCD1Bv62U=
X-Received: by 2002:a19:f71a:0:b0:4a2:4fdb:5037 with SMTP id
 z26-20020a19f71a000000b004a24fdb5037mr22275587lfe.535.1667972636180; Tue, 08
 Nov 2022 21:43:56 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pW_CMrD4EacJnwKGK74nW1sRxa2ummheWxujwXtfh0cA@mail.gmail.com>
 <68bc143d-393d-574b-c600-1575b38a5e81@talpey.com>
In-Reply-To: <68bc143d-393d-574b-c600-1575b38a5e81@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 9 Nov 2022 11:13:44 +0530
Message-ID: <CANT5p=oCch9-67FzV_84StBQ=8G1juab7-FzUBfMhgvTwrS5sg@mail.gmail.com>
Subject: Re: [PATCH] cifs: avoid reconnect race in setting session and tcon status
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Nov 8, 2022 at 10:16 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 11/8/2022 11:33 AM, Shyam Prasad N wrote:
> > Came across a couple of race conditions between cifsd and i/o threads.
> > Fixed them here. Please review the changes.
> >
> > This change should also ensure that binding session requests do not
> > race with the primary session request.
> >
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c4ed4d985488640469acfc621bed5c3a55d67ac6.patch
> >
>
> Copy/pasting from that page:
>
> @@ -4111,6 +4111,16 @@ cifs_setup_session(const unsigned int xid, struct
> cifs_ses *ses,
>         else
>                 scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
>
> +       /*
> +        * if primary channel is still being setup,
> +        * we cannot bind to it. try again after sometime
> +        */
> +       if (ses->ses_status == SES_IN_SETUP) {
> +               spin_unlock(&ses->ses_lock);
> +               msleep(10);
> +               return -EAGAIN;
> +       }
> +
>         if (ses->ses_status != SES_GOOD &&
>             ses->ses_status != SES_NEW &&
>             ses->ses_status != SES_NEED_RECON) {
>
> Sleeping for 10ms is really an ugly approach. Apart from making a
> completely arbitrary timing choice, blocking the caller uninterruptibly
> is pretty rude. And if the existing setup fails, this will blindly
> retry it, immediately.
>
> Can't this take a more formal queued approach, with a proper wakeup on
> success, or bail out on interrupt, timeout or fail?

You make a good point. I thought this was not very clean too. But took
this approach to keep it simple.
Let me explore the waiting approach.

Thanks for the review. :)

>
> Tom.



-- 
Regards,
Shyam
