Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C33C243387
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 06:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631220; cv=none; b=Ou/b8TCxVOb/wvNN2Y7JdBvuhYbql3dTizgiIyKwT67nGLMBjcy5SfQ5oOMr4p4/1NzBg9BozvMaFAykbOq3JhZfMajMjzIstCpJpEF608BIKP4UlYpn5I8DoS5u5H9CPaC7KSNRv1SkndYCCj4BKZMQ453MpeuiqI8gPBes0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631220; c=relaxed/simple;
	bh=T5ifx0bGxeqyrtnPJNcUibhfQKYZwJM7hgIh3vhwKHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DxUIPLpRbnUciN+yDPw3lTfkUcYCKpJwx5f6skpgSawzLzDWGH5sSk18g7/kpnKm3857MbB0gs1MQBjfl2D3BcC6lqZeqqKLFI7yHQXQXSYMPq/oWNE94oTfQORwxU7RGSoV+Sol6dJQxmdAt/OsknVhyrHjVmX4rCom8LsNn1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=F2zYwAmQ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="F2zYwAmQ"
Message-ID: <0568bec2-b85e-4b5e-8765-8acc3d779c82@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775631214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Co90LOIbkTlrjBcAgJGvDYECpJbGFClNbFMmlhGg1/k=;
	b=F2zYwAmQmdvua3/49eaT99HN6aP5VHjFbOyRHH6q6rhgm8/0HoXf256h2Ij/n6VyNoHxH7
	Nr4ykrFr+6pUjIeUuAJdgWpqGs8UIjs18AJgHj+9igeEa6qnXP+4KM4QgFr0HGir5cXGnq
	YF5N6kwAboJDJCmKWxoBsTb8jEmAZmji+fHeAS8EtDliD1rBeOZjO/miQyvmuQ9qJalx/i
	XxiKYqr/SSq0LdQjqtxwVgB92wJmVZkO6AMi28IgcOWTz0qSDwyqhgg+A7N4x4J7JdhUC4
	gBnhV17XkiolaU5eytaBscWhN/Z44Iw0xON+g0qBYutF2dNEN5bPdzoyI8GMdw==
Date: Wed, 8 Apr 2026 14:52:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
 <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
 <2026040833-espresso-triangle-425d@gregkh>
 <c7c0fcc2-ebdb-4ba0-9c64-fadbd57137fd@chenxiaosong.com>
 <2026040846-winner-juniper-096c@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040846-winner-juniper-096c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Sashiko found it, I just checked and confirmed it.

Could you create another patch? I enjoy the review process more than 
creating patches :)

On 4/8/26 14:40, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2026 at 02:19:48PM +0800, ChenXiaoSong wrote:
>> Could you send v2 with this check added?
> 
> Looks like this was already accepted, and the additional check would be
> just that, an additional check :)
> 
>> I am currently reviewing another patch. Perhaps you could wait until I have
>> finished reviewing it.
> 
> I have no problem waiting, but as you found this one, I want to give you
> proper credit for the find/fix.
> 
> thanks,
> 
> greg k-h

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

