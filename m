Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994467;
	b=mQJlTUsvhjr7i1+H+468SDpLwjtehkeLLhPkL2tXTJ3SFnnAdcKkHHof7dCSE8bdOkPI
	 ZOpDsJO/kBmonlVumRgwZkbXzZ9ctxzLqgVZY91wSAk66hOQuDHFxCbM6mKxZSz+4N+4S
	 4GXmmdO/S34Tx6SfBKhPlZL9bRFr37eAcZvFGXdNiDrWOV1BZmX0IPJIP2aEWbqkC4qg/
	 yADzdFZm47XdhrLW/ommhiyXMfoH/k4mPd5VwSbHLoE3BIl6e9CXFUurIcHmwgv+IUSKV
	 sBlXZ3QBKHl+xmdf5KnRC7XIFiIxOSa8h+0cYYu91vPZMmnfciZlF6qZdUBR5zzv5GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994467;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=rNa0vN78D0akbQFcdNqhv/WUiqgfa1Av3KtBFrChCIY=;
	b=LKswnf2GQiRI1TClWkIZUtxQ8PnrEEoRPOwHvjeiwqHcr+EYTfQH8zOmc06OJyW0LMxr
	 F4aNYtRu73S9q7SdjRnxVYeX0GMYFoYeZQOFmD0US6sIhtlb78JeSJ4X7LVFWSfsWOQGQ
	 HCmJh98KWyhpJFPNqXxekFu1T7RVq/zEPpzdOANZYo1xn0tmxKEqU7TERG1+Gy06tBi1A
	 Hcr0NFNNXStFvnp3DYId8uqqj3GOgHv4O+DF4tNREhnSrS33rwqEHBtTWjuzqeChoTiKV
	 B6ur/cHWw8qCvV8hfWK30a+qRwgEoENuWisLV++9lnSplvs9KbKCYzRETEjesOyn1IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vNrLaaY4;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EED606A320
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 09:34:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7EED606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vNrLaaY4
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso5310445e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 01:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794994464; x=1795599264; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rNa0vN78D0akbQFcdNqhv/WUiqgfa1Av3KtBFrChCIY=;
        b=vNrLaaY44Q/GfHmB6rx+D1IFbcUvRjzZuHD/uPB4vnaiV2hFmRRWMsAc4oC9pY5wFS
         tmcR+mCn7my8uU9MCBoEUOXLQxYPutp0mjEm9cx814WtP1eEv2EAGy+UFvoSNIk+T3Mx
         GAdY5wIRgynWUhTPEw9h9zeB9XYGrAH0bhyd+2dwXwsLCsapKqWuIqPMJ/mldGlh1nEe
         VtT8jMkH0JRZxUqUCjN8RGo/HKnaMf23xYULQZWlmkO+Q4JfmE/ZC+bvDciVfRGa1naV
         fVOMxDTlfb9zsukQBsgecnSANPhQuxyo6N5jpkF3RdWgIKUjDAYrTbGhpQBIBpt6W5LG
         wxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794994464; x=1795599264;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rNa0vN78D0akbQFcdNqhv/WUiqgfa1Av3KtBFrChCIY=;
        b=2XyaItUmAQKWUW1awv9OI261svQ/TYTRSYFDdUz/Wi8ShBpScVwxYOpYhMPZq47R5d
         FLLQUDEwwwSuM0KlOR/vQXwgAh2RR7/IeXS2gJI+Bf7qfGjWgIcAo6prm416BfWlB76b
         fNXOQKs79iNhwR6hLUgXSFbDTi94S4C+UafQDIvK0pavPafVpE5ZG0iBCcQJbGecgnC/
         B4ul7U5QpbgUzKiPm+kxD168Ynx16kcnjyuQIJY2QGVav76/WwPhGDwecj0egL0sdlDA
         4MzO2Zmy79i8D2/cPLEAcbQvI7EiPHF7nn3CGrjG1nlnNUmkImUda3CPaEumnkt6k9fr
         alAg==
X-Forwarded-Encrypted: i=1; AL+hErEHYyvfqkAEA7MH5fvRTXteCxlWPdX0W+mx3HzzbTLjI3aXJEuoo+msTcbL+N8R5x+cVP7okpqcRhCs@vger.kernel.org
X-Gm-Message-State: APuU4Z9rcDeKlwcbGjzpL6AIE32A1a4bDhWDciCAX7BcW9Z2QKp96hyf
	kd5Mq3P+EBCr5FptR9MqoB05+qJnYjZqQ4r9cW5dfrNOSbsDDzo/J5OU
