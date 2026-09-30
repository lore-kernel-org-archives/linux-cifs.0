Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28DE374A05
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781470; cv=none; b=GHLToWFNvq+QnhmLEg6C+5j9GKEOEMqe5Q8K9dL/4X8Dn4Unvaqt84sJz8mM/lTkiemCm7BU9A/vxyh60CxRxlq/m/TwuS/NtPaqKZIkJufCKmTeYpK3iE0oNF/B9TdyBmRmvH8i/IyRYxz+78q3lztEZovxV1whNh76tMnXdkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781470; c=relaxed/simple;
	bh=18kZ8PnP52CRB5IvdMYDi+jRrKH5wEsbLEEmFjxLp8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rYZYwdXSoRIZT+g9ehE9sbki6hzmwItysm8uNrfFerzNY5oUayqKpsOvXfjLHuBOTKCcAEf5/dzZB9B+QxdqjLeywZ0+O6OUok5uRju43KJKm5ELjUuwII1GYrrBq1mgMBY2tb7K+jEJgIH3cJsGYG6ddoKf26k0LP9XvLIol/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TLpzsh6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLpzsh6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC311F000FF
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790781458;
	bh=yzDSJePxqrjjuXwILoDgCSkZpGfsogLk6JJtjsdaFyk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TLpzsh6jorD4stADLHECZ/eIS9Zrug7fJyC3Si6pE6xcZFHSV1yRl+q3kFcUYtdQJ
	 knCnnMZ0CasHen4CtAPxUyi4UVjfeTBbv5rV3NhPxkFru+txmqOcSVN0GT3Dlt/xKP
	 OyPvy8ZIbRD1JUDkVdNRXpVjH3hz6xp7U4K5m1vlGERSVhgOZwP6J1sFXlM2I3mBZr
	 bzY/5jEFqUq5H7ANPl2wNs8ig1QJyOwOlXNXy6ODlvltoisYdLeEQSvkGGqkrR335J
	 JLv5s4LY6ulXa7gJPpl8PmBA2wJcfkIsA4QQKvOTIctPS3/kpFbvXDm7WA5GRF/+re
	 bi049VN6/FScA==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb796so770744666b.2
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 08:17:37 -0700 (PDT)
X-Gm-Message-State: AFuF++kOtcmnGMMI96YBTkFSiekTE3rrnWVhpQ5rTCoeMOCAil9PY99l
	gezhUK2/FgbYLZldqYUa9YjUYRwKD8RlO4Om4+Cae2mcl5bE90PLNag8X7Fwaspjg4La9pGTyg+
	6WEC/RY2yQ53/CgByfmF8DeyJBYj2zDU=
X-Received: by 2002:a17:907:728d:b0:c2d:ce02:8def with SMTP id
 a640c23a62f3a-c2e23ca13d9mr145278066b.12.1790781456676; Wed, 30 Sep 2026
 08:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930032822.1835287-1-pc@manguebit.org>
In-Reply-To: <20260930032822.1835287-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 1 Oct 2026 00:17:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-zUMWSM_usuKdz6HBLGz-YLcqb2+i=iWRn9fGJ30esgw@mail.gmail.com>
X-Gm-Features: AclHuK-5owUL19DJWQsYyUypw1TibuEWOeUWM1HnLtPC1wOaWAiXfKIBbY01L2o
Message-ID: <CAKYAXd-zUMWSM_usuKdz6HBLGz-YLcqb2+i=iWRn9fGJ30esgw@mail.gmail.com>
Subject: Re: [PATCH v3 00/15] netfs, cifs: data corruption fixes
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 12:28=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
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
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Changes since v2:
> * Patch 12: zero the stale folio against the client's local i_size
>   instead of the server-queried EOF, so an extending, leaseless
>   preallocate can't skip zeroing past the client's real EOF.
>
> Changes since v1:
> * Patch 1: split the helper into netfs_clear_stale_pre_isize()
>   (unexported) and netfs_clear_stale_post_isize() (exported for CIFS).
> * Patch 2: capture old_size before the resize RPC and call
>   netfs_clear_stale_post_isize() after i_size is updated, closing a
>   stat() race.
> * Patch 9: restore unmap_mapping_pages() before the flush/invalidate so
>   a concurrent mmap store can't redirty the destination folio.
> * Patch 10: refuse -EOPNOTSUPP when the queried server EOF still falls
>   short, and re-check a fresh i_size before the final SMB2_set_eof().
> * Patch 12: thread old_eof into smb3_simple_fallocate_range() so it
>   doesn't misjudge a range as past EOF from a stale i_size.
> * Picked up Reviewed-by from Namjae Jeon on patches 3-8, 11 and 13-14.
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
I've reviewed the v3 changes, including updated patches 1, 2, 9, 10, 12 and=
 15.
The whole series looks good to me.

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
