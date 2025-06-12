Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CC62BE7AC
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750967; cv=none; b=DeOXvgqpN1IKAL1tyggESDsePIs2B/xdc+GOm09PnAnQ12zvhXT1NMPPEAGEob4vDsQQKejl5NpbcfpglOAUfJKqvtdn3b09rryHXuoTb9hLSqnIyK51AWaXamRWrj1FJco0yjgprNJwh+rMZKCRM5vj14jAKgrwnLmRfhmVb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750967; c=relaxed/simple;
	bh=gIsrWc+2O4wYnDqj0tg0AUiR8sOkv52rkYRASsiP/sE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=UMlyU3H6PeeSDB87vMAY6beiZfXUyAHj0K5Si+3t3GNkR13dL1tP9fSgUfrdMAhQddcT0aFXx4fQVyldpq02GBnB/xVVJJ9P3L1+mjuomNNNmbKqoluwajzeyWaAEXRVkjIT3vdSZtmCiYOX+9hKi56KK2/qSNXW2HoLNDhfO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Djp6nRqV; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Djp6nRqV"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-607c2b96b29so2650191a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749750964; x=1750355764; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnwyBG02PAoJvFsOjGTHHBT0puIMX9Zn35Du0y8rYEM=;
        b=Djp6nRqVFx9SyBpRWSnk4p6b5ajUlksrYSuQRaKbti3qNFcHvHgUtjquWY9bf87VJ7
         b3SiVaac7ClZstnIMtiLy13TBtTA13gdOlaeOL2wL/crOL4Y8kyPitx5YE8SCPPnbQUE
         CbBYEDt1aOlQsFr7jB+aVIHtVl8OdfhDC2W6UxyCbz6dnFf3VLoUAib7At5LWqRu9Lal
         jGuaSkmqt7mRNwvYrZO79sDlW1egrItEmu3k1u50ojtjSQAuZNPQwDdZfyqcJyhjLbWw
         J44uE0OtbmWFAucvk5jWdpY94g4yeRbz/ElZxlLIdPZ+EVM2NGxUnQ0m/iLJZu9P57iP
         P9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749750964; x=1750355764;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnwyBG02PAoJvFsOjGTHHBT0puIMX9Zn35Du0y8rYEM=;
        b=srxoeIDkHbpVORQa2vqNdqnPGEEJuFUasM26Uvj9vHHbmftoJUqvSaXB+fQd5u6M7g
         n1tCcrBl1cIJIhIDhtgqL+ebaHRQM3QE87JxrtIai+R8zwSYaAd3IRkZJ0etXB0sz7nA
         x5UOSxffTNNv2iIPGbS6ZZ38djH1AlfZP9pkVYGWdsim/sm0+5bASvEFq8n0wUcywWd4
         IQRPgfKSdQcYomCd1lg8RJ6m7aDAKMRl0QovHH7GB0HJObNB3ZlzHnJ3WKYHObFGSLjQ
         CnuG+100z7E5sWi0i1AUmCUyRJHgJdQ6z7OO57iU7tJAGChD2tgGWSSRg21yo100Uq03
         z+Hw==
X-Forwarded-Encrypted: i=1; AJvYcCX20p48/Wl+PXeHCriItyJ304ZbT1zyypQMbzOmTocKPTc2mnFybgSeLUD6pdHbbRYh/P44WMBTf7nI@vger.kernel.org
X-Gm-Message-State: AOJu0YzhcDfl+dxBorfC21XBHEL8Q1f/tdmiml9tOEUrrFiHNhje/y1N
	DqCvL9drgfGWjN9EmzpdqTC9dXTVGQxxRSQVRIYsFri63Q99Iu70ANCNbbJL6eKXz7gYQSZStop
	zevcjLrvvRwP8QYiK2p4svle4K4QxZ4I=
X-Gm-Gg: ASbGncuSV4cLsJUbUOwVbJ7G8f1CwsLxVoMsfuzZ2FzW5iR1sOh8tF+7/9KZCCK8cJL
	jdzXowadL6jaG91Yxa5O0DPAF8NSRoWOCI58zHhKws3/Ad6UGKCQTieMkKVDi1fDjwGAZCR65ID
	+4sm7Xx3ZzXjyTw6Kd3x1D5TCKw86NyveKStvpBEuBVQ==
X-Google-Smtp-Source: AGHT+IG0RJE1rboRkEyI50nSMb1yYDCxBq6mW+PGcADAi4AfKCNoQxzirJ9xQhis3ZoiPNT/V/KVgTMacepbnh1FsOs=
X-Received: by 2002:a05:6402:26d3:b0:607:35d8:4cf4 with SMTP id
 4fb4d7f45d1cf-60846ca9a2emr7972043a12.25.1749750963710; Thu, 12 Jun 2025
 10:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-2-sprasad@microsoft.com> <aEpIiybxbTbIbDBP@vaarsuvius.home.arpa>
 <CANT5p=oV8SoYT9AWBCBU5uVFaboeWFyGw8jj9rckLn1eyOj3Cg@mail.gmail.com> <aEsBUL0c4wuErOjc@redcloak.home.arpa>
