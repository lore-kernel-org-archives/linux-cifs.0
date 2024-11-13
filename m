Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA204C81
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731502329; cv=fail; b=hxHT5B5d/6wB8BaPVLt/V41ermHrDo4SaoVLPaRjX36wbzJsi1GIaxTDvyDPolPLubD/I3hxQXBxqybIEVveapQTR9T90Zmq00EPlqgnQgwyZspu8cxrkvVAyBy2pRMTc9fBrAAloaD5sdS8lhs62VAxjgNpf2GuKOoo88K6Yz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731502329; c=relaxed/simple;
	bh=PIdivZT679L1p26Q/raWKk8Vq7dpDGrvwv6LdHbzFn0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MxvF8UY2fFvCb4KYTmfHP2l1EdZMzjeinEYkZw1Q1TIRUF7yg1XqmAeGl7uuS0n8v3UHPpDpQQClad9h4ewT1X6MBimIxASMdja64s/VW+9E0IwJFPB8g3f4iqOc9e6uKCM90sRFYaE6RjrfUdAZHentalacb6NbHq4QhoXdLlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Ul+FsMSA; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Ul+FsMSA"
Message-ID: <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731502320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pm1w2BiXSqUOzJVgbxru6dzDYWhyfMpv9lzim3rlYjA=;
	b=Ul+FsMSAL01mllUN4mXC4L04ky8vJ1uGsIe52+iCNTPXvzzglmY5VHeDfYHsC4irzbP+y9
	pRZFI5XYVopvNAQPi00wqTbwCUfxPLKAgXfAt7MSvH/Z5Ofb9LYwc5Kg+uprSNN/OzWpBL
	h58TL6e1fioARKMHto39LDlbYxAgZYCPCsKYv5u8C7gl/VsEw1nltUogs2hCt4TNuhm2pw
	OJAjy0s23thfn8FjqA1anpJgMSDYH/j6yWkIpRPJR1sJyVWS25sgONseK/qttoBZliYhIO
	YtNNmrHBEfguJsrbrzZsErI6tAuLdGNdH0KjQmje7AmWFuiu0Egm2xuQ/2G2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731502320; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pm1w2BiXSqUOzJVgbxru6dzDYWhyfMpv9lzim3rlYjA=;
	b=GM/p5905F/gNUTszLnwZTWOJggIThJ4iBnrG1UKnAzwa/zZy+BV/QShOLoO+Ea0wG6YtUY
	B0M0Yj8uLL50/aUcxHCA9f+FS2dXUdlHJX3DaYXEKP7k7SNngFdPd9Yp6+T/NcZCYlxPiX
	CkXWFalSDO6l5FLy2xB9c88BseFKtCNyeL4ZruYv5iS5UEi9ACMrgpk7e8r5sR3cnNCKVH
	7+g0Q4vKCT0zmlu8D/6Y6SwHSLzONQ/R10S8fDHM4Zq3ExY7V3ndwjS0orSrP0VZMq7T1w
	b3JEy1cKo3CyftLLnBD2tmChUeZvbjmYNejl9o+K4LZeZR/YJvDM3sgLgXRBDw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731502320; a=rsa-sha256;
	cv=none;
	b=p8XHRkXyLgHNX3GAVvcH4KTZmK08tAUtwnrW6kEWqXvnhHl9x1m4hjEIt6NkKTvwB+K6D8
	mQphlnV2rIBBshHA7RQASz1Vxek+Ftus3ByeznTQkrL2ElThtGWy6kxlEV2Wug6TvnNeiY
	dKvuljBRaxnlK/DsmJCJY6Ls9QJ5Du29r+uBJspqETcdmEB6JfyQd2ZFL/4ib3pzpnIFll
	jd+TLML5rPLyleclzk+eeeLW3PkJL9e0n98MBbvCZxEEwv73Vo3iNGC0UIs4IgsiXyirrp
	wJi8sjkhtG5EQYisQOsFb6ct3kjKvioiJx5X+uc+oE+i8PU4N/iixda3MWMXvA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Ralph Boehme <slow@samba.org>, Steven French <Steven.French@microsoft.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Samuel Cabrero <scabrero@suse.de>
Subject: Re: chmod
In-Reply-To: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
Date: Wed, 13 Nov 2024 09:51:55 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Ralph,

Ralph Boehme <slow@samba.org> writes:

> In my testing against with 6.11.5-300.fc41.x86_64 against Samba chmod is 
> not working on a posix mount.
>
> I don't see an expected set-sd call with the S-1-5-88-3-mode SID, it 
> seems the client is not considering to do this.
>
> mount options (all default beside explicitly requesting posix):
>
> //localhost/posix on /mnt/smb3unix type cifs 
> (rw,relatime,vers=3.1.1,cache=strict,username=slow,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,file_mode=0755,dir_mode=0755,soft,posix,posixpaths,serverino,mapposix,reparse=nfs,rsize=4194304,wsize=4194304,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)
>
> Is this supposed to work?

Yes, but this is broken for a while already.  Samuel reported such
problem at SDC 2023 but nobody fixed it yet.
