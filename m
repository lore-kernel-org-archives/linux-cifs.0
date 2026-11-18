Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023780;
	b=zO7Cz/JRhD8bsDHXCiP2/qfpJWmso/IATgfqc9LWZuqchD0epA/vn5sZcYnklPXCA7q3
	 QQO6uPAShx7jR5or9nLJrZYMD6k1rnQcJR+UpWvGkvlPXHX0FuUGbAtyuqvQTlgh1jyJV
	 Zuk0HEgTobLkTsR9/RlATegmnc4RYdHcjTDIT9Orj6f50JjUZw2Ef7UwtOiH2B3IiRdth
	 x65WkSw8N7HZtGOTk5TPhBjSTTkJhAWMrUnqbEewIy8Y3a6C2GCSHlRv7BKfwWEuibBis
	 1Sla8fjjxo87KWmRw6KxibM2CW6kx+lkC+loXQFLbhHrLnfV00ip0wo1hVHsUi4eK4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
	b=h3Kyl/DMXfzl4uTTfkASpJPZqWRpzuMi5ySKKgKMJQs0xYx9fGFylEkKx5OAWU2OR/hy
	 s3YFcOo8sfmvTj6sUq8of1IX7bCXm/PWanJBYiOFkp2lh5zjpDa7rCOBxfeyEGg+QaZRG
	 twRpNNBOblwx5xBGiduSwRAugsm8FXh9aeeYMriD2uPgg2iSZoXBP7q9r6UlxdAeKlTLm
	 /GJqif+oNVqZWkX+M+9RqEetMrf2OpRbdVVOGGaroKPOTqaLALVg44qNtieCaXfGIeIO6
	 8ynSE8YtTnW+QLh0sNnGovW9UBDyHY1ex44dLONPvvM6sgZofdSNH3RXnv/oCI2qI3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ntRkyPbH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900A7606A335
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 900A7606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ntRkyPbH
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso145493a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 09:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023779; cv=none;
        d=google.com; s=arc-20260327;
        b=kve5UBGcGMsuXIIcyReYL6ofz7Wc0ExhgMbst13y5CIkuJZ2mfBsnSnrW2jLd01K6Z
         zJfdrtwucw1ys5lu842TURY0R1ozHogsnY31A1inKBug0RCA3iDw/eAEZnk7M2ry0WHl
         qiM0OUsxBv10rU8YnPyclHCE3GZxEZV+0APfewpVAD3uAuO82dbRZVL84jS02edGa9Gj
         wXcFH2f8kTzA1SeG1WewTieSmk/PzOajfciJZPiQslQ+72MFNyEvUHjUFQlSuQOOWjIh
         oQsxwUfm/YX3QZt76WbG3/FrTdftzwLqL5zABGn0MISq8+PIuph12qXbfRy2A94CM5J3
         DNIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        fh=nC95P95Vaf6JS41Q8XJizC6Y2ITWUppVwx2BcQpwr/o=;
        b=i/XOvQ1UDsn3sus8/AQ/UaRYZe1zj/TnmVffFv5RGBeJyuN8E/1g2viFYGwI26zFKK
         niYMRgmGti8lT2G9nVT/7j/OG5IS2sWnThPz2iKpRk7oO7iXeElRPbSokQ0HKOcjBZaD
         gjA/9BrQE04saNsveZL2OzxqSiecj2ulr99YXkcJDBYxZ8A/jldIFUgUpMsqwQgxxCJv
         XWFlP6bUwWOcr6tov2iQsJgqrJJc2vHFygam/n76ARNN4DgHhUen0W9MNLxFpwTXGuKe
         yOu+AKiQ2UG6St6JK9hrLt7X1TCr9MiDdORL5Hk+YC7hTW9iIs0p2v8g6e/XMl0u2q1d
         WHOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795023779; x=1795628579; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        b=ntRkyPbH0sYjrGxbsOGUMGapMwa1Ew8BC3KxQf/iyM1aDPSlhjn0B7wO7Eg0MQnCiJ
         D0hyH5hpSWTxAh3O5zAp8o6klUYs95/pv3XYR3HonGc7ZODF5h7znk0vF5koQA9eJjcv
         A/wwsh144v6Aic9y2lIUf23EIeDNRzV8Y8oHNhFKBeOSPRHtD7qplu37vone59H+oKF4
         3jyhqe487oQtXgrud96W2cRO68ugz7TuvNBmwciDPUNM52RpTaAyUc/w3O7d8UOWWzQK
         XV5u7Ub2PM0CzqPeRSqAAHIxtSwFvo+5bIH8XaTuJLebB7/eeHz/r3H8P7s2hjLFBe8q
         o+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023779; x=1795628579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ciuN1q7GJk6psMO8HqaJ4EweNO3dgrafMeDSntT6n7I=;
        b=x1AW9mQpAu21QgOaYkZf6+3rraou6qBLXnqp+r1UNGKIib9qyL0qfZZfdGSi8yDZ4u
         /5zHkfGGfO+7g53tZnqQCZtuI6xEd7QBK8xsTbUCqwOrwxAXycyMKHJftUM2Nva9fDGS
         mrUsNPzoMFn3ZO43D5tgdpF+DPTa5881pgO6K3zKqkSVQ4ySMLDGeEaQLWnYmlLb4yGb
         E/rTf1SV3RyLg4HSYw2ivL5ycdwTdV1IPX85LIaOgQE9uxtCMWVq+J/ycWfggrA8pYrk
         ZvBTe1gJu0Ocxy1PLYoI3x1+lFO1/UMsDQ7MErssOSFGPDeVp8VQKQrDA6s+sJXMVdzp
         Q/xQ==
