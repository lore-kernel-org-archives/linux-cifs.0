Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F4296BC1
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777576618; cv=pass; b=m6M8CvYV1KNPg2//Caj76HQUF/rzjj69fR7NPpUgttNf8iFtkMYsIVzpi90j8GoR/RdcQF0AuuVYv5xm6j15l8DtNF3kfg0EZN2NLT1iXrbHr3LK/AFHJ/hP6Q3Lp8eRSCTM+OsmxQpGMPhLVk7lTKuRJ3kJuH9oIMYXPslh+ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777576618; c=relaxed/simple;
	bh=xDvPePKfH4SYIJvgq6nsiD90KSKxun/X863JKt5atPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QETVVDGphtwxFijm57Mdr5XQXkY5XGo1gQrVDKRMn83udFwq+8C+jrs3tL9OLEatzVmud8msLTb/VfJXPopw82a65ddhBfFIv7Irz1bJksGMonzfYWT/8nAuvjDjdknunzIYRg19mm9R2s2uQi0yL96mHxJHbtdkzsxGcHC6ZsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLkp5laK; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLkp5laK"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8aca4e14411so13407486d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 12:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777576615; cv=none;
        d=google.com; s=arc-20240605;
        b=O24YmFfl5glWtSyzUJ1iaWkUxXnOc0uye4/+WlqDOL7N2QUhucfm2vOpSecBLX9oLa
         hHDDizeH38ZbBA7iOjTiyQAgbdpeHJyh2ayWN3Lc7UucmvcE5fC6hvwNA7EF/qraLFLx
         GhqX5vD0r9LRPneCGssGadVU62MmM4d0IpsKcAb1rLJynG/NbyZs2a8V4XP+uzUPfLw0
         lcyQOFMTvz14d2p0w/6BnZ4WCydfOxeFbAKN52VW5paTrSSt7SO06hbrD7fgMwSoH2rh
         tLkMwDsB4uaxX3U2CUJ3wxqq4SzMH8uiyNfUJ50oTzRfpN4jZMV5S0b1ewhvAPdCzRAd
         OjgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DjI6tqWA6jLZAVm/BuUGdM3lQfH0KlxWewSifCFKExk=;
        fh=Eg9jCuy3cd6hwT36/ILiP1NmGCu6gaX2opVLVxGRBho=;
        b=Da6SndPLiGs3lSKL6Yft/EV4nE12oMQ4cSDHqEMsDG0yLF4nF4bDOlb7QWDiucOX9z
         BkgaDpztgFruHmVBqqx+z/37qz/neT2eV+efNQbOgn/BxIGVK6klZez62OVtK/QuEU1x
         RME9YEjxVcuOSREdKAb/uxuHyf0hhRElC9/vysPeriI0GU6FAk6OYym77Ohvofsy4NzI
         OSag3mLHoCbyLjaergv4FA9SlGkW2fgne+2E+AJUv2yF30xU7Ax+EzgGl2uV8yjbOF1B
         +nk/O/TXBxerbm/QCgJ76hwugrwcs41WuGzF+7uG8vLDsoEUQTdlGIh9PoGjRaOsKvpd
         jJCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777576615; x=1778181415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjI6tqWA6jLZAVm/BuUGdM3lQfH0KlxWewSifCFKExk=;
        b=iLkp5laKtstJrh9wvQ5TlYnnB1BzOOUXPy6sR+NKTrS/bBzBGO2C4Vu0e1Ze0NxbQJ
         xlJKibKf2DfSM1IzlzxHZZ8NOHX8667ldB2is80SCw3XeXi1WC6ShbJAkSS9oRXgmGk+
         PHZPjKOvyHzVTnfC79jBBJOiZKwbgrP1NaQDQSyVJiQ1QiSx/5bSS3DrCBuv6cGCcADb
         ebckZzwisoR46Q7rUnbQZ8eVwHqpdX43UFMJ14ASvuh71EKKH9hPlPlfRubVEEe44Fy6
         vhkRj0mzHUQZNuXeZanT62+1ByyLC0hQoOX5h4H6eBdFp3Fsv9OGVWUj+qtii3m+hWWT
         oPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777576615; x=1778181415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DjI6tqWA6jLZAVm/BuUGdM3lQfH0KlxWewSifCFKExk=;
        b=TtOjcaV9Tf3FfytuG9er15KgWT3hvv83mUe+vxYcKht7DVJji5R2pjhuVE03mqg5yi
         gJ3SFyzWMAW1qLzluBhGKJPXrzDYbOQq6X/h2KItyq0jKw3i2yuK06HW22rKpYhakyGg
         fA1p3Dpb8y9uYmEYVprFacP94tGAmdq9O0vwUzxqEcCVZFc6h9vPikxnv9bwb77bf33i
         cSsI+2LRs5ENIegF3+jeOEs7smJ0RF8O05IIQzYR1+05iUmDvIwYXhHp5/0BbupvDlGp
         ofKQydkKdNocj7nf53W0ovRHJv+/Ph86U/txjuDgp7MNi3VIw0cJhygxUFKU6z+Z9O3K
         Y9zA==
