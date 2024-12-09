Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D01014E2CC
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733772734; cv=none; b=FmTB8J2mgIW1cv0JVfaZ5WQAtjOxZkQGqSkzy+7tq7XhMCjoKJ0NOYu1rfL2gvf4GW/LarnxEJl0NfghaQ5OoJollu8YmNjaoJpaHqGM6FydTZCbhyRRPRNvLyMRjQ65npN7ZKb0mVzXGGCj25151kAKHAAi1S18IucHD380mlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733772734; c=relaxed/simple;
	bh=K2BhyQ1O0uwaV+nIudRYaNoMH4wQMpFCmS/Qnoylv1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+OMYEyUX1mATI6drMq9XJIBF2/Dy9TQq9LYBpmBt9sWTeUeHaX0Pfy8UChje+TFnsjJs0BdtPN7SE4tYERy1obMk9XxpDvsOigWQpuEVzlMYxDGFS6WSi6e8zpgqR3zyHb+91ifgOMK0HJ+zKoALOQKS5HUImPFDnTzckwgjqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Npb8Uv0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Npb8Uv0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DF8C4CED1;
	Mon,  9 Dec 2024 19:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733772733;
	bh=K2BhyQ1O0uwaV+nIudRYaNoMH4wQMpFCmS/Qnoylv1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Npb8Uv0+Gk+IsXMSUH1ahpyNe4A5VipPTNSSY+iRg7WXl3e9OcbmKV3vuFWT3Ilsz
	 oZwtXT/O41jD2hLcp1nceiyzpFaNSI5QjvdjPrxadylEC2wFq4wCnMYX6xUXLOlaaS
	 84WOCg+CnzWKXyezPyCkLh7/oHkDlAC7v7ABjJeovUW/VQWBEWydyRjzHllhxxcQVT
	 +GLYdr86N+lXlATzThK0zhrbHJxFkoxffAcvMp16k4cdR8vVzJ4G29eKsviTBbwNZ5
	 21WTsXk/jrKKXfgwD4fqCheiinaLXtLnVsURVFftOG96CnE547Q9pt23P08Tkwz4SP
	 A8BnSPmPoO+hA==
Received: by pali.im (Postfix)
	id CD4098A0; Mon,  9 Dec 2024 20:32:04 +0100 (CET)
Date: Mon, 9 Dec 2024 20:32:04 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] fix minor compile warning in
 parse_reparse_wsl_symlink
Message-ID: <20241209193204.jbz2hhhtjcxopnd7@pali>
References: <CAH2r5mss-vX3Fu+0MGrowFONRBshLuPicQa9nEcub7VhPqNJ9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mss-vX3Fu+0MGrowFONRBshLuPicQa9nEcub7VhPqNJ9w@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Monday 09 December 2024 11:39:17 Steve French wrote:
> utf8s_to_utf16s() specifies pwcs as a wchar_t pointer (whether big endian
> or little endian is passed in as an additional parm), so to remove a
> distracting compile warning it needs to be cast as (wchar_t *) in
> parse_reparse_wsl_symlink() as done by other callers.
> 
> Fixes: 06a7adf318a3 ("cifs: Add support for parsing WSL-style symlinks")
> 
>   CHECK   /home/smfrench/cifs-2.6/fs/smb/client/reparse.c
> /home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45: warning:
> incorrect type in argument 4 (different base types)
> /home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45:    expected
> unsigned short [usertype] *pwcs
> /home/smfrench/cifs-2.6/fs/smb/client/reparse.c:679:45:    got
> restricted __le16 [usertype] *[assigned] symname_utf16
> 
> 
> See attached patch
> 
> -- 
> Thanks,
> 
> Steve

> From 0096f8e57b4b6e503f0abeb0a79e2b1a77157a53 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Mon, 9 Dec 2024 11:25:04 -0600
> Subject: [PATCH] smb3: fix compiler warning in reparse code
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> utf8s_to_utf16s() specifies pwcs as a wchar_t pointer (whether big endian
> or little endian is passed in as an additional parm), so to remove a
> distracting compile warning it needs to be cast as (wchar_t *) in
> parse_reparse_wsl_symlink() as done by other callers.
> 
> Fixes: 06a7adf318a3 ("cifs: Add support for parsing WSL-style symlinks")
> Cc: Pali Rohár <pali@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/reparse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 50b1aba20008..d88b41133e00 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -676,7 +676,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
>  		return -ENOMEM;
>  	symname_utf16_len = utf8s_to_utf16s(buf->PathBuffer, symname_utf8_len,
>  					    UTF16_LITTLE_ENDIAN,
> -					    symname_utf16, symname_utf8_len * 2);
> +					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
>  	if (symname_utf16_len < 0) {
>  		kfree(symname_utf16);
>  		return symname_utf16_len;
> -- 
> 2.43.0
> 

This change looks good. I did not know what is the proper way to pass
little endian utf-16 buffer (__le16*) to that utf8s_to_utf16s function.

If this casting is the proper way, that it fine for me.

Reviewed-by: Pali Rohár <pali@kernel.org>
