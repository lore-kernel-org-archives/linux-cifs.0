Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5F9223311
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 03:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880728; cv=none; b=JRJqbFZulUDSGWnhz2ndAPcRbcaSJqzN5BfosyizcitWn9Z3NikTtOOq6uwQaAj7cJbGXWMt54oeq71XOEkRWRDYdtO+yY8gHyO9E5U/x3iLSsAv5N684o8NNfT6jqWAbbkV0p1IZ5ZslH5YV+6V5PCRhi2PJx5DRXLSe1FPzi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880728; c=relaxed/simple;
	bh=H8ADnCT7+XtmnLo/t/7jpWENWaN9J4LAu5C59CyV8f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alAcSUOLSdweOY287uI2fDF6h5MsQbjazWCUmCes8zd4O8jj0mslfT+xGL4B+XmBulXsCKPcoZDuQEATNTnEc2wZWnblJrlQwoegRGJVi+7Cw/UIWv78aXDtHMWtUW0V1Y+B9vCDUOXXMLyN+XyInZs6zOiEmSyvuhnerFDR8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hv74qovj; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hv74qovj"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b6d70df0851so364842066b.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 20:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761880724; x=1762485524; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m56MSCi9GS2DAUmAGO0m1PhXXJaDS1IMIajpI5QUjCY=;
        b=Hv74qovjUcPjRFSCpuImxbbFdSADhw2ZdSSnyQvDnK5IhQgP37K37XGbQSQVcqeF7w
         gfIxPAJSW4GtttTZ06Gcey5CEIxMirJDslZREzXs6NxVS91KfWrXnIMxXWaXFpWdBgl6
         OpnueKjtpHsxZDB2k1TziSEZ+e0CRgg4hGVWM4Ql/1zn/WfzaY/AgrTWZ37rOhUcsdOz
         ioqQ0h8Ug3NyumaI6fvFVf7vng7VaKB3Xjm+WtcF/70Fli4iYtqCuh/BGOByGs1HX56a
         nN9mFdulF7z9rMZ/lfWfhh+wUm5IVd32guBLsmzoGoe4Pa7wemSGZL2496OPkgmWRwVe
         l9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761880724; x=1762485524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m56MSCi9GS2DAUmAGO0m1PhXXJaDS1IMIajpI5QUjCY=;
        b=jbxsomkBALg+otOVgadJQb7jJtc3zY/DtBhvr6u60WSJ1OhfnBpUUzC8ECdko8qrfe
         x+1Y4UQIUE0RKgLb5bpEQf1LwA9MxcSiVyIJ4ULuB4NiO9iK2/hhuvG6WgCtR7MKneuC
         DINh+8ICvd8UQwJUyBoWTN+sQ2Wd3meNqkpfyfPW4Mx3GMRw6jdZpDAoVph9Sn5TWsZF
         8YZMsAmdc3ArTgPuC6H3q2hz1ExQrsCtwQj/1SmcT0F2aaM7Mnv8Kd64nDUlBaoZZZm7
         V5pJj3VcNbHRwFwxFjwF3NgTrH+m4GENuLoNH9RoAeGC42eLYcI6yWTidkqP1LEghNCK
         dLOw==
X-Forwarded-Encrypted: i=1; AJvYcCWCWICA/0O3YONQ3X0b9n/lDttyfr8Ane5WECNv9kaZlRQ0drMy9Xc6tObk3e/Uv4jQCURd1CK0phol@vger.kernel.org
X-Gm-Message-State: AOJu0YwVebl7c7v1a+wh4j3u6y3KTVDuBZ0JbTdSr7EditzfKpe0uBqs
	H7uMpzmNo7jgLjeV+/MtBRyT04xS6aVCYd5YuOSLOU9CcWGv8ckuCGzREiqol8ubJFwr0eoLQ47
	DuPjy8Cbk4jAoaMH4R/v8DXq30ly52Pc=
X-Gm-Gg: ASbGncvxd2g8kPx2GD3jhKYfhPZxKg8p/YAOcovNc7h7Vf8E6B2b3EmG8cMSK6D6DDT
	x2rA9xH5EYIJv1r3/w7fE7A8vQufXPzSls5z3MaGvAq0J/wKXisKf2Ya9RNIyYrpjeO4W/V8fb3
	B78Gz+iwKjBZNBKFDVlnyAaD2z+1vuDK3fh7ESWX+eu9qb+tCMjrrbVFF30jSM6TxGPS8TEih2E
	yCJK4AzBhV9FCYa8Us7ZrdeE8oFfzJ9x+924iCr1m02Saq/CGltzagyDK/E+Jj6t7Kfi7E7k6Gf
	T0AB
X-Google-Smtp-Source: AGHT+IFf4/f4waiiynFlzSFaW3MAv42hx+VykCHoNAFRcd7Uim8FFULynsfdXEzGAZSppucIkdK483TZcymapU9M4pI=
X-Received: by 2002:a17:907:1c09:b0:b70:67a6:ce9c with SMTP id
 a640c23a62f3a-b707089f865mr178665066b.62.1761880724264; Thu, 30 Oct 2025
 20:18:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com> <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
 <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
In-Reply-To: <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 31 Oct 2025 08:48:33 +0530
X-Gm-Features: AWmQ_bmoOmuHGdp8BFePG1f8ILtaAl4pQ-EmLWApsID7NTuu1MqUhgm4cVQMp5E
Message-ID: <CANT5p=pnXLDyZMVoKdUqTzPB7dxj2kd1g+2FfzD8LS4+8LyODg@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in /proc/fs/cifs/open_dirs
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Paulo Alcantara <pc@manguebit.org>, Bharath SM <bharathsm.hsk@gmail.com>, 
	linux-cifs@vger.kernel.org, sprasad@microsoft.com, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Enzo,

On Fri, Oct 31, 2025 at 3:42=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 10/30, Paulo Alcantara wrote:
> >Bharath SM <bharathsm.hsk@gmail.com> writes:
> >
> >> Expose the SMB directory lease bits in the cached-dir proc
> >> output for debugging purposes.
> >>
> >> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >> ---
> >>  fs/smb/client/cached_dir.c |  7 +++++++
> >>  fs/smb/client/cached_dir.h |  1 +
> >>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
> >>  3 files changed, 27 insertions(+), 4 deletions(-)
> >
> >Are you increasing cached_fid structure just for debugging purposes?
> >That makes no sense.
> >
> >cached_fid structure has a dentry pointer, so what about accessing lease
> >flags as below
> >
> >        u8 lease_state =3D CIFS_I(d_inode(cfid->dentry))->oplock;
>
> Also, I don't think we can even get anything different than RH caching
> for dirs.
I don't think we can make an assumption about what all servers return.
I don't mind dumping this extra info about the lease state.
>
> Even on RH -> R lease breaks (IIRC this can happen), we don't handle it
> and cfid is gone anyway.
>


--=20
Regards,
Shyam
