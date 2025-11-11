Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BDC36656D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762877042; cv=none; b=SbySuSFgnZrQ20OVfbAr2DXDKINmVrGuaga8t2kjr4lAiFGQ+Qo2bf3w38ummXLh4K3AyM+F9K2DmdpDDGsA0Tbn4UXEGmjk2jU59oUiB5nrNCdEIAH7tIt2bFyWhxAhanhhgClVYakMMxN6VUMtO6+RQFlpyZjn2OlsKOytVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762877042; c=relaxed/simple;
	bh=IqSj1pjWkOxz8XdpRQAu1uWC/z8Cx/Uyiq/kF6bkn2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WFdI1dvdt4fpm7h1laTXE4grPQDAsRfSSpYP0WTGwuft1w9wI8XguV+VBVIX0zm7bWFCGkmnS8RyZuSJ/EAnewFALyfuj2YfDRzAhYHa4YSeR/Gcd6o7bHJbRlI7ja2VWd/MY/nRjQGB91LyRFIKDGFhy8Yp32B7E0jiZD2KQJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOFdNtAR; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOFdNtAR"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88044caaa3eso44244396d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 08:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762877040; x=1763481840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p22dqnTP+WT7LTzsUQpMYPFrvPg4fKs8whrEeV7I6/k=;
        b=XOFdNtARQuUZYTaSY1j+/x+r8jPV0QmDjFvPOBeGDp3gwW17Ve9lla8i6FcQPY9Fhf
         HKFl6qxPd/PH1X/fSTDS96FIxnQQnQ0yF6+DI4hpMskFCKkFywsZRe9J6CBaR78nitxA
         NnUDgU+nqwq9OAPLWAj5cx/QKl3X9CcxXE7w3M8uFiIyx8HM7gtz+gfJGdS1lyai6Gqj
         JtCiROn8lo+9wSLn5riA2ey86kDFgI9AfC+PmOGeA/rb1SWuhEFGltLtDiEi11+4PMug
         JQkwIrYw8l6AoJB4aP7/TCA8OMuxT0M5/9J0DbaTbOgEy3CbKlkv3X2/HySVqT/dXjKB
         D+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762877040; x=1763481840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p22dqnTP+WT7LTzsUQpMYPFrvPg4fKs8whrEeV7I6/k=;
        b=h79fGA1kS5r1QEh1yKkLV1xqVTxc5wfAisboyjGP9wFsq5iaAlHSgCWJJxy1M8vKWX
         /eDtECkrjpoDQwbqhriEQmQxep2M5sUMAeHUoNDHx343aH6Rr5UoNBfwpX+H5DNayCRL
         lJHlCRzm7+1Aza3Wz2yyBLX1xEM3k0PkJdY8FycM9KXB739kFfdwUq+T7eACukF4xO1n
         Ji8/IMomQ6i7lAIFDia2IoWGQ9ndYwzgMJOSrdf7fiw2JVorOYJUB7z2xFBZ6cecVWq9
         uAOElhm3LCNj3DFWJMKHOSzOZ0QmsrxYEbCj0Ln1bDg/yDHxI4VPe2twYG50j3euqZPr
         kE5g==
X-Forwarded-Encrypted: i=1; AJvYcCXRYIp23uWfZpDOmWrvftSgBEg4brLlJggMWwcbRGL1Vw8aVH+GMnKOYitzzVakS1+SxXha1K0v4MOI@vger.kernel.org
X-Gm-Message-State: AOJu0YyXOleR+AHafIx0o5iR3UQe98v0JBrF8Ll0g6NQ+p2st2jq1dnL
	ILq3vZj1eQ33Oot4T6LKTef4a5hc1R61Ki0NUbhK0kJ4vZyu78Gap6tyVN7+Ni+rnGGyGCdO7F1
	0nqr/1ErAUehz/Ki/r1/Marm19DgZDkU=
X-Gm-Gg: ASbGncvz68IEt7Iz8g0Rcus5uHtM+S2YcyXbiDjWelXoruJAYzRi1Td71giCQwlI/+r
	RrC7dTJQuBchUTNjWVNI7z5rs8WpCehUpKKkfDSUPRHT4O9ievtauF1r+fZwntfJO4a5ERFbNHX
	aktMpXKDhLNDdfkMesbkZmcYYxovYQeTJoJTpp2U6TH/bwzWZQqOMoCNtMqs/x4TN0I66v0JHtJ
	/tdV/Dll79F78pbh9MSs6HfI0hYv4N0RsGrEG7fGPm+zGtGiJ7IGZJWiAQBiBCbKNT+A3wZOmKw
	9BE29z1+EDBV1g6tZMDFTu0hv8nxaUAIxR/hTw9fBygX52veAeXdgQXvZvniP2CWUfBeo/QvaRN
	92gRLlEbD/wg7c3YoC2ffDwA432lDA6rMGhGW58IWdqa4kApOLb7C+nHkElMK9XRMAq16yxFIAp
	MLzVQnQnO2o/5LU2gmmq0=
X-Google-Smtp-Source: AGHT+IGbI2y8BO4zXLUCfMUPsmSUaVvSwPP3A7OqUwFX0uRSKtOhi6kkDFDcw0Vnhb7AgoDQJVNEyWKQqIxY52glLdk=
X-Received: by 2002:a05:6214:3010:b0:87f:fb2e:9991 with SMTP id
 6a1803df08f44-882385cfb7dmr212493586d6.6.1762877039610; Tue, 11 Nov 2025
 08:03:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111070539.1558765-1-sunyiqixm@gmail.com>
In-Reply-To: <20251111070539.1558765-1-sunyiqixm@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 11 Nov 2025 10:03:47 -0600
X-Gm-Features: AWmQ_bnWa6CPOjA90RODWVbZ9Ca-j58oVz0SxlTOoe6a2Jum9heLBu_4Q52omkc
Message-ID: <CAH2r5msGsFW0GBrZpt1odmn8yXMbORMCHWTnD2xGOhG6GpWoLA@mail.gmail.com>
Subject: Re: [PATCH] smb: fix invalid username check in smb3_fs_context_parse_param()
To: Yiqi Sun <sunyiqixm@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively applied to for-next pending review and testing

On Tue, Nov 11, 2025 at 1:19=E2=80=AFAM Yiqi Sun <sunyiqixm@gmail.com> wrot=
e:
>
> Since the maximum return value of strnlen(..., CIFS_MAX_USERNAME_LEN)
> is CIFS_MAX_USERNAME_LEN, length check in smb3_fs_context_parse_param()
> is always FALSE and invalid.
>
> Fix the comparison in if statement.
>
> Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
> ---
>  fs/smb/client/fs_context.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 59ccc2229ab3..d2cf1f60416a 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1470,7 +1470,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                         break;
>                 }
>
> -               if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
> +               if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) =3D=3D
>                     CIFS_MAX_USERNAME_LEN) {
>                         pr_warn("username too long\n");
>                         goto cifs_parse_mount_err;
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
