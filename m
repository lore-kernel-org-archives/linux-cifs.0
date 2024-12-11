Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E00C2451CD
	for <linux-cifs@vger.kernel.org>; Wed, 11 Dec 2024 02:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733885214; cv=none; b=o7qABPgOC60dpuUirle5w7ZUDXRQ/MiNigLXsJm25bfalSoX51wYWvo317zds2JaxLPbcfP3U2+Fer69zbSLQvK+BcY3kYWydjAhVBdUz0poI3bJWOQqC8wgn09qiqjHWpBSXxgAeZDOY5/BGIfuQWc05/3k2tjMS9Y3H+97jM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733885214; c=relaxed/simple;
	bh=W0/CiTqoplIUoWdk03axt5FDqqwxa1rZWbYMTfTfF6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JoG8cztaGw0L95PAMCEZZHgAvUn1KTNYcNCGHmWLRw8mX5JqnuJn03SsjuhfyoQibzt0L01H/0B2SgkV3uN5k/97OEPPM6YtilprdqGwv2vLueXOwgTpijUhjqu1hRgEO/TjFIB3HKdn6mVgV7b+MV410p/jgk7Ox3zkQ+e3CC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnbS/lxJ; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnbS/lxJ"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-540215984f0so2509740e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 18:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733885210; x=1734490010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fC606rPojEqVSVoqYhusQIVlu2EF9QA4VOCUFP3nI4w=;
        b=CnbS/lxJGSSkj2Jhlo00+kYnB8PWeOncc8gOJE9zmrp7vi5nhO+qR6DbANl35StOR2
         e2xaa0pACUqb/iIoGfHyU6TLemdkE16FOPh1ijHMk2wT6U8qTnfZZwjrAMmS94r2LWRG
         6anXdTuQ2TVGHGdvaZoTSH1SC0J7Xn5a0Gvblcx1zkL0Llh0gE3eoYoITOmZMmILeccD
         8MVyMSrS+DYUMMlmx9XB/Ykwh4sKrJ0IugMz9+pkAekR3rwpYt3mwUyCgKca8z3/JxzI
         AStF0HPEPkG1g93wRM+Gnj/g6Fb+NplMfgy3W1dXWnNGEkdbmP62Rw37baiTo06CIgDF
         1pKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733885211; x=1734490011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fC606rPojEqVSVoqYhusQIVlu2EF9QA4VOCUFP3nI4w=;
        b=YtaCPv1QiDn8ivPXDQLng4c85AbKiC/fTxPEAtZ25JY0Oxk307QTku9oByCV9iQg2d
         cqdN05m9Q4RCDny2/PNes3Lw9OBz4D1+plpVpENArb36HgnNnIrLB/XQWoixhqIFHF69
         1RajIwJuA6H2/ASteAXocwvejLKTwQCVbetkVT5PFCUHD4B2pCn3eTa2DVUCpxZelS6l
         iKSNIyAJViBm3v2FcJFIxkl8DvuNyHYQRjQ3qqnhUwcOgnBPq/Mq5TyaYiTfMU4EfB1q
         MlC9TRkDarhERyr8SwGHC2EH3MHpdr3xRfhckh44BOREYuRYZuMC0YKj+CXGXfFnaTBJ
         Au7g==
X-Gm-Message-State: AOJu0YyIse6r7NB3SC4NOSNNJQKlMeP9+ST0Z+cobp/Q1fYjNuhlV/qL
	/RySmKRQij+hcovG7JNmjTwlztdqnxXZj0ZU50e0fGY59rUfEnZ4ut77CfGEypZ5RVDFwNpq+1t
	R2LYkvKjUnYCsJOY5sQEjLlBHAAI=
X-Gm-Gg: ASbGnctFuYH4pN+NEBMWwKeimoT7AFWT0lfPQ3LY7F3KGIcEE1i+G9GyV7vuDd6IQPO
	QGwohiS8e5QsCGwxngWth9wTgJMx9VkjC9XDIJZSZ8xXEE/pl/jAmPt0ZLzA2YCkjfvQaHw==
X-Google-Smtp-Source: AGHT+IFQ7HKvm86txHiNrbEkfC7eZy7WMf+bX+DX+DXtHKexRaDIJGZDQoqqhjnuqeVRpma11wzEyRsNXcJT8OeyiFQ=
X-Received: by 2002:a05:6512:3f12:b0:53e:f507:3801 with SMTP id
 2adb3069b0e04-5402a60be14mr286636e87.48.1733885210360; Tue, 10 Dec 2024
 18:46:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241210132148.2935-1-ematsumiya@suse.de>
In-Reply-To: <20241210132148.2935-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Dec 2024 20:46:39 -0600
Message-ID: <CAH2r5mv25sn_fVLjbRtk_mY66OT+iDEfo12HvMX8uh1o66PutQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: destroy cfid_put_wq on module exit
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.  added Cc: stable and merged into cifs-2.6.git

On Tue, Dec 10, 2024 at 7:24=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cifsfs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index c9f9b6e97964..9d96b833015c 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -2043,6 +2043,7 @@ exit_cifs(void)
>         destroy_workqueue(decrypt_wq);
>         destroy_workqueue(fileinfo_put_wq);
>         destroy_workqueue(serverclose_wq);
> +       destroy_workqueue(cfid_put_wq);
>         destroy_workqueue(cifsiod_wq);
>         cifs_proc_clean();
>  }
> --
> 2.43.0
>


--=20
Thanks,

Steve
