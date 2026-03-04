Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3034D38D
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 08:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611775; cv=pass; b=DN4PSKjsBkscOZn1DFz2sKqIvkEb2aEntSWdOV5SC+ywziF263IC1dgdqfIEeo7PqK1mCteTeykz9myIHOuO6ngrMEPwOgaMtKdWHRyYuLTJMaZsO9O1F8Lwx8/oQvcEdZvyNqjtg0X31cBSzEKrtyDv2+/N4C7Q4N7051WuO0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611775; c=relaxed/simple;
	bh=yYrEmbu7IwBZnJitL85TWkse6aGObew1M2PRoI4Lzuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gsnowx9E4W8aCrrj9xsEsAi9o9RhxM2Y3Scw8blyZqaajWEjBTCLFhuGkLjda2W3wXZ0OusehWlhyasHhJy/BnIrFD5ihfQTw1q23cTm9v41stEM9K/l59yuO4/NURJruRttqGfzNB7nP8SBA56kMsk4GobKMExfl5/Gh9/pnvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIXKAwT6; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIXKAwT6"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65fa4713bd3so11135647a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 00:09:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772611772; cv=none;
        d=google.com; s=arc-20240605;
        b=Xju4ynHYXZzpWhLD0ABJqJjAokpfkUETfH6dvlEMaNC1gdLPfat+/M4v6VDKDPWLT7
         R4BmHTFNnLhGUJ9R8i0Q/MFsjTHLMUM8HafpgZF7KL/RT5sS3oIYqUTcUTtym2/ZIS0g
         GG8M1uFBYCnhmTNlIGO0mFdAg2+aia2wzAUxhLVmiW6sAxneob9BcQJ6etI/R9h54mSr
         lzoG7T2T9XfGWvQqAc/uxsGALgyWbQ/I+p5Uj/2HgDs3mEqhJUx/XvgK/d2H93NunGnu
         8XFRrziFJ2DsVaiqGwKgzsfJ4Fl+7CBYoPCfdh1Z+YqnG9A2BjPrVR8mGenxVLLJ2XTW
         Ur8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1xye1Dpk2LN+iT/qxXT0h9wnROPzkAeV5RUbEejPjSk=;
        fh=1FS0zXXO525Xu8gV82s28AdTl2tDsSiUvDU87t2oh9o=;
        b=MnIo51gcJdGwOIixTq6XNGfVo1fuFzHooeEZmnqZx/4P8oug+tGJsVr6dnAlnXQZ47
         B7x1yyA0IqALTrMfTJK7h5XeV3vxGjQrWSdO7+X37Vn2tpfRrllpdDTYbBB2LiXug9ZJ
         zDcCZWzTMNZOz2Se0rjmuKt/ll+oFBY4ek79QqHgGdH3UZmPlLQoMQDseOGn3NXXULy3
         jw1afXlonz0Di5uxoIXm0VnYhrX/bjkmt6wPyFltn61Dx3Cd0EjhRiY6Smh09crm7JKp
         GY9QGTDLYrFDd6bIk3n0TS5H47czs67ghJe7SFbs5hHFtKqQLl94yXxNsLFpVMBXLnGv
         l4PQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772611772; x=1773216572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xye1Dpk2LN+iT/qxXT0h9wnROPzkAeV5RUbEejPjSk=;
        b=jIXKAwT6kgT/U/7cgI9N30typbOAROwZRVDSfUYHFXUcJeKzFyMrfpn6bLvLBtuaht
         Td/U8/DIzowLAdbXgmQ5jMYiJxLGymtf9tL7+Z4rgYBNY2fyBWT6Irev0ZMUa/XlBTu1
         6tMd+qImpP1T6N9a9b/ulozjWA6UF00WQ442E2rwpU9Hzf7BliSY7TMj2PqAHL/BEt0Q
         jdBy5nBaLvQOrd4aRfTOoty6nK9cnyX/gtVnVHGpxP1Fnc1gsZ6zPss09jGvKYTo7B/p
         Iqr4WmToAGn9bLo9T/HOg3VknNUJ2+Mfd3wM0xdUrvFX2FTErqhqfwHQhPoM5+Yf17WO
         gaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772611772; x=1773216572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1xye1Dpk2LN+iT/qxXT0h9wnROPzkAeV5RUbEejPjSk=;
        b=EZyUBbZGAcMW6Y1l96xhC1fIbMQY+5rO/zc/25js4SkKR35OY87xuaZCb1HUqrShAG
         lqekZwzJHygpyPMayiZSAOUK5AAXbgJmvyZxtj+JjJmpMIaGBIGICRNhzJEzZaRpHy/E
         OjLMsuirX3bu3QfNOSjT22ThB/YXDPPPrKwLum6+ZnChN5LdhAm5TW0cDzOqut4LuC5U
         ieqR0ysFDsiM/Ppx8TzUSPLsqniXstFnw5l0W068eVxrxFmmo3cnjR/VWU4XUGCl0aqR
         XVh1/IYW1shYSd2MsjKsG32pdl1KyreaI/qwalo2vb8dpfG4JUzaCQLGTZpdfSJPK4ZG
         +iBw==
