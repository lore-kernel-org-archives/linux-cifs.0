Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794649108;
	b=089Wb4sCFF9xKgu/BiFKbwtbGqvsppKUHbgPC4yd/iKSz5+HSa2xJKmvIe4/zGeri4mF
	 b4nG7qLxoji3HSa0yvvGq/rzn5sPXd4YKfDRlN8TtR3TxcpC6u51rlZJ9C460NQPDY39/
	 Cqls8T1l8A6PkY+50Dzy0awrDOLN9y8VZ+6GY6nyU7LhSjfApKECji96jACUsfEMRhR6R
	 1PS+NG7ybwoMh2j2saepFKVVW81vE9M9NSF8abkjATeg2G4JHSc/B5PQ0+CrzCprLwK62
	 8Km9gttbuPDH7KIyqL9tVYoNrC3W0YInrelvc2vrwgsaudJhC2btb8BsD1zMprlCFBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794649108;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=rCcKjGQMxTYHkBUjL/k0P3CpYfeih7rVvw9hPQOr5+o=;
	b=CFB6d3nr30oDg9ATvOLiL5pOTbpWyka/srHfACeLiSCuIt7intYpWs3744LcVbcGzLCw
	 cIeb0YOM+Wa0CpYTldfhUKlQvsI6AnidEkq4JN5FWdT5okkUu3DcRBncL5V1ZN5hkCbnF
	 m13x507E2C2lx0yZ1d7nhImM2Udycr+CrUFjpUIwXVGE4uvRcoGLdsbMxuRIsP3jb6ZDz
	 HGiunf09FzM+CmuD2oLGJBnNmrYWg5e/SkW8MCGJZ57VFYnj+2Ul+UCfQiPbqUQiCrrqV
	 vdRHcLfXRH2ZgbSP8zo7iSq+VyhuRZVH2Cm05aAgGXV68aavQ12jImnP8UObr9APZ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UWCD8tqv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EA3606A327;
	Sat, 14 Nov 2026 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UWCD8tqv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F021F000C4;
	Sat, 14 Nov 2026 09:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794649108;
	bh=rCcKjGQMxTYHkBUjL/k0P3CpYfeih7rVvw9hPQOr5+o=;
	h=Date:From:To:Cc:Subject;
	b=UWCD8tqv7mF2QM7V8smGmZ4E6Z2vGWmCAGG6XSYTWKefEI3AiZzDc45nMIoCUePwt
	 HxU0PwGAHitIhOalxxm5YQ7VZK++QaVemUSV/OZZJoVUKFABALcR3pBHRzRGEMdHCM
	 LdWAr26ONdUPnKerGhOg5EB0cmmE1dqV72JcvxFxrZdoRWzrcrkh1GEfr3I7RRodEA
	 d7vS9vfQRh4O0oqoMCUv1quvSnnT9sIHYTBFadlWo3YQQhC+JbnlgKcFPSxwxnQqH1
	 yN/Wed6H3TmwgOtAWIN7OL7VoIZ9MFYDqQyW8nBIxEkDEzxtNzGcIznqorzeh5lnf7
	 6Pa5nvgUpGnJg==
Date: Sat, 14 Nov 2026 10:38:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Jan Kara <jack@suse.cz>, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: ksmbd: SET_INFO modifies frozen filesystems
Message-ID: <20261114-chipsatz-gutachten-geklingelt-81574928a5f4@brauner>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

I'm working on a freeze protection series and this is the part that
affects ksmbd that I don't just want to fix myself.

SMB2 SET_INFO changes timestamps, permissions and ACLs on the shared
filesystem without freeze protection. So a client can modify a frozen
filesystem. On ext4 that trips the WARN_ON() in
ext4_journal_check_start().

Reproduced on v7.4-rc1 with a ksmbd share on ext4 mounted over cifs
with cifsacl from 127.0.0.1:

    fsfreeze -f /srv/share
    touch -d 2001-01-01 /mnt/cifs/f1
    chmod 600 /mnt/cifs/f2

Both complete right away. f1 has an mtime of 2001-01-01 and f2's mode
changed on the frozen filesystem:

  WARNING: fs/ext4/ext4_jbd2.c:90 at ext4_journal_check_start+0x1f6/0x2d0, CPU#0: kworker/0:2/40
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   __ext4_journal_start_sb+0x7a/0x470
   ext4_dirty_inode+0xa1/0x120
   __mark_inode_dirty+0x154/0x1110
   ext4_setattr+0x2bd/0x24e0
   notify_change+0x81c/0xee0
   set_file_basic_info+0x74c/0xcc0
   smb2_set_info+0x1d73/0x3cd0
   handle_ksmbd_work+0x89d/0x1d60

  WARNING: fs/ext4/ext4_jbd2.c:90 at ext4_journal_check_start+0x1f6/0x2d0, CPU#0: kworker/0:0/9
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   __ext4_journal_start_sb+0x7a/0x470
   ext4_set_acl+0x22e/0x4e0
   set_info_sec+0x2f1/0x7b0
   smb2_set_info+0x606/0x3cd0
   handle_ksmbd_work+0x89d/0x1d60

set_file_basic_info() calls notify_change() and set_info_sec() calls
set_posix_acl() and notify_change() without mnt_want_write().

It looks like smb2_open() has the same issue and also the EA, security
descriptor and stream xattrs written on create: smb2_set_ea(),
smb_inherit_dacl(), ksmbd_vfs_set_init_posix_acl(),
smb2_set_stream_name_xattr() and the direct ksmbd_vfs_set_sd_xattr() all
pass get_write=false or call set_posix_acl() directly, but nothing in
smb2_open() holds write access at that point anymore since 4e45cca31d4e
("smb/server: add ksmbd_vfs_kern_path()"). But I haven't looked into
reproducing that.

The SET_INFO ones go back to e2f34481b24d ("cifsd: add server-side
procedures for SMB3").
