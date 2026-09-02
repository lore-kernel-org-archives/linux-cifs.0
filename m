Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9391739CCFB
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377716; cv=none; b=k7iAzQUf1LPn/gFUW6f0DlThiDxDe4jdjZvhTp417DeS+hZ9QX6OmdUNql4ZMIeMJ44HYxXSm909+7o0y8SNudgef4Ky4i6yQHtsxGegKyN95yQCMAivluC7QPaAe5/mWrEHzNgihhs2HPGZVJIqXwO66FbOnz2v1NbYHhEmMK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377716; c=relaxed/simple;
	bh=hV2MW1omBZf24pDu1TyLQ7VokUTMjJdalm/WKcqe5oQ=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=tOabc92Y8Z1wLAv3EzSyDHKuk/gLs4e+Bn4b9KiWDeTWOWaszuZvkvB1c04vCm2Y0IkIkPE5Ndkw51T/Go2zdkup9kHvRcLG7A8AC2ynT68jLsdjN3ovxe/NS//JZxEda3ukxGea1e+v8bDN5AU0be89a3JT/OOHAEMnYaQjxD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GOKkdTYL; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GOKkdTYL"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e57a753f9so176020485a.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377695; x=1788982495; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GC4FIfkk2kp9PFt1uwqlIhd5i3bfmRn6wjlpVpmfWwA=;
        b=GOKkdTYLHtwfO3ngYpVGTvFI8bS9jy2AxeRMxBguqtyz+mrrUORq9lf9kDCSAKxOoR
         I2u1MFMWwWZGUNwTNq/9I+IlnwmgCDArVPN+m+Iu/wTXYKIlMgFa93lR+Jynm0Mu4qEf
         5PxuBOn4U3HwoWjMrUL94iXOSPSBHNeM4yrBPcctQBFB5MDB+AQSFM9k5owfyUGQEbiN
         HUGDO1RvIz7iOVnLN1KfotthYbhUcF+ZHQXILDGx1Sj+n9/Ike59tT+7EsIK6KEFRo2/
         Badzc6YVVwyjOiepd7sGNucttV9+0d0PqG4UHoWs9HhvSznmEOYBaD96nPZTIopNTfjc
         ituw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377695; x=1788982495;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GC4FIfkk2kp9PFt1uwqlIhd5i3bfmRn6wjlpVpmfWwA=;
        b=miJ4o9qqZrWW/V0K6jsq9VvLBopYLBw9b6TwEm2OHlY/JhJ0ZSDAMuFGZ/WPyvyZkG
         X8dfIQqpGBjiCxggcNd1Yo4Kqy6Sqytd65MnsCAuxQnUI6TXs00b/HbaErzFXXchBClV
         g1JcGalvu8aEEPxhE/y+7YTj0M4iKEvN0Te6MmRlE/DtZWDzG4m+n1QxxN2TXTL1JRpx
         rLNMFS6B7zqn7NEpNPaAaCrlvAFrSUrNM62g5g/u6Pc+T0U3HeMVojzVMcI0bZ0sZ4Eo
         0gDYudUfOV6TNiVapu8vavzpCE9eyWf8VtBiqi8BfPLrxUfus32Bh6H0sc3b1U/cxZ9H
         lBYQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxl5BsjKWo6CCXblmu6MDl/WCs0xascGs0OTg8+aukD9rQ+O8iEozlUidQiD+cnoa1IZB4KW5eU99+@vger.kernel.org
X-Gm-Message-State: AFuF++l2FiYsex6tHpA9SDGW8aCnLfo0SXYvOAU61w24M6OiQLrNtLQS
	n4Ll9dpuAIGJkyhfdDlmeyJKiWmtJQxWr6oAe2AYcuhl8rUYsM17VsRZSeXoZCtvPA==
X-Gm-Gg: AYBFou0IP0vGlNkGIcw02B1t0jJQSysMflGP5WtbFPqhH/lQzMsU1YLt4ve6u46AbBX
	lKrilEhpMLwiNIMeq5UzkPDVgmDx+5zFXoZl9hbQazQLqkkrzO1XeUBLz6hrDdhXpTUt5sAhuB0
	SPmpCXm6KHm1HWX00y11+E1b9LYIE0C5CTBW0GhreqXUCfq76zHzHjeI0gvSdBLY54s0keApykD
	Z7ALOmSvebb0a3IEbitDCr4arcHq4D7l4CNIE3dk8kjXiVwYdLrtLfcz8NCbEByJKU6kVEvMSPh
	hwkcWoGKjFkRKbrOk1oLiZxO2V7Y4o3ZIoxlfq3V5/7ejQB22cql1soipIEEnhSPv+/BRAX1NLP
	PgepFX1+TqLyiw0K2jF2cR2YbsjYW5W3an265nbZiWaqnKroZuqklJ3X/Ohn7THsk4rFM8xQPbC
	9+69TpXWKRVR3ygdg00rjH46rW/IME2y3ks0NG7c6foY4OitQWrWepM7eLWzmOicPNBoSpEwZFn
	61nj/oauAiXM/TuL451VBYY3hJijEJRwak=
X-Received: by 2002:a05:620a:d94:b0:939:6de9:4cfb with SMTP id af79cd13be357-9396de968a9mr206623085a.46.1788377695492;
        Wed, 02 Sep 2026 12:34:55 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ef0e9b1sm25737496d6.43.2026.09.02.12.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:54 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:53 -0400
