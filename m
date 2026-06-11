Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA713FADFD
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781210234; cv=pass; b=IWJ+wBChS8HBGephxJhOP16wHXResPyCBDTVgEhNcweYIpkzXecEUoWyU/LdbAIvhnocq3pJAOP/PWwcqPHH7x6Kj4CzzIYkxN2sYWxBJ9ycvxkvk80TLMk+P5Tkd7ByJ+xaFY/4/5wxXdqB/7NU4GJyJWvVDKgbxsAf5eVOA+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781210234; c=relaxed/simple;
	bh=73WLJC21hhKpLbbOzveQZZ1Rz8sJ9alAYv7Z/ugl/4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C0LxnSBSqGidp1IZHJVqVibFAX/6R4mwVGzCB8YjWxrmJKubkYL25978Dm/Aw/OxPdx1QK0wgH9mCbsRvku60Ew799ARFZd8KDaNRF2Dcg1zz4vsYTAFjn+HHcYDXWrXQ3KEMOL2oujd60t7DFNIJtCdq2DbBF4sAdNGuNQd0/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUVmH4wn; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUVmH4wn"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-396bed274b9so2528881fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 13:37:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210231; cv=none;
        d=google.com; s=arc-20240605;
        b=QMUxYyhZdQ0OR/CR3VoH/2fhxiKs32WIaCIpz/WjSQ1EWxiFQfXEagj34GHm+psd0e
         EXG42lh/npNdYfd9vQOZvTJoSkF7wcykU72f1A8EmmDlpd5X8Tq97CPRgKp564zZq+kS
         FX+n6c1mFaiVEXKgrU+6VGn/gFqaO9KXvkSYf7o7aQ3CHHyZCcg5nCurf50pxRliZdoT
         GJVMqv2U5zMkLbgLBnoZjoPsOoku8pu2VQEqmyEKDcp4bc3IHYs661fTmgdTdFCkjxJT
         0ZiWIOTn4y4Bp+68Fg84VhtK6sPYWXTng3sttYWajBANrasiEB0zFyDDhBJYdeSJV7xT
         o5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hR6L+m7wu2NX+62gnu6yr+xDqGZjBXR2Xn5NG9Z4K9g=;
        fh=88KV1mrCqhXD7Zg1lRgX+tKCOO9Z12HBEMPsom7x0wk=;
        b=XHqWTBj1i64BF9gcHWKEfTRzMadl5UpRTHgVIpFzTdJPLvj7K+hDTCzBnp2m8BGGcD
         YcIeCKqfWj73SIiRBb40fIbK0DuDhE85VEYESXrx+b16Amz6pqj/pqImIXtq1nW33z3m
         1BxlkBzB4nFSJgcEXMNNkEjcUw8TW1QrxLnnKv3z/NJ6XDvpNviqf+fbR7rofhd4dCpz
         2F1wlci1S7z5lToLv8QD9+D7uHlETKPcSoFXF0X4O0pMsbO1L48QXrq5raCVU2lSIJ51
         UxvAPhNLSa53G1uaju+TCRIt50/8ZSjVd7+2sVbauftVPwM3HLj1wUlOdL0VXeVQTm1a
         uk/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781210231; x=1781815031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hR6L+m7wu2NX+62gnu6yr+xDqGZjBXR2Xn5NG9Z4K9g=;
        b=QUVmH4wn6WGBiPfSiWio+QRAYJkBtGALeM5dpU9NpBj/5/2udTMFDXv/nzE6L5Qrs6
         PBpRQDQQ+fwLTlu1X8V+1wB22DHVUt0ZKj92M8ib4RsQjKN6cqTsJ1W6diKKRMU3zykQ
         YNy0CbCh5MjD4H8Ux/oVHtfEHEKTPlTjuIiYYJC+aOYVU6h4opvUUPWSIGfjSlWXl+GF
         6Pw4temSBOYZj3KBxS6PM6uEOYyKRueCB6KBYQlJAQBptpKqmmhVHT9znWa8JJCKVusz
         IEuz3x5qdt0aW6I08p4U8IcYLXxn47BX6gmDAVOsRgyJRaUvE+07rSeG7SV77UvFRqf3
         YKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210231; x=1781815031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hR6L+m7wu2NX+62gnu6yr+xDqGZjBXR2Xn5NG9Z4K9g=;
        b=oaI7z4mI1cs7tPpYWSJbUbmcqKTr0/6q78Thm+dobXX5ARQpCCVYKL6WtP2gkytKXS
         bbOdSppGcYUVFtRfO6lxrF0NMrkUW2GXpxCli/fQE3sUgwdGaTBdNRqaXil0gw4nwuHj
         9K7vdCvPRABqVRQKMcaSi2sVj1uuA4Ka+3iSEI3SDeQ3PbD86kuAQLBPkOekZP3iGTeU
         qmF4jNe6eFowsZqBSWP4zr9ZW9TfxZ3EL9eb9kF/AN1YEcGrEqCK0/7geoOt8TIMa4l6
         ArWXJ+eLQOS50swb5Zx+2pRT+B7QSf8rlpuAWPxTS9HfKnvF4B05Tq09Zp0qWx0nhNe5
         7mxg==
