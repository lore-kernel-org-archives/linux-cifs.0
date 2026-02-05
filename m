Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A9C279DB3
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318633; cv=none; b=imViJPqmoFFm9boDbMdlNvjbYEp2P8YLOcZtthkDkSveH9RYDWSI9rrIoAEVPhqf6gEJqrt/TjFfrvb4x3vPc3BFIGe8H8OydurzOmfMqL2XcoOGRbWP3wVBRGnTS3mKo8xi4XyFdWz/vCzC8/yhOre2v1B+PAdB/6wuJGUl7FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318633; c=relaxed/simple;
	bh=SHaffgVQ3AfsAhH09BHidOacnI+0PzatJgcx+DGvBUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nBOYdEXjwp66vw+bDwBYzBN53IKVBWhLWZS25GaxS+VGDC4g9xUfqvqG/uvFmi6nCy+G0/BpZ+80QOzXXKBbW6DQDJD2rDwAA9wG+fVD5ZddrI8+YVOe3eG+hRctF64mxW7D+Gfz1/JuHvNMAyOxbaLaHcbqkLvODopGhO+qUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QT6ohywU; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QT6ohywU"
Message-ID: <bfa4a0be-8429-4ea1-8bd6-691c3a47ff00@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770318631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHaffgVQ3AfsAhH09BHidOacnI+0PzatJgcx+DGvBUU=;
	b=QT6ohywUWxVKWBRmDDcVulFl+N/cUIc67XYMirTIHRY3aol296YYq5GDbzXaQIaBBHjuEd
	dV5oZSQh8dLMp517yv3a0UZz3lyL66rYV809HWMeKxYn1UjuW/3yVpnJ0M4GAPjNbwdU2z
	V5oNdQfVVp3Pbxz0BrZ9ILiCT4215r4=
Date: Fri, 6 Feb 2026 03:10:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb: client: fix potential UAF and double free it
 smb2_open_file()
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
References: <20260205161952.245146-1-pc@manguebit.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260205161952.245146-1-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Is there a typo in the subject? Should it be "in ..." instead of "it ..."?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2/6/26 12:19 AM, Paulo Alcantara wrote:
> [PATCH] smb: client: fix potential UAF and double free it smb2_open_file()

