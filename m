Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B62FC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 03:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjKADOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjKADOU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 23:14:20 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53709E8
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:14:16 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-507c78d258fso9147021e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698808454; x=1699413254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Wy/GlBNQRCsMLyXWA/sPihYfn3p1I2JDT7U84EplO8=;
        b=DB5Mz/QAtqsfNCW9IDBdQBaLAL9Bikr4CdQqm0tNe1U09v87jmdvQPpLYfdjGOOJb4
         GymSV6y+fvc2DZ44BtMyP3Z2adriqdcwPlOotFL3HIg8wT4E4MQKX89jIHeErhkGUKWH
         V585mBf81TKr9gmQc8b+I2oWlSmWaApHAcD2purUWmHjIXg5XhWz6ZfjAumSPXgeXlw3
         dnfKZY9XBj+Jro/u39OuJajK1M37iBNytARCCUbjtozgrscqO2hkJ0/RfyGi5tSAGsOu
         ZEQBywSGGfWKuwj0JC9q834A2YVJeyXK9b4F69IzQZFOrzX6auwVyz6l+CgLwD4Ao8cS
         HNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698808454; x=1699413254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Wy/GlBNQRCsMLyXWA/sPihYfn3p1I2JDT7U84EplO8=;
        b=N2zOBiF4OadhYzoglXI8xT5GmlgGEiK8fCWBxVLTNK66sTToLYK9PiagGmbi65U8ff
         fcTCbXQ6hce1vUgLCh3FPD5UEi2EIZrT0vFArPrfMbOfu5NfUQdVhuZKZKVQwBobiDo9
         3hn+JtVCwxqjQf5iqP0wxJ2YXBPcWRs/zKYVnXYSDqGTxSp8JLldOtjNEgMJ5RYulMUC
         kaWWsb9ZuANlWObL9eLEmNgYVaZGCzXlXL1iDknxUPTMb/nl+m3s83/Yl/ZwSCu7Sfxu
         5HkmEcEFn7BUzZB7CVnStieFJRdMag0LQ5P7ivPNsHa4mHtzrueQp5ug+5eGYbRXEv5v
         FyXA==
X-Gm-Message-State: AOJu0YxSCqB2CCdpU5rQ/z/DqeOTKCc4xVe4P8AfcKS5qLVaPXCrT1ao
        XC9DL9pcYey3KBDAf8+VQq0Z3HyrIfEWUVk17lc=
X-Google-Smtp-Source: AGHT+IE0igpuxb1NasC/1iSn1QUQXvftxnCMolW9hU/AOEZY11ro+hTi5Q3k0SOLIWUIOTxXMtc5fkPjVjMK47xKDNc=
X-Received: by 2002:ac2:5de1:0:b0:503:19d9:4b6f with SMTP id
 z1-20020ac25de1000000b0050319d94b6fmr10843127lfq.0.1698808454048; Tue, 31 Oct
 2023 20:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-4-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-4-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 22:14:02 -0500
Message-ID: <CAH2r5msi2OfU6GtkdvSZLc2SR3tXWpsv8+KRZiTKs=k65-P+=w@mail.gmail.com>
Subject: Re: [PATCH 04/14] cifs: do not reset chan_max if multichannel is not
 supported at mount
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

And added cc:stable

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> If the mount command has specified multichannel as a mount option,
> but multichannel is found to be unsupported by the server at the time
> of mount, we set chan_max to 1. Which means that the user needs to
> remount the share if the server starts supporting multichannel.
>
> This change removes this reset. What it means is that if the user
> specified multichannel or max_channels during mount, and at this
> time, multichannel is not supported, but the server starts supporting
> it at a later point, the client will be capable of scaling out the
> number of channels.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/sess.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 79f26c560edf..c899b05c92f7 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -186,7 +186,6 @@ int cifs_try_adding_channels(struct cifs_sb_info *cif=
s_sb, struct cifs_ses *ses)
>         }
>
>         if (!(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> -               ses->chan_max =3D 1;
>                 spin_unlock(&ses->chan_lock);
>                 cifs_server_dbg(VFS, "no multichannel support\n");
>                 return 0;
> --
> 2.34.1
>


--=20
Thanks,

Steve
