Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6776CC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 17:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29A2D222D7
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 17:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhP3Vh5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404046AbfBNRmA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:42:00 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:40662 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404044AbfBNRmA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 12:42:00 -0500
Received: by mail-lj1-f171.google.com with SMTP id w6so1226230ljd.7
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 09:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gZ1eoCYneS9yAgLZnUc42E4oXtwJEIxN9Z3hdYREjoI=;
        b=ZhP3Vh5tML8EwLKw4IRvn8dA3scWRZcXdaP2vxbJ6iCulxA82lh7eRPhqgPqcoz1ZM
         fjDP/yDP38Mi3bJ/TqviV02qC1esOwI2J5UApjR8gMyyYNn7w3SCPVGen6WuTt+nZOvb
         D1TVU2A/XdWRJa3jpF3ErD8dI81EYhmROm5qHiH3IGzys0XthXMUfibJaVVR3pzHC4vQ
         r6vPIZmXShwh0vPSkp2KTN4ai1iWYXYtGcgaMbRD3EYhU190lsOx5MmWbUS/W2ua0065
         bgFAKDvfG3OaQtGGOV28lfnX3bf8am29p4G0G/GVA1KJtEAExjG2Iw2OX1K6+uuOGK7v
         Izxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gZ1eoCYneS9yAgLZnUc42E4oXtwJEIxN9Z3hdYREjoI=;
        b=VNBmvph/hFnbLk0NBCFEzi8lOUztfGw58hm3J8QmcKmaXJdwfTRoK0SyDvRnwETzQu
         4D048HYWXLUA+0UXgevJaREXd6Gmgjv+OJSkNY/qaZJ2xsUU6eY1Ou9S+AS9YfCnk1sb
         3iro+4L2inaVzsx8KBqajdH0X/T+9SBX4e7+b05Yz2X1SlqlgV/YUdsL6x3xjk4WmB4h
         mVKaXM4QGIOBPZiHBajcEikiXXhAOUbTjPpKYpas+neG86V2FAgGQsjcxL21/J8eVaQy
         s4dC+1bpQOITv+ZFKBc/wNjxdNY392olsbAiCe8h6AGPDSzqL1HIaekx1Dpc3lET3lj4
         c44A==
X-Gm-Message-State: AHQUAuaAR9VFvHBAKGveKG1NvsAn94iPNfRcpb/XfSrmy+nOm5r4bHKS
        c2qcap1cYn29uVnAZL9rvu0O16wrweWkGwa2Sg==
X-Google-Smtp-Source: AHgI3IbsnQAlEUn3WX7kknzLayaQqi0HmMLGJ9oYY4sXkOCtDA8kTv8cKN77Qe8J1ccmFklm6tBVotPgQanHxHCG6hQ=
X-Received: by 2002:a2e:868c:: with SMTP id l12-v6mr3165978lji.90.1550166118839;
 Thu, 14 Feb 2019 09:41:58 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
In-Reply-To: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Feb 2019 09:41:46 -0800
Message-ID: <CAKywueSEaqsy+WRKfOmeSEbficz=OWDdbrxW1X2S336VMCafqw@mail.gmail.com>
Subject: Re: [SMB3][PATCH] request more credits during session setup
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 14 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 08:59, Steve=
 French <smfrench@gmail.com>:
>
> We only request significantly more credits (during mount) on first
> session setup so we typically end up with from 43-49 credits available
> when mount completes - which is not enough for a large I/O to complete
> (if started soon after mount).  We need > 64 credits.   Solve this by
> requesting more than 2 credits on tree connect.
>
> After mount (before this patch):
> 43 credits (not enough for a 4MB I/O)
>
> After mount (with this patch)
> 105 credits (which is good, enough for two large I/Os to be issued
> immediately after mount)
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
