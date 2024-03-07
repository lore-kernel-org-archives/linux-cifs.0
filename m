Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53F138499
	for <linux-cifs@vger.kernel.org>; Thu,  7 Mar 2024 20:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842969; cv=none; b=oxUsG1FvKdyOtnn9Bturd3qK2KQNmgxt+QjSkrxm5b2q9SVZt98/1uLZuFBiIH6YdexSSfzscsuXnEFvoqqjc4mPZRMFoOk4lOfdt5j8sTn+4R3l6Q6UB5cQdwXGX702JvuUhM5+wO/WmmbUSf0xgxIfzOld1X4eEIs54wi1nPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842969; c=relaxed/simple;
	bh=S6EjqYZbVHVsXmxxGSgDL80W1cCUfSlo4xpvkbM3H94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CoGtG8WpvBPLUR0kcip+Z130CxYWmNoEeIlcn3AC6QjYLYfGRBPIfONWEp4ooPJxRw2XpQ1MVwqgQrWZBTlcN09LtswWOsCmYdO+gQEngqSD1Bx8cr6TinREEP/Umaj78AmuLt/bJsancmhkJDa15ExEtRP9hTaSmq0JhbwQg6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixsystems.com; spf=pass smtp.mailfrom=ixsystems.com; dkim=pass (2048-bit key) header.d=ixsystems.com header.i=@ixsystems.com header.b=HNulIO+l; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixsystems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ixsystems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ixsystems.com header.i=@ixsystems.com header.b="HNulIO+l"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-47282752fc7so402855137.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 Mar 2024 12:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1709842965; x=1710447765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xbj6kfKYFycADPkyqjTomsxdR3myyejYOVqL9Ut/k0=;
        b=HNulIO+lXCx6DHzYOd/iuDd2s4rn96Nhm+dmaiw55otojMhY1gIVySnJEGGoHjzbHe
         SNbSXO0YhxfZBSwj+cq9T9Qo3K6pCm0FqwEk7y+pZ4oh0w/nULaKQ/qFVHRmZ5m5qUAw
         kG/fANKAdx1KS/wewux9YTwjB4lvnXqReIDLDYlSgX/G9kgwi1WzfjGo9n0veynNFK71
         DsPQU5fpQvBQzXD4pTX/qVwERYazdQ1hHflZNUKH+0xl3qjDu5l3df+IA80ASYpxUGvl
         5pedzc4hKSIJT+JRTZwCKgVPXmZlTUDLleWm4iitOCEZh1lwAF+7JK45bHlzul69+uJP
         bnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709842965; x=1710447765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xbj6kfKYFycADPkyqjTomsxdR3myyejYOVqL9Ut/k0=;
        b=v+8CK3X5qA0LbGwex9pkTPN9w8KY6XYBU8w45ZAALKcnrsuBJxRJd9JZ6casigE/0V
         Hxn9BhE9KVGFqupXBo+u9TIxGDtPlxaAD3nSplrr7xOqtywlDp5cNIYGZWq9NofZt9jV
         HfV3P4Eq8Oql65f+DHxzUAdSHM9pcVO1ntHUkhQG75zJavDZEwmVyDu9gwOZCmsbyK49
         Qjx3ABsonqCT1dK/IhFreEj+ALM3KaVjYMPhPQvE8KCOvuYJP1ehO2WlJmushm76/Q0b
         GiRrMfBc3fdWSylQx/JoGae8PcRpRmriVRafKzs2DN404aOz1y6Oe1+FS+9N3HuEXfiT
         jIZg==
X-Forwarded-Encrypted: i=1; AJvYcCXAYrv8QOjPxn9xbkriG7L90dmV2t6vJTwWAp9r15MPuhusHwQ9lL/ZsYLoHh7bisIdeDoN53JBbHJzULgc8N653oLM1ehydVBsiQ==
X-Gm-Message-State: AOJu0Yxw3WN2qOQBLim4kBpjpKWKjCnP1VablapYLUX+HzCyqJKRLrV8
	GN53eOXHfPvp8Vfz8xruWZaQmxM3+wrxc0W5bBnkcGcyVKTaTWw7aLH9m7tFR6+xEiIN6i06+B0
	hUMoTThNvvinXGAFjOE/Ov3A95qoqXgagj1AR