X-Gm-Message-State: AOJu0YwNMSEJRXHlgecLA5GfLYAJTaAqkvWa9U8VKfsY7XwpJzVEkzfW
	MsSGS0ydUy1r3vkhxGz/4yEfU5JH+OgW1cLhrQ7pLO/HH9Gah3zHJF2JVdqdfytK7tH5nGW3ha9
	NlsC0MoztgJOfZzrcfN1KkHSckz2idlOCKK1B
X-Gm-Gg: AeBDievQ1MhLwEi50V3Tygtz+kGsBbblALEGB19Bk365GiOhs5ohYPoF3Zr7bdQuKvd
	t+OzEdFrxb5txu+jg7bXOLUVCB+q+N+TRTukdvo4Tn35J03eeqvG82/cFIV6sDZCD+n6gUQY8gz
	TXGpawxZKz5LgLn2nqiLTnejMFPfTyNlugNX+BWcBKH3v68F6kDxmOensi5KD0/hmNfKI/0V4Ri
	QSr1VfBK5YsckBgjWEU0Aahxz56xzoi7Xb0OcA2LpVfnlvvORLWI1mrLdYhJhN0jsAIw0EP46B6
	qJSNjHSawhgWE3j+CCmyEamXZyh9eA1OrWPzv5lur6FFIniJzMALtH6lUkeWzCAI9Pef1LW5Oxk
	aRJGeVTFaT7b3QpMs+RY/dZFhLcI6K55vDEi8Lu6D4bd+w77LUeDol79sJApIIzLGojYezCs=
X-Received: by 2002:a0c:f109:0:b0:8ac:b5e0:bf92 with SMTP id
 6a1803df08f44-8b3fe70f494mr54865666d6.9.1777576615374; Thu, 30 Apr 2026
 12:16:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428160804.281745-1-sprasad@microsoft.com> <20260428160804.281745-2-sprasad@microsoft.com>
In-Reply-To: <20260428160804.281745-2-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Apr 2026 14:16:43 -0500
X-Gm-Features: AVHnY4IKz6Pr2LyA9QZ-gb-F4YYencxWRol59XhjMjNlndP_5DknAKVn0Qxqwos
Message-ID: <CAH2r5mtcNUUUH8q-TDTW1UfZVim=cfDZFegqkBc6xex=BZoRQA@mail.gmail.com>
Subject: Re: [PATCH v3 02/19] cifs: abort open_cached_dir if we don't request leases
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next and added Bharath's Reviewed-by

On Tue, Apr 28, 2026 at 11:08=E2=80=AFAM <nspmangalore@gmail.com> wrote:
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
>  fs/smb/client/cached_dir.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 04bb95091f498..64e22c064fa0a 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -286,6 +286,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
>                             &rqst[0], &oplock, &oparms, utf16_path);
>         if (rc)
>                 goto oshr_free;
> +
> +       if (oplock !=3D SMB2_OPLOCK_LEVEL_II) {
> +               rc =3D -EINVAL;
> +               cifs_dbg(FYI, "%s: Oplock level %d not suitable for cache=
d directory\n",
> +                        __func__, oplock);
> +               goto oshr_free;
> +       }
> +
>         smb2_set_next_command(tcon, &rqst[0]);
>
>         memset(&qi_iov, 0, sizeof(qi_iov));
> --
> 2.43.0
>


--=20
Thanks,

Steve
