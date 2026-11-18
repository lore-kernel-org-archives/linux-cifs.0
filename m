Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024254;
	b=P85TzKY95G6KNUlWSZUEy7jda9e/RpsUwq6QcIdS+dgWks6xm6TPw5t28EHRZDZbJ9Jw
	 m+RPx9+E0dv8D7E7GwtbayBhMR4VukvaS0czJk54AeMkbb8mZJWlpQcg9XxOTmbm6+j8Q
	 ouk8bQb1O22pQsickhwEti7b4OZS/Y/oSB5WtVUIuIw30ghPFbZ7L3JvnKdKZLAWHjlOz
	 hORbJ8CQsG2IpqyB2Vap2+XIsIqOXTT3wge/DjksiAIObmQIPPxCXExvsOoqVtF1gXD7X
	 Hhanzg8rUPVPmD6qcku5dSPgJvVPQDvJ1Z5m0n5mssERk2bpCYeUh93d/OlTEyF877A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
	b=sCX7Q9GWN4Yqlh9uh78st2NKNEIAJK5quSBYXBwoX4eVHQMQbZfU/qaUI+pcIthK6eJX
	 w1AjAxhENalY3NepmIcGH/Em8oN6lkbY6PbeRR98yj+2spSRQjXK6oFWuhDonfdnEp8iz
	 AcHd52s2SCvcI58A5/CVL3xdt/NyhzHH7/N1eh2S/zeyUdePtzGhkiSY6qbxzAW78b0v/
	 OSobQmefEdxKX9cutLabjjvJPSDQjts0MEPwksRa5eq9xKVpXzvx6SCd64P3fLq8LzXQj
	 js/pEY+tW5ZI8Siq/RJjsih1HeCfq0QLbD7cpRMDMZS6tMvx43LrIjx9EBKOf7Aumwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46460A2609
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB46460A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so1682333a12.2
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 09:50:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795024252; cv=none;
        d=google.com; s=arc-20260327;
        b=IawTb707Pp93CPCY855cEYi+R13dOmwUeKH+fEXD6JVdF60xPUobck2Qx42CJglyw2
         hlS83VZc1HtLKg7atTMrd7vtRYKW5lVEXN+fYkWKFgrSsLJ9Sn7d+KXWWGaaCS+OtGnl
         wK6YD8TXQP7bPlKjV4x6ZsN0v7rtnFNzQLiqAhE76M8rk2aNKC4HTl6oJVODO/B8rgx1
         kW/hbNpqzAqXQNiHLTaLR634D8eOcusYW3RWnxVXzK4VlBWBNS7A4UW7Fzl9PVMvi9mC
         /pjhU9nCiVwoiUfXqM6a1NtsT95KoxzquI3zmnvUi0vlMEmt3wbTANMXzhdvgAWjCt+x
         OvaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        fh=XH+b0HWXadXLvnf0+T3nFUPx3OMJnSuA3zUDPkB6dyo=;
        b=Hdlam9Hmkj3yzcsxz+N+/BflVwy85NH2plfcgCOWmUSveTbR8U3c1MdnreLMXJeXzK
         roTn5rgfputA+zdAhyS8Ii9+C+JFp2x5USnrQdMf3dTI7pPJU4s7XE2vexw1P0d7UFRz
         fYs9PmImeZaST1/neZmjx0ACbOcC/qP85pBZNjeWItfdRUKSlUPU6dtlZPa9KqYVgcKp
         JxE0RusYg2p5WsJEY3/gv1SG2cRiRu0y+EiaDy1qOxNNYg/yNaIvs+fQ2DiXT4TvRiJu
         KD2RKs/R0p7kKgkVgSYYY1JKgbqStcUxIfjnm+GUDLA0gLdqN7DMrFVOZgEsSBWbee4w
         RB3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795024252; x=1795629052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=t0urFznsvrKRqixemRUZFc9mgXym3XN1YMBmj0waBLyV3CsdgnHy8xmpMpLBOjvFSO
         4OyVbjrHe3QbmjmaFHziwXJZHZ3OpkdyrRZKOYWCdCJexvqSmUuVu4fnaP7X0VKW/H2Q
         uU2+obaBKEAHGKd8XWt2iDtAO+W46sMhQn7B0F4IN3mylmD+1QrZ9esi0QvoH9kZT9bX
         EBKM7Z1u6o+AxA5zR70zZUIovWhwqLZJa6oEexWqxHL96XtNRn01UmHNOonMpcB3gc6f
         RbyVXVt9WSJBogGVLF5lTsidaWxQ5lTI8ZoKmu6C/MRJ9rExNu7Xb6AIdnGzmI6derxu
         Duww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795024252; x=1795629052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=lPWmTb41zNmvweOR3vQnoyL6lSUIiOhybU5fWDDOB2D1nzK0G7kVSw3fOWwKYtOsFS
         aYSUJ6zfYc6gFxbv1KjmoQwfYLPtBC+t1urWG5DxOYSLvuws/IYQKyWLbmIGGsCtD5V9
         zxTEX4E3m8ALKWVW1NE/HIsouVEbz/J231NL5mfvxdMU7K/25u4H7BQlaTxvAXyU+cjN
         XxXza/rA8ypK7KDwGmw0zdArDhnW7gJJM96GcnexkV5qjaiFCHv5TV1eTBrS3XvLnh+Q
         +bWwlEoP/MJzCPd+kcnseewH5kCoN3S2CDbwcN82nfS0evH07d3pCp5rmQXA4XLCy+cu
         gsKw==
