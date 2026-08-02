Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ED230C60F;
	Sun,  2 Aug 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785681891; cv=none; b=LNGAFLgFcrXJaaI4kNYLGxe9Ld7slkXKV90hgrdSau9OTUBe6WNBaZxPCS4hLBc/DKwXvpMcg7GePAweYDrYSdR3ymvgN7vbNApyHET1XT/BbaBdN6FZ7UFNR4Cd4Xi1ayyFZBT32XDPApoypzF8gcLm/BQpHmtfHDakQAHxaXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785681891; c=relaxed/simple;
	bh=Pcdr397DQuTSOmKtag+6stPaPaf49AANhGHQlr4atAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jychL8QrXCv5BOpXrSxc9JfC3HAStpMLMvE9hWX4FutsqVj7Vj6TG2dprmNntBLdFGmRO9wQSilsj9w5mU8aB3BbQtWWcqvx7kVUkVOW4Wg8EuYDpbnNQF4qEvq3ejvgUGxqIKqZ4ZPjXl7KQKT1mARia/3IDKnfHZuHw115OBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a6f445868e8011f1aa26b74ffac11d73-20260802
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6bd9da42-8300-45d6-bb0d-be200a160b9f,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:6bd9da42-8300-45d6-bb0d-be200a160b9f,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:272eee8ba53b84dd20b264b0329ecb76,BulkI
	D:260801063744FUKH45WJ,BulkQuantity:2,Recheck:0,SF:10|64|66|78|80|81|82|83
	|101|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:ni
	l,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a6f445868e8011f1aa26b74ffac11d73-20260802
X-User: hehuiwen@kylinos.cn
Received: from [192.168.0.11] [(220.202.211.78)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2048491215; Sun, 02 Aug 2026 22:44:23 +0800
Message-ID: <ab250727-5a0b-431c-b1f1-96837155dda4@kylinos.cn>
Date: Sun, 2 Aug 2026 22:44:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] cifs: use cifs_invalidate_cache() in
 cifs_do_truncate() for O_TRUNC
To: sorenson@redhat.com, David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com,
 stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
References: <20260731153500.660569-2-sorenson@redhat.com>
 <20260731153500.660569-1-sorenson@redhat.com>
 <2259642.1785537449@warthog.procyon.org.uk>
 <a7724609-20ab-49b0-aef8-4d7673f0d308@redhat.com>
Content-Language: en-US
From: Huiwen He <hehuiwen@kylinos.cn>
In-Reply-To: <a7724609-20ab-49b0-aef8-4d7673f0d308@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

LGTM. This is safe with or without the inode lock. The pre-existing 
O_TRUNC locking issue can be addressed separately.

Huiwen
在 2026/8/2 19:56, Frank Sorenson 写道:
> 
> On 7/31/26 5:37 PM, David Howells wrote:
>> Frank Sorenson <sorenson@redhat.com> wrote:
>>
>>> cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
>>> cannot use cifs_resize_file_locked() to perform a proper fscache cookie
>>> resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().
>>>
>>> cifs_invalidate_cache() calls fscache_invalidate(), which works without
>>> holding i_rwsem: it unconditionally increments inval_counter and sets
>>> FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
>>> served once the cookie is later activated by fscache_use_cookie().
>>> Truncation to zero leaves no valid cached data, making invalidation the
>>> correct semantic here.
>> What happens if there's a concurrent read or write in another thread?
>> truncate(), buffered read/write and direct read/write() will play 
>> reasonably
>> with each other through a combination of i_rwsem and the stuff in
>> fs/netfs/locking.c.
>>
>> But apart from that, I think that invalidating the cache should work.  
>> It may
>> be slower, but since you're getting rid of all the data anyway...
>>
>> David
> 
> The lockless call is pre-existing; this patch just adds the 
> fscache_invalidate on top of it and doesn't worsen it, since it's safe 
> to call without i_rwsem.  Fixing the concurrent I/O issue properly is 
> out of scope for this series.
> 
> 
> Frank
> 

