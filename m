Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6A9C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Mar 2022 00:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiC0Ay3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Mar 2022 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiC0Ay3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Mar 2022 20:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517B966F96
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 17:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07619B8037A
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 00:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42D7C340E8
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648342369;
        bh=z9XI0eZ+tb5zj5pYFo17yEnodADJgiFUFHW/r6E+CQI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=bamo1k8P58L6irfWL5XCvQLXSEZWzamOm2Z0F2+TmboquqXk82oIsMvi17jX2ybQK
         3gK0awhQk9UqGauhnC95aUMUoRz3PllVh1+ySh8cqVYpm6VML/A4xtawgEQ1pjs6LC
         sAOZENXXw8o4w5FbVaDgHsu2WzYeooM0Ve1OH+wOkvMyH2Wz62/1VIpITiNQBt0qov
         Pijd1njkWWMbG9PSh9rKYsaFQk4yifxzrE2dWoBzAjh2SoV+dzDe26Vd8HP+qGKw0u
         MhYy2FhqeukqW7NFU+ikQoffnZ/adYadatsxA6jKMU8DUf2/nMT5S9rbpumVWzXc9g
         mgtxPmFOGoI3A==
Received: by mail-wr1-f48.google.com with SMTP id h23so15517060wrb.8
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 17:52:49 -0700 (PDT)
X-Gm-Message-State: AOAM5308QE4zgSCXYfObM8p7bI24SWe2INFy94erUWmrCtfFGJHLijKf
        Q/sIed7F9kcWmWx8Ji0adOixiRlj0xS3Nvg4jOs=
X-Google-Smtp-Source: ABdhPJwVKg48bnjNqE+leT0iYcbmLZDL6XXqYKjAftIqBrm/gacOjUlSeojgRo7+/yQiK87wjPKuyoG0wexA12vcqM8=
X-Received: by 2002:a5d:4149:0:b0:203:e064:2571 with SMTP id
 c9-20020a5d4149000000b00203e0642571mr15403922wrq.62.1648342368009; Sat, 26
 Mar 2022 17:52:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Sat, 26 Mar 2022 17:52:47
 -0700 (PDT)
In-Reply-To: <CAH2r5mtHGwL5=8a_RTk+0NRQK349yy=_ytyr77r-90eZ1UHacQ@mail.gmail.com>
References: <CAH2r5mtHGwL5=8a_RTk+0NRQK349yy=_ytyr77r-90eZ1UHacQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 27 Mar 2022 09:52:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jT-3o6cXfdUhAmxRbZYF7AoCmH3uXJK=-6emZ-JhABA@mail.gmail.com>
Message-ID: <CAKYAXd_jT-3o6cXfdUhAmxRbZYF7AoCmH3uXJK=-6emZ-JhABA@mail.gmail.com>
Subject: Re: [PATCH] [smb3] move defines for query info and query fsinfo to smbfs_common
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-27 6:26 GMT+09:00, Steve French <smfrench@gmail.com>:
> An additional patch this patch includes moving to common code (from
> cifs and ksmbd protocol related headers)
>     - query and query directory info levels and structs
>     - set info structs
>     - SMB2 lock struct and flags
>     - SMB2 echo req
>
> Also shorten a few flag names (e.g. SMB2_LOCKFLAG_EXCLUSIVE_LOCK to
> SMB2_LOCKFLAG_EXCLUSIVE)
>
> See attached
Looks good to me!

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
>
> --
> Thanks,
>
> Steve
>