X-Gm-Gg: AYBFou3fGw3wCOL5hEfDRMVsQAsaih8kDTqUie4Za9XfPnlP3tEUWfK00ZvZmzNZ5vX
	kVi1P7jOI612oufkf/pCcMN2/4gPBjRFm7aKsGT7y9r++4xQwRLDNXa67Y0AmQ8OApbh9K2MJyJ
	deMvQ8qceivV23SkbPTl1SkxlIVRLDLsMtDBeLksjjznDQ4ZkHDRIirwfZx+i9f5C+wU6HldbNb
	KMf5Q2FhvbrBpTXjxo8xOQ/SoqklY5jQ9MU7piwWUExsHZ0Udl+rXEdq2/Qpelul/uVdIFa4Jfy
	W+ad4qm3d6hLe4fzpsyesltf9ru8Ykd+yOzRJj8j0la4fmVcZPYXKuLV20uGSjAV/K7Q4rcXxxw
	AknCnSZ3HxbEU89Yl9HyeSGniP4zBzglMhgb1ZmVNi+7u41FLSBRT/20ImN9muGIvZ8JADfClbc
	OBV+dCT6/ecesUg0H/yjwqi4weeAPEZA9DrWKwIOcG09l2EC87y2sCsH/ZtZZlhvRYSZ9VJsZw8
	NQ5q4A3dCm+HY07zMV4e9kdkZaxzQjT9qou9Sh2hvQdk2RYBt6J/QOCIxT2OLXttBHj9Ck7HVUy
	/nxTBt12ANZj7e+97tQjlc5oZjiUZRvtZfDNee5BnE6I2HZfStT0pQ2F3ZOqouN3Eg==
X-Received: by 2002:a05:600c:c167:b0:4a8:9a2f:d27 with SMTP id 5b1f17b1804b1-4bb7da390b9mr35026975e9.25.1794994463991;
        Wed, 18 Nov 2026 01:34:23 -0800 (PST)
