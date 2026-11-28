Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795829774;
	b=csmBeBE0dI4Qa+dnYD884M/kGelPBT2QaSRxMI9QBy2oL8CUdsJEnAoPClTaOObPtl2z
	 YsTi379g8pIXcO5f7A/jz1Pw+riJPyiFx592OLNKvMmExrBIUzy5Cd7d6fHn5/IAfD0HZ
	 mS96hdGy5TFgs0BS52U+EDjPjGOdCsXYzApyayUm0tfnnX37WpYeCZB+mgrke3VN0irFC
	 NntWmnXZJkrlUQO+yGroYdIp7J2oL0+eRL6Z3HSDTCrYeSHui3fyIzkF0ShInLV/PDVvX
	 pBZQ4gy2Xp6cBeMUhydYwos6tWhBT2xb7z6t8ui7Yzizrqe7qVQhOiF4Vgaz3nC+pNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795829774;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=hlTasxKzbHtMleR5+wkbWGsmeXu6hDEZF+uLQ0NjV68=;
	b=euUPJkDQmUJ4eOBT96Sk/1rcrTJquJ/Sp2F/tyCF/t0t6MQq+jxlnaZlAaiCxUCGgxZ2
	 hq5iTRu0TZzbDYv/dBTJ4untZR7U85WBQeMne3KWVfoV4DDn94mIteTG2M6TnW0CeMtru
	 zB4Pl3NpwswQT5QLg12ly9zBnEN8nc7jjSw5NPhonvKyvsKP9QsgykoyaiehjsJVUmQD6
	 HZLyyfSWa5M9h24u0EKZr/H7AtiuEf8Yf53HpjAy6Koc1cxM0jvyV4ClpI9/OZ0mWZ1T4
	 VhFMA6CBZ+GiZx91HUe+vZNsBCwQZT2Sc2afW5kH/HcEROZA894h4V0W2Ad0qXNf6bQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HKBPY2Ah;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.48
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDA2606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CDA2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HKBPY2Ah
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-67990a45e02so8833040d50.3
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:36:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795829773; cv=none;
        d=google.com; s=arc-20260327;
        b=baYR8hLAK5LVTfK7GzPCe7aC4NCYu4rC7LDJACXDZPPpgLL8kCRfgvKTNw/Sp1kxQc
         AgP8xrhjU852yUFO4PoxSSgc28iwU9XhR9HyhhwAOsCiRUTXsXwlZTUZ85Im3mHdhPkZ
         rFHJLPJ+e0AO7FT+L7HdvhCgARFeA6i/790SETc/vvhW+AKEHvy2IlFqnhsxJUBGwJj4
         gC52aMgSesSDu/GcqZuN9EOLmfQUDmV+lEh4U3bRhqz4OsNC24cktRstWr/4kYQfstGd
         Xu6onLzXnk0KQyaBwkEZ7+F57EJ6R6aDYaabOJhSSPoltMHUzR+flChb9EZ55xnZCvBX
         tG+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hlTasxKzbHtMleR5+wkbWGsmeXu6hDEZF+uLQ0NjV68=;
        fh=F2lQhyuCCN3rHrwEk+8Z150M7XBKMyQO9ffxRbdlUbI=;
        b=i41ek/fAPMCVn9ebFe8K8ZuBfR0ECIHbJ3sauLoazeD4LYmfc/hZrPw/TP4YTbZa5t
         wFfzSvFgM/ezeftQOEqsZzYJiALrIy0TlpFtqe+y/T76Hrz/ZKnzdgFSpEgEnLDYhcS8
         GAVChMOr5v7TqmLbKtENztjKggPS3lRXFwDYJDGDRXFvx0oFZ5erkV2CEZMb/WEbXwQh
         vPb0ah7R/8KLfNlVOk/r7c+dumZFoSIDjvJjbAysiU7P2DVl+sCIMXNZid0O6ZBQ4zh3
         KGP1viMHROtqKyWrwh5RuRZRElKRuBQu50Lndb0o7nb2aQz2vZcMhrwsHfZajGEaqY42
         xdkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795829773; x=1796434573; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hlTasxKzbHtMleR5+wkbWGsmeXu6hDEZF+uLQ0NjV68=;
        b=HKBPY2AhbDKedYOXAH9MlDYYnfxJp+uuxXh37G6UV0Uukdf1bDXIsjclNL4gNhwXZV
         F8xvBHvIEJU4DIT7PQJg2eQtNTxCzKL0cNYMZvRnE0pkElYA/9Uu9l5P3CWtdkyqyKBb
         mg6tvMFGPhLUDDQuIHn3rjGIyPpWWdZ2DkGz2wyQDASUcAfhDXrfij8pDO1tTQhlW+95
         PxiS+65TgYnw5aOpEsV3SYNA7G+fW4x41FIJZUnoBkDZ3TL+6muSUPrlfJsEJNhx1aTB
         qzW9VdTOYFucNWRlzH6V9tJBBNdP7a9c2cU5AKkXpjFqEGYYpLJdwJdLyCH5KvGjVDSz
         /Ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795829773; x=1796434573;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hlTasxKzbHtMleR5+wkbWGsmeXu6hDEZF+uLQ0NjV68=;
        b=E+yRxMCeyZEF0viqG5N9NOFKPpSTKYlXTJ50cdQmE1zmR7Lp7Fj1k+ILTlVS0/VRDc
         6fVeEUwHH1JOf8vBceDSjaBZWsDh2oz7UgTUOf2K92qfMgrujNsiXy9d+yPXIW8NKQzP
         6N4EmLvjyLA5xlTiPiSBrhdYgAD5HtlymjaDXhHZ4xBusf8GgmFyyadDfR6UtBXfPWJu
         WejLXIutgkG6PIHB8HVK2jsSCL7o3FOLeNlIbTWIeUVsWjXIMu9D001os+CKrE8pyVwu
         bHu/6OB4tjo7/0eDOlwNjtmLDndIwOJl9rrmnVaaw89bJAb38FUBVAtMeX73Ba0+sFQ0
         HUGA==
