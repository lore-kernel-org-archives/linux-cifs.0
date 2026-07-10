Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12083563FA;
	Fri, 10 Jul 2026 06:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783665486; cv=none; b=Ev1f2wDxXDwT1zJTr5On+f12vP3VncQTexgo4JyZbwWnEh1aVNTeFIRMM3+AOwn1f4hjpP6jB2hStSPZMkIewyFB/R0BdQ4kIoykkJNb210HY4Xhry0ar0pNKCcwr0BcMYnzed+LnO4Z9MgtOs5AoMSu4XOhRffqYcHKY2rISnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783665486; c=relaxed/simple;
	bh=G6YBgkf/OjFwI9g6J1WS3lFkm934uamQ2YTL6p75Oa4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=TDgeVFMT/MMJr2b7xe6T6wXjiBnNDL+nbzcyoy6EGIw/igkpJifpSa9NT9Jn8S0UZPZW63YUNOWrqpu9mCd8lzmIfwJJ5QWL0Q4XVQlHv8pQOFYwuH6Z6QLkXOOhc77xcL9K3dq4q6OsvaADjXexAp1LJzvbJ5iMttubWN5B4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=GHV2VaM0; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="GHV2VaM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783665484; x=1815201484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/DPbmXITuRdtx072EpffQzv0HolMLLquvaHLTCO+MTI=;
  b=GHV2VaM0OZs1MqRLa6BPlpPhiK3ozqvJB8wFb54pCmJimg0x0w4xLqVo
   ywEcKZjL6uG4aenXiGfSQNiDqKJSF1heg+e/ZqmX6N3pHsZ4zbz5z9xKO
   g5K6megteY4JACeP57dgp94IoSCyC4e2E8WctWGL4K0/jsed+0UD7lpFN
   /WVQI83JY+9P0ercWKFemXr/CIKjnUSNQDp518JQ7Ocmu9x1zNaCif2Nz
   0TTue3NinJ+r1DVPDmhWnTdXQdzpu0jdqrh4nqdqESuovsY+Mt36wsSsJ
   Ye6sNEPncy+La8B33wiYxedaLvl5LhUYCePtyTvTS2mfJZ0hN3lQ9t7p+
   w==;
X-CSE-ConnectionGUID: /Ijrhp5DQjy0lcZ4yz/uvA==
X-CSE-MsgGUID: dGgxVo62TkiaoqtTTPvOBQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23413452"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 06:38:01 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:3924]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.123:2525] with esmtp (Farcaster)
 id 7024ac17-63e0-45e8-8037-22a220e8fc24; Fri, 10 Jul 2026 06:38:01 +0000 (UTC)
X-Farcaster-Flow-ID: 7024ac17-63e0-45e8-8037-22a220e8fc24
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 06:38:00 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 06:37:59 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Steve French <smfrench@gmail.com>
CC: Bjoern Doebel <doebel@amazon.de>, Steve French <sfrench@samba.org>, "Paulo
 Alcantara" <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, "Bharath
 SM" <bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<stable@vger.kernel.org>, <nmanthey@amazon.de>
Subject: Re: [PATCH] smb: client: fix DACL-rewrite heap overflow in id_mode_to_cifs_acl()
Date: Fri, 10 Jul 2026 06:37:41 +0000
Message-ID: <alCTJpbV46sPiYLT@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAH2r5mt_Pd=wd-pXdaYkNpWE9NfeM0bhnEy-LKuhgOZchVPTJA@mail.gmail.com>
References: <20260709155440.2132459-1-doebel@amazon.de> <CAH2r5mt_Pd=wd-pXdaYkNpWE9NfeM0bhnEy-LKuhgOZchVPTJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Hi Steve,

On Thu, Jul 09, 2026 at 05:15:40PM -0500, Steve French wrote:
> When I tried this it changed the length used (for chown with cifsacl
> mount option) from 88 bytes to 236 bytes
> which seems suspicious.  Have you been able to reproduce the bug this
> patch is supposed to fix?

I shared my reproducer script via PM.

