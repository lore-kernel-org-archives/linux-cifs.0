Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A071FC0F0
	for <linux-cifs@vger.kernel.org>; Tue, 17 Jun 2025 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750158314; cv=none; b=H5v/ty1aGKXPNwXPENoVRmuSA67v2mfDnO5BTJi5WRU9CukmyyVN7d5TxZqmdz37lqDIQ2T+6wRTItpAEZvOIU+/JiuJ3p6Dg7F74IoWux3J5blxooLXBRoCpw91lhqKah4xTVrCV3+uVEFXrAJ9HS19SLxse+F/rsUx2BvtfSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750158314; c=relaxed/simple;
	bh=5kIKMpqcNlABohjlDP+xOmd4LsKG1TbBvsNOissh7sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZfZWHBRnwnH4pT2P+4on5Id9iy6tnh03/Hb03vay+8rFmIhsJbBqwh4J54VMUZn07fZvagYAs2k1JMZ10H8o/6n084z79n3024g32km1EWCx7o29KGy4qDLmFfezkgQpnZiJ8RNOP5RxCI2ymJwym562DlP5HIyjWS+J9XtPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcGlAIIf; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcGlAIIf"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-606b6dbe316so11679353a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jun 2025 04:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750158311; x=1750763111; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3rBZCJNePUHW031fNrAegLXQS8pJ3X0u5RnIk4tcoQ=;
        b=LcGlAIIfnntceprhTs1M2EPx515skjj2P7eKDZwHCGdJvzfAtqZm+kNN0fO+hDL1sM
         51CjGsND1g3AhhMH1yf3JnsNI/MaZzJCvrRJBqoM8cKiEjcGo0j+pjGex84b4zwCILQP
         8s6q6Au6azKfWdSauGEmDqZpeo90WflzBsSRBRfMS3SXoqgGyEKh/T5Zhw7+YV9YJtRe
         dMM1Z+YFXV3AMEIDg9lhXkZ4Keg/CwXrSscSSXNKVZZOIu3PiuhQ+cApGQfK03o21cHw
         M4BfIeaUHKTlcw0eUsJzzMr20ZvXqQxIBuxuWT1q4bJCCy7C6teXz9leBM2TDWcYiDl+
         h/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750158311; x=1750763111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3rBZCJNePUHW031fNrAegLXQS8pJ3X0u5RnIk4tcoQ=;
        b=bU/+ZTgoGXpHrR1fXqwTodRQo1KCerIOTDawDAgWM/5t8lpprk3CIeR+N8JFLNfX7N
         J+EasDM0wJ+LQgdmV7UbSHjyZfxi8j6ZouGpWYURCFBnPiP5i+DoXNE1Pm5eCJA91+tu
         Uhx4CeRsOf1WBMp/oe2Gb5QMWyMWzYvCbO/3MOmNjMUmC0/JjYA0VUhgAZenxxBjoGVs
         LoBWv9jHOMoRrNG4oVrTs8kEiDeiWdanRjlKoW+/whUKDF8mofw/B744+lkRQyNtZ6D6
         pNdOIB6Y6EMaXflwhNgDYxaYiwXhatnMp7K9dEzPLxx5T/68NMd5Nzib6CTC7VAIRWgg
         T0FA==
X-Gm-Message-State: AOJu0Yx2pOas/RGt3y1xZgtSmasr/r+AF4xdkcpqYv+iMQ11fxlGl4tq
	IrIffonCgG5rO6vCZ8oiCec+sCl9CYetOPQErXYABJBhkIUX9HbTmcC8vGLNSz0KOVhG8jueVpp
	bV0968oTg2LQ5lPM70MMBS8Dp+7zBZHm6Wi71
X-Gm-Gg: ASbGncsjhJI2RNTrUR4DEnrThQ+Neh1T/aMAiG1/zMuxGCoyorVgCd15PSSUcKFu7Ni
	QWz9ifNWd8NirSKSykyhBSfNhlqdziiFVHjmvPwhf7Su+ZSxUhyxL+OWL3qK81lS6vBzh5u1b9F
	mexrJN14MMLvLH6SijbVLI6lXSB/UvrF2ddNn6x13hyjJXmA0Jw+kW
X-Google-Smtp-Source: AGHT+IFOn3UrsH4gaDWUEsgiCspcp0lQ/w10XN7o0PbmIV/Pbjbj4Em+2zXuNUaMqd08qUbMhmMuqcAj3rTF9rgMsvM=
X-Received: by 2002:a05:6402:1eca:b0:607:f5ce:4c01 with SMTP id
 4fb4d7f45d1cf-608d085345dmr12945427a12.3.1750158311083; Tue, 17 Jun 2025
 04:05:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317102727.176918-1-bharathsm@microsoft.com> <20250317102727.176918-3-bharathsm@microsoft.com>
In-Reply-To: <20250317102727.176918-3-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 17 Jun 2025 16:34:59 +0530
X-Gm-Features: AX0GCFu0QZECaoBikvulT5AW4wjqCsC5BacCchJ_U3A7drDwJPRr31me6tET0i0
Message-ID: <CANT5p=pmsUx8FGxZARcOdWXCVQo5V6zZV8k5pn7AZPt+6bGj9A@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: fix secondary channel creation issue with
 kerberos by populating hostname when adding channels
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, sprasad@microsoft.com, 
	pc@manguebit.com, Bharath SM <bharathsm@microsoft.com>, xfuren <xfuren@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 4:04=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> When mounting a share with kerberos authentication with multichannel
> support, share mounts correctly, but fails to create secondary
> channels. This occurs because the hostname is not populated when
> adding the channels. The hostname is necessary for the userspace
> cifs.upcall program to retrieve the required credentials and pass
> it back to kernel, without hostname secondary channels fails
> establish.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> Reported-by: xfuren <xfuren@gmail.com>
> Link: https://bugzilla.samba.org/show_bug.cgi?id=3D15824
> ---
>  fs/smb/client/sess.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index b45b46b1b792..f2ab8513c3ed 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -494,8 +494,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>         ctx->domainauto =3D ses->domainAuto;
>         ctx->domainname =3D ses->domainName;
>
> -       /* no hostname for extra channels */
> -       ctx->server_hostname =3D "";
> +       ctx->server_hostname =3D ses->server->hostname;
>
>         ctx->username =3D ses->user_name;
>         ctx->password =3D ses->password;
> --
> 2.43.0
>
>
Looks good to me.
This one depends on one of the patches I submitted recently:
"cifs: dns resolution is needed only for primary channel"

--=20
Regards,
Shyam
