Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B452720338
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705500916; cv=none; b=sl5nC74JJ+1Qtrqbu9XHEWeVvyIl5j4A4cy0BAC3LA2R6rpaw9ZurddN6kjjQveHlMrxqfvysmNzIXut/xtS14WzRrCEfFpGwyx/mJ1ZAEjLIL2AZ/IZ8PGhlmRuvBFvEXutb03VDJuqTPcxdYkKK/GWP25ILSM1JpPtL8fafs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705500916; c=relaxed/simple;
	bh=pPgqXQtg/qdp/cpBpfD5lz2/zSBpUMqgwuWbOGhKQzM=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=YWpJUrA8ubrbFainsmB3ZEXsyQxh/aIcn7nlRp5YG2yQ820vYLV9kGq5eZTxMXlxN8kY4x8zvZB9RLEaCwzQWwgkcgL2MMi7Yb8Z4JZ+CYk5MNM40JIcolfZlVh+sd//XlJajSQbZrFJMf3sel2Jjanhv9r8f3wnsVXrTqwbO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewHh2z1J; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewHh2z1J"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50ea8fbf261so13336013e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 06:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705500913; x=1706105713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxvkTzdYocyeEXW0mdLGFdU1RQP1gMNrsTCBGJLzwa4=;
        b=ewHh2z1JHJAyMRt+hfdQCYyefsbkq+T0jfO5R6AorL5BOtdx+uqOrCluFsko2+98GJ
         rrD+IUy8aEfFaHTs8NqOcIGLXeiVdFw2xpqkFbBczXxHF7zFKspjHnbw2GSNtjPkbU2O
         in4ra+usHmEN71arFLgxWbyE4l5Yv5dn90kJXEbydkasgmwL7IIQs1D/IxFBgvKw6I+H
         jAmrQyKi9VFKKgfIPQSmVscxK1bEHuFME1/qhv0Nhxg0rGnGI4szfEd9VCfHLcrDC3l3
         mMR6xGTLBusy9Ndg3JO3wh9bboou4er0eLV2qUbJC1/peTfI2g7LpcV+NxLp6Q7QYV6D
         8pdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705500913; x=1706105713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oxvkTzdYocyeEXW0mdLGFdU1RQP1gMNrsTCBGJLzwa4=;
        b=xVgtwjXSAq4coZ7ZpJpDcXJwVmdYRPoAh1ibQlCNfKW6YwBwU1U8osCaVGGsrHR94G
         yrXh+8mWVB+Z0las1agmm7iLMEJcW6n08ToHC7HtQBZTGgerYcp/dlwGAlfbZbIDbJ9l
         JwH7BbVZ1LaINbNt8GA9qvvMf7oIdFddPu4toGXNASOB7YqdilPVKxVfy2DOeVfJGGhs
         ljBrBLeqiIXqjTFI5w+KzxJwsi41dJ/+z/tm/1zARkQVpkmVMsBVZU8EXBwmBtOxSC7G
         spJRajQ/c1RWp5CZOIeUSHhyn1HCIF1Or7SAkPinumjnqA2P9Nmnq5XCmmojEn/Cor26
         Iv7Q==
X-Gm-Message-State: AOJu0YyyTLRwoQ/tnY9j8tyys6bGGoWAo5Vd68e2bIKo0ye5cI/98Qh9
	suTj8AhtijWZjWSz759KLOSMhYuz2SYdodMbr/Y=
X-Google-Smtp-Source: AGHT+IF2jPCauOSDZ7QYOzCDoHN0l5DtWAMaacW900kz+kwJs8IahV7XHxggpnT6g3k0c6K5T3lPdYeDUMQTYm1LxI8=
X-Received: by 2002:a05:6512:694:b0:50e:ab9b:c32 with SMTP id
 t20-20020a056512069400b0050eab9b0c32mr5403090lfe.78.1705500912557; Wed, 17
 Jan 2024 06:15:12 -0800 (PST)
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
 <CAH2r5msx0kbajyGbkT82bvZ=cv=EkuV07xYtC-ap=juPzBc7gg@mail.gmail.com>
In-Reply-To: <CAH2r5msx0kbajyGbkT82bvZ=cv=EkuV07xYtC-ap=juPzBc7gg@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 17 Jan 2024 19:45:00 +0530
Message-ID: <CAFTVevUv+8uuHG_P6FfJq1nTJhmc1CWehW_SsgVrF9bCOBkqNQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.com>, sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, sfrench@samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>, bharathsm.hsk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

Here is why xfstest 591 must be failing when the lease key is being
reused for the
unlink compound operation and closetimeo is set to any value other than 0
(deferred close is supported).

The splice_test program xfstest 591 uses calls unlink() at the end of the
program to delete the file A without closing the file handle first. This
file is thus marked for delete and the server returns STATUS_DELETE_PENDING=
.
If the mount options have specified anything other than closetimeo=3D0 i.e.=
 if
we have enabled deferred closes, the open handle to this file (which was no=
t
closed by the application), would have deferred closed once the application
ends. When the shell script runs the splice_test program again, the same
handle from the previous run of the splice_test program - that was supposed
to be closed because the file is deleted- is used by the next open to
open file A
since handle caching is still allowed for its lease.
This leads to the error: No such file or directory which we see in
the file 591.out.bad.
This error was not observed when unlink operation broke leases because when
the server issued a lease break to the client, it made the client flush its
remaining writes/locks to the server and downgrade its lease from RWH to R.
Since handle caching is not involved here anymore, the handle was also not
reused anymore by the next open.
Now that the patch has removed the lease break communication with the
server, something similar to what happens when a client gets lease break
notification might need to be done. One solution could be to flush all
cached writes to the server and downgrade all leases for open handles to
file A to R or 0 as soon as unlink is issued for the file A. In this case, =
even
if some file handles are deferred closed, they would not be reused.
A simple repro for this bug when the above patch 1/2 is applied (courtesy o=
f
@bharath):
1.  Mount share with closetimeo=3D30
2.  (shell1): tail -f /dev/null > myfile
3.  (shell2): rm myfile
4.  (shell1): ctrl+c to close myfile handle. This would be deferred closed
5.  Touch myfile will fail for a period  =3D closetimeo value

Thanks
Meetakshi

On Sat, Jan 6, 2024 at 12:12=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> On Fri, Jan 5, 2024 at 4:58=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
> >
> > On Fri, Jan 5, 2024 at 4:08=E2=80=AFPM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> > >
> > > Hi Shyam,
> > >
> > > >> Maybe choosing und using a new leasekey would be the
> > > >> way to start with and when a hardlink is detected
> > > >> the open on the hardlink is closed again and retried
> > > >> with the former lease key, which would also upgrade it again.
> > > >
> > > > That would not work today, as the former lease key would be associa=
ted
> > > > with the other hardlink. And would result in the server returning
> > > > STATUS_INVALID_PARAMETER.
> > >
> > > And that's the original problem you try to solve, correct?
> > Correct. I thought you were proposing this as a solution.
> > >
> > > Then there's nothing we can do expect for using a dentry pased
> > > lease key and live with the fact that they don't allow write caching
> > > anymore. The RH state should still be granted to both lease keys...
> >
> > Yes. It's not ideal. But I guess we need to live with it.
> > Thanks for the inputs.
> >
> > Steve/Paulo/Tom: What do you feel about fixing this in two phases?
> >
> > First, take Meetakshi's earlier patch, which would fix the problem of
> > unnecessary lease breaks (and possible deadlock situation with the
> > server) due to unlink/rename/setfilesize for files that do not have
> > multiple hard links. i
> > .e. during these operations, check if link count for the file is 1.
> > Only if that is the case, send the lease key for the file. This would
> > mean that the problem remains for files that have multiple hard links.
> > But at least the hard link xfstest would pass.
>
> Since this approach could be a huge performance degradation for some
> (albeit rare)
> workloads (e.g. if hardlinks exist for files, but such files are not open=
ed by
> different names at the same time), I prefer the two phase approach
> that simply retries when we get invalid argument without the lease key
> (which has no risk since the current code just fails, and retry will "fix=
" the
> issue albeit not as good as being able to cache the second open)
>
> > As a following patch, work on the full fix. i.e. maintain a list of
> > lease keys for the file, keyed by the dentry.
> > This patch would replace the cinode->lease_key with a map/list, lookup
> > the correct lease from the list on usage.
> > This would obviously remove the check for the link count done by the
> > above patch.
>
> I don't like the idea of hurting caching for all hardlinked files as a ha=
ck,
> so for the longer term solution I prefer a solution that caches the
> dentry pointer with the lease key, although that brings up the obvious
> question of whether the dentry could be freed and reallocated
> in some deferred close cases and cause the lease key to be valid
> but us not to match it due to new dentry).
>
> I lean toward something like:
> 1) store the dentry for the lease key, not just the lease key in the
> cifs inode info (today we only store the lease key).
> We could store an array of lease key/dentry pairs but I worry that
> this would run the risk of use after free and/or lock contention bugs
> (and additional memory usage if a malicious app tried to open all
> hardlinked files)
> 2) if link count is greater than 1, check that the dentry matches when
> deciding whether to use the lease key (presumably
> we don't have to worry about it link count is 1)
>
> --
> Thanks,
>
> Steve
