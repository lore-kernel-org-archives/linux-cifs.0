Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD381DE2C6
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744226532; cv=none; b=uZ74j3c8hcSpvCWIc9BNi2XwVmCxGkCaj2UVmb3XS2ezZ9XMhHbaILCuboNEG1fG0xzKeEayzfYxt4LyHpaNxgIskFPrPybVW5PfxFfK+/giPt7QuonYQQHdYeUKhDg/rQIrm4lEGB4AfV/6hQgALh4UeJfS61HZ9/dpSus6P/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744226532; c=relaxed/simple;
	bh=hsYUbnrKdNI4WsAtRGb6DsS6USp/KTw/GWpmfV+KyiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAL3i0wDjBpVCyYlMHTxwYgrfaLP9iWrgPPaPAIAbw4JDWuKpRvQaaRywtVr+9xOAaZEp+z8T0A0KJRn56R+2mjEj2wngihdx/bQ27RENWKmdxr3bjXJ5OwiQgolwK2/AD82qz3q+LRX1A60w6M9SxWkFn36vAmn3tvoEPjZsIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dd+DasOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dd+DasOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA12FC4CEE2;
	Wed,  9 Apr 2025 19:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744226532;
	bh=hsYUbnrKdNI4WsAtRGb6DsS6USp/KTw/GWpmfV+KyiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dd+DasOUBixFPs2dY1/FGoW5T1bSKI19+8LiDXS9EiOHtbvMqWkKkvhobrYXm54VD
	 QlFJ6s+n7Pr7atOgCqgPNmqMAaQjH6fCSo/2P5M+MI9m/RSrB1NDn803qvlCoc5F+Q
	 Puu3qeNLwljzEAPk/OYomlmrw6qOh2lfALg4MkY0dBHssuvv6sBEM1oJpLCfz+3C/z
	 tIUTc0SOKeY4ON8FTQ8j5MWYRQU06D/bCKjRflXwqj64HZfjz4KzTqluKewZ1eZtFm
	 jnz4sE0fHvFZafkhR7g6jZCmDUkWeGuEka6ASIs8P8O/9eFoWA+IRHldmUR4mY1SS+
	 ZlFhb11GWSl4w==
Received: by pali.im (Postfix)
	id C492B4B3; Wed,  9 Apr 2025 21:22:08 +0200 (CEST)
Date: Wed, 9 Apr 2025 21:22:08 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
Message-ID: <20250409192208.eihyv566ralpl4zg@pali>
References: <CAH2r5msKV9ChZr6-2tQ3ZLSmS9D5s1SiOWGfbhCnVPMEKoDf_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msKV9ChZr6-2tQ3ZLSmS9D5s1SiOWGfbhCnVPMEKoDf_Q@mail.gmail.com>
User-Agent: NeoMutt/20180716

I have tested it against Windows Server 2022 with new -o nounicode
option which turned off the Unicode support. Without this fix,
the mount with -o nounicode option and NTLMSSP was failing.

On Wednesday 09 April 2025 13:39:58 Steve French wrote:
> Pali,
> Have you been able to verify this (your patch, attached) to any
> (presumably ancient?) server that actually wouldn't support Unicode
> and would support NTLMSSP? or was this only emulated by turning off
> Unicode (and if so which servers did you test it against?)
> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve

> From 1d789f0843075395945aa30528fb17d6c517d054 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> Date: Sun, 6 Oct 2024 19:24:29 +0200
> Subject: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
>  Request in non-UNICODE mode
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
> UNICODE mode, just strings are encoded in ASCII and not in UTF-16.
> 
> With this change it is possible to setup SMB1 session with NTLM
> authentication in non-UNICODE mode with Windows SMB server.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/sess.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index b3fa9ee26912..0f51d136cf23 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -1684,22 +1684,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
>  	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
>  
>  	capabilities = cifs_ssetup_hdr(ses, server, pSMB);
> -	if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
> -		cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
> -		return -ENOSYS;
> -	}
> -
>  	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
>  	capabilities |= CAP_EXTENDED_SECURITY;
>  	pSMB->req.Capabilities |= cpu_to_le32(capabilities);
>  
>  	bcc_ptr = sess_data->iov[2].iov_base;
> -	/* unicode strings must be word aligned */
> -	if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
> -		*bcc_ptr = 0;
> -		bcc_ptr++;
> +
> +	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
> +		/* unicode strings must be word aligned */
> +		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
> +			*bcc_ptr = 0;
> +			bcc_ptr++;
> +		}
> +		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> +	} else {
> +		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
>  	}
> -	unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
>  
>  	sess_data->iov[2].iov_len = (long) bcc_ptr -
>  					(long) sess_data->iov[2].iov_base;
> -- 
> 2.43.0
> 

