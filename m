Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BB733FE33;
	Sun, 13 Sep 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789324006; cv=none; b=H2FKsIqFnxs9qxTUAJw1PdbS86TeS1GhtKMkJMEUDI1hz7JaLRf+sqvbwdBIxBx4ufqmGGcJ+O1WSqKBMHvh4R8qFtVp02IbwvTAsoQT0T1HT8GZ3yQxLyeW000DNWWb3M04AVE/iMpyhXSt8QwAPm+QTLDKFMoqQ0mKp5frVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789324006; c=relaxed/simple;
	bh=0lHpDg4wiCvQ8dRvDkIVwnY44coK3ufgTX6pVmPqFnU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=R7bSW2MY+rWOPLH+if8Dkk7/Sj0jWMWNS7H0HUcX4ixPE9JtOrILZciTyVSjLRSUGRW3pJf9n1C+UY3NKOlK5o7k8TCzRRRc3DYpoc8rdq+t1/qiiS3/+tpTnWdwb9YYImu9keq8E+iKs5EG2cHcTRzeKUtgZmZ4Ncw1lzjRSxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=XuMefVcw; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="XuMefVcw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KoMuCdx7kZxKDpPrG7xHNwM5JObihGkseKKYn+IDzp8=; b=XuMefVcwzmkCUsPIHch732LHtV
	v4oP4qSFdUvXzz+NyWGvjjBFnBFUBuIYwQsZQyA5ithF6ZSoH0JDfiGsT4JCJ6KgHIdftJitT4z+f
	N6cOSi2RD0yIZfmaU195D5CBL7Rid0FYbuRIZ2nk+9elJXiiFWH7ya/XUNmgTlcJ2Xv1cyL2Hyfpt
	hkyeneI5KjzoSTmVe3gdk/mdgE7Vln1TOlAdwaSmpT31PjfzxUz/uX0HE3EvTzuRLCJNmnZViGlqr
	YYGhENLFFMrxX5Sl1WfCo6oJNvY+N0njyp1GVahJDL00ddJYItqj9Pc64D8H0s5YzkE/iYZwZsNPf
	D7gTMzpw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5ouY-00000001LDB-2DGn;
	Sun, 13 Sep 2026 15:26:42 -0300
Message-ID: <336654e0c5002de5a69333a07d1c03c8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Stefan Metzmacher <metze@samba.org>, Shyam
 Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, Namjae
 Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix smbd_connection leak on
 cifs_get_tcp_session() error
In-Reply-To: <20260912172509.542168-1-pc@manguebit.org>
References: <20260912172509.542168-1-pc@manguebit.org>
Date: Sun, 13 Sep 2026 15:26:42 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> When an RDMA connection is successfully established via
> smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
> kthread_create() returns an error), the error path frees tcp_ses
> without first destroying the smbd_connection.
>
> Fix this by calling smbd_destroy() in the out_err cleanup path before
> kfree(tcp_ses).  smbd_destroy() safely handles the case where
> smbd_conn is NULL, so it can be called unconditionally.
> ...

Applied.
