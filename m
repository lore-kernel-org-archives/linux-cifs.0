Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A18DC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 14:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjJ3Oyy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjJ3Oyx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 10:54:53 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7A3C2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 07:54:50 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-507bd644a96so6594303e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 07:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698677688; x=1699282488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JU1+AlOjb6oMmpfgDjxA0bJFuXNbbKopM4PYQVmoSYk=;
        b=jjv6pjnVOUEl9J24wOSrdBdQw8u2rCtgGGzfzUI1tjy+PwmMeZHiwedRoSCSUKXTQA
         964lDI0Cu42pLGkZWlmK+KYmFhQEV4U0cg0LavdvcLj4cBU0/uBeQJBwUGWWOe0SXcxz
         Knh6SlAGGq76XLSjL7TFevK0xa9zboSUo/pU4Dm0bbER/7SeWCa5AnSBzRDUmwg5a5aU
         0lotWJG4hAYet7LAd5rxb6hRBMakj+XMx8zhA62IumFeoeARfr6FqgGRQ5ZpPSqW0UGb
         YVVTd4/xTMfZIOjOL0tNB86LquGUReokXiECR4jBMhJ1BXkaX/jv29KS3kkJaR9kBTVy
         Fang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698677688; x=1699282488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JU1+AlOjb6oMmpfgDjxA0bJFuXNbbKopM4PYQVmoSYk=;
        b=M+CcaoJs4oLsfZP4UDnNmCUKtt4J+yEaxBpemJogpy+D0D+t8pbFcG/MrUVkZiSzUW
         oh+lmvRObZA4MYoyyhJlKBxxfgbnEtnbFyO0spOYaSee1FcTXs9wfDLZ9nJbcqaqlHjo
         1q8+DHWeBo/hNSRPqZWAfUkEfo3ZB7c9XEKB9JWRx0k/IkOlnaw/rG/MB39hVZ2mnotx
         H6FS8MOO7PWOqp+P9ob843WIG6SkZo7epwaaHWYpyGQ/Ng4dFkppvtVgn0NBARV/7Ex8
         s4DJ/2W36fW3ISqptCYJ7l0m5Za2l/Bwp7HwlIE2Aygwr4cjzcgYjqktexLQwhL3qyWp
         YvVA==
X-Gm-Message-State: AOJu0Yzpm5RYAxObZJyUi6Lx4AxX+PLnIA7WNigcPTnzRffhcGqOVx8h
        nBWPVjzFcmM+6ujn4PgtaTFHtlobTwv/HYNvK2Vz1Gg9e9A=
X-Google-Smtp-Source: AGHT+IG4ViKvRp8SR2hr2B8ZXI6y4INhtaOt08Lv+PyiaD8+FsmmrWKMmaipeEXZbpRYLr0WgIzg52XJs0/kxTWHWjw=
X-Received: by 2002:ac2:54bc:0:b0:4ff:9a75:211e with SMTP id
 w28-20020ac254bc000000b004ff9a75211emr7340285lfk.42.1698677687948; Mon, 30
 Oct 2023 07:54:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 09:54:33 -0500
Message-ID: <CAH2r5msCnBt9yqE8G80eh5mcA+8U5UsV_83++by++5wuzZ5UqQ@mail.gmail.com>
Subject: Re: [PATCH 01/14] cifs: print server capabilities in DebugData
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Made a minor change "Server capability: "  --> "Server capabilities:"
to make it consistent with the places we print session and tcon
capabilities in the DebugData

Let me know if any objections

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> In the output of /proc/fs/cifs/DebugData, we do not
> print the server->capabilities field today.
> With this change, we will do that.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 76922fcc4bc6..a9dfecc397a8 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -427,6 +427,8 @@ static int cifs_debug_data_proc_show(struct seq_file =
*m, void *v)
>                 if (server->nosharesock)
>                         seq_printf(m, " nosharesock");
>
> +               seq_printf(m, "\nServer capability: 0x%x", server->capabi=
lities);
> +
>                 if (server->rdma)
>                         seq_printf(m, "\nRDMA ");
>                 seq_printf(m, "\nTCP status: %d Instance: %d"
> --
> 2.34.1
>


--=20
Thanks,

Steve
