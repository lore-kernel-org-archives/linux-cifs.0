Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667FF1E98EF
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2025 11:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736939358; cv=none; b=Id1eriTJv1JdmvgG2TbosyO5c50hBXy7s01IExnUoKbyTWzIZk8C61ktZiL/d+3t5oi2d+A+Ctl4+PDKAgy3S/6KOk24g7ZzMNfvdeP7LmpmZ+ky59LWnxGIIRZORteHDy0Ukbrv83b2wtPD5cIt56UZBSZqjdZE0yCiD+g5nmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736939358; c=relaxed/simple;
	bh=2fSe49bkNrDNkSkvqAS/A8a3rgrNIaZQAyE5547fVTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPau1R20TxXUvYO2v5PpiQuRPn00tzyhjSrTjpmccY1xeQZHc3xDvV+K3G/NQeJvNMEhNwATMdWAMr982yRnp7udTxhECaTUDLHivSTicg/J89XEQibd58gkBWDw9TtOjfJPIieqvNN9YtZgrMIehSFpEBQ2YKFZ/9eVpDhQIgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+GCpO9e; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+GCpO9e"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so1402967766b.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2025 03:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736939354; x=1737544154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reiyifGzvCkDi7U+hQ36D1LYIrQZs6K3CVyjcafuvjs=;
        b=i+GCpO9eCnptPqaeMfQr7qfIjaqky0D6HQVPal//AvS4BEXw+Tlj+jsIAx8/nagjPt
         hkEnGLQk5xUN2/3qKd0FYvPxxKgMeiJ3eefHAXbTRF1HJE8tK01fbQsU0U9j7tJpFxND
         r6BRYO6fXe+xzcE8waVUW+sFHBIWwuqRcUHVR6lo7HlL+h/QGnQvly1Pb6KHAaMgCC7/
         T1GXMolpwCk+uFKh7hJ9kgln0J3qsE4uBH5bDcmW7CaZDW7MBlM0VOxIUjTqFc9ejoms
         E6GjllYx0WC52f549K989wuESZWkX741qYxfzg/7G2aIic7ylKzZchkgnRb38T/qdFro
         y0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736939354; x=1737544154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reiyifGzvCkDi7U+hQ36D1LYIrQZs6K3CVyjcafuvjs=;
        b=QgQBdQIOzEvIsN081QKIUmVJ9hN+30ORGqncNovSwLRbziBZ16yZHCsf9K1uzO3ZFb
         PDCPjfHq47N/HRNBfLrJmBKPXOm3SljhMlDKlcdH2o+t6HsUhfi4AOL0hX49JI5eVOKa
         O+xwcGfS+45uAKkIkVfODWlWBpJjkljLHNRcZ9X9IHZa5YnSDwSApEKxSHat42fAxtiS
         Cc0EPXkqTuC+I556+xLRmk4l/7SkhUBWIpy735pOfH0QA5Gp6O1a5TQB6vfeR0SNW8tQ
         /QzYn0JyydwHXvbNVCTyF8LY9xivW+nVq0s2h0gaIXAogMRZp6WPwSEQBwCCB8y/yOxP
         SVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf9tofGATgJ9VOW2s+hP2O09PacDtaUe/6RYRJg+ODKCs9vJ6fgMjWO7kp4Lmw/PCecBIJt4vFSz1P@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ7T0HWflMaUPqcg9lD8UcSPL8Ed6UI6sh8Kj8Z66nrpzZuSnc
	rK0W2d/Di2HVwwQJ3qe6uPTMUOgsmIk10gNQNeYoaG0BhrQ/4UKv6RJQ/Z1pyfDPZpLLd/UruQN
	R/0jXuu1cTa9YJi/RrgOTI6mvAXs=
X-Gm-Gg: ASbGnctkOM/H1YsyvTwFHlcpowGIYvCfuSvbrEKBefFYFz7qSNpH/TrzJSVaoKoHVav
	6GWx44KcWcOZk1inKQk9EFI9w80/BNlCwD3OO2Uyka4fmrrNUNl9DR5+75Ej06l6kGN3C
X-Google-Smtp-Source: AGHT+IEZHFJVMc2NjYI58D7JHFas9/yGP4uBwGuXkU+zDXlZh71gOJOoWgvb6tBRIG49HbIEwtYSKj5flyTzzH3lXSY=
X-Received: by 2002:a17:907:7e9b:b0:aae:bd4c:2683 with SMTP id
 a640c23a62f3a-ab2abdbe9famr3147774966b.49.1736939354270; Wed, 15 Jan 2025
 03:09:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=o-1V2ea-+Lj+M0h4=syXyJYu73JU3F0dXij=KVwWUTOw@mail.gmail.com>
 <eed163634d34c59bdfe3071c782276c2@manguebit.com> <CANT5p=rEjCwxm8t_zayJ3VGTcXYgBgnSaeFUHwkpuL0DfZY0=Q@mail.gmail.com>
 <6f1f7984ded4a0152854ecc07b0ab56d@manguebit.com>
In-Reply-To: <6f1f7984ded4a0152854ecc07b0ab56d@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 15 Jan 2025 16:39:03 +0530
X-Gm-Features: AbW1kvbX6xgNBKafQOqG2L1n43FwbwmVPEeo6CUFOGXsUuacS25FNi_Mt3PQlMo
Message-ID: <CANT5p=rm6pvyDV9RDG3=YP+83kpqD60YbJE-HwVEoeBewBZ4qQ@mail.gmail.com>
Subject: Re: Negative dentries on Linux SMB filesystems
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 9:59=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > Hi Paulo,
> >
> > Thanks for your replies.
> >
> > On Mon, Jan 13, 2025 at 8:55=E2=80=AFPM Paulo Alcantara <pc@manguebit.c=
om> wrote:
> >>
> >> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >>
> >> > Ideally, negative dentries should allow a filename lookup to happen
> >> > entirely from the dentry cache if the lookup had happened once
> >> > already. But I noticed that the SMB client goes to the server every
> >> > time we do a stat of a file that does not exist.
> >>
> >> This is a network filesystem.  If the last lookup ended up with a
> >> negative dentry in dcache, that doesn't mean the file won't exist the
> >> next time we look it up again.  The file could have been created by a
> >> different client, so we need to query it on server.
> >
> > I agree. But we do have tools to trade performance for accuracy using
> > parameters like actimeo/acdirmax/acregmax.
>
> Do you mean using these parameters for negative dentries?  These are
> used for caching file attributes of files and directories, which means
> they are all positive dentries.
Yes. Precisely.

>
> > So we can avoid going to the server each time if it's within some inter=
val.
> > If the server gives us dir leases, we can be sure that the dentries
> > have not changed without us knowing. So we can definitely cache the
> > negative dentries till as long as we have the lease.
>
> Yes, that could be done with directory leases.
>
> Note that negative dentries are also cached when @lookupCacheEnabled is
> set.
Ah ok. I need to check about this.

My point was that today, if we keep doing a stat for a non existent
file in 1 second loop, each call translates to a server QueryInfo,
unless dir leases are enabled.


--=20
Regards,
Shyam
