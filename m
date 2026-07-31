Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D733783C5
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 20:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785529761; cv=none; b=Xgsu6CgVAidKG11xhWy4KXqnDd35C89k4vTjeZ8561w4j8hBO0XpQzXOyOhS9Of7rHrQWpOPp4QwYmGQNcAGlubCgn5yOc/m7urypBaE1Dse21smpgQzCK4JDlyIZnGWPON7y1RyMTIqqnWA9KAc4AwvHyLhdtmUpeY/26yGQmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785529761; c=relaxed/simple;
	bh=TTr3Lt6McnPh8157OGqGv5Nr8SVlcuT8S3IffbVeaU8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=rnX7N3KMhBktEpJ7cuEL6w+lWja4UcIeEtxpwX9EqPkXBNpM5hVnhy7PouBhs+MxU3P7QFeF03+yAPNpDWNgrrANeFpf9KxgudathjOIR/t6/cKevfdWwSMYsglx2L1VCsbYUOHL+WY4VeRtmEWRxUCHLdGWsT1ly54C+KnZjQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ar8/R0cH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ar8/R0cH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785529758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asnlb/PqYZQxzC1g9OfpZ+tniukUbswsDNlRb5ALWrc=;
	b=Ar8/R0cHQoXL1N92IYLInvahQOQTL2ETk/0F3H9BtpBwwETdW289R5kkJPhm3l+QS/rmlk
	P0kI3MyXQ6RvXTH+FEmd8u3b9E/Y+GROxc18TTeH7R++TD6F4BTbDdRYrC9unT8W+VM59Q
	5GwV+oSmJgJ5quGfW+akfQlvA6oGwrw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-3_WlpptWMhaN9Tj1X_2n1g-1; Fri,
 31 Jul 2026 16:29:14 -0400
X-MC-Unique: 3_WlpptWMhaN9Tj1X_2n1g-1
X-Mimecast-MFC-AGG-ID: 3_WlpptWMhaN9Tj1X_2n1g_1785529753
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF29B180047F;
	Fri, 31 Jul 2026 20:29:12 +0000 (UTC)
Received: from [10.22.76.7] (unknown [10.22.76.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3161618004AD;
	Fri, 31 Jul 2026 20:29:11 +0000 (UTC)
Message-ID: <eb5b9a92-7cd5-4d7d-aca9-59dfc859f038@redhat.com>
Date: Fri, 31 Jul 2026 15:29:08 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] cifs: follow-on fixes after
 fscache_resize_cookie() consolidation
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com,
 hehuiwen@kylinos.cn
References: <20260731171231.686427-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260731171231.686427-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Reading through the Sashiko findings for this 
https://sashiko.dev/#/patchset/20260731171231.686427-1-sorenson%40redhat.com

These are all pre-existing, and not introduced by this patchset. I have 
fixes for several of them prepared:

* cifs_setsize() calls truncate_pagecache() without i_rwsem 
from cifs_do_truncate()

   Real, pre-existing. cifs_do_truncate() has always been called from 
cifs_open() without the lock.  This would likely require significant 
work to fix.


* Local inode truncated to 0 before network open; no rollback on network 
failure

   Real, but pre-existing and unrelated; I have a patch that fixes 
exactly this.


* len underflow in cifs_remap_file_range() when off > i_size

   Real, but pre-existing, unrelated to any of these hunks.


* smb2_duplicate_extents() leaves file extended if FSCTL fails

   Real, but pre-existing; I have a patch that fixes exactly this


* pagecache_isize_extended() missing in cifs_setsize()

   Real, but pre-existing; I have a patch that fixes exactly this


* Use-after-free in cifs_file_set_size() after cifsFileInfo_put()
   This is real, but it's pre-existing and unrelated to this patchset.  
That said, I have a patch for exactly this.

Frank


On 7/31/26 12:12 PM, Frank Sorenson wrote:
> After commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
> cifs_setsize()") consolidated fscache cookie resizing into cifs_setsize(),
> two further fixes are needed and two dead-code blocks became removable.
>
> Patch 1 fixes cifs_do_truncate() (O_TRUNC via cifs_open()).  That path
> runs without i_rwsem, so it cannot use the locked resize path.
> cifs_invalidate_cache() is the correct alternative: it works without the
> lock and ensures stale cached data is not served once the cookie is later
> activated.
>
> Patch 2 addresses a race identified during review: cifs_setsize() calls
> fscache_resize_cookie() without i_rwsem, but another concurrent open may
> already have the cookie active (IS_CACHING set), making fscache_resize_cookie()
> a real operation requiring the lock.  The fix strips fscache_resize_cookie()
> from cifs_setsize() and introduces cifs_resize_file_locked(), which
> temporarily activates the cookie with fscache_use_cookie(), performs the
> resize under i_rwsem, then deactivates it.  Callers that already hold
> i_rwsem (cifs_file_set_size, smb2_duplicate_extents, smb3_simple_falloc)
> switch to the wrapper; cifs_do_truncate() continues to use cifs_setsize()
> followed by cifs_invalidate_cache() as established in patch 1.
>
> Patches 3 and 4 remove dead code.  Patch 3 removes a caller-side
> truncate_setsize() + fscache_resize_cookie() block from
> cifs_remap_file_range() that became redundant once smb2_duplicate_extents()
> started performing the full size update via cifs_setsize() under the
> i_rwsem held by lock_two_nondirectories().  Patch 4 removes equivalent
> dead blocks from cifs_setattr_unix() and cifs_setattr_nounix(): since
> cifs_file_set_size() calls cifs_setsize() on success, i_size always equals
> attrs->ia_size on the success path, making the subsequent size-inequality
> blocks unreachable.
>
> v3: Fixed broken patch
> v2:
>    - Added patch 2 (cifs_resize_file_locked): based on review feedback
>      (Huiwen He) that the fscache cookie is not guaranteed to be quiescent
>      in cifs_do_truncate() - another concurrent open may already have it
>      active.  The fix strips fscache_resize_cookie() from cifs_setsize() and
>      adds a locked wrapper for callers that hold i_rwsem.
>    - Patch 1 commit message updated: the original rationale (cookie is
>      always quiescent in cifs_do_truncate) was incorrect; the correct reason
>      is that i_rwsem cannot be held in that path.
>    - Patches 2-3 from v1 renumbered to 3-4 to place fixes before cleanups.
>    - Patches 3-4: add Reviewed-by from Huiwen He; otherwise unchanged from v1.
>    - All patches: add Reviewed-by from Paulo Alcantara.
>
> Frank Sorenson (4):
>    cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
>    cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie()
>      under i_rwsem
>    cifs: remove redundant size-update block in cifs_remap_file_range()
>    cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
>
>   fs/smb/client/cifsfs.c  |  6 +-----
>   fs/smb/client/cifsfs.h  |  1 +
>   fs/smb/client/file.c    |  1 +
>   fs/smb/client/inode.c   | 41 ++++++++++++++++++++++-------------------
>   fs/smb/client/smb2ops.c |  9 +++------
>   5 files changed, 28 insertions(+), 30 deletions(-)
>

