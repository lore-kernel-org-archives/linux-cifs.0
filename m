Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52A44AB99;
	Tue, 21 Jul 2026 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668893; cv=none; b=G55HDed52g29shtexsZvqLBtSKwvKR9GdpHCMhKWPkpfN6mFF8VQWjijRT37yhSTXe0oQdM51gvA0PKTmQ8wiuVZDFZH9CbbPk9XGfFCN38PRY+ULpQr79r1AVrmd+tgtc+hwveqCs9srWAvJe2t5oXYGA6PcJYVw9qzYjh64qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668893; c=relaxed/simple;
	bh=+Gqsm4gqLMwFNZ0AshqdF1RuqOVGIAZJQ31a7z5jhGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ar6/h2rIZnyHFGDVvFi1JPknKkWkGSI8QL+/YgZU9Ra2WK32KJTsZ8v5okpQ9I9EsAkLrQMUepnLaDf1V6khTEhET8JQfMt3++p3Bed5f8zYxi8cy7Twst0tpB+abSpLx07oATIhZE4Vy7gdLoIC7A48drEXhQxuWBLzEch12fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/HjMpiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/HjMpiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B61F000E9;
	Tue, 21 Jul 2026 21:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784668891;
	bh=mNAYL66qhgcA6JDYg6N3671A+c/SLVrzYAycekrZvxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H/HjMpiGsS8p72ql1jiQsC6WmJiVqI2nS3qsMmWK0HCFO7HtPc4BQrSyXB6WlDMS+
	 sntGSOuBd7lVdIa4dG+7iLjmsC0n+oFI5rKiMp7SC1VzUbrLvJM1HIAoNWLGAPId7D
	 efkIG+/Ar5zh65qPyLgRJiiqjEUHrHN03rP2ChbuLKAJveF2hTPypVkKE3xm7aSwXW
	 LeaYMOjshbmMFnLoZfLT/qsDDkVNJ/1oG9Gy5nNU+sfoG6nIEb+hR9/De3XylCkP+o
	 jTFAwW3MYOXruUqiWE8ekwBUqzaUcrTRb/Z3+oBL3cbNL/HT3z/NPmoeC2XnTyKAA1
	 heklvUPszuUTg==
Date: Wed, 22 Jul 2026 05:21:22 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, fstests@vger.kernel.org
Subject: Re: [PATCH v2 xfstests 0/3] add generic/795
Message-ID: <al_e-tLidEugZyY2@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, fstests@vger.kernel.org
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
 <al8nX7MnPDzmUA5W@zlang-mailbox>
 <4021e03f-6d80-4a26-9112-1dc20abeed12@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4021e03f-6d80-4a26-9112-1dc20abeed12@chenxiaosong.com>

On Tue, Jul 21, 2026 at 04:31:59PM +0800, ChenXiaoSong wrote:
> Hi Zorro,
> 
> The stat command uses the statx() syscall rather than fstat(), so we have to
> use a C program to call fstat().

I'm not sure how you got at that conclusion.

> 
> On 7/21/26 16:25, Zorro Lang wrote:
> > I might not have explained clearly during the review. I wasn't asking you to
> > rewrite g/002 and lstat64.c. I was suggesting checking whether src/fstat.c in
> > your previous patch could be replaced by the stat command in xfs_io [1]. Check
> > `man xfs_io` for the "stat" command to see if it can fulfill your test
> > requirement.
> > 
> > Due to I noticed you need information like st_nlink from struct stat, so
> > `xfs_io -c "stat -r" ...` should meet your requirements. Please
     ^^^^^^^^^^^^^^^^^^

Please note that I have been talking about xfs_io stat subcommand all along, rather
than the coreutils' stat command. I suspect there might be a misunderstanding here.

xfstests inherently depends on xfsprogs, particularly the xfs_io command.
I just checked this for you, the stat subcommand in xfs_io does indeed use
the fstat system call [1][2], not statx, and its -r option will print out fields
like st_nlink.