This triggered the following KASAN splat in testing (and no longer does
with the patch applied):

[   46.251162] ==================================================================
[   46.278880] BUG: KASAN: slab-out-of-bounds in build_sec_desc.constprop.0+0x3010/0x3a70 [cifs]
[   46.319912] Write of size 4 at addr ffff888155556374 by task chown/3439
[   46.351546]
[   46.358846] CPU: 4 UID: 0 PID: 3439 Comm: chown Not tainted 7.1.0-rc6+ #35 PREEMPT(full)
[   46.358850] Hardware name: Amazon EC2 c6i.4xlarge/, BIOS 1.0 10/16/2017
[   46.358853] Call Trace:
[   46.358856]  <TASK>
[   46.358859]  dump_stack_lvl+0x51/0x70
[   46.358866]  print_address_description.constprop.0+0x2c/0x3a0
[   46.358871]  ? build_sec_desc.constprop.0+0x3010/0x3a70 [cifs]
[   46.358941]  print_report+0xb4/0x270
[   46.358944]  ? kasan_addr_to_slab+0x9/0x70
[   46.358948]  kasan_report+0xb4/0xe0
[   46.358951]  ? build_sec_desc.constprop.0+0x3010/0x3a70 [cifs]
[   46.359015]  build_sec_desc.constprop.0+0x3010/0x3a70 [cifs]
[   46.359077]  ? queue_folios_pte_range+0x45c/0x7a0
[   46.359082]  ? __pfx_build_sec_desc.constprop.0+0x10/0x10 [cifs]
[   46.359143]  ? __find_readable_file+0x310/0x540 [cifs]
[   46.359220]  ? kasan_save_track+0x10/0x30
[   46.359222]  ? __kasan_kmalloc+0x7b/0x90
[   46.359226]  id_mode_to_cifs_acl+0x31c/0x760 [cifs]
[   46.359295]  ? __pfx_id_mode_to_cifs_acl+0x10/0x10 [cifs]
[   46.359356]  ? __build_path_from_dentry_optional_prefix+0x176/0x620 [cifs]
[   46.359432]  cifs_setattr_nounix+0xc5b/0x1860 [cifs]
[   46.359505]  ? __pfx_cifs_setattr_nounix+0x10/0x10 [cifs]
[   46.359573]  ? __pfx___vfs_getxattr+0x10/0x10
[   46.359577]  ? __pfx_current_time+0x10/0x10
[   46.359580]  cifs_setattr+0x173/0x2b0 [cifs]
[   46.359648]  notify_change+0x832/0xf20
[   46.359651]  ? __pfx_from_vfsuid+0x10/0x10
[   46.359655]  ? chown_common+0x422/0x5e0
[   46.359658]  chown_common+0x422/0x5e0
[   46.359662]  ? __pfx_chown_common+0x10/0x10
[   46.359665]  ? check_heap_object+0x6f/0x490
[   46.359669]  ? strncpy_from_user+0x3b/0x1f0
[   46.359673]  do_fchownat+0x124/0x160
[   46.359677]  ? __pfx_do_fchownat+0x10/0x10
[   46.359680]  __x64_sys_fchownat+0xb9/0x150
[   46.359684]  ? arch_exit_to_user_mode_prepare.constprop.0+0x95/0xc0
[   46.359688]  do_syscall_64+0xaf/0x550
[   46.359693]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   46.359695] RIP: 0033:0x7fd413b00b0e
[   46.359709] Code: 48 8b 0d ed b2 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 04 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ba b2 0f 00 f7 d8 64 89 01 48
[   46.359712] RSP: 002b:00007ffc3eb973d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000104
[   46.359715] RAX: ffffffffffffffda RBX: 00007ffc3eb97700 RCX: 00007fd413b00b0e
[   46.359717] RDX: 0000000000001770 RSI: 000055e6afa81740 RDI: 00000000ffffff9c
[   46.359719] RBP: 000055e6afa7fb70 R08: 0000000000000000 R09: 0000000000000000
[   46.359720] R10: 00000000ffffffff R11: 0000000000000246 R12: 000055e6afa81740
[   46.359722] R13: 0000000000000001 R14: 00000000ffffff9c R15: 000055e6afa7fb00
[   46.359725]  </TASK>
[   46.359726]
[   47.532861] Allocated by task 3439:
[   47.549557]  kasan_save_stack+0x20/0x40
[   47.567957]  kasan_save_track+0x10/0x30
[   47.586353]  __kasan_kmalloc+0x7b/0x90
[   47.604316]  __kmalloc_noprof+0x1c1/0x530
[   47.623566]  id_mode_to_cifs_acl+0x2d0/0x760 [cifs]
[   47.646748]  cifs_setattr_nounix+0xc5b/0x1860 [cifs]
[   47.670768]  cifs_setattr+0x173/0x2b0 [cifs]
[   47.690945]  notify_change+0x832/0xf20
[   47.708918]  chown_common+0x422/0x5e0
[   47.726468]  do_fchownat+0x124/0x160
[   47.743582]  __x64_sys_fchownat+0xb9/0x150
[   47.763261]  do_syscall_64+0xaf/0x550
[   47.780816]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   47.804785]
[   47.812163] The buggy address belongs to the object at ffff888155556000
[   47.812163]  which belongs to the cache kmalloc-1k of size 1024
[   47.872006] The buggy address is located 0 bytes to the right of
[   47.872006]  allocated 884-byte region [ffff888155556000, ffff888155556374)
[   47.934359]
[   47.941237] The buggy address belongs to the physical page:
[   47.967735] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x155550
[   48.006191] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   48.042968] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
[   48.076404] page_type: f5(slab)
[   48.091399] raw: 0017ffffc0000040 ffff888100042dc0 dead000000000100 dead000000000122
[   48.128595] raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
[   48.165814] head: 0017ffffc0000040 ffff888100042dc0 dead000000000100 dead000000000122
[   48.203005] head: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
[   48.240615] head: 0017ffffc0000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
[   48.278257] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
[   48.315854] page dumped because: kasan: bad access detected
[   48.342361]
[   48.349658] Memory state around the buggy address:
[   48.372332]  ffff888155556200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   48.407026]  ffff888155556280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   48.441656] >ffff888155556300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 fc
[   48.476272]                                                              ^
[   48.509238]  ffff888155556380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   48.543873]  ffff888155556400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   48.578508] ==================================================================


