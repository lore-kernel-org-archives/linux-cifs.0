Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9552580E2
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759154764; cv=none; b=J/1QD051SO+KCsYPp7xCsmxnURJc05IIPJh5HZdumk5La133+pKAGVL7/xyROODyOm4mySCI2YEs4VrLRlr+XUnDHiAQ7vjyvgJ7Y1VaAqNxZEP2oj7lIeuHATGNZo7bjhpFh4+n8fSqmHfdImc/wlGG9q9/ABEKhO15znoJpGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759154764; c=relaxed/simple;
	bh=EurY6B9pTPpEbknkM+SMWan7c6xp4Mn/j5PYktvogPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thevCpvmVdEuqXvuIqZpzQB2m0RJiNub/tLMTrN/ffVx51yO4DvETp5g1xU3Qrb1SRK/675gQDnRZYmNoLJoCibcgB8YAUigjxxByDs/hvJojlG8r1eAaF7kMGwcHr5X0mbPzhI4irNptTNg72yBbheQRpx4l0OqZ4JIEberc5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UY0Oooor; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UY0Oooor"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7f7835f4478so29483066d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 07:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759154761; x=1759759561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3m/De6IGrOF8SXr5bJ7lJnvv2Y3jWe1ERH66bZunAPk=;
        b=UY0OooorbfDKd6cwtFkamjHaC+/8N7cvnC4FFbEpy4s3jQYYHJI1MEk6MkWyxiCzYt
         H86P0LM4eFQ+8ApFP4TD/BwtoKPYlkBFyepJlwx+jaedOl+Ih+roNCQwb090Zscv3I3H
         0Y1eiCIudxNBFIY8Duy8N9Il3fho5Nei4VxbOJ8AXqi4GcBaS4/+nghHMWIS5nU8PPG4
         OfpBNavgnHbyskITXIqk5G5Lb2sNSdSpjW+QZ7f4Gr/lXkq7NfpFrZQ/4Tixm1N5sfCz
         ZECq93pBe+qWPOBsKU/uz5UsSIIl/kZTcWiPCCY4hMA0EK9K2h0t0Dtm8qUkfAzDptzL
         /o0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759154761; x=1759759561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3m/De6IGrOF8SXr5bJ7lJnvv2Y3jWe1ERH66bZunAPk=;
        b=jl9Heh2c8shaLGl7stckx5FbqmCcYu3B9iogKwEOs3xev9T1vNX7eGmyp3+z1hQ2FZ
         ZEQ6FOxyhZIYue9B2Ae9O+ueVo1TKN4Z26aO51kozinvB42t7JnSSbRv81cmscpqa/mv
         mAdXz4GIaGVm/htgzcs1AGg/xdf6qp+6CXIzzqExfhAC88Z/WdgvIdj9REyStjmF3ETR
         AFGRXPGowjihom96FwlGnYGHEY/9+n2Q6W5Jn7xuPXhYhrBYk2us3iHczpdqs6gOJZ3x
         jZs/oXDgeRmtmJOpmT910wPf2hHlLZKbRKwswlwLIMoY3X0LLkh6nSHfAkRAEtrP1WHP
         BvnA==
X-Gm-Message-State: AOJu0Yy/w1s4afIo+T117AgZJflQip6lOpOsI/le5aw0IjgeEz+XydSp
	/h0pGN/GlU6xOxUNPf6Xkk7TQaT9bupP7z/EMXhn3JwI3Kb8sx+MCL7hq/GqUQp2ht8W61uTvYK
	PUH/5bevvxU3BPcIjdYoQhKYjhPKeYns=
X-Gm-Gg: ASbGncs1GwqOMyKsSQnQ4Y+tBBaJ7Izv2HVyfPH0aekEy25qngyZHqnbfFy0AojXI6F
	e0jJ7rYC5LtGvPNYGESb4ZQSvEEYN+U1v1xPE7LNo7LpgmLQIKTXf06dGLNlJ39P81w88cyHt5p
	4CqHgU0caLj+UKPndW+hzhEHgMKtA/Xac/vOkdN1nQReRQBIAJvNV7xVvfDr6ECLVTzujqZtgcu
	776fDVjQR0JmJXgweu9nbECq2zt+txwHg9ycVC+ahIpdg853kvb+odRYcqm0UaURSy56jMBOug1
	lrSWYzC8lC80LDqL63IDtGlgatw+iDEol9kaMtA2L8xKI3y/5eWcA/y7N0pTcwBu
X-Google-Smtp-Source: AGHT+IEkD6LiBOE5Z4LuNKBtobw5Hw8Qxfg47p74bZqbBjvOnVQBHk6xuE0PC6PH83K05Mb+prOUrmNBYlTWmX6K0lo=
X-Received: by 2002:a05:6214:19cd:b0:812:dc64:e903 with SMTP id
 6a1803df08f44-812dc64fcb9mr210534756d6.42.1759154760364; Mon, 29 Sep 2025
 07:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929132805.220558-1-ematsumiya@suse.de>
In-Reply-To: <20250929132805.220558-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Sep 2025 09:05:48 -0500
X-Gm-Features: AS18NWCNLyZqjxN9rzFSSuLtRWTM2NdowknQbwx8FB5AfkZV2BQq2gw6l5afY6Q
Message-ID: <CAH2r5mtAVB-Bvpf941+zN+DGoYHkX74sESVTVYb7oNVy4Gqfpg@mail.gmail.com>
Subject: Re: [PATCH 00/20] smb: client: cached dir fixes and improvements
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks promising (although wish could be done in smaller stages, easier
to test and review).

