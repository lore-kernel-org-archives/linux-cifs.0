Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A61FBC9C
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739401111; cv=none; b=JBlPaOulmPGMhCS7sGDzP5MHSBWCM6Jbu79QPakOVPANnRDlE8i65Gep/2odPJ8Jnw7fBiapvs3h3x51xOA/+EbV9x4GDBXVggXgI+I6N7bMQud1t/X6ZDCV+3c9CSo54qD8yZehfPoOZUzMQaa/brF2tP0AFWrCRNBzwKMeWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739401111; c=relaxed/simple;
	bh=eZnkkAONNsxSeq0dt3KsFQvz+tNM59a7nSTZxrPa/dA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=cSttEzG7tXMy8EzLymATCBwS+43fB/Ggt+FYk1Sk+zaFl8I+NGWol8hLQ3oBSzytIA9AWwk/zB+cGGjNKftA6heFnBa5tpjgqn6Xm8zxCgqxWYJY3j39WsUzxoCYtGkfz1kBhpP/u/Sxg/2pQSRXm+xIZ2dPwM7jNC7beOtsVas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Xvu48/sn; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Xvu48/sn"
Message-ID: <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739401107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eDGDsTslF7z+04wsfVk3sXsZ7TcHdxhzLB0GNpz5skc=;
	b=Xvu48/snXWetl8NthQ8zENINUHkRFFcDdpSLcUlbu4U4ISH6ijBx2QDkB9wG/eh1IJOdl4
	3UoNoT58x+dl9JDdUu79Pl1Rwo+K/mxkuaRifBKjyeGjmBuQllio0lu01edhFnk9CHU0jr
	et/p+2H9M+jZK+RmV4Fen7fFQX/59KWLkIFg1RVakJQpjcabq0v26CfWMj31fAVjArclfF
	FCnfbebpE89n6MINTQ4zdi0VPw5z0yZNy53EqmJ8gPIfkE97hP+54/2CzSOCb1wnKfQNtd
	e1yfCroBbdvBamemAfiRfAuNX9FigBR61Wns6uS5NmL3cf7nyWmVV1JbpW7W/g==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
In-Reply-To: <20250212224330.g7wmpd225fripkit@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali>
Date: Wed, 12 Feb 2025 19:58:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
>> Pali Roh=C3=A1r <pali@kernel.org> writes:
>>=20
>> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
>> >> Steve,
>> >>=20
>> >> The commit 438e2116d7bd ("cifs: Change translation of
>> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because=
 it
>> >> expects -EIO to be returned from getxattr(2) when the client can't re=
ad
>> >> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
>> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that'=
s a
>> >> different problem, though.
>> >>=20
>> >> Reproduced against samba-4.22 server.
>> >
>> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
>> > translate -EPERM to -EIO. This will ensure that getcifsacl will work as
>> > before as it would still see -EIO error.
>>=20
>> Sounds good.
>>=20
>> > But as discussed before, we need to distinguish between
>> > privilege/permission error and other generic errors (access/io).
>> > So I think that we need 438e2116d7bd commit.
>>=20
>> OK.
>>=20
>> > Based on linux-fsdevel discussion it is a good idea to distinguish
>> > between errors by mapping status codes to appropriate posix errno, and
>> > then updating linux syscall manpages.
>>=20
>> Either way, we shouldn't be leaking -EIO or -EPERM to userland from
>> getxattr(2).  By looking at the man pages, -ENODATA seems to be the
>> appropriate error to return instead.
>
> It looks like there are missing error codes for getxattr. Because any
> path based syscall can return -EACCES if trying to open path to which
> calling process does not have access.
>
> And EACCES is not mentioned nor documented in getxattr(2). Same applies
> for listxattr(2). Now I have tried listxattr() and it really returns
> EACCES for /root/file called by nobody.

Both man pages have this:

        > In addition, the errors documented in stat(2) can also occur.

and stat(2) actually documents EACCES.

> -EIO is generic I/O error. And I think that this error code could be
> returned by any I/O syscall when unknown I/O error occurs.

Makes sense.

> Returning -ENODATA for generic or unknown I/O error is a bad idea
> because ENODATA (=3D ENOATTR) has already specific meaning when attribute
> does not exists at all (or process does not have access to it).

You are right.

> For me it makes sense to return -EIO and -EPERM by those syscalls. But
> for getxattr() we cannot do it due that backward compatibility needed by
> getcifsacl application.

-EACCES seems the correct one.  But yeah, we can't do it due to
 getcifsacl(1) relying on -EIO.
