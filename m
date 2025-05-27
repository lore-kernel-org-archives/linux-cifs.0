Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9C288500
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748374171; cv=none; b=FCSw2fQcFqyaIGRatOCRFdcqKl+mXn9z/3lP27J7bQvFeUn/1W8gmmVA07tMurRJFW10sq1NIxnHrLbtBsEjcSWcOvB/ns+mTvc4lTPK7Xxd9FMvQMe2SjsE5DibefJkdYCutiGP5+czVH5TYrFXTUgSj/7xDB/tA0ODCw+u1mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748374171; c=relaxed/simple;
	bh=VZDNWCA6mWv+aikUT6pjYJ/AzRdpRDW+QwMv7gBjPSI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=a5gCxxa3gBT7eoe+bUOeyctFk6+fDJUyll/BfOxstzvArFp/XJaN1JkehTJ/0WFVwNxJrPADuwYxspbmZDbpwfmSzyvBAwWGV858WNIbqj9GHuGfHfHtJb/LFej0Jk4tMQ0OqewNCpZ2W8GKTFa4kHhya8WmAAo4Zzh7co3eV1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=B9BtwG5c; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="B9BtwG5c"
Message-ID: <d3e68ea1c2db713c80eef6fba357f765@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1748374167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mzs5guenPfSIPgnP9FoPJirSaR1i3KISTbSN3iWLbKo=;
	b=B9BtwG5cnwmAxbBIwNsOezO2Q8rdOLPuNsj0da9VE+aHwg/zs7jOjP85u7ByDY09JKt6/p
	3PUxbd0W1PymLv3swWs0oZO8+6Jg6EGfPBMtHvZHho0o/ZJ4Zuy9ZCPnK9SrF9VR6ROj/R
	yjsY7YaX7Jj0esabXqjTSHuNtbm4AtabssbcvGkzT/7cporvtZaigJRdHgOte07bQ2BsNJ
	sZwtdltXcCjl6YPvOsnhBLUT+07oIRW6XY6OdVR0x3U5zGNXIgf5JPXQ2DUE0xXai4FRM3
	PBijOPWwoTwE16rsdf0b6Q7gecUC/Eegmdb6S3uqHsKi98PWoQc7zmdq89APcg==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, ematsumiya@suse.de, sprasad@microsoft.com,
 paul@darkrain42.org, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3] smb: client: fix race in smb2_close_cached_fid()
In-Reply-To: <aDYQILpDA0EqzsX7@precision>
References: <20250527184213.101642-1-henrique.carvalho@suse.com>
 <44fb26b3d061287bf1cf8ec458adc8a2@manguebit.com>
 <aDYQILpDA0EqzsX7@precision>
Date: Tue, 27 May 2025 16:29:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> On Tue, May 27, 2025 at 04:06:01PM -0300, Paulo Alcantara wrote:
>> Henrique Carvalho <henrique.carvalho@suse.com> writes:
>> 
>> > find_or_create_cached_dir() could grab a new reference after kref_put()
>> > had seen the refcount drop to zero but before cfid_list_lock is acquired
>> > in smb2_close_cached_fid(), leading to use-after-free.
>> >
>> > Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
>> > held, closing that gap.
>> 
>> Does this mean that SMB2_close() will be called with @cfid_list_lock
>> held?  If so, that's wrong.
>
> What I mean here is "Switch to kref_put_lock() so
> smb2_close_cached_fid() *IS CALLED* with cfid_list_lock held". Poor
> wording on my part.
>
> The lock will be released after cfid is removed from list.

Awesome, thanks for making it clearer.