Do you have any reproducers for the problems it fixes?   I have been
worried about tests like generic/011 and generic/013 that fail about
10-20% of the time (probably due to deferred close issues/races) - and
hoping that we can get more consistent tests ot repro deferred close
issues so we don't see them in the future.

On Mon, Sep 29, 2025 at 8:28=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi,
>
> This patch series aims to refactor cached dir related code in order to
> improve performance, improve code maintenance/readability, and of course
> fix several, existing and potential, bugs.
>
> Please note that the below only makes sense to the whole series applied.
>
> Semantic fixes:
> - cfid->has_lease vs cfid->is_open: when opening a cached dir, we get a f=
id
>   (is_open) and a lease (has_lease), however, has_lease is used different=
ly
>   throughout the code, meaning, most of the time, that the cfid is 'usabl=
e'
>   (fix in patch 11)
> - refcounting also follows has_lease, up to a point, when we need to
>   'steal' the reference, then we might have a cfid with 2 refs but
>   has_lease =3D=3D false (fix in patches 1-5)
> - cfid lookup: currently done with open_cached_dir() with @lookup_only ar=
g,
>   but that is not visibly good-looking and also highly inflexible (becaus=
e
>   it only works for paths (char *).
>
>
> Technical fixes:
> - due to the many "Dentry still in use" bugs, cleaning up a cfid has beco=
me
>   too complex -- there are 3 workers to do that asynchronously, and the
>   release callback itself.  Complexity aside, this still has bugs because
>   open_cached_dir() design doesn't account for any concurrent invalidatio=
n,
>   leading sometimes to double opens/closes, sometimes straight UAF/deadlo=
ck
>   bugs (examples upon request).
>   (fix in patches 1-11)
> - locking: the list lock is not used consistently; sometimes protecting o=
nly
>   the list, sometimes protecting only a cfid, sometimes both.
>   cfid->fid_lock only protects ->dentry, nothing else.  This leads to
>   inconsistent data being read when a concurrent invalidation occurs, e.g=
.
>   cached_dir_lease_break() (sets ->time =3D 0) vs cifs_dentry_needs_reval=
()
>   (reads ->time unlocked)
>   * also, open_cached_dir() always assume it has >1 refs, but such
>     assumption is proven wrong when SMB2_open_init() triggers
>     smb2_reconnect(), and kref_put() is ran locked in the rc !=3D 0 case,
>     leading to a deadlock because the extra ref has been dropped async
>   (both fixed in patch 19 and others)
>
> Improvements:
> Having all above fixes and changes allows a cleaner code with a simpler
> design:
> - code readability is improved (cf. whole series)
> - usage of cached dirs in places that weren't making use of it (cf. patch=
es
>   12-18)
> - patch 19 (locking) not only fixes the synchronization problems, but RCU=
 +
>   seqcounting allows faster lookups (read-mostly) while also allowing
>   consistent reads and stability for callers (prevents UAF)
> - because a directory is always a parent, bake-in support for when openin=
g
>   a path, ParentLeaseKey can be set for any target child (cf. patch 12)
>
>
> Cheers,
>
> Enzo Matsumiya (20):
>   smb: client: remove cfids_invalidation_worker
>   smb: client: remove cached_dir_offload_close/close_work
>   smb: client: remove cached_dir_put_work/put_work
>   smb: client: remove cached_fids->dying list
>   smb: client: remove cached_fid->on_list
>   smb: client: merge {close,invalidate}_all_cached_dirs()
>   smb: client: merge free_cached_dir in release callback
>   smb: client: split find_or_create_cached_dir()
>   smb: client: enhance cached dir lookups
>   smb: client: refactor dropping cached dirs
>   smb: client: simplify cached_fid state checking
>   smb: client: prevent lease breaks of cached parents when opening
>     children
>   smb: client: actually use cached dirs on readdir
>   smb: client: wait for concurrent caching of dirents in cifs_readdir()
>   smb: client: remove cached_dirent->fattr
>   smb: client: add is_dir argument to query_path_info
>   smb: client: use cached dir on queryfs/smb2_compound_op
>   smb: client: fix dentry revalidation of cached root
>   smb: client: rework cached dirs synchronization
>   smb: client: cleanup open_cached_dir()
>
>  fs/smb/client/cached_dir.c | 946 ++++++++++++++++---------------------
>  fs/smb/client/cached_dir.h |  74 +--
>  fs/smb/client/cifs_debug.c |   7 +-
>  fs/smb/client/cifsfs.c     |   2 +-
>  fs/smb/client/cifsglob.h   |   5 +-
>  fs/smb/client/dir.c        |  27 +-
>  fs/smb/client/file.c       |   2 +-
>  fs/smb/client/inode.c      |  38 +-
>  fs/smb/client/misc.c       |   9 +-
>  fs/smb/client/readdir.c    | 146 +++---
>  fs/smb/client/smb1ops.c    |   6 +-
>  fs/smb/client/smb2inode.c  |  48 +-
>  fs/smb/client/smb2misc.c   |   2 +-
>  fs/smb/client/smb2ops.c    |  49 +-
>  fs/smb/client/smb2pdu.c    |  99 +++-
>  fs/smb/client/smb2proto.h  |  10 +-
>  16 files changed, 733 insertions(+), 737 deletions(-)
>
> --
> 2.49.0
>


--=20
Thanks,

Steve