X-Forwarded-Encrypted: i=1; AFNElJ8E6xK/w1SCMEyW86UX42r7+bQS5kE4oaRdbKcsusVLhQtQMK4ukKX7pi6gg36weavr4JUdvZBJ8tfN@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4pHjKtuULrSjj34Zdv1jjXPwhHzK9BUfFhOx4Wrct26bA9XAe
	50ck6O16onK3F+k1zeHue1oj5Dhs2Zv49EqcJp8vUY165IKDkF7lN/IC8B/ZqkJSiIUfqTY5TQD
	t+1otEZhtnKH3ZvIiZl/x9q6soO0gMjQ=
X-Gm-Gg: Acq92OFj1O+RA/VhMVgb0Q4sVgejiA8UXwS1xY4UpxhDG8MY8RfjqSFpRZy8GojMTcC
	tYnNx51opZrjrTAy2DpO77X7lLiwqKxBumeNVTmckpgZnMNTe9m1IVUgdz9WHkbDcRf6wL1nyXF
	1UcGVuLft1rb+gwNzqB7T2YQ+sB6E6yDGTccpLz9GP62sXppBR+zemWQf+spA9kHjMoGNd96gOI
	pal/dBiTx2NIzMwiV3sWmLy7klC20b1m9fxI21kkx7uKj3QdPhBa0G6YUBR5yZSiJ1q8lqYm51v
	cs6NZ9KZiB0XwIPjpgD8nyiLZ+1lc6eu+nzb3bcQTk4xWJcqcDd7zD8DT1rB5Oxjk8j+ZA50yco
	C6OAn+MvqDkwtGg8KevCGxQmYMgkeW9m0ndy3j4HoctAFsYiRsvaeO0Eu6Gxs8RPQ2EzqI2wHrf
	rMI964ZrALPhZGpT0Vhd0p
X-Received: by 2002:a05:6512:224a:b0:5aa:6f5d:ee0b with SMTP id
 2adb3069b0e04-5ad2db15619mr5675e87.2.1781210231441; Thu, 11 Jun 2026 13:37:11
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aiplQF3QGXmXAEk2@stanley.mountain>
In-Reply-To: <aiplQF3QGXmXAEk2@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Jun 2026 15:36:56 -0500
X-Gm-Features: AVVi8Cd4EQliyIHLF8hHkVDnv7pEGey5HCW41kivA4WOaBYOV5igv-hjRbl4GJw
Message-ID: <CAH2r5mvKDLssgLBs8x5zNhp-+-h7yNPYzgtf_LQm3kchRVtZ4w@mail.gmail.com>
Subject: Re: [PATCH] smb/client: Fix error code in smb2_aead_req_alloc()
To: Dan Carpenter <error27@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Jun 11, 2026 at 4:00=E2=80=AFAM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> The "*num_sgs" variable is a u32 so "ERR_PTR(*num_sgs)" doesn't work.
> We would have to do something similar to the previous line where it's
> cast to int and then long.  However, it's simpler to store the return in
> an int ret variable.
>
> This bug would eventually result in a crash when dereference the invalid
> error pointer.
>
> Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rathe=
r than a page list")
> Cc: stable@kernel.org
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  fs/smb/client/smb2ops.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a3257815e661..a8f8feeeccb5 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4359,11 +4359,13 @@ static void *smb2_aead_req_alloc(struct crypto_ae=
ad *tfm, const struct smb_rqst
>         unsigned int req_size =3D sizeof(**req) + crypto_aead_reqsize(tfm=
);
>         unsigned int iv_size =3D crypto_aead_ivsize(tfm);
>         unsigned int len;
> +       int ret;
>         u8 *p;
>
> -       *num_sgs =3D cifs_get_num_sgs(rqst, num_rqst, sig);
> -       if (IS_ERR_VALUE((long)(int)*num_sgs))
> -               return ERR_PTR(*num_sgs);
> +       ret =3D cifs_get_num_sgs(rqst, num_rqst, sig);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +       *num_sgs =3D ret;
>
>         len =3D iv_size;
>         len +=3D crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment(=
) - 1);
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
