Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7552C68B;
	Sun, 28 Jan 2024 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706462095; cv=none; b=PEZxQFMlFKAVb2bnxrOWYgy44ziDLVdXPn6I51rIoxCsDU3YiuuE5llQb0+T1V9Y6iKRPIGkTmoFiP3+5HHytcqjSYWvgP7wlTdWr1rH7gCsYelmciOeKDbW7qFPfo0L+JKp4jfxTTqup1QeSAf7Q7RMerYiTfXuSgS3D7TGiuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706462095; c=relaxed/simple;
	bh=4Xin2GhmRaH9WZjohRX4gGGj1AHpOGUOPeo9BUwOE7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miV2p8zRhVnNeBrLIx6AETGKRn2gyaunGbF+O2THpP0B/4T0mjlLJuaNeAZeg/2Cj2Cn+DeyqiQoJnB9p5k7g7V4IIoY1Um79yDCvwthi5YkdJd1BBB+mikqLL1YYWXkW20f4oJN5Izq4u9t4wU4s94UYg2cdPodVvzDmof7yuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=Ldq8AqZH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=t3hf7zHY; arc=none smtp.client-ip=64.147.123.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="Ldq8AqZH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="t3hf7zHY"
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailnew.west.internal (Postfix) with ESMTP id 2CEA02B0026C;
	Sun, 28 Jan 2024 12:14:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Sun, 28 Jan 2024 12:14:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1706462089; x=1706469289; bh=6/obcrnKJ7
	a3RkYq+Ehm94b9WOwdcJVxmJWcHUHMFjg=; b=Ldq8AqZHDdmczf6ZRoVA4wvzTO
	pipAQFVgnWJDbNoTjsLWHaNRJ48psD2EmU7C5eBwdmHHq7bfkUP/8sccaLxNouH+
	3UCFXvxpnkFM+Mw8ENPbVTEGg7Mp8+n27xcO74rtNkJpd7rOJz+FM1KVXo5VHUIx
	NlMHako7q0ecRLtf9EwBxu7bOQ888APMpu78EMBlm7V0CILzBjU5J0MT0+qWZOAc
	b6eT6UPjc8De7gQRN1eSDndMRFnOzr3mWqfx93RqekBO8gNHVI4Ebl954gRsLQq+
	XhOS9a3ORubQ6adowbwD10U7jaGOL9CX3sLnA4+QeuVAbBIDI2oZkvpACi+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1706462089; x=1706469289; bh=6/obcrnKJ7a3RkYq+Ehm94b9WOwd
	cJVxmJWcHUHMFjg=; b=t3hf7zHY4GCFwOV3WhpEDgoiiaJWPlzTR3HGf1o+DeHz
	04Z0vyg08GfIjlYxnp1bNa4q2RX0OxeLG5I/fsM2qlfLiiRkPJc2Naod2Ah2akz7
	hAC3xtgCK5afno3/7bw/TtkMQvj39QIjveZ0qU2rt5DWyr04ejw3AEQ887wAwhbZ
	8wPgVFGrRHjMVUv1K8aUIFS7C5tNo753w15VI3IA6U2SNSnD0QpBlgMbUId5bRM/
	hbuR6ytjnUCcB6r79S2eHK730zSTlFDTjFAqBI6BKQH50VSZtEfghpF3h6kjL+4B
	8CmwFmkG1zfvGaCN+1YTfDzOjJLRPoZVT2BKV2uu6Q==
X-ME-Sender: <xms:iYu2ZT80KrUC6VT16QNStmKv4JpqMa4ZpqvDBciVeowoTUFukzZFGw>
    <xme:iYu2Zfv08iEOXdxM_ZQKyOWZqXHbC5KUTtu2LcN9---1r0UQxZh0pKPS7jfOS7MM3
    Kio3QDj9Iuvqg>
X-ME-Received: <xmr:iYu2ZRApUDXUYfJ5HZmgXVIecXbm-gr18eQPSF47nATG5E8VuOs8YPlSet1m>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:iYu2ZfdHqbc8hgzLkXOIWvFAARJQlmukZj5qm40uAfSQnykcba2lOw>
    <xmx:iYu2ZYNSsw_NxA_X66AM5JQxKJCopfeei7Nr1J4Y5EQRdsDQ0QOeRw>
    <xmx:iYu2ZRlwJvdQg_NV0XuKF79deeti_EmUJRAxuJxDFP45_KOWP0DyqA>
    <xmx:iYu2ZUv2Xhi0nHr2lseMNqqvZRy6c0oniLyKEe0Q4JeWXLln9n3rXnPML5o>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Jan 2024 12:14:48 -0500 (EST)
Date: Sun, 28 Jan 2024 09:14:47 -0800
From: Greg KH <greg@kroah.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, kovalev@altlinux.org, --cc=abuehaze@amazon.com,
	smfrench@gmail.com, linux-cifs@vger.kernel.org,
	keescook@chromium.org, darren.kenny@oracle.com, pc@manguebit.com,
	nspmangalore@gmail.com, vegard.nossum@oracle.com
Subject: Re: [PATCH 5.15.y] cifs: fix off-by-one in SMB2_query_info_init()
Message-ID: <2024012840-trench-grove-1b5a@gregkh>
References: <20240128170759.2432089-1-harshit.m.mogalapalli@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128170759.2432089-1-harshit.m.mogalapalli@oracle.com>

On Sun, Jan 28, 2024 at 09:07:58AM -0800, Harshit Mogalapalli wrote:
> Bug: After mounting the cifs fs, it complains with Resource temporarily
> unavailable messages.
> 
> [root@vm1 xfstests-dev]# ./check -g quick -s smb3
> TEST_DEV=//<SERVER_IP>/TEST is mounted but not a type cifs filesystem
> [root@vm1 xfstests-dev]# df
> df: /mnt/test: Resource temporarily unavailable
> 
> Paul's analysis of the bug:
> 
> 	Bug is related to an off-by-one in smb2_set_next_command() when
> 	the client attempts to pad SMB2_QUERY_INFO request -- since it isn't
> 	8 byte aligned -- even though smb2_query_info_compound() doesn't
> 	provide an extra iov for such padding.
> 
> 	v5.15.y doesn't have
> 
>         eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> 
> 	and the commit does
> 
> 		if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
> 			     len > CIFSMaxBufSize))
> 			return -EINVAL;
> 
> 	so sizeof(*req) will wrongly include the extra byte from
> 	smb2_query_info_req::Buffer making @len unaligned and therefore causing
> 	OOB in smb2_set_next_command().
> 
> Fixes: bfd18c0f570e4 ("smb: client: fix OOB in SMB2_query_info_init()")
> Suggested-by: Paulo Alcantara <pc@manguebit.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> This patch is only for 5.15.y stable kernel.
> I have tested the patched kernel: after mounting it doesn't become
> unavailable.

Now queued up, thanks.

greg k-h
