Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F8B3C0602
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252090; cv=pass; b=CFduDAMLmPUeIncDrY+4vvNvcNOuAdNa2vYYn+7l6xagoTzo0XCM6Ca5AufWCGAIRARd+mZxROGeWhp04ABMDDPjml1KGfQuYY1HPbvhgkEuAcltqKDpyS/CmDBgOK1ZAyJv+tfPUjBM3RhcacE8Zy1K6DOzL1GTY0X/3bohijY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252090; c=relaxed/simple;
	bh=Pm1yJnATyFiIvMSxiCbHh2UJX40kGMCmkLF7Y/R1OHo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dK0dQe5+xxdG5fqgjmnOUbP1VqggoznBU3f1qV3bFfFqzq+CfUXQJtQi6ZjmvDKAVHOrRqhQmRGQ3KdQoH4w7qEyIfKBycw6qrcvapZHlc87/DcRcfJE6FZyKfhQSE0bLHRSSrOOMZPPaZopAfFZWoEHqJ0mR6ri6Q7i6UXUnwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5WmK0dF; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5WmK0dF"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-488b3fd8d0dso235059b6e.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 15:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782252088; cv=none;
        d=google.com; s=arc-20240605;
        b=VFUzuNzf9+SgaCGTsGwqiaM2oDCXIu5z3448MWVem3imroRiz+IHSuksEumEkrK4TH
         9Zi0JGKV1LfpCOJC3v22UjpyYNwSP4OJTIc5Pl7vgo+GDAkEzDLfvI3K3fZ7vs3XAig8
         Kq7oeXkq/Xr0SdbRsUOzkeFAIBcmWhWKPowynwQvSdoO1xXaPtJ8fGhJRHTqRyeQOL/G
         IjnryyzdVAPbdGJ1VuQC6r7br5ESp6R8c45X7he6aMD0U2Hs9F9wArU1OjMa+eTndqk4
         tqgQrgPQyKjcluNtE9abUci3XOwYAD0uCzyQLWa+qyupUwipNOYstHsh0TW40fHI4zBm
         LsGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dtDFRvrG1+EC97yQOEMKqneeBmsl8TlWmiO0u8Cavlg=;
        fh=OmUezSkIuB/Hln41PkS90rN5zykW4fCP56e4eNnCc6I=;
        b=FST1M/Kp5X+GA4oq8E5n0S+0ZtfUMMfOf/jfeBQ+7IzFNgexapd0yamQPlPaKi4hoX
         oFOKVGFkJWiqqluHvz4A4fCBMIMBRfHumV90LWykacwaStpzCB1lW0Aao5TC49mxiOvk
         MgS36eUCSaja+9jN94eAXZZJz/Lb1uJ7bkvFwzoI8YJdjMaDOaB8994bLkDgDNjXSr/c
         ljdFE3Wm3S7ZrlleCKuSjhcqDT8TjGlFQqDkHU5B+NDhrHZki4851GqFMkKCwj1TWrrd
         T1o8RcaWiOUJiQdhQM2BHxECHkeAlSAT/KuYHFeTPsgJc0uwheXBLl4Ewwb0yy1Q861I
         xO9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782252088; x=1782856888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtDFRvrG1+EC97yQOEMKqneeBmsl8TlWmiO0u8Cavlg=;
        b=k5WmK0dF7/XkB1h3fKV5VvyGx5b/im/M32H7vjF/xeKxtv91cPoJJ+nJIhlcMsv/m5
         nqencLWOlxZ40z6NU0/lqhMn20LVP1r3zuhahjVyzUYC04qmHipFfK5jSxn3hNXYKbNw
         ltMutaAIqgEhCwD6ZtbmePeV35Y7wOrMCx47vWTUgNqqa2pYCOpWiCaKLndkX3wKK9Ay
         GB83I/CJ0chh+o2MJHoqMrzYKHHcke37B7QPoHjYmlsW9VYcCGPxZUnFINKr1cwrYox0
         igyNxh69hZAZ+BLnofocNz/TLbr+DM/60aj1OZCPE4olZdtY4/mxDU7do+sTIKji4Hjq
         eWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782252088; x=1782856888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dtDFRvrG1+EC97yQOEMKqneeBmsl8TlWmiO0u8Cavlg=;
        b=rRTB7VISJAL0q6rhgrDxJw/Q1VcMIENNytQAKFvHgEu6rHFJf7488Wix1HxDHS4wKK
         563MUoBmjUVZW+TpAA/2duT2TdynqKI6nihb8C/SqyKYjyl3GacAlC+uKY1WfOKH0YjG
         kwj1QeIBaJB7u5wub8YOfXKROqAr+YA6ZEBQZ7ykNV0T3WE0g6LAY9Y57kjBG/IktfMQ
         7gU7gDpgAN7I1GweMWN3z0wnyjeQ3pSKHH4PY8J/sN7dOLsh7fZZRMQg+yNREjsivtS9
         8Sv5omnEk2uwooXqrlYfdkGU2pWJNd59hR3ikaXtJb/hskGTRxuTwBj/KeqKl9fHtmWc
         xN1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8mfDeU5zRDDrjWSm7BSupP1FdZ1czGarMVLfvngEP99CLV6bSgPsjJy8qW8MzZVaRxG0meQMPk3vjU@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3DFWnWl90F33+Mph3JJNmOCy/FPlExYVb2hXiKW5R1/1P2RnH
	xPlGflgmnRgaZG2Zs9aCYQhKMe14I4w0ffb4ky6lp7jQQ3MYBeolXAylBnbQ0xmmoeXfhmtjurv
	gX8xGCmGrj6BfaJWPVAObCfO33O14mj8=
