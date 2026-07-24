Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD92D3A93
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900138; cv=none; b=Hpz77NGEim4ee4VkDzFNlbQjjf18DF+J+NrgrMteyRk8G8VpalZOxzBTNU1atXzusBP3Byq3uEbW214lxpSi9lXy6Dw6oOPrHOgbi9gYO19FrDveB+fEjUL+xJHfKh+P4srOfAz8GfJ/bfcJ4SHSI4X4Y6yNThhWp9KQEAvXXD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900138; c=relaxed/simple;
	bh=+fPu8vElWnLdmTpjMOkPrYtwDN12zu1lh22vzM7u9uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0Glbm+4kLzbIMDGwI52cKFnfbnnO4fX8KXxIBrgt5TD1RRJ66RTd4UGOXwcpks13GRduKaQ6FqGkh1jKV7MHihT+h+fQ9ahO+B6FFg8X+KsXiRoZ3vOQWwQM3vvgJEwle04mnLRVem2aOnOndCXbf9y0u7NBxu49XFE38J0hyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RnbN39io; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RnbN39io"
Message-ID: <2f4e2edf-5aa5-447b-89b9-09d1b19ce14e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784900131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVqNzyLmES05l/0J4S3kCsg10AtQ6RGQtuU+KVaQOZ8=;
	b=RnbN39ioR4pPEmw9gsNPABvQWhjXTaZi5qhSAOWXKAuIPmTAJO1bx4YUjjXk+XAogOIvZE
	J6IZ96b+P4Y8O1fxxDJULTGgqd8Xxa7WhPDULfAdrn8fpE0+MR9bTE831MOOvKOTO3Xo13
	6qqWgusw+HK1meQknh5VtcJQLfI8+BAMdlJ8qtormRzPw7uyDj4BTgfMe8Q315h0O9icIA
	i4IT6aZ8tEyKDzhGOf5BxpnQn7C+1gpmZj9gmsxBt80LPQf0VBDWZ3tLb7TEofgQAH9tuL
	xZ1+bwhIIlOBrbIL7CN2WMMJzL1FvCMIEW0L9bmpyee03TtbXQyXvEFv/lOB9w==
Date: Fri, 24 Jul 2026 21:35:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 00/11] smb/server: change notify support
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Do you have any suggestions for this patchset? I plan to send the 
non-RFC version in the next few days.

On 7/23/26 15:20, Namjae Jeon wrote:
> He needs to submit a patch aligned with the current base. We can't
> just wait since we don't know when Gaël will send the patch.

On 7/23/26 11:16, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Sorry for taking such a long time to complete the ksmbd change notify feature.
> Over the past few months, I have been busy with the birth of my daughter and
> my PhD-related tasks, which left me with limited time to work on it.
> 
> Once Gaël updates his patch ("ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED"),
> I will rebase my patchset on top of it.
> 
> To test this feature, the following patches need to be applied to cifs-utils and kernel smb client:
>    - cifs-utils: https://chenxiaosong.com/lkml/cifs-utils-parse-notify
>    - kernel smb client: https://chenxiaosong.com/lkml/cifs-improve-notify
> 
> The complete kernel client and server patches are also available at the following link:
> https://chenxiaosong.com/repo/linux/ksmbd-change-notify
> 
> ChenXiaoSong (11):
>    smb/server: add debug type for change notify
>    smb/server: validate notify requests
>    smb/server: support canceling notify requests
>    smb/server: watch directories for changes
>    smb/server: keep notify watches on file handles
>    smb/server: save simple notify events
>    smb/server: save old names for rename notify events
>    smb/server: match rename notify events
>    smb/server: encode notify events
>    smb/server: send notify events to the client
>    smb/server: break directory leases before sending notify events
> 
>   fs/smb/server/Kconfig     |    1 +
>   fs/smb/server/Makefile    |    2 +-
>   fs/smb/server/glob.h      |    3 +-
>   fs/smb/server/notify.c    | 1011 +++++++++++++++++++++++++++++++++++++
>   fs/smb/server/notify.h    |   24 +
>   fs/smb/server/oplock.c    |   40 ++
>   fs/smb/server/oplock.h    |    1 +
>   fs/smb/server/server.c    |    2 +-
>   fs/smb/server/smb2pdu.c   |   12 +-
>   fs/smb/server/vfs_cache.c |    3 +
>   fs/smb/server/vfs_cache.h |    4 +
>   11 files changed, 1095 insertions(+), 8 deletions(-)
>   create mode 100644 fs/smb/server/notify.c
>   create mode 100644 fs/smb/server/notify.h
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

