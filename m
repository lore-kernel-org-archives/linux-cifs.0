Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382AE4ACC99
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377701; cv=none; b=fJddQgulVkDQZhI7jH6Xr4hN8OYpXmCnXa760NejY1ClxyKsD6qITQYrJ7OPd4DJ1oU9O868MUSucFgeY9qYAX+txxAnl1ckptYawNWRaKFT/WYfM8zDlnxccuttaINvFARdtK/R6y9k9ygWeeWXly6DIIjuSmKuWmhytuEbAMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377701; c=relaxed/simple;
	bh=7XijPLwz3cHBxl1YFk+E8vu/tL68tteh4h0gxiMHTNc=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=nF8lGkQnGdZIL/JOloQqFzAWXpW8+xiQRpB1Yp+FaCnBefkR6PWgc5n6WNvS0cWg75HltO7gn2CmuHLa1KBVFbnriD3ijCIcCfOoDjguzKQEJ+Gc5CgJTfropTfDJWXmq/p/R5RdKq/B0Lna8uehC5yzBoHfCyd/ROPJ9nmDHUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=apaOjh7d; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="apaOjh7d"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90e7d9c747eso18229766d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377690; x=1788982490; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BIdNMxFvwqrPz4tpIyv6StSQNKP9oc9jkPpYrkixADU=;
        b=apaOjh7dQp74WY42ZKX1LucplV5mZwhakPtY5Jg2eXD4fZ3oEZRJXmKGzxoPFjE+Sd
         TFfutb20vFTVAwcF8aFfemNt+nNl2YigcQV+qQOzgrBZCsRMIjQAuCsL06AIQQPDPill
         MkUKXuR5tuMo6l8FA//nAL1Tj/XGhR8GdhHCcbs6J/tW84CM/8/sKhSrjkWKYzLVip42
         ZvhxgG8RAlyP+XVemMTyp9hSCSvPOSZ6O099hPlHoH9oipeJfJ8CrCyHgbhmgS30owwF
         HV1aWHhUJ3mUY881jnB4aQkdPvbZn9vSbvoRWmIqm1/impT4Vj7OvR0gzwrjwAj+PxTq
         nR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377690; x=1788982490;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIdNMxFvwqrPz4tpIyv6StSQNKP9oc9jkPpYrkixADU=;
        b=J71LwYn1+6XROYM1ePCgS83aUAEYOivwZi0nGIx9+8GchWUrcVn3MjZvoUn45IL0x6
         DRUAQS2hYNOfsiNuaP/56gtU1vYpBSorIYV8/9WHdoW5scfw3xRT/cBc3Tojiq8CF0q5
         LwvLEOhstZufpmViWB9A7NxyH9Ksus06uLWo40ZIJsPt3zhFDhaxhGyWfymrMueqFqR3
         dE+bFrQrTXcPDGF9tlN0ZavHuQRj0ZM6wi4VP97ZP9PaTe+V8xrz3rZqecKTFimTsXt5
         9BJXwI1kJY2wBnO0xxFODsyvC8cTqWesjqczYfuD/0evIw8sZUW50zcibgOR4N1WNmzH
         vJLw==
X-Forwarded-Encrypted: i=1; AKwUvByMCv++dWG605qBlKk+4llEjiD4QL5cwSYWHBSgTAFyCnbCTEKw5nx+KIpYiIWv/O3KpYfodV0/mJWi@vger.kernel.org
X-Gm-Message-State: AFuF++m8s+7CcUFsWQ9KCIAgABjYUFfYnzz2NvFtOTb2xUvEoJa3AHT0
	4sgiexOyLs1LMM15kPWhvsBP9gDdMo7EAv7RJ849xS4cT0q9nsJUVXBPrb5Ce9NLfw==
X-Gm-Gg: AYBFou0Lt8NNn7dmmSn5kKxvRNPXQcW7/MbJPyCW05Mhlt5DCVx/T+zelt7gu/13eN8
	mJBYlJKVU4XaVR0ms/w8gDZFSPXeTVYvQ0cpdLfa+pxAnAGu+/Gwk4TbN+Eklxr8Le6HzXLOYzx
	IYKmsguzxP4mtKy9RncYT8Mo2yLz7i5TI/uSMoqFF8a1tzyqnKt0dR5eyqRE2B9yM/A07xY5wSh
	lF4YAHoTGt0AiXiUeuwywV1ESXRZ86qPXHCtBbqbwVVcYV5EVmsk3/P6J4Bjc580mJeR1+H6+8+
	pqB0232ZuDIB5rEVsyyiHPxFLcawtMiBHAtBzNoz94BcM+EFovaOk/Lft0rIFxcv1G/gZFaJBBz
	YRz2QYzqRTZzK1hKURyW0sx60uBGlV8zZyWZbZ3vJa8fzImBfa5i586snV8ar92CaI5xpJXuDL9
	1CLljOEGPqbT0VFbXMQLKTFcpqy0OZxMBVwHRaf6Ke5AbbDIPPJJYBpDGlW9XGwkE8DGDdCV70g
	EqSemKGFRgc0XtwJYb5yp54DlPyaybjbA==
X-Received: by 2002:a05:6214:4601:b0:8f0:3b2c:a9c8 with SMTP id 6a1803df08f44-90e9f25c224mr108760886d6.12.1788377690538;
        Wed, 02 Sep 2026 12:34:50 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0f57fsm25004716d6.47.2026.09.02.12.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:49 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:49 -0400
Message-ID: <f12155b3bc5ca8d846bf822b35f6b857@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260902_1319/pstg-lib:20260901_1604/pstg-pwork:20260902_1319
From: Paul Moore <paul@paul-moore.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, linux-security-module@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 13/27] fs: port xattr to const mnt_idmap
References: <20260901-work-idmap-const-v1-13-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-13-54ccd48e100b@kernel.org>

On Sep  1, 2026 Christian Brauner <brauner@kernel.org> wrote:
> 
> Convert to const struct mnt_idmap.
> 
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  Documentation/filesystems/locking.rst |  2 +-
>  fs/9p/xattr.c                         |  2 +-
>  fs/afs/xattr.c                        |  4 ++--
>  fs/attr.c                             |  2 +-
>  fs/btrfs/xattr.c                      |  6 +++---
>  fs/ceph/xattr.c                       |  2 +-
>  fs/ecryptfs/inode.c                   |  2 +-
>  fs/ext2/xattr_security.c              |  2 +-
>  fs/ext2/xattr_trusted.c               |  2 +-
>  fs/ext2/xattr_user.c                  |  2 +-
>  fs/ext4/xattr_hurd.c                  |  2 +-
>  fs/ext4/xattr_security.c              |  2 +-
>  fs/ext4/xattr_trusted.c               |  2 +-
>  fs/ext4/xattr_user.c                  |  2 +-
>  fs/f2fs/xattr.c                       |  4 ++--
>  fs/fuse/dir.c                         |  2 +-
>  fs/fuse/fuse_i.h                      |  2 +-
>  fs/fuse/xattr.c                       |  2 +-
>  fs/gfs2/xattr.c                       |  2 +-
>  fs/hfs/attr.c                         |  2 +-
>  fs/hfsplus/xattr.c                    |  2 +-
>  fs/hfsplus/xattr_security.c           |  2 +-
>  fs/hfsplus/xattr_trusted.c            |  2 +-
>  fs/hfsplus/xattr_user.c               |  2 +-
>  fs/jffs2/security.c                   |  2 +-
>  fs/jffs2/xattr_trusted.c              |  2 +-
>  fs/jffs2/xattr_user.c                 |  2 +-
>  fs/jfs/xattr.c                        |  4 ++--
>  fs/kernfs/inode.c                     |  4 ++--
>  fs/nfs/nfs4proc.c                     | 10 +++++-----
>  fs/ntfs/ea.c                          |  2 +-
>  fs/ntfs3/xattr.c                      |  2 +-
>  fs/ocfs2/xattr.c                      |  6 +++---
>  fs/orangefs/xattr.c                   |  2 +-
>  fs/overlayfs/xattrs.c                 |  4 ++--
>  fs/pidfs.c                            |  2 +-
>  fs/smb/client/xattr.c                 |  2 +-
>  fs/smb/server/vfs.c                   | 24 ++++++++++++------------
>  fs/smb/server/vfs.h                   | 20 ++++++++++----------
>  fs/ubifs/xattr.c                      |  2 +-
>  fs/xattr.c                            | 22 +++++++++++-----------
>  fs/xfs/xfs_iops.c                     |  2 +-
>  fs/xfs/xfs_xattr.c                    |  2 +-
>  include/linux/capability.h            |  4 ++--
>  include/linux/fs.h                    |  2 +-
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/security.h              | 20 ++++++++++----------
>  include/linux/xattr.h                 | 20 ++++++++++----------
>  kernel/bpf/inode.c                    |  2 +-
>  mm/shmem.c                            |  2 +-
>  net/socket.c                          |  4 ++--
>  security/commoncap.c                  |  8 ++++----
>  security/integrity/evm/evm_main.c     |  4 ++--
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  57 files changed, 135 insertions(+), 135 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
