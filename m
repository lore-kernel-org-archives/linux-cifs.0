Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550AA4570C2
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 23:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788391248; cv=pass; b=I25zJiiw9vTogpGHXiAPkxNNMU1LoyReeMNs8EuSud+B6omb8WeaNrMd0ivKCf1+WWlvn+BaR5psiCt6APOn2uwWT4dmw2b9JnevkfFAt+F7RZY/CzlCglMboF9bnu+U0uL6m/diBu47Ss28rdCChRGnEpXBqmEyhPepM3KBeC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788391248; c=relaxed/simple;
	bh=iC4igTMpMA0vt8N3OLjewU/xk9zTtezvRPa2jfDrV7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrYitgWPWvw5Rn8rw2+4Qr8RWMvguK9wNBRsFrBoHGT5iCHAcDqoSM+Qwj3Hlb1DYt+Xnu0QVWAuZhSN0p1W7P3Ijak4jjgHytcLrxK8tflR90eA/kIcB7j0IH2vm76MBT3MMNQuWtW4KunLx1ofqYBy7giQYpdZGAoUU12VrPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=awtVFJwL; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="awtVFJwL"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-783906bdb20so661513137.1
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 16:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788391246; cv=none;
        d=google.com; s=arc-20260327;
        b=j7jBMK4g/oXf7tQphv+eEwaZoWo3tNtGLgBoYOjObQRzAKaCjhwk2K2QRQmzwk6sbk
         tQ2wGyRJJlhkTnzG3I7V1q9EZKRr/iav9zhou94TfSKDLvqrINjO+DjOtwMFOyxZQbvN
         4Ghnwp0RA/R4pLx3EzdZbSBe7bYDBx3owAv5i7MbC18OdjeNxnsshHzves18KtEuA89A
         R/eWFo/E3weCMSoqnieSc67eITQvM7vfm5bWmp1ffp9th7f83V5vErgK8TpQJi8iHfFJ
         ZbDVWS27M3bPLFMkjogVJovF+PbkOMNbviGK+Jan3qD+EbFPgHmUrEg/anJwlyoqSLMa
         UUOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ctfyWmXku01u+4qfsuLl+OcUlV55EiVZqHCl5DVKyE0=;
        fh=fjxCBqEt/Rx/IoFEYel5mJQzONtS9ABq08ZbtF8Zwoc=;
        b=IByXO6mO0GjWwH/y8BdEDYzP4wFWNKMpyxTy8KCX7bFoBTLsKvNotFa7sQuqUImnXS
         RHZcJk9D+t637xVdEwSuut/FfgwWYsWaibRHr0uILBYNpoyF4nOoBTx4RMhJjYemUtKF
         Naz265XeyEtbJPACniC1kCPntcBSfvfdCHQqvAX7ggvNIsbs98qX14cyGp4xDRNCUwNJ
         W1T0zz0CkOITzyFE0Vb5CoKf7wOb9o3oCiVaG8p6PqMxTv0kZSwwEn54eZXF5/NSFLaS
         oh5SNGudMKKyR+MURwM4svEK77HQ8Fk+hMPjK58vZG+O9tBdGtRGYq/6qoRj/H4cWcuU
         MSPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788391246; x=1788996046; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ctfyWmXku01u+4qfsuLl+OcUlV55EiVZqHCl5DVKyE0=;
        b=awtVFJwLOPvszdd6HdFM0Hh2xVxGOnfUic8ciOWfb1nrHPJD/so58cYf+Qs+bkwU0m
         FTMxFlMhyak+JbEchb2SMb+0hjyojustqKOqDn21TmSi84sa7aYEF4Zbwpa/uwCPnTt8
         hACdH4AQfVFYpf8XJlSXindwYj0cKm+PmQpyLRYvCBHbvzxz6xL4KncF2wAn9DeS7gwD
         nvn2Di9rJjOPVh45oIsZi4qgToRObEhXC14cIs3aZPEhvHAyw1hZnn1WY0xdClB79JZ5
         IyOKV9ZQLqpIuoEc8peGw9XoSfwytxXNO/7yns1eZUnimOryymoRekl0l0s8rmfR0+P9
         /EIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788391246; x=1788996046;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ctfyWmXku01u+4qfsuLl+OcUlV55EiVZqHCl5DVKyE0=;
        b=hR4bzvpMX6QNF2xeIhzLTFqMjNZao4/8ytyB2Em8zFVIANLYbdTUq4AGSEL1PVvTSK
         c5rb+Lh5uwt7rDk6hetHdshC46lDY7fUKYm4pm+WZhbecpAw0SFzcawHFDTErciI1+nr
         1WFJ14eEy/WkSTwk2wny1yXVABz54Px2Z7HZ5CD8DPtBD7AeITVi2jhUQlI5/sFe8kDT
         WOpIZqHNW6ZsZicr50V/4leq76jTFm3xT++xF1qMGLBaqr6CAYp3VOpyXqXs0y66V+eo
         GyIn8jwkOU3ljPVS7BzO+8wIrfbrUkx7cs8IXSRfdZJlUTTN/HskTrqpFDXTI5P1uF5q
         tFTA==