Received: from localhost (mob-176-246-251-118.net.vodafone.it. [176.246.251.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2b74d6sm52272335e9.9.2026.11.18.01.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 01:34:23 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=044bdd0a4a47942c271d04e37cdfe5ff13f45bd18be64b399c47a4223d1a;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 18 Nov 2026 10:34:10 +0100
Message-Id: <DMY8FEXBRS0L.2X0W5NIFG56C7@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Konstantin
 Komarov" <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>, "Jeff Layton" <jlayton@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <fc53ec55d315a4b96ec1e6f250ad3763f2189755.camel@kernel.org>
 <DMXXOPD9UDNP.2YP9ROMHFLM9E@gmail.com>
 <CAOQ4uxjcvAKTaGXO0=BpbtgoEPmN7GKieVbX1ZpZR38H1Z3j9g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjcvAKTaGXO0=BpbtgoEPmN7GKieVbX1ZpZR38H1Z3j9g@mail.gmail.com>

--044bdd0a4a47942c271d04e37cdfe5ff13f45bd18be64b399c47a4223d1a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Nov 18, 2026 at 9:14 AM CET, Amir Goldstein wrote:
> On Wed, Nov 18, 2026 at 2:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Hello and thanks for replying,
>>
>> On Wed Nov 18, 2026 at 12:53 AM CET, Jeff Layton wrote:
>> > On Sun, 2026-11-15 at 19:03 +0100, koraynilay wrote:
>> >> This is an initial implementation of a new timestamp to indicate the
>> >> time when a file/directory was initially created.
>> >>
>> >> This patch series takes inspiration from the one by Sean Smith
>> >> <defendthedisabled@gmail.com> [1], but using
>> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
>> >> <djwong@kernel.org> in [2].
>> >>
>> >> The semantics of this new timestamp should be at least these:
>> >> - it should be the same as btime on a newly created file
>> >> - it's user-settable, so it can be preserved for backups, filesystem
>> >>   conversions, archives and any similar operation
>> >> - it should be preserved every time mtime gets preserved
>> >>
>> >> and the correspondence with the other timestamps is as follows:
>> >>
>> >> ctime <-> btime
>> >> mtime <-> ptime
>> >>
>> >
>> > I'm not sure how to interpret the correspondence above.
>>
>>   |-----\_-----------------|-----------|
>>   |       \_      change/  |   birth/  |
>>   |         \_ modification|  creation |
>>   |           \------------|-----------|
>>   | inode time |   ctime   |   btime   |
>>   |------------|-----------|-----------|
>>   | file time  |   mtime   |   ptime   |
>>   |------------|-----------|-----------|
>>
>> ("file" as in "the concept of this file", I'd say "file content" but
>> that would be incorrect for symlinks)
>>
>> so ctime is "inode change time", btime is "inode birth/creation time",
>> while mtime is "file content change/modification time" and ptime would
>> be "file content creation time" (same as Window's or MacOS's creation
>> time).
>>
>> Does this make more sense?
>>
>> >
>> >> Examples:
>> >> 1) a .zsh_history file created in 2019, then after a few years the us=
er
>> >>    decides to switch to another filesystem, copying the .zsh_history =
to
>> >>    the new home, in that case btime would have the timestamp of the c=
opy
>> >>    and ptime would have the 2019 timestamp (just like mtime would hav=
e
>> >>    been preserved)
>> >> 2) a symlink created in 2020 from the home directory to a /path going
>> >>    through the same process as the .zsh_history, in this case it woul=
d
>> >>    also make sense to sync the ptime to the 2020 timestamp instead of
>> >>    keeping only the btime (so the inode creation time).
>> >>
>> >> The proof-of-concept code (for testing) for stat(1) and cp(1) is
>> >> available at https://github.com/koraynilay/coreutils (master branch)
>> >> (Note: these coreutils code changes are a prototype and won't be
>> >> submitted upstream as-is, but they work as expected in simple stat an=
d
>> >> cp -a/--preserve=3Dptime tests)
>> >>
>> >> Lastly, the name "provenance" and "ptime" are not final, I personally
>> >> don't have a strong opinion on any name, but while testing with stat(=
1)
>> >> I noticed that "Provenance" is definitely too long for the normal
>> >> output, so another option which would fit well is "Origin time",
>> >> abbreviated as "ntime" (OrigiN time) and not as "otime", as that woul=
d
>> >> conflict with btrfs' internal naming and create confusion.
>> >>
>> >> v2 changes:
>> >> - fix permission bypass leading to ptime update on immutable and
>> >>   append-only files (found by sashiko[3])
>> >> - normalize ptime timestamp as done in fs/attr.c:notify_change() (fou=
nd
>> >>   by sashiko[3])
>> >> - fix wording in vfs patch to be like the cover-letter
>> >>
>> >> v3 changes:
>> >> - vfs: reject setting ptime with -EOPNOTSUPP on filesystems that do n=
ot
>> >>   support it instead of silently ignoring it (found by sashiko[4])
>> >> - vfs: fix not being able to clear immutable and append-only on files
>> >>   with ptime, and allow updating immutable/append-only atomically alo=
ng
>> >>   with ptime (found by sashiko[4])
>> >> - btrfs: validate on-disk ptime nanoseconds and reset to otime if
>> >>   invalid (found by sashiko[4])
>> >> - btrfs: avoid re-assigning ptime on unrelated chattr calls (found by
>> >>   sashiko[4])
>> >> - add ntfs3 and exfat support as suggested by Amir Goldstein[5], but =
no
>> >>   vfat, smb, or nfs4 yet as they are a bit more complex
>> >> - move the introduction of fileattr_has_fsx_mask() from the btrfs pat=
ch
>> >>   to a standalone patch in the series
>> >> - btrfs: add fileattr_[gs]et to symlink and special file operations
>> >>
>> >> v4 changes:
>> >> - vfs: implement fsx_xflags_mask as suggested by Amir Goldstein[6];
>> >> - add SMB (ksmbd/cifs) and nfs (nfsd/nfs) support as requested in
>> >>   previous threads;
>> >>
>> >> Note:
>> >> to apply this patch 2 previous patches[7][8] from the ksmbd/cifs
>> >> subsystem are needed.
>> >>
>> >> New Question:
>> >> should I rename fileattr_has_fsx_mask() to something like
>> >> fileattr_has_unsupported_fsx() and keep its code as-is, or should I a=
dd
>> >> the fsx_xflags_mask & ~allowed check in it and keep the name as-is? (=
or
>> >> both?)
>> >>
>> >> Thanks.
>> >>
>> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@=
gmail.com
>> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>> >> [3]: https://sashiko.dev/#/patchset/20261027220532.736352-1-koray.fra=
%40gmail.com
>> >> [4]: https://sashiko.dev/#/patchset/20261028134728.294127-1-koray.fra=
%40gmail.com
>> >> [5]: https://lore.kernel.org/CAOQ4uxiuy0VwZj+3M-zRqQ49WTpHZpiaQ+6MZ8z=
8WdLjyQM_zA@mail.gmail.com/
>> >> [6]: https://lore.kernel.org/CAOQ4uxjtuTDT63vJdYaq+RHQEQFLTksp66e46OM=
N99WhJz3SbA@mail.gmail.com/
>> >> [7]: https://lore.kernel.org/linux-cifs/20261112111637.184045-2-koray=
.fra@gmail.com/
>> >> [8]: https://lore.kernel.org/linux-cifs/20261115155308.415734-1-koray=
.fra@gmail.com/
>> >>
>> >>
>> >> koraynilay (10):
>> >>   vfs: add provenance time (ptime)
>> >>   vfs: add fileattr_has_fsx_mask()
>> >>   ntfs3: make crtime user-settable using ptime
>> >>   exfat: make crtime user-settable using ptime
>> >>   btrfs: add provenance time (ptime)
>> >>   vfs: add __vfs_fileattr_set_locked() for inode_lock()'d callers
>> >>   nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
>> >>   nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
>> >>   ksmbd: add provenance time (ptime) and map it to CreationTime
>> >>   cifs: add provenance time (ptime) and map it to SMB's CreationTime
>> >>
>> >>  fs/btrfs/btrfs_inode.h          |   4 +
>> >>  fs/btrfs/delayed-inode.c        |   6 ++
>> >>  fs/btrfs/inode.c                |  29 +++++-
>> >>  fs/btrfs/ioctl.c                |  24 ++++-
>> >>  fs/btrfs/print-tree.c           |   1 +
>> >>  fs/btrfs/tree-log.c             |   3 +
>> >>  fs/exfat/exfat_fs.h             |   2 +
>> >>  fs/exfat/file.c                 |  42 ++++++++-
>> >>  fs/exfat/namei.c                |   1 +
>> >>  fs/file_attr.c                  | 156 ++++++++++++++++++++++++++----=
--
>> >>  fs/nfs/inode.c                  |  27 +++++-
>> >>  fs/nfs/internal.h               |   2 +
>> >>  fs/nfs/nfs4proc.c               |  56 +++++++++++-
>> >>  fs/nfs/nfs4xdr.c                |  19 ++--
>> >>  fs/nfs/symlink.c                |   1 +
>> >>  fs/nfsd/nfs4proc.c              |   9 ++
>> >>  fs/nfsd/nfs4xdr.c               |  40 +++++---
>> >>  fs/nfsd/vfs.c                   |  17 ++++
>> >>  fs/nfsd/vfs.h                   |   4 +-
>> >>  fs/nfsd/xdr4.h                  |   3 +
>> >>  fs/ntfs3/file.c                 |  20 +++-
>> >>  fs/ntfs3/frecord.c              |   8 +-
>> >>  fs/smb/client/cifsfs.c          |   8 ++
>> >>  fs/smb/client/inode.c           |   7 +-
>> >>  fs/smb/client/ioctl.c           | 109 ++++++++++++++++------
>> >>  fs/smb/server/smb2pdu.c         |  37 +++++---
>> >>  fs/smb/server/vfs.c             |  43 ++++++++-
>> >>  fs/smb/server/vfs.h             |   1 +
>> >>  fs/stat.c                       |   2 +
>> >>  include/linux/fileattr.h        |  29 +++++-
>> >>  include/linux/nfs_xdr.h         |   3 +
>> >>  include/linux/stat.h            |   1 +
>> >>  include/uapi/linux/btrfs_tree.h |   3 +-
>> >>  include/uapi/linux/fs.h         |   9 +-
>> >>  include/uapi/linux/stat.h       |   7 +-
>> >>  35 files changed, 614 insertions(+), 119 deletions(-)
>> >>
>> >>
>> >> base-commit: 3bc1fb9c3b20cd478c83496ab16addecb401770d
>> >> prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
>> >> prerequisite-patch-id: 614f0bc9411391403d4e9702bafeb31b0ec04ec1
>> >> prerequisite-patch-id: ddf636b9d33d82ea206ce265d817371350bf8858
>> >
>> > I think this is going to be very hard to do properly, because the
>> > kernel can't really manage this on its own. Something in userland is
>> > going to have to set this value if you want to update it to something
>> > other than the original inode instantiation time (aka btime).
>> >
>> > It really sounds like what you want is the ability to make the btime
>> > settable. Personally I think the decision to forbid that was wrong-
>> > headed and that it should have been settable from userland from the
>> > beginning. Maybe we should just revisit that decision.
>>
>
> Frankly, I don't think this decision was made at all.
>
> There are only 2 types of filesystems in Linux today:
> 1. btime is constant (xfs, etx4, btrfs,...)
> 2. crtime is settable in principle but not via a standardized Linux
> API (ntfs, cifs, ...)
>
> AFAIK, btrfs in this series is the only filesystem which is going to
> have two deviated copies of btime and ptime.
> For all the rest, the deviation is artificial in statx.

