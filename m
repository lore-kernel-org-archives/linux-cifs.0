Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EE1C77B75
	for <linux-cifs@archiver.kernel.org>; Fri, 19 May 2023 04:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjESEeV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 May 2023 00:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjESEeU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 May 2023 00:34:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7BCE69
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 21:34:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-96f6a9131fdso23167866b.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 21:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684470858; x=1687062858;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JlhatVC3PMFgnqS1f0Ch/VirG9RssaxiOOzSQoMScLU=;
        b=NlQR+sO8tqUKNnZxRAtv8YexAz4iFzkMHyJEYIw9DNv/E7nPgUHzYSJkhDH1v4L0SJ
         NlG51kBRnYCeCkTPt/r1FI9tHyYzlePtRoYpEs04rWf5GRXLvF/IYz99LDjcLuOWHXg9
         3PwfihkoJUngl12+5QiaeukHYN/CBJZrWz+/K/PxZfKh0a6H831xEs79amcakLnoxLvu
         ctnjhowlk6WmQM1/8luzwDNuvoQwL56fuWaWKz3hyryuLIbkX1d03E7mEofMTb2uQzQl
         mFVkeONmptwcxgyz+TWAt8hErQyH21vfGivbKvLP8h3NB9jNkbP6R9a0j5G15rsCcHNm
         MoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684470858; x=1687062858;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlhatVC3PMFgnqS1f0Ch/VirG9RssaxiOOzSQoMScLU=;
        b=CiBWYF5YviyPya8/mOM11YmFMMl6zhLthlm/5PEKJ9igUSDKRE22pRWtDChtNEc+6O
         fFMhuNBRnulW44AyCFc2y1Y0eCmkpootfKp2tAg5sdQcv17VL6Q21NPIVWohH9KtKCBS
         m3U5j5sH6ebi6q0x4EUuVKnlFfa1Vpgm/ukVPOl7j9QFzZgPi3AotqNnpxxq79wn0fJZ
         ktvn/SXlWNXeZWH41tAzxkjmlTJzBU667BZoqgVtbmVYszgMv9dPqtuWTNzhJAIrg+yE
         m/VKww3MvwIizWYd1NLYRMR6gslSMVB2T/DsBVx3dHKiRgpGiKDskm0vCItvhZBRBjew
         czvA==
X-Gm-Message-State: AC+VfDyNoIhgwNFPpT820SRJf0iywK7YGF0D9LXbmw38PD7ca0eZWr2S
        gb8+meWoO8aBK4OSWWeGLH0IjCWQwj30lMPX1LQ=
X-Google-Smtp-Source: ACHHUZ6SkCv80z5KXTIACVsiu6twq/aTr8AtUMvQ3ZSy3IUs7Vdxf4zRbAGCMkmJfmAoe7oANb0crhSvDjnbUTgPKPE=
X-Received: by 2002:a17:907:a4c:b0:94e:e30e:7245 with SMTP id
 be12-20020a1709070a4c00b0094ee30e7245mr258138ejc.8.1684470857931; Thu, 18 May
 2023 21:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230518144208.2099772-1-h3xrabbit@gmail.com> <CAKYAXd9gBFPORqQ17mELGyygyOPxY4awsGxvOLYj7O3ckUHjrw@mail.gmail.com>
In-Reply-To: <CAKYAXd9gBFPORqQ17mELGyygyOPxY4awsGxvOLYj7O3ckUHjrw@mail.gmail.com>
From:   Hex Rabbit <h3xrabbit@gmail.com>
Date:   Fri, 19 May 2023 12:34:06 +0800
Message-ID: <CAF3ZFec8fGUmKun1hPG9yBj0A5iRA5HJKMfjS6oqgQi1+CrDTw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>          if (ctxt_len <
>              sizeof(struct smb2_neg_context) + MIN_PREAUTH_CTXT_DATA_LEN)
>  You need to plus sizeof(struct smb2_neg_context) here.
>  MIN_PREAUTH_CTXT_DATA_LEN  accounts for HashAlgorithmCount,
>  SaltLength, and 1 HashAlgorithm.
>
>  >               return STATUS_INVALID_PARAMETER;

Sorry, should I resend the patch?

Thanks
