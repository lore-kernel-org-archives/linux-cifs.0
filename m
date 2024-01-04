Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04AE2D036
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jan 2024 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Z/VCUQZL"
Message-ID: <095d8821cbafdf3f13872f7e9d7125a0@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704409793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1dEX5Xf2/v0xpFvSo5AcJIu5ZeDSuP2Uu0JMbDOV4w=;
	b=Z/VCUQZLqs6anqK3V+4MFuVnM3WE9PT3TeR1f5RKNTYJ+gabUOwfWr0mL9hAiTvfxo7wQK
	9Y8Otji95NoqmkAe4fH5DgeBH9VvDforpiZgtGwBzSQ++0jGpD6Vb6RDMZdEfE6gkXzJe1
	kb5lpbfYUs6/LvJZABYaZp5a9689F3PKy6n2qbBcs06svjzP5sLcuUBJOgUBI4RnBmlN48
	1NQ0dJV3Tmkb1edJXK71RBmbZ0lIlL1HiIh+H9j8yjSc2nsD//7xj4Eh4HhArK+IDy+Ugh
	MrPfUYra7DZ5N+iJUcmwE3/B8hC8Ecw1lGGIH1GaPLPVtiY/Y4V0Ruad7xgadw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1704409793; a=rsa-sha256;
	cv=none;
	b=luf/u9oifg2PIYLJeuERZv4zZ4A2+vE2jUwdfQRdyQAJ9W62S32sPKj/FvA3enJGeUZYDd
	zk0uw0+z/WVDZ9BIQPb8WES1YKkEgJSSiaTXWeFii8h+dxOmLOXt/XtTHEZeYlvrd3GORo
	XXEcFPHKJE6j9n8zIzDXoiPROW+YFN++pxorUfLkmd0x0q0MxNYAxiXIUOrJV+LNGzCJep
	hLjv/YML7o1xAGekQeLWyMHGa/3103+eqyHWYciXaI/ZXGptcXzDA5spaLAV4HJtyAxsGa
	GsCDenAnhmY+O1JK7zHDl5PMKeq6YkYN6Xt2wnwJKKQgyrPvDVG4WBn9dPOE6g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704409793; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1dEX5Xf2/v0xpFvSo5AcJIu5ZeDSuP2Uu0JMbDOV4w=;
	b=U3UJN9GL+S4II9ALXiOVwiDn8zN6Ng9GyUgUVUAyM9oNMy0BAWsyQH8UFvmU8jGSuHICDc
	T09Dlfj2JtFzkc7nFNL7lBRbrUzfN6hplaGejDTWb2rDZRhtwrSGx+PJ+wymEoPV8QSyrc
	JCRedPh+5SraNhh2cBTc3P9pTeG5Exr16grec4veBZgznCSs2J+ymJt6VQsJ4GIHpVrcVn
	sVY993kJm0Z2KeBW4Mk/EqkOCV4TpXsR9MGp2WPGBt12oJouEe1ONbicSlkvrKe/FKfipP
	echPliAqPmFvhvx5wnM+vRKBA2UGNPqFObXWm8UoMaFqS6WnXkJNs3htjXS6HQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Tom Talpey <tom@talpey.com>, Meetakshi Setiya
 <meetakshisetiyaoss@gmail.com>
Cc: sfrench@samba.org, sprasad@microsoft.com, linux-cifs@vger.kernel.org,
 nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 samba-technical@lists.samba.org, Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing
 lease
In-Reply-To: <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com>
 <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com>
 <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
Date: Thu, 04 Jan 2024 20:09:50 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Tom Talpey <tom@talpey.com> writes:

> On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
>> A possible way to handle such case would be keeping a list of
>> pathname:lease_key pairs inside the inode, so in smb2_compound_op() you
>> could look up the lease key by using @dentry.  I'm not sure if there's a
>> better way to handle it as I haven't looked into it further.
>
> A list would also allow for better handling of lease revocation.

It's also worth mentioning that we could also map the dentry directly to
lease key, so no need to store pathnames inside the inode.

> It seems to me this approach basically discards the original lease,
> putting the client's cached data at risk, no? And what happens if
> EINVAL comes back again, or the connection breaks? Is this a
> recoverable situation?

These are really good points and would need to be investigated before
coming up with an implementation.
