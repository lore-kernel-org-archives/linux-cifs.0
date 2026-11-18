Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795019817;
	b=Bit+oiBWTPvimcV2rVKkdr7jNB/3btKiv252YtxvqKeOe5NgyW+fmnEaOdB3MYHvcHr3
	 /YeFKVDxfdYnqoUxmrr9/KvOiV+DTUeNaIaQm+5W0ZP23caHRwTqu/ZulE6o7yUJUkmc2
	 sTEt/JavEGQGelwTTHlhvlO6nkxZQo3LB/u7zzzgr+dToDinChooyAfoUytaM9k6oCred
	 3wdghM+jSGvxDfrM38Ui4GZGElKe0U6kh6ofSNZqd153nvWX/4zs6SpHkFupq4Vb6pvTS
	 yupTlc6NU7JgOoDvcVQcNRBLiRhDXCzKl5MDrwGTkU5oiaytLebK3uoq3mz9+r0mzhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
	b=WYSDUqPW3jpvnbRosoDwzpIw+XhkRMhkVID3rBNYRBONdMkV7Bp0kzDkhIIlzkugr1PX
	 3Wezl+EgB4AK94W+3sJSKGvvtJKudjfyb/v5gNJBknJSFsOuRdNYf/Cf0t9UhYBiyVDXM
	 QvE3BfYeHqQgy939gnbgSupl53Vg/yWLNvyrBQnSYPGPilQzCWvTgFF6c4tTps1i4c7eN
	 ZPLEf84+epp4yMIXtdV5oWL/zKAk7u5kmlXSRd+RHh3oSAxXvNbzHscODHzXROJHcqL9R
	 /UXAirTwES4SZ44ajrgiTjVOxW7+veKNb1iBRvVmk8wpoo5jqqNp6PUM7o0L0f67B9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C062606A335
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 16:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C062606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b8a1f59d5eso903806a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 08:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795019814; cv=none;
        d=google.com; s=arc-20260327;
        b=mN7wqAaDGK8llqCulkO6F6zoyCN5b6HmBp0aF415VrHguLv4ESvMINVVuuL//8snN+
         oZ/Wk30JCuTNRp4wRPrpQSgH1yxb6KQdnlqkzQwRlf/B/SYx0wnoBJgbEWmkmdG6dDU1
         QhTjBKtGO8NRrxBnUGAc4WlQUN5OtF8sSg3W/LwN0MXH1QvIggsLaD6WZU6wV+lh2UHH
         WWcFEEpS+BrKwtGPw82DFpU4fOPuOEwVOpApPM3V+hKVRKl8jZOWdskp2hgHKhBsm47K
         pIdGDh+orDLP66v0YpSwSn0VX2/gfJS8vJQ+9QxNsd6sf732k5J5o8J30+gEuqi6Mf0a
         1RsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        fh=W1nUjaurUDqIIfCtsiJHZtXyOstMQn8/9i5ZCs9IB0A=;
        b=qlITuMBL5+wAt9okBqByFi/2ZyNBxxwoWl1bl3aO6xRfj9LK6rHe6a13bDGWT064q6
         BPT2q7Ht30tuZN4TvQCrDZuXVfx4sU91eMcx7AX6qhi0A/I/A5uq5c3BGtWhR4CA/aAY
         pJ9Q27iXOaoEtRYjdqT0immLmCV6wuCYWCmkT2IbV9GQhNUun7QHDcrmVxbrfXFWs5Es
         mumIRDi+Uci/odcELuNKHIfkT6hpFZRzbcnsLYvKsXTX5V6UwpMgp0lxo0LzCj7ED51W
         FGnPdJ5c5ThFMaQ7iUvkgxsAAfq0b834SYhib3dJJfSmQ+njHEAbyv92k1UkUf7vzaW4
         0MkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795019814; x=1795624614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=Q928FUfp2LnQkjGEnKMIMu+nIXWPV8Mw0HjVjFDQa7MZUVLuYPLFwnsc7iiHqC360u
         Kp8IRabh9aATlCbBIrXYC8LB4ujsA2WowQnPl0onFZOSJ5rVYhQ50HD2q0pTUJXyKimM
         OUL77cTMfVDMrYjz/NQW0TKyEQpYRFMt7Ju+HVxVGfRQjrSAY87Mpzq+C/2x9bC6NTow
         OtYFWyMzdvLEcoERGP5aXpJZMZOJljjkWPd07rML7zS6cDn/RnBxJCXaYM/7fpaXHvui
         3d3div9gMzI9ed77/rJrBt7B9+fw7rgFDQ4NESvylFpmE6QFtWC5GnB6Lj4Ro4sGb6Nt
         AJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019814; x=1795624614;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=YEz4jWlt2hrNhlDEGsedFWKhSxdiM6pgD3Dg0gDlGhC4Ba3XdCPbdJcGtXoLbFkKje
         +Rqx9gvt7C3/tRLZ75M4Nq7THfxN/is7K9GfuajKsS8d/fqPqu961PLs5dNqUsGoA6Uk
         nJe3eYor3uHpm+fGYJI76LraTqn67B98nq9FH+uSdpvLH14hk871nDr66jnBz79ObxQw
         UMjfxf6rGLmxTij2G2Jaqqq+3HvhPFH503eQDMMgh2tIgEb12otTx2AhafsuWoxyXugh
         s18zXGm8EtUc9holxu63zjf98J10eTd3uDXqLM4Zb69NpCTGQvEro9WzeDVlSNe26kgr
         xeGA==