X-Forwarded-Encrypted: i=1; AJvYcCW6iJ8APVlshffJZkLKRj5SD+zSHkebxHIs5S6VYvqkHBG6s2g6jI/W028mAU0waK44QTWCArQZCD0m@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3/wHrHgqGeW3YqPcxxce+W+0ug6SsZky4gkmcasYSo3gjuqEu
	yWN7mJdlBU7mixj0+AIVSoPa6sfW0cYVPWd7Sr1H8ZRTWC61FGXKrmVGhJSI4G/lD81qyZXtQM+
	efsJKpk95KlNL51FUwQoNw0OhMiElwqY=
X-Gm-Gg: ATEYQzy7EA9PtyyPia7hcqoLHa7KaQ7FLNS7TpGdS7DHrMJk5ztCOhnkWX2TEQxyeto
	MplEpY8Ec3QOztaD201HlQhafONbRG/MzVC6/8dPvPL4/f7MaA7I9L+byNi3eH2pjsEkf4zeVUn
	pyLwx9V9xG05WY4cm5SMuJgf/yXRzVuCQD4IjjZIKTX/vkrl01ZFCibUM8WfO4BeeXyr6t81DPn
	7QVm6yhymeYuHU5/pYb/4a1l0eetjHM3k0PVDrZLSe3Agj6u4JmM2FgiQcfQbhysItqCx3ySlL8
	EHEBvw==
X-Received: by 2002:a05:6402:1ed1:b0:64b:5562:c8f4 with SMTP id
 4fb4d7f45d1cf-660ef779ee9mr647360a12.7.1772611772139; Wed, 04 Mar 2026
 00:09:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
 <CANT5p=rRqPFdieYHeLqtOLtC0Jr-e9jMihj7a+SgCqQt3YWqfQ@mail.gmail.com> <CAGypqWwJpjNh6ohj6ymuJhLR8x=Zz9SHNx8Uo6NBJXZKjdN9RA@mail.gmail.com>
