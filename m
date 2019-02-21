Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17AAC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752DC20836
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iO1bebg8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfBUUFA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 15:05:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39593 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfBUUFA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 15:05:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id g80so25093310ljg.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 12:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pol17e6a2Ub3vRKUmuQO2cGG3urq/3jqahV8A/ONM74=;
        b=iO1bebg8IjLtwdLLyyZ8M24To8FRghAhOjuuJMXgijRNOqldTvLLoDid9rEUK5Uyp/
         AHHcInBY4X3HGHesKvdIQzQXtn1W7uaF//xwgWIBol5GCJYfRdhn3IWrUSNXTSt9M8mY
         5a537WUBYvwiHXia2f+Mm9IePW1JgnQey5OoX/u6nknu1/9alTrAFkuTSO2CzkNiyAPD
         CcmmtTRIk7wSPU9dyL5FdMaTB0klj+I39JVRMPP2B6DGNbH6anurTP0N1IsXl5m+TsPh
         M3mxQaXDXCD0rbAiiJG9dKRNWCeQewR3GNfC+5xDSrRb2bdREQe/cUMZOsJj5BXngmVu
         p7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pol17e6a2Ub3vRKUmuQO2cGG3urq/3jqahV8A/ONM74=;
        b=hBgZ3IeDnKdDLd+jhGunE/Wnw+ahgiMsG0lF2g3fMwurmi+mLvSHhPysX/neWudBn6
         C8733txOMxwKtCptb35dNyW01d4p0G/5ElBfhohW2FTt9RNpqG7TeqOf/lk4Ks/N5RRQ
         p9AtlPrt4l3HbYfXG/QdTNpjiZxuKkkS1Rluf9R9VqUdInjXnLirwiRK+LPUkbGWDYZf
         k11+JRwTBZB2h88IaUPbAReEq+pl8nPJH3vWoXHh+X+E9mtrzaj16dulT0qhh53qGG+b
         8M3QZYmiTgzH2G8CDotXQX+c/wsqvd0p9U8LTq8DImBX5xNnS27+aE34rtrJ35NZM9fC
         Sdqg==
X-Gm-Message-State: AHQUAub6NFw9QN4Xx831qaRMXr2dKG+YoBKFNKRF2JVto60uuzNJLG/X
        YY545QUaxQoWRx/7c7YcAxPAkXuEpZTm+FzjUg==
X-Google-Smtp-Source: AHgI3IaQMySisfOa6VOIH6z2DhIXeA7GawGHUuJWKdFGgZOq0NvNPNyNOMAbWwJJE0n3C4IcVqybaqfp5pua3Nf/Szg=
X-Received: by 2002:a2e:8644:: with SMTP id i4mr158035ljj.192.1550779497818;
 Thu, 21 Feb 2019 12:04:57 -0800 (PST)
MIME-Version: 1.0
References: <1550705753-15443-1-git-send-email-pshilov@microsoft.com> <CAN05THTJLY4iBOHSC4h7DEgCXvmNbKr6WDqMQwZEBcpL3AhSsA@mail.gmail.com>
In-Reply-To: <CAN05THTJLY4iBOHSC4h7DEgCXvmNbKr6WDqMQwZEBcpL3AhSsA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 21 Feb 2019 12:04:46 -0800
Message-ID: <CAKywueSHtEdXb_YcvFNO5BRggWRxNCtgzUsXmc6TJfVgm633=Q@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Reset current mid to next value in sequence on send failures
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 20 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 16:06, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> Awesome!
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>

Thanks for the review. I posted the V2 today and changed the title to
more self-explanatory one:

[PATCH v2] CIFS: Do not skip SMB2 message IDs on send failures

--
Best regards,
Pavel Shilovsky