X-Gm-Gg: AfdE7cnTs2FNGW0qpZpIzeAsbr8ypVMGP00A0/+1UdDgSZo4N52aIojlrTGFlAxNrtL
	TJEEnMxeBPuR8m7ZkxddL7qrS/dHDWSfCAZedTIIMRXtNijUtjkGG3BYUE/cDXJrWIrstOCLp3E
	+ccnOs2uQ5Xl5fOB2leQqy3Hrv6GghhL+Q+kW+ZdnvrORQRSzPCVpBBb48YMQb61QLdrPUZna0d
	sWH9s45skCGE0w9zimztITzqSgKb+MmHuEmOaMOp1NNXtwwlFq4UQb8SQEKHZQcHtxxIP4MrIJC
	40j1GE2OuxvGuPLjcJLjh4KemGC9e9aFgzhKQoGs/I3lbf0Rq1A+hKbztOGTT0VnaCt6wtPw4R8
	FaC+UUHYYWA+BR11+JP3J5OETTYzErjWn6zON03JAejb8335UvFLqEgOB6woInPY2LDKgx8+4xM
	ixSJ4GYnkIWEQ=
X-Received: by 2002:a05:6808:1523:b0:489:5d8a:92fc with SMTP id
 5614622812f47-4907948f85emr532781b6e.28.1782252088173; Tue, 23 Jun 2026
 15:01:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623180620.373135-1-pc@manguebit.org>
In-Reply-To: <20260623180620.373135-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 17:01:15 -0500
X-Gm-Features: AVVi8CdqKQgNzwiEIwKFCy4XVKBIxO8Zk0MG2rc6vEbMkYruK-zzZWcm8D94jt8
Message-ID: <CAH2r5mvKj25T_5S4OA6ZWKuh+SipBLBd5cMeT_24sA8xhd3rDw@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: fix compiler warning with -Wvla
To: Paulo Alcantara <pc@manguebit.org>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FIxed one misleading comment and merged into cifs-utils and smb3-utils for-=
next

On Tue, Jun 23, 2026 at 1:06=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> The length value for @path array in get_uidgid() needs to be evaluated
> at compile time, so replace strlen() with sizeof() when defining
> PROC_PID_PATH_MAXLEN and then fix the following warning:
>
>  cifs.upcall.c: In function =E2=80=98get_uidgid=E2=80=99:
>  cifs.upcall.c:1400:9: warning: ISO C90 forbids array =E2=80=98path=E2=80=
=99 whose size
>  cannot be evaluated [-Wvla]
>   1400 |         char path[PROC_PID_PATH_MAXLEN] =3D {}, buf[256];
>        |         ^~~~
>
> Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Enzo Matsumiya <ematsumiya@suse.de>
> Cc: linux-cifs@vger.kernel.org
> ---
>  cifs.upcall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 01690dfcade1..5bb3e6881491 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -1376,7 +1376,7 @@ static int ip_to_fqdn(const char *addrstr, char *ho=
st, size_t hostlen)
>  }
>
>  /* cover worst case/impossible scenarios, + 1 for NUL */
> -#define PROC_PID_PATH_MAXLEN   ((int)strlen("/proc/2147483647/status") +=
 1)
> +#define PROC_PID_PATH_MAXLEN   ((int)sizeof("/proc/2147483647/status"))
>  /* max valid UID/GID is (UINT_MAX - 1) */
>  #define INVALID_UIDGID         UINT_MAX
>
> --
> 2.54.0
>


--=20
Thanks,

Steve
