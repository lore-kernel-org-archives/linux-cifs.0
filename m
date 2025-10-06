Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815802D47F2
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759759882; cv=none; b=YCeRRNv95rGsRn7nuhMF2Rnv9YSLOTPLFwaq0M7MhnSqy2iypAM+YSNpwEcEnc+qqmsAmTTzMxOnH2AXqAsV/ODMx3GmThpWQZVrd6GF+H7Pvh9gVJVdt24RbKwQy8yFJ8oMAh11rTfvNveQybkaWKduO9SsQx9tcgrzVovBikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759759882; c=relaxed/simple;
	bh=6KX20FQd1Uo1sLjzECcx7oev8zJiTnNJjFoFDUGykpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A4EThN7jjF+O5a+3vgHaj8ZqibsCblxAEp9jP9q2NPF4kQ7i+8U+g8mNVGMLlGCNGPX0wKwhGB+ESJ5ewTTWT2lVEj41vYgVFoytqYA8rc+S3k7d15lpvP+CFBrPzZ9Vi2F9wFt1YjiMWT8AmqqMuA/tGS7ofWIpVVX17I6s/PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BU5qEbUC; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BU5qEbUC"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4060b4b1200so4412689f8f.3
        for <linux-cifs@vger.kernel.org>; Mon, 06 Oct 2025 07:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759759878; x=1760364678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4elTS5fxSiSlcbJrOu3/EQIYqhoiCF3SWgVxpKWdawI=;
        b=BU5qEbUC5jt61szkz8QGfDfN+BuXIBOtoGhaedEWqh7+3OwK2w/AsFWpzQW1P8MoUS
         7dqXmZ1zJDFsAI4FwQIm1g0HcQqOmfVpoNoA+GAwFiXqZkcugVoSVW7JWClcI6tZo//t
         uE+QXfPT4ZbNsGvGo6nStGjyG1KyuEZwPF9u/RZfGx6gpXr5MaPGb8bzcJQ+KlQ9kiE5
         4cKBoyiJyFnUxbh4ygdO9KgXXM/OgXlJIZWH7tSsih6EdaXbaQjPVWBVHtLLrZ/bV1Y1
         u3zmR8BW/F9JP2leFfVKAPZy2eMQxQnmzmjswXM7hsi9WrBX20YO1lmqOfk/hl63mMAz
         /Qvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759759878; x=1760364678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4elTS5fxSiSlcbJrOu3/EQIYqhoiCF3SWgVxpKWdawI=;
        b=SJ/k9MwYJIJbpnfVlevh7arxe+WoQFeLJwY/NoVSDB0Ahx3Rt680LOfep4eXdvxGvF
         Y7tDLIogzrXxWvprvfZ5CY8MwTzeODEA62UNsDMpSWCjrqeB0LmB9WKEy2MlO5QdDE1s
         VwL87Cn4wxGjwiYrnQ4GvoP4qN2IycZK5L7+AeZKWeOGwCLOxaHl24vhVnk87sks6mQ0
         AlyLZZV4MbhMyPEKCxTdDr7IpkeDXD52jOQlm/I+5aYaWOce5vIInlEQglot0TReLDo8
         PbcZ1e/CMmipJHvkKndr0zaaDnE5yGw/tYzHoLuQjJdy4X5U1VNFsukH+x5IE/ff3R9f
         vGmw==
X-Forwarded-Encrypted: i=1; AJvYcCVEApZoYJbkpU7fgEQblJvHpd9p6moEF4PcB1B751EyUGixGiQL5rw1LPSoFbjZIxaaq4gttVwZ1hbQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6se+VB2gj2zDrfsE9gYitlmS+/paEVLUOrx5zsNd85+yuhS+l
	+bdhmN68MXzlgevqd8EnL6pqeVLgldZ/c7elmCPvxZ0iR87yxfevoEfFDvbxXX0/qMV2leDe+K+
	Sra0E
