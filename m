Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196740;
	b=UjX+IAAv6YzOFDJJc7AbWRg5VqXADMzOr9gIEvYcsasPsIaL0R1OsLHyoJyhyfov2hgR
	 19GPjXAbR7+hu+GOm4xph1Geg/7e/BEiYacfcAr1o/OeryF6Cg8euXyF/wvKFos1XZ+FE
	 MlW/u5CNCrwUqCycvzVxSZxn+BdtaEiIc4Jxav12hYXJgILhwgeH+nOkeDMEUpYQpqHlR
	 s7TMUEoWus0XVngBusyHa+jcN2Afs/AXmpiWYWhFFnhqzCG1E/E2+n8oqPTqfyrZ/vDkI
	 NM+f6MBqpJfVhqLnvvl+6zv/h0ZdSh7ejxR7NIL7tzcaa9Yv6RgFVfvrqABqOFVqhQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196740;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mNKWKeQaizgMT/LZrjHv0QI/kJLBxPj3nyrlUjJt+Rw=;
	b=UVMy3qqPWe3xtjMx/f0192WClqj/v6QI1QQJnYIuZKIjS03eiFpCoRDk9dcVcAXC5VQA
	 /IvolLRKS0GuMYiCPAUWEXr+lOhdFd17SdLFYo8gy/DR7i6wy9bnhbfx+8yxzlhWDwTDK
	 vzVko1lI/ndujbeIVnwn8cfq68bjlC0AoHEhcEzK81r2XPrH8p6w/FVUK3UT5VexfbQSV
	 CCTBKPDKECaSR0Kp+V7TBTXNyLFyNyvtga46hmb7pcnEFjJ5HQalEpVC1K/JkJ7TtQpg9
	 23piT8xUiUxVC0qaGdTJv8a0MZvdLWEN9jZE2W9Ov0DIiVHxMwR0Pyq69acW8DZExiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yhXwaODF;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDD606A31C;
	Mon,  9 Nov 2026 03:58:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19EDD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yhXwaODF
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794196729; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mNKWKeQaizgMT/LZrjHv0QI/kJLBxPj3nyrlUjJt+Rw=;
	b=yhXwaODFp3EfLG9PrFG2Igm98j9S4+1rlJqaTrZTcU6Kl0XG1Rqr8W9At8JXhLqJmYvGbEtb+6NB8ltIWKFd1Tgoj1h9JUvQ8JU//6muix+/tq0IOjEDNXVA7M+abRr88tyuQIoknITTP6mykRaXKa5h3KMt7TjXyfyJpfhWcCw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XEITxm8_1794196727;
Received: from 30.221.146.205(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEITxm8_1794196727 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 11:58:48 +0800
Message-ID: <54a1224e-abc6-4042-8979-2c21441fb4ff@linux.alibaba.com>
Date: Mon, 9 Nov 2026 11:58:47 +0800
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
Subject: Re: [PATCH 1/2] smb: client: hold server ref while queueing reconnect
 work
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
 <7e2543c16b6b75edb8c55b138175dcd8@manguebit.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <7e2543c16b6b75edb8c55b138175dcd8@manguebit.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Paulo,

Thanks for reviewing it.

On 11/8/26 1:28 AM, Paulo Alcantara wrote:
> Joseph Qi <joseph.qi@linux.alibaba.com> writes:
> 
>> When query_server_interfaces() returns -EOPNOTSUPP on a secondary
>> channel, smb2_reconnect() calls smb3_update_ses_channels() which for a
>> channel runs cifs_chan_skip_or_disable().  That clears the channel's
>> slot in the session and calls cifs_put_tcp_session(), which can drop
>> the last reference of the channel and tear it down.
>>
>> smb2_reconnect() then falls through to skip_add_channels and queues
>> reconnect work on that server, using a server that may already be
>> freed.  The send path obtained the channel from cifs_pick_channel(),
>> which does not take a reference, so the session's channel reference is
>> the only one.
>>
>> Take our own reference on the channel before calling
>> smb3_update_ses_channels() and drop it after the reconnect work has
>> been queued, so the channel cannot be freed while it is still used.
>>
>> Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> Please check sashiko comments
> 
>         https://sashiko.dev/#/patchset/20261103091558.2342761-1-joseph.qi%40linux.alibaba.com

These points are about the multichannel disable path as a whole rather
than about this change, so let me try to answer them together.

What this patch does is narrow.  It holds a reference on the channel
across smb3_update_ses_channels() so that the final cifs_put_tcp_session()
runs after cifs_queue_server_reconn() instead of before it.  Previously
the last reference was dropped inside cifs_chan_skip_or_disable(), which
cancelled server->reconnect, and skip_add_channels then re-armed it on a
server whose srv_count was already zero.

Queueing reconnect work on a just-terminated channel is indeed
pointless, but that comes from f591062bdbf4 ("cifs: handle servers that
still advertise multichannel after disabling"), which added the goto
skip_add_channels into a label that already ended with
mod_delayed_work(cifsiod_wq, &server->reconnect, 0).  With the reference
held, the work is either cancelled by the final put or runs and bails on
server->terminate in smb2_reconnect_server(), before it reaches
smb2_reconnect() and ses->session_mutex.  The send path holds no locks
there, so neither ordering can deadlock.

The srv_count == 0 race is reachable, and smb3_reconfigure() is the
clearer path into cifs_decrease_secondary_channels().  But it is older
than this patch and I don't think it can be closed here.
cifs_pick_channel() returns a channel without a reference, so once
srv_count can drop to zero under us the pointer is already stale on
entry to smb2_reconnect().  Reading server->srv_count to decide whether
to take a reference would itself be the use-after-free.

The guarded increment is the same idiom smb2_reconnect_server() already
uses, and it narrows that window rather than widening it.  Refcounting
the channel selection looks like the real fix, which is a much larger
change.  There is at least no double put, since cifs_ses_get_chan_index()
returns CIFS_INVAL_CHAN_INDEX once terminate is set and
cifs_chan_skip_or_disable() then returns -EHOSTDOWN without putting
again.

So what's your opinion?

Thanks,
Joseph

