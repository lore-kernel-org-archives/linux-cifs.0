Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDDA30C147
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646285; cv=none; b=oi2XI1+tRrNbDYdyyj5l9s7R3fWXSoSDJLI5vLR2Vu1eF3aO75cYUomMCip/XIqqcybK7zY7WZqHHiswW4rGA28y6nsrfgUFyvmYgU7EcjqMvsY+7smTZIbY/6SpdE9pXTxaBpXFSXODlbhHDMFz9bGr06RovDfxO89zIjt7V4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646285; c=relaxed/simple;
	bh=UpHWC+x2ex12/X/OsmxeQf8Izt53vagWkzbufxq+MwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=llc/GELq+E3q60mXjgbLgzketmHHdsyXPYSUni5WqbJoGIB2gS25mcEWWjq51VUQGHmfiAbGeECoZduTu4oQVDA+C2h61UVn0QLYbdFs8iApR1FGoKhY4ONYMsTc9z6lxGpB0/3/cfmjlUVEUWR+t1J7VqPPbFWlRqeewo40VVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPfaXg1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPfaXg1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B243C1F00898
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 01:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790646283;
	bh=sp9uX2zFfpg5pK5KSRTvk8Ybpazr3ABIsJBvNYrYSqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PPfaXg1iHhAnM1g0d/pQwsmU636o37cfIBxL5rz1zlBC7OUFGLRGzfdoN8d5RickR
	 HiogL24EWHMwbdKAJIIX0+Zv8goF0dzjbvplRKy3zHvTuEN7FEK4YPMgJVZLWDwRN7
	 kVBH/VIin+hWf5Pe6KIyvkd/WLEjBv6zT11L9RLcft19ffrVqwLGOvnaO11dt5Q0ma
	 PZvKi+MB5dS+VBaJF0aLsEvw4kvjlhHpU9Cyp8mNZO1rdQce58kYrUnqPC4oV0gq4t
	 jdpkYjCT48L0tPWU65yEERSHteXkZp4tZaZkEmGPIO8OTNsqpKNtco3tNqod/bAd06
	 luUo0y4zz2e1Q==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c570f6f36so347059866b.3
        for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 18:44:43 -0700 (PDT)
X-Gm-Message-State: AFq9FYL7iTzqRlt5HbrcP1nxZCl0GNn7z4n88BaveYE1ck2EmQ9SwUZq
	CJgFhLsHDH1AY9uf4TH5YTa4Uni8fC59EouBIAB7dFgcOzyAxYa8w2czLFUM6rAw7uonm07NgXo
	jBuOy69UmHii1QGHZfO3ztZsGej7fi9E=
X-Received: by 2002:a17:907:e8f:b0:c29:63f2:99bb with SMTP id
 a640c23a62f3a-c2ac26820b5mr1370695066b.47.1790646282381; Mon, 28 Sep 2026
 18:44:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928200934.1040189-1-pc@manguebit.org>
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 29 Sep 2026 10:44:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-mCkoFH-metAK+PbT2hb+sWmw4HJCCOP3XqOpjgKNorg@mail.gmail.com>
X-Gm-Features: AclHuK9qRWv1LVqtZNcohTCvryiBwziuqL2w9TCldOIHHP97-2mRkDRLZ0kQiIA
Message-ID: <CAKYAXd-mCkoFH-metAK+PbT2hb+sWmw4HJCCOP3XqOpjgKNorg@mail.gmail.com>
Subject: Re: [PATCH 00/15] netfs, cifs: data corruption fixes
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 5:09=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> This series fixes a number of data corruption and spurious I/O error
> bugs found by running generic/363 (fsx) in a loop against Windows
> Server 2022 and Samba 4.24 servers.
>
> * Post-EOF pagecache poisoning on extend (1-5)
>
>   Data dirtied past EOF through an mmapped region was never discarded,
>   so it reappeared as file content once the file was extended by an
>   ordinary write, a truncate, a zero range, a copy range or a clone
>   range.  pagecache_isize_extended() doesn't help here: it's a no-op on
>   cifs because i_blkbits is 14.  Only the one folio straddling the old
>   EOF can hold such data, since pages wholly beyond EOF can't be
>   faulted in, so each extending path now zeroes or discards that folio.
>
> * Missing flush or drain before trusting server or pagecache state (6-9)
>
>   FSCTL_QUERY_ALLOCATED_RANGES can report just-written data as a hole
>   unless it has been committed to disk first, and the O_TRUNC open,
>   interior zero range and server-side copy/clone paths did not flush
>   dirty data or drain in-flight I/O before an operation that assumes
>   the pagecache and the server agree on the file's contents.
>
> * fallocate refused without a read lease (10, 12)
>
>   smb3_zero_range() and smb3_simple_falloc() returned -EOPNOTSUPP for
>   any size-extending request whenever the inode wasn't read caching,
>   since the cached i_size couldn't be trusted.  Query the server's EOF
>   in that case instead of refusing the request outright.
>
> * Short reads leaving stale data behind (11, 13, 14)
>
>   The read-gaps path and the DIO/unbuffered read collector left the
>   untransferred tail of a short read untouched, and cifs could not
>   tell a genuine EOF from a stale cached remote_i_size after a lease
>   downgrade.  A read racing an extending write could come back short
>   and, in the read-gaps case, have that stale folio content written
>   back to the server.
>
> * Unstable pages during a signed write (15)
>
>   cifs signs the pagecache folios in place before handing them to the
>   socket.  A buffered write could modify a folio while a write
>   subrequest built from it was still in flight, so the signature no
>   longer matched the data that followed it; the server answered
>   STATUS_ACCESS_DENIED, which surfaced later as -EIO.
>
> Paulo Alcantara (15):
>   netfs: clear post-EOF pagecache when extending a file via write
>   smb: client: clear post-EOF pagecache when extending a file via
>     truncate
>   smb: client: discard post-EOF pagecache when extending a file via zero
>     range
>   smb: client: discard post-EOF pagecache when extending a file via copy
>     range
>   smb: client: discard post-EOF pagecache when extending a file via
>     clone range
>   smb: client: flush and commit data before querying allocated ranges
>   smb: client: drain outstanding I/O before truncating on O_TRUNC open
>   smb: client: flush dirty data before zeroing a range
>   smb: client: drain and invalidate before server-side copy/clone
>   smb: client: only require read lease for size-extending zero range
>   netfs: zero gaps in read-gaps folio to avoid writing back stale data
>   smb: client: only require read lease for size-extending preallocate
>   netfs: zero the tail of a short DIO/unbuffered read
>   smb: client: distinguish real EOF from a stale remote_i_size on read
>   smb: client: require stable pages for signed connections
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
