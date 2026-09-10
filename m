Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13748471246
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041716; cv=pass; b=JRcAi72a5i+S/rPVgK2G4YshJjyLsRXuH9Ju+lp3FSdUOhShjcc6cwSTycMMtIkFEiqIExyC9Iy6JMy0IXFsHjtsNXSw9gYhi4G8ousSf7WSOurAbW9ztv+q/hFddtEHqX8i0cVBCJEQ7jDJ67njs7ySigca+m/ldplqT7j7wNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041716; c=relaxed/simple;
	bh=5X8NDK1IvRp7a4aAJHX5rGeSw785JfBRLyXBlvisMsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVDgdCc+HPRhHzoz9ggUzkBaVPmfqFs0u0XLdfNQANbbZwN+tWi9NYP3YUXjjTxKHw/T6XwzcqT84PgKrqWM0tgbbiBS+HwA7Vv+wjFYyOvCsWcDoBCGiEMg6vCy/jZHFOTa5F5Cs/3j+Xm2fedIel+byiu9xFk8+FfczVesLK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VCtsmqVn; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCtsmqVn"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a67fa7a64eso2073600a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 05:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789041713; cv=none;
        d=google.com; s=arc-20260327;
        b=l9RzsEntevETi/GEI1PsRZSlm99JCJsM1ZTxwLn7TllSMkpbFHKTh/TK7Y9bcP2OBU
         0FbwDFzPeTZI4850mhlMxX3xEZlHC/E5lOvIVJw2gPrQx/nYdfXzI/4qh3rbiVKALO/0
         TldvNz9/8ZOk2JzxyBeIsf9ItxAd9AHISWo+9SjzjYR2BnVtJ5nD7ZMvs+lndErGNPK0
         qwjHS96mlV71wThr+IIRMozY0PYSEYkCa9S0ZcAVmxsrUDUk4pD/u/zwd+LhHW7iRe+i
         lGrscV6buxKaLPzj5VEZp6d2sOm71CK+S4LQ1hQCZ92j2kEzkH9IrNu+TfHfUviyguDH
         c+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1EZxOZZtHFabv0Jm4eVjpJOKmFRnvvaSJb+bZq+jrHw=;
        fh=Ui3saCFAombT+YlVMTZJ2dgjOz22CKwvVfjicK6STNw=;
        b=Hdu37HcAkUmPBICIPSfcKvwlAysLu2lBnfuSprLs5oAWcW4+3RijAG8JW1Ij4uG6Uu
         W/iySTKD5G59St5svd5JOVJAzqLLVyBpQZ70Ai1LiwqdGGu1BEO7SmFy+Ni1IKwtev1n
         dxcwT/FIoTIhr4wAmHXA/fhd2n0gQAxaAsvv4JjULM83Zp3MnUP9wQ12uaQFaVLwRD+l
         25/irVPE3EmfVhgRYcCdO78o9nt4rZUwmss6Mh6fxMgoCP0VEqI6PE5JisnV0jjRov3d
         g/+gCB5fHOUJXQOHlkVMS0fmQOlaEW8kGZ3mZHJyxpX2frAwAQcyLzW3P222DRn8NjcI
         yWQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789041713; x=1789646513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1EZxOZZtHFabv0Jm4eVjpJOKmFRnvvaSJb+bZq+jrHw=;
        b=VCtsmqVnnaeMvZWR8L4pAkB7f/tRq7OfDJUbHnWUXytrD2SmTQPk8AX/Qntib9ztxt
         aXVcY/TUhbeeWkH7gnyeB1FtVAUNwH/yQ8PCBCDAUH3SkfUap+gIz1eYfjRyXghM6ap4
         gx8Se64N6NENfw7b5GvC5z8k/74vBcOStM3cDSc+qbMktR3xJi6pdMYtqYRntzV2yg/1
         DzFZTWtmu70Cm7CUVeLb2T2/NYRMR9aLu6SWeRCvo4X8Kws6FZK5OFVf5SYbnHg0fN0S
         BAPgakqEN3Ocq2lWZNkZOrEsXEd2CowX4SKfk9iYaIPUdw7Xmszby7knjD4tHIm0B2Qm
         IZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789041713; x=1789646513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1EZxOZZtHFabv0Jm4eVjpJOKmFRnvvaSJb+bZq+jrHw=;
        b=Ro5KsKd+uRkl9OjYxnPC/h7/vz6VY6H+aMfeHc6gwAi/8T6a+a5BR5xEKPyISUGWBZ
         q6UpYOab/3bqcQ8wsDAReIfea7DGbDRMlKLQfLeUKDrMatw9HCIXhD4Oi5ZuMHLSsIuC
         cW3mehkaBIcdXRZhTiYhuUVYVN51H3RpYIZAzcGIctwCkYd1AvY4cpdqMmvU4X+cQtDl
         Qz/kJe8X5rNbX9RFgMG1uw6TchP4xB2NH9t8ik4lgx3Zdlr/ofmIqhMb5/rUIyIuvA6V
         A2e6D1A7jEvO2rTM9zrsqeGyG+m6sL+cYm4cABWLtjmTX/DhoXR5/RMzV4IgqkDPQqkL
         n52A==
