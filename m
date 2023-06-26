Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70361EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjFZF1t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjFZF1r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:27:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BB4116
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:27:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4fb7769f15aso385791e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687757264; x=1690349264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7TvSgH0G5v2PmNV2p4Q4IexKZtFXs1mCWMHO1D/FXo=;
        b=SkYPXIcq+PLYyBKOEqWjZu6USQFshI2HCazqsDpfGYLUnT/jQCCaxiCxi/MG/shV53
         OkZ2KtNkzObcQIGSnMArmxjsBIm2z3qUnWkedhSdOnlQMDVomCH16ZLbU9ANyW1roMjq
         I1FCyG4LU8uZ57dSBWAixyGuc8cPJ4aoc3VwYcqA2nEk0zgasBEQzvN4R4gBJ8m7T9D0
         mY7F9hdoJ3rpu1umkyL74KENBblLP+iTGgUN/xCqMZcVA2B4aD3wbVmWCs/SRZuCPkLx
         J9lN1F610Bqw5lC12BzO6KSIOB2B3xaCg5yMY7CZXUqatZsl2Pbj0byKRIq0cneDodkg
         oYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687757264; x=1690349264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7TvSgH0G5v2PmNV2p4Q4IexKZtFXs1mCWMHO1D/FXo=;
        b=C8qtGShLlCxSFdc8V2OCOugizcEQfwUH6kkDjySlzT96YJ/yemyxAh8svE6by44CPt
         obaVVB89kYNYv2DmHuhti2YeA3zld5547plDtJZ6zSd/tHUM+SeJIdx3UmdGzp4fHFID
         qKgz3/+S45Aa2YFamSo9Z7eDGXcFbebUEkrw8H6vbBemtYR/SQrr90PlRz0nmqA+Mq6T
         5t8kHAMTK6t5r63eI1XSShiN7TlyrVotoB0NmvcDSqAsJaarLwcvkWoXwMT/MJqkTapv
         6eBn59zjZqmfa0B6Jy/nJBvao+GgtpLOzfofHXUORJZ1vA9yk7+TuCMxYwLk+R1YUhIh
         bzRg==
X-Gm-Message-State: AC+VfDxnINfTehIiPInudsYo86/PrQQTwhYKp4r5Qs/pny12Ul5jO2zM
        CfgYDywjmfHBZEE14QduveN3+jKz0wiMOFZqK3E=
X-Google-Smtp-Source: ACHHUZ5hUGF37YHQBgKdeJ0+oSX36Ff8V9E/gOC4WQn3A59xgHofixBDlQEFs2vAdHwkzncVDz7pYwcRo/hHF9TzNGI=
X-Received: by 2002:a05:6512:3139:b0:4f8:6ecc:db15 with SMTP id
 p25-20020a056512313900b004f86eccdb15mr12311126lfd.49.1687757264074; Sun, 25
 Jun 2023 22:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com> <20230626034257.2078391-3-wentao@uniontech.com>
In-Reply-To: <20230626034257.2078391-3-wentao@uniontech.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 10:57:32 +0530
Message-ID: <CANT5p=rv1hF7vX4G=HienkLFnyBdQh1_Qdbd1oeHum_-2fE6-g@mail.gmail.com>
Subject: Re: [PATCH 2/3] cifs: fix session state check in reconnect to avoid
 use-after-free issue
To:     Winston Wen <wentao@uniontech.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 26, 2023 at 9:24=E2=80=AFAM Winston Wen <wentao@uniontech.com> =
wrote:
>
> Don't collect exiting session in smb2_reconnect_server(), because it
> will be released soon.
>
> Note that the exiting session will stay in server->smb_ses_list until
> it complete the cifs_free_ipc() and logoff() and then delete itself
> from the list.
>
> Signed-off-by: Winston Wen <wentao@uniontech.com>
> ---
>  fs/smb/client/smb2pdu.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 17fe212ab895..e04766fe6f80 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3797,6 +3797,12 @@ void smb2_reconnect_server(struct work_struct *wor=
k)
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
> +               spin_lock(&ses->ses_lock);
> +               if (ses->ses_status =3D=3D SES_EXITING) {
> +                       spin_unlock(&ses->ses_lock);
> +                       continue;
> +               }
> +               spin_unlock(&ses->ses_lock);
>
>                 tcon_selected =3D false;
>
> --
> 2.40.1
>

Hi Winston,

We already have this check in smb2_reconnect, which gets called from
smb2_reconnect_server.
But one additional check here will not hurt.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
