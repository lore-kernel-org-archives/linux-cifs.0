Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88272C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 01:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348049AbiALBzh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 20:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348041AbiALBzg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 20:55:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F251C06173F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 17:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55648B81DA9
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 01:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D208C36AF3
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 01:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641952534;
        bh=ZeaOoJLdE08/Zvr8viObH/h2Dx1bS6mOqW6p1TGpXPw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=K0EbFP91irGDL+OALHdKPQWhpfAigMw10dxpM5xpDn/Q8yqAvauLTsD5iizYhodoV
         lcGXEfxFmrBU8v0LR7GbLl2UwPVncafSabmJy+RDOqbBn0K9oH+ixCAMUqzh1O7GDh
         h2UUGUUySKokHDqlUiUBWQFeAJ0T9eYlogRBdlu2Fsn5NO6Bn8hyChPTxao7m5gj3o
         Jtr2t1cLMPPDhmOofndxvLAvCRB0tokm3h78zfysysse8YGh3HMWzY6R4DqdbRpAoa
         G4lGOE7kK26K4mZeI3TP46otlM2MnE7h5I3CoZPGnYpeq7ayE6XQpUBuvVTlvt8wIE
         pPe3fwDqSouyg==
Received: by mail-yb1-f172.google.com with SMTP id n68so2212079ybg.6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 17:55:34 -0800 (PST)
X-Gm-Message-State: AOAM5323BrJVrAklikQzneXjEymQbF6QSCQlHkaZkYSlwvbta2JXcTej
        rS+ZniIn+W7+EpFxg/kFLxNagt0Uz4la04P3Fa8=
X-Google-Smtp-Source: ABdhPJxolccl3khI8ZZfflT4SePvXwKiFxVW9wQqK0LXELEhj1PwgtYSTypgCcegCbh8AW6ib2uEDveQ+HzuLBHAGQs=
X-Received: by 2002:a5b:58d:: with SMTP id l13mr9969804ybp.475.1641952533118;
 Tue, 11 Jan 2022 17:55:33 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Tue, 11 Jan 2022
 17:55:32 -0800 (PST)
In-Reply-To: <20220112005115.99855-1-hyc.lee@gmail.com>
References: <20220112005115.99855-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 12 Jan 2022 10:55:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_LZ6=vXU7GrCLtEBXJBYVksLdmx9dB-DWDwP=nickGPA@mail.gmail.com>
Message-ID: <CAKYAXd_LZ6=vXU7GrCLtEBXJBYVksLdmx9dB-DWDwP=nickGPA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: smbd: fix missing client's memory region invalidation
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-12 9:51 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> if the Channel of a SMB2 WRITE request is
> SMB2_CHANNEL_RDMA_V1_INVALIDTE, a client
> does not invalidate its memory regions but
> ksmbd must do it by sending a SMB2 WRITE response
> with IB_WR_SEND_WITH_INV.
>
> But if errors occur while processing a SMB2
> READ/WRITE request, ksmbd sends a response
> with IB_WR_SEND. So a client could use memory
> regions already in use.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
