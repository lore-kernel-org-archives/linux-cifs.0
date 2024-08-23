Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CC210FA
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371607; cv=none; b=QZy25aJJ8D5pXbQJf5jCl4w61zQ9JiI9hhU6NM1MtgteJ9yD1/Cgb5/ohipuY+WX9XholYgZxlIXvlzgZ0VsdgXbDVRHtd9m3GgtZ+xZPDFqq/jBGmG00mvIF8qIqP5aplbgbcG1M9TWlUrOk3YayWi7ad4ok22zOZxZ9vnSMv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371607; c=relaxed/simple;
	bh=ZIyElc0jnr6XH6cfi/XbpXF1RHVM0VQDocMNigSuoT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=em2wHZXMYDFy5/IgX1OHaovsTl6f1m6OEIltomodQgXV/omxkSz0arE7nHsi6Okh41dmxx4eo7d4TSn/20zK19Hgc+BbGbwI4HJywKfXMVjMEzZp6coX43Ky/7KKbAsrOnEWbY5GPIfz1fKLhtZfRVXkh+ZORc+jKxufkK2dRps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJmVekK1; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJmVekK1"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7095bfd6346so1257586a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Aug 2024 17:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724371605; x=1724976405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7Cuj2TprEjUUE2IR1DqpBqajoKhZ6dKS/ngJ4VkFwk=;
        b=UJmVekK19Tjtfwds8zEtwtPuw6F+s7r4OEUh/xiOtsAiUIshwYzCtFOsxnDLpWYSc5
         ceCukldw3QyHzySbpxHAXzlB2ibeMZaLUIZtMyRFxwASZsp8OEfeChBvpBlYBGmqN+Bc
         C1bcUl9WnEnlc+DAdsCAsjUV7hRQLNBeWEnx91NIeUHP3n9PooZiZsW6LckRXrBBIpgR
         67KWlrDmEItD+0+0hKgCpgSmI5ZpX4jRFDBqanB/46CyKaTfidpONg+TlLx6Ik8P9h+y
         iOhsWGAF1cmCBUE9MhWo01LcSkAVF83r+S/GD9SEyHXJdb6oImMU2v/DvPEFd56hetZr
         DYvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724371605; x=1724976405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7Cuj2TprEjUUE2IR1DqpBqajoKhZ6dKS/ngJ4VkFwk=;
        b=eFWUmoZ0w4d5Xr761ctAZw4Zou+RUTZJQNwSWbfz0B5xDGf54IhPt6g7IioTxzCxjj
         fnMlQ5D7+9H9InJJSTxbJTtujyeMqWsH8HBzW1h+oUsXyevL1bfd55vEocNijjOsN9TJ
         RhJWvmMEXICboiAp0GArFzeCAG6dhH6hjiYOlViBOo9sCPLJ5BeYfZ4KR3waU8tlvG5h
         AX/bwe3oarUZ4TdS7vdsVlW1ncOmxqpL/T69phdlM6N4ixFAfNvvU8wnCb5fF7vdxsln
         PqRKhQg1koE/XXkMN7LBP0yWlvsvUQYj3Kalhfb+yMC/egEpmRKSRzXCXPf/s1luRlUf
         rkjw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ3CvkXvguc9JrlouzcSUIMtcKuB04yUPUKGNW8tfipZK2wzBwT3GtZ1mjGCx2/aFoFPQqsNWXlsOn@vger.kernel.org
X-Gm-Message-State: AOJu0YyWxjHPFh0gAWqWLZTph7QP4L+47g3PsDVIFIh4yOkfOpvRfjv+
	1sfW6hzSAVMPXhJKiyniBQmurRsQcBHg372ZR5oYzKHKVDRPIB4enN4cKEmHokHuSEqesr8g7RA
	2FHUXqWYCkVVQnYGa31FiFFgmw7CMstD/0Kw=
X-Google-Smtp-Source: AGHT+IEMZzZMSeHHokoqHn94iWWP6C2jExOZ9WLz+9qeWGpT0lb0kq3QIMv2gzr3rL3OTI/li8SktuPEQhKQgyXpJPE=
X-Received: by 2002:a05:6830:25d2:b0:709:42dc:a017 with SMTP id
 46e09a7af769-70e0eb2ca4fmr539403a34.12.1724371605124; Thu, 22 Aug 2024
 17:06:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com> <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
 <CAACuyFU2va16OGn7_i-Ur-TEic7AW7pQj3c3xrPT1P2HJts9bg@mail.gmail.com>
 <CAACuyFWrejfaYiFU8REzj=uTFg88qi7guL1oQg3zqnDWY-vR_w@mail.gmail.com> <CAH2r5mv-V=H0QF205oZTc0Y3yfUchEyk4Y-QqFvVJgpJhxPWRw@mail.gmail.com>