X-Google-Smtp-Source: AGHT+IFronwxMMHkcckLT9rFBLjnZhvZHnpYrjZvP+dDG/QrNH6L26ofm9YjWXE2n0J7F43BCIlvZW8mc35ZPNBPzAA=
X-Received: by 2002:a05:6102:242f:b0:473:886:5616 with SMTP id
 l15-20020a056102242f00b0047308865616mr1518189vsi.5.1709842965693; Thu, 07 Mar
 2024 12:22:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mutAn2G3eC7yRByF5YeCMokzo=Br0AdVRrre0AqRRmTEQ@mail.gmail.com>
 <CAOQ4uxg8YbaYVU1ns5BMtbW8b0Wd8_k=eFWj7o36SkZ5Lokhpg@mail.gmail.com>
 <CAH2r5msvgB19yQsxJtTCeZN+1np3TGkSPnQvgu_C=VyyhT=_6Q@mail.gmail.com>
 <nbqjigckee7m3b5btquetn3wfj3bzcirm75jwnbmhjyxyqximr@ouyqocmrjmfa> <CAH2r5mt_FY=9Dg6_K1+gYMAKuyPAPO0yRZ9hKcLkyypmUjxQZA@mail.gmail.com>
In-Reply-To: <CAH2r5mt_FY=9Dg6_K1+gYMAKuyPAPO0yRZ9hKcLkyypmUjxQZA@mail.gmail.com>
From: Andrew Walker <awalker@ixsystems.com>
Date: Thu, 7 Mar 2024 12:22:32 -0800
Message-ID: <CAB5c7xrnE=egCK3iD1=OSNTaAvRqQRJK_wWXdogfGN5TDCHq_Q@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] statx attributes
To: Steve French <smfrench@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Amir Goldstein <amir73il@gmail.com>, 
	lsf-pc <lsf-pc@lists.linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 2:04=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> On Thu, Mar 7, 2024 at 11:45=E2=80=AFAM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Thu, Mar 07, 2024 at 10:37:13AM -0600, Steve French wrote:
> > > > Which API is used in other OS to query the offline bit?
> > > > Do they use SMB specific API, as Windows does?
> > >
> > > No it is not smb specific - a local fs can also report this.  It is
> > > included in the attribute bits for files and directories, it also
> > > includes a few additional bits that are used by HSM software on local
> > > drives (e.g. FILE_ATTRIBUTE_PINNED when the file may not be taken
> > > offline by HSM software)
> > > ATTRIBUTE_HIDDEN
> > > ATTRIBUTE_SYSTEM
> > > ATTRIBUTE_DIRECTORY
> > > ATTRIGBUTE_ARCHIVE
> > > ATTRIBUTE_TEMPORARY
> > > ATTRIBUTE_SPARSE_FILE
> > > ATTRIBUTE_REPARE_POINT
> > > ATTRIBUTE_COMPRESSED
> > > ATTRIBUTE_NOT_CONTENT_INDEXED
> > > ATTRIBUTE_ENCRYPTED
> > > ATTRIBUTE_OFFLINE
> >
> > we've already got some of these as inode flags available with the
> > getflags ioctl (compressed, also perhaps encrypted?) - but statx does
> > seem a better place for them.
> >
> > statx can also report when they're supported, which does make sense for
> > these.
> >
> > ATTRIBUTE_DIRECTORY, though?
> >
> > we also need to try to define the semantics for these and not just dump
> > them in as just a bunch of identifiers if we want them to be used by
> > other things - and we do.
>
> They are all pretty clearly defined, but many are already in Linux,
> and a few are not relevant (e.g. ATTRIBUTE_DIRECTORY is handled in
> mode bits).  I suspect that Macs have equivalents of most of these
> too.

MacOS and FreeBSD return many of these in stat(2) output via st_flags.
Current set of supported flags are documented in chflags(2) manpage on both
platforms.
