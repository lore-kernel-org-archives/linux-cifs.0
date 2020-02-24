Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64667C38BFA
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 22:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D7082176D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 22:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wci2Ct75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgBXW1m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:27:42 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46331 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbgBXW1m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 17:27:42 -0500
Received: by mail-io1-f65.google.com with SMTP id e7so1865871ioe.13;
        Mon, 24 Feb 2020 14:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=okoEokk8koFi0gbrNVrs/CtK734/+xWplYEPxW27+Gc=;
        b=Wci2Ct75KDbCFUhLx2OoDlxXrlzD6YzLomd/+CaJKS7ovaUCAfTfeP+SKU3NDEQBKG
         X5UJJrKhPzn5aPiK0tCRQJAOx6GCV3NJsv3ahtsP55qKWaBjuwD0lhuhZ7DUAnzH2Bqi
         xTdlPhbbBl8o0UjlB3xFGoTkKtSRVV4p9yrPaPR5H7gbe9K3tQbQ7wWiI5CqXlpdFWM8
         f/0JJGm1fMj8xFUACo8xRr+jXCzDwQolfdJxkynDJdkQ2UF4Th9PtcXeaVPYfqoswlV8
         Aq/PVHB7koAmFnt/R7pFT6gZpoWuv9XuLOvXP3EaArqfs7jj/mUGLbxUcDBhuwbfpng2
         nQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=okoEokk8koFi0gbrNVrs/CtK734/+xWplYEPxW27+Gc=;
        b=LtWhOWBg4FDJdDjGaBzQcYApdIoX3PqBiDtIm0Ep0iiiCPLZbI8IyYxqipMOdAG5JR
         9dolEYQFgoDlv4mwB9r8WOtROuI2CA9Q4owI7dl6GMTmDQXqcMoLNAMoP1uDNwpJMX1x
         SdnBKtSOWhNxG1NWCZXw7NryMDmQ8byxe7ys7RKIc02ZojMlww67PFqfAeauTfvOd6Gk
         loh2OxHtlfdfpedbQn/N9l8d/nNfZGKH3VOer9uq+QwzsPK7PDnW+9uo/SOQV+66HIV9
         AT4c4ZHoHHF4pfJ2ZtFZLiwod1sbFzEK7dgqKO84zn0sK3yUnr6m5WB9ODPBm8vWckoB
         XStQ==
X-Gm-Message-State: APjAAAVhnCJuCe9ahEuCTNDMUud4ybPsTlHvgchbSOvykSEwUTFhzr+K
        ytyJ3tiH8kua+UseiGXtrq9uS8jpZItF3q1wtqeBQA==
X-Google-Smtp-Source: APXvYqyvB53aFrIiMdZSK+Pyl7Sam7svWwN4rs//H5xeSV3qfK+PHY59oqCwhlbWovNG9LjrT85SyFgM+QyFjzuDSKs=
X-Received: by 2002:a02:5b8a:: with SMTP id g132mr2106136jab.78.1582583261895;
 Mon, 24 Feb 2020 14:27:41 -0800 (PST)
MIME-Version: 1.0
References: <20200225075237.61e103e4@canb.auug.org.au>
In-Reply-To: <20200225075237.61e103e4@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Feb 2020 16:27:31 -0600
Message-ID: <CAH2r5mv0YhqRNYogxo4TkK9FdzG1JrDz1SBfQt2+91RgdiAEfg@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed

On Mon, Feb 24, 2020 at 2:52 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   39452a5239bb ("cifs: call wake_up(&server->response_q) inside of cifs_reconnect()")
>
> is missing a Signed-off-by from its committer.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