X-Forwarded-Encrypted: i=1; AL+hErGdGyXsZqN3Iqjy8W/sl+7eZE0zFcPXQ06mpkami1UxvAUVvY6yFRTYrjIJODIJHtJXJEweoVMYx5k/@vger.kernel.org
X-Gm-Message-State: APuU4Z/34ZO1YSQimjxaDX+fqPaQmYsEO89FppYuf362h6uoodxH90v9
	uRU/q6adijhpj4+wckRbE91lc+SfBhLMwVwwLSNx3rLaZHuo6K9Zo5jAlUs7s+CZY1CUQHiLfQ6
	tj4LnyZttyzf8HeWdylKQLrddhi9QzVdM1NcAgIJFtQ==
X-Gm-Gg: AZFdTZeUQKnW8skb4G8TQGwOPQz1w1U0UADtqSauz20fI/iGjrwZtPYeL3eWe8wxjIc
	3cIe4ja8XgVY8NjbsH9tsKc57S62U8xCHW9Hd+VYhaGto9CUwGj99wra+olbr5pAbb4EHutl/3f
	lIZkAd9bDv8tLaHvPiBBvDrtwGm2g+t8cHMveSS4GTua8xuLvfvLr23DUhI1NTAX8rwJ8A0clcT
	RLhIXdTS9bVahYE0L8jvBai9R2cb4+F3XXlU7JjM9eLH75HtDWxcUDyPYxCeTIZt27/ssM8riW6
	IEBW16LWdjwfNhXWG76LT8y2IFtkhXh9tosLgbcgF1hIYBqNJWoYeBrVA4WqIEhf55I/D+h4iZS
	SerCsZTp+XiANqNszK62gducH+gxrcwFSP2Tby53q/JpJ/nM5apsEq0UNFQburqQgFFwSMx/NAO
	fPlTQlcb139lMsXT0f72409bzBiZHVElKV/bHQ4nmakDJA6KTZQElSuIeqK2U4JhqRjkdu4eLuS
	oJ3KiWI4/VTyPdPl58Iy+bW6ghaAw==
