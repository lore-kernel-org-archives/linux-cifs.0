Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25064071DB
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780756553; cv=none; b=O9NvQPwetAY2iISDFG7/GK0/OhVSINbLT29d4xDnIoGLTO2ysg85j0qvOLo9wbIfG6Oxjd0ZgPYlqKmU3cOp3rB5AvHtqO0zZWNYkfZK8O1Z12DSn3vKv34V0m3gqrU4bX8H0PF0rMHYpd/bABWvePV6UZVv6cc0vY3XX/lwLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780756553; c=relaxed/simple;
	bh=BEBnUeX/RT9tS5iu+VqOnqxWdb6kE39mmRSQ6I4INzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qjy32cw3r64LfDZYXCXpZl+P80wDR+kOGVxM3q+C5U6pU5epKROhtXSpr2yLBzNJV2jLDwhUGFiD4s1hCbaylY/PRLkxM5fCdFikO9Zqr6ZZREsqhMjeoQNe6xtzr7K73ZlFLitQaItsTPvUVG3uGrObAfh2X8uluJGfyn/t7ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP4iD/SB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP4iD/SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA721F00899
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780756552;
	bh=tV0RI6EMgBJ1R6c+XhxWAdkRi6i0AsaO1G1tNclIq78=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YP4iD/SBSQ9pPxjJFW8wDNhrkbuoCoGMiiy2JGO4n6oxGAZfmRCpitBLvxTo/iiW1
	 He+NYZQOexEGxeCU+/PfNXFpx5RZaJRsrKlFDJexPtv8cwfmV/mCksGfY2p5oCOEfr
	 LlaYUFqER1ZFIuoKVvtISQKDsaDdXrKF/QG7WUP5HkqEY3QCwKMFi68xY7vF7vdpkl
	 8Ls5TGD9gUPbWpN8aMy0/qk/p7FgLUqqL/NbxWTnCK0TnBOEJKVPkipAlM9ewRzrBu
	 HFv2mi4c+RcL5cjffRmebXU+PbU3fq88ivd7hVt6hsDGImOoQY9v92yP+t99fK6Bl9
	 z0qQryNwieWlQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-beb1bee8c16so378477966b.0
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 07:35:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+bZuOpgt5FiIsu+wWg9cnhhVlStSTt6tgVJg71DnXVW+gPgX66fO8l5qW/G7vWpk/kcBdWug8Qm9gz@vger.kernel.org
X-Gm-Message-State: AOJu0YyeU4BLaVeigiIw0vieRlVXUW0DdeMs5qxMZObd7rXRN5NHX2Dc
	Kx/rHuX86hRgxR1qs2W5mPCI8Z0N86WenPFJ4FSfQSjocTL+60fk1C87dIeT8xL412YW31u/heY
	NJT6gcc1q0jRWJdsME+inB3fL7K41WJo=
X-Received: by 2002:a17:907:75ed:b0:bec:a1b4:1bb4 with SMTP id
 a640c23a62f3a-bf3a7302f33mr248270066b.10.1780756551104; Sat, 06 Jun 2026
 07:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com> <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <CAH2r5mtmggcLnkBrFOX-ob4KC=v8LmfOGfmzH0X-WR5nxNTceQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtmggcLnkBrFOX-ob4KC=v8LmfOGfmzH0X-WR5nxNTceQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 23:35:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8V9XYaRLFviyBTxLQuWAsvDuab1nmuX_i4v4nY8j6iHQ@mail.gmail.com>
X-Gm-Features: AVVi8CdEyDhr1v9M707U-5DoB1V9TmKzvpIFwAl9PiUb3n6nv9AlGbH91JtCZTw
Message-ID: <CAKYAXd8V9XYaRLFviyBTxLQuWAsvDuab1nmuX_i4v4nY8j6iHQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
To: Steve French <smfrench@gmail.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Paulo Alcantara <pc@manguebit.org>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath S M <bharathsm@microsoft.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, David Howells <dhowells@redhat.com>, 
	"Stefan (metze) Metzmacher" <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 6, 2026 at 10:59=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> It is defined in current ms-fscc
See:
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/62de1=
77d-ed90-4884-ae04-9de52f1180f1

It is defined in the FSCTL_SET_COMPRESSION request but not in the
FSCTL_GET_COMPRESSION response. This patch is for
FSCTL_GET_COMPRESSION. I'm not sure if it's a specification error or
if it's intentional.
>
> Thanks,
>
> Steve
>
> On Sat, Jun 6, 2026, 8:51=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
>>
>> > +int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt)
>> > +{
>> > +       struct file_kattr fa =3D { .flags_valid =3D true };
>> > +       int rc;
>> > +
>> > +       rc =3D vfs_fileattr_get(fp->filp->f_path.dentry, &fa);
>> > +       if (rc =3D=3D -ENOIOCTLCMD) {
>> > +               *fmt =3D COMPRESSION_FORMAT_NONE;
>> > +               rc =3D 0;
>> > +               goto out;
>> > +       }
>> > +       if (rc)
>> > +               goto out;
>> > +
>> > +       if (fa.flags & FS_COMPR_FL)
>> > +               *fmt =3D COMPRESSION_FORMAT_DEFAULT;
>> Again.. The definition of COMPRESSION_FORMAT_DEFAULT doesn't seem to
>> exist in the spec. How do other smb clients behave when they receive
>> this response?
>> > +       else
>> > +               *fmt =3D COMPRESSION_FORMAT_NONE;
>> > +
>> > +out:
>> > +       return rc;
>> > +}
