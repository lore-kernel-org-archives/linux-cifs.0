Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E3AC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 17:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CBE20643
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 17:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJHj9j4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfCKRrv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:47:51 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:32931 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfCKRru (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 13:47:50 -0400
Received: by mail-lf1-f45.google.com with SMTP id h71so4116035lfe.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 10:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7o6HTrzG5+qP+qhSGmkrYLSN/8H3VvVojbC6vYmxVU=;
        b=SJHj9j4ex9byzJxwrA2cA/FMO8ULDEsQa6bx8Ea2gzjMncp5UMo3JF6YCqwWSI8B2k
         l/ZIibTGKYwViJVCNae/Qjy3OlBpo297acFQGvx+/b9rBsoZHdyryxpwNJzTfSodUgDO
         +SHmoKTJducfwHNXq4aYviekXjk0erLXpOms05Dm3dxV/eui0iq2ofot/VpReFQIKBdn
         yMcFfFb4ophSWchmzhzZ7C73OBsU6sqDDcmkUMrhEKroESPCHrIkH9SoMHdFpVh8Amyb
         TVnOexp3bBb1JNVYuBWqrfxQEGw+Bv+Y6PTeLh86pGo0JHkpUemcNtL2nh6ZL4mmR9nB
         FEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7o6HTrzG5+qP+qhSGmkrYLSN/8H3VvVojbC6vYmxVU=;
        b=ubXnyAIiQQOZu1cUYH71VFmYlmS0IHSHHBJM0OMDMX5vxQ1PAud1xuN7DydI+ZyY5T
         dc7vk7sfwZuDVVLtzRFEzC+Hx+4KQXefmnMMCuqqhChzGFgGdpdpVJrcxXnAB058X+Bh
         nmPd4pmHGc1LZqmJVHrG5mlpflMFNS5j8aA4pMMYWnKWvD7V+kyhpYo/SipeZEQqaDAq
         iszE5H3GhekBNITm6okTJ8GqtxYhOWGn/yIsNcMVLbyvzKzmQRIgfqO0m95uBLN8t0dq
         D3B+TmCyRIiMtDYxLaXKMcV9vcvN7gcmZdlNm3f0oQZKLMqiw8YtASYp5hOTm9OAUzet
         oZ4g==
X-Gm-Message-State: APjAAAWJAhr6i+tHLx0RZ7G/Cp5f11nsxa4qD4DVoqk+GY97ssd/SBiL
        DaUTOfp+0i5AJQ0tN2Y+n6kJ/9DpqmBu5dthYGQQGFI=
X-Google-Smtp-Source: APXvYqzACYJcu0qcCemA2WIDsSbD5EQDaCKKPuTHrmQBB6gtLCzx4uxdPCwN+BxG5OhHFMCVTT/GYfgLtB2aG59GguY=
X-Received: by 2002:a19:960c:: with SMTP id y12mr2495325lfd.159.1552326468769;
 Mon, 11 Mar 2019 10:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msdRYgbuz_V5Rb+LGPXc-EweCusoDMePTQPz-fuguaSTA@mail.gmail.com>
In-Reply-To: <CAH2r5msdRYgbuz_V5Rb+LGPXc-EweCusoDMePTQPz-fuguaSTA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 11 Mar 2019 10:47:37 -0700
Message-ID: <CAKywueQ7ntS3UHicYeNwKOZ0Bdi1gXrrYvs8ETsuC5TVt7RYaA@mail.gmail.com>
Subject: Re: [PATCH] Add dynamic trace point for timeouts waiting for credits
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky
