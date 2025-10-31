Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58CE15E8B
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761895905; cv=none; b=smQgVvV7lTEsXLwpAtVUMb0/z/VrAFqmNgWGXy3Mh5MYrA31NYs/rE5l2/rhIHzfbn9rD2jVIos2JnyYQhRX9fY/oQ6qVP6DSrn11wABECASJ2IO3uIv+GKOZz8fqkPTflqIoubhTuDZpHEpA+0sRO73aMus41+o2hkrMO/jhAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761895905; c=relaxed/simple;
	bh=teiy6SuXRcmrINY/Zsq7y5DTB2xOmNwxdmflxJTZFQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S1zPf/sxF5l9dUb2AChQzhRGl0t54cI1mFtPLUV2HSDoiIN7HifdMZopV+IzopWavy2W0+WxnTNS98PkXet8hc0zp9K/bAl+PNbdKPKKcVXrDtUgoSJZvnurxoco0SROJKRC3j1rn9GnGPTSwDXuyWgz0Fpy+oCsKRazcFONgj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajNIOELi; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajNIOELi"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-783fa3aa35cso27921447b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 00:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761895903; x=1762500703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPPGlDKg94J7lH16JJPSotz2b47PBPsswat4Kr7+Je8=;
        b=ajNIOELiBbFUYq0TxBNaVqT3lTe6k23CHFE6VvKbVYFFCYM3rNXqV5zTELjikaV4D7
         2JOsEMxy6cIUy3gHMBbyuEVnJuFXDOS1SyEe5VgqM5p5ZAe9R+OxI7IG8XSJO/64a3Nf
         ZH6hI/C2skWDIiZ4JfmSt1rNpjDovsjThMR+OoJuePiuE51N6/wONg9C9XqtVDhXiJel
         youHzKWqV8yH1fpLXL+xR/v3nSXKNShA83dK/JSX4FQSwqcr6nOd2ONKbS13H/NeJTq1
         auFjev8JYlbByLvMD2eSU4CEy2rmK2bMBdD0oIRxeRveTD/ehmgczJD+0i0kAsg7sGsD
         +2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761895903; x=1762500703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPPGlDKg94J7lH16JJPSotz2b47PBPsswat4Kr7+Je8=;
        b=ahwOdXGCV8G9MFDAxlW5GDfeI7YgAQF2cm7IWjHOhd6ALIMb3T0fpU2L1X9KRyDtn1
         J/u6CbbebcpGAJ2ze6BuWhbfq5BFvORs1DfN/N9v2xQyB1zvi7I53rLd7DDqIbW3QQ95
         XYnA2Ugl2ULYBQpvoNTzoK18/seTLK6b6M+L439s0uMudxhdZS9WjZIFFIUX3ir99LDT
         BMb7h0QUywbQbwoeXvgyZYu0Rtpv3lKn4XY0eVy6gUdP/2xWbWYTRGv6Mh1gk3pDE9eP
         vDdIxWSC1kN8ZnDqYsEfPv4FVh6+yh38qQm0joQ2xMPiBkh5ccIhfLI/yj37rzZcaXBd
         GIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXap2Oz8pELPLesB2/0pIczj3lTYpTtQzmkSTT0p1RbUfET7EkGMGKmzYSIw+kEqopfBoR1Vqk2qVHN@vger.kernel.org
X-Gm-Message-State: AOJu0YzZH+bycenAk31gyWK1I42kZ1fbuf3AOz3Lk/tvXLGRFNdyrEBO
	ulEmF1UmZfHowyFUmdiIpqglI5EntBQ/fhmGtqqJMRueoLlmAhCopZ02NZvVRQOzpKNixFIkJIZ
	JrUENT8eXnvpHIHlt+fFPGIQ7MJkQ19M=
X-Gm-Gg: ASbGncvv6IqOgoU2TaPoMwR1qYVH6/xewQhfBEENBilLZPrIFlO97ywtCvDWnMIJUPD
	v68ShJmHZVgp7SCcgzBV0+a6XiNoxY83UiXAK9WE+XHubMPFQXCoAcnRyC/eElli6/dYXWUv58L
	a4HO0t5evxIysNcRX8QCBL3Bx1GCMHCxoAovJclkMVwDnR5VmOjvPgLg/c0B9b1DTpcnV756Igh
	J4bfKrviy6yzIRBS5VJkjnDjrvHIDHH9BU3I2x71/wvwMymjqGQaHeVjLnIqc0adFQimg==
X-Google-Smtp-Source: AGHT+IEosEbP+8J8W1P9KQZyEIBhMzrRLRhEBgGOBmEe7m904RmfSWcoQvUVcipiuOQ3FT+gM5YHnvqPh+Cs/tktkGg=
X-Received: by 2002:a05:690c:b96:b0:786:3789:71e5 with SMTP id
 00721157ae682-7864852a404mr14451147b3.57.1761895902604; Fri, 31 Oct 2025
 00:31:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com> <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
 <CANT5p=pbEAKBm3K26AxtZV9+UwXvfrrk-fYs7LsSD3nHdZptNw@mail.gmail.com>
In-Reply-To: <CANT5p=pbEAKBm3K26AxtZV9+UwXvfrrk-fYs7LsSD3nHdZptNw@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 31 Oct 2025 00:31:31 -0700
X-Gm-Features: AWmQ_bnQ9ISxb97ADc4rYZOiIA5tQ7SkrX3yYeC5laVfX9msLDSEoBeVuV5-ZGs
Message-ID: <CAGypqWyCUVdEO0=6sVUQQXx5S0+AJ0efsj+nOTgaAJiV6=XtQw@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in /proc/fs/cifs/open_dirs
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	smfrench@gmail.com, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 8:20=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, Oct 31, 2025 at 3:28=E2=80=AFAM Paulo Alcantara <pc@manguebit.org=
> wrote:
> >
> > Bharath SM <bharathsm.hsk@gmail.com> writes:
> >
> > > Expose the SMB directory lease bits in the cached-dir proc
> > > output for debugging purposes.
> > >
> > > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > > ---
> > >  fs/smb/client/cached_dir.c |  7 +++++++
> > >  fs/smb/client/cached_dir.h |  1 +
> > >  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
> > >  3 files changed, 27 insertions(+), 4 deletions(-)
> >
> > Are you increasing cached_fid structure just for debugging purposes?
> > That makes no sense.
> >
> > cached_fid structure has a dentry pointer, so what about accessing leas=
e
> > flags as below
> >
> >         u8 lease_state =3D CIFS_I(d_inode(cfid->dentry))->oplock;
> >
> I agree with Paulo here. We should avoid duplicating data if it's
> already available elsewhere.

Thanks for your comments.

For directory leases, I don't see we are populating/storing lease
state anywhere including cinode
in current code, unless i am missing something. Today we check if we
have R lease then set
 has_lease =3D true.
I added a new u8 lease_state, the idea is to use this flag,
1) For showing state in debug files in this patch
2) Adding trace points to print lease state and other info, I don't
see any directory caching tracepoints
3) Importantly today we don't differentiate the directory caching when
we get R vs RH from the server, i think we need to.

We can probably repurpose the has_lease field by refactoring code.
But I am fine if we want to defer this patch until we have #2 and #3.
