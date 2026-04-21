Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDDD3D75D3
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776785204; cv=pass; b=Ovy1NOqBUnW3ZXQ1A7XsRUtSWdTbL//mqzv/dI3scMIQi/JHBMpApYEJmDPivUSgSWSNwO696/i0SbwSX9h8WZhdQFFtA4//gwJf/6JJ9peHQVRg/SqQWFQOUMIoWUpe8fbFfw7337SzGbirJSex+HnPZoP+lSdiHOZssNJChD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776785204; c=relaxed/simple;
	bh=yPHRahqtUOMV/Hb4WJF5/YBWLujURcb0PRjmy2lESXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Epz/i2t/VAOIAeL4yzMB4TFPSDw5fBMVmK4aBBzR7pQ9uNi3EwBv+eiv2p+HBc+GAegmUruN8x5IQd1KJjAmuxO1NP5loCiOgIQ77dOmjXySIKElvZgbrtoOFtOA8TmMIUuIpCbfR1mcbeKp1fAgs37sYGEZkwUDkPhH+WfwgjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AL8sndUb; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AL8sndUb"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-651c366f7efso4691293d50.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 08:26:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776785202; cv=none;
        d=google.com; s=arc-20240605;
        b=Z2SZO1otEhYRMJBZYaqNkFTatwDz9ABPS4WvbQSXEdK442SuBzkV6DYluYVATO+h2P
         9mJyVUEaLdQU3hdIXyWLNdgHO0/kuc4xNdlwsI7Ni5jTlSzfkcHPJLxUBMOJDfSzkOCI
         FjtORUBpdf5R1fGZrz5AWMtKAD1o3lrbK71tYo23BkVqJ/3aAN7hqFTTqX2Eo0/qlKvY
         KdSpxNR2AmDqeuGHl3QsJOIRkn3th8ztvV89p/+YT/wFTSPEOBr9ao90QIWG9sNzYajw
         DUZmeXjLlzi5mzrCxEtucBkYNOYgYMjnRiM8XAV4Ulz6rJVb8iIEVx/CYAEbkKbkb+8B
         2AsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gq4JGCjbD0peb76RqIvyQzPZR38TXeWbvqiNZavVYoE=;
        fh=6l+b+8TgNjskIbEdKAy7jNhDycv+isEey1OBJZGhKP0=;
        b=gGIsM4+9xFVEvJW7qXoHK/gYX4VPTwT5l8smXbZUr9LpM7Fyg4c/+dQPLeSDSYRZ5T
         HGXojnNt6Crb6jaexbhjFf6/kkCAcVag4UNseZPuzhMqw2+c1elu3kr/GSfSXWDgOkk1
         +uoFqA2bfXppFBnjYHJRBK6JXlxvv6n8G+HtA+XMPf/wSw6BSKL5umHGS85xjzGtY9Wg
         /7IVYN4Nhx2io/N6wWgVPMQYnFOHI7IhHd0nbhyN0/ZNzF5jGm6d6CjUlnsAQygids8U
         4K3I9GybrepXyIol2Qtpeckn7HZKljQ0SbYxrnZbJMqRSXygiUOP9ETje8ywtBcQz+fg
         XHaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776785202; x=1777390002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gq4JGCjbD0peb76RqIvyQzPZR38TXeWbvqiNZavVYoE=;
        b=AL8sndUbEqJnN4LtUsy2isXmtUjPFDsLa5TuM8Gors5ID7DiX+UGK9uQcVAQOLc5+L
         onW/sFTq0TQrFXRlGmisbruq7iwSUxVmW0azZ5JE1vrXHpTklGCpBqRSDFEW8LoFV/Wg
         nM9uFV30p9KCt1FYXLm4bXS+26lhUMjvEM2SNmvJNwwsc3w4HM+bFhPx9vCb3IPSyLhR
         We5pwxSPKgsaFxeYgprlJ2RKLMSxJvZMSyZSqJ65E2qNv7C4vdHVkOR0j+ckK61zqCgn
         B6jAE125sP8UneibGwCr/NezMLtVBUyrGe4hCEa46IH15Pc9ktqG5WQmFlxiCzS3wGj4
         cEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776785202; x=1777390002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gq4JGCjbD0peb76RqIvyQzPZR38TXeWbvqiNZavVYoE=;
        b=WQFD99M+7P5SCVUYYDqw/ykrgRQSsBL3UdNIF5vw+sGlpj/AUXYqkMeY9KHfPDLrB3
         oj4gPbbv4vcHo7FglIXoEE9fn/8m4WU6ucCWii41cAQdHYo6nWncmwvn6WKgZ9eGeW1k
         uhxnXcAu1NaCWWsUFlfBwp8L/jfOf8RuKQkKX1dcEUzZfxvWbS1EmEHIAapBFTpOogZt
         0Wai8/uJZFtm9ILr+hI7uWb8m6SaNNpH7+xmu27V97p/U1R5oJLm2NutOlM48lrMnQ78
         YyNgMs/YGBBUuFChznXYPIYYu7c1yfQLT4bvCjpMYFCPKy4FvJTBAnqiXrdeBuS/jpFP
         HgPA==
