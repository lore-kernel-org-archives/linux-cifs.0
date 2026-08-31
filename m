Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5E43C9EF6;
	Mon, 31 Aug 2026 07:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788162914; cv=none; b=A37A6TCCNIeBorCR4Csk++LcSc0i9aMSeER/34U1yNOjta7Ce/cyCo3bE7jMIT/juojQutxINcatyNgCK5TW9nSkhs51nOk3awfQTsKStV/10V+uFU2bbzMTS608gSKlz+8or0jo0hWFKm3chFMDAmBzkWi4vXxoavwSHyhbDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788162914; c=relaxed/simple;
	bh=XS6MnXjdLgN+IYhhFCbdkHwuEbPjLdRgd8mBHzowrsA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=al6XHs5fVzKhLfnNCFkzoc+91KwDoRC8v/7s5+1q9ThnLHZv3JVny2tfo5TpMg1Vj4eCCXJZ6kcHmv7iehKcIw4sF8oNvQZ8wMSfSyJkKuXBvJjY8W7Jko7mBc2/4EnQIhAScIAel2SikHlQjzI0BiMCD0D6K074N4giQWOrvTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4rqbM8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4rqbM8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF1F1F00ACF;
	Mon, 31 Aug 2026 07:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788162912;
	bh=1TPnEmDnniutV5HQvwxJTUXw2WVcmYP9OzXkFa4bSgg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Y4rqbM8YB6nCBdyUlbKEcz83EeJavjEKEBBRMR2B+C7ErWntMg+z3CmM322SjjLSn
	 DA8fDWEBQ5wYwCThDMMDt+DosdzIyDSaQwR1+zDBvzj9XfmagYUW3/985rBoOWMRyq
	 /qz+ESZitATPcdEaOcKx1vBaQoEDu7W4ZHeYe5YE0T/qmHANVxTft7pvBEwkWXo7X7
	 /xf59VmTdPhh6QJymzMjgdliilE7+9yuIHtS+WH3sGRrJskpEEssyBSwAVOigzXjwN
	 rSiXLMeexpgirZhC6AfqEUQ+V6nP4wmCPjBl/TJNVZFR/wsWPHI7Zu0aAwosaLjh6R
	 SEJkbZ53rtGJw==
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev, 
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
Subject: Re: [PATCH v4 00/10] netfs, cachefiles: Miscellaneous fixes
Message-Id: <20260831-tabuisieren-flugobjekt-stangen-0dd7cf160bd3@brauner>
Date: Mon, 31 Aug 2026 09:55:06 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2075; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XS6MnXjdLgN+IYhhFCbdkHwuEbPjLdRgd8mBHzowrsA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNNY7bJpSvk1b096VIscV85iNXdwV7cIjfrRLo2b5mh
 7Dtlv3MHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZbcnwV1DnULdcyBTnjear
 eq4EzVRZsu6R4v8+e5PLq6YWz9/V/Yfhr7im1gm/vukeSR1ZJ+1ry1+dvTTtd8iq0L2bshba9a5
 NYQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 27 Aug 2026 14:42:53 +0100, David Howells wrote:
> netfs, cachefiles: Miscellaneous fixes
> 
> Hi Christian,
> 
> Here are some miscellaneous fixes for netfslib and one for cachefiles, if
> you could pick them up?
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

[01/10] netfs: Fix uninitialized return value in netfs_unbuffered_write()
        https://git.kernel.org/vfs/vfs/c/f18e8774f4d3
[02/10] netfs: Fix unbuffered/DIO write partial transfer error return
        https://git.kernel.org/vfs/vfs/c/c753a33664e4
[03/10] netfs: Fix error vs transferred passed to ->ki_complete()
        https://git.kernel.org/vfs/vfs/c/0bfe2571a6af
[04/10] netfs: Fix i_size update for partial transfer
        https://git.kernel.org/vfs/vfs/c/741416a8003b
[05/10] netfs: Fix subreq ref leak
        https://git.kernel.org/vfs/vfs/c/3c30087e2759
[06/10] netfs: break unbuffered write when netfs_alloc_subrequest() fails
        https://git.kernel.org/vfs/vfs/c/8fb45a934661
[07/10] netfs: Fix readahead synchronisation issues by loading all folios upfront
        https://git.kernel.org/vfs/vfs/c/fed0b33e6c58
[08/10] netfs: Mark folios with COPY_TO_CACHE whilst issuing subreqs
        https://git.kernel.org/vfs/vfs/c/533203c41831
[09/10] netfs: Fix read progress reporting
        https://git.kernel.org/vfs/vfs/c/e00827a4d0cf
[10/10] cachefiles: Fix potential UAF/KASAN warning
        https://git.kernel.org/vfs/vfs/c/a67632c8c268

