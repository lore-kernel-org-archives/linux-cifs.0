Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CA878F59
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 00:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776818084; cv=pass; b=uIF+qLf18fJk/+DozCrcQqHlFfsIqcT9UUI9xiSoUb3xCIdc6NfCBZB41xL5yBtIyKQhCGvawAtwBY6wyeuheEuTqYNNROKt4uPHadFTL/Zsi5+ecgTsQnDO05xqXu5QuJn28VjXBOO3i9oIJU4H/YqhiahaDiSGc5D2sW5wZQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776818084; c=relaxed/simple;
	bh=T84rhfPfPMeah91DmNMcVpdACGkTJ2yeF29RqqlRsy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHoIqJsCC27OSg25iyymP/5Mw7U8s2wztYdYXebLNjWFzeIHZEUSGOD0p4Rd2KLzMjWWyc8OLeTpzHwehQyedG1hzX8NOqv4reWvofO4FmEc2p2l3PqR/xakv8FpDJJxjHE12nkBbKgmLKu6fx8IC5Kf/EXAT4+WSOdmAp73gBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qw7E45Ht; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qw7E45Ht"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8a151012558so53337256d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 17:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776818081; cv=none;
        d=google.com; s=arc-20240605;
        b=eoA4BuRjEc51IO4xSrf7dhc/e07GRHtphbQ2+enlAdWXkfxcPzgHo3tSRenVhWCuGC
         NNbKuN2GWI8ZZ1X3xPiPa6IP9hQ3uVX/76EG+Y5BLvPgJ2pial4rmXqLEruhXS42WPkx
         ZoGY47vCZy6Jf5G5s3OrDPOrHWRqMKZYCwpBVi4fSS9EL7dI+d2KTcgvPh3hrc1oS+Mn
         QSXsgH8W63gskQANhDKYhE1/17EY4CHHVZkKb+YR8snZH2H8a06awJU+IKK3s2uNrJgz
         VXigpmUCMipjT2uj4tFm4oauRaaWqgiZbBB3YNGBJ2j0xC79pg9NESa8py6A3PoVGKoi
         4IOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a7iWeGavKHIUeJfUfxgN0PlXjETm2sJfoROjkDRTKyA=;
        fh=+PRw39Iu0HZ3NnRj3bVR0DjPb5udgjZELhPbFY6cEpY=;
        b=gNG37zpaCZ4M8JFZO9fV2oNi3EZWvZ8gePSEh3Pn0P6AJj+vFn5Hj4rjPmBfKumsqE
         OBnzMTsbktlD7q2hOBJcOivmO0PAe7QtTHs+fmQfhAsPveIHx0vSdQlpMSXewf21cpeT
         odyho5zSfy0j+suvchNIhpjPK6xPGK/c+KUD03FIO2AuazrP4nSNGcwHF1hD+3V6vkOA
         u+FxxEGAEMCpDcQSkpQ6GadCGRKuEsiFM2IysTNcs7Su2EUL2kSQucU/BNWz6zWjii4J
         uBMIdimx8yn6K9wpsbSTxea7sT1zSc4lLgvydB/Lc5XGTLxdUQXKTtaaIFQaFX8lSKFX
         M52w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776818081; x=1777422881; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7iWeGavKHIUeJfUfxgN0PlXjETm2sJfoROjkDRTKyA=;
        b=qw7E45Ht+TljLSei1ayt2jvHMklswSIUvLH1+Gkws2gaUZ0gEhfCatecQ3YtwTZTPH
         5cnPZOhf2hdM4bTOgq3FP2DVOW8asqpUIKc1Opcw3uODQMGmu0AjhYs2swcd4L9YgXXU
         DadQ1zSAtqhZLORzfoZ68Eme9Cd+/qcHFEnIeIQO8iOxodo+DCOMFOQ1q5mXA7hhi/aD
         ZwSPVyXVEddDuJFi0u4T74hC6kwOI+KZgSkNFQk+LcT7QxFhJ+FVdoJZEq2Xuqmvwexo
         /PILoqdCKcALInnLfnUTVvgdBjgnDz6GUVUqIHBwrzfEQ9niYSEgvGDz3009fsen7BJI
         k8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776818081; x=1777422881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a7iWeGavKHIUeJfUfxgN0PlXjETm2sJfoROjkDRTKyA=;
        b=RQx2Q4EGhjspYvaV11pQVXF3nEp37pAo1ykEw9VBXJbofJ2NfXor/AkZsv5S+umnKK
         mCUQajNpWdXOBy5DxEE2j6HNAMpMoY3ksk7+PONmw1IREqutXAjAK1t12OizsHYozY3g
         U5wcKI3LoL+aM+gBxTuxbWibNSIqk46Lwinu6FwXtY8gv5VZtt6VOWqlGwtbbdHCxINb
         vKhCXfdr/TFLjzWknxvzzaa14tfS73A8lBLLcJNNCE4AslC9KJq33vTDG6TNCF/nvVyG
         8ycalikC/zebQsWZzZHPUlhQ7TLT+JQna/nZhU+O1SCAw+8my8843UKG6OPo5Xt6mFv9
         i6OA==
