Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD7492E56
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003416; cv=none; b=NTOpzjjO94LzPAuVcWRH4l0azgVa999B6lUcUmOwXYjIDAWTINFSlZf/xaaPN6yXxeAJecn0KwxOaaKX6hTtvGNY+cdbUrKEUqHVDAwxlszspRUYuUrQBFgXnW1Z36UpGe8IHdiFBcE3Yr08whog8rMZXBsRmXbUJkK4gMBWUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003416; c=relaxed/simple;
	bh=p4wtHkJRrb686nIr/T77Ch/kUH2/YjR81Zf8Q3XavP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RNQgBqoS1zwICfVfAelpQZmwI4VLN420ht/GnZ6G2H7WOORx5OkEaQdChu87Seb2SxJc7SKBUQqPzc/xUw4xaRiao30GI/gYKYDLjRawI20OKqyxiVMXQYEKkiIx3sxaRBl+Wqwl98WeXKBWMkj2g6zUlSqjWFs8iFjHpZrE3lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKkiLf30; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1u/KdCy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKkiLf30";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1u/KdCy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790003414;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KP/WqIglOMecbqvnAZpiZd+ruC1UjHTFlInUM+iwZGY=;
	b=eKkiLf30i8GkfxCu+uHOlRWb/Xm2Nj9SUhvChG6ksYxWuNe9JWWvfaphR/5t9Yk+t7QBm8
	yaD3ZGCh5Rqy7oEnHcBQemiEJweVRGyEWsy4eRJUx0peyhHxsdsEhq4BgzwfS/tZKg+LOi
	m5hMhKcz02AzHV2uuSxaAleGfFRB6fM=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-FX66NIToP4aHXrI0e6_8fg-1; Mon, 21 Sep 2026 11:10:10 -0400
X-MC-Unique: FX66NIToP4aHXrI0e6_8fg-1
X-Mimecast-MFC-AGG-ID: FX66NIToP4aHXrI0e6_8fg_1790003410
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-671562ddec3so3949295d50.2
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 08:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790003410; x=1790608210; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KP/WqIglOMecbqvnAZpiZd+ruC1UjHTFlInUM+iwZGY=;
        b=b1u/KdCyN+UrnhvnVxQj4okYRS6n5SlMY866lSX60wLiLM5B/Agw9H6JvdxdewuJIL
         ulUcDH0BFFax69zmRHKdL8GblVjuOm0S9i8Ge6iSxP1Poaf9g5Vh6s7dbBXB4z5vKK++
         lSaFt2gIH9ABS+0cX1rnmVNHJ55KkvRvVuvTqzTJDh0XpZ+1s26T8fnTO7wzTYlqRiV3
         950zZ/URroY21OcHwUmaA3c9oD61LbB+LlCVd4b68iqwwiUYCU2gs4UM3R78eD2Q/LHq
         r+qaqQUKgh0fDdJeoQs37diGwcuVHQ3UYSz7rUrTZx4xoxkyND8GeUNBKj0XIybudprp
         ZvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790003410; x=1790608210;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KP/WqIglOMecbqvnAZpiZd+ruC1UjHTFlInUM+iwZGY=;
        b=ItTuNW8icbB9BDYNlq2rB72K//bRSg/376zHWRZTlzgYje22CD4J10zvxk7XzvhHI+
         cOFtEHfjgPVxlhVIP4uKFJMJsi7NW0gYz9cnRVym7JSzO5kH7anxEMjsq3I6O45d4ytJ
         WdqqoD5VtbBSYQO+eIPhD1thHJis+jlN//NargjueODjsI7kzRxsTT3mTHCs/RPO80pi
         Q8vUkY8wAGFjlnElE2/LYQ8zYKEdeTMAapKomnPUSpDjCxq4xQuCR47C3cQANvf3a51o
         gJDY3SZ51LFYemWF/higc/+ODym1LmNXRR1zpvZCnroqa+0m3zFwUvGXBiI520teYEZ8
         vnzA==
