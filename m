Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D884839FF
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 06:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707200043; cv=none; b=YllEzxsW9NctCp1BLg/HoS2KU0DvMp0E6qw8fyHUZ/drDGL6JdV9k9swuqEL1pdew0gMlkmth7iGZg8NXibIRIUDjWnLiBYo6Ov1Rz2GpOKychlSsFoljuMeFsigHFiet0Zw7fC/e5tWXfoddk5AeSC6Gvk180zi/Ya+ddJ6ER8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707200043; c=relaxed/simple;
	bh=6GZu6i73tP5ygSrBIdRW1sbW6QEiEpA6UYZD9tp4bWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CEyo2ojH1ylb/LdJ5H1n5RoCrRj9WGHmLMUp71xj4WGUmSwl5QjUwoVYEIjy6w79YLBm+WnSmUlj/7X2kHQug0j0mYJsTl7DT5dA6mtaWAxMyoDXDg/xGQWSjhXCspEc++LfiqSdqaIgTERshCi/DTpfjNPA9G0xcQ+6s4ocvHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/i3KF57; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/i3KF57"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51137c8088dso5652156e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 22:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707200040; x=1707804840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dtylrecvxxp8VUC5crHrURPX8SaEtdLHapIjvpGa3cA=;
        b=W/i3KF57fo2vi7h1DG0z/nTidACZvovtBKi9nN236Y0oeGR2S7ebvn9whDYs5+cAKv
         p68qIj3KHxkV8jyx/mt9vgyGy4yl935t05CpLTXBOBg/DO/IhG6+tC4Q4uaWfKqFC1k/
         euqpRaRjEEVA8ADDlSiKSyMMBMWn7tGf5gdHhu81VTCfiCAzCAT66Xr1u+RqMuSYJHWb
         usBIG0Ib3x7cgx0xIYc9ViUmqkXJwbi/cudev6qDqCyS/rs25j2gP2gxFqo/Y7up7nTe
         3lfwTDdPky2kFGozCipXaUe9UwxtQuu7C2N4xAMItn3bIT1oQVwUJXxE3xLxaWHvK56z
         zP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707200040; x=1707804840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dtylrecvxxp8VUC5crHrURPX8SaEtdLHapIjvpGa3cA=;
        b=mVkzcGh0ckmn8ArVmdRJ/DXNMJcUbNzjUVFXfdAJ5SNtyjAHQ205dB5SVnVYVmnHk1
         6TXpciAON0aJGKTzhfeNzZgGDk7im3+jpNHMhP/n44pqhp57dLxDBfCZufZtbFQyNB8X
         cCLnLcl3IuMj9qU10BheBOXPQmDiaKagWjnRRAIenPfsEMSAc67pSaWbw1ADYSro5RRK
         5UCF9B+0DisWMZdKnzK+Eokf8OUNl511Tx0GVpfukZ0s98gi+tPmMGZHvbClnLhT94l+
         nz1Jd0bOwf625ZWwApYgQXl/aCsVbqyCa8rkXcYenof3FJ4aVLzxAM5bonnGvMDNV/ER
         F0pA==
X-Gm-Message-State: AOJu0YzZxNSftDEVceJTeaf8lpFDrS5q5pXr8mpmvnvwYuOCPFi4OTeF
	H1qOCrGxVZfHlEbVw/AUluWZolqbo2gUAZHX8wf6axCKFo43gKnhH5hHODiuXsC7wdVbTs64spu
	OUV208LIzrnS6UaxKx8mW8HtlMXK2qjdb
X-Google-Smtp-Source: AGHT+IF5T7FTnDOcHFuF3SE3+tZu62ONmdNTRMTtqax+83kxZIWixL7CdSeJFzUMEFVVPKgjcKtrlFBIY+pWVM748/o=
X-Received: by 2002:a05:6512:64:b0:511:32cc:1c4c with SMTP id
 i4-20020a056512006400b0051132cc1c4cmr1049605lfo.40.1707200039594; Mon, 05 Feb
 2024 22:13:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201111530.17194-1-sprasad@microsoft.com> <20240201111530.17194-5-sprasad@microsoft.com>
In-Reply-To: <20240201111530.17194-5-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 6 Feb 2024 11:43:47 +0530
Message-ID: <CANT5p=oNrsP6ZMuUjZ=JT2wg9-6BBS=t03xhmfHxZHMgM9QjOw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cifs: enforce nosharesock when multichannel is used
To: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 4:45=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> In the current architecture, multiple sessions can
> share the primary channel, but secondary channels for
> each session is not shared.
>
> This can create two problems when primary channel is
> shared among several sessions. For one, there could be
> uneven utilization of channels due to this skew.
>
> Another major issue is how a cifsd thread can get to
> the channel for a secondary channel. The process is
> already cumbersome. We also need to find the right
> session for the server struct.
>
> To avoid both the problems, this change marks even the
> primary channel as nosharesock. Secondary channels are
> marked as nosharesock anyway.
>
> We can remove this when we fix the mchan architecture
> to share all channels.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 82eafe0815dc..e7543574ea9e 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1043,6 +1043,8 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                         ctx->max_channels =3D 1;
>                 } else {
>                         ctx->multichannel =3D true;
> +                       /* enforce nosharesock */
> +                       ctx->nosharesock =3D true;
>                         /* if number of channels not specified, default t=
o 2 */
>                         if (ctx->max_channels < 2)
>                                 ctx->max_channels =3D 2;
> --
> 2.34.1
>

This was discussed offline with Steve. And we decided it's best not to
use this one.
This patch may unnecessarily increase socket utilization for mounts
that could otherwise have shared the sessions.

Our multichannel implementation makes it difficult to solve this problem.
I'll send another patch for now to work around the problem in another
way. (the cumbersome method as mentioned above)
However, please note that the perf skew problem can still happen with
that change. Maybe we can address that in the next kernel version.

--=20
Regards,
Shyam
