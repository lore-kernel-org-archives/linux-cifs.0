Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73413242B0
	for <linux-cifs@vger.kernel.org>; Wed,  7 Jan 2026 20:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816178; cv=none; b=qM7uoHB48XtsPMoW2sCw0+O9c068r0ZAebWMuO0Uz5tpqVAKaH54HOJzR67o/y7jCHFXpTLZWlDQsns0+EXfjnBsdO/GHHzWyNM4h6Rtw02TsaC40uBwvm1FaE8RomiqNQ0NQbwIZ4XdJHIzYGzjrPcsye6OXJebQKeBPhV1KFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816178; c=relaxed/simple;
	bh=C56IoC/7pKu7IOe+bmIo3KG0TqDEmn/tNomGMdAluCU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UOSDkfh4DIrmzhvC9PuQhgfWFu1DNAvDAL0PMgBb0nZrbC5YapQMot99qfAWcd0pk12mHT5uvp8QtVwFMvmwmVShowwC9lATQ6dFBavLFXMvzZDzOxpJYMUU1Epk9RPWSgvojNBJb9THjIaJyzKWqvwNCEasBPZv7vjA3n9AeUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fx7DRgq0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRF5tVBf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fx7DRgq0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRF5tVBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767816174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iu+APFi4DB1BEixYf1NERY7bmC13ljDpUozQin2rblQ=;
	b=fx7DRgq0aRftvVxmFO7vKuj1KsVZde4v1libfEZMdoD9L+gYzFLiODi1qbQTOWca2LTDbF
	Kd3yqWncnDze4xMKsAFm7ySOOKwdFQtoeCO3OV/8TJD/o1uom1QmR/FpINyok/ymYVQKx0
	lXpmn7fdSXgRtBgtFowNbGBfbwJ6K/Y=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-6H1gB2ljOgquViKKAtmvtw-1; Wed, 07 Jan 2026 15:02:53 -0500
X-MC-Unique: 6H1gB2ljOgquViKKAtmvtw-1
X-Mimecast-MFC-AGG-ID: 6H1gB2ljOgquViKKAtmvtw_1767816172
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-78fbae83badso44697667b3.1
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jan 2026 12:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767816172; x=1768420972; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Iu+APFi4DB1BEixYf1NERY7bmC13ljDpUozQin2rblQ=;
        b=YRF5tVBf9i7M3G5iQCY/sPLkSHWaxqfgtZHG8OxXCLDNiRf2uHMROuL5CqDEiVHU2w
         c5WLUpgAZQtP/0Aft0cnGSHfWsTEJ5NADIgYAPMwYDio7aQR+iSwtQXOzzQXmIKlHu2C
         qmll2rAppmwYq6Smi+BjH91cYp7fYx/w28rRO1ESkHG04jCpbZUqaC0WxJgFjTUqAKga
         QzG81ANGW42MdRv9UUNnDSTbJeFU/06DUzysqWRbCz+R2NjgAH0UFQEp2MF6am+xAaQp
         0t8phTolrASVZMQx2X8tczyqD6LmGTzrW8zHsyeGqnbUMLMoWPhTDWMtQx1voGAyKkdJ
         +09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767816172; x=1768420972;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iu+APFi4DB1BEixYf1NERY7bmC13ljDpUozQin2rblQ=;
        b=SLtqJlLNtt51Dsym6Gj+iEF+SDaL8QoMMua/neL83G9FjhD7MW4Q2bLYIoQcc35qJR
         hL0keajHKbhwadPIeQcgMxqcby36drdAlqycfc+fTHYMEZm43Xx7zqoKM4iI25oz7vzQ
         J8BmwkOtwFVGQrJwSbjxRBM4AfsVQRxgI9casNdzeug3i/hWIpEBoDsHQFTRqOT3wj9r
         tTBMZynRt0lQLva9l5p7XnMtjGzCYG8J3rYF23eS7+a2gk/+mqxnbd2OQntNxnKw6NVd
         Sw91jakeb4mnWsGg4sKXUxV3ORoxLW64fO4zH62F87JBthhTb3zLyFxpY4kmKPj/PiWM
         nRRw==
X-Forwarded-Encrypted: i=1; AJvYcCWSM4UqRbEGyKri99Qe2aJwg40s4+oNxwva1grYTeRPMprwgczPaDGP+i1IIq3WfMH/xQnn0t0UjtFi@vger.kernel.org
X-Gm-Message-State: AOJu0YykchRjxfrTgcVBFp4HM8hVjfsECrKbVjZcDviz7CVA70RDy5/u
	MXbYy7pOrSATZFaPp9zFbs/TS6/OmeRbmTaJB+UjLJjRdNtykepV2Rg0yN86R1i+H6ZbBKzf3dJ
	XbOm7WtzOshO2JjEkpt9q058irUdzA9bsIyH7TgI3JGPKFhoJnfUrN5UNaF8hQ5U=