Well, my objective with this series would be having ptime just as
supported as a/c/m/btime, especially from userspace in the 90% of
setups,

> So the questions to ask are:
> 1. Do btrfs developers prefer to store a new settable ptime or
>     making otime/btime settable with this new API?
> 2. Will any other fs in the future want to store settable ptime along
>     side the legacy immutable btime?
>
> My take on these question is:
> - Personally I would love to see ptime support in xfs in the future and w=
ould
>   willing to contribute to this work, because I have hard evidence from t=
he
>   performance benefits that it brings to smb server workloads
> - Judging by past experience with i_version bump interpretation on xfs,
>   I find it hard to believe that xfs developer would agree to making the
>   legacy btime settable

so I guess for v5 or v6 I'll also draft a patch for at least ext4 and
xfs.

> Hence the distinction in statx API is needed, but for most filesystems
> it is a pure semantic way of saying "I do/don't have settable birth time"=
.
>
>> Originally I just wanted to have btime settable, yes, and if btime was
>> settable I wouldn't have made this RFC PATCH either, but after reading
>> the already existing discussions about it, I can understand having an
>> "immutable inode creation time", like ctime exists, so even after making
>> btime settable, a new timestamp would be necessary anyway (e.g. for the
>> people who want btime to exist as a forensics timestamp).
>>
>
> Right, but every filesystem (e.g. btrfs) can still make an independent
> choice whether storing one or two copies is desired.
> The API does not limit those choices.
>
>> > Failing that, why not just track this in an xattr of some sort, since
>> > this is really just an opaque blob once you allow it to be settable. I=
f
>> > the xattr isn't present, then you can just use the value of the btime
>> > as-is. FWIW, I think samba does this today, so you could try to sync
>> > with its behavior here.
>>
>> (This is copied and adapted from [2])
>>
>> I actually have been using fully userspace xattrs[1] for a few months,
>> mostly for backups, and it "works"; but last month I wanted to merge 2
>> FSs (and have another merge I have to do), so I ran [1] on all files and
>> then compared all metadata/data between source and destination and
>> noticed there were quite a lot of files that didn't have the xattr set.
>> So I looked online and learned that xattrs only work on regular
>> files/directories, not on symlinks or anything else (and the missing
>> ones were of symlinks).
>> This is what prompted me to search more if anyone had already proposed a
>> new timestamp (instead of making btime settable) and found the email
>> thread from april linked in the cover letter, which gave me the excuse
>> to finally work on a proper patch.
>>
>
> I am tired of repeating my arguments (and finding my own quotes)
> about why using xattrs is a poor replacement for in-inode ptime.
> AI agents can easily find those quotes for those who are interested
> so I won't bother, I just say that smbd already uses xattr to store
> the creation time - it's just bad for performance and disk usage in
> metadata intensive workloads.

