Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3807939EF33
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377706; cv=none; b=fjYZkIePbmcpFk77yuFmdrLrZIUrhcWM/i6WFcl1ENd6GjD4jfr+yA+YIJ0PmYEcCZKO06fEgfWT8qAAraH095BgaPMpwlVIe+KCGmEnX6Nk8AZ43lMB0K7kqBTIr3moukhjrcLPqu3ZnaJ8FMNkGck3781TtFzB1xQ9mvs5Dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377706; c=relaxed/simple;
	bh=eh+it0zb54ufEP/JnblEMEpySL7Prj/F5s/H28111ro=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=EHI5Ax0s2HTCMCYny/EKiEgXZ/Eapk2iUmCJv15RVJHsPdfQiMUtqp5Hi3uReAddPKEY7vU4uu0m8nCxrGJwmyb0gOSTIs4lN1cSFU4DfMiJA4ZS/KX7jZOs7+ZDD2a6o8qxcB5iYHrzuMO5dFrA2TUixLY3EmOQ6VCiNWsi5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=BApmi94N; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="BApmi94N"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90d7fa95a58so12990956d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1788377687; x=1788982487; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=BApmi94N0haia63+fWtF0lO8gtf7CPbnhyiBUjO2IH+nYwAJb4uJXYRK7Cr6JJKpFk
         YxGptCgPyiA1YZmnPhS3FOGlqVAlbkwTb/eVF5NtLCuLuSICFUx37nq/Nns4yNA2zgH0
         CFYc13B4d2J1cC4nKVeZUp+yNmFJrn0DoYd6ScYOlVDpCIQWM8wV9IJ51HJQi6KW+GVF
         nI2FzCFnKFMfXHpWkki8P6hmZ4q8a2BhC/Xez0+PIPWLa+R4Uc0B91tXHiwfcP+6AsP1
         FRMH/M4HjtVOxsSROaRN5mJYZjmLY8FnTjlOzEo1VRpzChFgoAHEReRUhVrJL43U/Yma
         Kkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377687; x=1788982487;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GJ6syoQl7zUGKH+u6+bqTcHjjLcFH2wSt0NVpBp7lDc=;
        b=s85cS9K5UNFTHKF8erP8bnWjvL5uEZ+Kx0uBkDM1xu/P0lPJPxJnvnFTwZ8rtPHV79
         f/ssyWXkMPhrnpEKyQUpmIjfsw7vTLJobLuswqT8w4/dgMN3LznlpMNYh8+zdM0l2IsD
         9Sh4BXMTvtICl7G3SCdLuw20/wxbK90ohwLbbTZBQ9AKY9EXducUR+OA80R+0DUyhRIJ
         SN9CiKEiHbJ46HxT67XDQE6NtCJhJE0BC1JXTERTkcprpm0YNpgisEosfC0AIsi4ycCV
         cYo6ZZYQwKItkaJOz+/ZC7X9YTH5AHNft+X1zFoLrB3sVOCNdDsqRJtQhseh9QxKdjHS
         SK4g==
X-Forwarded-Encrypted: i=1; AKwUvBxO0F9L+oZJbKucrVuy6AkmF8gS6YCbikrQvdcwOKey9R7XsEKEws50zAlhyAcr168co63H7pyU+fCR@vger.kernel.org
X-Gm-Message-State: AFuF++n1ZJWoeHhlMz7CoIpTF7BgWD0sutvlBy2VSKTvl5fwQVAgHcNv
	32Ee4HPHP2br1QPQ/nRdldP+bqDLEBCv2Ktf0KEDBdF05Li7iHU+pmun/qhMXhe3Ww==
X-Gm-Gg: AYBFou2SjBiuWYVmmUKEr6EUnrgHaRrNrJmuBu3Aspl9TMcK6dzA+vWkom4mTbdKGYX
	3ulem1vFX7Eee2TsWOUch44+vpit55YoCyOeqvyFL8louBIt4o+q38UebXMnClRAL1PlOUIN0iC
	ekPC3UVrqwEjy/3ucKo4yGwHnSKUEN1G4VPRxfdVbB7pIxb8klgO1QCwCNQXKgqj/FoP5AOhKv+
	NvRaxO6I8DbjXJMwZqnDP7yc2j6YcN6mz+RR2v6WXd1GEdlpjeF8+kiUWDi/geo0DTWV91i9tIv
	uD5sCeREB68kUvVJi1WXNns/kkup3BblGpBZKjcQvigVhxC4oHJxPHuyqQ0pJAAg4nPfPV5PpU0
	sj+o+CA752IuCxhQggjJMGml+/t+iXv8LRmp9RuJRBwICEqTrVFH73JvtQmSmaumFmAxcucrHIa
	NPmYrrxcrTLaTt+lJv3yfQg9+qoQsfXmn1otnir57HcNuXh0/EGN4PbnVZmHYH1j5gb0eDf6R2Q
	ZxoS+PEC3GvpYKJt43mW9tVja4OAFvYSA==
X-Received: by 2002:a05:6214:e85:b0:90e:7de2:d81f with SMTP id 6a1803df08f44-90ebabbac8emr90744936d6.20.1788377687526;
        Wed, 02 Sep 2026 12:34:47 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ee08710sm25176366d6.2.2026.09.02.12.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:34:46 -0700 (PDT)
Date: Wed, 02 Sep 2026 15:34:46 -0400
Message-ID: <e266759fa7a20e9620b16c1b5a717744@paul-moore.com>
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
Subject: Re: [PATCH 11/27] fs: port acl to const mnt_idmap
References: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>

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
>  fs/ntfs/ea.c                          |  4 ++--
>  fs/ntfs/ea.h                          |  2 +-
>  fs/ntfs/namei.c                       |  2 +-
>  fs/ntfs3/inode.c                      |  2 +-
>  fs/ntfs3/ntfs_fs.h                    |  4 ++--
>  fs/ntfs3/xattr.c                      |  4 ++--
>  fs/posix_acl.c                        |  6 +++---
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/posix_acl.h             |  4 ++--
>  include/linux/security.h              | 16 ++++++++--------
>  security/integrity/evm/evm_main.c     | 10 +++++-----
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  15 files changed, 43 insertions(+), 43 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM, SELinux)

--
paul-moore.com
