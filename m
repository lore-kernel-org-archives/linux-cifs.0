Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE44DDAD
	for <linux-cifs@vger.kernel.org>; Fri, 28 Mar 2025 07:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743146388; cv=none; b=JVJhrI6AzQTR3GkQCeK2ywd36gyppSZ9nR8PE37fKy+Wjhdwlikc9GgCcvVJ4CiLoIjo8mYJR/ZbwFIJgeeHNqVJckb4cfccYF2rIuUZOomWYb6OpqfiQu+3arYLhrDJo5snqi/tc482R9sU2PdpThrObwCwUeGqQjnQqojQkyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743146388; c=relaxed/simple;
	bh=p2Xe6t20c7jDv95YeEYupg5afQudMvVjf4cRtYF1xGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LYmr6KCJaEZ5HcjlwgspCtxwZKiDyXuhznJY5eBRwBA4YH8ts+kdN/TiTqIltKWSsNr+fZG0d2NY25r5Ju4P6TU57RzTPdGg390+f4DX+qig+sWbQhZOYECxpYpHYj07y/6HlviQzVnOK6ymq7WRDIO806edefNI9FPZt3NoRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YeDSBNKz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YeDSBNKz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac2af2f15d1so235170766b.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Mar 2025 00:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743146385; x=1743751185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnko3g9v8Mrgk+aSlVAhEA8zV8Ev55/l3TLAwyUNEm0=;
        b=YeDSBNKzpGgfylG024aICsfCYsmuuHI4Ino0Kc0ha1dWRrHbpc/5nCsUDYuQUnx/Dm
         go73J40xvpYjcisVExMNUZmO1oHqlRSelKGllhWppggKS5GQqj/vvXUhmV9FAa6wa9c0
         j9dexb0/V/J+6cDNcJdBF9s9guen2m6BPp/mMRcDPzg5r4R39x9pkx335kqAHKfYEY6t
         VWgWELu8O0xRNI0S1b1dAMfEJjidPsFygfOJ8ZvPwQyA+GFgZQMvoBNbABIeSSS5Ga3W
         wBPoxpGkaHMoDtlk0CDEuLJ2unvJ8nZS13vf8gKmpa1zKY1900jdtxd+JJSiH08CuCZE
         vcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743146385; x=1743751185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnko3g9v8Mrgk+aSlVAhEA8zV8Ev55/l3TLAwyUNEm0=;
        b=vJjymZnHUr91bre8Lvvnjb13yFLhJ82BYjfR4U/0J7Rz2Uq5O82C0QZGLXrgTDm+MW
         eiJvf/RoTiy/MQErVRG5g3bB+4c2ffm8ZXw7PBz2wK8gwHTH5iGOgR/9ilu46pBTvFDO
         zGZRdq52mzqYgdz0wYYwlGXHLBYudODMGAdctF7HKPoU1LYYZ9hLuvViBnBhpXmMvT2K
         l4SdxSsKULKlhER4t7blWX0m2jLKfKSVF70FPzD7qJGZXLrIyNdPhzpc86ZGAm11u1Hv
         BjJINX3a4a2TQ/u1p9QEq6J8toEDFgU9hCrYc9uQxWtyT2vmRAE1s/M7Vc6HVYLHw9yw
         WMUw==
X-Gm-Message-State: AOJu0YyoGzIRleuJYspMa5DQ6nzzYXQ/C5ORfR7b2a7pEXbEdLnURZz7
	tT5F2dE51Z+63CJPh4btJDW/L+GRfLYvov6uiyIjdKpyGKBZ3MaLREf6CFKdo8l7tbJr94EJgB1
	Fc6a38MgShqUx/toREKhifqNITtQ=
X-Gm-Gg: ASbGnctyli7FJh1HJ5Q1GmUAReYJGeK+9wj/sjTg1A9kiQ3gEeDFisV/CL2Pqsf2AZv
	oqoaYoPw5E+dMWW2N1NrMVFjR9vlwglGvPcJWUNhzF5j2rkIcR9oP4dQv3/AFcVltymPOYMsGFK
	H5zj8iMCoC6F+QlJFGMX4qeOoZ
X-Google-Smtp-Source: AGHT+IHNPBjKki/eZD2nzSy/2VzymVlZ0beTaF0cL3dPWHa4ljLh+mTJ+UHc+P+RdmXkjLcPS3It7xll5dKeafJ63Zk=
X-Received: by 2002:a17:907:728e:b0:ac3:4226:d40 with SMTP id
 a640c23a62f3a-ac6fae7c6aemr618349466b.12.1743146384691; Fri, 28 Mar 2025
 00:19:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z66BwJnHAI8zDOzP@linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net>
 <20250328061312.3043039-1-aman1cifs@gmail.com>
In-Reply-To: <20250328061312.3043039-1-aman1cifs@gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 28 Mar 2025 12:49:31 +0530
X-Gm-Features: AQ5f1JrI7SY_DG_GsKgdeA21G2dEHT5afsXnSSkRgzAWGlSdVR3jKKRzZpPdk1I
Message-ID: <CANT5p=o2ACbOMUYPi4vOAewNWtH8RJLoTObVE3vDGG7wDTZXPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Propagate min offload along with other
 parameters from primary to secondary channels.
To: aman1cifs@gmail.com
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, psachdeva@microsoft.com, Aman <aman1@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2025 at 11:43=E2=80=AFAM <aman1cifs@gmail.com> wrote:
>
> From: Aman <aman1@microsoft.com>
>
> In a multichannel setup, it was observed that a few fields were not being
> copied over to the secondary channels, which impacted performance in case=
s
> where these options were relevant but not properly synchronized. To addre=
ss
> this, this patch introduces copying the following parameters from the
> primary channel to the secondary channels:
>
> - min_offload
> - retrans
>
> By copying these parameters, we ensure consistency across channels and
> prevent performance degradation due to missing or outdated settings.
>
> Signed-off-by: Aman <aman1@microsoft.com>
> ---
>  fs/smb/client/sess.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 91d4d409c..35ae7ad3b 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -522,6 +522,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>         ctx->sockopt_tcp_nodelay =3D ses->server->tcp_nodelay;
>         ctx->echo_interval =3D ses->server->echo_interval / HZ;
>         ctx->max_credits =3D ses->server->max_credits;
> +       ctx->min_offload =3D ses->server->min_offload;
> +       ctx->retrans =3D ses->server->retrans;
>
>         /*
>          * This will be used for encoding/decoding user/domain/pw
> --
> 2.43.0
>
>

Looks good to me. These are low risk and I've validated that this
change works as a part of my multichannel test runs.

--=20
Regards,
Shyam