(I really need to remember to add the xattr explanation in the cover
letter, it's been 3 version since I wanted to but forgot lol)

>> > That seems a lot simpler than adding an entirely new inode timestamp
>> > that is always going to be a copy of the btime, except in rare cases.
>> > Having to patch all of the on-disk filesystems with a new per-inode
>> > field is a lot more work.
>>
>> > This patch is quite simple, but changing btrfs, then ext4, xfs, etc is=
 a
>> > mess, and inevitably you can't get these timestamps until you upgrade =
your
>> > filesystems.
>>
>
> Jeff, this is standard "how to make progress".
> I completely don't agree with this argument.
> We cannot use this argument to block progress.
> Is it already a long standing practice for userspace file servers (samba)
> to probe the host filesystem for specific features and fall back to
> alternative implementation if they are not supported.
>
> There will be nothing new in this case, that's the only way to
> make forward progress - define the API, make support queryable,
> implement the feature in some filesystems, implement consumers, repeat.
>
> Also for nfsd, that's the only way to ever implement settable
> FATTR4_TIME_CREATE which is the protocol allows.
> This is never going to be possible with custom xattrs.
> So I must say that I don't understand the objection from you and Chuck

Thanks,
koraynilay

> Thanks,
> Amir.

--044bdd0a4a47942c271d04e37cdfe5ff13f45bd18be64b399c47a4223d1a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCav1xEwAKCRA0bnTtJTDo
ONy4AQDh8MSZrQYCROH1/V+zXLEsO4Ud8LKqbexCE1SH8y22aAD/S0syn6cnANKL
b7slZW9g7lq9P8km1xNXs/wJv/FqsQk=
=RUOk
-----END PGP SIGNATURE-----

--044bdd0a4a47942c271d04e37cdfe5ff13f45bd18be64b399c47a4223d1a--
