Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D6370AD4
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567982; cv=none; b=FkBWrYAuaXAJH4fXgmGBrobDctK3xXIbLBP2jvt8xYUffssRBkwul19vvK/ncRgrBlR1g2LkcM3Cdxv/DiWBcPUBTrGRpRyreUCDZPlef/xKHNOmRHr2k3rO7KC+TGcJUl1UparzOtQSteskkJWGKVy7wC1DjPHUApAnB73a4s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567982; c=relaxed/simple;
	bh=wM51+wm/Pnz7nLV8Cihn7FWZPN6PhJJq8Z6jf7Vo5p8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ugvEzScGjt3Q+H0XONTzC1UVen2ycPyyJjxrSIYc8S4PT95clUMIo1V77dsGowDdEtrtf9s5eVfLeZXzCcNA1tCMleBQWLAEeqRcuCXJMM/ErOii5/6fiug4fXJXR3ZSZ094Yvxuxfe+kHufBHQMTAO//9WH77BOmXg67kHqDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=he9t6w9M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="he9t6w9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784567978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S1rbuc0RIfMk2UFrtvYrUE/qnw8rbUlycERmTi9F9rw=;
	b=he9t6w9M/KBCUI1RYtpc/lXHYxJtFH+k9wg083RoSBtyrHyKO/2CSGLuVLH5w6XlEc84zD
	YeExNqkMDp6AY0Zl4eLrEa7npDYbHHxUUJgiUGDeKGlcGyavtB/c3pF19z7OrIFwyYIvq5
	C1GVx6QDkBw4bmNO0v7pA2hBxxGILUk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-U7-84CPQMSycVmmf7hrLXQ-1; Mon,
 20 Jul 2026 13:19:34 -0400
X-MC-Unique: U7-84CPQMSycVmmf7hrLXQ-1
X-Mimecast-MFC-AGG-ID: U7-84CPQMSycVmmf7hrLXQ_1784567974
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C42DE1806D32;
	Mon, 20 Jul 2026 17:19:33 +0000 (UTC)
Received: from [10.22.76.6] (unknown [10.22.76.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD8DE1955F78;
	Mon, 20 Jul 2026 17:19:32 +0000 (UTC)
Message-ID: <8e0060e7-8579-4ccb-a2e3-a4df93db07f3@redhat.com>
Date: Mon, 20 Jul 2026 12:19:30 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] cifs: fix attribute cache corruption from
 concurrent directory operations
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com
References: <20260720163541.1428872-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260720163541.1428872-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Sashiko doesn't appear very happy with either patch.  Looks like I'll 
need to rethink the approaches.

Frank


On 7/20/26 11:35 AM, Frank Sorenson wrote:
> This series fixes two distinct but related race conditions in the
> cifs/smb3 client where directory operations (lease breaks and readdir)
> can corrupt the attribute cache of recently modified files, causing
> subsequent stat() calls to return incorrect file sizes or fail with EIO.
>
> Both issues stem from the fundamental problem that directory-level
> metadata -- whether from a lease break notification or a readdir
> enumeration -- is not strictly synchronized with the authoritative state
> of open or recently closed files.
>
> Both bugs require as few as 2 concurrent threads performing directory
> and file operations simultaneously.  They only reproduce against Windows
> Server (where directory lease breaks occur and directory enumeration
> metadata lags behind file state); they do not reproduce against Samba.
> The workaround for both is to mount with actimeo=0, which forces every
> stat() to query the server directly rather than trusting the cache.
>
>
> Patch 1: cifs: serialize readdir with directory cache invalidation from lease breaks
> -------------------------------------------------------------------------------------
> When a directory lease break occurs while readdir is actively traversing
> the directory cache, the lease break handler calls cifs_revalidate_mapping()
> -> cifs_zap_mapping() while holding CIFS_INO_LOCK, racing with
> cifs_readdir() which traverses the same cache without that lock.  The
> resulting corruption causes subsequent stat() calls to return wrong file
> sizes or EIO errors.
>
> Fix: acquire CIFS_INO_LOCK at the start of cifs_readdir() so that lease
> break cache invalidation and readdir traversal are mutually exclusive.
>
>
> Patch 2: cifs: prevent readdir from changing file size due to stale directory metadata
> ---------------------------------------------------------------------------------------
> After writing to a file and closing it, concurrent readdir() can fetch
> stale directory metadata from the server (EndOfFile=0 for a recently
> written file) and overwrite the correct cached i_size.  The race window
> is between cifsFileInfo_put() removing the handle from openFileList
> (after which is_inode_writable() returns false) and stat() being called.
> The existing is_size_safe_to_change() check only blocks this when an
> active RW lease was held -- not after the last writable handle is closed.
>
> Fix: track the time of the last writable close or truncate in a new
> cifsInodeInfo->time_last_write field.  If readdir attempts to change
> i_size within acregmax jiffies of that timestamp, the update is
> suppressed.  When the suppressed size differs from the cached value,
> cifs_i->time is set to zero, forcing the next stat() to issue a fresh
> QUERY_INFO RPC.  QUERY_INFO returns the authoritative size from the
> server's open-file table rather than stale directory enumeration metadata,
> which is the same path taken by actimeo=0.
>
>
> Testing
> -------
> Both bugs reproduce against Windows Server 2022 with SMB 3.1.1 and
> at least 2 concurrent threads.  A reproducer program exercising
> concurrent rename+readdir (bug 1) and write+close+stat with concurrent
> readdir (bug 2) was run for 400000 iterations with both patches applied
> without hitting either bug.
>
> A reproducer is available at https://github.com/fsorenson/cifs_cache_race_repro/
>
>
> v2: fix malformed patch 2
>
>
> Frank Sorenson (2):
>    cifs: serialize readdir with directory cache invalidation from lease breaks
>    cifs: prevent readdir from changing file size due to stale directory metadata
>
>   fs/smb/client/cifsfs.c   |  1 +
>   fs/smb/client/cifsglob.h |  1 +
>   fs/smb/client/cifsproto.h |  1 +
>   fs/smb/client/file.c     | 24 +++++++++++++++++++++---
>   fs/smb/client/inode.c    |  6 +++++-
>   fs/smb/client/readdir.c  | 12 ++++++++++++
>   6 files changed, 45 insertions(+), 4 deletions(-)
>
> --
> 2.55.0

