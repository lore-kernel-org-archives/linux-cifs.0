Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31FF2D77FE
	for <linux-cifs@vger.kernel.org>; Wed,  3 Dec 2025 21:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798018; cv=none; b=OkYw8Gmpd4oK3bOPSf1aEb3kXf4EXF/8uDn+4HZdaV6+T2dJmcvU+L2Y+301YFVMyGNgWs638k9D+Ac+gmbiDFYyAGmjE2GtyFYd5fmzFvtSYwyuzxc9mf8RMAU6VaWDCwwbJLIVImIl3sGRADApIrjptL9bNAyCwZcyfy3y5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798018; c=relaxed/simple;
	bh=4mv07ydDIBDY+yYYyDcrBWUbY7+M8hTG8ElX+6UDZ0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QpQ0sg3a8qRcwdjReOrm578pfgcX8KeOHAiaTBzBnduAA6REQ7UdViWR+A4AxA32E/xY9gj5JsYhB7x+F8JV7UOKONlpKUK5TdEfa2kxm/ViCZqXSXdSezJ6nonHSbZ4R9/1xT/MBRxff+3r4A+k1/3KHClSOsrrFkalfidCNqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JopjRNVf; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JopjRNVf"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee44df7750so2242401cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Dec 2025 13:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764798016; x=1765402816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4dm3yP8EhvjXM7HY/9hUsT4foK9V8lDuxE0CKRUWT0=;
        b=JopjRNVfU98l9It7LMYoUhECOIZCRNVLf0qZlNdpSwpW5jgp0T66PjPIXbWyNoPj++
         3SRcvNaHbMhd9kwusY/dUlBn8TC9ba7eAsfXVOI3qceQQJHvbOCFy/gq913qo+/ewSb+
         RGaF66b1947U5FPdmNczKYBuMREq7O6Sqq+ja3EokwUNNVE1xQOcrehoouzmKMJhj5Gu
         T3z2VluD5UyRB7LdBzOwQlGFlZT0bivIkXWtnJ2s74Ik4tUlm+la5i4S+XN4FpKiylhK
         x70cgbsdtTJvSjd+jzS6OEU5bFS9B9ejKTcTBuzzG/V6T2fdyEFcrezEWyjd2eAfiq9g
         Ifcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764798016; x=1765402816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q4dm3yP8EhvjXM7HY/9hUsT4foK9V8lDuxE0CKRUWT0=;
        b=gfoMOJ8PjdU/HW0/OXoYo+Ia72U3V4ep8fv3i4bxLOyKKfNF6e2Cn9VYaFSmhAJ1qM
         VlhtteLz+Dmh2CkkZRejNz3fmnLwoaXlqvVw5Y2RMKAcYA4HKnCXQ2rdo2/4SXwa2+hK
         vD3ERp591RZwxE9FxAu6ERuRanY4klozc8ayzywPg1oi3I7lof+ZsGoEDlZGWFCYXKOQ
         xZeuES0ldd5roAOjWg/0qCJ/Nr655ACh7mjtSgbVUa4hAl015oiRKZnUEchl7gD/FAcd
         llX4KbK57eqU4fZ+1+yYfh0+/0/7X8L1d14X26+xewageFG618+UH43x4dB6eK1cDTeV
         7M/g==
X-Forwarded-Encrypted: i=1; AJvYcCUqPU++UYpCKOgw029WW1DcNnSir+K0xNLhcVtChJSxkDFuJexgUDpXh74fYyY7PtrOeuf1FcfmGBQk@vger.kernel.org
X-Gm-Message-State: AOJu0YzTmPuvRRfsOOjHj5mcuinghziI1gx+4Sj+QoVnrLkrQFRLy1q4
	mxHvA/bPtvsQCyikp5RyXNRKr5q430lneYMNiIS27LIZNm/u10ApzhMG/Ll+yOZaMV+a+BfR9BE
	uEu1hJZ/+hAQ86KGsgCGrkdjTrO60D2o=
