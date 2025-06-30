Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC361A0BE0;
	Mon, 30 Jun 2025 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751312222; cv=none; b=oGt/8dGAwVFCZgv2bWhDqMFVV25md9jK5648OyoPIqBs/spmJ3gMdo0vSGoF/gjKl22y6uPCAjH45g07oDnGJBcSSlgtaKWVCoUdUAh+G5wbMGVioswZ556h797BFJYFvgNfGbflEzzH4kl+JXC+r/WwpWYob5Ob5BJ2Hojp8fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751312222; c=relaxed/simple;
	bh=sHoXAnTSMie/IEIvzduGIz89rK444Jwh7QkYoIjfi9g=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Gs4RbKWbpuFzwix9vX7YqFbvxLkXSyQz7nL32sXUAPyhFLJ8iYklRHNVvPEsZyMY4G6MiLHRz5t+8437Mezv/OtWBDfhvSn4so3u7xm5PhQpDIA0rrX4Rr3SIy1TUUAaoy1hwSTaGGOHUqRp7othfaLnvugZptnAaP+7fZc03LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=npdRan0K; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="npdRan0K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ixrMFcYBBwkefYVGhNQKYmuomfUS2tXjom2XGCiZiG4=; b=npdRan0KYv0oumSwCOzjqfNmoK
	R4RWZaR4mk5mmUQx/xOiz43+OwLz1XSIhi+sMnZ/bkStIITEl+BMx25nEsezG4V/kuS2uy2MV7/04
	ir5sSZ+bLs8QNM6LNf+UdSX0TjVD2Zba2T0fHTJW9rZzYuOrJ6e6BEYIGpW3PgWnHe3uJLy3sx2u0
	gHjhUbLw4d+dr8YE1tZLKtrYupv3wehPP0xGohfXzSdHqxbgH0RRskVqL8KvIkjkA+4MrCPk8jLMo
	dOoqz25viAbdovjMlKKevHJnxFLvGNW4gO8jGQAfzyV4aBdYww2qkGhefSnOifGCiQeAEJthkeekW
	YZteYUXA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uWKJ8-00000000sH6-31fq;
	Mon, 30 Jun 2025 16:36:50 -0300
Message-ID: <87104723045d2e07849384ba8e3b4cc0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: nspmangalore@gmail.com, smfrench@gmail.com, linux-cifs@vger.kernel.org,
 dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH] cifs: all initializations for tcon should happen in
 tcon_info_alloc
In-Reply-To: <20250630174049.887492-1-sprasad@microsoft.com>
References: <20250630174049.887492-1-sprasad@microsoft.com>
Date: Mon, 30 Jun 2025 16:36:50 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today, a few work structs inside tcon are initialized inside
> cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
> is obtained from tcon_info_alloc, but not called as a part of
> cifs_get_tcon, we may trip over.
>
> Cc: <stable@vger.kernel.org>

stable?  Makes no sense.

> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h | 1 +
>  fs/smb/client/connect.c   | 8 +-------
>  fs/smb/client/misc.c      | 6 ++++++
>  3 files changed, 8 insertions(+), 7 deletions(-)

Otherwise, looks good:

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
