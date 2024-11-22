Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F67082F
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 02:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732241166; cv=fail; b=HpR4FPDN1hI1UyhxLxJwJgF+UzeG2A6hxHACJc6tQ3KJ/nUruy1jf1JRqf6ioCx52rdyqdzvD7b+ugPUQMxLimduyU7SrsE5CYcb0mfbEr4QO0qV4oaZeh/f7xUGse8UFhxMaB0c0uHu6AqZUnq8+c6JbcHj4Q2DOTDhVu3wAMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732241166; c=relaxed/simple;
	bh=7CodY4bt+MqwW1LbjN5bwZUdHp3KYuM72ja2TK4e/GU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=QBLZtGwDDc0hDTe+ljX4ZhfgZ9WoJhjKXFsBUfbSqlgDzyDmT2tCNhMEhwsSbcLRynFiJ/ytVTt+lWWWbmqSNIZmTTozveV4fSyD6LJzVlf7I2Q6BPkLS7Gru0ghpIiH9X1hQF5HLBwHmpRx8oIrUa/T2iojGGXv4up5/244yqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=dbU7wOr9; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="dbU7wOr9"
Message-ID: <2a818d91e9f3c392b2739a4c2a018085@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732241155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0n2d7GX/Zcabij+uGj6W6f8qQlSC0BPL3/FBID84Qdo=;
	b=dbU7wOr9WirIAxZ/xmTXSoBorT5g0OML4P6Ol2DwI+u+j2FsDW9VwGS8A5J5U6Aai6WTnn
	8Rp6kCJcZFTOGA4vIB1vOC0Ss3qDO1sLd8BQYnM4Bm2a3d+Iv5zShIGgNe4G9Kf1fDL3d0
	av0c8JNjb9Hjic2R+/hKJKJWVtpI35yBeA2HgS5+nRUq7P+2WRI++jKlAjKI4YZqyO305X
	S6SwmPeLpDYV2NgUG4oFlU3W48dUE0kRJDRwUCeRIxeFxTpyBDCCpJ0Dr7Vij45x8Es39E
	eZbUOGKGSDyDMGcV49gDbu50N88gO3AGipGIhaWfxV7aNX+tOaiuD3+I2JC6Lg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1732241155; a=rsa-sha256;
	cv=none;
	b=jDCQvTTWyfFeIASByC3R2YjzgsFn9EsGWGncbe7uLhdY9NnFCV26G4H2tfGHKFn6k4RUQX
	Rd5kET+CBopr7urXcKYmCS7Qw9AC0qtj54vUPL9jCeL87s5qf+rOVU4JIxpsEk5a/Vl4Dp
	hm9opA982Ox3lwq4b9ul4l1BQ0u/NpCrNh4CMmD6TsmWBpg2Co3mzquoyFFTxGlTtRtErW
	9fATbzMioRNCiQAjjSOTfm1ZgM2yWjeIEEPTVJNChHL9KhtC6/bpS4fVGwxirUiLdSE3Oy
	HJDU+vuJPLR0jOzJnZ4HW93w7a9uxQFUPyu6PvPWKfwWJ3TGJAkbYAUcBISOnQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732241155; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0n2d7GX/Zcabij+uGj6W6f8qQlSC0BPL3/FBID84Qdo=;
	b=Y9YK9Q/PhDof5zK6NjbjtJCrzMtRS6OQ5PeZLrdYNWfQy9uYVFLNe74vAHHVrz7Kjb8EcA
	Q2x6z+ICuCgtZILdmb5/m2q5lMrYqoYN68D4aKUuwyRPqhAqRkt0dPjVfVZkPZflt2Z3Qj
	5ZXI9h9Hg09rLPFlCLKiOqFCtvWTJZy4h/37fQYYc3M5Mgd8AIRqFOxk8XSdT0yp6AxXU7
	O2kR05UoMTsgzLfIDDRnsfkoXvKz3Cq1AeUi/P3H7aSWmpjHuyDoYUexygm83jQCkpLg/F
	ZDnZPYF4TZ+z4Ka5XrbqCDM+W5uliI2bg7miAs34+Y1M8ah15cPncKDrB+5EfQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org, Steve
 French <sfrench@samba.org>
Cc: paul@darkrain42.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
In-Reply-To: <20241118215028.1066662-5-paul@darkrain42.org>
References: <20241118215028.1066662-1-paul@darkrain42.org>
 <20241118215028.1066662-5-paul@darkrain42.org>
Date: Thu, 21 Nov 2024 23:05:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Paul,

Thanks for looking into this!  Really appreciate it.

Paul Aurich <paul@darkrain42.org> writes:

> The unmount process (cifs_kill_sb() calling close_all_cached_dirs()) can
> race with various cached directory operations, which ultimately results
> in dentries not being dropped and these kernel BUGs:
>
> BUG: Dentry ffff88814f37e358{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
> VFS: Busy inodes after unmount of cifs (cifs)
> ------------[ cut here ]------------
> kernel BUG at fs/super.c:661!
>
> This happens when a cfid is in the process of being cleaned up when, and
> has been removed from the cfids->entries list, including:
>
> - Receiving a lease break from the server
> - Server reconnection triggers invalidate_all_cached_dirs(), which
>   removes all the cfids from the list
> - The laundromat thread decides to expire an old cfid.
>
> To solve these problems, dropping the dentry is done in queued work done
> in a newly-added cfid_put_wq workqueue, and close_all_cached_dirs()
> flushes that workqueue after it drops all the dentries of which it's
> aware. This is a global workqueue (rather than scoped to a mount), but
> the queued work is minimal.

Why does it need to be a global workqueue?  Can't you make it per tcon?

> The final cleanup work for cleaning up a cfid is performed via work
> queued in the serverclose_wq workqueue; this is done separate from
> dropping the dentries so that close_all_cached_dirs() doesn't block on
> any server operations.
>
> Both of these queued works expect to invoked with a cfid reference and
> a tcon reference to avoid those objects from being freed while the work
> is ongoing.

Why do you need to take a tcon reference?  Can't you drop the dentries
when tearing down tcon in cifs_put_tcon()?  No concurrent mounts would
be able to access or free it.

After running xfstests I've seen a leaked tcon in
/proc/fs/cifs/DebugData with no CIFS superblocks, which might be related
to this.

Could you please check if there is any leaked connection in
/proc/fs/cifs/DebugData after running your tests?
