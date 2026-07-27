Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B8B346A13
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 22:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785191771; cv=pass; b=uwiGzzjDYyafoGFy4ak5LJLaoSpyRMjpQ9edgW/EaE6SNHZlnowTr09HfrcIm/oy5RDj9kDh94fqhsaAIxeYr9aksiQ/H4DJlfb8JPAuK3Y+CgIc5Rd6KFStTeyLsFTWZzv2lxV8GXDHGdaiyLOKlHs5ZK0rpmlOoFCKx2MHawE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785191771; c=relaxed/simple;
	bh=A5JGrji3gmfi8wfjTsHx4EWzPUAzQF2VKLtV+g2ok+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJU2mj7zKOd9n+XVEfan57IW059+Gxz8MBC6IHLDZOOVCkXNBQi1vyU+Da184vI4Q+SWeHg0Pt+OOcrT5UFmjaurJIdpyD4qWEEFJcYfU+/ThGBBuYdxSxWOk0u34f0V5yq6NDEUrl95CkN44uHS/nSpE8g5IEG+2VI4AnoRK8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XU23rkGX; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XU23rkGX"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so3527156d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 15:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785191769; cv=none;
        d=google.com; s=arc-20260327;
        b=rU4UPVQp/g9YgD704tx0hT4MqXzVw46oSpNn3tcN+xZTeEgm2kLrCKMm3mRb+AFO8X
         mKZAocCyBmsEPo630ARDQtwhwEwSTT9hW9PDB1U8XsZwpekZstJWLtcPeVyJE+LYjURh
         N6pp6QogLF8w0OxTGKIoQD+cSE5rzbpeTAT1QMGZ9+uPxg5i1kovKT7XwIJP3LQQMv1W
         iujL8Ex93TrZn0UkbZfMBENCU5HMwlahgz0W/EnYLT35RhgvtEc76pDO+4cPufvDrFxA
         D+IiYfTbHtpA7kPlBq3AofeJ3SNyvMB2eQxdonOh63h6SG1WyxNezSsMf9ubQlJH7zou
         kI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xB/RgUF5HOpfhoQWUuueEiTjIaE91QXbECBTQOcSbPA=;
        fh=hxXYhzzH34eI03ro/nD7dIIT5GkbPU4D7+y2EzuyUf4=;
        b=sMQrKuvmf+Be12ZKcINP9qrc0gmP3Kd3eqP42B+UlS4pseSsToGPS7WcCyJDDoMyk5
         1bW2jL3CFTG4fBO0qDnKtkHdu9EC+BOp0LKAqtdM1VHmvOxo8npyb2RiJbio1kJ/qZ2b
         QCklI0rnLHBb631Bg8yvMoXdQV4uBx9eXRe5b0fuPwLzi6EohDU3qusnlwkxjLjtajNh
         m2iH9FLTflXJd7CSIoIMe8oplevi4iHUXsprhWfTZI3Kpr+1R6gDA1BrpeWof5ZMXwHs
         Qq22oB4iWjlHka8i06dGLyKNkpQG0ExQxuXuEWl9RafMlHPoDZToRZBTSj4pYOAFtmSY
         2FPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785191769; x=1785796569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xB/RgUF5HOpfhoQWUuueEiTjIaE91QXbECBTQOcSbPA=;
        b=XU23rkGXVdV5YPoosTojGUi2ICmAQnhS8lpg3tB2fmY2w/VcC62LRLTVh6oAl0OM3b
         6dt3DXEK7PFOUCwr3gJFLdgVdQW4V/a5n0vs95P09fq/ZZ6Urtkitk8zfIavDKC5NmRn
         HC9AEcUYGx0pol/5aurIG0TpMK9cG2zaKdI1QT+L2RNPMqmECPF8s5sr8umd7CGVXcOT
         6dJ2dQUoFezcehfDxNLJYBF6N2D+ACBAIqlKFO6rn3gWmwbbWJnV9eiqvR2HqHFzZUGN
         HGhHLlqla8h9fTUViOYC67CSqOjq1gHhSWrco2VZFlPx6lH1Sw934+csFmVpPgkr2TJd
         t1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785191769; x=1785796569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xB/RgUF5HOpfhoQWUuueEiTjIaE91QXbECBTQOcSbPA=;
        b=CHtxVsOqgZKJdvLE3/hhv8CfEcXMkeldIuMdUjY9tqinQfF8N6oRldxHnsQU2QMjLa
         +7MR+DxrY9tys7/oxGcwsqV0Fygi5zSrOQnepf2GeOroD1gZw506uKNUsNQqaLanrCZx
         r4xPSiXzBRZAb7CUH2fups0Mxl/PA8asjX0aj793pc+hKbIxF9+dfHXMUuWFAynlYd54
         xDMC6X5/D2xCchiN9zmn/r/o3zlHqZkPIrBrYaTMJx6BmQrFIWeU1ptNKa65NleBuYPE
         UlLJ6I1YN/mlNY38rjkYa1620XQiBsYyN4otNmFzxUQR9TXt9VGXCKnnFVNACX1I91r+
         OzKQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrk3n9lvuO8O1WVNu9+diUCBHNXEjPLtp0gwos3DvuTzmCqA+oRFs/WWew8pT5dePcm7pctkyZEXnZt@vger.kernel.org
