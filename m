Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0822E3F8;
	Tue, 10 Dec 2024 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733820755; cv=none; b=KVA777oZe+So4Zcrw/tkIaUdiD59UF8+t8xwbW2IVO6Z1FC3q6pKUNBBueIsT6fsIV4L6aunPX5VzA5y7bACDHIp5xdQ7O/7GGRim9hbQxO44Gjwx4m8p0RfLhsQLLXRs/gsnEQ93TZA/gPdgNYDhF9QEaYdkZdxZGvSfF3OwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733820755; c=relaxed/simple;
	bh=vMzpnhpfT4W8z+DQaCIRqR/Q9i3pT1XN67mAL6L8kVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXcxGnNxAvmy2lDfGZykhXY/kpm1IkKUOhlVeJD8f88iks3+z0i4W+/P9t0aTqz97pePdm7XHYdBoASzMPKHFmHMEccTExOhzUVL6z6N293upP0iu0WqZZK+OGfRImidjQAWKYJGNHOE1yYL6u8Fsv6bscej/JU1fOuc4UXGsCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7zhY5w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7zhY5w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C1C4CED6;
	Tue, 10 Dec 2024 08:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733820754;
	bh=vMzpnhpfT4W8z+DQaCIRqR/Q9i3pT1XN67mAL6L8kVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q7zhY5w4VBRHjFcl1RwBKy4cidvL4uDDQZSBc+EJlQuU4rfWCZ4i816gKPQIDutr4
	 OIeNypgNWvljX2z4WYz7uKRIgaRVVQxv0sbZ/bGN1W+Mlif1NLCcmkut8SxfTWLxXr
	 ua9AAwMk7OH5Q+KsvBZs0JxlTARx6aTeJCv5w8VY=
Date: Tue, 10 Dec 2024 09:51:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Krause <mk@galax.is>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <2024121030-opt-escapist-fdc5@gregkh>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>

On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > Paulo,
> > 
> > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > Michael Krause <mk-debian@galax.is> writes:
> > > 
> > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > 
> > > > > Michael, can you please post your backport here for review from Paulo
> > > > > and Steve?
> > > > 
> > > > Of course, attached.
> > > > 
> > > > Now I really hope I didn't screw it up :)
> > > 
> > > LGTM.  Thanks Michael for the backport.
> > 
> > Thanks a lot for the review. So to get it accepted it needs to be
> > brough into the form which Greg can pick up. Michael can you do that
> > and add your Signed-off line accordingly?
> Happy to. Hope this is in the proper format:
> 
> 
> 
> 
> From 411fb6398fe3c3c08a000d717bff189f08d2041c Mon Sep 17 00:00:00 2001
> From: Paulo Alcantara <pc@manguebit.com>
> Date: Mon, 1 Apr 2024 14:13:10 -0300
> Subject: [PATCH] smb: client: fix UAF in smb2_reconnect_server()
> 
> commit 24a9799aa8efecd0eb55a75e35f9d8e6400063aa upstream.
> 
> The UAF bug is due to smb2_reconnect_server() accessing a session that
> is already being teared down by another thread that is executing
> __cifs_put_smb_ses().  This can happen when (a) the client has
> connection to the server but no session or (b) another thread ends up
> setting @ses->ses_status again to something different than
> SES_EXITING.
> 
> To fix this, we need to make sure to unconditionally set
> @ses->ses_status to SES_EXITING and prevent any other threads from
> setting a new status while we're still tearing it down.
> 
> The following can be reproduced by adding some delay to right after
> the ipc is freed in __cifs_put_smb_ses() - which will give
> smb2_reconnect_server() worker a chance to run and then accessing
> @ses->ipc:
> 
> kinit ...
> mount.cifs //srv/share /mnt/1 -o sec=krb5,nohandlecache,echo_interval=10
> [disconnect srv]
> ls /mnt/1 &>/dev/null
> sleep 30
> kdestroy
> [reconnect srv]
> sleep 10
> umount /mnt/1
> ...
> CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> CIFS: VFS: \\srv Send error in SessSetup = -126
> CIFS: VFS: Verify user has a krb5 ticket and keyutils is installed
> CIFS: VFS: \\srv Send error in SessSetup = -126
> general protection fault, probably for non-canonical address
> 0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 3 PID: 50 Comm: kworker/3:1 Not tainted 6.9.0-rc2 #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39
> 04/01/2014
> Workqueue: cifsiod smb2_reconnect_server [cifs]
> RIP: 0010:__list_del_entry_valid_or_report+0x33/0xf0
> Code: 4f 08 48 85 d2 74 42 48 85 c9 74 59 48 b8 00 01 00 00 00 00 ad
> de 48 39 c2 74 61 48 b8 22 01 00 00 00 00 74 69 <48> 8b 01 48 39 f8 75
> 7b 48 8b 72 08 48 39 c6 0f 85 88 00 00 00 b8
> RSP: 0018:ffffc900001bfd70 EFLAGS: 00010a83
> RAX: dead000000000122 RBX: ffff88810da53838 RCX: 6b6b6b6b6b6b6b6b
> RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc02f6878 RDI: ffff88810da53800
> RBP: ffff88810da53800 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff88810c064000
> R13: 0000000000000001 R14: ffff88810c064000 R15: ffff8881039cc000
> FS: 0000000000000000(0000) GS:ffff888157c00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe3728b1000 CR3: 000000010caa4000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? die_addr+0x36/0x90
>  ? exc_general_protection+0x1c1/0x3f0
>  ? asm_exc_general_protection+0x26/0x30
>  ? __list_del_entry_valid_or_report+0x33/0xf0
>  __cifs_put_smb_ses+0x1ae/0x500 [cifs]
>  smb2_reconnect_server+0x4ed/0x710 [cifs]
>  process_one_work+0x205/0x6b0
>  worker_thread+0x191/0x360
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0xe2/0x110
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x34/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> [Michael Krause: Naive, manual merge because the 3rd hunk would not
>                  apply]
> Signed-off-by: Michael Krause <mk-debian@galax.is>
> ---
>  fs/smb/client/connect.c | 80 ++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 45 deletions(-)

What kernel(s) is this commit supposed to be for?

thanks,

greg k-h
