Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88152931CC
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403827; cv=none; b=M1YId9myzGXFJHTQxfSS9bcOU+sZQHAVs4glVNP2P6R1wH0d5KrzJJPS1PZAheF6daEeCFlKUm2Ad+bFAr8k6GUs4GlvPIBbkaXbve1BZMDi38/pdQ/CU0yd9HXKVToJTThoRC8VUIDirGbiWEfcC7703BHERO2D5wcwLS9BTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403827; c=relaxed/simple;
	bh=6y02Jko5gTIptTJkcEFy7RR6RB037h1n/Y8oC4tDeJ0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QrcMrWd2sUVFuQ0fydTv68g/2zn2u3Z1yoBDjXSJBlfa/YT5A4nG16GbpAvHQwGne8NIm1KxT0QWLIrIIpqB6q7hH3d6pLGaaCGxVvRFPct68k6UrHSjLKCneRxoeA3NILPSc4ITA56MQ5VXe4q6gv21ZBhvINiemIQ//zHihkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=8e4T1VRi; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="8e4T1VRi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jdngDsWNTBRD96PCXFxe5UrM/Mn7eVBAAKpiQuPznG8=; b=8e4T1VRijoHgrK42JLr1f6BTsb
	Rcb35RdJV3VmVoc5deD+rkAQLM+4jr4/8AgHebMzRqoBLsKEEMyuLO2K14z3f/+UgysYhPSz9+E/Q
	QHDcEDZXx5l8r0LU8XDVQRTn99AllsIGXyo0PFHTFeIV5HmbbGdPaMQ8/YnHxBCphUtVtIVLVx5AS
	gXEDAJz6V5d89kLm7y0bc1D1RagvA2J/t2BTmb6sWHHD0DVAp3rD4ZfCfWB3HTJL3XiBgEkOmMQ2B
	sNIJe0fLi0subEYB+rmiCBnKb0m86k2Zvl8z6kyXhKxQ9aRZkvctBRcL4cLyTTeZeyEbkOtnYnn/A
	tHqd6q7g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x69fu-00000001PSH-3ktw;
	Mon, 14 Sep 2026 13:36:58 -0300
Message-ID: <6ae6d40538ef67b3a613f983d98ac56d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg
 <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey
 <tom@talpey.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix use-after-free of iface in
 cifs_try_adding_channels()
In-Reply-To: <20260901010413.368183-1-joseph.qi@linux.alibaba.com>
References: <20260901010413.368183-1-joseph.qi@linux.alibaba.com>
Date: Mon, 14 Sep 2026 13:36:58 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Joseph Qi <joseph.qi@linux.alibaba.com> writes:

> cifs_try_adding_channels() iterates ses->iface_list with
> list_for_each_entry_safe_from(), which captures the next entry
> (niface) under iface_lock.  The loop body then drops iface_lock for
> the whole duration of cifs_ses_add_channel().
>
> A concurrent interface refresh (SMB3_request_interfaces() ->
> parse_server_interfaces()) marks all ifaces inactive and removes and
> frees any that are not re-advertised via list_del() + kref_put(),
> where release_iface() is a bare kfree().  Since niface typically has
> no channel holding a reference, the list reference is its last and it
> can be freed inside the unlocked window.  On continue, the iterator
> advance step then dereferences niface->iface_head.next, and the loop
> body reads iface->rdma_capable/is_active, both on freed memory.
>
> Fix this by never keeping an unreferenced list pointer across the
> unlocked window.  Each channel attempt now re-scans the list from the
> head under iface_lock, takes a kref on the selected candidate, and
> passes only that referenced candidate to cifs_ses_add_channel().
> weight_fulfilled still tracks selection progress, so restarting the
> scan preserves the original weighted distribution and the
> weight_fulfilled-before-kref_put ordering on the failure path.
>
> Add a per-pass attempts cap so a flapping interface refresh cannot
> keep the inner loop spinning within a single tries increment.
> ...

Applied.
