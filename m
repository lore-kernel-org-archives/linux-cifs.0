Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9721250BF2;
	Fri, 28 Aug 2026 01:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787879934; cv=none; b=Bd13HUU0Rd8ps4G2FVBqxfnrkARbpDZSxdnCLs3yJ6sPSXVvRyjqLGqa7rumNrLobfyVyTQdBmJsMOXoKRRMTO3M4ruAqnqDHG6iagtsH2/8v+15GfC3RPb6ZIBbvy/Dc4MikoztccluA+HiuCO9oVzXShw9JUzePxR6i8JT1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787879934; c=relaxed/simple;
	bh=Qe4mCoHxygk4njy6Ur1jGezMg1XgEb9Q2Nv1clomcMY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=opJ+faH3TgfuRQq32WlxvVKXsb3fz8MvQX7Qu5POqFQohH6OPwZoNBEc6tFp7qm83yivYxWfn714Gd1dpF9Qfm3D5YgptzgG5VUMbnUJCPuNkLccU9LsdAU4reynJNH4j0FGrgCQIG/c5UAyflNbxVTdSW/x/a+fF04QNZMWOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=6LkjVqiV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="6LkjVqiV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5jarugf1sC0sAToCWV6Ei9ZozdfdRPpJJVCVS6c84g0=; b=6LkjVqiVdg2IDGvNydFthWY8zv
	iqq5mMkoWz1AE0V9lq4E43dWUPSUzQESCVRN1sxMv2MLdQbav3/omCv1m1nVrPPqx+4VSczG70+NM
	pnuxEF/zoXmezRSvmsM4WPrRGG+KUw4O92xW8FBr9DM77TJZa+KzjDlLiHQDpqTQnrYPBxJg5d9A5
	6RhOGzB3MKcAYpiW7dzqPEyXN3zhF0Omr9+S5cWGeNve/k5P11RVKn7u+9prY8rP0CqG+8L90Ks9+
	x6NsxSIw0EEdCUsXNw+H054ReqqpaSCzNy1j2yc34qNAEudiBAG2HEAzsYaAvgVcl9bhOUhSGqqcU
	Xd27PSaA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzlF3-000000008xO-0IMS;
	Thu, 27 Aug 2026 22:18:49 -0300
Message-ID: <4d1df965d61b1c091d4c0e90dff0e8e0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] smb: client: fix heap overflow in cifs_do_set_acl()
In-Reply-To: <20260827021336.82730-1-sorenson@redhat.com>
References: <4475a3bab754e633b20f78a6827cbc75@manguebit.org>
 <20260827021336.82730-1-sorenson@redhat.com>
Date: Thu, 27 Aug 2026 22:18:48 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> cifs_set_acl() validates ACL size using posix_acl_xattr_size():
>
>         4 + (count * 8)  // 4-byte header + 8 bytes per ACE
>
> cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
> wire format into the same buffer:
>
>         6 + (count * 10)  // 6-byte header + 10 bytes per ACE
>
> An ACL that passes the xattr-based check in cifs_set_acl() can
> overflow the heap when posix_acl_to_cifs() writes the larger CIFS
> format.
>
> Validate the CIFS format size against the remaining buffer space and
> USHRT_MAX before converting--data_count is __u16, so sizes above
> USHRT_MAX truncate the on-wire packet length, causing the server to
> apply a partial ACL.  Replace MaxDataCount = 1000 with
> min(CIFSMaxBufSize, USHRT_MAX).
> ...

Applied.