X-Gm-Gg: ASbGnctgxIPy7dsgljsvmi8oEyh3AHZau5TdN0dyziO+tVgEq2tizh3s78SoUwKrQYy
	ZjqqPjVW/bRrs/Gd7atAEzQrLkno2OY2cvvCIgj+U9IJvA7nm6lMHSIzKFP34Zl0FEh4+pr0JA1
	MZrU35c6k5sh+IuSDUkae/HS8EJAE87493yLEOCxKsHzyYRdwjdP6B7R7Q0+p5lVNFO/tiVw88T
	zdGA4++8w+f23vzBJcPwjr7T0wt96bagtYaWMqVFB74rH7mD2kAECG7IxXRL7+EmAN9KyRlUS/A
	MBe8XY30cUbluInn01M4AfX9hlFaFAyKt78yAhowOA0xXx9hwE68AaqwGpYp071wG35JjnE44tT
	/subRN396RgKWw/MH8FTXw6O7uEhZ+HTAyIQuYuXMDRnx5SyJ0Og5IA9/FqmepqzWTrcHza53iH
	Txyn6I2cX/lw==
X-Google-Smtp-Source: AGHT+IG1RqtM4CjFZIoV9HQ/AGJf69t++XxRfMRR9/KEWXX168CW0sh0DFIGvs6Sts+Nzs+IjWJ+CH1r+PDY8raGX3I=
X-Received: by 2002:a05:622a:188e:b0:4ee:4a3a:bd10 with SMTP id
 d75a77b69052e-4f017691727mr61297771cf.60.1764798015667; Wed, 03 Dec 2025
 13:40:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1597479.1764697506@warthog.procyon.org.uk> <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org>
In-Reply-To: <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Dec 2025 15:40:04 -0600
X-Gm-Features: AWmQ_bmPZtnFFmlM888CIxDrVHAGDo88ZyE8SdWbeAXL99pNPNJhCXfBTmmIgG4
Message-ID: <CAH2r5msAgsWfnCt171TcmhvCw39GtQ8nU8SwzrVpP=xw2vGypg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix handling of a beyond-EOF DIO/unbuffered read
 over SMB1
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 12:03=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> David Howells <dhowells@redhat.com> writes:
>
> >
> > If a DIO read or an unbuffered read request extends beyond the EOF, the
> > server will return a short read and a status code indicating that EOF w=
as
> > hit, which gets translated to -ENODATA.  Note that the client does not =
cap
> > the request at i_size, but asks for the amount requested in case there'=
s a
> > race on the server with a third party.
> >
> > Now, on the client side, the request will get split into multiple
> > subrequests if rsize is smaller than the full request size.  A subreque=
st
> > that starts before or at the EOF and returns short data up to the EOF w=
ill
> > be correctly handled, with the NETFS_SREQ_HIT_EOF flag being set,
> > indicating to netfslib that we can't read more.
> >
> > If a subrequest, however, starts after the EOF and not at it, HIT_EOF w=
ill
> > not be flagged, its error will be set to -ENODATA and it will be abando=
ned.
> > This will cause the request as a whole to fail with -ENODATA.
> >
> > Fix this by setting NETFS_SREQ_HIT_EOF on any subrequest that lies beyo=
nd
> > the EOF marker.
> >
> > This can be reproduced by mounting with "cache=3Dnone,sign,vers=3D1.0" =
and
> > doing a read of a file that's significantly bigger than the size of the
> > file (e.g. attempting to read 64KiB from a 16KiB file).
> >
> > Fixes: a68c74865f51 ("cifs: Fix SMB1 readv/writev callback in the same =
way as SMB2/3")
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Steve French <sfrench@samba.org>
> > cc: Paulo Alcantara <pc@manguebit.org>
> > cc: Shyam Prasad N <sprasad@microsoft.com>
> > cc: linux-cifs@vger.kernel.org
> > cc: netfs@lists.linux.dev
> > cc: linux-fsdevel@vger.kernel.org
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>
> Dave, looks like we're missing a similar fix for smb2_readv_callback()
> as well.
>
> Can you handle it?

Any luck reproducing it for smb2/smb3/smb3.1.1?

--=20
Thanks,

Steve
