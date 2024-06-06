Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF408199236
	for <linux-cifs@vger.kernel.org>; Thu,  6 Jun 2024 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717696316; cv=none; b=o8mZ7sL9BC2a4DG//2T7K1ZitNinACjeZSJ5YGkkrlrSHD1U1c4A1DyUiF1AIHXTk5BZ6CVSjtAkzxwOSeF9IOtr4IPwiS9ZlvTTCv3+kFRvuRnKEXmdhgO474OX44fuvQKbyb+s/DJWxOT36cn86XsVoM3SePJ+Ju3ds15nrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717696316; c=relaxed/simple;
	bh=NlQHPzRNNV9L7olGqLJ0tzq0DYYJdFIfR8ZdHafTqIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrRe9t9XAjLWsodXFuNPSHtQoLh39CyHFSOzpaCRElTr2kLY4PpSd3Fnb70zBnEhUQ2FsCEPytiWU9Djrfya2Y70J3ANbHQEq1v9ZtQwxuGyKFy+qfK964sXfh+9ZoT/Qmzt9dtO1rQNWyJRaJT2VR4AuqYiHZAEs1JBSfu9yuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/UuydXf; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/UuydXf"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52b950aa47bso1905810e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jun 2024 10:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717696313; x=1718301113; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qt4FLVyprgqU2/taXxBd/fPgCgIg5srrafZ1+q3iDLc=;
        b=S/UuydXfFHqIO/pDc+J19XxG4/Mm5+Hb+B1B2DwedD2Z+r55c4Y7EVZqztNMFTVlqE
         OssNu7jKuCfdnfRx1z9/y+seS3Y/JL6jSSlwwqmAtBe2AHaUvhiay1LWjlE4AeXdHBuk
         pd2ilkkC/VA5c4izJRkoq7mF12HpZ+rO34cOxDrSD6MAmyAln1ct36OeTxtOO4af84A9
         835/SgkRr/k01/2zQAdyhu7gBk3fLhIFu4yqEXCoiV9xbUN+LOOmAnNGb72jvlekzTZ/
         xVZax8rzNK/NTs1KWt+BWAzmad9b6cCn5ttzvtPjAKXRlnS0GLnIhKD/ADI5iJJ7mIBy
         3v+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717696313; x=1718301113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qt4FLVyprgqU2/taXxBd/fPgCgIg5srrafZ1+q3iDLc=;
        b=i5GNsf7zzSl2L5yL7yzqUQm3SY4ksX2OwlAbbz1SgEtrYCVtojvtXhNKGq1YQv6hb4
         JBsbnDBbzvpxR3WnpNBcN9ekvv0tdx9gpoStAa8DvXhD0t66gKCrj+OQPhC0AJ0rNkw1
         2pRNYeNQhIJuONZu8eLvU8E6f+Vk3c7OeWG3Ey4L9aI3UARAqW0lGJc7/qU2OeqZ2wAg
         ADiIbJwxtJozJQOiMZuzvh/ImVqaqSys9n1E/ee49vCCMBM/Nbw/l10b+XjFtlTSYqZO
         nGJfL2rV0z3LXwNN3EWhAk1UrAbjObatkG+gdsDrCoZtnCD+zO88Twz/v6BXZ0N9O6TZ
         PwwQ==
X-Gm-Message-State: AOJu0YxjCunpNIzTUdVElsIv3b/mLbkHKcWox+1LviJcTzzV8W1ekRtX
	aKS3utmm6tOpzMqEpfKSIjEaAEJH7BBWlLFdtVddAR+EUxu56RsEp1gjD+9SE0MybtllgzDaszQ
	XUFGZPEO6w+R8wso86VujApNwABk=
X-Google-Smtp-Source: AGHT+IHCrfutONH7Z8UMwXbrmf73JVaaWz4jb32hiExOZk7QFLKHPUbA1E/RAkmCjWpeiD1PicPKLIoscP9YR5QTeSo=
X-Received: by 2002:a19:f508:0:b0:52b:b6d0:b368 with SMTP id
 2adb3069b0e04-52bb9fd06a8mr195032e87.58.1717696312645; Thu, 06 Jun 2024
 10:51:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240606161313.25521-1-ematsumiya@suse.de>
In-Reply-To: <20240606161313.25521-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Jun 2024 12:51:41 -0500
Message-ID: <CAH2r5muDs3V_dVZZcozr-6bXE5pxo66kjaLHFdBpRo1hGpJyJQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix deadlock in smb2_find_smb_tcon()
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next.  Is this an easy repro scenario?

Shouldn't we Cc: stable or tag Fixes for 24a9799aa8ef smb: client: fix
UAF in smb2_reconnect_server()




On Thu, Jun 6, 2024 at 11:14=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
> deadlock.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/smb2transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 02135a605305..1476c445cadc 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -216,8 +216,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __=
u64 ses_id, __u32  tid)
>         }
>         tcon =3D smb2_find_smb_sess_tcon_unlocked(ses, tid);
>         if (!tcon) {
> -               cifs_put_smb_ses(ses);
>                 spin_unlock(&cifs_tcp_ses_lock);
> +               cifs_put_smb_ses(ses);
>                 return NULL;
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
> --
> 2.45.1
>


--
Thanks,

Steve
