Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAAE4A206D;
	Thu, 17 Sep 2026 09:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637743; cv=none; b=oaIk2TV+iT9fMgxD7HxqPmc+RoerSZCb4lDIY/3ksZ8pdsRkAt5B+QUiu9vPVpRQlSimBRvrC3FWu4pBv3bgQRin3uJi7XQDhgBDGW28A5X5rMRIm3JQJzl04eilgG5DArgoitNlXw9H/u2B0GW7OvpszWPfQSK4SoAS+V/5e3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637743; c=relaxed/simple;
	bh=Pziy3GyxVaLVNQGPnPGUWY0b4UTr67i47uVByFhvx/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OgRIwb9s1aKyzPedhDWMTUYygbo+rKJus3EXCLLnBPvkDm6zP/6uzUeTNtk5U5xzuNt65DUVLxG/V+YL4eJJ0eglFX3eHltR7wwmhGv+lHUKn8Mt4BuOJSQsEFHdGo4VYCl7LsXHoBSiHxIVtI7kqjlB8DQYaNXYgwPhfGpVKWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nuDHQyhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nuDHQyhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B080C1F000FF;
	Thu, 17 Sep 2026 09:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637728;
	bh=y3Bksu4nsuzmvX3mOHjIHS2i6H1vZRzqxHYcTA5sqo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuDHQyhY1tFTfXzEcitVxdNcIWBaKVfVhqNf/PPt6+RICZxO4y9vXAo15zeRHhez6
	 ZYVtQKn8riSQngpHGpuvoqTIMQxO95EUJ/hKjGCAHck4llBQZhW1tq21dhIBWkcvAP
	 /nTO/yOm1UgB303s24+yuGBfuCNIwlsAvMX5mookX/A0fGLQpCzs7pOzWc0r0+T1u5
	 UZFgKi5Vwb4PDZOKr4oWG+LRz5ColAj14EU7RTeDMkD00mm/XRdvYXIakeaRD32e+E
	 LWkp6xawGWqxVp5lQzX8rfxwm3Cc8s75wy9erACQQTK5tB+1SB72DqWFqQUpQdsVsZ
	 xl6dVuwb7jaFw==
From: Christian Brauner <brauner@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] super: make iterate_supers_type() deletion-safe
Date: Thu, 17 Sep 2026 11:34:54 +0200
Message-ID: <20260917-ablegen-mitgearbeitet-syntaktisch-7dbfdb681783@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909193034.7467-1-kmehltretter@gmail.com>
References: <20260909193034.7467-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=brauner@kernel.org; h=from:subject:message-id; bh=Pziy3GyxVaLVNQGPnPGUWY0b4UTr67i47uVByFhvx/4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3hLFzhMTtFnpRn7DMd7l9c+VKrU99n28G661fVJMq 0jmK7/vHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMxkWT4X5fjxsGZNO+VcuFb u3XX61ad4DNzm3PM0a747vwlH2aeFmJk+Nkyc+EmlSO6/t079R8bFU92u+/huVxY1m7LnWMBVS2 OnAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 09 Sep 2026 21:30:34 +0200, Karl Mehltretter wrote:
> iterate_supers_type() drops sb_lock while invoking the callback and keeps
> only a passive reference to the current superblock. That reference keeps
> the object allocated, but does not keep its s_instances node linked.
> 
> After the iterator releases s_umount, final teardown can unlink the current
> s_instances node. The iterator then advances through a reinitialized node.
> With the current hlist it stops without visiting the remaining superblocks.
> The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> the cursor lifetime has been unsafe since the helper was introduced.
> 
> [...]

I'm moving this into vfs-7.4.misc for now but will bump it to vfs.fixes once
I'm confident this is safe.

---

Applied to the vfs-7.4.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.misc

[1/1] super: make iterate_supers_type() deletion-safe
      https://git.kernel.org/vfs/vfs/c/d1ac530407a3
