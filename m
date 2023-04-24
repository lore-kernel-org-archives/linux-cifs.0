Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CCDC6FD18
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Apr 2023 02:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDXCWl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 23 Apr 2023 22:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDXCWl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 23 Apr 2023 22:22:41 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D92B19B0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Apr 2023 19:22:39 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4ec816c9d03so4169960e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 23 Apr 2023 19:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682302957; x=1684894957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KYnMkTwxeU2tNH4bOGttDlCSdhds9ufjY0t0SMYcNU=;
        b=Y4R85GU5UmldO+K67ZwnWmXn38BZ8KvRQO1bC1yK29z3VdYYIijLJAVpJe7d03D12W
         2FhID/J4DDbFN6KXubtOePu3Vk8cjPzKNMQGPd6SjXvgW0xQo45wiNq0/7bupmb8wL+w
         k4Cml+yg0MYEW+wID7owhIIiYs0iH7mTH8zHNsjUAvVqtrxuZTVrUyWMc0+gBxggpR8m
         IJ+c3qx/AyCWzoad3Uqf6jDig9plbsVEJHXYA+q7fezWfhOGcqQO806v0Iw5NdcLE50H
         rjtat65Nv9lgqTtpJ6fMiyxOgiSMaF9doxI40kpkuAifOSeAMHjsuU42G3/zGNfGmLRu
         Yaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682302957; x=1684894957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9KYnMkTwxeU2tNH4bOGttDlCSdhds9ufjY0t0SMYcNU=;
        b=XylwhpQIXHWwBtqwvQhuuXIVgZJe0ENpwciRmXdbInEYBz4VZsStj5ZwmrP/BQbSWg
         CBJi6VduBw2W3D9vOiin3mHLnDTQpiGGthrZDIAqOx1Sweq3po++fcta6rquHM9M8WyN
         sfFclMqbjyVOUo+2k6BOe2l+Eribkdm7Re2Oa5xWK1krDcGrBKh40rCvvst6+jRjJbdP
         UiRtFgBw0eXow0nJuKvRhtyppdBYizrdWTYodnywYVQENJ74nUzphdtZKUXnrM/xMbnE
         7xMsc+tYZxm8KDWYbuuJDfpYnOOu2WY7Zu7iiU1TXwIsr1uy7pU8Is58u6fCN/dxpP5z
         DhDg==
X-Gm-Message-State: AAQBX9da3vtW41PPUvvUQv1/1cdBdHejL06SeIlV+Yi/KFuzFCmin4ss
        Y8ugwi40IaUF79xz2TSAM4bqScRt3SWYRX2MYTzoIcqq
X-Google-Smtp-Source: AKy350aAUevP8AWM5VRdFg1T+zvunaIbXHzubRsnvkr+WUdhc4MqmodIXnrxfEM0Z5ldlmI3ALzCh2HOW/NqyXtsDEc=
X-Received: by 2002:a2e:a0d4:0:b0:2a8:ba49:a811 with SMTP id
 f20-20020a2ea0d4000000b002a8ba49a811mr2342938ljm.25.1682302957344; Sun, 23
 Apr 2023 19:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1679051552.git.vl@samba.org>
In-Reply-To: <cover.1679051552.git.vl@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 23 Apr 2023 21:22:25 -0500
Message-ID: <CAH2r5mtACptru6kKCnK58EuksefqhTcVHdK_qEUyUnj7YRpN3A@mail.gmail.com>
Subject: Re: [PATCH 0/7] Avoid a few casts from void *
To:     Volker Lendecke <vl@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I merged patch one of this series but looks like the other ones were
obsoleted by the other three cleanup patches you did for
SMB2_open_init.  Let me know about patches I may have missed, as we
get this updated for the merge window

On Fri, Mar 17, 2023 at 6:19=E2=80=AFAM Volker Lendecke <vl@samba.org> wrot=
e:
>
> We should not go through void * without type-checking if it's not
> really necessary.
>
> Volker Lendecke (7):
>   cifs: Avoid a cast in add_lease_context()
>   cifs: Avoid a cast in add_durable_context()
>   cifs: Avoid a cast in add_posix_context()
>   cifs: Avoid a cast in add_sd_context()
>   cifs: Avoid a cast in add_durable_v2_context()
>   cifs: Avoid a cast in add_durable_reconnect_v2_context()
>   cifs: Avoid a cast in add_query_id_context()
>
>  fs/cifs/smb2pdu.c | 55 ++++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
>
> --
> 2.30.2
>


--=20
Thanks,

Steve
