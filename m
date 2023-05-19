Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DCCC77B7F
	for <linux-cifs@archiver.kernel.org>; Fri, 19 May 2023 05:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjESFRD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 May 2023 01:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjESFRC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 May 2023 01:17:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC08E42
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 22:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E3B6540B
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 05:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD58BC4339C
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 05:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684473420;
        bh=n06pXcC4gPgjY8r7z7dQb3VHliVuWEiPBYSInyI3ymI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tSCTZ4KJOXrGROyX4DGIszyFfgu3JKNOyIlwXwnCpxz8aHMtIIoCxZIpXnvhDgUDT
         wixLZRZoTS013AS7V7X9w6Gvy0tCCyfEkUMKZiZcRNLzxaSRTGR/QHPDsvn+vhTYlk
         RH0iG2/fZhSaNQzR/17eyP2XWOvy76BiEa1hAy4HUAK0ex61g1+9ZEbHfnN4GxROoe
         XVsFQHqwuA6fNCA35yrb/0bTHxLqu6Yz3Sq8o6W+vDdu5VQZOaUsdvUNSSuzSNp0zv
         qWlnNsNNqYF4qnhp7brf1adi0+DqHGE8yL6dmnfrUh4Kp2vigztxxz+XoPx4uU2vu/
         Ixq0Rl8S1Ixew==
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-54fdc9b8351so1737950eaf.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 22:17:00 -0700 (PDT)
X-Gm-Message-State: AC+VfDwnRitqje2nbLb5/uvYpjEn31bx2DqnGLooKEh4rPzpPxbxmZMA
        FDBI9yKuqpH/YwF7fIMJhdyIfS5QZ5Yi8gTRLeA=
X-Google-Smtp-Source: ACHHUZ6bYlRvGLX07fjDytbpjkJ8excDm6GQEgaWDG5xG0LXlphtYZ+dZCO/10JotiLg91zmN/XCzWFiBunK6KXdY5g=
X-Received: by 2002:a4a:654a:0:b0:54f:5d2e:ad8f with SMTP id
 z10-20020a4a654a000000b0054f5d2ead8fmr234311oog.7.1684473419831; Thu, 18 May
 2023 22:16:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Thu, 18 May 2023
 22:16:59 -0700 (PDT)
In-Reply-To: <CAF3ZFec8fGUmKun1hPG9yBj0A5iRA5HJKMfjS6oqgQi1+CrDTw@mail.gmail.com>
References: <20230518144208.2099772-1-h3xrabbit@gmail.com> <CAKYAXd9gBFPORqQ17mELGyygyOPxY4awsGxvOLYj7O3ckUHjrw@mail.gmail.com>
 <CAF3ZFec8fGUmKun1hPG9yBj0A5iRA5HJKMfjS6oqgQi1+CrDTw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 19 May 2023 14:16:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_o2+SFz+a7c7MwYmsyH0LrVqWP4AePM2imMSBsqXOq6Q@mail.gmail.com>
Message-ID: <CAKYAXd_o2+SFz+a7c7MwYmsyH0LrVqWP4AePM2imMSBsqXOq6Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Hex Rabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-19 13:34 GMT+09:00, Hex Rabbit <h3xrabbit@gmail.com>:
>>          if (ctxt_len <
>>              sizeof(struct smb2_neg_context) + MIN_PREAUTH_CTXT_DATA_LEN)
>>  You need to plus sizeof(struct smb2_neg_context) here.
>>  MIN_PREAUTH_CTXT_DATA_LEN  accounts for HashAlgorithmCount,
>>  SaltLength, and 1 HashAlgorithm.
>>
>>  >               return STATUS_INVALID_PARAMETER;
>
> Sorry, should I resend the patch?
No, I will directly update it.

Thanks for your patch.
>
> Thanks
>