X-Forwarded-Encrypted: i=1; AL+hErE1bKgfEybuC5I2eTjtt4/8vFaJZzFWR42fkiY3muzXvrAWr9HXtpHr1xAWBiNNfnhtDqeT+qfUa81M@vger.kernel.org
X-Gm-Message-State: APuU4Z9jYQtbGY3TmhnIOi8xkMUwyrUoo50imddEfWuXvFjUF7E961W2
	MRTOIrdoM3iBHikYruJxi10EIBaK3fmsyisj/zT0Z5R9rgTJOcYSoM2c8yxDkGXI2ptwN1bl4cT
	ojXSC3qz522bH/R+ivgeUARtRtQGWfHc=
X-Gm-Gg: AYBFou0Iosp0TwVKJ3fXsYX/oNCaBYUzEqRmu2yYaPXlUBIHF+GIxRS1RJD7jzyZj6r
	9viLMt4pDU114T9TKdDxrsgTHdG1oo2NmG0ci5cT+/BAkFeLM/rrwnDEWwSjNRNJEzsugZegSco
	jRt4KfMUolALbh+Ct1xmZ2l1dYJIR1eb910jP4LMiJH0sUW0J7Qex0li7Bssn15Ksca0XM4HqU/
	S0RIHepnKvM42lbIy9rvF/3sKtVsb6701c3QDRttssE5bjfVmLe89Ip9fzn6sdrSl68sBSjI5KN
	IV8t3bTQxaRkLgVrHGdPE8XXkM+iZJggSgPcZOYtXQCdRX4BeirFXwygvbEAfBNmlrTUoEpSSJh
	SMR1m4P1pajBdX5tTlWQqUPVLuZDnXBzy8eCNaNknkLIeynMqC1tcQFBqGO4vkBmd3NRc2Q==
X-Received: by 2002:aa7:c259:0:b0:6b3:e4e8:74ba with SMTP id
 4fb4d7f45d1cf-6b9b29685d7mr115387a12.13.1795023778657; Wed, 18 Nov 2026
 09:42:58 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261118142613.be3r3s6kobkkxnz4@pali>
 <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com> <20261118151605.lqtn5fz423kuswk5@pali>
 <DMYHPLWKPSH3.MUM1IIZZIWNR@gmail.com> <CAOQ4uxiwpdC-fKkqS5kiZ515q9MenC0jX4USV1idN7h2njx45Q@mail.gmail.com>
 <20261118173708.ax4t7zzklr5jvf2t@pali>
