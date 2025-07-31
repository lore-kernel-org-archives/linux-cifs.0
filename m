Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCAF1990D8
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753991741; cv=none; b=Zlk4KSE1ZIAxeySLGR0f4Q1oRX+MWRMPMhq1DbddPOj9owT+cCdo7fr1u7bD2Tpwb9YvYXf6AzcXX5f4ogQ75TE0geBhgc6pwTYFLN/kkBbDToKl45OP5l6DNawnDyx5ZwpETAwQMlNDehhsxUajg2af3SuGjQVbUt8/I8Q3z+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753991741; c=relaxed/simple;
	bh=rxzeOdbUpE/t7lVD4+QcY5dj/bBeekOt2pydS5tAM6k=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NjmemyBII54wnF1JHOn4++CWhu/VqVABSfEcWEZwrjnzoArC2TMkGxYKRjRQYGPUD7TPOCEWoz2PnFpxm4XceHh68kyAhUqJ8G7F28xliC2l/0tfUsLLu0kt75uQGrpbOneiMHjC+/Cb6Lbx+GO93u12vuSN3bm0GopayiWxRMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=mCa+h58W; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="mCa+h58W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tF5DFGSDUUUnwOh+pGMFjT2b7lfiuG/eDFa+zYSCL5k=; b=mCa+h58WzR4JhThr6OiUYLtEmB
	wxZ2WwQiHinPiS0YbVY5H6qX5uH7SYxfCD1TKTzIq6g26gDwb0cJqHrW7OaFWrtW9xzizRT9vbJgw
	s2R2GenG431A87j/1E1twzfgS/WT8iw5/R3VyW/3HOH6uf5E2KnKM6dntsHspprP5h6UE6QD04hiN
	ZQRVy4tWaiHlbybDZ3DE5UT5JazfiARPFMl3d9RgDKCWx5XMbTKcOSOWHNMo+jGVxZIcc2cdZVHg2
	pXJSU38P7IzNvKL9s+l70J1MRc6S50y7mLPFuzuGnygaMLC/2qC6UcuuhkxRXHHwcXSOSJEIHI7EM
	VIrP+YOw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhZNI-000000009z5-05J3;
	Thu, 31 Jul 2025 16:55:36 -0300
Message-ID: <52d7cf6d7736535383af64827398f345@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>, Steve French
 <smfrench@gmail.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <08cbb023-7824-4319-bdf4-481013cff2a9@samba.org>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <08cbb023-7824-4319-bdf4-481013cff2a9@samba.org>
Date: Thu, 31 Jul 2025 16:55:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> On 7/31/25 7:37 PM, Paulo Alcantara wrote:
>> I see a regression when attempting to create symlinks and sockets.  Note
>> the 'nativesocket' and 'symlink=unix' options, which are definitely
>> wrong for SMB3.1.1 POSIX mounts.  It should have 'symlink=native' and
>> 'nonativesocket'.
>
> ahh, sorry, but I was kind of expecting that. There are just too many 
> options.

+1
