Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BF5C19F2D
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 05:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiHIFj5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Aug 2022 01:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiHIFjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Aug 2022 01:39:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E761183B3
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 22:39:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a89so13785170edf.5
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 22:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=h9mb8i+/86DCNIsdcUJZ95OqmIwZGN9ivnUHg6oAv2Y=;
        b=CRgC7m/Vq1AEeizLLP2+5IoC9kvyBRPzYxwvloNbrjMmPKqaKWGNOKnMb8RoacwrSM
         G/LNv/0AEM20bDhufQf2VwWMuV8KxIfOswy1WVHNYme5yvahgC5dUtY7DHpQwd/t3Kjh
         6BSazNI/auJWyidHClY7gU60ed8+WNJYcdvFhnhZUXDdS75PmWLIcRRMLG5jZf/5fQdx
         jjd3wJptk4BadDclJIKYOHjljZMZbgxBXrWaX15ALJJv+ejSLtJYIjosCGwREUQQN6VI
         5h/axLWo4b0o0c31feQDdDWr+a3HCnTnx+ixcf5VxC7CC5U/4/f0y0iiZ+47SjDki6XB
         fOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=h9mb8i+/86DCNIsdcUJZ95OqmIwZGN9ivnUHg6oAv2Y=;
        b=zS4golT11tABsaktd3FPJcNvCIlJSBwgD2VW/63qauEKI3YyvXu6W97h+qZQKa/d7Q
         EkcBXgqhHlnLsRcHnDmbgPqk/BgBoKbanlfyEdI0EAKzniBTOlD8SLG4k5XyZZeVoFeQ
         Wq37Yrch4IRiulVgqfS0x1awOYbVwobwHNG3viva0hUA1hyjewfeyFpvU/PCPeJLPa/Z
         f/J2eNDs+/DXQDf/FRZECVfbn5SooKyrKZm4iysk5AvF33hD/TUIqJHy0VcW0OeOA9pD
         Aa6evp9KTNmQqc3V7pAucHq4uuHRjTFx2XexJv+E/TsaNvlMoNs8XyIC5wOqN/8APwgC
         1wkQ==
X-Gm-Message-State: ACgBeo1X4aGZiH/JUzQ1gdkn6uQ/1HvbCJ51QvmA1HySdpGdL5jEKwfI
        TQDPShYulhCh8cm4yKO/zSUaQH3IH2l1Ht2xF/HnTOiq
X-Google-Smtp-Source: AA6agR5GIvdh7/AhuuF9w3ASR27543ToOEa1DS0uKdFpkt2JP0nxWp03l9AQFARlK3zYMbH8vQ4OPbmC5fhETyeVIeE=
X-Received: by 2002:a05:6402:177b:b0:43d:64c5:7799 with SMTP id
 da27-20020a056402177b00b0043d64c57799mr21291061edb.180.1660023589784; Mon, 08
 Aug 2022 22:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muR_X4FQMYv=-w-yP8Gv-qFLGEtXZD_36FJSCDracgnBA@mail.gmail.com>
In-Reply-To: <CAH2r5muR_X4FQMYv=-w-yP8Gv-qFLGEtXZD_36FJSCDracgnBA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Aug 2022 15:39:36 +1000
Message-ID: <CAN05THRh9hFkFCDcq_7CwCY+20KnLNT=zEgcWCFX0srGAc1gkA@mail.gmail.com>
Subject: Re: [PATCH] fcntl F_GETLK return F_ULOCK if the whole file is locked
 by F_WRLCK
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by me
Looks good

On Tue, 9 Aug 2022 at 15:25, Steve French <smfrench@gmail.com> wrote:
>
> Any comments on Paulo's patch?
>
> It fixes a regression in connectathon test 2
>
> I tentatively merged it into cifs-2.6.git for-next and added Cc:Stable
>
>
> --
> Thanks,
>
> Steve