X-Gm-Message-State: AOJu0Yy1DKSZc2YWmv3WcWHGgXZIGvtkwBrLE/zNelXHMlJpiOoEgnVU
	ag1miMC67v41uzWtd4bnJxEt6xrHupG7EEBrcHn93amltSNLyQRJ5U7K+otxPKWbNTczp5L6wot
	fx6VJ6Q3MxH/eTYsMcmQKnBmvcFOd0+8=
X-Gm-Gg: AeBDietT71ljV0/BMLEEssEPRpdLZBgy2WsGnmPiZmQgVnZ1DSIhmgxCGKIHQuLL0/1
	w9UaHFBUa/HIiVMoD98uGVVwGvd10EUsVnnqHeiPWAoRFatXGbW8Bspcn6O4/H1kKFlFmG9ANw+
	b47gsjQMAx+7q6bm2sof/ZuMDBFLTRfN2xX7yTO6vHNFnXpl++S0rH/Y+JSLBdFuLlYk28LBr7N
	vN600L0GeORocH09pEavatR51QMfDsZKHNcOdnZMfDHzxNa0BPoSq5GBjkj0fMZMyOaU0wYzFGn
	DDO+aVtmQBfYSKc+aXlhP3k2GDUIQ6WcQ2Lis8eJWQgN4BEisw==
X-Received: by 2002:a05:690e:1688:b0:651:bcd7:709e with SMTP id
 956f58d0204a3-65310a71a81mr16767427d50.46.1776785201788; Tue, 21 Apr 2026
 08:26:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421063955.99164-1-sprasad@microsoft.com> <20260421063955.99164-2-sprasad@microsoft.com>
In-Reply-To: <20260421063955.99164-2-sprasad@microsoft.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Tue, 21 Apr 2026 08:26:30 -0700
X-Gm-Features: AQROBzCohKFBLFtob7mlCVxxtoiPObLo3LCBJqTRkUUEkaO51_Su7hdh5BVHQMc
Message-ID: <CAGypqWzrOmR6rUimbBJa9qJ-=+KJFzccMjere9dX=KwWeDFe+A@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] cifs: abort open_cached_dir if we don't request leases
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 11:40=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> It is possible that SMB2_open_init may not set lease context based
> on the requested oplock level. This can happen when leases have been
> temporarily or permanently disabled. When this happens, we will have
> open_cached_dir making an open without lease context and the response
> will anyway be rejected by open_cached_dir (thereby forcing a close to
> discard this open). That's unnecessary two round-trips to the server.
>
> This change adds a check before making the open request to the server
> to make sure that SMB2_open_init did add the expected lease context
> to the open in open_cached_dir.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 04bb95091f498..e9917e5204b00 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -286,6 +286,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
>                             &rqst[0], &oplock, &oparms, utf16_path);
>         if (rc)
>                 goto oshr_free;
> +
> +       if (oplock !=3D SMB2_OPLOCK_LEVEL_II) {
> +               rc =3D -EINVAL;
> +               cifs_dbg(FYI, "unexpected oplock level %d for cached dire=
ctory\n", oplock);
Should we reword the log from "'unexpected' oplock level for cached
directory" to something like
lease not available for cached dir.? Considering  the client itself
might be disabling oplock temporarily.
"unexpected" might look misleading.

> +               goto oshr_free;
> +       }
> +
>         smb2_set_next_command(tcon, &rqst[0]);
>
>         memset(&qi_iov, 0, sizeof(qi_iov));

Other than the above minor comment, Changes look good to me.
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