X-Gm-Message-State: AOJu0YzkF27p1KF7MR3p0bRhiowxMTHt70Of7YDR6P3t4iT7bMxNzWgk
	0SM9cbb2LWrj7lsGcmiGh1ckTIEwLltG4sdBWtsQw80gAufHTkmu8XOjv4t7FW0Dt5PK1sRr/WE
	96je25WhmuyrF4K1O3hoZLPp6w4Dn8Bw=
X-Gm-Gg: AR+sD13qcmDpCO4B8u20lMEfdG2Xn5mednTp4PBA8F1YleFhDShGLjcY8dqN8kL9qe0
	d8JHvHE/Qc2ssRRjfbpKvu11Qxrtv299mgTEaGnaNAl0BB9BXYVTAh8v36arHDgyhGbr8K2JdJQ
	uz1/m5n3mUA6/sxun5ZKlRrHyMweDFjWggf3BOwNH6wZP0Lr2RnTcCnX4SeJ11BAf5k49VEElS6
	2FclNspmLVbV9p1bGjecJZf4NNXfXqEYT7eXnQo2o3wR6oIEnwGpRIN5GSHfVv8FeC+ZY4tfR1r
	VeVaOMh/LUWJW9iAEw+t/ibXrWmInG8iw/Hv5Wr98D0AAe5rzTIUlYk9+e7+oK6MKPDtq4VSrQK
	4WyidUx0vTj/KFRQ8T+P4MitDOxZ9tmEHY2YeNE0HvK23wWJy9GSb9QtCrsXEQkN4kS8msPq5fF
	BH
X-Received: by 2002:a05:6214:5f02:b0:8f2:2bb2:8f42 with SMTP id
 6a1803df08f44-908147c7b20mr7487676d6.27.1785191769145; Mon, 27 Jul 2026
 15:36:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704052714.428561-1-chenyichong@uniontech.com> <02e13173-b4b1-4de2-a58a-b5627799b94d@chenxiaosong.com>
In-Reply-To: <02e13173-b4b1-4de2-a58a-b5627799b94d@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 27 Jul 2026 17:35:57 -0500
X-Gm-Features: AUfX_mzUIvcagLEcPMY97ckvDzQQlCVjXFrPKdEl1fje-c6oDGlpmD2J9KWOYyY
Message-ID: <CAH2r5ms7f0iOTS633Z=yvSfjwZY-L446GB8-fYebePyDoaOYgQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: free partially allocated transform folio queue
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Yichong Chen <chenyichong@uniontech.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next

On Mon, Jul 27, 2026 at 8:41=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> =E5=9C=A8 2026/7/4 13:27, Yichong Chen =E5=86=99=E9=81=93:
> > netfs_alloc_folioq_buffer() may leave a partially allocated folio
> > queue attached to the caller's buffer pointer when it returns an error.
> >
> > smb3_init_transform_rq() stores the buffer in the request only after
> > allocation succeeds, so the common error path cannot free a partial
> > allocation. Store the buffer pointer before checking the return value s=
o
> > err_free releases it.
> >
> > Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> > ---
> >   fs/smb/client/smb2ops.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 199f6aeb7b33..3fe9f0534e42 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -4882,10 +4882,10 @@ smb3_init_transform_rq(struct TCP_Server_Info *=
server, int num_rqst,
> >                       size_t cur_size =3D 0;
> >                       rc =3D netfs_alloc_folioq_buffer(NULL, &buffer, &=
cur_size,
> >                                                      size, GFP_NOFS);
> > +                     new->rq_buffer =3D buffer;
> >                       if (rc < 0)
> >                               goto err_free;
> >
> > -                     new->rq_buffer =3D buffer;
> >                       iov_iter_folio_queue(&new->rq_iter, ITER_SOURCE,
> >                                            buffer, 0, 0, size);
> >
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
>


--=20
Thanks,

Steve