In-Reply-To: <aEsBUL0c4wuErOjc@redcloak.home.arpa>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Jun 2025 23:25:52 +0530
X-Gm-Features: AX0GCFsqJ7067WWZ8Pl0Sum5POKdD4BWEbtCmdGNIW_5mgUnu0Fn_9e5Ix6lvHM
Message-ID: <CANT5p=onfDfYua88sPoE-S+RxPKDD1dGQ1_4GzEs2U5ZaZj=EA@mail.gmail.com>
Subject: Re: [PATCH 2/7] cifs: protect cfid accesses with fid_lock
To: Shyam Prasad N <nspmangalore@gmail.com>, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	bharathsm.hsk@gmail.com, meetakshisetiyaoss@gmail.com, pc@manguebit.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.de, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 10:03=E2=80=AFPM Paul Aurich <paul@darkrain42.org> =
wrote:
>
> On 2025-06-12 18:35:13 +0530, Shyam Prasad N wrote:
> >On Thu, Jun 12, 2025 at 8:55=E2=80=AFAM Paul Aurich <paul@darkrain42.org=
> wrote:
> >>
> >> On 2025-06-04 15:48:11 +0530, nspmangalore@gmail.com wrote:
> >> >From: Shyam Prasad N <sprasad@microsoft.com>
> >> >
> >> >@@ -220,17 +225,6 @@ int open_cached_dir(unsigned int xid, struct cif=
s_tcon *tcon,
> >> >               goto out;
> >> >       }
> >> >
> >> >-      if (!npath[0]) {
> >> >-              dentry =3D dget(cifs_sb->root);
> >> >-      } else {
> >> >-              dentry =3D path_to_dentry(cifs_sb, npath);
> >> >-              if (IS_ERR(dentry)) {
> >> >-                      rc =3D -ENOENT;
> >> >-                      goto out;
> >> >-              }
> >> >-      }
> >> >-      cfid->dentry =3D dentry;
> >> >-      cfid->tcon =3D tcon;
> >>
> >> I think moving this down below to after the "At this point the directo=
ry
> >> handle is fully cached" comment is going to regress c353ee4fb119 ("smb=
:
> >> Initialize cfid->tcon before performing network ops").
> >
> >Hi Paul,
> >
> >Are you referring to the tcon reference?
> >If so, I think the way to fix that is to get a reference (tc_count++)
> >on tcon right when we add it to the cfid->tcon, and put the reference
> >in smb2_close_cached_fid.
> >I think that should take care of any concerns of race. Let me know if
> >you disagree.
>
> I don't think that is sufficient.  cfid->tcon needs to be initialized pri=
or to
> the network operations in open_cached_dir.  If we receive a lease break f=
rom
> the server and the delayed work involved in that runs *before* cfid->tcon=
 is
> initialized, it leaks a ref.  (cached_dir_lease_break has a direct copy o=
f the
> tcon passed as an arg and takes a ref from that, but cfid->tcon is still =
NULL)
>
> T1                 T2
>
> open_cached_dir
>    <open+lease acquisition>
>    (gets far enough along that the file is open and lease key initialized=
)
>
>                     // receives a lease break from the server
>                     cached_dir_lease_break
>                       // takes a ref on tcon (via arg to function, not cf=
id->tcon)
>                     cached_dir_put_work
>                     cached_dir_offload_close
>                       // cifs_put_tcon on cfid->tcon, which is still NULL
>
> open_cached_dir continues on at this point
>
> Another reason you need to initialize cfid->tcon earlier is that in the e=
rror
> paths, cfid->tcon needs to be valid so that smb2_close_cached_fid can act=
ually
> close it.  Before c353ee4fb119, the tcon was initialized at the same time
> cfid->is_open was set.

Fair points. I'll put it back where it was. Just protect it with the cfid_l=
ock.
Although I'm now wondering if we'll be hit by some weird race by not
using cfid_mutex in lease break handler and laundromat thread too. :)

>
> >>
> >> >       /*
> >> >        * We do not hold the lock for the open because in case
> >> >@@ -302,9 +296,6 @@ int open_cached_dir(unsigned int xid, struct cifs=
_tcon *tcon,
> >> >               }
> >> >               goto oshr_free;
> >> >       }
> >> >-      cfid->is_open =3D true;
> >>
> >> Moving this down below is going to regress part of 66d45ca1350a ("cifs=
: Check
> >> the lease context if we actually got a lease"), I think. If parsing th=
e lease
> >> fails, the cfid is disposed, but since `is_open` is false, the code wo=
n't call
> >> SMB2_close.
> >
> >That's a good point. I'll submit a patch to fix this.
> >
>
> >--
> >Regards,
> >Shyam
>
> --
> ~Paul
>


--=20
Regards,
Shyam
