Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CEA15E5D4
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753985758; cv=none; b=TfQ36qQsQ4r4icCiIic/5atQMEFSQR9e56/nFXXHHmVLMy5147/b4HWN84WPfc1dkKHtvXlPZQS46+T2SX33qjrzlNKxcUOS+vzCUlPSjkVWKZLdVM2gnBdNWMj6Udy4GwRUQV+VDWRTnJ+EDoDKMX2HNAlq1rSkKZnQkUW5bbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753985758; c=relaxed/simple;
	bh=JXxtEdlNlXPJnJXNO1yKvixtGXSSSWt8anCsP1m7a1U=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=cJxvP660Xj2IdYPK4OX3euuul/RgrqTAlvLIrtUZ3rcj3knTsCRdsXakWAm5G2rktGZLKduNxEOzpbW7IpKrIWkXX8wVklB9Ko+MyYWaGbKy5yrKjGcGkUae+16J+cNNcvlpKCsfKKSqN/IqvlJkjz+y2CYSnDOs9b8spvlNlsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1nQoBWOC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1nQoBWOC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0zL0Afw/kGtO72CPF27lZi/Rx0HprRcFWXiQK3qlyeQ=; b=1nQoBWOCrE6q8qqJ+75wUdUm/i
	J4zWSmn9eAqZc+9HECq/DGvCkGbgZNslA4v1mkbzfaVnHihRhQJl/2wj3xl4rBUN5/qfc7OxHFS2y
	yww7MpRkd5tAhkYTPQkAj1CGgwBZ0aPRrQoPm06KPAk4coflu+gJiomP3uynUG09Nwl5w8Rzk6Ej0
	FY1/JHrXij6iI2sbY1rwOat8GQq0bGf0i85Vlt8L4j0Dbhcm0fMMNOr9Cz9dhjQodO4hbwhKYLZt5
	NjMU4nJmChqkd+bNud6K0lDOeCYkEBuYphW4vPzeFx/z/aTa5VmMdZ2Z6jaAmfNjC8CWASHPuE5uR
	VlbMf+Dg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhXoo-000000009kH-05ZC;
	Thu, 31 Jul 2025 15:15:54 -0300
Message-ID: <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Matthew Richardson <m.richardson@ed.ac.uk>, Ralph Boehme <slow@samba.org>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>, Steve French
 <smfrench@gmail.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
Date: Thu, 31 Jul 2025 15:15:45 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Matthew Richardson <m.richardson@ed.ac.uk> writes:

> Thanks for spotting this. I can confirm that I see different behaviour 
> with different kernels:
>
> 6.13.0 - mkfifo and ln-s work as expected.
> 6.14.0 - mkfifo works, ln-s gives 'operation not supported'.
>  >=6.15.7 - both give 'operation not supported'.
>
> Which implies possibly more than one regression?

Yes.  It used to work on older kernels because the client used to create
special files with NFS reparse points by default, which is required for
SMB3.1.1 POSIX mounts.  6c06be908ca1 ("cifs: Check if server supports
reparse points before using them") then added a check for
FILE_SUPPORTS_REPARSE_POINTS, which breaks against samba because it
isn't set.  IOW, we should skip this check for SMB3.1.1 POSIX mounts.