In-Reply-To: <CAH2r5mv-V=H0QF205oZTc0Y3yfUchEyk4Y-QqFvVJgpJhxPWRw@mail.gmail.com>
From: Marc <1marc1@gmail.com>
Date: Fri, 23 Aug 2024 10:06:34 +1000
Message-ID: <CAMHwNVtLS91okXnESNrja2OWJoN1gebeB1hHeuvMbmHD2Y0uMw@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Steve French <smfrench@gmail.com>
Cc: Anthony Nandaa <profnandaa@gmail.com>, Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you all for working on this and resolving this issue so quickly.
Am I correct to assume that this update will eventually flow through
in an update on my Ubuntu desktop?

Regards, /|/|arc.

Op do 22 aug 2024 om 03:58 schreef Steve French <smfrench@gmail.com>:
>
> thx for testing this.  Have added your tested-by.  Let me know if any
> followon patches or issues.
>
> On Wed, Aug 21, 2024 at 12:43=E2=80=AFPM Anthony Nandaa <profnandaa@gmail=
.com> wrote:
> >
> > I have now tested the patch.
> >
> > On Wed, 21 Aug 2024 at 18:55, Anthony Nandaa <profnandaa@gmail.com> wro=
te:
> > >
> > > I can help with this. Marc, if you can help me with the minimal repro=
 steps, is OneDrive needed?
> > >
> > >
> > > On Wed, Aug 21, 2024, 15:15 Marc <1marc1@gmail.com> wrote:
> > >>
> > >> Happy to help and assist where I can, but I have no idea how I would
> > >> try this updated code. I think it involves compiling a kernel and
> > >> applying the patch to it. This is not something I have ever done or
> > >> have an idea on how to go about it.
> > >>
> > >>
> > >> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.com=
>:
> > >> >
> > >> > Marc <1marc1@gmail.com> writes:
> > >> >
> > >> > > This has been working great for many years. Yesterday, this stop=
ped
> > >> > > working. When I tried mounting the share, I would get the follow=
ing
> > >> > > error: "mount error(95): Operation not supported". In dmesg I se=
e:
> > >> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" an=
d
> > >> > > "VFS: cifs_read_super: get root inode failed".
> > >> >
> > >> > Can you try the following changes?  Thanks.
> > >> >
> > I see that the patch is in
> > for-next@80dd92d6ac7d1bc4b95d0a9f4d7730fe5ee42162, so I have just used
> > that to build a new module.
> >
> > I created a share from one of the directories in my OneDrive:
> >
> >     sudo mount -t cifs //WIN-31GSG2M9E6N/Users/Usa/OneDrive/Shuttle
> > /mnt/shuttle -o username=3D...,password=3D...
> >
> > Before the patch, the mounting was failing but after building with the
> > patch, it mounted successfully.
> >
> > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: parse_reparse_point:
> > unhandled reparse tag: 0x9000601a
> > Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: cifs_read_super: get
> > root inode failed <~~~~ FAIL
> > ...
> > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: Attempting to mount
> > //WIN-31GSG2M9E6N/Users/Administrator/OneDrive/Shuttle
> > ...
> > Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: VFS:
> > \\WIN-31GSG2M9E6N\Users unhandled reparse tag: 0x9000601a
> > ^^^ SUCCESS.
> >
> > >> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > >> > index 689d8a506d45..48c27581ec51 100644
> > >> > --- a/fs/smb/client/reparse.c
> > >> > +++ b/fs/smb/client/reparse.c
> > >> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_bu=
ffer *buf,
> > >> >                         u32 plen, struct cifs_sb_info *cifs_sb,
> > >> >                         bool unicode, struct cifs_open_info_data *=
data)
> > >> >  {
> > >> > +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> > >> > +
> > >> >         data->reparse.buf =3D buf;
> > >> >
> > >> >         /* See MS-FSCC 2.1.2 */
> > >> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_=
buffer *buf,
> > >> >         case IO_REPARSE_TAG_LX_FIFO:
> > >> >         case IO_REPARSE_TAG_LX_CHR:
> > >> >         case IO_REPARSE_TAG_LX_BLK:
> > >> > -               return 0;
> > >> > +               break;
> > >> >         default:
> > >> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n=
",
> > >> > -                        __func__, le32_to_cpu(buf->ReparseTag));
> > >> > -               return -EOPNOTSUPP;
> > >> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: =
0x%08x\n",
> > >> > +                             le32_to_cpu(buf->ReparseTag));
> > >> > +               break;
> > >> >         }
> > >> > +       return 0;
> > >> >  }
> > >> >
> > >> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
> > >>
> >
> >
> > --
> > ___
> > Nandaa Anthony
> >
>
>
> --
> Thanks,
>
> Steve