X-Forwarded-Encrypted: i=1; AKwUvBw/I+7tmJiO3XykcuvmrZEah7H5uZdUcpkI/B/F5cTEBcTd7EO+iaJPMGfqOukrFy5fVEPizz1DhNAy@vger.kernel.org
X-Gm-Message-State: AFuF++mWMy0p6MihmbaERFflGL+lHL8ztIma5RmrUaBwgsRkTDYpfLrk
	tbsncclvwLrshooBD4B05ina7O+kvQ5Zm/n07lwpvnsvtn7pV8zI3jsZME67VfRfsSDG00wNrFy
	NV7x+UR/Zw0025hdb+zgJo9CNMq1stPqlzqPZZgIrveFp0nZxReij7cX2wua+ZOo=
X-Gm-Gg: AYBFou2V/jvOuquqilYhlPKrYqAYSII8hsWwjdad5SyIpY8KDv3OtcbVebwH0akWLhm
	F5uqCVliIAbCx5CNOelyFKAqR03F4hRuC+sXRkPevnnKRO5MsJw1Pnqkki7iizGdup2HJqXeFoo
	O0Mnf1LHHDojgWBtTmltpCICPemh41CfnyjiHUK0Zdi6ExlHWhprfICYqGVmGzFg/V/NpwXxjyh
	2PCmX3iOCsA3Jhxjsp6OarCnWwxyOejORDulfaEqvEZ5/zwspr51ZHrGF2dqu/xtfeA3EImdJmc
	MutGBhACaRcEnIWksh62A+sovFqBswpy7DJ0iHoe+C7L2tKoIGsa4EBLGL/H2Fx1w01HQMLV6N9
	LdsQgQGRhgKtvOsNHz2oXaWgAg7FYFaZtfzsLLDcK
X-Received: by 2002:a05:690e:418c:b0:671:6e1b:3579 with SMTP id 956f58d0204a3-6717fce3850mr2872381d50.31.1790003409785;
        Mon, 21 Sep 2026 08:10:09 -0700 (PDT)
X-Received: by 2002:a05:690e:418c:b0:671:6e1b:3579 with SMTP id 956f58d0204a3-6717fce3850mr2872360d50.31.1790003409357;
        Mon, 21 Sep 2026 08:10:09 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672990aada0sm3719159d50.9.2026.09.21.08.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 08:10:08 -0700 (PDT)
Message-ID: <199e41b7-e739-417a-9c23-f812dc56e7a9@redhat.com>
Date: Mon, 21 Sep 2026 10:10:07 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v4 0/6] smb: client: fix create context out-of-bounds
 reads
To: Zihan Xi <zihanx@nebusec.ai>, pc@manguebit.org
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <cover.1789478666.git.zihanx@nebusec.ai>
Content-Language: en-US
From: Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/26 10:29 AM, Zihan Xi wrote:
> Hi Linux kernel maintainers,
>
> We found and validated an issue in fs/smb/client/smb2pdu.c. A malicious
> SMB server can send a malformed SMB2 CREATE response to a CIFS client and
> trigger an out-of-bounds read. We validated this with an Impacket server on
> the QEMU host and a root CIFS client in the guest; CIFS does not set
> FS_USERNS_MOUNT, so the mount must run as root. For valid SMB responses,
> the series preserves existing request handling. No impact was observed in
> the tested CIFS mount/read path; a full filesystem regression suite was not
> run.

I ran xfstests comparing cifs-next (7.3-rc2+) with and without this patchset,
and I don't see any additional failures due with these patches:

tested against:
samba: v3.1.1, v3.1.1+sign, v3.1.1+seal, v2.1, v2.1+sign, v1
Windows Server 2022: v3.1.1, v3.1.1+sign, v3.1.1+seal

I have not tested using the POC... just for regressions.

Tested-by: Frank Sorenson <sorenson@redhat.com>

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

