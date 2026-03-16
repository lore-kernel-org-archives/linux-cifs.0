Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D77B3DA5C5
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773685580; cv=pass; b=ZvNm5pVnL6FblBdYGC8JXH0SoYuy1GLr5qkVSd0cFByPF/+PYkgPA94Scas3vTT2j9kU6srfmrU0cIugQI8fphzzkEzbJJoqEbfX+5ycM9nKzmVa5xnW7Iy5/rRk3f9U/oUEK5RPtY/GT5XJbMxPfZ44zBqinH09Ev8XyYoB4YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773685580; c=relaxed/simple;
	bh=ODuNhgRZuf+DphxmAeK9W2ttr4M7Xg3l+26yw6FQlUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OWckWpzV2wdx7HfJ+vHY8u7PVJkedtoNHPaz304/V3WRQWuMsLhpmEc9t+/ZJgksICZ0lQabKEoR+u6bu9X3FjPJRnbuKoWXYXHX4FwztsVAYBgFL/dEen3+AG1i/dyrW21Z53fRR29mHe/WRYmV34ouLRNknAHRkfLkwR5+8xU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eb8ho7fp; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eb8ho7fp"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79800183233so65387267b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 11:26:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773685573; cv=none;
        d=google.com; s=arc-20240605;
        b=RSiBvQyPkkdf7n5BcQZH6kmC7dX6phlcBTpdTomOrNPe/KnklNmJec3hQOmgNgWLuN
         rh4GbKNXbpS+DBXFT7J4pjYTfYD9JP9RmJGjFN+6+esG2fUIrCuY0c3b/X7Q0klr8R0M
         8sdzSfhWhnr4Cj3sm6/nWUai5QFHClPB77EU85wogeHx1k9TwbM7leWyKgkJK90/WlYF
         Jbiu8gHBkEK1bkR11Cci1yM2lIY0gGAmRC5h19WKhATfHxZ5AepHEBJgA5EbODPXzES9
         S83EI1rvq6aeh85PkVpvjFNR6R1tWkWFvw6ZGowR51BpKlqqBC3iIi+iQNeC73TSx9Qx
         HiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3kkpPvX9iiQRabDqcRFUBUlzbFZGaOhyaGyOhqlkCgw=;
        fh=HtMMkX+9jLy36jVCaNidWlppEMMNJvujRJJ18mM1BN0=;
        b=Vd9t1tIJ02AtaVNcRN7/TdLhFSOEaSTbm8jj36p9DPBqMnhuIjEmaEMGkczvBVNSkr
         2r9E/GwS+bqn3+2wEawEj0ejsII47mds7M5VhfvxqxYn0iqa3JgtGiwObhvjEzIe1jRy
         7omO44r5u3crp5eg2PZIkhUGlx8efq631EvaAA/e5p51keImDcfBtDPI7r1sNjxR5Snz
         ACHC+DfdLAsP5QjzYwzyVxF0Bwhqsrcbj5WBvTc0VnQKL6QZwx8J0Uv632qPGfjcxBHH
         FlB1VJunUFsvqyJXNOzGKYxixxrA6rzVPOvnUd+pFCCBQ3QzY0sN6rG+4L5bXRuzyY+8
         vt/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773685573; x=1774290373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kkpPvX9iiQRabDqcRFUBUlzbFZGaOhyaGyOhqlkCgw=;
        b=eb8ho7fpiAzg5iccyn/x+a7GoFAwWxs9bcZfq1i6xtw7pWMV6BzJSeMtWybj74fQiS
         zdKNO6eNir2HBrzL32QlwfziAlfMDZuRBI6ARrSgqxiRVmDyw6X2N1EKf6SRXBFMtLlV
         jja6mVinICAR9kX+cGNnYbi3v8DQfMpk0bPbCpoqg77Zh8boajP/9YmfgEFrbSFNwCYa
         mctG+l58XuZNz842eOvRcLfDWfeeMZYDWGYUWs8BQdqiK7VekRJ4S88vrVeNCC7H+dzv
         cWCkc9o2ApQV/J/GQBLKWN4s56kRRuN6mpqpKeoEqa2W3v6cmY/qtL8L1myl212SwUbE
         E4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773685573; x=1774290373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3kkpPvX9iiQRabDqcRFUBUlzbFZGaOhyaGyOhqlkCgw=;
        b=YrIfZdX6z9m6lzIka6OWIpPtAOSM6Y+S0gvnffsS3aZc2P/UUWYhVUbQOtam7DxmDr
         VOwuUJD/dh7PD7VXHCtFEPkbjHVbErVpdMJlZ9SUfcCMN2Ae6/vc4h1gAeGOrOmOp7AH
         9gsKiPc5eiDa8iKu/Zo25DDj9hXj5bn7fRVqNIitFQjdfQ5SZydRW83x4K1VyLEOLl9H
         U8klrESokjj19Gog8iGNY6KiG3uqAJV0Xx3ElmdU456oJwPcxUF90XPe8IeUBewGz7So
         ZzqSpEa5ZV9rpaJ+Cp21woR+Op/pAJ2Dkulzgk+cU2ELd5NZrn6+/CVRWDJbDSXf0v+y
         cCDg==