Please double-check this on your end, make sure it works for you.

Thanks,
Zorro

[1]
xfsprogs/io/stat.c:stat_f() :
  int
  stat_f(
          int             argc,
          char            **argv)
  {
          struct stat     st;
          int             c, verbose = 0, raw = 0;

          while ((c = getopt(argc, argv, "rv")) != EOF) {
                  switch (c) {
                  case 'r':
                          raw = 1;
                          break;
                  case 'v':
                          verbose = 1;
                          break;
                  default:
                          exitcode = 1;
                          return command_usage(&stat_cmd);
                  }
          }

          if (fstat(file->fd, &st) < 0) {
                  perror("fstat");
                  exitcode = 1;
                  return 0;
          }

          if (raw)
                  return dump_raw_stat(&st);
  ...

[2]
$ strace xfs_io -c "stat -r" README 2>&1|grep -E "statx|fstat"
fstat(3, {st_mode=S_IFREG|0644, st_size=106979, ...}) = 0
fstat(3, {st_mode=S_IFREG|0755, st_size=36680, ...}) = 0
fstat(3, {st_mode=S_IFREG|0755, st_size=236720, ...}) = 0
fstat(3, {st_mode=S_IFREG|0755, st_size=2482096, ...}) = 0
fstat(3, {st_mode=S_IFREG|0755, st_size=187232, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=233380912, ...}) = 0
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
newfstatat(AT_FDCWD, "/", {st_mode=S_IFDIR|0555, st_size=154, ...}, 0) = 0
newfstatat(AT_FDCWD, "/", {st_mode=S_IFDIR|0555, st_size=154, ...}, 0) = 0
newfstatat(AT_FDCWD, "/home", {st_mode=S_IFDIR|0755, st_size=10, ...}, 0) = 0
newfstatat(AT_FDCWD, "/home", {st_mode=S_IFDIR|0755, st_size=10, ...}, 0) = 0
newfstatat(AT_FDCWD, "/boot", {st_mode=S_IFDIR|0555, st_size=4096, ...}, 0) = 0
newfstatat(AT_FDCWD, "/boot", {st_mode=S_IFDIR|0555, st_size=4096, ...}, 0) = 0
newfstatat(AT_FDCWD, "/boot/efi", {st_mode=S_IFDIR|0700, st_size=4096, ...}, 0) = 0
newfstatat(AT_FDCWD, "/boot/efi", {st_mode=S_IFDIR|0700, st_size=4096, ...}, 0) = 0
newfstatat(AT_FDCWD, "README", {st_mode=S_IFREG|0644, st_size=27145, ...}, 0) = 0
fstatfs(3, {f_type=BTRFS_SUPER_MAGIC, f_bsize=4096, f_blocks=249372928, f_bfree=196292374, f_bavail=195356006, f_files=0, f_ffree=0, f_fsid={val=[0xfb10ffbe, 0x278a3f4f]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=27145, ...}) = 0
newfstatat(AT_FDCWD, "README", {st_mode=S_IFREG|0644, st_size=27145, ...}, 0) = 0
fstatfs(3, {f_type=BTRFS_SUPER_MAGIC, f_bsize=4096, f_blocks=249372928, f_bfree=196292374, f_bavail=195356006, f_files=0, f_ffree=0, f_fsid={val=[0xfb10ffbe, 0x278a3f4f]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=27145, ...}) = 0
fstat(4, {st_mode=S_IFREG|0644, st_size=2998, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=27145, ...}) = 0
fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0


> > give it a try, if it works, it will make the whole patch much cleaner.
> >
> > P.S. For a new test case, please don't use a specific case number (like
> > generic/795) in the subject or commit log, as it might get assigned a
> > different number when merged. You can just use something like:
> > "[PATCH] generic: new test to ..."
> 
> -- 
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
> 
