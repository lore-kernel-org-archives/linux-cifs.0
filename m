Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D177153BE9
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 02:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785206774; cv=pass; b=CKbHzZBj0UMKdqzqjMzkgtwaHWqyZYk49pU1+w5ZMNq2Qw3hBGfz5o1xUtVbFhW0cNdYW8kPOwjlQBXye+VLk9BB2HWU0sUlGkJHaAyTPdwdS50j5Ia/SUQKE/Gen+k6YUqUz65tonXLmo4FjctrI4XgVDFVF/Xwfr3Pt8grxWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785206774; c=relaxed/simple;
	bh=5wknqcHvWa0WA3hEzOZOnjFeqRFvMR8i7YuXqCPjflc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YBeyn9ndpltAqFbQlgRiL5rSDDo8fr7SSgRcA1nNS6aNfwI3GAnJlktTi0sONnHvwzkkqrvCwUIk+6SCR77+tBmCZIm0/UDazHn9fFcFD+39cxPdqKVY21gkIRrFqYZivYAAU6a6eP48GI3CzkxdBlXbScHpY7g1oDo/HSRk3bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWFJgpLv; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWFJgpLv"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so38600846d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 19:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785206772; cv=none;
        d=google.com; s=arc-20260327;
        b=C6hntYZdC9/F840Lnc9EkHoQfCO0vaUsvjXskhykN8DwT9/L4KM4VtbsoWyYxVGSGX
         Rzlib6IFStIPs9ELC4tPqjBtuN7iL3npjhERH2FKJ9Y0ZTnq48LgMb8KAQ/tpmVyX4K/
         FO4tL+jqB9AVp4bTMubN0yg+tcrWAke5eeLH72KansuAfKhOELVwwq/lYGTTDprylr5k
         +WnqRQNJJtQ5bWSjGNApZXpB2CeHkiyfmg0/VMhgOYetadiCS1APq4qWBwVQrI6oHcoz
         mcdaV6kzzPYjUfaN7opDiilCM0HwRZkhL8XDY+zPun367jSJfkRB3grKlJaQ35WHgKTt
         iX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ul0Kh2Ht4XJBDiRLtygSASSEJtkfDbax5CD6cF2jmw8=;
        fh=OJisH41nAjtUw/+h1FzTpYv6gE+6VEjT9bFzBhezkII=;
        b=GdDf77MzfWlgjkFyk++WYDHC+Sd+53tChiG098/A6cFrIGatsmFYmYFA6X8AvNejDp
         EDlKgNQSsxCyUQj6YDsHoXDuG/9j4xDT6m8IouxG6Iq6u9ITc8kzHCqrixe/XwuBzHhi
         y+uAuIJiN1dgz42yzVT3QNWvIFmQ0JlGlDdIaq+HDmLqBpXhbVMy4PgBtcB8rMFY2wnK
         ly9CimFVGTnJ3OfZhv5FF1wr4RJZHBXn75WIJSgQqUA+4zDZ8J0E27UoCpvfjk2+kRyO
         xav98JkMQy5nGzX8UIFnEexaOEUchYu1Ea+W45W6fMwamGPvIqCYr0uqJ/0OBH6aOl8U
         TtKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785206772; x=1785811572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ul0Kh2Ht4XJBDiRLtygSASSEJtkfDbax5CD6cF2jmw8=;
        b=AWFJgpLvJkrp1LWYUT/YRsvns2hZXMkPxQUhi+LYfKVfqz1RhxrTq0prYKriHzqZpZ
         vbXT8OhC+nEoPAyMY5YB4omM7OwAEYvBbqObhkHiCHx6rlow5HdJHoSXdM6jAVQjCToM
         Ftio23KDABmqCm2wE1z5TuVkOETiXp8LM7Swyf/1U2yemuKsAWgcHksfWXhH9MoGOJ6/
         o7IHJN/miJqbS4y4Mq7dCKz/043q3Fx/BllHSijwl2XdhcLvuuSurNbGJH3eNJNyjqa8
         N/nZmlPtHKAOAkAlsMvEk7nea+EB/9XlBEtNDcNjanWhLS2pRhJevTOF4QFSS+vgoFS2
         kzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785206772; x=1785811572;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ul0Kh2Ht4XJBDiRLtygSASSEJtkfDbax5CD6cF2jmw8=;
        b=bYZIIPlFAM/xS3sfwbQVE/8jIzUaGAGcjRwJEAoOR/QHn7KvRP8S0T3/AA0KjQQ3fl
         bT2eun0Jo6tQmorhdSKZZFuoAD7Haq2rZO/AABM2pGHTZiv3sUS7Vnva3pdoXLDXLade
         OjoixAFyOoA5xgCVmIGwvKAzFRxvRgZw13ZxOTYwDv3CyEI9TT7esaz01WikcZrXCY0f
         iTBay+RAj9z7CegGWktNTBurkr2nziIdrfAz6x4KuS0C4jwnVVBvpHFI7BLaFhVsF0kH
         X6l9iawSA9gDtWpC02+AYc1cWfQWJT1vrz+0y/jn/fJTcI4wUlLrMKURDtavqa4fqAS8
         i1sA==