X-Gm-Message-State: AOJu0YwOuVe5XAx+6y4ttk3apoRHhOZ+6P1QtgPtoADTMvANrCnQjZJO
	Asr08+liBIe5DNXnE3LZBx164otkue0MHuyJRxflwH2aXJEFkyXtdSnACftgcUSok/A7VmrlqfO
	Q1U3BAxwvD+UB1I9kVmG9YOpCnR8Ny9s=
X-Gm-Gg: ATEYQzzgxyEe51aTDtNyXzTNQ8I/ZJqJ96SbOv0V7xesa90bcIWpYngDDGw8qxiv9Yo
	u5BJFW0y0+Qu7pL8ySLigOXjWGVA6TkDWs6O+2plPULx9qONHZ+RwXHUEPH2rPA4fgHssvHrAJI
	LQcnbpyH/ZXmyj2Q3i1ezgZgm2la4Hy6CU5kqpC+TKwpcE2vUnu/HZ+G0H6u5X3eqbdgW7YrHHE
	4dOU3EfShv030GMZI8PhgJXqg8LEtF46modva2J1a2pfSeTFEQRvG2ZAcuWXORN7swngstJiWmb
	uIjuqZhBfCtOJ8P/+XJRtnDFLES4ieMNE+Rgc1M=
X-Received: by 2002:a05:690c:398:b0:799:1913:1157 with SMTP id
 00721157ae682-79a61843aaemr6579057b3.16.1773685572704; Mon, 16 Mar 2026
 11:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304140452.1606662-1-bharathsm@microsoft.com> <2026030442-cleft-appealing-93ec@gregkh>
In-Reply-To: <2026030442-cleft-appealing-93ec@gregkh>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Mon, 16 Mar 2026 11:26:00 -0700
X-Gm-Features: AaiRm52vkx1o4KUlFUplZY1SlPbCSAIAgITGANrDqlX316hTVt3Fp6-hQME48bQ
Message-ID: <CAGypqWx543J5t2nYPOUEPS_WJT=w=n90NMq1Z-XgMUCa=e845Q@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: fix page cache corruption from
 in-place encryption in SMB2_write
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
	sprasad@microsoft.com, pc@manguebit.com, ematsumiya@suse.de, 
	henrique.carvalho@suse.com, bharathsm@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2026 at 6:22=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org>=
 wrote:
>
> On Wed, Mar 04, 2026 at 07:34:52PM +0530, Bharath SM wrote:
> > SMB2_write() passes data kvecs inline in rq_iov by setting
> > rqst.rq_nvec =3D n_vec + 1. When SMB3 encryption is negotiated,
> > smb3_init_transform_rq() -> crypt_message() encrypts data in the
> > kvec buffers in-place.
> >
> > For synchronous writes through cifs_write(), the kvec buffers point
> > directly into the page cache via kmap(). In-place encryption overwrites
> > the page cache with ciphertext. If the send fails with a replayable
> > error such as -EAGAIN (e.g., from a connection reset), SMB2_write()
> > retries the write using the same iov[1] buffer. Since iov[1] now
> > contains ciphertext from the first attempt, the retry encrypts and
> > sends ciphertext-as-data to the server, resulting in data corruption.
> >
> > The corruption is most likely to be observed when connections are
> > unstable, as reconnects trigger write retries that re-send the
> > already-encrypted page cache data.
> >
> > The sync path can be reached during partial-page O_WRONLY writes when
> > the page is not in cache (common for append workloads with repeated
> > open/write/close patterns).
> >
> > The async write path (smb2_async_writev) is not affected because it
> > passes data via rqst.rq_iter, which the encryption layer handles
> > without modifying the source buffers.
> >
> > Fix by setting rq_nvec =3D 1 (header only) and moving data kvecs into
> > rq_iter via iov_iter_kvec().
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/smb/client/smb2pdu.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index a8890ae21714..a88a19dec494 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -5072,7 +5072,11 @@ SMB2_write(const unsigned int xid, struct cifs_i=
o_parms *io_parms,
> >
> >       memset(&rqst, 0, sizeof(struct smb_rqst));
> >       rqst.rq_iov =3D iov;
> > -     rqst.rq_nvec =3D n_vec + 1;
> > +     rqst.rq_nvec =3D 1;
> > +     iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> > +                   io_parms->length);
> > +     rqst.rq_iter_size =3D io_parms->length;
> > +
> >
> >       if (retries)
> >               smb2_set_replay(server, &rqst);
> > --
> > 2.45.4
> >
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.

Thanks Geg for your comments.I have submitted a modified patch to
mainline with cc: stable@vger.kernel.org
"smb: client: fix in-place encryption corruption in SMB2_write()"
d78840a6a38d312dc1a51a65317bb67e46f0b929
Please help adding this patch to stable kernels >=3D6.3.
