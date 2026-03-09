Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A92BE7C6
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074999; cv=pass; b=rvgeliiuW7WW9PEDWrqDeTcMIuINxS1eo03L1IbBz1wVtgjJ0PTgq2v1UUd70TcNHzWxv+4ggzCY8t5B5VCOc67fwF56wSmUqvH8tqeJvPesUgQxMWtHZJEIS3phlQQ1ZdLt/8iRSw5n5B7NvVEJyEvfIgi1b843iJHTLNPCpSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074999; c=relaxed/simple;
	bh=KAaPZbb0DZR9Gm52FjNA4Inv7exM2JbDH3cVjDEaakU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1XQIMG1aaMEoAgplrDKvq2g//ago52lofJuCm2PseJ1gXDAaSOd0bDwpHHMOYL0yiFwnQCAfNvxBWUTMHXFs+aU9QWcZYN6efPEgn7xx3Qli5JUl5id4EoelsIslpEfeo891GnF0Ly1ZKHBYr/WA/pfPDpPrpyHHHtXmgZSr90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8i9w6fM; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8i9w6fM"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cd77786e97so231298285a.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 09:49:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773074997; cv=none;
        d=google.com; s=arc-20240605;
        b=GgXD844Zf1++2OHhrXJol8KMCS1qHnF/hjYFsE4OO6IdFIltrpsJgWO6b5wvy/aWxz
         mD7rEbquwos+5uxdfeN+7YqHHydESK0qtCSVVjocUaxe6+VR2vjmsHAJgxXLmMff7XXJ
         PwLyAdaXcmL5QKpdW4Z2XdGygtLVzJ6a8jPUoIPjfeRfe0mE8hicX9oaF9J+x34nKn4c
         reb+yN43eSOui0PwLHTc6gbDgBM+B9/5erHE02HRsM7SPohWyfTXoBTzCreyYg71r6v8
         uay265rzKQVJEVU1A+dQz5WMeBK8ZsU2p+E+SwGupVUeDgE6EA1vc9vkr0IiBKSXHKZ4
         mm4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ezYVrHR1lgcWwO9n3xsdtR2MeYabbPAdyBaDkHGJ+Z0=;
        fh=ofmnPgzyhLKWA0mfWOHl8ycIz1yxt50UP62Zys3kL0s=;
        b=JeVrWQ8wwR2aNJEhoBKSi6+6xiLyh2h2gQnweXXWXZkX1VZ/mvcVT6oueL2DDWJFC5
         S6/XO9Sc6bNeVAOUurWtTMiQeKKIz+/NsLc4E0Sytf0NL8tv/5uHvu18A0UhzovgDFGe
         8/9at3TzoOkYLyYU7Kdx0ycNSCg29jzmCjGZdQ3YaDSeY0IQnqy92HoCsJ8VsqVjDz3P
         V22G50NxBnfW2ic8Dz9EeIWwflgpS9OgMyDS4qlEJTGnhINj6OvEmp6jk709hbargqbF
         yTni+9eBovCBBYMLtwbkn5Ajd6FPHtAqDTrMZuzTEYGeErjlRyKEzLmH4x3VORM0PFl9
         nIwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773074997; x=1773679797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezYVrHR1lgcWwO9n3xsdtR2MeYabbPAdyBaDkHGJ+Z0=;
        b=e8i9w6fMF4QIzhv3ERPxJnOHdSDX30bsicBiXS1x7nPzm/Nxjm211pJb1cY+DiJp7k
         /kQlgwSJzst7XyAmU+acGborBFlDC2wc2sXLn/KRTdN95WIqp4p2bzntBGF6A2gHAD+5
         KR5Ky0cs0fjzPe5uEuOspEWNm+ZUtjycYSaErI7plcL71QzXQt+4wW2J7ol/wM5JpR0+
         wSzC82IaSA6gNy3BOQnSL33CCQNINWJyTx/UxmkwcEXvWUWzULfUKYrTtoMXTO30KQdG
         kyO/kXn6dhvvx3yn7iZAyyYSau/kWVkT5d6yJqKU1mx8X6GhNulohMgSE7iSIio2TSk+
         TZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773074997; x=1773679797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ezYVrHR1lgcWwO9n3xsdtR2MeYabbPAdyBaDkHGJ+Z0=;
        b=memYkRFNOHnz9DkZVo590986L59+mNt6zW3/nDcWZ8I4JJH1m0FoGFuQ/TAdZ/9X8x
         b8IJi+DfsPsGc9+MGP95AASqlHJ3kVBGMuTwR9vtSkY/4R1LzenuEtQbaUpKp/DoONAd
         Sf50NqL0DJEx63kIYq+7GtZo70kyI3YK5x4k8V4VKIHM2V9vUXhxofRYOHb7EBWD6Qdj
         v1jec/RQDk0eDZVPCSkvT6MFt9AH7QlBrhWc8iXkFCN6wloXmqzhuuIBz+r85Gll9o1Z
         GvqwmTykmE/pxGgQNsJf0u8iingYS18i9HOd/jT9bnMJv3TcVgL7ju5FMIrkNittyki+
         znqg==
X-Forwarded-Encrypted: i=1; AJvYcCWs4uKcuY/+RYUSkJNuLp/XPrpb5d8MVSoES+Wz6P/2wBcMxUi6ZaOtGeaozGri6ME0p12I5NQXz7f/@vger.kernel.org
X-Gm-Message-State: AOJu0YwX+m0cxISsxwRiO7Wt2FzEXhjkxjKWaVfkm3FLwuorNRdABpTV
	1+hhlMkQcSrZp4n8phfYHW4spR4cYrXJi6q9kMPHFI94M4tqBCnuP+hjgSOZJNY6DQCCQAbl5Bx
	sLLDleCvPsjJ/RvRMFwpYy+t/Ci8iqxw=
X-Gm-Gg: ATEYQzxgdGDclDVkrni4T1IvV8Gbg2GnLXmJYQPbr7+Fncj9njIGHYlKbP0vGR9xgIR
	9P5a9G6r6Wq4UXGkbEvQbeFcwVgmIyWvL2vaHugUHUvisfUdNsjR+OdFznoqbWUFcqUSGki2Zkc
	qHdTNnmlV6EgLcE3+rOd2iiOd96PVfngIn8RbY0K1RcR8HohrTQGUOE23Dg2HZLGXFJ0CObFl7w
	0B/u7SZeWn/M7AIpTgad0B9Ys0qRz3so3LbL80HS7v7T1zHFsAsv39veH7eAsTTakX+nKKSVifv
	3Mznj9xcr81OrjEmQuJbu2SdQClVdF17op/oEpfh/wjilKPSmVlBag8TmPERMXuPGR+RXVV2TXx
	fcwibVjUDWXn2u8oGcUE6rh1K/2RVhk4NWWEM4gAHuxTA1e/it4I8emeL0zbRXpab0bwZ/pNXDy
	NrUs9VC99lS2O1xrvKCNzd
X-Received: by 2002:a0c:cdc1:0:b0:89a:ec6:102c with SMTP id
 6a1803df08f44-89a30a348b0mr122617186d6.19.1773074997053; Mon, 09 Mar 2026
 09:49:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309103049.22169-1-bharathsm@microsoft.com> <nvmbb2fbm2zkqyk4x254d33llskfldguygq5pfkedv36upems7@jcofwqya42t4>
In-Reply-To: <nvmbb2fbm2zkqyk4x254d33llskfldguygq5pfkedv36upems7@jcofwqya42t4>
From: Steve French <smfrench@gmail.com>
Date: Mon, 9 Mar 2026 11:49:45 -0500
X-Gm-Features: AaiRm53tLnbdLcEbou2BkAZ73WFR62nyhqqgct1D2L97UsGXrHnh4TsVioqBhIg
Message-ID: <CAH2r5mtjTN1gs0sbZsKtRzRO6vRfYFPpZc-14EPfRSKPOoqbag@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix in-place encryption corruption in SMB2_write()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	dhowells@redhat.com, sprasad@microsoft.com, pc@manguebit.com, 
	ematsumiya@suse.de, bharathsm@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Mar 9, 2026 at 10:52=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> On Mon, Mar 09, 2026 at 04:00:49PM +0530, Bharath SM wrote:
> > SMB2_write() places write payload in iov[1..n] as part of rq_iov.
> > smb3_init_transform_rq() pointer-shares rq_iov, so crypt_message()
> > encrypts iov[1] in-place, replacing the original plaintext with
> > ciphertext. On a replayable error, the retry sends the same iov[1]
> > which now contains ciphertext instead of the original data,
> > resulting in corruption.
> >
> > The corruption is most likely to be observed when connections are
> > unstable, as reconnects trigger write retries that re-send the
> > already-encrypted data.
> >
> > This affects SFU mknod, MF symlinks, etc. On kernels before
> > 6.10 (prior to the netfs conversion), sync writes also used
> > this path and were similarly affected. The async write path
> > wasn't unaffected as it uses rq_iter which gets deep-copied.
> >
> > Fix by moving the write payload into rq_iter via iov_iter_kvec(),
> > so smb3_init_transform_rq() deep-copies it before encryption.
> >
> > Cc: stable@vger.kernel.org #6.3+
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/smb2pdu.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index c43ca74e8704..5188218c25be 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -5307,7 +5307,10 @@ SMB2_write(const unsigned int xid, struct cifs_i=
o_parms *io_parms,
> >
> >       memset(&rqst, 0, sizeof(struct smb_rqst));
> >       rqst.rq_iov =3D iov;
> > -     rqst.rq_nvec =3D n_vec + 1;
> > +     /* iov[0] is the SMB header; move payload to rq_iter for encrypti=
on safety */
> > +     rqst.rq_nvec =3D 1;
> > +     iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> > +                   io_parms->length);
> >
> >       if (retries) {
> >               /* Back-off before retry */
> > --
> > 2.48.1
> >



--=20
Thanks,

Steve