X-Forwarded-Encrypted: i=1; AHgh+Rpyk6eVIDI0o/VHaP/UWUNsaMUIO3k0nfG/Xbyb/qp2A8g4kiqa5Lfpq3Hne3hoxSelauIjQSZWEYbH@vger.kernel.org
X-Gm-Message-State: AOJu0YyObx/Yt78sEYU21ikXJqj7GV2z5w9Z9nYOc3R/XkpEe5uP6IFa
	JV0IlTkbUoNR2BKGKVG7Zp07OpslUJVaMC8hRR6wIfmNj5BFE4M2wdKJX7azjm+SPFwIupg0KSA
	asn9zVAr0QD5J6estJ4tH9BBgStbgMTGmiLE2
X-Gm-Gg: AR+sD126vOnVXZJetgCK7aSIW/6I91el6xb0OeUDmiNShciIqhr/qCZZiaAYpjRVyXQ
	GtGn8jzMgrK+bIMflauzWce8a0fIk10gjC44gY4xBp4+NtpucnRdgzWfafcWhmF3CvIb+61/ziw
	mXWHJjYyn62nxRJ89J07eK9Fn3MrgywaBzX79oVSdINXlxGDyMj9u4XY/u/iUXu3Cg8jTW+NmRw
	mz5hcPgVTcJUmRF97hBHq13svg2FdLwju73kiTXARVCZk3FmHHjFKlbI/blcpCo/dV9zgJrzlS5
	ok3Sasjb6b/Y2OESfDcRSR4qE6wKr/CIGp4iWMutX2tnNsqqJwif2R/DB2kCrOK10uZHDdvHb0r
	Ls6tCsp0qMz8clx1hj5W4l1AayJ634wZ0EPF4w905HA==
X-Received: by 2002:a05:6214:33c6:b0:8f2:8b5e:3b98 with SMTP id
 6a1803df08f44-90816f762c1mr5386286d6.9.1785206771788; Mon, 27 Jul 2026
 19:46:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724163036.2670328-1-sorenson@redhat.com> <2ff7ecbb966ccaa5dd3768b0fdf38d39@manguebit.org>
In-Reply-To: <2ff7ecbb966ccaa5dd3768b0fdf38d39@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 27 Jul 2026 21:45:59 -0500
X-Gm-Features: AUfX_mxbRPwKrd234rmAZvEgk2ur-sPeV35GI3qWO6_9bMmyk73aLV0tanALTG4
Message-ID: <CAH2r5msET6xuFrpLrn62dWEaVqqPwd-kxGR_4DN=is2-jGgUmw@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: follow-on fixes to time_last_write mechanism
To: Paulo Alcantara <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Jul 27, 2026 at 1:22=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Frank Sorenson <sorenson@redhat.com> writes:
>
> > This series addresses two correctness issues in commit e8a8d54c2d50
> > ("cifs: prevent readdir from changing file size due to stale directory
> > metadata"), which introduced the time_last_write field to protect cache=
d
> > file sizes from stale Windows Server directory enumeration metadata.
> >
> > Patch 1 consolidates the time_last_write stamp into _cifsFileInfo_put()=
.
> > The original commit scattered the stamp across cifs_close(),
> > smb2_deferred_work_close(), and three deferred-close drain functions in
> > misc.c.  This missed the case where background I/O holds the final file
> > reference after userspace close() returns -- the stamp was anchored to
> > the earlier userspace-close time rather than the actual server close,
> > allowing the protection window to expire before the handle was removed
> > from openFileList.  Moving the stamp into _cifsFileInfo_put() under
> > open_file_lock provides a single canonical location that covers all clo=
se
> > paths and uses the spinlock's store-release/load-acquire pairing with
> > is_inode_writable() for correct memory ordering.
> >
> > Patch 2 fixes the stamp placement in the setattr/truncate paths.
> > cifs_file_set_size() calls cifs_setsize() on success, which calls
> > i_size_write() and updates i_size.  The subsequent check
> > attrs->ia_size !=3D i_size_read() therefore always evaluates false afte=
r a
> > successful cifs_file_set_size(), making the stamp dead code -- the
> > truncate path was completely unprotected.  The fix moves the stamp to
> > before the RPC call, guarded by attrs->ia_size !=3D i_size_read() to
> > exclude no-op same-size ftruncate(2) calls.  On failure the stamp is
> > left in place rather than restored: restoring a stale snapshot (prev_tl=
w)
> > could silently erase a concurrent _cifsFileInfo_put() close stamp if th=
at
> > close arrived between the READ_ONCE and the smp_store_release.  readdir
> > is suppressed until the stamp expires; stat() is unaffected because
> > cifs_revalidate_dentry_attr() uses from_readdir=3Dfalse, bypassing the
> > time_last_write check entirely and always returning an authoritative
> > QUERY_INFO result.
> >
> > Frank Sorenson (2):
> >   cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
> >   cifs: fix time_last_write stamp placement in setattr/truncate paths
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve
