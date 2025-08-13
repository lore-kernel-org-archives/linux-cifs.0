Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA5C2C1592;
	Wed, 13 Aug 2025 06:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755065880; cv=none; b=Nw/EvLyVFavLULpgaE3VoWCDwJHY6bGS82cUCbcBZFFjDwepSSIJn7t+X/R2S3t+y2K4z/LJGztJoUnM/OnO5N/d7wKziFnUdEOM7B6NUj33el+UQU8z6Cw4ymo4BtI9m82COzrrzTLlK14sdIGqhtdcd9HUYUyowGlmpvdZRiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755065880; c=relaxed/simple;
	bh=54AJhgpcSudV+hNAJGayVXcvyuvhyHVqjEdcQPHzdpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mg+h0DMHQKzAb6FhScYI27boTmghSKuw+gHiI1pCU6UutFsmiA6l0/XGmtK0ZuYM+PO6E4HIaSsfZJbWdQirLVD2egjsBeSA2Oxsf0/lcex/0BtkugVKfWzx+NVx0xwa5RxhD7mZTkyhLIuNk5N5gW/KXp0zhuKT33ePLcdFIzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ArM9DLB3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ArM9DLB3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=TRStFU0iG8B6s9qs4xh8W9VpCXMpgzKi6Yokp8SG6go=; b=ArM9DLB3p21I7BnUdHUg0OEQFG
	g2WV7snw7UkP9elqIXS1/WhOIZqJmDFaVXi75cV6TPWQUaShQWKrbPNUtIaPG9ylYmXhO5jFEtdAo
	ze2ksXfOr6RIa1N7I6kcJ5IER35MftQBd8v78+3E9mJkBnnOjsf3WCQj1Ao7p1WvfAQ9Pj09IWuEh
	33AgAFz2LrHVvUtKSvxRUZ0VQ9GS+dRQXq/rFWFw84gQUiHL7aI7FxczmfXgaU2tAIEe0/39OMqxW
	sMeeS1FyevfgDyTD1WPWAEkmCdc3ePHbrvJgENgBGlunYBasW2mEKgHf9FfOtAWVinW+pWSA0Ryzq
	KXbOS0EF9xXP9j9Eo09ObW1+haZC0Ln4kVarUCwbqkIl/fsHvS0GatGYBtQQjG65zGiE4TFHQwZ/K
	kIZdieX+1HbVtLFtaBBx+PJR7MGiyKVat3wmoTcqL/OD6ap6bi4DgoiWHkGypxOBy3pBljx3rL9N7
	H1kJG3ExLY6k3Cw3ni6/oyEP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1um4o6-002YpX-27;
	Wed, 13 Aug 2025 06:17:54 +0000
Message-ID: <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
Date: Wed, 13 Aug 2025 08:17:53 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 563/627] smb: client: let send_done() cleanup before
 calling smbd_disconnect_rdma_connection()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <stfrench@microsoft.com>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250812173453.306156678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stefan Metzmacher <metze@samba.org>
> 
> [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]

This needs this patch
https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
as follow up fix that is not yet upstream.

The same applies to all other branches (6.15, 6.12, 6.6, ...)

metze

