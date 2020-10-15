Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE53C433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 22:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3618E2078A
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 22:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OktTxdHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbgJOWT5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 18:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387851AbgJOWTz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 18:19:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2684C061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 15:19:54 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w17so286192ilg.8
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 15:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7YXSTpuLbjjX5pn7JOE2gBmBSx86xPwCHVvG7GOB7A=;
        b=OktTxdHVhp5XAEs1MiIbfd/477++f3C3LgGAOAcBctYAMON3e6rIooyiEDiQRXFWmk
         0Cw5BNOJDuX/DGyXqDabkpVLlMkVKCu5CQm214ISwjKzs/C2+fLvGAtIFT2yit1JfHgd
         C+52lTG0HdOWsfjVIKl2dp4hIHwmb7jSaqf1EeyA3ZA14n5NDSBeLnQbA+DJ6+Q/FWOu
         UOX6T+pw7BIuPr0m4/HL6AvvNEdo+0rBHIGYQlp4012k+790SNg9vUyEiL30RnCmov3q
         PidBBrVpVPW6RNYcIQ+5s3TqZeIRSEgo8Vz8o2xDGUf2yKO4i8Q1oN5IFI/Hycuy/Aaa
         FB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7YXSTpuLbjjX5pn7JOE2gBmBSx86xPwCHVvG7GOB7A=;
        b=BJDZuUdtMu7FCLzpgqNxAOSKgAKEqFVEm6bxEJqicIWRknt/Ne6wfqoRphVOcqKTbb
         dqUpPCvQlTWUh2SKr74lREQtbADGwBDdJmvcZbWucN5Cf6p5+oACJOIDTOLKU7gk8MqS
         Ve+HePfiyJLE7AqRMUuqG0qj4ECWhP3kUdQtoLlJ4WYxyZfqPollf71Aotm5CprEE9J1
         5kgEblLcElGkG9gzRKdMPjEA1+GQI5UI2eN4f0pooUzI37uvfQYhKa0G8m2VXOCAHxrJ
         C4pp39vrKg5InRsiz9lCO1VRt9COWvDnn1/yMmWlshmq/EoJN3+ZWcaOb4fTcZmnoQB1
         c2uQ==
X-Gm-Message-State: AOAM532yc1SNCD0U+NzsJdoL0s+YOmXfXEZv7t0s9ZJuN5bskD/Ro7bz
        EhxHEWNHO9nvYTsqPlF67M7kDZyVdXA6cYUxSO8=
X-Google-Smtp-Source: ABdhPJyadWL2J2/xGXv1rLu5zHkELTLwC6ogOMl0SJN2BD4vFQNDlyfGowwG/5C8LpkHZj3K0x9tZ2uUD5yK++cPQzQ=
X-Received: by 2002:a92:89c3:: with SMTP id w64mr542373ilk.49.1602800394235;
 Thu, 15 Oct 2020 15:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
In-Reply-To: <CANT5p=rkeg0w67RcdKhRzGRD_iHA-eB9cBPOO-6BxZz+iyRp3g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Oct 2020 08:19:43 +1000
Message-ID: <CAN05THQ7XMF63-u1SLoRa-KZJS_u36M3Sb+ku6FsrUpvHx3doA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the error from crypt_message when enc/dec
 key not found.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 16, 2020 at 4:02 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Fixes bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=209669
>
> Please review.

Since it is an oops, can you add the stack backtrace to the commit message ?

>
> --
> -Shyam
