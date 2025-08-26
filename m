Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08D38A5E1
	for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756223101; cv=none; b=JB52XLZ+Rhmm294lsCyhAPazL/+R/CMEn48EFWWuY3CeVm80gwCiAnrw2tpvZXxJFCq18UwnaPMRnTfpfAkSUyogPIB4kYu6Hd7/DWCyJ7giTAguHgSjzMz26gRrFhV0UZzg7hnNFEyF+bz5YM+O/4Glvva5dOfNXasu2Q4gQTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756223101; c=relaxed/simple;
	bh=q/g00MJx7okLS3+UTPxLLf3OD2FWm6cfJzz+gk7ayno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MyTExpxL27gc2ZxjLRiAVJDzHO8yAboqVkh8gZbnc/tBmAec1dTCWfNdh1zcH6J90dP/hxf35vksgqpHdZzySKuFjiQfE8AQdhK4PqochriBbHqZoob16RPw+RLRISXuY0l/L27h3CCwKJ72mXcrIPrDyPfUSNvrDmT8KzrDXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Na33Zr3C; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Na33Zr3C"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70d9eb2eb55so23089956d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756223098; x=1756827898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NeEk7H695yr1edEOQ69nU+2Pesh1LqnBQS5EDjqttdM=;
        b=Na33Zr3CktZQVR8VhHN5JAYQLPqNM4GErwAKrGHgq7ghsIxgbcBtnxbcKXGFZwUqIN
         zBmcP3YpZQ7UX1QL2UfVW6N9tMvBI31wXcusd3MCTO6Oofhkc/bokMXS76htQ1n31/+k
         yy03BCRuFEWRu8EMv9WEOaLtO3MDzWLlVfI7TepQjBbsN2uaAxicSV7fW1Vv5SkXGDkE
         XYw3AptPoU9tn/Vw9bG0yE0gss3V9o00M0nS7apqRKc8N/Uq63OrqM8T93eqbg5jUGZP
         nIrT0y9dhhyMDcfj32AcG8ELzfsu8YneIFKqppLknlcb7NWcleExt7yHKP7pInvmxICG
         f1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756223098; x=1756827898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NeEk7H695yr1edEOQ69nU+2Pesh1LqnBQS5EDjqttdM=;
        b=kH6VsaR848spsPzIwUXhsGkTHSe7Eah2kF8Y0an34pGK0HvhgX+EgZgnNIw8pE6pQn
         EN3syKMzJIz73KdbpURO4LlBNLl/xI+4DLn1S02RikBhwBYn5ApsPpOOyt+eZKj+TSz8
         2u9rJYK9MIGtotSURo+i4eT6wm/Z8BCzldTh3iyCdRp+9d/Uqt1Ui3ACMgFzC3+7GEwq
         3WvSYcS+Ls2aBNHoghxumNF93GZxbYONkrYSGtKCeV7X0h2yKV74lNFZiFAzjWZPJfn+
         nFkoKzaIkZH9tlYXdxn2Pl3Azw5CFKD2+DzzHHwTv8CD/MzsU2fb8Vb4Edw26UgjVlEe
         p+8g==
X-Forwarded-Encrypted: i=1; AJvYcCVbxHXwmmuFfX9N2NvwRH+AdgqmOh7pN+x2LMl41xgcyP4EdbV7ssmqWQB/9c+D5/JDBoL2Ud4ZAtQH@vger.kernel.org
X-Gm-Message-State: AOJu0YyMQvgII3W/JIatmVSsa30JdexrMcq5OeihFCV2h71M0hrdz/Wx
	pgtBEEDb3wTlThbHvFnn0+OWws9uA1w2TBO1FUejt4Qb8QaxcvKktJL8F8JxYEMpxNyFksqfpY4
	pRXF2OvZvt+6oHdM5rVHTPoID/okelnRgEw==
X-Gm-Gg: ASbGncs3Vrb+L0lsgTeywzPUzBjFhEILLWnpYpD8EyNNAAtj9kp+t3DQfnx6nUCrdN5
	qwkkokoRJg7x8Om+xN1u9H3M9loMwnL/u7fepxG1tOqqJ2dnOE2IGLEW7ZVMzHz1ZP6VQ4+kwWP
	HFMJ382vb0vGAJlTuTzI/s3xGVsmDedXb8KU+MygAwPeYd1leES3M1n8K9hA1DZNPJZZJbHkdiY
	YCFuZnk1rnuB4xPmaGFzkGyttAfC8MsWSMincM3aegOff9kONpPmhtMJnhkexUh44mkdlg5luw2
	Aq6WzuTt6JusaDwUsYW8
X-Google-Smtp-Source: AGHT+IFAPggm6RcSJHcOxqUdXN5arQvrazkQxcaMlunsmpUuHl6rQPYtlixateN8ljEBguIVYtB4QGzdOV6IHUfqSmE=
X-Received: by 2002:a05:6214:f2f:b0:70d:b89d:f142 with SMTP id
 6a1803df08f44-70db89df59dmr94966036d6.66.1756223098482; Tue, 26 Aug 2025
 08:44:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvpzK1NMmbKE-wUDHLhtm_fiPAp=zVm1egw3=cLbUh38w@mail.gmail.com>
In-Reply-To: <CAH2r5mvpzK1NMmbKE-wUDHLhtm_fiPAp=zVm1egw3=cLbUh38w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 26 Aug 2025 10:44:46 -0500
X-Gm-Features: Ac12FXyR1nVdsJhVHNIpiAglm8OdtkNIIdicBhlNFpm-pGNy4wIvhroKOAeC5JI
Message-ID: <CAH2r5mti-UupbXXQrCRFDF_Bm81pgvpjW05mNFmFdMRCND1bKw@mail.gmail.com>
Subject: Re: smb2_copychunk_range() reset max_bytes_chunk to 0
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I can reproduce this every time with running generic/017 to ksmbd (the
test fails later for a different reason to Samba)

On Tue, Aug 26, 2025 at 10:40=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> I noticed what looks like a bug in smb2_copychunk_range() - I see it
> when ksmbd returns ChunkBytesWritten as 0 we reset the
> tcon->max_bytes_chunk to 0 which causes all subsequent copy_chunks to
> ksmbd to fail with invalid parameter.  I don't see it Samba (but maybe
> because they never returned ChunksBytesWritten as 0).  Any thoughts -
> the logic looks wrong?
>
> /* Check that server is not asking us to grow size */
> if (le32_to_cpu(retbuf->ChunkBytesWritten) < tcon->max_bytes_chunk)
>      tcon->max_bytes_chunk =3D le32_to_cpu(retbuf->ChunkBytesWritten);
> else
>      goto cchunk_out; /* server gave us bogus size */
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