X-Forwarded-Encrypted: i=1; AL+hErGHQj+DgocxdXKrIcm3sgxHte6qlzWA3g/hldqbwAUFDuL8w4zvwoAvRwJaeH40tJA4Ym3QwGXUTWEC@vger.kernel.org
X-Gm-Message-State: APuU4Z+oZuov7yO6wsN8JCDqDH+x146plrmHCjzTPzMVy7660cc2Anig
	mp6pCpo6SFK4LU1Dk/oE7Bu1pmDuQeTE4Fk4Wkw3rjVUe1G+vO7DCyGDVcV/py1dYjuDQns6RUx
	Q1oC6Yv3+KCO7AP2V0Ro2u0HC4DSO/P8=
X-Gm-Gg: AYBFou2b2wLp++AKk42XYaaNOZW+4ZWrgIydhDLRRJLEkOfZK7g6j54x/iMnr7o4UeE
	G7rjR+D+lG2iLTjYenPV9Hqv13kIz348kReIot8blmQsIzhxXdDyq0SnhYw5M+iuk9Sphpd3qA8
	LFvclbjuqn5799Fj2xHjWinxS9IjzwFWaDtOb4CBSZ5tVLw58Q0ziIZA0ZB19K4sM80iHTHIWHI
	fX4pxPwzk/BiHqouR2L6xZMR/6TbCuHCxKoCN3uFGFmArUssK1Pp2Cy7GcPoj7p0/QJXUGkNucw
	MUiW7EjDx9j92xIIVLZURC+Ikjg/e8f10atoBpTzd09GoGmKgZlxA03Eu3yn8gR6dnEuSXdM8g/
	VlIrEQaU9HO5SVTm3M0QVwXScoB+zQJvPpfGsLgmFQQkeVQMiH8MWFMy9PemZYbZDzl1ExybDzN
	rijaNGJz0PKMH/xuM=
X-Received: by 2002:a05:6402:5411:b0:6b7:df0c:18d0 with SMTP id
 4fb4d7f45d1cf-6b8a2e6d881mr1966295a12.11.1795024252167; Wed, 18 Nov 2026
 09:50:52 -0800 (PST)
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
 <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
In-Reply-To: <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:50:40 +0100
X-Gm-Features: AclHuK8-cETfcc5mQcfuFgReFzNL3uUqtJJFv8XHOum7KdV27M9jJ90gtN64MvU
Message-ID: <CAOQ4uxidYWNVmoPgxKrxesXTxpMB-JqUZx9p6xXZWD5m+hJ+JA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
To: Jeff Layton <jlayton@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, 
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

On Wed, Nov 18, 2026 at 6:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2026-11-18 at 18:28 +0100, Amir Goldstein wrote:
...
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
> >
>
> +1
>
> I think this is the better approach.
>
> Looking over some of the earlier discussions around this since 2010
> (!?!): I think some of the XFS devs objected to making it settable for
> forensic reasons. So, on XFS you might need to rev the on-disk format
> if you want to do it there to preserve the "historical" btime, and
> maybe some xfs userland work to make it accessible for forensics.

XFS_IOC_FSBULKSTAT will likely continue to publish the original bs_btime.
if a mutable field is added it could be published as bs_crtime.

For forensics this should be enough.

>
> For the record, the statx manpage documents the btime field very
> sparsely:
>
>        stx_btime
>               The file's creation timestamp.
>
> There is no documented guarantee that this will be immutable, AFAICT.

Yes, and it really isn't immutable for cifs already.
It's just that we don't have a standard API to change it.

Thanks,
Amir.
