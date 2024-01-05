Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ACA35EE1
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWCor/x0"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cd04078ebeso8102701fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jan 2024 10:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704480146; x=1705084946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOuNo5QOezjdWI8kaYyfhUK8Zoaff0H0diWFnsQjqgM=;
        b=DWCor/x01CzCleLVhEbFCQNcdl1YteUEeR+BqXzR2YcSo0o7y0HsutLO09qDoNNNp7
         cmsDYqQian1rznKjaUtHoAMj8XvLzXVsy8spnnK+ySayaAyL44FOyCwssOHJvv34QQ0O
         fh+54AGsthSeSeSZnhKqlKGEvsMC7YALplMzF/cPFPzlM0UPsDRRvijnPOBfH0BHOJRY
         t41BMrFxcTWfXgk53ZeeuO1TijFlbIIuHqyfeINTD2KnV91JW5bd5fLkF/dvEgzNz1Ds
         +79oTr1+DVMtpbbPyw95C/kNaaR03KLQrwaKdslRwoHd/m1V7kdLEaiJXvJTp8/2sWQ7
         UTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704480146; x=1705084946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOuNo5QOezjdWI8kaYyfhUK8Zoaff0H0diWFnsQjqgM=;
        b=lFPSF+6aE1toaio+WWm4zMuN6xSa5Mpwi0ejBJgEoassnEvotv5eBBIHT71KzHWH7J
         Tw+B6hywZyeZjjueWUGrLsFASv9Ag2/tQ2vDu0XZPzWeU3vpi1iJhLzOBfOA+Wypd02a
         RlA0zzOT21VC0LrfuvOlG9G7WmmRuOr5Z7sCb5YmLkRjarFEufkFE7gPWYttMnq2ARWY
         e8Oy9paa6nNy5RclqM+ym19f4Cc+2b0St0sDtNUCdZ7H5Z3w6uUHU438BROioCeWzzgO
         F2noj+2lQjghlS5eZI5W2BfHdtRB03wmLmI4VgQWjD6jMpnNAUyFl7CFbfD6qxF8qMnN
         E+VA==
X-Gm-Message-State: AOJu0YyO+2KGkucqwnB17Vu708x3lfmxOicLIUy/sa8Eq/oeQrFVcpv1
	agPB2fJ4sF4p1Q9KCFeuRuGsV7YSqrDi1jgiMd0=
X-Google-Smtp-Source: AGHT+IFqcHS2G3StS7fN9hpnVhOEwBTUbrCd9hnmzd7hjVHtULzEoXHgad2OKdhi5WpCUYFBkxmvKraUCjxTzL2RamQ=
X-Received: by 2002:a2e:b8c6:0:b0:2cb:280a:ad3c with SMTP id
 s6-20020a2eb8c6000000b002cb280aad3cmr1840835ljp.13.1704480145576; Fri, 05 Jan
 2024 10:42:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com> <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
 <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org> <CANT5p=oFxQEB5G4CzVuJBkg76Fu-gqxKuFdYJ8NCnGkS-HhFJA@mail.gmail.com>
 <aee2e001-a1a6-4524-a897-de293ef1c034@samba.org> <CANT5p=rB4dtk7jp3cP9Wda4J2eG0HcEjGDOt9SCOpx=ho8DzRw@mail.gmail.com>
In-Reply-To: <CANT5p=rB4dtk7jp3cP9Wda4J2eG0HcEjGDOt9SCOpx=ho8DzRw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 5 Jan 2024 12:42:14 -0600
Message-ID: <CAH2r5msx0kbajyGbkT82bvZ=cv=EkuV07xYtC-ap=juPzBc7gg@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sprasad@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, Meetakshi Setiya <msetiya@microsoft.com>, bharathsm.hsk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 4:58=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Fri, Jan 5, 2024 at 4:08=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
> >
> > Hi Shyam,
> >
> > >> Maybe choosing und using a new leasekey would be the
> > >> way to start with and when a hardlink is detected
> > >> the open on the hardlink is closed again and retried
> > >> with the former lease key, which would also upgrade it again.
> > >
> > > That would not work today, as the former lease key would be associate=
d
> > > with the other hardlink. And would result in the server returning
> > > STATUS_INVALID_PARAMETER.
> >
> > And that's the original problem you try to solve, correct?
> Correct. I thought you were proposing this as a solution.
> >
> > Then there's nothing we can do expect for using a dentry pased
> > lease key and live with the fact that they don't allow write caching
> > anymore. The RH state should still be granted to both lease keys...
>
> Yes. It's not ideal. But I guess we need to live with it.
> Thanks for the inputs.
>
> Steve/Paulo/Tom: What do you feel about fixing this in two phases?
>
> First, take Meetakshi's earlier patch, which would fix the problem of
> unnecessary lease breaks (and possible deadlock situation with the
> server) due to unlink/rename/setfilesize for files that do not have
> multiple hard links. i
> .e. during these operations, check if link count for the file is 1.
> Only if that is the case, send the lease key for the file. This would
> mean that the problem remains for files that have multiple hard links.
> But at least the hard link xfstest would pass.

Since this approach could be a huge performance degradation for some
(albeit rare)
workloads (e.g. if hardlinks exist for files, but such files are not opened=
 by
different names at the same time), I prefer the two phase approach
that simply retries when we get invalid argument without the lease key
(which has no risk since the current code just fails, and retry will "fix" =
the
issue albeit not as good as being able to cache the second open)

> As a following patch, work on the full fix. i.e. maintain a list of
> lease keys for the file, keyed by the dentry.
> This patch would replace the cinode->lease_key with a map/list, lookup
> the correct lease from the list on usage.
> This would obviously remove the check for the link count done by the
> above patch.

I don't like the idea of hurting caching for all hardlinked files as a hack=
,
so for the longer term solution I prefer a solution that caches the
dentry pointer with the lease key, although that brings up the obvious
question of whether the dentry could be freed and reallocated
in some deferred close cases and cause the lease key to be valid
but us not to match it due to new dentry).

I lean toward something like:
1) store the dentry for the lease key, not just the lease key in the
cifs inode info (today we only store the lease key).
We could store an array of lease key/dentry pairs but I worry that
this would run the risk of use after free and/or lock contention bugs
(and additional memory usage if a malicious app tried to open all
hardlinked files)
2) if link count is greater than 1, check that the dentry matches when
deciding whether to use the lease key (presumably
we don't have to worry about it link count is 1)

--=20
Thanks,

Steve
