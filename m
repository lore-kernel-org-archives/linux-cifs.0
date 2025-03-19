Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855D2561A9;
	Wed, 19 Mar 2025 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742390454; cv=none; b=kxtz8F6FwoE+Gn6BsjPMwBnSIPoamx8Kp4NsF02kigd1t6UVFOeIdxpGfj4j61f3C7Ts5+Wkcuw/gEQtO3HR9Mi5gG8xTOwzbtvoVgsOOgTVkUnXyXxNTpaFyHQskbAufzQLKGqIwOWK1GoT5kwKP4dyItDs+BVjfIBcSFgq80M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742390454; c=relaxed/simple;
	bh=t3NPHZmEs0IOLbyp8nLJfl0nWThQSpDc9XuxgwnjIJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7p/lbVmjUMf/wdZqEIn2kW1NxNG6EBzP/mKoWzHinUclT5BtZEe8ysAcHfuJlOgN1UgfyJnWrHuowfbMtJVNnV5iJmOfB3/othM7tmSIZr8jTPUUJcD8rYG5D1prBpLiI7WJ5CO3tF82obO/mP3h1mGzcbJwShJG95F4os67zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=dG4R7ff3; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="dG4R7ff3"
Received: from localhost (unknown [10.10.165.6])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7AAB94487856;
	Wed, 19 Mar 2025 13:20:41 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7AAB94487856
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1742390441;
	bh=Zz2pEh2nfdi5YtDfIU1ZX58JSLtvXWSI/ZwdYeX2inY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dG4R7ff3x6jTLMi46ckYVCdMswrdwi2QvhpzoDGrK9IEAAaOsynnwuombzs+dVi7C
	 tiYIdZaV4vQeOW/oz/x7+Oxsv5n1aleX4ld5aRKfxoeml6+Gg+bg02H/KeYEKOc4UX
	 2poWV8zqx3sp/8MmNkuvaCv8yia1eV40zbOHeGko=
Date: Wed, 19 Mar 2025 16:20:40 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Alexandra Diupina <adiupina@astralinux.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, 
	samba-technical@lists.samba.org, Aurelien Aptel <aaptel@suse.com>, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Pavel Shilovsky <pshilov@microsoft.com>, 
	lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] cifs: avoid NULL pointer dereference in
 dbg call
Message-ID: <ci4fhara55ka4mh65zn7x5vp3zjcqcytghupjzz2izudvjjejn@6qggfqf2qsxc>
References: <20250319123110.21814-1-adiupina@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250319123110.21814-1-adiupina@astralinux.ru>

On Wed, 19. Mar 15:31, Alexandra Diupina wrote:
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index f3c4b70b77b9..c02aab58aade 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
>  		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
>  		spin_unlock(&cifs_tcp_ses_lock);
>  
> -		if (tcon->ses)
> +		if (tcon->ses) {
>  			server = tcon->ses->server;
> -
> -		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
> -				tcon->tid, persistent_fid, volatile_fid);
> +			cifs_server_dbg(FYI,
> +							"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
> +							tcon->tid, persistent_fid, volatile_fid);
> +		}

Something is wrong with the indentation. Usually scripts/checkpatch.pl
can give some feedback on this, too.

CHECK: Alignment should match open parenthesis
#32: FILE: fs/smb/client/smb2misc.c:822:
+			cifs_server_dbg(FYI,
+							"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",

>  
>  		return 0;
>  	}
> -- 
> 2.30.2
