Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C1723185E
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750412065; cv=none; b=EeuIw8hdRVcuymUuK0okJYpxM0m9qScFe4k8T5SDC/T2vZnsY1Q6UEIyVI71gh8I3T/OjD/cdVYdb+niDIOgeowIf9eaocxsy5ctjiKehngwTFs03/JTumD+LOwUYIW77BeJTG1SKn/NXGDbvD+yGtLjulIy3GKG52RAiJL4W2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750412065; c=relaxed/simple;
	bh=vNbZZxSpjpybWrLrYEWVZexE2pU7CLEA1MDWxe0wHQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5i0pfBcUfT3g6jWQ9VrooHqbmZ8B+ysLrEe2sMeoG9orOj49sZ/7iamJNE8nwjpFQ2VUpTex6Kk36lWBvzpfC10MVAZG5ka9P4YhV4BRs+OIR9YNZ++mw1sa4+Agopa+hiSZVhp/ugnSz0kUsb5eK3rOWHq/PPg/ugrogUVBxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3ar5Wm1; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3ar5Wm1"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6097b404f58so2859561a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 02:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750412062; x=1751016862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSF2qMlBvG4KnLxs963ibgBcKh3dtg4vJpAT9HIOFeA=;
        b=b3ar5Wm10Ds/jWWxIpjFAQ6O6jAQq5qTWNYjH8bx8Yhy8Rpy5zqhGiJYvfgRqlfdkk
         yDazK3Qff6GJF1ufCnupCP0jz5iQ55DhDFhpFGDHkCM7QC2OYJLm4ZMn+auL/tGMiQbz
         +GDQv9NtbKWhPuDes5rcLv0aJ9Xm5RuMxjlfZqTmfmhwPwDry7ODvzGMDRNj8GKsZAYw
         RMip5ZXaSUGvVyYi9uaPDFAvybnCRhwuW5FtddkLoumFCPu861y3b7lLuayEbObvIk9Z
         QFz2QBak5Rv4fTvFrxSYtR/kC6PvaYh+JSYVbNaBy02ncH3rkXPFfAl9LiFlz5ODpWTQ
         CDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750412062; x=1751016862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FSF2qMlBvG4KnLxs963ibgBcKh3dtg4vJpAT9HIOFeA=;
        b=BPKJ+mMujM+CSpwQwislCVa9zx2OVtl+DY35QV0Q1nEgD4gS/FLEHP35v6DMvxJQzA
         GWA4bvOO0O5YjQpk+nC6BgSf2pFvPWRD/+ZQ2E++DmkINxrM45u8CFD1Aw7CG3uyx7Mu
         FdPsnHHz+2Q8RO7Cng7Ty+40M0m66AK2RJ62WRiatAnriZ0SU1cEXcrpbJb18o48lTET
         Ptl5NNK09GlWA6tgyDkbSvHkNgYpKbpeRG0d7m42yXgmBBsGtk31S8hzZgpGGz5POBn5
         YCxrkfXOIWWmg55jbdR0BayH7sSYpZvEI7CtZOcNtWljechvT8XfzET5cY/HKHaHSNzv
         ChmA==
X-Gm-Message-State: AOJu0YyJaRtY5/arfAn4giGz9bR8OAEJWUT73JjvoLwjbtNzwInoDdjA
	rrx/dWCPNO0+0bs/W1OPZrfGTyCA9apEOdIyOzmHw8wpHP/Yy2veOubTfJR6plcxY/PNl3XjTF9
	0I+5FWlwGmWTeF+MHyphduf1EkB1Khu0=
X-Gm-Gg: ASbGncvCwTrsqqFuRTU/c6umPtZT84cwrjJoVFhkzHf8hf8Z42EPKgMVRw30rpe6oju
	0oxMXTV/5JC1lGZlj9KqGMc0D3d5sDvEP4jx6GsALPgKidkZPfx/rF/XNnW9x72YM0aoEfoF+kB
	4oys/macZVHF2ZUc0gYJOjt9XFOUbaet4DzDHRTaTNjw==
X-Google-Smtp-Source: AGHT+IFrRZhC1Rf0lwSPSll7Fc6TT9TAKEcApOS79yucVYrOzn9JGHVSYvklGPGO4nkLxsxXAh0p1PM/m4z4tSATlmc=
X-Received: by 2002:a05:6402:27d2:b0:609:b8f6:7e83 with SMTP id
 4fb4d7f45d1cf-60a1ccb423emr1882348a12.11.1750412062456; Fri, 20 Jun 2025
 02:34:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 20 Jun 2025 15:04:11 +0530
X-Gm-Features: AX0GCFs462POviojRjaGVzA9hAOcGDpMyqkgtvvUQheRvYVnGybaKI3Oe2WOiyM
Message-ID: <CANT5p=qHXoRb95FvAwxey7U2pQetV6iHswm0Brotn7Sj3YtOcg@mail.gmail.com>
Subject: Re: [PATCH 1/7] smb: Use loff_t for directory position in cached_dirents
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:26=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Change the pos field in struct cached_dirents from int to loff_t
> to support large directory offsets. This avoids overflow and
> matches kernel conventions for directory positions.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index bc8a812ff95f..a28f7cae3caa 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -26,7 +26,7 @@ struct cached_dirents {
>                             * open file instance.
>                             */
>         struct mutex de_mutex;
> -       int pos;                 /* Expected ctx->pos */
> +       loff_t pos;              /* Expected ctx->pos */
>         struct list_head entries;
>  };
>
> --
> 2.43.0
>
>
Looks good to me.

--=20
Regards,
Shyam
