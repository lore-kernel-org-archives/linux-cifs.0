Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A4530E830
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750412221; cv=none; b=mzLTa9wpPYRLQ5sMnufrDW9gjzmrGG/BfcWlFocm3mW6aDJJZUVf1rcebAev/HOQmqiTVtFNMRKIAy0D5Qj7BZkWsPCaeOcyx9O8q82enOEVeDABYZEm6wzR/EV5B0Wp1CC+j7rp2lrWOSxr/kIl8n1+zL8LRd92yLUhK+rWxII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750412221; c=relaxed/simple;
	bh=I+hTaDP+GB7fD14ghcC7gr+oxjYblsuXnMij3HlJu0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rK8btjT4BDzOxRZMsym/ZSVY62ZpaRvw0Ql3c4Qy7fbzK88kJ1qQSjKRITfQbbgZA2aciIHO87AaU90zu7YPtchpJKneJejkrAov6/QSzv+bXdyxzZ7ZwVyEaaxYA5vAi6cOlF1BANmh61MKvwIA7YIH13axryQU/M1xvFLmt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8Na7eZ5; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8Na7eZ5"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60780d74bbaso2906776a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 02:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750412218; x=1751017018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jp2+aJbKJueEvL+spLo2e6YmX/AqKMc1WMXFZyDKo/M=;
        b=X8Na7eZ5LlvKP3YVN7p94VNnuYGwQjPiAkgWbesc1jwr/B8Bzsi+vp+lpvnIGkK/Pe
         hcYNcA0Nxd+oWKB1jGN2ozaIr+ZPMsRYI6rmYD1YYdd+FLJOENQQRxMdTqfi2x+AGYDa
         ujWiLQQzI955IyNSEE5Mvp3qSYKFtc1GM4t3PcYHTKY3dYy1ZcfHsn5Tk8u8WTbu+Ip0
         GztqZH6j7m2NXzvu3la5uQgQP1uROIIroNN8+dn661s/0409CRgezQWNNmuCz4QMkEug
         M1/usXP2wUxu9yxgA6zkPICSY7EtOX0HLcHZ79rbnzO9RABTixi/sMpOjdGIaZeMQwiA
         CAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750412218; x=1751017018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jp2+aJbKJueEvL+spLo2e6YmX/AqKMc1WMXFZyDKo/M=;
        b=PYIzK9TqDUyzcBx4WVKz5wlXjTpRJnagB9Q1eFNruSwUPWZIy3TLe2Pei/3bzmboRm
         z3qUMR6SymO1ZQ4MbuUek6kB9McHZ1WpmwfYKAq0y55xn5gNZKmkZFQoE3G1xvkahqYk
         vu2SQ7HY8XQqvso6S89c+x9CapQhab84vfugDlWiOnmRUaRoMwfPl2TVSxa4PCnELgWt
         Xs+vfMULnSQIQPbg0mv9JGpIYCO5itypRxg0VU7AyMKqA++4WJcjVEraODlE/B3jAqtG
         KNGQSEhr0nvxBvUg9hGYKtTuSRbzskzM6imdVmXlrtiL6ofGpONdGZzJnfHlL33nD6oO
         S8vg==
X-Gm-Message-State: AOJu0YyYXB3LAV0MIFyAoWFkDYLLdCObJSwGpl8X5vBhDBIIuOj5nFS6
	plUXiF+YcNsflT4t1Mxy4Rf07wnBjJ6I9L8uS3vQooi34ctW79U7jUnwFe0th+KDl9bOfwsTGk1
	6/8h66sEkwC+SuUavGyuzHvpE0L3N/hQ=
X-Gm-Gg: ASbGncvFa6OO48i5YKTHzEJIFFeLL0zIJGmfpOU9sJhIrFPh6VdMXSunUYVi42ccSX1
	XwgSMmPUajf2KpWdmqdpQD2zcGHiqenWA7wGpMipuPEKJQKCBlX2pGviISGysyiF6cxgusdRvYG
	//OthGD0tnDHQfIEHRwDNfpB8wC4i5jgJzksm6xsN3qQ==
X-Google-Smtp-Source: AGHT+IGTM2SKbSwYUV4S+k9JwF0X2dtvBELzNc6mnJml2whnzzIiXjqlRgLSXCMEkeJf1Hdnx/MyPoCJrz6j6PPpoO8=
X-Received: by 2002:a05:6402:4305:b0:600:a694:7a23 with SMTP id
 4fb4d7f45d1cf-60a20958fd0mr1421109a12.0.1750412218236; Fri, 20 Jun 2025
 02:36:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com> <20250619153538.1600500-2-bharathsm@microsoft.com>
In-Reply-To: <20250619153538.1600500-2-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 20 Jun 2025 15:06:47 +0530
X-Gm-Features: AX0GCFvkfqELfG_NM0xdrsdfROzS1gydRetmOQy_82hfnBKHO27OAppTPO9pp88
Message-ID: <CANT5p=pDjDAbgtwLa5yB01dTN0LQXYk9V6xVYokUpSPVoSBPjw@mail.gmail.com>
Subject: Re: [PATCH 2/7] smb: minor fix to use sizeof to initialize
 flags_string buffer
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:06=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Replaced hardcoded length with sizeof(flags_string).
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index c0196be0e65f..3fdf75737d43 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -1105,7 +1105,7 @@ static ssize_t cifs_security_flags_proc_write(struc=
t file *file,
>         if ((count < 1) || (count > 11))
>                 return -EINVAL;
>
> -       memset(flags_string, 0, 12);
> +       memset(flags_string, 0, sizeof(flags_string));
>
>         if (copy_from_user(flags_string, buffer, count))
>                 return -EFAULT;
> --
> 2.43.0
>
>

Why not define the size of the flags_string as a constant too?

--=20
Regards,
Shyam