Bjoern

> On Thu, Jul 9, 2026 at 10:55 AM Bjoern Doebel <doebel@amazon.de> wrote:
> >
> > Budget the destination buffer for the worst case in both branches:
> > every rewritten ACE may take sizeof(struct smb_ace) bytes (which
> > already accounts for an smb_sid with SID_MAX_SUB_AUTHORITIES
> > sub-authorities), plus the smb_acl header that
> > replace_sids_and_copy_aces() emits.
> >
> > Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjoern Doebel <doebel@amazon.de>
> > Assisted-by: Kiro:claude-opus-4.6
> > ---
> >  fs/smb/client/cifsacl.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> > index 07cf0e5782337..6d572dd995d79 100644
> > --- a/fs/smb/client/cifsacl.c
> > +++ b/fs/smb/client/cifsacl.c
> > @@ -1812,11 +1812,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
> >                                 cifs_put_tlink(tlink);
> >                                 return rc;
> >                         }
> > -                       if (mode_from_sid)
> > -                               nsecdesclen +=
> > -                                       le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
> > -                       else /* cifsacl */
> > -                               nsecdesclen += le16_to_cpu(dacl_ptr->size);
> > +                       /*
> > +                        * Worst case: every ACE is rewritten with a new SID of
> > +                        * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(smb_ace) each,
> > +                        * plus the smb_acl header replace_sids_and_copy_aces() emits.
> > +                        */
> > +                       nsecdesclen += sizeof(struct smb_acl) +
> > +                               le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
> >                 }
> >         }
> >
> > --
> > 2.50.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve

