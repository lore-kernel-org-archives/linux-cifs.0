Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A038C22257D
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 14:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746885808; cv=none; b=X47CuuG0WjD/Shyz6LYCqSl0/mJtfhPeNvk+yYqHJDs7zntNym3v8Hg3WOEHMlf4nJLv1HiCl+0mBqXC/dVajBuUbBlqoRpctrvqmP7jA0OsGzTk+2ZNyvugrrW+gw7el0tU9+3O4YUOWvrxLmxo7rXfJ9OZ7rnpq5C8L5INXlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746885808; c=relaxed/simple;
	bh=UCyhJ3iJ6ju9lWuSdod09k62lS9RFSbeseoYZsBx0eo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVVnpJqoeF5OzRRGNuc1n+/X6qRicC7QL3KPBh1ORDVZ3/t4RtCq0Rj4IG+wXqdcgmS3RD1hMxWAoKI1cX32qH6nYVomEsQ7oA/EYtDjJMauVsFKoGqeGw7rUfVSL5okERlabq0cyMMPR2iQPOEMiI8xTBxPq5liAQqWdmSMDBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iv81Batu; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iv81Batu"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad221e3e5a2so234030566b.1
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 07:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746885805; x=1747490605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrddfAsrr4Rz8zPE1iYKrfy4a3Y7XwNeI+yEr7qQ+WU=;
        b=Iv81Batu1/l/YCOIrrDdh+KE1IL2x5VHxAxiP5u0nL0mYgl0m7/zG8tQNwPeVeLX4T
         W4fSbysRKCSTDxqObhoDCpibTUwdx928YHIhHKNJqXQMjf0Q95euV/NwZBlTADLx/F/p
         qREr2Wkd4J1Jfl+hJH8RgUakdM2nL3LjBUlwABVsyL3+53OeUK92u3z6SiryQAtF7JpS
         zZD3Jh6wbqDj66DurY2J2frMUfnaPzlLCxE7CMwdTeFXxCyTgPOt2zdjqrWUlzKtFoX4
         MZQkgtzzzt8YAO6vOXaenJXoT5djbv4aqmPFBsBBqbyDYtWnpqu5mui74vwi7mDXNjeK
         SjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746885805; x=1747490605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrddfAsrr4Rz8zPE1iYKrfy4a3Y7XwNeI+yEr7qQ+WU=;
        b=O2GLDn/BYsuf9x5O9J5m6hefjsuJmPKG+4xaR5UvP42BiY/6yXhpddIYEZJEGsbDcl
         KPTcMyOqrDX2Be9JoLbUAvBDhYqwNIYJ43TE1yhFACCIrqE2gUD6ByR1eMKyzoo6yzLW
         yhm+XEFXGfOZAAgNzM+KJZiu0Zftx20kllK7vG9w+KtCXHkWojsrUfebQ6aAmek2/qlQ
         JCt+p36rk9uDDVl88+smUNaTn/gSGfDbVUCUljB0QkGPuOAeVkrKSV1ZPoFRfTIytKp1
         wmhiBtUapkgeMAF1z+Tk4w1zdjkwJn042SGCV2kcXAqKYeB8eY3eIs6gB5t8MYcrjv4W
         X/Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXCaxOUjZORT/NDIVpPpk0FXnJM14hOLG9vO75/OzDTlqWpG1P6pkndWt+tPzNkBNYHxi4QGo2lukPM@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk6qUUjDyXr43pb1lGV+vQLttQ4iMwbUMdOQKVwWVu2zXty/Wo
	7wtyHNxz7I6oldNe1m3iM61uYnz2LQgAYjiGsekCyBMYwkB3kcwezb+//+UfXACUwxKFZnIC0Gz
	WHLu2+hFBHnnaSVZ9lwh73ZObjtbUoA==
X-Gm-Gg: ASbGncvjRrMx7WQ6XMMoIS14g4O9te0T2zQoaxF+wF8ThTFkArXObkDWGzzcYW/nOD0
	xUCAxOAUEgclfJ/zchjGOHdJ53irLhxnyJgeRoinP144imsP4Fx33HC2q12BdXBU129zehm8TfR
	brzok0GMS33u19mc0922ipIxlg8p28zRt/N+j+Y+gp70Y6AJEYkLX+kweSbciOMRs=
X-Google-Smtp-Source: AGHT+IEthodbc5YPYzOHZlBsjlXLI3gWoC6WjHk3ELFqusaqMvdhUnVeBmwveiAdu0aIo9lpzyik9Sm6ZHuruI1rXEk=
X-Received: by 2002:a17:907:d106:b0:ad2:39f2:3aa8 with SMTP id
 a640c23a62f3a-ad239f24184mr238404266b.38.1746885804569; Sat, 10 May 2025
 07:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502051517.10449-1-sprasad@microsoft.com> <aBS8jg4bcmh6EdwT@precision>
 <CANT5p=qGspYwczDEnp6oy6F1UQJZKJ9vYw_3pKdipcByqjjuTQ@mail.gmail.com>
 <aBgFcc9SPRPOUFHw@precision> <CAH2r5mv5T4LM6FPGtma-w7StY_vi96qutEYX5AMAgbFEiMYHmg@mail.gmail.com>
In-Reply-To: <CAH2r5mv5T4LM6FPGtma-w7StY_vi96qutEYX5AMAgbFEiMYHmg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 10 May 2025 19:33:13 +0530
X-Gm-Features: AX0GCFs_JHusLsbqeaSNgIO5k22QiUepcyoj7g3G_hMHPBlr52IOLt7pPpEYiPI
Message-ID: <CANT5p=rkspaP5ucOq4RacjC4E6aVarTEAZ98_kRKaYfx1=rB1A@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
To: Steve French <smfrench@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, bharathsm.hsk@gmail.com, ematsumiya@suse.de, 
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 6:18=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> On Sun, May 4, 2025 at 7:27=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> <snip>
> > > > Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses=
_lock) ->
> > > > unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up i=
n
> > > > another path?
> > >
> > > Can you please elaborate which code path will result in this lock ord=
ering?
> >
> > I was referring to the following pattern in cifs_laundromat_worker():
> >
> >   spin_lock(&cfid->fid_lock);
> >   ...
> >   spin_lock(&cifs_tcp_ses_lock);
> >   spin_unlock(&cifs_tcp_ses_lock);
> >   ...
> >   spin_unlock(&cfid->fid_lock);
> >
> > This was more of an open question. I am not certain this causes any iss=
ues,
> > and I could not find any concrete problem with it.
> >
> > I brought it up because cifs_tcp_ses_lock is a more global lock than
> > cfid->fid_lock.
>
> That does look like a good catch
>
> In the lock ordering list (see cifsglob.h line 1980ff)
>    cached_fid->fid_lock
> is almost at the end of the list so is after
>    cifs_tcp_ses_lock
>
> "if two locks are to be held together, the lock that appears higher in
> this list needs to be taken before the other" so this does look like
> the wrong locking order in the example you pointed out.
>
> The updated lock ordering list with the proposed ordering for the new
> locks fid_lock and cfid_mutex is in Shyam's patch:
> "[PATCH 4/8] cifs: update the lock ordering comments with new mutex"
>
> --
> Thanks,
>
> Steve

cifs_tcp_ses_lock is not the right lock to use here in the first place.
These large locks have caused us plenty of problems in the past with deadlo=
cks.
We later decided to break it up into smaller locks for protecting
individual fields. cifs_tcp_ses_lock is meant to protect
cifs_tcp_ses_list only.
tc_count should be protected by tc_lock. I'll make the changes here.

--=20
Regards,
Shyam
