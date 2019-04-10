Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF49C10F0E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E7120857
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwjLm4WH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfDJCw4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:52:56 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:46556 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDJCw4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Apr 2019 22:52:56 -0400
Received: by mail-pl1-f181.google.com with SMTP id y6so415469pll.13
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2019 19:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zcq4NuPxQI2F1cEPLZXeWZ9RiGkONuA8nty0YW11WE=;
        b=jwjLm4WHtXx7Qji5F0ifD/DW/S2ADs2FXWVIxs8i3XemaBsg4N4UwgjCGEdmQ3iMY3
         wv163KQuNxTqPh2hCICfpguTFUSik8QgvLe6WxpVG1uWi/mlk/l3/++SvqtoK2DX4tP1
         DGgenVnlp5YnJ/eyTC1Zv8/myP/JZZt4Fwur+CdP6P4rBJ7N4EFZj27bxKIqz3pS+pyo
         4syZ8dFAItejV5XFyw0RUFF4NJHuNL4qOy0J1TCuG6netiFiEGnGn+u6CS0b2uOMK5xs
         ZIfX1nvDHBwNwTojB1NpE83h1MON5kj98Im13U9DKwsaLzpvPXOWnnxq3pDldzXZpsph
         POcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zcq4NuPxQI2F1cEPLZXeWZ9RiGkONuA8nty0YW11WE=;
        b=LQNwNmqFvFml2DcP9Fk1gfZXeD3sBq6pyG2qkYHTVNF+geMspGI5wprYj8xKjGN9lg
         gPQ80tGfx31XcUhzKPS4e2ANaAd6qed6Ndxmb8M/dh0kdNs7dAgVFJ7gDvPy2aKVLevz
         mlz0hhlV/sBhEcepXiTF3AZdPmSEnBVNTt1m9dmPnSrn14o8gWFPJCEyRcw6m2Fu8rpL
         UmOQkQyrl0/4sQRHu+iTXFzQAeoyEce2IRrKR5TZW4BCPQK2JiiQ5LqEyCB7W1NVyfTW
         VsMG1Od60xc1zTVDGrdlmr5f2Oj8eVDkt8PojEm8nocv+5ad0xZIci3UmP1FaOez8UlP
         jqvA==
X-Gm-Message-State: APjAAAV8p8cezoZ5D0X+eedkeYD/dGL4RdZgIQvWeLKcNjT8PFqTYIfr
        2cOknjZFoW+WIWMkpW0kKts3FJLPw538SB083oRMoMU2
X-Google-Smtp-Source: APXvYqwn/fBQeJoNfQ8+eSeheS7qbUuAd7j9517aS7e9+i66d1Wk0O1WLH0vWzbjOuD3ertco8T1zSB2tf427sgA068=
X-Received: by 2002:a17:902:70cc:: with SMTP id l12mr40919993plt.10.1554864775085;
 Tue, 09 Apr 2019 19:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAGCB87tK0qBHSZsGyEAAhNq_6C4Dv+ivqphn3-DgRHm8Yp9ERQ@mail.gmail.com>
In-Reply-To: <CAGCB87tK0qBHSZsGyEAAhNq_6C4Dv+ivqphn3-DgRHm8Yp9ERQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Apr 2019 21:52:40 -0500
Message-ID: <CAH2r5mvCcdMStvrtgBoKthMnR0vuEWO59mf4gU2JhgODRHR=AA@mail.gmail.com>
Subject: Re: Kerberos ticket expiration on CIFS client
To:     Andy Beal <andybeal623@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Have you tried a similar scenario, but with winbind getting the
kerberos tickets (rather than kinit)?   Since winbind can handle
automatic ticket refresh

https://help.ubuntu.com/community/ActiveDirectoryWinbindHowto#Automatic_Kerberos_Ticket_Refresh

On Tue, Apr 9, 2019 at 9:49 PM Andy Beal <andybeal623@gmail.com> wrote:
>
> Hi there,
>
> I recently deployed an SMB share for my team and am trying to access
> it from Linux clients joined to the same AD (using cifs-utils). When
> mapping the file share, I first run "kinit <user@domain>" to receive a
> Kerberos certificate on my client, and then map the share using
> "sec=krb5" in the mount command.
>
> This all works flawlessly, but 10 hours later (the lifetime of the
> Kerberos ticket) the mapped share stops working. Note that I don't see
> the same behavior when mounting the same share from a Windows client
> (e.g., there's no need to re-login after 10 hours).
>
> Is there anything that needs to be set up in the Linux CIFS clients to
> prevent the tickets from expiring, or to cause them to periodically
> renew themselves (similar to what Windows clients might be doing to
> work around this issue)?
>
> Thanks!
>
> Andy



-- 
Thanks,

Steve
