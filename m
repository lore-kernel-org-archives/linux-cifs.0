Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990AA17332B
	for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 23:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727739360; cv=pass; b=ONkWBHMaKuWxBazpY3p+lwmNGlfMzxEewM3iehE5g0xm3yI2D5kNz4DsBK8n+3CDAMTW/i7rYsM+HcKxFIXtSojpef0VQKreAlMAcqO9TYq/8sKG4pR+rYgAB69pd2HcP9/PzXeL0MApB+0M0QMXxuj1iE9kmHyPrhAftWf/EUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727739360; c=relaxed/simple;
	bh=U6PowvyAZgRO5nv7kIjwiLdf6Mf4PzQ7Ym4jTy47D5U=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=heIrRY2lKqGcN5RgHKIddeWSnO21AUHuEsbn91yqXXUxJ20WltEN152r1/6rlGANCgG94twyjd1Ak8Oh2y/JbvIybleuR3Hr+7EAFnFDltU6PXMlpOwCLFGzkUYJGMiwgQpK0DqfyXzG36jlI5oDCo9IibY2vHFgwvAoMIyQlLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=p6ri61eb; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="p6ri61eb"
Message-ID: <6ab25571881f3d17aec3382fe80190fe@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727739355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UTNo638x9e6grbM1+tOfSL1Omb36cgryWj71hjX7KJM=;
	b=p6ri61ebAtVJQDGoupe+ZpTloBB9jDS7l9TNNHH00BMtobuEJccatO9RBEsRLPP1Rg0btY
	AEGYINyGdgQjW4C7SRoxoJTgr1eNtllJl7bpWrTizuVA4jUmC6Cc+yVbZT2J+17UE1Tjh0
	/d3pXB2qeQOzcSOZ7u5H59bzIzQJEFH9eoReaOHfFLc6dwt1HE5TcyjmBA5mIDdzH4EYoo
	Lv7Z+uh/05Mn7GoiDzeN1xzkxVr2d/MDIi01oMY6+NhJLAFYn5DNuxLiVo8W3QPd/8kOj1
	2zUkBTfjZh6hq1U1ojmbYMAAuLNSAc13F/BMs4SlCLpaQjr87K/6gVCFPI/iiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727739355; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTNo638x9e6grbM1+tOfSL1Omb36cgryWj71hjX7KJM=;
	b=VxSiyxwZhPJpT7nes4zVvaILwmyOIWL/rCkyDtOgTibpEhs4Pof++EDwHE/WscB8DzKFvu
	tLjMa9skLvG/Srtug3uakMJOyV0qpvadWxRrsefHPI92Y7OSL4iKHAy2D3PsH/n+SvRu2c
	ehoIISSDvaP4ADOftBe7e3rLxniC+qCYJmEV+4Swdb8LqKd8RD/ZvutHyZisG5kum4Fkal
	gicC1GPlhFy30uqGXYvlVWswdDoHPpcOqP5nL5eGZ0zm4uRcv62XcQjWP0VLmVce3fPKYE
	iRJlwPVTV0FjegW01ew7eXrrpXhSuadPO8lamgyWvgCZDDhjHLHzWT4jwAIuRA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1727739355; a=rsa-sha256;
	cv=none;
	b=VrUelD/XXZH+fQKddicm/moCxVfNKhmNZn+5FUxqu8VhMAMxhMjWYv6Un1eAVBVpN8O9f4
	kNwtWcOo7UjAk/L8jwtHll2uflelzAGtUf6HKyQrdsdl0gHUXRGqZR/ZEv2DFx/OhHTG+5
	ORjzepnvyevaZvSmRv/GiWWMdLNAn0XhldiAe9GBl6n+Vn9fnmqwMfMSeIi6Dt2c+ilUSX
	1MgtqMkUiV7FDX9N+7r1WzbhOMfFHNpArb/pN+QHBiCtYe6j/6d0W1GZW9fGkPAN7w9o+7
	PwMWRiQ5A+RnEvsblBgJvFnqJ/0sX52wKe6m9LXyn7OvbqHc9/D3tnnZRLLmfA==
From: Paulo Alcantara <pc@manguebit.com>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH 4/4] smb: client: make SHA-512 TFM ephemeral
In-Reply-To: <20240926174616.229666-5-ematsumiya@suse.de>
References: <20240926174616.229666-1-ematsumiya@suse.de>
 <20240926174616.229666-5-ematsumiya@suse.de>
Date: Mon, 30 Sep 2024 20:35:52 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> The SHA-512 shash TFM is used only briefly during Session Setup stage,
> when computing SMB 3.1.1 preauth hash.
>
> There's no need to keep it allocated in servers' secmech the whole time,
> so keep its lifetime inside smb311_update_preauth_hash().
>
> This also makes smb311_crypto_shash_allocate() redundant, so expose
> smb3_crypto_shash_allocate() and use that.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cifsencrypt.c   |  1 -
>  fs/smb/client/cifsglob.h      |  1 -
>  fs/smb/client/sess.c          |  2 +-
>  fs/smb/client/smb2misc.c      | 28 ++++++++++++++--------------
>  fs/smb/client/smb2proto.h     |  2 +-
>  fs/smb/client/smb2transport.c | 30 +-----------------------------
>  6 files changed, 17 insertions(+), 47 deletions(-)

