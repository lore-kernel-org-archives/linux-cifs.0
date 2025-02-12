Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A97190470
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739398747; cv=none; b=KagnvBaUXt2Y1M0Ffig+lyl8pK7aJUaMXtegQ2bNIs8uW4SS8888O1Ey63RY0Z1yfNQ4dmeQLaKUuWA90lVv9bB9YX3moXzaPlNx1vDTXQ0Hm7TMtlxEM0xyzMHT1PNn2kGay8qHAvgGKe62dv2bWsDyg16pDiSnEn258tRqj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739398747; c=relaxed/simple;
	bh=5LFQN6drl14403WP9G2BlF+iu+fN0ELTrPud31b0JOg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WSvKpO1d+F58+K4sFu4v9JBIuKTyF7WStjk5yKXQTcI032lwaRMIndbYwguQRlRKtMe/zjAdvuAbVToj0+m783JxbYwgE9OX51hgtOlqjYg+2UckUdOOjpATFKy9DZsph2wYgfFSluHliIcINzxZLGi1SND62bbPMpPMuQXF9h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=DlHUVfqw; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DlHUVfqw"
Message-ID: <92b554876923f730500a4dc734ef8e77@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739398744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mLbXTbCIYeQMD+8WdGarmOHOtYEwmHjiqyapfnwp6yg=;
	b=DlHUVfqwGGl0VpG0yXr5GFnNzDBoAp79Bm318Q6BM8s5RHLeyzb+TszG6AsyPrmr7oL5a/
	ZpXDU0/41ZUFkj21VvKXnACo+yxvbnGchMsEyXt8gVy8IM5keiIsydVcsLMdLiror9X1UP
	44BGZGxL/t/LCXwC1kbzbs20COXZiO6JJoPtO0vnnnI7W/45t+XDrIh6d6ot6NKdxMWqRY
	C4xuV3SquvFZ0tieWK+pmF0q5bextIxDjirdF117gsMEj/aWzUIzBOrXcIuT206Z9D0aOe
	nRKvCf7+SaaPI8HrIxelsUnA/oGfFGexG6tRwRg4mYIvAP9WTQHTnMjHclxJkA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
In-Reply-To: <20250212220743.a22f3mizkdcf53vv@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
Date: Wed, 12 Feb 2025 19:19:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
>> Steve,
>>=20
>> The commit 438e2116d7bd ("cifs: Change translation of
>> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
>> expects -EIO to be returned from getxattr(2) when the client can't read
>> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
>> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
>> different problem, though.
>>=20
>> Reproduced against samba-4.22 server.
>
> That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> translate -EPERM to -EIO. This will ensure that getcifsacl will work as
> before as it would still see -EIO error.

Sounds good.

> But as discussed before, we need to distinguish between
> privilege/permission error and other generic errors (access/io).
> So I think that we need 438e2116d7bd commit.

OK.

> Based on linux-fsdevel discussion it is a good idea to distinguish
> between errors by mapping status codes to appropriate posix errno, and
> then updating linux syscall manpages.

Either way, we shouldn't be leaking -EIO or -EPERM to userland from
getxattr(2).  By looking at the man pages, -ENODATA seems to be the
appropriate error to return instead.
