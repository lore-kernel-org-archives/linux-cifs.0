Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E727E233722
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777728712; cv=pass; b=iIkopvFjkOHPfRwRSgSX99s/fWvzNjTutiPKRy4/Pa9NAlABTygD8itrDJN6tkr2yhctVNSVmGC0I4ul7beoIIhdaaNHZxuP2sohm62qxrjT+4XjdtP4mPaj0ZD1mF32XlvqHcs8FuajOsoB1EclTTZ3v48CeKUBZm+4Es9j+Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777728712; c=relaxed/simple;
	bh=pgccSiTk7cwpR918eHNO4Vz2jYqp1tuwAppiPbXW6rM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jwkgGucviQsbCFKsbjlBkRmzYlokwLh4rJNwcu/zrlj54fql9S/zPm3h0awlJ3eFn9ewtPUu+gmWHM1NYXsYD3ArVbsWg56+AS3srx5T08Uy7Vhk+VVa4rylyMEVsruzU0D8odq+BXtlMgBdTKiTcbgAolkWGnKK3v1lHpjBoDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qbkyD7XP; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qbkyD7XP"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8acb856a674so36320516d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 02 May 2026 06:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777728710; cv=none;
        d=google.com; s=arc-20240605;
        b=hUlA8pf4ow8EDjGQ/PGndvHup/ql4vSq+vO931hWSYKLYwMGKcrw+y51xUx/PRPBWJ
         9uRVvuCasTvN00OIG2fFidA/MTgMuwd4ghZfSUDFX6UJRnN8tcJZ/IwXivKNlUKUedbo
         ujmI2A4hwUpVFjfjrBEeebFeKQ1aaiWhFdVqBwN8i3txW4HzeOlDhKfRvq3ZgBK5/D4q
         g1DdrKhd7C4dQ97a/C8zPQ0KO7jQ3fZfyK8kOEzOCDzVEv+jw6nEfaC+KoJjt3C+ZjKP
         VB9WMdU/bq40YLX9ZSpp0+/fTg2GjpYEdDtm3iXiW1+V7R4Aqwl3ILnLpNmeFAH4KWk0
         LYIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hrz1mttDC61uI6sTdrN+XNGEUMww2d9RdTsgZTXNbkg=;
        fh=yjngr4Ur65yIztn1No1BGScYpyNFlBDtOVcCWWzCxY4=;
        b=LBzSI6eOKQTr3F7in344amenIH2mvOWl21PVbQjrqaSpVq9sYllih9vOfm0640owNU
         rdKGJAqYq1LL8AsS7yd/MwVU6isbdBAw7WFCJ49v7ubOnL+oKWKLFuPxbwm804+tpbgC
         3l5Upk9loDD6GdTa3gZKPFKGF1HkNcj+/BW5dsQ7h4dervG1u98Gj3q4kqrGzz+syO5J
         nxPjuwnlyw2vCr3M+Q09vvc0xBhwts3IjjG61VmjoopUVbAGOOVONibfGv4lCzvxO3oE
         BbiwNuORMos5N+82b+zTw14Y5xa6UonbAoALVEOrzkHtjzNx80JiwpUphF3ChrmjoilG
         ZZQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777728710; x=1778333510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hrz1mttDC61uI6sTdrN+XNGEUMww2d9RdTsgZTXNbkg=;
        b=qbkyD7XPoCk03zOijwy5/n4SVmcp77/JlJM8lrIxLPPpdLTmH2rwM1OF9gEEEZMBbv
         g5D1srBK8wU0K1qKE4OYTullwdsIB444AuqmH4fmt6MJeeyl9h1a5tETHBBDLpeUf2xq
         woX5gTTSCuxbl+wGpXZc5i383FPqPEXXcwSoBmh4wP8zPM0kFVEeT/415w5rVbw4NEYu
         9n7CXAWZGHpJJ6ja1fJswQHtkTDLt41I6qcmjyR5z6OaLOZ6ya3N+btz7tR93k/pePv0
         h+/RgR/GUxkcSUNSETLtIUzAfcbYcjCs7+QxkCIa88NjD228NdCnDEDL7xhH0Mj3IR+d
         Q/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777728710; x=1778333510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hrz1mttDC61uI6sTdrN+XNGEUMww2d9RdTsgZTXNbkg=;
        b=d8iCY/6/+hnIxVHkX5yRggvxPqcZb7wTtL8je0GfZ3qqNyF7sgjlhBDj6xCGPGOVfd
         1PAFBF+5tJ/rJxlxFmsD2sWSLutPP9LXkQk5ugXDKyr72kFFN0TTYzVnk6NwzfFwGwQc
         Kg5IsG/HLfDCq2Ur2qk0FgxhB6vAMuY0F6UogxyjyPH7PvmJxF7CrEnNu43OemPOdmpd
         c1t8bW43TY0QPj709MQpx6hcUcpVuJcYoEV5I8cefbvpin+iRSzMMlhhPh6ZHGDDh8mp
         eNyTmrSIvrFS0l3pO+OJL59nP74h/HdwZpUGTcCOe6OIrcu9+a3T+pgd9v9BIFGgKbG/
         eU/A==
