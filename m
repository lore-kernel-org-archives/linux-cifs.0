Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CB3E3C7D
	for <linux-cifs@vger.kernel.org>; Wed,  6 May 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778077003; cv=pass; b=KXTvjNhY11BJBWTWNHv0TvcenLf0ZJ5wXmE+dWlKhYMnyrgH5SDuaT4rbCgH3jlkp6bAvUdZh/4DCkLkG+IeNqBi4bFmhGQYrvev6UENGA4nOppb00PeQkZ1zHFfcdL3CRDTjLUfxwGTjTU+nLBMIDRA03oyBP7KzAX+Bf/q/P8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778077003; c=relaxed/simple;
	bh=BO0inazC7nIhHzK/RqjC5uR0srzp6ZDE+sGZyuMr2xM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNfSwtdA/VV8d2VNYi89IMV9qOlySoMgu+Sp0IuzXJbPWe7az7FbDblvknefYY+suyqmXgydjvqr0NyLs2h4IHpkGGnLikEdVZXE7pfc6X8GROGYx5iX+ZLDOnhrkpCwlI+IxtuZuw2quN4qTpv0hI/eUiDafo7hN2w2m2zrb4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3MFG9vk; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3MFG9vk"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7bd8cc5ad52so30003577b3.2
        for <linux-cifs@vger.kernel.org>; Wed, 06 May 2026 07:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778077001; cv=none;
        d=google.com; s=arc-20240605;
        b=M+ZbuyN4riQXNTpRQ11LqZ8fEyTAPXGXNqGVdFQSEffPn6Lyq6F1EymXREHzVY6KJm
         2hLaNV1/OzC1igQIDzZHpiBbzckbPZlL+DEDBIvdF+pWUop0yTr86K8RoPWt88tQwEDb
         pn6VHQ/t9vZULTdTYSAhGJCDgJLVCtUftjzVDnUMN8pfcqT9k3nF89u+ZDvr3YHy+4ay
         9IpE40uyxf30Gi2X7BfoZnirg2tLRWgXCZbqSCRMZgJxHYuHtVKuTmFhGDLTvkIjl0TL
         d1In5LfOLVqyFX5+LScgs10uZ3JaaPKwEsjBGA8Uk3PfqhNvTSK2bKjuR0Ft0AyIQ+At
         VVJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vxGTLSi9EMDgbvFwJLkFrQfjW8cmX9Z3HmTaLl84F/0=;
        fh=6l+b+8TgNjskIbEdKAy7jNhDycv+isEey1OBJZGhKP0=;
        b=bC+V5K3pUUNSovPXkRavf7P0AOmZboagQFXO5dqQb21/fD1A4QZJp+dbLOW5QRSBJr
         /1lgtyAqICosv7OMEQBxlSPVBPWs6RX8I/m3AnG9seguIKwU1j33/Ft3o2W5oSUr0SnE
         59YjO1lqu/KKcqndBqwvrxTvmsmA98JWFfx82BXf2DE9tO97grD2HB/Gdt3E8lSPvsDF
         uT6BvYA06OJlrfODRma/R5JzY8WFdV8hsI/tkx5ipqwbOn5ChAUQDgPogVxvCf42jEcI
         4jfeki01oyjLOdJStAJwAeHYXI7a+dHFpQFbPZEqg1MK7vng9SiQrw+W8OjWkWM2OYHI
         ukDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778077001; x=1778681801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxGTLSi9EMDgbvFwJLkFrQfjW8cmX9Z3HmTaLl84F/0=;
        b=O3MFG9vkS/Rc9ZGtyXSLXmwtOnrbwZG9JxdqeXASyTqnMGTaUuIFdL/8XFK22ZZL9F
         dalPAIXbZ9qfBtzvdleY6Xbg1RJNjyz8paKpmqqUzbi5Gld314zRj2n/yhzIGXYHi3yo
         uCWub3P9dZ87l9lIQqAhwLbnQZBMkcoThfPQ7691kp1nMffYplWzD460ZieljT6iMqwP
         pj2GX60j+rJh7ZQx9dMDCEakY28ttg+Jyq0NMGP3GR+YQQ722QI1svkMgwlh1BlePckN
         yyvT3pm9hyEBC7MKseiYLhrsj+itYK0lNFYM16bUSv/yoLo+h2wm5bIqJxAH1MGliOUu
         Ktpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077001; x=1778681801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vxGTLSi9EMDgbvFwJLkFrQfjW8cmX9Z3HmTaLl84F/0=;
        b=U5z3adYOkEgT5rLWhpKiMsx5mm5hUS8CQGTup1F0w1BrliAmBB8BWlMFqU4FkEC/Du
         K1mV3deYUIKypklmJ4wq76uVwMzETUQMYjZtJCv4fyR24gbEcQ6jGb3F6JkxyOvOjySN
         iAn7tOuY8tdoIWPK1qVhF4MDP9ksFd1yU3KksxrNTkzH5zQqKeN6ClaZJNq/bEmURVhk
         OJHi+tluVgEeE96oEtEAhnKh/qa+6kpm3DOAd2Wj0Oi9+G16M7n3uYltugPou6gLMzjr
         jnk58CLlg88+yxatAvZF2eTzjgjhqpYoRX+scMxPQa1+M0/R69DdqsA4372QXvB2o1BP
         4nnQ==
X-Gm-Message-State: AOJu0YwJeOB8RJKMjt4aTbf0pCG43171xavkanJVoUoAXnKS9TZOktZu
	n06qH4YD3Sb/HmB307wiBgavinzb/lNPCLtU6ByWBEXON9Pk1DkEVzYMyubiTbnE5MgMnXylmZT
	kNG3dp02fUeO9SHy1HJ+fyZFlTHi9zgzQxVYFLGk=
X-Gm-Gg: AeBDiev3iRUAwhXsmNdCbGo0r60p5rL0AqfC/1RqfW4Eb3DGh8+krD+91BzZOl1E3bw
	INol89uUel0gkui9BAlYvFZTMgmW1FOZ1pyI/HRxRucHMw1ckKAwzdNsK2Az4LzGIKzNyYtW/h1
	n6b1N16xN7xxizPMqNTJegwO7IffFrZy/8/K7tS6N4sNQiILjn34zVOaSZPYOFMwNf9hxp/ZZZl
	qenuxGTlQQDxegV0TflMRpkYUfuOF1UofpZYh5R1vuTD3pQSpzsH9ZfFPBSj9JY2zdwL62gYV4K
	jGJhZs5ZMxObLITrUx/p5zp1yzMEQH6QfYFI7tL4becvY1XXYg==
X-Received: by 2002:a05:690c:10:b0:7b4:657d:bd5d with SMTP id
 00721157ae682-7bdf5e89316mr40655117b3.30.1778077001190; Wed, 06 May 2026
 07:16:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501112023.338005-1-sprasad@microsoft.com> <20260501112023.338005-2-sprasad@microsoft.com>
In-Reply-To: <20260501112023.338005-2-sprasad@microsoft.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 6 May 2026 07:16:30 -0700
X-Gm-Features: AVHnY4I_xPVwU3LeqsN8XTWUSXz1NIExjYj6-xyUUPP5SFkn_3D5obBBB9o83R4
Message-ID: <CAGypqWx3zYp0yo2PmAvSCYuMRmiCDdJGSUwzSN=8US2aFrWNbQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/19] cifs: abort open_cached_dir if we don't request leases
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de, Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 4:22=E2=80=AFAM <nspmangalore@gmail.com> wrote:
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
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
