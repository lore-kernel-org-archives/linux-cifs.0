Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C6280325
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 00:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788136940; cv=none; b=Kdq8le+EPt/QvLUhIEDpC3Lhvo/nqQv6ypfpyuAtYSvwL/KRoKWlB9HGYxIva1XVksgF66Qnb0tpZFH9zpE6+/s0zzaZkNGL0xYwfP41IcjS6ZUjkSgALQEoId1GTey7MCzRU1OXSNE6Kxn1yISQxJeW1jwfIxsLSKPYrcPO/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788136940; c=relaxed/simple;
	bh=3Qw2fs21wkrwzl7ChAiP2vCNWpZweRNdpO1p4tzob7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRC6rFSGmfcolYAwyWLiD7/YmJCvy8c3Xq0TOntDg7ANgOL4IzragSVGdRDMGkY84i7+LIclMwTq1zFCzn1MqXnWL5/zBs6V4jJo5zVnQIDsTCHvGiRw5i6EkPIh3HJ4ZDu5+leaTW+Me3xwEFbl0ZJMxVOBGut9m1k1Wn48N5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3UdL8Ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3UdL8Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907FC1F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 00:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788136939;
	bh=cwLD5MPaM5wEPEiG4IYB203rR0WWLqJ94Gf1v2xping=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n3UdL8Ff7vYSPKFZghKggZzq0vJRXALq9Dd7AhjCvJ24p9VsMoZN6WO98qE2SqwEI
	 cbYsrjB8hEDBqyNkU/raMT/hw5YKlTYaF88j7Rwhr059KJHGVW9FDDJXWhvFAQyJcX
	 1ZJDQt2tfOuwPMwY7wyo+/ni/Ny9htNVxr7/XUS0sVytyIU7uHIiJiR+FVHZNg8t1N
	 D4CUZhHQV12XBlNPaP/z5x/rfPK6ziWTHHxSCYYD4vgB/V8N9PwqNgeObkCn9KNpFk
	 MrInbiRlLnOU814Fpx8gF7v4Rz3KUuvkVncKfunzus1KXaiWwGYygJTDf2cF/ZsqPt
	 kKKxRk/JQZzdw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so4472543a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 17:42:19 -0700 (PDT)
X-Gm-Message-State: AFuF++kQtrIiUSOmJwSjBdtDGrU8yNQIhiJECbcYawaAYYYZOaphhTZi
	/teeWaz0PEJgt0HJl3YLKIaw7kpewMe2Sk1UONgU0B9xrTVLbskkzBX+HxAhrsx8roRO7V3dkmQ
	oJ3fBqO9TjwwK8uo4DhLT7ptp5UQ/9c8=
X-Received: by 2002:a05:6402:5055:b0:6a6:32fa:cac with SMTP id
 4fb4d7f45d1cf-6a632fa0d07mr6252464a12.17.1788136938260; Sun, 30 Aug 2026
 17:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828231211.252093-1-pc@manguebit.org> <CAKYAXd_cR_WAd-3iRW_KJRmSBKxNiSuGvjNXXk33pG3Z_2dBvA@mail.gmail.com>
 <ff527b2379048e28e0b2e66abdeb1aba@manguebit.org>
In-Reply-To: <ff527b2379048e28e0b2e66abdeb1aba@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 31 Aug 2026 09:42:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9V-WCNVzs3gOrQ8cPjAvpLUv65t4tub8jQuOqo9diZJA@mail.gmail.com>
X-Gm-Features: AcwNN1X_X_OiN_At6RLiKHEGZ7PMCZKvvLGQTPCi4abYeLmXEsP_wL_myo1NJ7g
Message-ID: <CAKYAXd9V-WCNVzs3gOrQ8cPjAvpLUv65t4tub8jQuOqo9diZJA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix data corruption with concurrent writes
 and O_TRUNC
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 1:43=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Namjae Jeon <linkinjeon@kernel.org> writes:
>
> > Should we also take filemap_invalidate_lock_shared() in the
> > page_mkwrite path to serialize mmap writes with this truncate path?
>
> I don't think so.  It's serialised by the folio lock that
> netfs_page_mkwrite() and truncate_inode_pages() take.  Also, if a new
> writable page was added between the first unmap and
> truncate_inode_pages(), or if a new page is about to be become writable,
> both paths should go through filemap_fault(), which takes
> invalidate_lock shared, so they will both serialise with invalidate_lock
> exclusive in cifs_do_truncate().
Agreed.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
