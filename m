Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E55E3ACA78
	for <linux-cifs@vger.kernel.org>; Tue,  3 Feb 2026 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770132884; cv=none; b=rThNaBFd7q3qJgWq5Lr1hdoxf0g0I0w9rG1DK+CZIipe7dTiQB2yEicPuturXGuAFmkBwLzRaixS1NyejPTCy0RP2D8UdB2Fv6yRzh6JBEdaA05FHKaQxaFTowzOxzUBazDTh2UeaUMpCoesaFg5ctrYxU+fjjgRd+bzyVrZV9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770132884; c=relaxed/simple;
	bh=TGaje7OyYxCAGf1IpBxS10iopHRuh7D9j8scJzYcMZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghw4Iqt8cUJhK+Uz7TGiJ7xF88Bv4Hi7ccE+/zAkjz0CcdQDw9KShc9BoHjUdH3dZ0G4z9E3n20+du8PCAmPb5q2aaQIGWWH2uSkFrW4P+PGTiv5KZBPH9mvAUsFKDA9sVk38lOwy5DZ/o+WJx72cutOWpT/aNYpO8PVgjwYmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bFAjElFi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bFAjElFi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=zOK8Z4aogisOi5gxd4CyoR5qgb8OCMTjCkj6yAjfp7I=; b=bFAjElFibiRlpBiMOhwsb845LV
	/wtrbZgsIk2G6C2+Cr+PDkc+0i1HTOKbLP96JcX/dmIKBbmuD49x/LIvHmL1flsqt1UTrilg9EylM
	Fl1tiin1nVYRsyteVaJCUDqB0NkL3w7UPan3tch+dlr3O20ArHcZKBv1IhStZ3pHVZ6uZiK3gszLO
	Y8MpafEzmqxI6dZo6P0NJL7+U7gjMIFNd+u/nRbieXE4fl7Vh7Lo/2ne0AA9SZAKWfgGgwD2nGKEW
	qsUHL9/dDBlz9p/3BcUpGrJWKhG9hVNPOI+AMR5t3R4kJFC8mFNq3b4VsTU7mJFzn7jjoqGjbdS1D
	fde3SOlFkWGwxvKSv6S/4PY12wJlAkHvAYEJuEKjdobHh9ycWF6Ulr0LbXXJLLwzUUw6mLcDVNgZp
	M4ZkCG9WpPcwrl817Q+xPdUpTnJJNb97p///CmAf/K9iULRUZr3jpnAzv987XEqPAyJFVWHA1VZgC
	HfxBAwzxxSRMAj81K9bYJehr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vnIQK-00000003yKc-27IT;
	Tue, 03 Feb 2026 15:34:40 +0000
Message-ID: <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
Date: Tue, 3 Feb 2026 16:34:40 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: common: add header guards to
 fs/smb/common/smb2status.h
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260203152012.914137-1-metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260203152012.914137-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

this is on top of your for-next branch as it depends on this
patch from David:

cifs: Label SMB2 statuses with errors

While there I found that this patch:
cifs: Autogenerate SMB2 error mapping table

Generates this error:
client/smb2maperror.c:55:60: SPARSE: error: restricted __le32 degrades to integer
David can you check?

Thanks!
metze

Am 03.02.26 um 16:20 schrieb Stefan Metzmacher:
> This will allow it to be included multiple times without problems,
> that's needed for the smbdirect move to common code.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/common/smb2status.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
> index 3b86dbf8c369..b6421bc5113c 100644
> --- a/fs/smb/common/smb2status.h
> +++ b/fs/smb/common/smb2status.h
> @@ -9,6 +9,9 @@
>    *
>    */
>   
> +#ifndef FS_SMB_COMMON_SMB2STATUS_H
> +#define FS_SMB_COMMON_SMB2STATUS_H
> +
>   /*
>    *  0 1 2 3 4 5 6 7 8 9 0 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
>    *  SEV C N <-------Facility--------> <------Error Status Code------>
> @@ -1782,3 +1785,5 @@ struct ntstatus {
>   #define STATUS_IPSEC_CLEAR_TEXT_DROP		cpu_to_le32(0xC0360007) // -EIO
>   /* See MS-SMB2 3.3.5.4 */
>   #define STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP cpu_to_le32(0xC05D0000) // -EIO
> +
> +#endif /* FS_SMB_COMMON_SMB2STATUS_H */

