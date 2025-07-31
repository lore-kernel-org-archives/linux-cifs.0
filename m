Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7395376
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 19:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991964; cv=none; b=BRmoYqwjGLQdnwJUkr/JVeQyY28nT4GAf/2G65u7+FPwRWwLEowafaIkaFxesR7FOTa1R8Deeyx5o4mlVPDd6qrlTAB8Oew37UOrJ8HpUmKPk9G0pVE0POC/L2ZhIVxoHdWpQ6YRidUHDRsyHcPhwZgqSx8JDzChxSM5mD+cgj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991964; c=relaxed/simple;
	bh=qP+pMjasBFTYBxKl1BWRMsw6X+3kyo5r7EbyqpV3dqw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ATKXtnrvg7dMGacDDSV/imaP7fAgRkZNvuNmESieKQ4uyFJE6ECKeK2j5kEdO178kvUieoIF7B/NztXr3FSd4AK5ckUQrn/gsE8pXoMdWy4EFAnRRlS9+LU1yqmwvxdXugnGWX1tT36off29oxIZGkjUS8LElkzfZi49Pt9zNV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9b5iZYeq; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9b5iZYeq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vxzzoa3ou8PQuxT/bijiuLafOcebQQN/KnF7p7OJSVo=; b=9b5iZYeqgRGrpM33Nicfz1eHsL
	gYp0tQMpW8toptNqlkyRcqJj1VjiYfq7zCe3hqEdAuA9c89yF+gUAjVLBnlfhvwQR06gl/dFpCtwg
	bCrFpDDh9urW+h5hF2kkxX6VvheH9URpVKXUhuIPQxsmYwv9bxyMiCa3VccuAtDgyPoy9cjoQ3Zsm
	ulq8nqRIjTIKNM5jWavGshjukxhPQDIZ3e8sL15vloYGGTlZY4yUXfe1s2XFj03Pj/yh86XCXSycO
	nKE3USbE3BHaM1B79C4wkIm4TlgrBVilZY0o9A9gpIY2OLruBflLGqMtojts2l/HyvVRuZ3peDx3L
	/T6wq3VA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhZQu-00000000A04-3GMm;
	Thu, 31 Jul 2025 16:59:20 -0300
Message-ID: <de55ac7121fa750e21c4d7689953f067@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>
Cc: Matthew Richardson <m.richardson@ed.ac.uk>, Ralph Boehme
 <slow@samba.org>, Samba Listing <samba@lists.samba.org>, CIFS
 <linux-cifs@vger.kernel.org>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
Date: Thu, 31 Jul 2025 16:59:12 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

>> FILE_SUPPORTS_REPARSE_POINTS, which breaks against samba because it
> isn't set.  IOW, we should skip this check for SMB3.1.1 POSIX mounts.
>
> We did add this patch to 6.16 in mainline
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/smb/client?id=8767cb3fbd514c4cf85b4f516ca30388e846f540

This patch doesn't fix the problem with creating symlinks reported by
Matthew.

Note that I've run the tests with v6.16 kernel.

I'll send a follow-up patch soon that fixes both socket and symlink
issues.
