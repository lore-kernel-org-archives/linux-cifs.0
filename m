Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00022F24
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753992028; cv=none; b=Q8BwN6QYZ6BhC26tEgrGWAouiBbGV1df/3ap54lXBwLN0iDyESCb3Pxbfk342uNS2WJEtGgo+NZtJwP7RviirrCHms8QlCfgjtVaWVAlwkbZl/FNkmEx/a6D25CIXz48Xszs8gXu+XQMSIs+lRDf+/uRC23odwse8nAeWisjEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753992028; c=relaxed/simple;
	bh=ZH6SLu+kZO91P78pQoSl+GaV4FMNYsUSBSqu1/q/G2c=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=oJJye6TKz3moMZYejqCvVSkg12KakgUiNvR67JPoOrL6paNuwJ4o0FOO5Cx5CfoDwToe6KMWcjiIerVsMkvMBoPYk+RlCc9Tkis2GInj1A8hzUeoRb7KeNHVsZApmVnXo8NhkvQY9rEZnWv1lINWNwezjUW0WRVWRwDUDxaMA6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3u2DrkDn; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3u2DrkDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uL4tCP4sEG9IAfSthbX/P3vGpVFg1EmQwOOb4WciATw=; b=3u2DrkDnfZQRAL36HFfOafkrDf
	tVkZqC2hDkHjcSqPL0cjOOihULpErAjs5Dvu/Tbjl9QmS33qXZnqGCDSBItje+0r9pr93BBnMvRZp
	+j3gWI7Qcvlk8L/3HjOmkc4NQm+xG4sdY1U1ABB0A0CSTFRqg5m+yUeHwfL1rXKwg6i4SfkmwxbHQ
	WU+5r+tMOxBzjkL19xaWmX5bJBFU8WgJRu4wg7/5eVXKeDAbGDzC4uXTpZtuTfsdkUNTwfHHPfapn
	pc4gHlKhUJEs2/9nucWJOSPa9BJvjjZUO0ZOFky2shFu2uOs/RGOKp9Qx7bivQxV5WS9UUoY6Aszx
	Di8id/6Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhZRx-00000000A0a-04gQ;
	Thu, 31 Jul 2025 17:00:25 -0300
Message-ID: <1ee7cccb5fc35163cd8d0ed7777b37c0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Matthew Richardson <m.richardson@ed.ac.uk>, Steve French
 <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Samba Listing <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
 <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
Date: Thu, 31 Jul 2025 17:00:17 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Matthew Richardson <m.richardson@ed.ac.uk> writes:

> I've just tried the 6.16 kernel from mainline (Linux vm-b 
> 6.16.0-061600-generic #202507272138 SMP PREEMPT_DYNAMIC Sun Jul 27 
> 22:00:36 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux) and while mkfifo works 
> again, ln -s is still giving 'operation not supported'.

Yes - mainline is still broken.  I'll send a fix soon to ML.