In-Reply-To: <20261118173708.ax4t7zzklr5jvf2t@pali>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:42:47 +0100
X-Gm-Features: AclHuK8TtEMT4ky5dtrBYdddz3l6RdahxalryFAKqWHd6v7Nf1ie2l606ulnXFE
Message-ID: <CAOQ4uxi+GvBRD8T4kFSqqZ-bxYfN3L8A61jtS2SeoGM6rN-3=A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:37=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Wednesday 18 November 2026 18:28:04 Amir Goldstein wrote:
> > On Wed, Nov 18, 2026 at 5:50=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> > >
> > > On Wed Nov 18, 2026 at 4:16 PM CET, Pali Roh=C3=A1r wrote:
> > > > On Wednesday 18 November 2026 15:58:02 koraynilay wrote:
> > > >> On Wed Nov 18, 2026 at 3:26 PM CET, Pali Roh=C3=A1r wrote:
> > > >> > Hello,
> > > >> >
> > > >> > I have just one issue with the userspace API. It does not allow =
me to
> > > >> > figure out what is the source of statx btime field. If it is fs =
ptime or
> > > >> > fs btime because this RFC implementation is mixing both fs ptime=
 and
> > > >> > fs btime into the statx btime field.
> > > >> >
> > > >> > I have feeling that this is quite a mess in API and I would like=
 to see
> > > >> > a clear distinguish between btime and ptime in the API, like the=
re is a
> > > >> > difference in the fs storage.
> > > >> >
> > > >> > If the btime is used for forensic analysis then somehow I would =
expect
> > > >> > that the statx would not report / not fill changeable ptime valu=
e into
> > > >> > the statx btime.
> > > >>
> > > >> Hi, for native linux filesystems it will report ptime as PTIME and=
 btime
> > > >> as BTIME (also semnatically).
> > > >
> > > > That is fine.
> > > >
> > > >> for the windows-like ones that only have
> > > >> ptime (semantically) I think it's reasonable to not expect btime t=
o be
> > > >> immutable, since they are meant to be used with other OSs who lack=
 btime
> > > >> semantics.
> > > >
> > > > The problem is here that the RFC statx API does not provide this
> > > > information that the fs lacks btime semantics and instead it fills
> > > > non-immutable ptime value there.
> > > >
> > > > I'm pointing only about this inconsistency.
> > > >
> > > >> > It would be really helpful if the statx API on inode can differ =
between:
> > > >> >
> > > >> > 1. btime is present and its value is ..., ptime is not supported
> > > >> > 2. btime is not supported, ptime is set to value ...
> > > >> > 3. btime is present and its value is ..., ptime is set to value =
...
> > > >> > 4. both btime and ptime are not supported
> > > >> >
> > > >> > This should cover all cases of different filesystems and also al=
lows
> > > >> > userspace to do proper backup of both ptime and btime fields (if=
 it want
> > > >> > to do forensic analysis or anything else).
> > > >>
> > > >> These should already all be covered by STATX_BTIME/PTIME and their
> > > >> fields in struct statx, the only problems are windows-like filesys=
tems,
> > > >> which IMO shuold be handled as mentioned above.
> > > >
> > > > Exactly, I pointed out about these problems. I somehow expect that =
the
> > > > new API would be generic and uniform across filesystem. IMHO it doe=
s not
> > > > matter if the filesystem is windows-like or not (there are also Fre=
eBSD
> > > > fs and also others which allows to modify that time). So better
> > > > description is fs belongs to category 2. from my above description.
> > >
> > > Ah yes, I used windows-like to mean "only have ptime semantics", so s=
ame
> > > as your category 2.
> > >
> > > >> Of course, as in the other discussion, I'm open to changing ptime
> > > >> NTFS/exFAT/... support to remove btime altogether and only use pti=
me for
> > > >> their own crtime if that's what wanted (I'm fairly impartial on th=
is
> > > >> specific issue).
> > > >
> > > > I'm giving some ideas how to possible handle this situation:
> > > >
> > > > 1. do not fill btime it at all when it is not available (remove bti=
me
> > > >    altogether - the case like you wrote above)
> > >
> > > This would be the most semantically correct option, but would break a=
t
> > > least 1 script/program/use case.
> > >
> > > > 2. when userspace ask both ptime and btime, then do not fill btime
> > > >    (remove btime altogether - but only for that new case)
> > >
> > > This probably is the best compromise.
> > >
> > > > 3. fill btime with ptime value, but add a new output flag indicatin=
g that
> > > >    the btime is not present at all and instead kernel filled ptime =
value
> > > >    into the statx btime field
> > >
> > > I don't really like this, it adds complexity and uses memory/1 flag b=
ig
> > > for a single specific field, IMO it's not worth it.
> > >
> > > > 4. let statx btime as currently is, and add two new statx fields:
> > > >    immutable_btime and ptime. immutable_btime would be filled only =
if the
> > > >    fs supports real btime (so not for ntfs/extfat crtime) and ptime=
 would