Message-ID: <0a5d61e6a17442e42646e98ac73dd7df@paul-moore.com>
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
Subject: Re: [PATCH 24/27] fs: port ->setattr() to pass const mnt_idmap
References: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>

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
>  Documentation/filesystems/locking.rst     | 2 +-
>  Documentation/filesystems/vfs.rst         | 2 +-
>  arch/powerpc/platforms/cell/spufs/inode.c | 2 +-
>  fs/9p/v9fs_vfs.h                          | 2 +-
>  fs/9p/vfs_inode.c                         | 2 +-
>  fs/9p/vfs_inode_dotl.c                    | 2 +-
>  fs/adfs/adfs.h                            | 2 +-
>  fs/adfs/inode.c                           | 2 +-
>  fs/affs/affs.h                            | 2 +-
>  fs/affs/inode.c                           | 2 +-
>  fs/afs/inode.c                            | 2 +-
>  fs/afs/internal.h                         | 2 +-
>  fs/anon_inodes.c                          | 2 +-
>  fs/attr.c                                 | 2 +-
>  fs/bad_inode.c                            | 2 +-
>  fs/btrfs/inode.c                          | 2 +-
>  fs/ceph/inode.c                           | 2 +-
>  fs/ceph/super.h                           | 2 +-
>  fs/coda/coda_linux.h                      | 2 +-
>  fs/coda/inode.c                           | 2 +-
>  fs/configfs/configfs_internal.h           | 2 +-
>  fs/configfs/inode.c                       | 2 +-
>  fs/debugfs/inode.c                        | 2 +-
>  fs/ecryptfs/inode.c                       | 2 +-
>  fs/efivarfs/inode.c                       | 2 +-
>  fs/exfat/exfat_fs.h                       | 2 +-
>  fs/exfat/file.c                           | 2 +-
>  fs/ext2/ext2.h                            | 2 +-
>  fs/ext2/inode.c                           | 2 +-
>  fs/ext4/ext4.h                            | 2 +-
>  fs/ext4/inode.c                           | 2 +-
>  fs/f2fs/f2fs.h                            | 2 +-
>  fs/f2fs/file.c                            | 2 +-
>  fs/fat/fat.h                              | 2 +-
>  fs/fat/file.c                             | 2 +-
>  fs/fuse/dir.c                             | 2 +-
>  fs/gfs2/inode.c                           | 2 +-
>  fs/hfs/hfs_fs.h                           | 2 +-
>  fs/hfs/inode.c                            | 2 +-
>  fs/hfsplus/inode.c                        | 2 +-
>  fs/hostfs/hostfs_kern.c                   | 2 +-
>  fs/hpfs/hpfs_fn.h                         | 2 +-
>  fs/hpfs/inode.c                           | 2 +-
>  fs/hugetlbfs/inode.c                      | 2 +-
>  fs/inode.c                                | 2 +-
>  fs/internal.h                             | 2 +-
>  fs/jffs2/fs.c                             | 2 +-
>  fs/jffs2/os-linux.h                       | 2 +-
>  fs/jfs/file.c                             | 2 +-
>  fs/jfs/jfs_inode.h                        | 2 +-
>  fs/kernfs/inode.c                         | 2 +-
>  fs/kernfs/kernfs-internal.h               | 2 +-
>  fs/libfs.c                                | 4 ++--
>  fs/minix/file.c                           | 2 +-
>  fs/nfs/inode.c                            | 2 +-
>  fs/nfs/namespace.c                        | 2 +-
>  fs/nilfs2/inode.c                         | 2 +-
>  fs/nilfs2/nilfs.h                         | 2 +-
>  fs/ntfs/file.c                            | 2 +-
>  fs/ntfs/inode.h                           | 2 +-
>  fs/ntfs3/file.c                           | 2 +-
>  fs/ntfs3/ntfs_fs.h                        | 2 +-
>  fs/ocfs2/dlmfs/dlmfs.c                    | 2 +-
>  fs/ocfs2/file.c                           | 2 +-
>  fs/ocfs2/file.h                           | 2 +-
>  fs/omfs/file.c                            | 2 +-
>  fs/orangefs/inode.c                       | 2 +-
>  fs/orangefs/orangefs-kernel.h             | 2 +-
>  fs/overlayfs/inode.c                      | 2 +-
>  fs/overlayfs/overlayfs.h                  | 2 +-
>  fs/pidfs.c                                | 2 +-
>  fs/proc/base.c                            | 2 +-
>  fs/proc/generic.c                         | 2 +-
>  fs/proc/internal.h                        | 2 +-
>  fs/proc/proc_sysctl.c                     | 2 +-
>  fs/ramfs/file-nommu.c                     | 4 ++--
>  fs/smb/client/cifsfs.h                    | 2 +-
>  fs/smb/client/inode.c                     | 2 +-
>  fs/tracefs/event_inode.c                  | 2 +-
>  fs/tracefs/inode.c                        | 2 +-
>  fs/ubifs/file.c                           | 2 +-
>  fs/ubifs/ubifs.h                          | 2 +-
>  fs/udf/file.c                             | 2 +-
>  fs/ufs/inode.c                            | 2 +-
>  fs/ufs/ufs.h                              | 2 +-
>  fs/vboxsf/utils.c                         | 2 +-
>  fs/vboxsf/vfsmod.h                        | 2 +-
>  fs/xfs/xfs_iops.c                         | 2 +-
>  fs/zonefs/super.c                         | 2 +-
>  include/linux/fs.h                        | 6 +++---
>  include/linux/lsm_hook_defs.h             | 4 ++--
>  include/linux/nfs_fs.h                    | 2 +-
>  include/linux/security.h                  | 8 ++++----
>  mm/secretmem.c                            | 2 +-
>  mm/shmem.c                                | 2 +-
>  net/socket.c                              | 2 +-
>  security/integrity/evm/evm_main.c         | 4 ++--
>  security/integrity/ima/ima_appraise.c     | 2 +-
>  security/security.c                       | 4 ++--
>  security/selinux/hooks.c                  | 2 +-
>  security/smack/smack_lsm.c                | 2 +-
>  virt/kvm/guest_memfd.c                    | 2 +-
>  102 files changed, 112 insertions(+), 112 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
