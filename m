Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5258A348453
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538657; cv=none; b=MJW4O515vHAeamMtZWiIriohSrAVFEoRLmxJM3ZyEAy0AsB/9fp8HB8QX0a9AgEdBnU8/ESwIzrctg9TZFMfDa/4eWWoRC7JmihOHe/JUh6FDBew+Vhzy/v/L5uuDSSMLExrWeJrPrj26owsCeiEuFIscpQ5tbTu8H150VzNprg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538657; c=relaxed/simple;
	bh=1YtA5tbGoV4aHe36eHBGP3wLM/YC0g+QQhItedmxNzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTQljctk3/c5GZPkKu23vHxUOqzw7bkai8nDj+6tVmzOllCroUIVe5nWZrouSYWZ/tIElWb3AbdtKkiFN5PiZO2vC1zs0hyDAxWpB5SX9Al4f8uMOnUfxWX2m6xzo61MKLYN2N6n4RCUfDUkRVyCDxSVjjriv3cADk1PsdgWuhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7gjxHlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7gjxHlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079A41F00AC4
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786538656;
	bh=njtwWj4aifJ2fdaNHC18DkTXwuJ10H6ExFhkgPenaoY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l7gjxHlQXmv7oZ5gFOXfuxIvQdxrOd7tkw9nK5JlfXVcfWiOkTm9EDFK2KCMVQ4sJ
	 qQQI+9x5iQJfraJECjFcvYnJ6+r49SBF0y6F0WhinqjBrcWI/hl+MOGTh6X9/IomDK
	 x/vfjCwV7qU5V4dc76ZkUnREh2K+Z7+oDyvQ2ZF6+GQYCn2j/0TuBsAP/5B7xcvZfT
	 59YT8d23+Iwxt+7krnB5nKcJA9Yh/ysO7+t9tA3/NxkwHYpwQK9xfS4OeVzr41RSa2
	 cza5a/L9hPiCLHfHHDNUSQIsapkf2w4auReUyKsq3STDzWMIXdTHWUqSiCflF/XL/P
	 nvlqqGt0xxq1A==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c20e70a0962so102193166b.2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 05:44:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoBQi6i9nT46xKvgSW97Tpxry2DG5fjD4Nz3fdVWs8mKYDyvbme/3dkyl7Ntxg8L2go3chjV6o2QiYY@vger.kernel.org
X-Gm-Message-State: AOJu0YxFCf5AOafSI2InHrzP/UB8vXi+a1OFAoxndkSZ5L5SIvJgdAB2
	WdeiSqqNtZG9jtbKbm+Q6YXxA4ZECex1CDkrSV3rGRnMwBDT/jMy26NZHxpVI4FgppDyxNWDwOY
	HsafVUqsisKII9wCDM2q8XehdIysC/MA=
X-Received: by 2002:a17:906:7305:b0:c20:74db:50c7 with SMTP id
 a640c23a62f3a-c20f2eb73ecmr175680566b.13.1786538654665; Wed, 12 Aug 2026
 05:44:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807125845.1477067-1-thuth@redhat.com> <20260807125845.1477067-3-thuth@redhat.com>
 <CAKYAXd_VJH8dFHofy2Jfk2172vDuU+XizXQf06w0oz81F1WDdQ@mail.gmail.com> <e23dc8fd-67c5-4950-a598-13ff50a40d1c@redhat.com>
In-Reply-To: <e23dc8fd-67c5-4950-a598-13ff50a40d1c@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 12 Aug 2026 21:44:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-2h5yEj9QbQdg=Ycwci4JuueZVB4cfAX2nXNoXs-2Ebw@mail.gmail.com>
X-Gm-Features: AUfX_mzukNwB2DoC8tP_9GrVbMAx9Eo2JdU-GGH53bCvMCnGHU_ccDvfyYz0-Zg
Message-ID: <CAKYAXd-2h5yEj9QbQdg=Ycwci4JuueZVB4cfAX2nXNoXs-2Ebw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when done
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Steve French <sfrench@samba.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 9:57=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 11/08/2026 12.31, Namjae Jeon wrote:
> >> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpo=
rt.c
> >> index 1143ee52470a7..d23566da2ac81 100644
> >> --- a/fs/smb/client/smb2transport.c
> >> +++ b/fs/smb/client/smb2transport.c
> >> @@ -464,8 +464,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct =
TCP_Server_Info *server)
> >>          unsigned char smb3_signature[SMB2_CMACAES_SIZE];
> >>          struct kvec *iov =3D rqst->rq_iov;
> >>          struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> >> -       struct aes_cmac_key cmac_key;
> >> -       struct aes_cmac_ctx cmac_ctx;
> >> +       struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
> >> +       struct aes_cmac_ctx cmac_ctx __cleanup(aes_cmac_zeroize_ctx);
> >>          struct smb_rqst drqst;
> >>          u8 key[SMB3_SIGN_KEY_SIZE];
> > Shouldn=E2=80=99t we also clear the raw key with memzero_explicit(key,
> > sizeof(key)) immediately after aes_cmac_preparekey() ?
> >
> >          rc =3D aes_cmac_preparekey(&cmac_key, key, SMB2_CMACAES_SIZE);
> > +        memzero_explicit(key, sizeof(key));
> >          if (rc) {
> >                  cifs_server_dbg(VFS, "%s: Could not set key for cmac
> > aes\n", __func__);
> >                  return rc;
> >          }
> Yes, but I was planning to do all the scrubbing for such other spots in a
> separate patch series (similar to what I've posted for the smb/server cod=
e
> already) ... this patch series here focuses on aes_cmac_zeroize_key and
> aes_cmac_zeroize_ctx only. I hope that's ok?
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
