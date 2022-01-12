Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2F2C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 05:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiALF72 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jan 2022 00:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbiALF72 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jan 2022 00:59:28 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA7C06173F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 21:59:28 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id g11so4421463lfu.2
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 21:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjDixZmTx8xyndUL+x06vwqxFKRPaFwZHkeC5y5TVME=;
        b=k/aqVt+HCbKwYejpcbMfsBqdtvtELtP2W04AYYJX3065P/LZzEty/eDoodT+TIuHhb
         RRIEYQbRSMM0BamuG3f6hcootA5AQ9er9L9D3xzGRJ8hES16VpagoVqIEOHnoE31Nw1f
         OEOM/bzRwaohM0OuOunBoECVf9+hXrU0zRH0Kc13LKCHpvkgozyTQk2/MZ6r8JbS933n
         xo6aCopQazn+Sa9iiaYEwAkOheo/gr+9SRTHteUhNdsW5Td9kF2x2hPJfg4RvHQOd3HK
         PDLmVEAZPaO+3Sx1zQzdAcyzvCrGEpcaMsBazzy16fxUTe7Fec4Kb0xFtEgM/hWFKNro
         INLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjDixZmTx8xyndUL+x06vwqxFKRPaFwZHkeC5y5TVME=;
        b=33xgc/mNzlM2dUqdBCkVVXn2CVRtkmci0heJ5RKDBpULyGtaiRlgcoOcnrU4HbVAfc
         iYbHmlyRSPJfOoHHrAIBEjy1MSQWAxoMo+dlmXyQyQyr/hFTNMh4wwjXr6sVMoLJFXMJ
         8hUjsskbqvbMi/QEpuzd6kopwsVZOhE9GUKrmzmP/6Yrg1zVq4tfytiRX4voIfyXMjPk
         Qj+hkjh+ke1dZoeYjDn5kMYVSyb/schJ5Uyz372AhZFXApppLKA+XOsEp3tUrNHRznIV
         jCosc6psr8OLyIqzdEOoxG0Bpd0kURv3YP/lgQaXSkSphKD/VJLk7ThemRiaxTmLsWpn
         74cg==
X-Gm-Message-State: AOAM531X3gjg/s8eP4kZxW9SE5bOBKmnSJWXVE0fJ5N/pQfCJNltx+H1
        BRk6OMeJIfTAx+BrC6PtcEL99mRHBninjQHgUsE=
X-Google-Smtp-Source: ABdhPJyP34FS+KiNNxuANKDkje406R74zxtGwPeGm7YKqozLutyMEJB4VWRjYyI8L5mAeyeXgjPVxRswX6jYaJJ3/8c=
X-Received: by 2002:a05:6512:ad0:: with SMTP id n16mr5908712lfu.320.1641967166302;
 Tue, 11 Jan 2022 21:59:26 -0800 (PST)
MIME-Version: 1.0
References: <Yd1BojYhOVOkyoZt@himera.home>
In-Reply-To: <Yd1BojYhOVOkyoZt@himera.home>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 Jan 2022 23:59:15 -0600
Message-ID: <CAH2r5mtGxjBNdn9NENjc_GLSrmEvF-hwJkfK6oWFk48OV6nFXw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix FILE_BOTH_DIRECTORY_INFO definition
To:     Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

On Tue, Jan 11, 2022 at 6:16 PM Eugene Korenevsky
<ekorenevsky@astralinux.ru> wrote:
>
> The size of FILE_BOTH_DIRECTORY_INFO.ShortName must be 24 bytes, not 12
> (see MS-FSCC documentation).
>
> Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
> ---
>  fs/cifs/cifspdu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index d2ff438fd31f..68b9a436af4b 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -2560,7 +2560,7 @@ typedef struct {
>         __le32 EaSize; /* length of the xattrs */
>         __u8   ShortNameLength;
>         __u8   Reserved;
> -       __u8   ShortName[12];
> +       __u8   ShortName[24];
>         char FileName[1];
>  } __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
>
> --
> 2.30.2
>


-- 
Thanks,

Steve
