Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924BB4087A
	for <linux-cifs@vger.kernel.org>; Fri,  1 Mar 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709302136; cv=none; b=mhHwJ2QqeQrjFyVTybZD7HJtBEagviTksHt9bXif9dfLC3hhinU8drDd0I7osORTJBiaZemcrxaBbTEuv8rmS+RBOiILEqUr2nY4Dwl69vQjsIEbL2/rHtlZHBLY8RRdWtWIsO3szu2r/whwVyFB6+OpxR9N4eSFdBwbf4OyJ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709302136; c=relaxed/simple;
	bh=iT6JJmiRbb+kh1+RgPYgYNnUnOvZ0AoJcZwUvgBzKnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RtIM4qus8slEv6rHsnV1YHdm0NfGy1c5X0EoUmkPMYnBrKTqJW7RhWAZdls/ueh4ZOBWA/zM+2FTHwXvTJQUJnxC7IGOkwi9DtxsTy1M1n9RTIpi+Jm8FKNLjPyODMKO+2GVUB8K35RRQBJ1PpgHo64wUwIJyTm6GeAPml/QL/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZaRsLJh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZaRsLJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709302133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eZNB7Cp4kFaNUO1dt4k9gvrovl60pZyh1b4xj20qO2c=;
	b=EZaRsLJhYNGkGK42KP6HJwKrLeeQLQyyckxa278quaauXCG4REhv86PrbDju+chiIceiaJ
	akLHTyE+IWqR8M6IaGkTLjuJdi0NnAsF6FLDIj1heXrQhtmORH4ao85CFqjFXiSMV32TQf
	zu2dNGRVrBKNe4QlW5NdB+aUV0CMimA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-jf157Y3INRKCMkPebLhOPA-1; Fri, 01 Mar 2024 09:08:52 -0500
X-MC-Unique: jf157Y3INRKCMkPebLhOPA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d298d601adso14745531fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2024 06:08:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709302130; x=1709906930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZNB7Cp4kFaNUO1dt4k9gvrovl60pZyh1b4xj20qO2c=;
        b=JVLtDMrflDkqZK+rw0teH6wcmbVDXoqGlK3F5II26CrPBX0LqiGFcrUiSwPg9ka3AE
         X5AqAiiqjF1ftpV9rMidTcRsw1j+/bDeVRvHjV11ZDTYTT3LqsgR8NpEKLegz8hxQreO
         kvudCfeWfS5px6BE3X+wMnZiMPQz4vlvsALdpDkm1y+ab4DwD46jLZa1idZ1mVTjwLcj
         EnaJnAyUpCqkS+P7e3lNnXrcj9clpp6oSLhUkds5H0S2TG73V8nrudywGwkh+ve+5KlU
         QFe1lwYKEf1sWeYVWDhB40HCGCMo6ssqNGcgGKl77OaBOclKgsxquxb8JXECb9VO4hka
         tPlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVunYSr+Q7xNW8aKgo0LMRDD+zd6U1RA3kTcm4QfKs5vTDrotn0S10bmAZ7VSZq86PC6MUt4n5VAbC4zemV6x7b2VMulEtG/MlFQ==
X-Gm-Message-State: AOJu0YzvDCsa7Q+Zuuf/GjL6L0dNRpFbZcVO3wNcfN0GCJmTPHtGgYmC
	9t6kQ3fYTtrapHfAFtLy9A9XeDswGlObAWZXrP+dt7Jenn9qrBMsOuuRUdCJyQ/lt0wbUHrFADi
	oMB40fEbiunYTd0e80BM3MK1jwzSdW4R0E5Gku0RZwfWw6GstU7z51cNpiusZjtR3KyzT0np9ET
	yABE/A5Tse33hGZA9813qZg1zuNHC3hbEfFg==
X-Received: by 2002:a2e:a545:0:b0:2d2:c83c:ffd7 with SMTP id e5-20020a2ea545000000b002d2c83cffd7mr1484960ljn.42.1709302130737;
        Fri, 01 Mar 2024 06:08:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSDJeJpN277d+Vv9za9OxHPDSkM2MaL7PivkBpn5DLbwMNlURIgc/uCGOC+jzzIJ/SUczkiXhxW0KtMRkM6us=
X-Received: by 2002:a2e:a545:0:b0:2d2:c83c:ffd7 with SMTP id
 e5-20020a2ea545000000b002d2c83cffd7mr1484941ljn.42.1709302130433; Fri, 01 Mar
 2024 06:08:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230925201827.1703857-1-aahringo@redhat.com> <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAH2r5msWwX7QdXrzmR3tapU85WMga9Y-waNOHm+hMWmWPUF=tQ@mail.gmail.com>
 <20240209114310.c4ny2dptikr24wx5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301103835.gylf2lzud2azgvx7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20240301103835.gylf2lzud2azgvx7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Fri, 1 Mar 2024 09:08:39 -0500
Message-ID: <CAK-6q+jZVfK2=Z6RCCU+K+TLYuHgC4ynqOBz3K-nhcypCoN3ww@mail.gmail.com>
Subject: Re: [PATCHv2] generic: add fcntl corner cases tests
To: Zorro Lang <zlang@kernel.org>, pc@manguebit.com
Cc: Zorro Lang <zlang@redhat.com>, Steve French <smfrench@gmail.com>, fstests@vger.kernel.org, 
	gfs2@lists.linux.dev, jlayton@kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 1, 2024 at 5:38=E2=80=AFAM Zorro Lang <zlang@kernel.org> wrote:
>
> On Fri, Feb 09, 2024 at 07:43:10PM +0800, Zorro Lang wrote:
> > On Thu, Feb 08, 2024 at 11:35:06PM -0600, Steve French wrote:
> > > Could you forward the changeset for this so we could try it?
> >
> > Hi Steve,
> >
> > Thanks for your reply. Sure, there's a temporary branch "patches-in-que=
ue",
> > you can get it by:
> >   # git clone -b patches-in-queue git://git.kernel.org/pub/scm/fs/xfs/x=
fstests-dev.git
> >
> > Then you can see a generic/740 test case in it, run it on cifs. I teste=
d
> > with cifs 3.11, and wrote the /etc/samba/smb.conf as:
> >   [TEST_dev]
> >   path =3D $dir
> >   writable =3D yes
> >   ea support =3D yes
> >   strict allocate =3D yes
> > And set:
> >   MOUNT_OPTIONS=3D"-o vers=3D3.11,mfsymlinks,username=3Droot,password=
=3Dxxxxxxxxxx"
> >   TEST_FS_MOUNT_OPTS=3D"-o vers=3D3.11,mfsymlinks,username=3Droot,passw=
ord=3Dxxxxxxxx"
> >
> > I'm not sure if it's a cifs issue, Alexander writes this case for gfs2,=
 it
> > works for other fs, but blocked (until kill it manually) on cifs. So ho=
pe
> > to get some suggestions from cifs list.
>
> Hi Steve,
>
> Any feedback about this? Just to make sure if it's a cifs bug or a case i=
ssue.
>

I talked yesterday with Paulo Alcantara (cifs developer), he is
currently looking into it.

Paulo, is there any feedback yet? Thanks.

Thanks for the ping Zorro.

- Alex