X-Gm-Message-State: AOJu0Yz4gGNW7KH9kHOQSBJB7EZr2ms5XO1mZU6ibbmJBjmyQu/zdnJV
	KiOIRlw02iEN7xlT37xPu3jZsJKdfkgrVq7DnE9S4dPW2Io+GQA6S0UNyJXLq8AlbKrBzI4LLlA
	YzZvSTVvnq6Teajm+4CWVYkrBxwswRUU=
X-Gm-Gg: AeBDievjB3eb3ZNS8HS+mO62IoCwMM92pnaLl21r5zoT+uGn5qJZ1aXvyHFntueyGfI
	NpmjPY6TGMtyiP9lu2WxW89Ky7qh3CIYBGOtG4gA4DHNkq5qFfwwPGiF3zSHvVsyJOWIbGriYtq
	Srkol38q9q68TR2D9OEhQLHbvmxGQGMYoU9MQeYlMmD50+EOQ5yCwaNuVCL7rrfPqxQB51VF+7/
	dJJ6MOBqJ+iNtkaUw3B6oZzB3Bb+nL1PGCiZ7SY/uKwhBu+OKeUPZWdKOQeG96p0GGBo96Bvb0z
	fq/RJ9Sj+GbrZCem4Fogon0iQz6PtmRJocFcGqfXW+TVAkPLkFNBfvMpa14Lw7349RAZs6CGCgs
	QUt8lHVR09se8csj8er5iK+aYOdCs0x+ydi8/dH2Z1cWbgx5zv0L7qF83bbd+RzsG4PnaEnlkDw
	==
X-Received: by 2002:a05:6214:27c3:b0:8a1:3ba4:9832 with SMTP id
 6a1803df08f44-8b028055b1emr324001396d6.16.1776818081568; Tue, 21 Apr 2026
 17:34:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421190619.1396589-1-mmakassikis@freebox.fr>
In-Reply-To: <20260421190619.1396589-1-mmakassikis@freebox.fr>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Apr 2026 19:34:30 -0500
X-Gm-Features: AQROBzDROgFbeYiT5KLwQHfB3p1ZZt3-GH95yDZxdZQVXyCv76Tgc1nOJpmiH1U
Message-ID: <CAH2r5mu+kn7qDq4_y6PFYsgAPwUE9WuAjNU_-4Z8Ot6s9WkCQQ@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: stop sending fake security descriptors
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch generates a build warning

smb2pdu.c: In function =E2=80=98smb2_get_info_sec=E2=80=99:
smb2pdu.c:5817:1: warning: label =E2=80=98iov_pin=E2=80=99 defined but not =
used [-Wunused-label]
 5817 | iov_pin:
      | ^~~~~~~

The patch removes the use of that label
...
-               secdesclen =3D sizeof(struct smb_ntsd);
-               goto iov_pin;
+               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
+               return -EINVAL;
        }

On Tue, Apr 21, 2026 at 2:06=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
> the requested information is not supported.
>
> the code is currently wrong, as DACL_PROTECTED is set in the type field,
> but there is no DACL is present.
>
> instead of faking a security, report a STATUS_NOT_SUPPORTED error.
>
> this seems to fix a "Error 0x80090006: Invalid Signature" on file
> transfers with Windows 11 clients (25H2, build 26200.8246).
>
> capturing traffic shows that the client is sending a GET_INFO/SEC_INFO
> request, with the additional_info field set to 0x20
> (ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
> (with only SELF_RELATIVE set) does not fix the error.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/smb2pdu.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index ee32e61b6d3c..6622efdd55e3 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5745,20 +5745,8 @@ static int smb2_get_info_sec(struct ksmbd_work *wo=
rk,
>                 ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
>                        addition_info);
>
> -               pntsd =3D kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
> -                               KSMBD_DEFAULT_GFP);
> -               if (!pntsd)
> -                       return -ENOMEM;
> -
> -               pntsd->revision =3D cpu_to_le16(1);
> -               pntsd->type =3D cpu_to_le16(SELF_RELATIVE | DACL_PROTECTE=
D);
> -               pntsd->osidoffset =3D 0;
> -               pntsd->gsidoffset =3D 0;
> -               pntsd->sacloffset =3D 0;
> -               pntsd->dacloffset =3D 0;
> -
> -               secdesclen =3D sizeof(struct smb_ntsd);
> -               goto iov_pin;
> +               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
> +               return -EINVAL;
>         }
>
>         if (work->next_smb2_rcv_hdr_off) {
> --
> 2.51.1
>


--=20
Thanks,

Steve
