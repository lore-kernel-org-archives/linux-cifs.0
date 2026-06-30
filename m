Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E73140D580;
	Tue, 30 Jun 2026 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810093; cv=none; b=GjWtqglEtU72LCAOHloDZv/dv1F2iSJvqYbZtPkZXJSE2mWN720WtJ+KZX0ZKpug2DHMZzDXisM7OiySRsp8HPDLflProeQFK9jm9LZBRr6sfObvWHF0rmDfSS5O5/gKnM4MxTUYYgeFK9AfHEGYxGlGmEHVxmAsUWePF7D4SmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810093; c=relaxed/simple;
	bh=x6N9r4hpID2SJXcF8H5ekm/xAhkIsEfdhtqQU8KStqg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KJzCZjk1oytz/GjL36fo/bnUa6doLHOmwALpC33720DztIVtGk3y9eTy6INLEm7DBzmn+nypFF8Qlv+iSgIqxvieoPqiQkN/Y/S8wDFnHJkz3E3AOnXtcXRGc9BCeucb6+iKbD6rjLHj3xZPXGsUwk5UWsUi0aSpkoCh5il4wYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrkbnWVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrkbnWVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A683F1F000E9;
	Tue, 30 Jun 2026 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782810091;
	bh=Q5aVqG1ipIItOhc6JxQQpp1/Z+pIgYL49qEtUS/ClnM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nrkbnWVwznNfPveYDwBpblXkK6ugse6XsElE/1emGBXlVDiiBC2I5oBB7lhnD38M1
	 ls7FUPmfXBrLlhevSsS/PkLpwt2LZOyxyY6Axdc0pEfuYL5MtHi1BakksJ4a7S6uhl
	 TAGkH+XC5lktvRfrpZZezw6RHtRJOjt+8fl2tTJ1u83lumNGMBJpX7L3hD290/XzZK
	 D15GHXNsUn9/svVQQOQPF8NMry7KdvtFHgsrRzFVbQv2c///pNmMNzqlIEYfkj7okI
	 1XbpYPLfBvyQ+dZS2H21kUdcJGVtC0pPvNngCZ3/IFYJOxMFmk7BoRQvWhU0DIXhi8
	 0kx36hP/TUx+Q==
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, 
 Christoph Hellwig <hch@infradead.org>, netfs@lists.linux.dev, 
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Subject: Re: [PATCH v3 00/15] netfs: Miscellaneous fixes
Message-Id: <20260630-exzellent-liege-kommen-59a9e0e7e2a2@brauner>
Date: Tue, 30 Jun 2026 11:01:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2770; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x6N9r4hpID2SJXcF8H5ekm/xAhkIsEfdhtqQU8KStqg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5t77c0+ZTxXw+bY1B9jmpx+n27o2z2Q/scKp8ezT3E
 WODy6kvHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNh82Rk2DCJV+dfS/sy62cd
 zFPfhtbdcd5bYjjr4o19f1p67/gxJzMyvH+lxM1w47B619RZnY/WTIo+6OfzfOWs9Po3c6+dMnA
 qZwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 25 Jun 2026 15:06:18 +0100, David Howells wrote:
> netfs: Miscellaneous fixes
> 
> Hi Christian,
> 
> Here are some miscellaneous fixes for netfslib.  I separated them from my
> netfs-next branch.  Various Sashiko review comments[1][2][3] are addressed:
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[01/15] netfs: Fix decision whether to disallow write-streaming due to fscache use
        https://git.kernel.org/vfs/vfs/c/61c79e2cac37
[02/15] netfs: Fix netfs_create_write_req() to handle async cache object creation
        https://git.kernel.org/vfs/vfs/c/f43e809738d8
[03/15] cachefiles: Fix double fput
        https://git.kernel.org/vfs/vfs/c/4c6fe3b4ba06
[04/15] cachefiles: Fix file burial to take lock when unsetting S_KERNEL_FILE
        https://git.kernel.org/vfs/vfs/c/f1ef918f8183
[05/15] iov_iter: Fix potential underflow in iov_iter_extract_xarray_pages()
        https://git.kernel.org/vfs/vfs/c/72c00e84e611
[06/15] iov_iter: Fix missing alloc fail check in iov_iter_extract_bvec_pages()
        https://git.kernel.org/vfs/vfs/c/eea815a087cd
[07/15] iov_iter: Fix a memory leak in iov_iter_extract_user_pages()
        https://git.kernel.org/vfs/vfs/c/11cf15dacff6
[08/15] iov_iter: Remove unused variable in kunit_iov_iter.c
        https://git.kernel.org/vfs/vfs/c/8cb836bfb87d
[09/15] scatterlist: Fix offset in folio calc in extract_xarray_to_sg()
        https://git.kernel.org/vfs/vfs/c/132e70406412
[10/15] netfs: Fix kdoc warning
        https://git.kernel.org/vfs/vfs/c/46163ade2426
[11/15] netfs: Replace wb_lock with a bit lock for asynchronicity
        https://git.kernel.org/vfs/vfs/c/1b157b933689
[12/15] netfs: Fix writethrough to use collection offload
        https://git.kernel.org/vfs/vfs/c/6ed47a3ca47e
[13/15] netfs: Fix writeback error handling
        https://git.kernel.org/vfs/vfs/c/70d669edd0bb
[14/15] netfs: Fix folio state after ENOMEM whilst under writeback iteration
        https://git.kernel.org/vfs/vfs/c/a009d3cfb306
[15/15] netfs: Fix DIO write retry for filesystems without a ->prepare_write()
        https://git.kernel.org/vfs/vfs/c/b43370a12abb