X-Forwarded-Encrypted: i=1; AKwUvByKCsZrSMqONhzsSgbr0rhzJ6d5HhJT0rTfheK8n3PwPGVN06hRg72VklpC5bcetrv3Lkiq1dM+tZ00@vger.kernel.org
X-Gm-Message-State: AFuF++m/IHnJqv0ZScYar2UG+bRr+dRZTTn3u05QGI9x3RxymcXPJhL3
	vP3l/aH+uQe8sWccK5qj/oR93VQtL4+QHu4JBBZRTjsowSWu4k1BRIADmfL8xRjGtsMG1cdetO0
	k1oDWNtH9J64q68cas7LsR7XwcdS4p5Ya/OEYehvPpe8=
X-Gm-Gg: AYBFou2TteUX3ig0S8q5+3PfPbJwgc0AxftZDrO8t21eO3agWClUnv70eCJYEcOELnr
	4cNLA5fd0qLOa/7PU3UBZV/BR8f6jpOwNhTY+oWxxWtIqPl7YR9oPNYPDCH7frupMrny4uvPsWO
	cenPJ++usoWkQdgFMQQ2AA9c46KEip1mEPGxbM+LvCwfokc1z+z8oZpx5vuiqSEgCdtrP0hL71d
	V5gviMW/rU06nLORuolw+aoIEo9d4G22N/0zuBEw86e34mPvOQ5Pq9QLG8seNkpqvV0HjJrCT4e
	963UeKBuOlWCjx1Se0u6SD84b3jY1QqB9bQjMkYKGuS/3nqUTX61BP2m3kWZToYevO9xSUmtfaL
	2zf8=
X-Received: by 2002:a05:6102:158c:b0:784:b9ec:913f with SMTP id
 ada2fe7eead31-78a1f1e91famr2790327137.5.1788391246032; Wed, 02 Sep 2026
 16:20:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260902104207.1820332-1-diego@bynar.io> <e5dec57a-0186-4087-9de4-5037f0a09879@redhat.com>
 <498fd2508ad66ac9d8fd19cbd4b4a02b@manguebit.org>
In-Reply-To: <498fd2508ad66ac9d8fd19cbd4b4a02b@manguebit.org>
From: Diego Oliva <diego@bynar.io>
Date: Thu, 3 Sep 2026 00:20:22 +0100
X-Gm-Features: AcwNN1Uq89CVK9SEpAncgGJQrXQWyiuzoucQNLEbuPZ4hbh-lgr1YZwMIHkcJc4
Message-ID: <CAExJZk3gfbM4LkvN-zJGt6sQ3AKN+huZuhEatMswx2nYHyu7Og@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in CIFSSMBRead()
To: Paulo Alcantara <pc@manguebit.org>
Cc: sorenson@redhat.com, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 10:29=E2=80=AFPM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> Your patch 2 checks that data_offset + data_length fit:
>
> +               } else if ((size_t)data_offset + data_length > rsp_iov.io=
v_len) {
>
> but I think you may also need a lower-bound check to make sure
> data_offset is at least sizeof(READ_RSP):
>
> +               } else if (data_offset < sizeof(READ_RSP)) {
>
> otherwise, the data would overlap the response header itself.

Hi Frank, that's true, thanks for spotting the missing check!

On Wed, Sep 2, 2026 at 11:32=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Diego, do you want me to fold this in:
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index f3cba16f6e17..f9aff0712794 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -1742,7 +1742,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_=
parms *io_parms,
>                         rc =3D smb_EIO2(smb_eio_trace_read_overlarge,
>                                       data_length, count);
>                         *nbytes =3D 0;
> -               } else if ((size_t)data_offset + data_length > rsp_iov.io=
v_len) {
> +               } else if (data_offset < sizeof(*pSMBr) ||
> +                          (size_t)data_offset + data_length > rsp_iov.io=
v_len) {
>                         /* check that the data lies within the received r=
esponse */
>                         cifs_dbg(FYI, "%s: bad data offset %u length %u f=
or response of %zu\n",
>                                  __func__, data_offset, data_length, rsp_=
iov.iov_len);

Looks good to me, thanks Paulo!
