Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A2C41C63
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755284070; cv=none; b=TZ02n0jm+LxBB8tXU7ghwsq+d3fdH9mk7REo6xNjccXgXh5IMbrvEuwIh3Xn4iKdGJJgthikRhkfunxiXZxx/vSEBHeEDt9UtAJEXYIIlGLyg0IJnqjF5jTl+Njt2AsSYHxWNOYE7+XfYQ/1wPQq3PcBXvXk6Ccg8XG/jX3dnO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755284070; c=relaxed/simple;
	bh=feYrH81ll2LQ0StPZFgg15IM+J6/HWwpSWoHBZvdG4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZpuydUxJXtaYSa4yaMQyMneCMOBaZYW1ZE9PjnmKwAJEQTEiOQismkU9827hjuMWmV8erjvaw3tDHbQBaXWsYNsZRyVibxI0oh/BZSYF7PI1mybauIs8n1Y6cNC7SZA1U4AG8NM0o1CkBjMYddJpJxsUuI2S7UXDKIMVnU5gJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xoAo8F57; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xoAo8F57"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ZKtXS1xlHywgeG63+c8TImHR9FlMaC+j8CtJTcFDpxI=; b=xoAo8F57Ox+n/P6I3rv4HLJEIO
	6auMFdeSiu8DI0pUXTWhEju07m0Ua8jXVdJzo0j4Xxzf8JBKgqQNGZ0pCEyU14Kv+ToQ0pezelsRb
	cUGP3K0xLCUM0C2/VuQoRYAaBbxiyWkbSUoKrBA1jF3/B0zeo/+P17NqjeVlMcZa7mLe5hPfLPMzQ
	fypEzv/gFyPjpRjV+HN7DVOcTvN4hEZICL+LiSIYLfvcKRFhbhyHxlB+Apz6IWRopQWOK6dgSk0y3
	cxcYFevvPfIFUzss4M99qWyNE4GQ7prGTjfnhxU3CjE/ExaAnexDazcVlC2D6nE+PaFz11GLZ8Bqw
	x/e5qCx+WAnANz+q5S10R2knYQZeE0nk+JLaNZ/pAgjZshIWmXrPqEfzGr8AoAiJ9gnGxXrVS+Mmd
	a3mHj0syHbHsXrhD4CAV+dpd/4HlVb096/ZitP3/Ztd8WKdehp3Dv2YC8yVtUxO/+8r8MDNxl8LBj
	Ft4FrkQOvjpIqT8y4MHik8lN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umzZK-0032nB-0I;
	Fri, 15 Aug 2025 18:54:26 +0000
Message-ID: <5c1a0969-1757-46c2-ba88-a5db75f76d78@samba.org>
Date: Fri, 15 Aug 2025 20:54:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of
 ksmbd_rdma_destroy()
To: Steve French <smfrench@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>
References: <20250812164546.29238-1-metze@samba.org>
 <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
 <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org>
 <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
 <0bcae9fe-1dff-4530-875b-fe917af5b649@samba.org>
 <CAH2r5mtas+irtVpkkCYRLyXpPknXqbAiN9gdupo-5z=YbFepTQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mtas+irtVpkkCYRLyXpPknXqbAiN9gdupo-5z=YbFepTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 15.08.25 um 20:52 schrieb Steve French:
>> Maybe also remove the 'return;' from the inline ksmbd_rdma_destroy function?
> 
> Done (updated cifs-2.6.git for-next with attached)
> 
> It does look a little strange that a trailing ';' is only after the
> ksmbd_rdma_stop_listening() line - is that intentional
> 
> diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
> index 77aee4e5c9dc..ce3c88a45875 100644
> --- a/fs/smb/server/transport_rdma.h
> +++ b/fs/smb/server/transport_rdma.h
> @@ -54,13 +54,15 @@ struct smb_direct_data_transfer {
> 
>   #ifdef CONFIG_SMB_SERVER_SMBDIRECT
>   int ksmbd_rdma_init(void);
> +void ksmbd_rdma_stop_listening(void);
>   void ksmbd_rdma_destroy(void);
>   bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
>   void init_smbd_max_io_size(unsigned int sz);
>   unsigned int get_smbd_max_read_write_size(void);
>   #else
>   static inline int ksmbd_rdma_init(void) { return 0; }
> -static inline int ksmbd_rdma_destroy(void) { return 0; }
> +static inline void ksmbd_rdma_stop_listening(void) { };
> +static inline void ksmbd_rdma_destroy(void) { }

No it needs to be just { } in both cases.

Thanks!
metze


