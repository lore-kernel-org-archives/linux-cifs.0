Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0321B4F09;
	Tue, 21 Apr 2026 11:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776772601; cv=none; b=ikV4GcrYzGkWRIjQd15ch6qBJdgh8FBzLR9CWLrONUreVsigodMORZ983O1EzlowlyoaxjgrBKOWEjxWl1yFEfsGW93bs99oRFKy0+MVxRqkxQ6hgkVBvxUtXfb6e1tKMzGhd8fvw2/x+eis8iPyiY0aQrirXiiYr/NFuDb/tnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776772601; c=relaxed/simple;
	bh=MNJPO7cGXFv8GlOOyNtbzfLCDQRkPcX6aOvPd5gkUcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJkXPGEwe7OvU7NSrZpJo4yNj8h1wDRIjvOfo+V3a9WlG+NOgAFZPvV4lY/SE/dafXBDvf7RFz53qoYwpNzZR39+Z/foS9Kfts2s334oukXrwBheIKU/kL0R7LCaqEh7gnMgnPT9YdMuFXG3rcz79+bEh8MDDUtMsUL4tSKVrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGlM0WG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGlM0WG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98459C2BCB0;
	Tue, 21 Apr 2026 11:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776772600;
	bh=MNJPO7cGXFv8GlOOyNtbzfLCDQRkPcX6aOvPd5gkUcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGlM0WG0IV1Y2AfP8OIhIwO55cOroMm7l6xyg00zRkIx1i1ezI2am9p1um0kY6ln6
	 jBjVBuv3bGOm0XWAkq9s9Su3N47zXkTPCsGTqpcT2LqVZYUsJSTmb1C44tEkTE3PRp
	 6Pf4QW1sknOFR1OgRp0LtRlsvX2OahM1OQfBFBVVh1/1OAoW7FB0sK7OrdIWCtutJr
	 eQIZVNMJCXNBk6Ja5duuH7UHZ8HmL56Vs12bp2goPj6MWwmWQupMVaIvJW5qq/yiNw
	 MqFJLKsa+EjwKUbkpadlIqkkfHifbteYaEEJh9UIv3ZerehHtcaDWxOnss78HDP4GU
	 dGYRde56ItGuQ==
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] netfs: Further miscellaneous fixes
Date: Tue, 21 Apr 2026 13:56:32 +0200
Message-ID: <20260421-matschen-esskultur-6ff56a239132@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420083705.1009074-1-dhowells@redhat.com>
References: <20260420083705.1009074-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=brauner@kernel.org; h=from:subject:message-id; bh=MNJPO7cGXFv8GlOOyNtbzfLCDQRkPcX6aOvPd5gkUcU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ+T/20TeLYXq2kFW/eXImKej8/Od+73EpPMMXl9LUfL HfmMuqEdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykXYWRYcXuI2cnZlt6/Fwm byR6Oe3gHLbala8+eF7mjJdb0LR9azcjw6ymo2KzpvOcaGtsWR9+/uTPoN8Tdu56VZehasC6iv9 XMwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 09:36:51 +0100, David Howells wrote:
> Here are some more miscellaneous fixes for netfslib, found by Sashiko.dev's
> AI review[1] in response to the previous miscellaneous fix posting[2], plus
> a repeat of another patch you haven't picked up yet:
> 
>  (1) Fix an early put of the sink page used in netfs_read_gaps(), before
>      the request has completed.
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

[01/11] netfs: Fix early put of sink folio in netfs_read_gaps()
        https://git.kernel.org/vfs/vfs/c/9d17365ee50d
[02/11] netfs: Fix leak of request in netfs_write_begin() error handling
        https://git.kernel.org/vfs/vfs/c/453f1cc34a8f
[03/11] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
        https://git.kernel.org/vfs/vfs/c/b712de212717
[04/11] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
        https://git.kernel.org/vfs/vfs/c/3a6ca6bbb857
[05/11] netfs: Fix partial invalidation of streaming-write folio
        https://git.kernel.org/vfs/vfs/c/6fe333abf07d
[06/11] netfs: Fix the trace displayed for the total overwrite of a streamed write
        https://git.kernel.org/vfs/vfs/c/b7a4cdd022c4
[07/11] netfs: Fix folio->private handling in netfs_perform_write()
        https://git.kernel.org/vfs/vfs/c/49f3b040e222
[08/11] netfs: Fix group handling in netfs_read_gaps()
        https://git.kernel.org/vfs/vfs/c/ab763d6514d4
[09/11] netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
        https://git.kernel.org/vfs/vfs/c/756f72b6d8db
[10/11] netfs: Fix comment about write-streaming avoidance
        https://git.kernel.org/vfs/vfs/c/f81dc0987b3c
[11/11] netfs: Fix netfs_read_folio() to wait on writeback
        https://git.kernel.org/vfs/vfs/c/c721f7b7992c