X-Gm-Gg: ASbGncuVuBy6wZIx9RAZW+MzmRqFfECXQxDOcBwoUQx/Ffdp03iOEaA8ywGobE0RvNB
	U5+lZ8dwDNLTJrz+j5UE9CckMjsT3S40xJ8w+2lYnMFeNRV8TTNvBMD2V+Cg5PkMYg7IPlcVojU
	G5ushBcfBnYDfDqmqf4BTAKcjmhqS61zHqpYT2EQtE40CKzNckkUV+lMH+Ru3lHpFSmmczapcVN
	fMuZ/Y7u7dOTrRMn5LtBisAC6sfCEZUoQkXmYBPTA1Dp4ek2HJG3ruEXirsX6SkI2lxd/OmEAUr
	K8VFMkhEa2NtbCAcrIMeRw8lFrTGXUx4sYmiSnDxsh46tYaYeuVugkmNLaBrQJvTwTu3IjAxivy
	umVcayQlrQZDjAvmhoTbO62MeZBVbww8zg8l25cuYHQl0EUo1uznrEIQQOUh0fcOI2yZ4aCPNqv
	alx9bVD6tthzhRNLI11pfcOe3Oy2lRBld4q8dhuA==
X-Google-Smtp-Source: AGHT+IEM2L1wWYPT5u1TbIMvltisCAwxrpRriHBP3NHzwPBECHbb42VTLW67CPPTPF2hjKNFBgKsJQ==
X-Received: by 2002:a05:6000:310c:b0:425:7f10:e79b with SMTP id ffacd0b85a97d-4257f10eaa1mr1731307f8f.44.1759759877557;
        Mon, 06 Oct 2025 07:11:17 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bc01:231a:db87:72a2:aec1:dfe2? ([2804:7f0:bc01:231a:db87:72a2:aec1:dfe2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b62e121e0afsm9126319a12.25.2025.10.06.07.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 07:11:17 -0700 (PDT)
Message-ID: <8e79516d-ad82-46bd-af00-3a8594a0baee@suse.com>
Date: Mon, 6 Oct 2025 11:09:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Reduce the scopes for a few variables in two
 functions
To: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French
 <stfrench@microsoft.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <468cf96a-5dd9-4aa5-a8ce-930cf16952b3@web.de>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <468cf96a-5dd9-4aa5-a8ce-930cf16952b3@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>

On 10/5/25 2:10 PM, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 5 Oct 2025 19:01:48 +0200
> 
> * cifs_lookup():
>   Move the definition for the local variable “cfid” into an else branch
>   so that the corresponding setting will only be performed if a NULL inode
>   was detected during lookup by this function.
> 
> * cifs_d_revalidate():
>   Move the definition for the local variables “inode” and “rc” into
>   an if branch so that the corresponding setting will only be performed
>   after a d_really_is_positive() call.
> 
>   Move the definition for the local variable “cfid” into an else branch
>   so that the corresponding setting will only be performed if further data
>   processing will be needed for an open_cached_dir_by_dentry() call.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/dir.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index fc67a6441c96..7472fddadd4f 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -678,7 +678,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	const char *full_path;
>  	void *page;
>  	int retry_count = 0;
> -	struct cached_fid *cfid = NULL;
>  
>  	xid = get_xid();
>  
> @@ -717,6 +716,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	if (d_really_is_positive(direntry)) {
>  		cifs_dbg(FYI, "non-NULL inode in lookup\n");
>  	} else {
> +		struct cached_fid *cfid = NULL;
> +
>  		cifs_dbg(FYI, "NULL inode in lookup\n");
>  
>  		/*
> @@ -785,15 +786,13 @@ static int
>  cifs_d_revalidate(struct inode *dir, const struct qstr *name,
>  		  struct dentry *direntry, unsigned int flags)
>  {
> -	struct inode *inode = NULL;
> -	struct cached_fid *cfid;
> -	int rc;
> -
>  	if (flags & LOOKUP_RCU)
>  		return -ECHILD;
>  
>  	if (d_really_is_positive(direntry)) {
> -		inode = d_inode(direntry);
> +		int rc;
> +		struct inode *inode = d_inode(direntry);
> +
>  		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
>  			CIFS_I(inode)->time = 0; /* force reval */
>  
> @@ -836,6 +835,7 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
>  	} else {
>  		struct cifs_sb_info *cifs_sb = CIFS_SB(dir->i_sb);
>  		struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> +		struct cached_fid *cfid;
>  
>  		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, &cfid)) {
>  			/*

-- 
Henrique
SUSE Labs