In-Reply-To: <CAGypqWwJpjNh6ohj6ymuJhLR8x=Zz9SHNx8Uo6NBJXZKjdN9RA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 4 Mar 2026 13:39:20 +0530
X-Gm-Features: AaiRm50RAVg599O1Kq7p-6njPt4lvBF1_RuEISx6FP1G2EiE48v8YIoYn2BKpko
Message-ID: <CANT5p=pqF9Q+633gFj-dYqC8CraDbskKHN=8ZBjDP6RAiE_o7g@mail.gmail.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Shyam Prasad <Shyam.Prasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 11:34=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Fri, Feb 27, 2026 at 2:25=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Wed, Feb 18, 2026 at 11:30=E2=80=AFPM Bharath SM <bharathsm.hsk@gmai=
l.com> wrote:
> > >
> > > We are noticing a data corruption issue in kernels based on stable
> > > 6.6.y. Especially, when a synchronous writes retried after a
> > > connection reset.
> > >
> > > Based on investigation so far, it looks like we are having issue in
> > > the following code path:
> > > When SMB3 encryption is enabled, partial-page buffered writes hit the
> > > synchronous write path in cifs_write_end() when the folio is not
> > > uptodate (!folio_test_uptodate(folio)), it calls cifs_write() directl=
y
> > > with the kmap()'d page cache buffer, bypassing the async writeback
> > > path.
> > > cifs_write() calls SMB2_write(), which places the write payload in
> > > rq_iov[1], pointing directly at the page cache buffer. When
> > > smb3_init_transform_rq() builds the encryption request, it shares
> > > rq_iov by pointer (new->rq_iov =3D old->rq_iov), and crypt_message()
> > > encrypts in-place via aead_request_set_crypt(req, sg, sg, ...). This
> > > destroys the original page cache data. If the write gets -EAGAIN afte=
r
> > > encryption (e.g., connection reset), cifs_write() re-sends the
> > > now-ciphertext buffer as if it were plaintext, resulting in
> > > double-encrypted garbage on the server. The server accepts it and
> > > returns success.
> > > Please let me know if you have seen this issue in the past, your
> > > comments on the analysis and probable fixes.
> > >
> > > Repro steps: Attached repro.zip with repro scripts and instructions:
> > > 1) Mount with SMB3 encryption enabled
> > > 2) Perform buffered writes in a loop (e.g., echo "known_pattern" >> f=
ile)
> > > 3) Kill the TCP connection during writes (ss -K dport 445) to force
> > > retryable errors
> > > 4) Read the file back and compare against expected content
> > >
> > Looking at the callers, it looks like simple_fallocate_range*
> > functions that make use of sync writes are also susceptible to this
> > issue.
> >
> > > Issue can occur when all below conditions met in buffered writes:
> > > 1) SMB2 encryption is active
> > > 2) Sync write path: Writes reached SMB2_write via cifs_write
> > > 3) Retryable network error for writes: When EAGAIN or ECONABORTED
> > > returned from  cifs_send_recv().
> > >
> > > Here is a the sequence of operations leading to issue:
> > > write(2) syscall
> > >  =E2=94=94=E2=94=80 cifs_write_end()                          [file.c=
]
> > >      =E2=94=94=E2=94=80 cifs_write()                          [file.c=
]
> > >          =E2=94=82  iov[1].iov_base =3D write_data      =E2=86=90 pag=
e cache pointer enters iov[1]
> > >          =E2=94=82
> > >          =E2=94=94=E2=94=80 server->ops->sync_write()         [file.c=
]
> > >              =E2=94=94=E2=94=80 smb2_sync_write()             [smb2op=
s.c:]
> > >                  =E2=94=94=E2=94=80 SMB2_write()              [smb2pd=
u.c:]
> > >                      =E2=94=82  rqst.rq_iov =3D iov     =E2=86=90 rqs=
t points to iov[]
> > > (with page cache in [1])
> > >                      =E2=94=82  rqst.rq_nvec =3D n_vec+1  =E2=86=90 B=
UG: payload in
> > > rq_iov, not rq_iter
> > >                      =E2=94=82
> > >                      =E2=94=94=E2=94=80 cifs_send_recv()      [transp=
ort.c:1305]
> > >                          =E2=94=94=E2=94=80 compound_send_recv()  [tr=
ansport.c:1071]
> > >                              =E2=94=82
> > >                              =E2=94=94=E2=94=80 smb_send_rqst()   [tr=
ansport.c:427]
> > >                                  =E2=94=82  if (flags & CIFS_TRANSFOR=
M_REQ)  =E2=86=90
> > > YES for SMB3 encryption
> > >                                  =E2=94=82
> > >                                  =E2=94=94=E2=94=80 server->ops->init=
_transform_rq()
> > > [smb2ops.c:~4398]
> > >                                  =E2=94=82   =3D smb3_init_transform_=
rq()
> > >                                  =E2=94=82     new->rq_iov =3D old->r=
q_iov     =E2=86=90
> > > SHARES pointer (not copied!)
> > >                                  =E2=94=82     size =3D
> > > iov_iter_count(old->rq_iter) =3D 0  =E2=86=90 empty, no copy
> > >                                  =E2=94=82
> > >                                  =E2=94=94=E2=94=80 __smb_send_rqst()=
  [transport.c:272]