X-Forwarded-Encrypted: i=1; AL+hErF5BfJ7y+5TKN/EHWRy+2RK6LKo4HgIAzGQG17IWS69f23EhplNdTcLi99LA3OwqcdQN3/4r4BZ/Ca9@vger.kernel.org
X-Gm-Message-State: APuU4Z/u4l+ohpSnA8QYZLWCzPA0RSVM+eL/hV88ny7920xWxD/Xd6t8
	GzpDd563k7EvgQan3bNkAQNA0rbFEsop8d/KNgKhY0AVyJ+KzKS4yhBHUaQjaczeeR+FMLd7/rN
	yWA/9nxOK4qEU6aUYoo9yF4gRIRut8hA=
X-Gm-Gg: AYBFou10Gr4xSW+73L/jCE1yZYpxKp23879BcmLODluLDzh0wzxk4qDV5p6SSZ3L7Fu
	+b2eliloMrLlc3onmTQF9cyFNfSjirLeOn5A1s2HdLDtcKsn1UnbUtvQlsoDcICwIgj1R3yo07x
	XPWZ0EKwtSNqFauVodVr8W4ug1yhRewdYWRsReXrJS6KaTHZG0QvTAEKdrpZJh07sL30Om07tdp
	cxNiw3O9NPL28NrWtH66hRDKYTm+IR1uhBq0A32YzxBBKHx0f9Cp6v2xPoY7oJuZe/1a4ViUote
	M8Ac3NrGIEITrLyHJ3QW5rLNLxehNbfVCYZP5EbVABBrbY6TOuFlOOQTUtoktL7s7BLVJ+FJwqv
	2IEjNToCjjlQ0kLMlt4eHtoB25A20MpsAZnjcPDCinkjCTveKuEIKDXhBG96dK+ZQffIFzA==
X-Received: by 2002:a05:6402:c711:20b0:6b7:b12e:1638 with SMTP id
 4fb4d7f45d1cf-6b887effc26mr1999145a12.37.1795019814317; Wed, 18 Nov 2026
 08:36:54 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
In-Reply-To: <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 17:36:41 +0100
X-Gm-Features: AclHuK_Wot5qcfi8_9CAebWCtd31KyKZ5gW_T2w6JAANm_7TsCfaaSyfxQBsTLM
Message-ID: <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 5:09=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 2:44 AM, Amir Goldstein wrote:
> > On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> w=
rote:
> >>
> >>
> >>
> >> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> >> > Implement provenance time (ptime) in NFSD, as introduced in a
> >> > previous commit ("vfs: add provenance time (ptime)").
> >> >
> >> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> >> > CREATE, OPEN and SETATTR compounds.
> >> >
> >> > If the underlying filesystem supports it, use __vfs_fileattr_set_loc=
ked()
> >> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. wh=
en
> >> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >> >
> >> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> >> > STATX_BTIME, preferring ptime over btime if available, and advertise
> >> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >> >
> >> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> >> > Signed-off-by: koraynilay <koray.fra@gmail.com>
> >>
> >> > @@ -3646,7 +3649,14 @@ static __be32
> >> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xd=
r,
> >> >                                             const struct nfsd4_fattr=
_args *args)
> >> >  {
> >> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> >> > +     const struct timespec64 *ts;
> >> > +
> >> > +     if (args->stat.result_mask & STATX_PTIME)
> >> > +             ts =3D &args->stat.ptime;
> >> > +     else
> >> > +             ts =3D &args->stat.btime;
> >> > +
> >> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >> >  }
> >>
> >> I have trouble with this approach.
> >>
> >> We've already established that, for the Linux in-kernel NFS server
> >> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> >> does not permit NFS clients to modify that.
> >>
> >> After this patch is applied, the server reports the ptime instead
> >> of the btime on some filesystems but not others.
> >
> > In other words, for some server filesystems FATTR4_TIME_CREATE is
> > settable and for others it is not.
> >
> > Isn't the NFSv4 protocol equipt to deal with this complexity?
>
> Not a question of whether NFSv4 _can_ do it. It's whether it _should_
> and whether opaquely choosing a settable vs. an immutable timestamp
> on the server is the right design.
>
>
> >> Essentially this changes the semantics of existing files that have
> >> a btime set -- technically that's a regression.
> >
> > I fail to see in what situation this is a regression. Please explain.
>
> Any consumer that depends on btime being read-only is now screwed.
>

Who is the consumer in this context?
An NFS client?

Can't an NFS client be connected to another NFS server
implementation which does allow this?

I can't wrap my head around the problem.

Thanks,
Amir.
