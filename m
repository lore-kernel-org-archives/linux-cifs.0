Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B72537E7;
	Mon, 29 Jan 2024 08:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706516376; cv=none; b=VWis4kk/Dbo2QbArjpxNfUqzCQMcNPk0f+f1kxtwqeZ56W7+qEqu6HWh1aJlEFKK96M786VoEy3IPsrzMmquZg94FIlwDoUM1TCVpbBMMZFkYegM7OxSH3gSG9vgwSlXEBtwl6hvhtvuZRC400cuP1BEuflBF8Fh6FzuOSRHfrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706516376; c=relaxed/simple;
	bh=JVQ8C19NhA4E5YeKHFAnWi4eMOlJPZhQ5BYVrlIRvfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MggLGn2endfHTedwgw0efT7Ea8zp9/PFmpW9/1BcJXed6xG9T1fhDLg2AEhTiTjiKfYbKV5FYE2MWirMYfb5ugX2SC+Vo1WxriCZSQ2D8ibLUTh+trurGAm2ms9WHVNP/6nHyO3uRYdyb1o6Jkb9+WtJfKG/6eEcV4EnMYFwaFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: by air.basealt.ru (Postfix, from userid 490)
	id A814D2F2023C; Mon, 29 Jan 2024 08:19:23 +0000 (UTC)
X-Spam-Level: 
Received: from [10.88.144.178] (obninsk.basealt.ru [217.15.195.17])
	by air.basealt.ru (Postfix) with ESMTPSA id CFD762F2023B;
	Mon, 29 Jan 2024 08:19:19 +0000 (UTC)
Message-ID: <06bddf4e-a15f-bf1b-b9e5-d173cdacf4d0@basealt.ru>
Date: Mon, 29 Jan 2024 11:19:19 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10.y] cifs: fix off-by-one in SMB2_query_info_init()
Content-Language: en-US
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 stable@vger.kernel.org
Cc: abuehaze@amazon.com, smfrench@gmail.com, greg@kroah.com,
 linux-cifs@vger.kernel.org, keescook@chromium.org, darren.kenny@oracle.com,
 pc@manguebit.com, nspmangalore@gmail.com, vegard.nossum@oracle.com
References: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
From: kovalev@altlinux.org
In-Reply-To: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

29.01.2024 08:43, Harshit Mogalapalli wrote:
> This patch is only for v5.10.y stable kernel.
> I have tested the patched kernel, after mounting it doesn't become
> unavailable.
>
> Context:
> [1] https://lore.kernel.org/all/CAH2r5mv2ipr4KJfMDXwHgq9L+kGdnRd1C2svcM=PCoDjA7uALA@mail.gmail.com/#t
>
> Note to Greg: This is alternative way to fix by not taking commit
> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
> flex-arrays").
> before applying this patch a patch in the queue needs to be removed: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch
Maybe I don't understand something, but isn't there a goal when fixing 
bugs to keep the code of stable branches with upstream code as much as 
possible? Otherwise, the following fixes will not be compatible..

-- 
Regards,
Vasiliy Kovalev

