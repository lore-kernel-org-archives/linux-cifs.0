Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651E0C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 19:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbiCGTDO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Mar 2022 14:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244938AbiCGTCz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Mar 2022 14:02:55 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262196D4E5
        for <linux-cifs@vger.kernel.org>; Mon,  7 Mar 2022 11:02:00 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id z26so13711182lji.8
        for <linux-cifs@vger.kernel.org>; Mon, 07 Mar 2022 11:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UaElNruVNuFS2nBZB+dXtlNVultIerGxWoXXB1VaxQk=;
        b=bDhussN6WOiZvzqzym5zlYyMrCE4m9fbBR46M+0oRYN2Qb0X/4yo09rfejxbZVYCul
         wo1WeUBwE4fM2MZzkFWC1i57yJy95P0GXvIUWjLPDEahm9eKlplAi6IC+I5dS6yroO4u
         CQgygTD3Q7slVNh4AkhIMmhqOqJFoukkVPfD1PKF350Eubpn5kHytnh/9kryU24M8jno
         Zd9eTK3djCE1yYPqDolC+xOirCGscRvvWuGjMbNLFEpfL9zwTP5CTWjCbhbvgc1NpsQa
         9a2+ykiwCCua/daD8Tmb+Qf6A9hr0eXasLrKzJxSyL+wetuJ2xwnUsQ4yiXvfSWhGbsF
         1tLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UaElNruVNuFS2nBZB+dXtlNVultIerGxWoXXB1VaxQk=;
        b=AQicH+PgTYxEKImP9MFq18aKbSFvXOmI3w/rMvcK/ivMlaaksBG5eAru+1l9gYvV6L
         tb3Cf6MhDMltGRxwQmd81k8GCNNLrZ6CvYLe6xMJgOrI1R8lpLBt0ozvpeQ+h76LZSPa
         1Z7KRoJOn+kbXbiuImgPhAhOexlApI8aGhmPjKGisIV9SjmTzAKQ5lBEFujZCY6KaBPC
         W8qSJ9xEYficORWao4/ml+28uQj8OiGR5iauuZRGyjl2PXBkoEDk0gKVmRzQ0tj1Gt7i
         Jl8NP2Dh/6UK0xbtUZLwdicih+bd0wbCyL/wz6LJIYHQkT8IhQPDTc+kiv8yPeqUUm6n
         Aa3Q==
X-Gm-Message-State: AOAM532O0yvRoGY+UXNNHeZVRafl+N1rMV8ZejoziiZUmGPfatoBBvkE
        ie0tlgmXIKbBU6tGrdj59hcSu3mIAZX1IsZJgwuUmWuV
X-Google-Smtp-Source: ABdhPJzcPhd6NWbxPA7ptT6iGjoWP913VJ6io+ooI04vVU/Q/t65z37hJlvCDni08f3dPaiw5+1sioTUHdx1Su4Il0E=
X-Received: by 2002:a2e:908f:0:b0:246:3e31:a80e with SMTP id
 l15-20020a2e908f000000b002463e31a80emr8479407ljg.23.1646679715092; Mon, 07
 Mar 2022 11:01:55 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
In-Reply-To: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Mar 2022 13:01:43 -0600
Message-ID: <CAH2r5mt4aaQb2dVFAYLCU_MrPfJmwPM7bUXtOJO7Nwrjm1N1pQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3]Adjust cifssb maximum read size
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Could this be related to any of the intermittent xfstest failures?

On Mon, Mar 7, 2022 at 12:46 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> When session gets reconnected during mount then read size in super
> block fs context gets set to zero and after negotiate, rsize is not
> modified which results in incorrect read with requested bytes as zero.
>
> Attaching 2 patches, one for releases before 5.17 and other for latest.
> Please take a look.
>
> Regards,
> Rohith



-- 
Thanks,

Steve
