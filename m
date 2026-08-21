Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036933749FA;
	Fri, 21 Aug 2026 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787332741; cv=none; b=FTEvS/Wa84IdMGXJ2J/yt2aU4j3cR0IikYSoyWxjrQcFOOx1rllcZyO4i7bb8v5RP/aVORWsBbw+Q3GEFGmPfQjxuiNhrtebVqWw4hxQeCs76mRyNfk9d1fL25iTa9aoS8HqHyKJEPgyH+H2pE6QKZa4ZJNoxnjgotXqxjNEXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787332741; c=relaxed/simple;
	bh=NYe7nukoaAeZoWwuB6GedpvVD/uZ5GT1Cgs/vb20VzM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=arjenCE+ERupZEhv7slcoMk6LfyO7BVA3Qz9MHnS6dAxmf0QAB8RFriDhKU1/v3bwpIEqq36pFkh8wusYwvbl+hGKvhyPHUD8QcCAIp5vuNHHqJRDk4Q33gaguVElerOs6tWn1uf0C6xAooLX5EfWkjoIJod4el2QPdt1jbEdl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=bPX7Txm+; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="bPX7Txm+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eGFEiYEVjkcCzgDW1sDcNJoasexjmVTJtd81q0MQQhI=; b=bPX7Txm+aEXVSbJoZKzjQba2XG
	9YS/Y0rDUhBbcKT7T1doyGbOzeyI+iecGVyiKU3KGh094SRLP6IdW/bVIUZi+zvAg92pm6zhyv0GP
	P3HBhks11I2VpufWiGMErvvmSU2Tl27dQ2DOPHsmsXlrMilNdKUZA4MZPdiOW//gSzZqcZ6dXXapw
	g5PuxS92tOYKAvQ+Eel4gCBYp8VA8nQu47TjLyI3TiB1IqTt9oJ0/OtjQR+m38BKbE4RvuL1ZyEv2
	QkJdM7SLmJ+l80Vb1t1xIXTzQWGiyQspYdOe/Aq7Ki18+5JtYSdnkrCiwEFbowhIk/9oN7uh47FkL
	pH3bTrdw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxStJ-00000000PlG-3uIC;
	Fri, 21 Aug 2026 14:18:53 -0300
Message-ID: <6e9aa19ba351b8c7f4df2992342a75da@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Steve French
 <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-mm@kvack.org, "Christian Brauner
 (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 4/4] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
In-Reply-To: <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
 <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
Date: Fri, 21 Aug 2026 14:18:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Christian Brauner <brauner@kernel.org> writes:

> smb_send_kvec() blocks every signal during a send:
>
> 	sigfillset(&mask);
> 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
>
> An incomplete or partial sent would cause the connection to become out
> of sync. That in turn would cause the session to be torn down and
> reconnected.
>
> In 00be6f26a2a7 ("smb: client: transport: avoid reconnects triggered
> by pending task work") smb hand-rolled its own solution. Have it use the
> new no_notify_signal_save() critical section instead.
>
> This stops io_uring from cancelling a send in flight but that's just
> like it is today and it is bounded by sk_sndtimeo at around 15s.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Paulo Alcantara <pc@manguebit.org>
