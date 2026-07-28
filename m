Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DC226C385
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202069; cv=none; b=UL+H0tNuxJGMh5MO8i0rDUTPwtsZFiL0N/BjaiwA8lG4wUl6fPNzhtO3vTtmkJlkUATXo4owdjxSvTRDXxAv9QhDs1+tBTo93k9AI8RG4R7GQK4OHExRlze1VMi7taFek9pnNqqGudnrWR+13M064fApFb0WIANRiyUFJiZA+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202069; c=relaxed/simple;
	bh=VQIYdZiXBkeVR8c3WGrsYUqs+wG6vIZInqEICxeHwD8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=QRjmrzKOh9WKnjIwTRJ+50nURyvQGzLlNSLhHKr5cZfgSXhnBcLXfk0Svqf2yMc9AiUWulGAQdI25HZjGq8GvL+hDrFTaLqYumOocLzozVQV1qItClINtgOz5Rvqm/o6IM066SRpER9K3M4WkuZhNh2TQwTyzMwh2ixjyFjxf7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=pft38E5Y; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="pft38E5Y"
Message-ID: <2fafb7c0-1a77-4eba-921e-e5134479fdcd@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785202063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ckTlBeS7HmS02ssWLKX7LOBJ97bRyeGxbAL4H1GiPVU=;
	b=pft38E5YLZEPwTf+3x6GQT1/0WD1sSetvpZxOjJCaz0kxUM8tZbplEDkZ1J0nmexMACygS
	rxtPyGpnCJlEvdGUTJCDDfl3T2EfvCvfHJma9vpGWxlh36jkRogtMsiAH64//htOpR4Xnr
	tMvbXDIU4FpmipjiR/DaRftds0bChf+zlAPk+0XMk1BrnwWkwv79ww4bNZcmLDtFizC3CG
	wAOFDxuoeW0VgChc9EyxwTNpxNzPsjx/q89IsGmwehycWn10s/tTwmgenkeB3kXYSehkrd
	s3/ngoihzNaKCV+q8TMdxiA98uxE0y6ZpLWAoYIf96FkuLD607tAOrww7JI/iQ==
Date: Tue, 28 Jul 2026 09:26:49 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Steve French <smfrench@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>
Cc: Ralph Boehme <slow@samba.org>, tanze <tanze@kylinos.cn>,
 Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
 Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
 <6c4b4154-6d3e-49ae-bdb2-483f0a3a2b4a@chenxiaosong.com>
 <CAH2r5mtL7wjbSZ8A2Eo323oUuGTkJti0B--gZti-92Pw0Oz_bg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAH2r5mtL7wjbSZ8A2Eo323oUuGTkJti0B--gZti-92Pw0Oz_bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Adding support for more fallocate options would be very useful.

On 7/28/26 08:58, Steve French wrote:
> Adding support for immutable could make sense but would likely need to 
> be an optional feature since some OS don't have filesystems that support 
> immutable. Should we make set and get immutable an fsctl or new info 
> level? Are there other attribute flags missing?
> 
> How about adding more support for fallocate options?
> 
> Thanks,
> 
> Steve
> 
> On Mon, Jul 27, 2026, 7:50 PM ChenXiaoSong 
> <chenxiaosong@chenxiaosong.com <mailto:chenxiaosong@chenxiaosong.com>> 
> wrote:
> 
>     Our company has some urgent matters to deal with this week. We will
>     review the protocol changes proposed by Ralph as soon as possible.
> 
>     By the way, do we need to extend the protocol to support `chattr +i
>     testfile`?
> 
>     On 7/28/26 08:35, Steve French wrote:
>      > What other protocol improvements should go into the new version
>     of the protocol?
> 
>     -- 
>     ChenXiaoSong <chenxiaosong@chenxiaosong.com
>     <mailto:chenxiaosong@chenxiaosong.com>>
>     Chinese Homepage: https://chenxiaosong.com <https://chenxiaosong.com>
>     English Homepage: https://chenxiaosong.com/en <https://
>     chenxiaosong.com/en>
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