X-Forwarded-Encrypted: i=1; AFNElJ/AQtpcuXvmpdv/+yOeFMFN/l8vN58MZitXgqb3Fw7Iecbk6o9OWP0fNDtSWQM4o7BlrxbZ81/WFPGZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzxLcEKj/6LPjNjSmbX2JcKaa4Tnk+MjQ/x52SwtGBzmL0iZZbr
	RiRoQX8093IF/OSiwnT0YyB6PMtwHfpO5OLHu5DxNExeBNvzFlYMCI8vYdsOOmbJMc5bR3H3DZ3
	WYgfz4v8pKv02bMkp9nEcNMw9mpqeCvA=
X-Gm-Gg: AeBDies6sjTumx7TjTCIgnsUZLAGc14U4v8A+JoyBrD1cjkyImL3Nijpil8/V8fjI+4
	Wgx51l9WLpwoOu3Jr07mBgtd2EpTh52Xe8rSnXuFeNwo6eUrp4ktHujUXD6UJgxv840kSOGT1DH
	cYov2b2LCxq4LM+M+BRh3fseRe8a6qADTTG3L2EnFx8WfwBXirTLkHeY7PqerRtsAQ//O+8SMe7
	DnxOIHG0ywiwadsJAlpi+ZAydb93pA9uupuck1LraraK6EsdtH+9cxkJEl1T7r4u0vgJs7XBYS7
	VOE1o3AZhdoqfkRcjqOSHzUPGDvKuDhpHSnqmyOIUwpvD1BeM0YSEb/3ZjnVmc8/R/CBv/St3sf
	BvBKn+qPCqzCwKrojvngGwTwKggeVv29cFB4AWEfZEBJn07vwAB5E5SZ3Kei6zex/iq8U/eY=
X-Received: by 2002:a05:6214:4c86:b0:89a:1c81:65a6 with SMTP id
 6a1803df08f44-8b668732e3fmr40217166d6.17.1777728709600; Sat, 02 May 2026
 06:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260502095435.2969835-1-zisenye@stu.xidian.edu.cn> <20260502104836.2980415-1-jasonye247@163.com>
In-Reply-To: <20260502104836.2980415-1-jasonye247@163.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 2 May 2026 08:31:38 -0500
X-Gm-Features: AVHnY4IA2OM7KepiFDCKXPMHG0pkdd0-xitH6I9Qe-pVWSU9I1aM70hKjPNlndg
Message-ID: <CAH2r5muMKoKagbZiezK5HpfYtD0Tva5auOhJoRjXtSaNNzyYpA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] smb/client: fix out-of-bounds read in symlink_data()
To: jasonye247@163.com
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@chenxiaosong.com, 
	gregkh@linuxfoundation.org, linux-cifs@vger.kernel.org, 
	Zisen Ye <zisenye@stu.xidian.edu.cn>, Stable@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Sat, May 2, 2026 at 5:50=E2=80=AFAM <jasonye247@163.com> wrote:
>
> From: Zisen Ye <zisenye@stu.xidian.edu.cn>
>
> Since smb2_check_message() returns success without length validation for
> the symlink error response, in symlink_data() it is possible for
> iov->iov_len to be smaller than sizeof(struct smb2_err_rsp). If the buffe=
r
> only contains the base SMB2 header (64 bytes), accessing
> err->ErrorContextCount (at offset 66) or err->ByteCount later in
> symlink_data() will cause an out-of-bounds read.
>
> Link: https://lore.kernel.org/linux-cifs/297d8d9b-adf7-42fd-a1c2-5b1f2300=
32bc@chenxiaosong.com/
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> Cc: Stable@vger.kernel.org
> Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2misc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 973fce3c959c..2a7355ce1a07 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -241,7 +241,8 @@ smb2_check_message(char *buf, unsigned int pdu_len, u=
nsigned int len,
>         if (len !=3D calc_len) {
>                 /* create failed on symlink */
>                 if (command =3D=3D SMB2_CREATE_HE &&
> -                   shdr->Status =3D=3D STATUS_STOPPED_ON_SYMLINK)
> +                   shdr->Status =3D=3D STATUS_STOPPED_ON_SYMLINK &&
> +                   len > calc_len)
>                         return 0;
>                 /* Windows 7 server returns 24 bytes more */
>                 if (calc_len + 24 =3D=3D len && command =3D=3D SMB2_OPLOC=
K_BREAK_HE)
> --
> 2.53.0
>


--=20
Thanks,

Steve
