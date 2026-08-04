Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB63AEB39
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837724; cv=none; b=GDo3O6stJurKeYvHdtpQD5rofCJsR+oCJJE8YMzJR/cc5F54kGqJatI/KLXoe8hZHfSRBSxNKNgNs1SSBeXW6hj8rBWlaTimNsyU5Fp02dAx623h1CfMpaYsTghzJuKXfyAtDKdd3MsjMe0/5W1Bbkn3umNnhJWBSV8h4tF7BkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837724; c=relaxed/simple;
	bh=TX6uhwwQkeikuVG8FiFn+Ptm0boyjGFqcJfTfnV6Clk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eR0uiIRKbS+ZeQ2bsBodYwMV9iUlEEo0ehZUNQypom31ED6vpWZU6EokklC60pbPT8XrGFxRryRpPGy32ezpMwyRMUy2jUCNNrn082qcrE9115vgN5kkuXDe4NKp+ck26IvUlsG4wY7Emlquf5GzZzRkJZX3T9ctHQW0ptW6SBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=XgBSPvEj; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="XgBSPvEj"
Message-ID: <8216197a-9265-487b-b2f7-be9548d4f497@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785837717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qaHkidke+4C9kmHksLQFwkbFvAsunX2TY9Pu/4EBkE=;
	b=XgBSPvEjLIceAKlLEEgNqgSwt9cHqVy/z3p539bOsphistFAIaQVRHk6WParFBHnn6tptW
	3U91aYHgzJ+0VonSECS3+Zd/WHoCYgCwH6gwbTZt7cpfi2jaGEQsH9H+4qa8xnQGUGqKp3
	Oivz+9IiRgeuNzXv2u6X83d6bI8vMPxeGHHqorPbYdTf6OVa4fcsxgzKEl3rIapFSekJ3t
	0RxFz4crYvuSCOjJXzLc7UjquADz0WWcuJJPv8Txup7n+orTJlWdCD2qfR+d/BzGF7DbyH
	ASLMCsa0oDjaQFR9zQkkxpg4CEc2ct8pupJxe4xEoR2kjTE5bMt7CD7WITTM+Q==
Date: Tue, 4 Aug 2026 18:01:53 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
 <0b0ea9a9-8784-400b-bbf6-efbbb8869dc4@samba.org>
 <4e7ac5e3-3116-4828-89c4-8e866dd267d1@chenxiaosong.com>
 <a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Should we add these rules to POSIX-FSA?

在 2026/8/4 17:50, Ralph Boehme 写道:
> hm, it seems this one is indeed missing. Good catch, thanks!
> 
> The behaviour should be:
> 
> - if there are one or more non-POSIX opens on the destination, MUST fail 
> with STATUS_ACCESS_DENIED
> - if there are only POSIX opens, the operation can proceed

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