X-Gm-Message-State: AFuF++lQBLH+SCAbAu9vzYAQqe9Fq+mPPMFTQC+lUxnx9nCsBTlJwkvQ
	DhpcCfBMQybUFi3cD38VUBc69d6DJTaKWXdmlWXu9l0DVfkgP04jxh2W+dOJuLC1AGIjJ4FC45y
	uVB1G9JWokp/i78Dmh/dFjJ5GOCtO41k=
X-Gm-Gg: AYBFou0Zom1xFNlIFXhcbeQ1/jRfSqpPg22D/Zl737nuA2jJEMriGPQZOzhChIgjeZl
	3uAjbZ6HyZuTuVWP6lbsrBdgIK3LOrF/FuWK0s7YvHfuFGh/nwxbJQcBAqM/YZIcJAIKy/DeN6r
	CH8eoQFIiU+PUL3MGQ/acuFwyKu94hxdWcgsX6uPy25q/tFr0G/zMKB+Q98OvVyObNN3Pm9c9pe
	uBZWPS/GaDKwLP5Pd5TPCZfiSX1VKXpIRDaOtjDQC0x5nvcb8OTyA/gBl9tz2t7Xqh5RNjE0oGS
	V3Z8eSs1POBDqRDivPZRo4lioSJ0V2xBj9bXz511BlIR8pmcM+NfNg==
X-Received: by 2002:a05:6402:194d:b0:6a0:a4f5:f4eb with SMTP id
 4fb4d7f45d1cf-6a99caa4a32mr2736469a12.4.1789041712693; Thu, 10 Sep 2026
 05:01:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=qCCdnFsDYTE0vTsBpD48ZkeVsb7=y7roczn61Kz1gtOw@mail.gmail.com>
 <a4af8859841207a11fb6daccd7132ac0@manguebit.org>
In-Reply-To: <a4af8859841207a11fb6daccd7132ac0@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 10 Sep 2026 17:31:40 +0530
X-Gm-Features: AcwNN1WDBs9jAO5uC5QOj2GEcW9g1cbWUBECNrpQ5NhqnGMYEQAN-4J9Iy1uOn8
Message-ID: <CANT5p=phx4OqBSbki3RQBGwVQSFtiK7rvhQ2_KUD8aVbbyA8rw@mail.gmail.com>
Subject: Re: Soft lockup with 7.3-rc1
To: Paulo Alcantara <pc@manguebit.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 9:46=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Hi Shyam,
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > On one occasion, when I was testing modefromsid,idsfromsid (which
> > appears to be broken btw), I observed a deadlock during umount.
> > Attaching the system logs from that time.
>
> Could you please be more specific in what exactly isn't working with
> 'modefromsid,idsfromsid'?

I debugged this further. The issue seems to be due to a combination of
modefromsid,idsfromsid and handlecache.
We cache file and dir attrs in the dir cache. But that does not fetch
security descriptors yet. So it falls back to uid/gid,
file_mode/dir_mode values.
There's a fix needed in my dir lease changes. Will submit that soon.

>
> I've quickly tested it against Windows Server 2022 from #cifs-next with
> kerberos and it worked for me.
>
> Please share the server type, settings, full mount options, so I can try
> to reproduce it.
>
> > Does this look familiar to you?
>
> Nope.  I recall seeing some lockdep warnings among those paths in the
> past, but I wasn't able to reproduce such deadlock.
>
> Unfortunately the dmesg output is incomplete and we can't tell who is
> the actual cifs_tcp_ses_lock lock holder.  Possibly on CPU 0 or 4.
>
> If you have any reproducers for the dealock or 'modefromsid,idsfromsid'
> issues, please share them.



--=20
Regards,
Shyam