X-Gm-Gg: AY/fxX5STeO/LNFN7tKiwd9XX9wH2AD4MG3pYKnWexEuIfVYjSQoL+DMUjqXGQkTUoZ
	zY04tQILcAT9V+MWE/JwR6HXZX4Y6Z44WT+Rs1ysJV3ylb/M5C3LWK2zIECZVQ6qaMbEoTmzmZf
	xgcVQUxCfjsJHGAtxoI7PfU3ULRHPIg5v1NfzqZ1uhzOOlFjwR4NuhgmH9JeiV5+UOJJ7NHjt7H
	KFCAGJrg2c4M0KFmSXrjf0wABbZtSID0ks0G7Ell1gtLGmecESGl3v3nX+qHAQ/xX8XWYW4NP+5
	MjeTtWSB5h8YrEFqr99+GWEOt7BZxjzXWmFWQiiPqa1v15QRQJM3RiclcP/5aGT/+Rc9cDi4NCB
	jOllF0Iyi7cz8z70vuCUfm/DxxvgNIVDvSaiM0wzv
X-Received: by 2002:a05:690c:6002:b0:78c:8cf2:e1a8 with SMTP id 00721157ae682-790b57fd697mr35186657b3.41.1767816172487;
        Wed, 07 Jan 2026 12:02:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFtanv8xfnFTTRT6tEbrRIY8LovgzhbuRiJibqFx8Wg+Ad59na27viUk0nz6iFz80kLE3f9Q==
X-Received: by 2002:a05:690c:6002:b0:78c:8cf2:e1a8 with SMTP id 00721157ae682-790b57fd697mr35186317b3.41.1767816172118;
        Wed, 07 Jan 2026 12:02:52 -0800 (PST)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::41])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa5534f2sm22153297b3.10.2026.01.07.12.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 12:02:51 -0800 (PST)
Message-ID: <591f69efdf89ba02c36b042faa3486eca0cec76d.camel@redhat.com>
Subject: Re: [EXTERNAL] [PATCH 5/6] ceph: don't allow delegations to be set
 on directories
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner
 <brauner@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>, Jan Kara
 <jack@suse.cz>, Steve French <sfrench@samba.org>,  Paulo Alcantara	
 <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N	 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM	
 <bharathsm@microsoft.com>, Trond Myklebust <trondmy@kernel.org>, Anna
 Schumaker	 <anna@kernel.org>, Eric Van Hensbergen <ericvh@kernel.org>,
 Latchesar Ionkov	 <lucho@ionkov.net>, Dominique Martinet
 <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Xiubo Li	 <xiubli@redhat.com>,
 Ilya Dryomov <idryomov@gmail.com>, Hans de Goede	 <hansg@kernel.org>,
 NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, v9fs@lists.linux.dev, gfs2@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 07 Jan 2026 12:02:49 -0800
In-Reply-To: <20260107-setlease-6-19-v1-5-85f034abcc57@kernel.org>
References: <20260107-setlease-6-19-v1-0-85f034abcc57@kernel.org>
	 <20260107-setlease-6-19-v1-5-85f034abcc57@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-01-07 at 09:20 -0500, Jeff Layton wrote:
> With the advent of directory leases, it's necessary to set the
> ->setlease() handler in directory file_operations to properly deny them.
>=20
> Fixes: e6d28ebc17eb ("filelock: push the S_ISREG check down to ->setlease=
 handlers")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 86d7aa594ea99335af3e91a95c0a418fdc1b8a8a..804588524cd570078ba59bf38=
d2460950ca67daf 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -2214,6 +2214,7 @@ const struct file_operations ceph_dir_fops =3D {
>  	.fsync =3D ceph_fsync,
>  	.lock =3D ceph_lock,
>  	.flock =3D ceph_flock,
> +	.setlease =3D simple_nosetlease,
>  };
> =20
>  const struct file_operations ceph_snapdir_fops =3D {
> @@ -2221,6 +2222,7 @@ const struct file_operations ceph_snapdir_fops =3D =
{
>  	.llseek =3D ceph_dir_llseek,
>  	.open =3D ceph_open,
>  	.release =3D ceph_release,
> +	.setlease =3D simple_nosetlease,
>  };
> =20
>  const struct inode_operations ceph_dir_iops =3D {

Looks good.

Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Thanks,
Slava.

