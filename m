Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3293AA4F9;
	Thu, 14 May 2026 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778756568; cv=none; b=Ol/4qS/7FPOmYCXEAun2k397y0YkVFDGqNYKaMp/9WnnlGXgc/kj/UGeCcSeJxsmyRZrhN/QOLzewRANXFKx0wsoPchZvUDQsp5EE58NkZGXDrnupew6nKnE8iDXArg+2Taia1GzQa50KP+x5598DdFNau1xjW8/S81upurf4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778756568; c=relaxed/simple;
	bh=zyjl1Ct3b+gw6gBocJmX26R84MHN5JupYoOLs2uWsxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QexR7PfiGbJIhw87NxIf5FeagMUSpbEjErGD4wW4wHmzwOLtbVkiNHIlMVvHwRqDJr4JUAECG/XHlcSQNGQ84Lhaeom4z3Wzfti/622iU9H2ZGF6XPKoCpmDUNhxSjAp7Slv1W4EeMV4wj44TPn3fka8AfpN5PKT76fFnVoSC+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OmzgHsQp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OmzgHsQp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=RsWnrQ/0UnSrtJxr9MFknS8VfTQmv+l46mUKZhXkp9I=; b=OmzgHsQpOGUL7cKZoH128F37Ej
	HCruXaFjefPOa2LWNeI84rV3FZNWuBoJraMMiuuRsB5aUDjei03f8fG8ydHi3zTixAm+k0A5sAAPf
	Q+aMp/ixX8STsKeM+3jb3Llm1dEzVQDR/QxnDkpiCpJSVIkNPZFQOH25abE1N8Stzf0q4BjUD0N1J
	Fas/2VpFssJOUIhYBzA3vZ0GUWarHZrGNKUMzryEV8TedBsNVl/7UObkBXTf+6CeESYbdudEabaL7
	BxSKr17h4w2JXulMUILQ6+Ilenvj2Ji4LmO/hYqWA1koq8MGZXoXefwgopsgBQ1HRDb6zW344RFdH
	Biac2v6rU6rw+impjxkv8KzyYiiQxIrR83V59szUWWf8FjQX6oSV0U1RRaGllsYDjNpswiFae7N8Q
	oISg7JtyPcC0r+wlb9bDPPPlYlpxP7aIm6dYp/aS89SHo+QETpWQAvU9KNOTwq4t3v4CBAetExKun
	RhUDbk9kU/+OgXSokEacRnEg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wNTpu-00000008mM4-3a1I;
	Thu, 14 May 2026 11:02:38 +0000
Message-ID: <7de22a6a-478a-4bb8-a023-d186eea26bf5@samba.org>
Date: Thu, 14 May 2026 13:02:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smbdirect: Fix error cleanup in
 smbdirect_map_sges_from_iter()
To: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1927248.1778698202@warthog.procyon.org.uk>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <1927248.1778698202@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.05.26 um 20:50 schrieb David Howells:
> Fix smbdirect_map_sges_from_iter() to use pre-decrement, not post-decrement
> so that it cleans up the correct slots.
> 
> Fixes: e5fbdde43017 ("cifs: Add a function to build an RDMA SGE list from an iterator")
> Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Stefan Metzmacher <metze@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Tom Talpey <tom@talpey.com>
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org

Reviewed-by: Stefan Metzmacher <metze@samba.org>

Thanks!
metze

> ---
>   fs/smb/smbdirect/connection.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
> index fe9912e53da6..8adf58097534 100644
> --- a/fs/smb/smbdirect/connection.c
> +++ b/fs/smb/smbdirect/connection.c
> @@ -2168,7 +2168,7 @@ static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
>   
>   	if (ret < 0) {
>   		while (state->num_sge > before) {
> -			struct ib_sge *sge = &state->sge[state->num_sge--];
> +			struct ib_sge *sge = &state->sge[--state->num_sge];
>   
>   			ib_dma_unmap_page(state->device,
>   					  sge->addr,
> 

