Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28001D5141
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766764068; cv=none; b=PEUuL3V8qWw3CNwAUiDq6Vcm8dYr5wWHYcAdKaxyOn6luPs4qf54EWvcZX1DZyMPdbmxy59rLBGLbkaXQ91cPs7jkINu5GYx1LMk1gynlhDHP5zYpqagGu+CmMqJcksC7ByLE5P+y5ldPhXB7zvnI9NFZ0PFFw5JwjfyFnWluQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766764068; c=relaxed/simple;
	bh=0R5ZYrUWcFgGmKC1YWTOmy02KVeUNII/mMtMUGq5A3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRwR+vYsimbCwe0EsU+yAn9cxpoY6irTpj6hvLeLlzh1siTAmafz/UoQ+3YSeOTGMYgNQIYLj5O/c+XEopxP7YS8BQS0zmmstcEubSVnURfdTr5XLFKe/y08m5E5NmAL8Uk8HtN8pWFbCVg8EpCOUhmhVMo9sDq8m7QARoMtFdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gHNHZ3Df; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gHNHZ3Df"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso46288615e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 07:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766764065; x=1767368865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sq4Ia/9e6geIgONH1BydGmHgyfZWGyHcJ/TjLEl965o=;
        b=gHNHZ3DfrZWSHkjv2iY7hy9R0UJXUk+zXv78bpKvVFW0XJ0eH5TjLAsVaMxCswIEck
         BudwP43KP3U+Kuv0yA3/mutRj0EJdExKSwh5xpMtqMU4y/KI2fnfCYHag042QljKS+A6
         qXofnDySIlmexchIwxptsLUrCyDVU0xNqhX+b+uu6DqtaqKnT62r2oQN9VGiAAJWEqZe
         Z+EcxD5NKA7r5w6TQ0tM74YWGq1uhKvYYPehbnVfdE30Od1Hi4abLuHQ3r6GPPPQLCLt
         ek9mi47xOCmPqwpUNnsCOL8WB1N4qcCbVElIsUU0qPpwcb1dmUcc9WziTdr5d7lhoDAI
         3gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766764065; x=1767368865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sq4Ia/9e6geIgONH1BydGmHgyfZWGyHcJ/TjLEl965o=;
        b=O6za0iQe5UnubDRHjWQdHJWi8AhLKI+rIW/lmkKVMPmuN7rDipmGqc2XwIkNGJKwID
         gJvhCrXB5bQJD9WuVg1/SeUKgv5bkubHJeFIokO/ihSHSTpUuEb8GddwyhBsf1mKf7Ko
         oNcamy6JY+f7yox92RTpvY1a3FXzVryjH70i4LUPikbik8e127PwiPVdEn9kmfs2SGpO
         zx7MsdTnz4pLxZ1I9xLiXdR6HR2LMI2yQoIflgBNKVdYUPxtP738spXrhGEtV/btm0hx
         BEgGyEseybHmuumS7eKZ91MoNSRv2ObVOhZl+mXYBPY+UoNC7LVYtoVB1TGVvOauy6P/
         OiWA==
X-Forwarded-Encrypted: i=1; AJvYcCWfoc8p7GTXMFzvjQ+V8qqBV1wsto9T1vJxG2RrjNhZn+waKWrIy85VZzdsaPYRGPCwhujLVtwZUcuE@vger.kernel.org
X-Gm-Message-State: AOJu0YwV9ilZMgQxrOqmjBGfjzD9TJDOxFxaWXPzpcgPrLPzFMV/zs6S
	5b3hpEQO5UO+UkTx0nHxzV/s/95DfJityG9DWtWm0ZD7vaPfS7gACoQGNF3blGGm3Os=
X-Gm-Gg: AY/fxX66xbA3hpqdHdqd+NfaLiZKljpzqMMHjQmnWUxYKga7yke6ka8Vx11J8jPnv4F
	ZkwXxjZ0kvP03/l6EtxLX632CvTkb7qjfY4lGGjv75J1nHggHgX/XbyAtPWH/JMosVYqqDCtvWT
	zrbyGZcnnxuiTo25nXhrukdquWXncL2TM87Ao+iYzzfvhD6B1AB/x+8Ep7n1JfTdwXkh3cPobsJ
	+8MI7qprAvPrCPyblyzxd7+MTmuQs4GKOzl7zWK8K4tBugS9/wJJhPHyVitLUUqJpamw5zktNvr
	uMO7hG+xlZSWB5HyehuzGUu5sXIOMJIe+fI2ORvKWNzYfMUa91eCssg+b24zVMRWmLHR5G+R4E9
	bqaNwVm11Kvx1pvStjIVIp7t3g6fbZJb1ppfNu7AV53XBmm4AZWweR36BRWifgyvttUOb3klcGM
	haouv/vQCMYUjz3w615PnkgELtKQ==
X-Google-Smtp-Source: AGHT+IEN+8XkT1pwwHPMhsqMFrpcKMog1bb93F/k9eHTnoCwBLL3gU9bgnXmmMGOaqAjlDi09PoYBQ==
X-Received: by 2002:a05:600c:470e:b0:475:da1a:53f9 with SMTP id 5b1f17b1804b1-47d1954778dmr237774675e9.14.1766764065068;
        Fri, 26 Dec 2025 07:47:45 -0800 (PST)
Received: from precision ([2804:8fc:1d03:c72b:a43b:e62:50f9:41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm85817178c88.1.2025.12.26.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 07:47:44 -0800 (PST)
Date: Fri, 26 Dec 2025 12:45:26 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Steve French <smfrench@gmail.com>, 
	Youling Tang <tangyouling@kylinos.cn>, Namjae Jeon <linkinjeon@kernel.org>, 
	David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
Subject: Re: generic/013 failure to Samba
Message-ID: <xrumab2vstnivbhiafrjhzflztii6bxfwrlfs3lfjc7lwsbty7@3jozs5y6lxg7>
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>

Hi ChenXiaoSong,

On Fri, Dec 26, 2025 at 02:44:26PM +0800, ChenXiaoSong wrote:
> Hi Henrique,
> 
> The following is the modifications I suggest. If you have a better solution,
> please let me know.
> 
> If you agree with my modifications, could you send the v2 patch?
> 
> Give special thanks once again to Youling Tang <tangyouling@kylinos.cn> for
> his guidance on UBSAN and Clang.
> 
> If you build the kernel code with the latest version Clang (I am using
> version 21.1.7), and `CONFIG_UBSAN_BOUNDS` has been enabled, you will be
> able to see this UBSAN error every time.
> 
> It seems that we need to add two Fixes tags:
> Fixes: 68d2e2ca1cba ("smb: client: batch SRV_COPYCHUNK entries to cut round
> trips")
> Fixes: cc26f593dc19 ("smb: move copychunk definitions to common/smb2pdu.h")
> 
> The key modifications are as follows:
> ```
> smb2_copychunk_range()
> {
> 	// remove `chunk_count`, and use only `cc_req->ChunkCount`
> 	...
> 	cc_req->ChunkCount = 0;
> 	while (copy_bytes_left > 0 && cc_req->ChunkCount < chunk_count) {
> 		cc_req->ChunkCount++;
> 		chunk = &cc_req->Chunks[cc_req->ChunkCount - 1];
> 		...
> 	}
> 	...
> }
> ```

Thanks for looking into this and for the reproduction details.

I don't agree with the proposed changes for a couple of reasons:

1. ChunkCount is an on-wire __le32. Using it as the loop counter mixes
endianness-annotated storage with CPU-endian arithmetic and would either
require constant cpu_to_le32()/le32_to_cpu() conversions or be
type/endianness misuse. The current CPU-endian u32 chunks counter is
intentional.

2. Re: "Fixes:" tags: the UBSAN report exists because Chunks[] is now
__counted_by_le(ChunkCount). We currently index Chunks[] while
ChunkCount is still zero, so the __counted_by contract is violated. That
points to the commit that introduced the annotation as the Fixes target.
I don't think the batching commit should be tagged unless it introduced
a functional issue independent of the annotation.

Also, my earlier comment about the "first population" was wrong: it does
trigger, but the report appears to be emitted once per call site (subsequent
occurrences suppressed), which matches what I'm seeing.

-- 
Henrique
SUSE Labs