This commit leads to the following NULL ptr deref when mounting a share
with 'vers=2.1'.  Reproduced it against Windows Server 2022 and samba
4.21.

  $ mount.cifs //srv/share /mnt -o ...,vers=2.1
  
  BUG: KASAN: null-ptr-deref in smb2_calc_signature+0x195/0x4f0 [cifs]
  Read of size 8 at addr 0000000000000000 by task mount.cifs/693
  
  CPU: 2 UID: 0 PID: 693 Comm: mount.cifs Not tainted 6.11.0 #3
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40
  04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   ? smb2_calc_signature+0x195/0x4f0 [cifs]
   kasan_report+0xda/0x110
   ? smb2_calc_signature+0x195/0x4f0 [cifs]
   smb2_calc_signature+0x195/0x4f0 [cifs]
   ? __pfx_smb2_calc_signature+0x10/0x10 [cifs]
   ? do_raw_spin_trylock+0xc6/0x120
   ? do_raw_spin_unlock+0x9a/0xf0
   ? _raw_spin_unlock+0x23/0x40
   ? smb2_sign_rqst+0x10c/0x160 [cifs]
   smb2_setup_request+0x225/0x3a0 [cifs]
   compound_send_recv+0x417/0x1140 [cifs]
   ? __pfx_compound_send_recv+0x10/0x10 [cifs]
   ? __create_object+0x5e/0x90
   ? hlock_class+0x32/0xb0
   ? do_raw_spin_unlock+0x9a/0xf0
   cifs_send_recv+0x23/0x30 [cifs]
   SMB2_tcon+0x3ec/0xb30 [cifs]
   ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
   ? ___ratelimit+0x133/0x1f0
   ? __pfx____ratelimit+0x10/0x10
   ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
   ? cifs_get_smb_ses+0xcaf/0x1070 [cifs]
   cifs_get_smb_ses+0xcaf/0x1070 [cifs]
   ? __pfx_cifs_get_smb_ses+0x10/0x10 [cifs]
   ? cifs_get_tcp_session+0xaa0/0xca0 [cifs]
   cifs_mount_get_session+0x8a/0x210 [cifs]
   dfs_mount_share+0x1b0/0x11d0 [cifs]
   ? __pfx___lock_acquire+0x10/0x10
   ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
   ? lock_acquire+0x14b/0x3e0
   ? find_held_lock+0x8a/0xa0
   ? hlock_class+0x32/0xb0
   ? lock_release+0x203/0x5d0
   cifs_mount+0xb3/0x3d0 [cifs]
   ? do_raw_spin_trylock+0xc6/0x120
   ? __pfx_cifs_mount+0x10/0x10 [cifs]
   ? ___ratelimit+0x133/0x1f0
   ? smb3_update_mnt_flags+0x372/0x3b0 [cifs]
   cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
   ? __pfx___mutex_lock+0x10/0x10
   ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
   smb3_get_tree+0x1bf/0x330 [cifs]
   vfs_get_tree+0x4a/0x160
   path_mount+0x3c1/0xfb0
   ? kasan_quarantine_put+0xc7/0x1d0
   ? __pfx_path_mount+0x10/0x10
   ? kmem_cache_free+0x118/0x3e0
   ? user_path_at+0x74/0xa0
   __x64_sys_mount+0x1a6/0x1e0
   ? __pfx___x64_sys_mount+0x10/0x10
   ? mark_held_locks+0x1a/0x90
   do_syscall_64+0xbb/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7fd23a9a88fe
  Code: 48 8b 0d 1d a5 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84
  00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
  f0 ff ff 73 01 c3 48 8b 0d ea a4 0c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffdeef79388 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
  RAX: ffffffffffffffda RBX: 0000562a96057eb0 RCX: 00007fd23a9a88fe
  RDX: 0000562a6d33347e RSI: 0000562a6d3334e4 RDI: 00007ffdeef7a4a2
  RBP: 00007ffdeef79440 R08: 0000562a96057eb0 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
  R13: 00007ffdeef7a4a2 R14: 0000562a96058f00 R15: 00007fd23aa96000
   </TASK>

  $ ./scripts/faddr2line --list fs/smb/client/cifs.o smb2_calc_signature+0x195
  smb2_calc_signature+0x195/0x4f0:
  
  smb2_calc_signature at /home/pc/g/linux/fs/smb/client/smb2transport.c:235
   230 			}
   231 		} else {
   232 			shash = server->secmech.hmacsha256;
   233 		}
   234 	
  >235<		rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
   236 				SMB2_NTLMV2_SESSKEY_SIZE);
   237 		if (rc) {
   238 			cifs_server_dbg(VFS,
   239 					"%s: Could not update with response\n",
   240 					__func__);

What's the problem with having it allocated the whole time?  Reconnect
path will need it to re-establish SMB sessions, so this means we'll now
have to allocate it every time we attempt to reconnect a session?  This
could be worse when smb2_reconnect_server() is periodically attemping to
reconnect a session.