> > >                                      =E2=94=82  =E2=86=92 crypt_messa=
ge()  [smb2ops.c:~4280]
> > >                                      =E2=94=82     =E2=86=92 smb2_get=
_aead_req()
> > > [smb2ops.c:~4196]
> > >                                      =E2=94=82        sg =3D scatterw=
alk from rq_iov[0..n]
> > >                                      =E2=94=82
> > > aead_request_set_crypt(req, sg, sg, ...)
> > >                                      =E2=94=82
> > >    ^^^  ^^^
> > >                                      =E2=94=82
> > > src=3Ddst =E2=86=92 IN-PLACE encrypt
> > >                                      =E2=94=82
> > >                                      =E2=94=82   iov[1] (=3D page cac=
he) is now
> > > AES ciphertext
> > >                                      =E2=94=82
> > >                                      =E2=94=94=E2=94=80 kernel_sendms=
g() / sock_sendmsg()
> > >                                          =E2=86=92 sends encrypted da=
ta on wire
> > >
> > >          =E2=86=90 rc =3D -EAGAIN (connection dropped)
> > >
> > >          is_replayable_error(rc) =3D=3D true or cifs_write while loop=
 detects EAGAIN
> > >          goto replay_again                    =E2=86=90 loops back wi=
th corrupted iov[1]
> > >              =E2=94=94=E2=94=80 SMB2_write() re-sends...
> > >                  =E2=94=94=E2=94=80 smb3_init_transform_rq()  =E2=86=
=90 encrypts ciphertext AGAIN
> > >                      =E2=94=94=E2=94=80 crypt_message()       =E2=86=
=90 double-encrypted garbage
> > >                          =E2=94=94=E2=94=80 server writes it to disk =
 =E2=86=90  CORRUPTION
> > >
> > >
> > >
> > > Modifying SMB2_write function by adding payload to rq_iter seems to
> > > help here. Need to further test.
> > > With below fix, when rq_iter size > 0 code in smb3_init_transform_rq
> > > allocates fresh pages, copies the data via copy_page_from_iter(), and
> > > encrypts the copy instead of the original.
> > > Please let me know your comments.
> > >
> > >
> > >  rqst.rq_iov =3D iov;
> > > -rqst.rq_nvec =3D n_vec + 1;
> > > +rqst.rq_nvec =3D 1;
> > > +iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> > > +              io_parms->length);
> > > +rqst.rq_iter_size =3D io_parms->length;
> >
> > Another option is to initialize iov_iter_xarray with rqst.rq_buffer,
> > similar to what smb3_init_transform_rq does. But this should work too.
> > Changes look good to me. Please submit a formal patch.
>
> Thank you, Attached the patch please review. Also created the minimal
> repro script with network disconnects.
>
> Further investigation on this issue indicates that the issue is not
> specific to the 6.6 Kernel; instead,
> the issue can happen in kernels <6.10 including 6.1, 6.6 and 5.15 and bey=
ond.
>
> On older kernels ~5.15 with deferred closes may reduce exposure
> because deferred handles might keep help pages
> in memory and which may help writes to avoid sync_write path.
> But commit 262b73ef442e (smb3 client: fix open hardlink on deferred
> close file error, backported till 6.1) appears to
> increase the likelihood of taking the sync_write path because we close
> deferred handles aggressively in some cases,
> which makes the existing encryption write corruption bug easier to
> trigger. The commit does not introduce the bug;
> It increases trigger frequency for writes taking sync_write path.
>
> I will send out this patch to the stable mailing list separately.

Looks good to me. My RB is already added

--=20
Regards,
Shyam
