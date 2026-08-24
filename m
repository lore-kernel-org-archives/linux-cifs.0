Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE62836EAB8
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787583824; cv=none; b=bpt/lU6hCpXzxbfDCuSYlbRZsUXxzxOlQGDMQH8+r5wU8jseAoty/1rWbs2/C0fzODEcYs8CQHfiVgAkUByXFQC2P6OpoeoLW7LRpwE2tUnoyj4zVLFeFAv4ial8dn1SlFhObDymOgNrXllprfiyosg6yn3VVWEKy7akYHuS++s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787583824; c=relaxed/simple;
	bh=+btdl5rvtiJzh8XPj4RG86SBosoRWA9bFHjoye2hLcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSQlVemJVK9RQ0EdKsCPlyPfK9ltpbkES0NyUCl/Al6eTYi4N4RaDMJt2Q1BCOkVHE1jZCuKv10AktJN5QI7jICnJm2nx3c49V7ifAe7K1EueERKSFwF7kohArte+4EgXenhtvbHkdysvAxvXM9dMEyfcd/UPeffvnF1wL6vfTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MlYxhye9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MlYxhye9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787583822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ3erjJduSWntjWxjPCCJpediljarFwjV+7IHAqxu6o=;
	b=MlYxhye9jEkWlzFCccp1+IHNrfo8MVbU0G1K8UV5FtNBG0p275L6o6tFqjeQQkAV0wRli6
	rYXrvmDNq3hQI6LmReuGHXkU/LbBoI0Z+vCX+s15wLh4eTsi4E1tzsKcECTO2CtbLrE8Eb
	2IZZl+FjHD7xHNef+s8o6hfwhj+yf18=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-2cWygwANNtm8DIgIiEXztA-1; Mon,
 24 Aug 2026 11:03:38 -0400
X-MC-Unique: 2cWygwANNtm8DIgIiEXztA-1
X-Mimecast-MFC-AGG-ID: 2cWygwANNtm8DIgIiEXztA_1787583816
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B3BD1944F01;
	Mon, 24 Aug 2026 15:03:36 +0000 (UTC)
Received: from fedora (unknown [10.44.32.9])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4B0C630002ED;
	Mon, 24 Aug 2026 15:03:31 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 24 Aug 2026 17:03:36 +0200 (CEST)
Date: Mon, 24 Aug 2026 17:03:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH v2 0/5] Stop TIF_NOTIFY_SIGNAL from interrupting work
 that can't be restarted
Message-ID: <aoxdQmFMK7pjH9qk@redhat.com>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 08/24, Christian Brauner wrote:
>
> Christian Brauner (5):
>       signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
>       coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
>       selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
>       smb: prevent TIF_NOTIFY_SIGNAL from interrupting
>       pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

For 1-2 and 4-5 feel free to add

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

-------------------------------------------------------------------------------
sigprocmask(SIG_BLOCK) in fs/smb/client/transport.c:__smb_send_rqst() looks
a bit suspicious. Even if we forget about TIF_NOTIFY_SIGNAL, sigprocmask()
doesn't necessarily clear TIF_SIGPENDING, nor it can protect from (say)
do_signal_stop()->signal_wake_up() from a sub-thread. But this is offtopic.

Oleg.