> > > >    be what is currently in RFC
> > >
> > > I think this is also too complex.
> > >
> > > > Ideas 2. 3. and 4. should be fully backward compatible as it would
> > > > affect statx output only when called with new flags.
> > >
> > > Then 2. is probably the best way to go forward (maybe I'll include it=
 in
> > > some way in v5), but I think we should let each filesystem maintainer
> > > decide if they think their users want to have statx report their own
> > > crtime as btime, ptime or both (native linux ones would of course
> > > report btime as btime and ptime as ptime).
> > >
> >
> > Guys,
> >
> > Let's take a step back.
> >
> > If this discussion is proving anything is that the btime/ptime
> > duality is a big headache and it's going to be a source of confusion to=
 users
> > even if we come up with some smart pants consistent semantics.
> >
> > As Jeff writes, I think we should consider making btime mutable
> > be a per-fs choice and not an API limitation.
> >
> > A filesystem can even decide to store both the forensics btime
> > alongside the user settable crtime.
> >
> > There are some precedents in xfs with settable UUID which is
> > a different field then the origin UUID from mkfs.
> >
> > Fs that have immutable btime have a few choices:
> > 1. Keep it immutable
> > 2. Start making it muttbale (like the Win fs)
> > 3. Start making the user visible btime (STATX_BTIME) mutable
> >     but keep the forensics btime on-disk for, well, forensics
> >
> > If btime becomes settable via options 2 or 3, this could require
> > admin opt-in (e.g. tune2fs -O crtime).
> >
> > With option 3 the crtime feature would be ROCOMPAT
> > With option 2, it could probably be COMPAT. Maybe.
> >
> > If we accept this story and the major fs maintainers are
> > in agreement with this plan, then I think the missing piece
> > is making the "settable mask" visible to users via the new API.
> >
> > IOW, we need to somehow export FS_XFLAG_RDONLY_MASK
> > to userspace instead of only exporting the supported mask.
> > And then with the addition of xflags_mask, we could also
> > -EINVAL on users trying to set readonly flags/values.
> >
> > Perhaps a single xflags_settable_mask is enough.
> >
> > For file_setattr(), xflags_mask is anyway a set-those mask.
> > For file_getattr(), does it matter if we get an answer
> > Filesystem does not support casefold on this file
> > OR
> > Filesystem does not have casefold on this file and
> > you cannot set casefold on this file
> >
> > It's kind of the same, isn't it?
> >
> > What do you say?
> >
> > Shall we drop PTIME in favor of "is BTIME settable?" API?
> > Leaving STATX_BTIME exactly as is.
> >
> > Thanks,
> > Amir.
>
> From the beginning I had a feeling that this is not an option at all and
> that is why all that ptime-way was chosen.
>
> So thanks for brining this up. I like this your idea. It address the
> original problem with backup/restore of "create time".
>
> But I would like to point out about another thing in this your idea. It
> would be nice to have an API to retrieve that "forensics on-diks btime"
> in case there would be filesystems which choose option 3.

Anticipated this question ;)

As I said there is already a precedent with xfs settable uuid
(I think other fs have it as well?). All the metadata is available
to admin via xfs specific ioctls, but not via the generic vfs APIs
not even to vfs via vfs APIs.

I don't know if this is good enough, that's why I urged to get an
ACK on the API design from major fs maintainers.

Thanks,
Amir.