X-Received: by 2002:a05:690e:4146:b0:67d:bda2:a4f6 with SMTP id
 956f58d0204a3-67df44c4aabmr13817573d50.108.1795829773220; Fri, 27 Nov 2026
 17:36:13 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118002529.250616-1-sidchintamaneni@gmail.com> <2c16f03f9ba10bc4cf508420d564b928@manguebit.org>
In-Reply-To: <2c16f03f9ba10bc4cf508420d564b928@manguebit.org>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Fri, 27 Nov 2026 17:36:02 -0800
X-Gm-Features: Aa3M54rSKmt0il3afckVWFqy1h-RAmFCaFQGHvkbqyLQu4tqXd2WZKI4sY965VI
Message-ID: <CAE5sdEgn4V2JhCPrjcb4gRiPBcxi6GP8cg1JoW3P6Hoqop5zNw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] smb: client: fix cached-dir and deferred-close
 unmount races
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Allen Pais <apais@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org, 
	Rachel Menge <rachelmenge@linux.microsoft.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Gillian Laming <glaming@microsoft.com>, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2026 at 07:14, Paulo Alcantara <pc@manguebit.org> wrote:
>
> Hi Siddharth,
>
> Siddharth Chintamaneni <sidchintamaneni@gmail.com> writes:
>
> > While investigating the cifs_kill_sb() unmount busy-dentry race fixed i=
n
> > "smb: client: fix busy dentry and inode on unmount from late oplock
> > break" [1], I wrote a static analysis tool with AI assistance to scan
> > for the same teardown pattern where objects are moved off shared lists
> > and locks are dropped before their underlying dentry references are
> > released.
> >
> > That scan identified two more unmount races in cifs_kill_sb(), both of
> > which I reproduced in QEMU where cifs_kill_sb() reaches
> > generic_shutdown_super() while dentries are still in use:
> >
> > - Patch 1 walks cfids->dying under cfids->cfid_list_lock in
> >   close_all_cached_dirs() and holds cifs_sb->outstanding_rreq across
> >   dput(dentry) in smb2_close_cached_fid() so dentries for dying or
> >   concurrently closed cached directories are dropped before
> >   kill_anon_super() runs.
> > - Patch 2 counts cancelled deferred-close handles in
> >   cifs_sb->outstanding_rreq while they sit on a local stack list before
> >   _cifsFileInfo_put() completes in cifs_close_deferred_file(),
> >   cifs_close_all_deferred_files(), and
> >   cifs_close_deferred_file_under_dentry().
> >
> > [1] https://lore.kernel.org/all/20261117001733.192399-1-sidchintamaneni=
@gmail.com/
> >
> > Siddharth Chintamaneni (2):
> >   smb: client: drop dentries for dying cached dirs during unmount
> >   smb: client: fix busy dentry on unmount from cancelled deferred close
> >
> >  fs/smb/client/cached_dir.c | 31 +++++++++++++++++++++++++++++--
> >  fs/smb/client/misc.c       | 32 +++++++++++++++++++++++++++++---
> >  2 files changed, 58 insertions(+), 5 deletions(-)
>
> Please have a look at sashiko's reviews on your series
>
>         https://sashiko.dev/#/patchset/20261118002529.250616-1-sidchintam=
aneni%40gmail.com

Sure, I=E2=80=99ll address the comments and re-spin the patches.

I also ran the static checker across the entire kernel, and it found
similar bug patterns in several filesystems and drivers. I was
wondering if there=E2=80=99s a better way to handle these findings.
I don=E2=80=99t really want to publish them somewhere since I=E2=80=99m not=
 sure if
the races are exploitable. At the same time, I don=E2=80=99t want to spam
different subsystem maintainers with patches without verifying each
issue first, which feels a bit cumbersome.
Just wanted to reach out and get your advice on how best to approach this.

Thanks!
