Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960C1CD2A;
	Tue, 10 Sep 2024 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725949862; cv=none; b=Hnq+aHxaaNSO733X4anTS/veCc2EG8oVTXRROozK2GSla/h3FyUIU1b34m6UPhB07PpOpdJcFVcBgcQnBpl39gAt6FgXkCtexBhXbUdC80vyfuVBmT/DtTTjLuq1tMfmsihmKWsNruL38yNZyxFv/8Wr407s4KTABQYEcrrAqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725949862; c=relaxed/simple;
	bh=Io/7MUsF52AOl5d2uvn4oj42TQleErWNQcXDVfPex9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lGxK1octWd1Vp+oU2LRwaOVQEmK80fjivNNGAakuTZ8rtbCN4ZdBAKXkuIz2Ge6Aczg2/Fs1Z3YYiUDwN+ixvAJ+zKTf8f02XslC9PLzKkCU4LqkgvlXYN9amv6NioKU738Srs2eLeoXK7MQru/w24SFJ5KHBL/6l2p8akHR46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMlQX/Qp; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMlQX/Qp"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5365cc68efaso3122388e87.1;
        Mon, 09 Sep 2024 23:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725949858; x=1726554658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJ4nrcrs/k1qQl102+7XLuBeo+Tbgkt7HJYe02llZ/A=;
        b=KMlQX/QpJN9JZPSjqmYtHUtrvx4s/aGf0+eiodkEpa1huNY7Y3q5zeJDK5IjJGu0yq
         qDVDGYroJrH4phMNZ7bnZZ5GaDdA6RBaeui+jkrVn2Mbh1Uib+fNVerZgclhDuzIBLOb
         Xl6WUs/o6qOvzrPePjGzaKyreAkQDzCZAwATCWP2+jJcWsjEm26NCQTlE5e5WrA4zPvI
         zwb+H5zXsESg0rDzWac+p/Eo8CeiJmtSoGt17mcyXWMeZlHZ1GQPGFvNCL2Iiob36iq6
         Vd9X4kZjHKfqpdGP/XEYVMzKZLsTuBbKipbjrlQEbTATOla+kpbvEQFWhWqkFi5jyekM
         QciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725949858; x=1726554658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IJ4nrcrs/k1qQl102+7XLuBeo+Tbgkt7HJYe02llZ/A=;
        b=pDTlug+t1UrfZcs7qhImYKMNVJbclbNzWx/K+ovqTegeyTcON+I2dChujv65C7e3qT
         KTPacoT6ijFXp5tslMA7VjFBdj5q5ldE+037TJfVMsdLA/6I2KZF86FN7qFgh+roRtE1
         ynRFoyp1tqJNP8Zcmuv/Hg0uXPRPQ2AeELm3Ibh9E4+LH5ufhRoNUy/CSDuiifD9dShE
         PDRy9jh2fCXlAGvTscBSeZHVPO9ptvzuMiGig8t7BgTdjxZniLAo7CLhDhjNPwQ2X7Zk
         ahInuTipMeOBssENTBVYGId6B4Dej5ab5lX5b4wbwaKIcBQwpRhdF86GNDDyzcQhahh4
         H5LQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1uAARBcrsuA82y8SQi5watP8icTB9h7uNYvoFqBT22iJ1Zec3HGUPoPvyPtwioWLLDobPZ8c5dc8C@vger.kernel.org, AJvYcCU9ffcaVKqB5Rln2cRfYlbiUqPoMqo9ga5JR7PxNGvk9+QUrEYGus2qAbvkQAFFj7xt23zZcCVNIBVvrz2G@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm0cSyBd5GpIPeQEwHrXVQaq2Bi6vJZKBEqenb21Y/5roZRgrk
	Psx784pvvpW9SObChzZkn7Mcrskg7wq3gOtqzF/96NahIWSqz7e1Q0rDBNG0Us3IM0NLcsmvTsM
	d0hSwsF1riB/u5NJn7Ak0xfcIaTw=
X-Google-Smtp-Source: AGHT+IFOSlXYruaOL+tHCjzaJk85XUOG/a0mcGFk1uxlA+OH7ZcZd5T0rFpP0fLi2UIa2L4xIp+c6yS5+vz1sJO5IUc=
X-Received: by 2002:a05:6512:3f15:b0:52e:f2a6:8e1a with SMTP id
 2adb3069b0e04-536587b51f7mr10660826e87.29.1725949858123; Mon, 09 Sep 2024
 23:30:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827085420.76655-1-shenlichuan@vivo.com> <CAH2r5mtEvkw-v6dr7KdxoA6kzhraEx06kosrYoD-p1kmkX7cgw@mail.gmail.com>
In-Reply-To: <CAH2r5mtEvkw-v6dr7KdxoA6kzhraEx06kosrYoD-p1kmkX7cgw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 10 Sep 2024 01:30:46 -0500
Message-ID: <CAH2r5mvfMH6pW=6QwWEKyPHWnvuwA364KwVVirBj+irBi8DbRw@mail.gmail.com>
Subject: Re: [PATCH v1] smb: client: Use min() macro
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sat, Aug 31, 2024 at 11:43=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> tentatively merged to cifs-2.6.git for-next-next (target for 6.12-rc)
> pending additional review and testing
>
> On Tue, Aug 27, 2024 at 3:54=E2=80=AFAM Shen Lichuan <shenlichuan@vivo.co=
m> wrote:
> >
> > Use the min() macro to simplify the function and improve
> > its readability.
> >
> > Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
> > ---
> >  fs/smb/client/cifsacl.c   | 2 +-
> >  fs/smb/client/smbdirect.c | 8 +++-----
> >  2 files changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> > index f5b6df82e857..2f9a1bb6e21c 100644
> > --- a/fs/smb/client/cifsacl.c
> > +++ b/fs/smb/client/cifsacl.c
> > @@ -187,7 +187,7 @@ compare_sids(const struct cifs_sid *ctsid, const st=
ruct cifs_sid *cwsid)
> >         /* compare all of the subauth values if any */
> >         num_sat =3D ctsid->num_subauth;
> >         num_saw =3D cwsid->num_subauth;
> > -       num_subauth =3D num_sat < num_saw ? num_sat : num_saw;
> > +       num_subauth =3D min(num_sat, num_saw);
> >         if (num_subauth) {
> >                 for (i =3D 0; i < num_subauth; ++i) {
> >                         if (ctsid->sub_auth[i] !=3D cwsid->sub_auth[i])=
 {
> > diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> > index 7bcc379014ca..f307122b59fe 100644
> > --- a/fs/smb/client/smbdirect.c
> > +++ b/fs/smb/client/smbdirect.c
> > @@ -1584,11 +1584,9 @@ static struct smbd_connection *_smbd_get_connect=
ion(
> >         memset(&conn_param, 0, sizeof(conn_param));
> >         conn_param.initiator_depth =3D 0;
> >
> > -       conn_param.responder_resources =3D
> > -               info->id->device->attrs.max_qp_rd_atom
> > -                       < SMBD_CM_RESPONDER_RESOURCES ?
> > -               info->id->device->attrs.max_qp_rd_atom :
> > -               SMBD_CM_RESPONDER_RESOURCES;
> > +       conn_param.responder_resources =3D
> > +               min(info->id->device->attrs.max_qp_rd_atom,
> > +                   SMBD_CM_RESPONDER_RESOURCES);
> >         info->responder_resources =3D conn_param.responder_resources;
> >         log_rdma_mr(INFO, "responder_resources=3D%d\n",
> >                 info->responder_resources);
> > --
> > 2.17.1
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
