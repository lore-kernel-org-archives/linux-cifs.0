Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675027;
	b=j4XD67NrpYEtmHnQHrN8RBDMZNf/6QvhQBoEck0CzUeBudX8Oh0GtZGigAi6o5r8oRxh
	 q1ltyBxSxzJ9FR5CFMzSgRksUYOGUFbB3OZ/Kfj5VAc2YXuXf45KM6uZgTpbD+JaW8cuV
	 waxe4xqUgYoz4+rJmHUfNamdiEQg5fgUJ4fMucUoj1LL5pemtsoQHQp6am/uVUoL0xvxv
	 +iomURh+XM/zuAz+2FM/8fDl4yCK99NeFg653i1zRPyUCJhAuQLvHNqGk7Rb3j0YBG3GC
	 /R8zqdIuzT9IcscjNoLsOG0dwEDZzdfOg+8DPaAzj4mLtobwv9pTi+VTfJ6XugT4zDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675027;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ooyx/43cfLO7FTK575kvS4RSBtp8mYfWZfw4OohOomk=;
	b=sGnbpgy/4OTqRq60ckHww64XVCxe73fuCRnMcMSp+AZuNjZeiSPBjh+P9tIFUMBVtL0R
	 zVXO1FULM2l8jGCfqHq4tIxmtqshmRmt4EWN2LGZ9d8a0diEVwS4gwDxru82iAf2NP7a8
	 yLOKfksdnK2HxoCO2swEX73d7F15VThe2VDU1211OUuROaONeh5NEQ7HUDf7YZjWIAVq3
	 IQANuo/5c3dO0Uhp1nDgxvr0I5S2jF03sy9lPcw/i3/nWjEdIqiAknn8+wroLvi7lzM9y
	 o8Desytva8V2McqchZjCpPeYgYxJrInI3M98eBDrL5BVSnlWL05knCW0ijbnGQANMiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b="a/jv6JjF";
	arc=none smtp.remote-ip=95.215.58.56
Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81635606A331
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 03:03:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81635606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=a/jv6JjF
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qu6++vYIG27+XtXchHhIRccwrxsnE0Ys6DdfwHscTJ8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793675019; v=1; x=1794279819;
 b=a/jv6JjFukP7pl6VNlRqNcL5fHWh2BOfA9mc2iWj2mylJcEKpUpQPr0aFGKCvc9/A0i8YuEl
 Nw+7TsiuNVeFzugSrOyRT4Ljc6GtUpYmnmsoRrOxyzwh0XaVQfi4Pd4ZD64DveTdiTD0u6x60HP
 HIEXa5WeQTuhVTuRpbb2MhAT76fGcYzsQbvUU2ap7RckBmGeyo4+FBsmqvVTKyK0MyRsgtJSmov
 cbAGG8N4A07sKn798gP/IkajYircvfYhducnPf6v+E6O5BstQWWdAiApwZO0f30DMF490WZoE2T
 gkYWytPF+eTbzPandJ1TAnBOd+EWnrQtSA77htXvzNa5A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d880b7f20f2040cd;
	Tue, 03 Nov 2026 03:03:38 +0000
X-Mizu-Trace-ID: d880b7f20f2040cd
X-Migadu-Flow: FLOW_OUT
Message-ID: <c02b4586-522d-49bb-87d6-69277b45add3@chenxiaosong.com>
Date: Tue, 3 Nov 2026 11:03:31 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: require NUL-terminated EA names
To: Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Steve French <stfrench@microsoft.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 linux-kernel@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>
References: <179367391951.8187.2063761250230294066@stu.pku.edu.cn>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <179367391951.8187.2063761250230294066@stu.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Since Namjae provided some suggestions on v1, it would be better to add:

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>

On 11/3/26 10:45, Yifan Zhang wrote:
> smb2_set_ea() verifies that the byte reserved for the declared EA-name
> terminator lies inside the request, but it does not verify that the byte is
> zero. With SMB debug logging enabled, the name is passed to %s and the
> diagnostic reads beyond the request allocation.
> 
> KASAN reports:
> 
>    BUG: KASAN: slab-out-of-bounds in string
>    Read of size 1
>    string
>    vsnprintf
>    _printk
>    smb2_set_ea
>    smb2_set_info
> 
> Reject an EA entry whose declared terminator byte is nonzero. Return
> -EBADMSG for the malformed buffer, and map that error to
> STATUS_EA_LIST_INCONSISTENT for both SET_INFO and CREATE.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Yifan Zhang<yfzhang23@stu.pku.edu.cn>
> ---
> Changes in v2:
> - Return -EBADMSG for the malformed EA name terminator.
> - Map -EBADMSG to STATUS_EA_LIST_INCONSISTENT in SET_INFO and CREATE.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

