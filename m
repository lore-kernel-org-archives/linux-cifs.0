Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA138ECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 03:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiINDqv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 23:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiINDqu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 23:46:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8B96AA2E
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 20:46:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id sb3so2153188ejb.9
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 20:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9tgxeZipMQR/nu57L7C3VnxxaYjZEdAKQQXhepBr+SM=;
        b=j6tyYfDj6zltBBXmLaisa7OaG2w4+nBjJCQTFTo8Ua3vqccO7Bnbj218TN1hqvfWS+
         NOyBdyszWCPC2iYBwwCs0auKmACevx7WEuAgYBISRS2zOzXbJGQG7drZEUHKJPTulrxe
         qPC+nO+KciOljtV4M2R6e2YxDdKnIl/FNP7y7wGhjdlLCmajUPmiNkrXEnMbTwJsBnjf
         tUJgYSKq3O4p5ldkQbIcV6ljBWqMQ+QIBbMj6eWyeqAlRhqQQB/pFCpzkrOgB9gpfA0b
         Ou3j7UxMBsIuY1mVRaKSv4I6AwUtpGm6A/ZfzJ86n8G24qKgkRV1ucPDPKrSPLj5VZ9x
         ubZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9tgxeZipMQR/nu57L7C3VnxxaYjZEdAKQQXhepBr+SM=;
        b=eit3c1EapmW2Iz7vOyeW3TBxTUNkXDy/cD8Z70mhRr5ehbeQwcTyWdLkfSfVzMbTA+
         0WbC7pxaaQ1E+KQqRzB3xPAlvQgUgHvlqJ9OK0raerg7p2CV/r8fixinHFXzsO3bXf9P
         FBvQ+eN6Hz57B43iq1+9I2c+Fe3xv5Q4/IG8WUEaQ8HbjFWagctDX6syaMev4B+DESda
         5CXAUTY0GYcDuWs16/DcRAo1JAWctiqRxuLUmdaXtrNj/W6QF96HYE5S1AooPSnYTAHt
         NBP2NdloFNvKyajRa+TdJXKUhbAOeO27jmIhybtR37io+TiPsDvV7XZmFBL+4AckOXeR
         c/BA==
X-Gm-Message-State: ACgBeo1yr4dZtJQgr6tWFdHlJDDRc9M1dzWryDSNAorXYEHBu3WdW1aT
        a55ZN0Fq3TA02+DepdLU31e/7x97cnDN0+XvPMw/QNmq
X-Google-Smtp-Source: AA6agR4HNjCFD7QRe/S8YJFWrzrfCErIl1dOkRkHUoul9cQ6B8i3RCdGZUiRQ1wTyzdxqVmTDjin+oPIL7TSSjxE3FQ=
X-Received: by 2002:a17:906:4548:b0:77d:3c16:2e9b with SMTP id
 s8-20020a170906454800b0077d3c162e9bmr9703908ejq.757.1663127207929; Tue, 13
 Sep 2022 20:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663125352.git.metze@samba.org>
In-Reply-To: <cover.1663125352.git.metze@samba.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 14 Sep 2022 13:46:35 +1000
Message-ID: <CAN05THQweWFvfOEU7vQ8ZjKfncKx5HgcA16a0cH2iG34VP_vcQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: don't send uninitialized memory to sock_{send,recv}msg()
To:     Stefan Metzmacher <metze@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed by me for both patches

On Wed, 14 Sept 2022 at 13:34, Stefan Metzmacher <metze@samba.org> wrote:
>
> Passing just half initialized struct msghdr variables down to
> sock_{send,recv}msg() means we're waiting for a disater to happen...
>
> I added the removal of passing the destination address to
> tcp as a separate patch in order to explain it separately.
>
> Stefan Metzmacher (2):
>   cifs: don't send down the destination address to sendmsg for a
>     SOCK_STREAM
>   cifs: always initialize struct msghdr smb_msg completely
>
>  fs/cifs/connect.c   | 11 +++--------
>  fs/cifs/transport.c |  6 +-----
>  2 files changed, 4 insertions(+), 13 deletions(-)
>
> --
> 2.34.1
>
