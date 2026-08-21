Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F26493643;
	Fri, 21 Aug 2026 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330875; cv=none; b=V5SXnmsklh9yQF+MqXmH5ncPQz/9J99ePO+lH8vTBcf3d+TY5QdfgkVQIYDWCoycJ+nsGD6pdNysTBdg6bljprZcA7HGOYsW6dEXwHgHcNg1NoKhTpVcZiampp1LjkxNA8AGduHQuPXE7l4l4zpyqCybdRu1Qmcq5WdRDBnjik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330875; c=relaxed/simple;
	bh=z2ulub9dl8THI2owkOVjoaL6xhY9CbVV0Fk0tHOZiJo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ZYgHa4PMd6fq+Jn2b5wPOlhpMYuw+0c8TbUGuXW9QPtx9GU8dp9EdwINuqMZFuBr2bKDgOXXMtWggxqs9w5l6wfsvfHXi8fBXV4X4u0D6uwxAJGcThMsWCv3cX4L7DYCdYLJE1lx0jE33uySVkAC8Jj985Ar3NZDlqHtGenbldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=0S/mbdek; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="0S/mbdek"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JKm4YX0Sqba6IPbbN5YY9Mx6kuql9H2JQdt3dH6Ixfs=; b=0S/mbdek9+frFNgI5PuZDYeg/L
	bR6Sqr01L9KUBGOnu+RSQszPG164dZGuovJ9qrjyKibmbIFU4++Kx9zaV799c3UQjFyJ3MOPxcS1a
	62p9w3k5PLS4iNxlxiB7PfC49o6gw+TLu1F0h417zSv1JBSjL2ZLk11Hm2wY0CBFYifejVSxvX7sJ
	4XAkA9r/UHzPT79PbB+Vq3sFxHBwa6zCFRp/0KgJS7mxFZwN8p4vF03GTsXt71hsSy/+jF15cAmTm
	XYeDsBn1bBJGMgr+E0/97cvmEAAU85X+rLoi+508wRnrkgFVnL19+FArQ2MLlFRghXY0Vx75eeda/
	+12/btNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxSPH-00000000Pet-1Rrh;
	Fri, 21 Aug 2026 13:47:51 -0300
Message-ID: <7bdd71d4092fe74f58bedc74e0e316f9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 stfrench@microsoft.com
Cc: stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: [PATCH v2 1/3] cifs: clear tcon after cifsFileInfo_put() in
 cifs_file_set_size()
In-Reply-To: <20260807024158.3707995-2-sorenson@redhat.com>
References: <20260807024158.3707995-1-sorenson@redhat.com>
 <20260807024158.3707995-2-sorenson@redhat.com>
Date: Fri, 21 Aug 2026 13:47:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> When the else branch of cifs_file_set_size() finds a writable file handle
> via find_writable_file(), it borrows tcon and server from the handle's
> tlink, attempts the handle-based set_file_size() RPC, and then releases
> the handle with cifsFileInfo_put().
>
> If set_file_size() fails, execution falls through to the path-based
> fallback, which reuses the borrowed tcon and server under the
> "if (tcon == NULL)" guard.  Since tcon is not NULL at that point, the
> guard is skipped.  If cifsFileInfo_put() dropped the last reference on a
> tlink that was already removed from the tlink tree (TCON_LINK_IN_TREE
> cleared, as happens during reconnection or session teardown),
> cifs_put_tlink() will have freed tcon; the subsequent set_path_size()
> call is then a use-after-free.
>
> Setting tcon = NULL after cifsFileInfo_put() causes the existing guard
> to take the cifs_sb_tlink() path, which acquires a fresh reference for
> the path-based operation or fails cleanly if the session is gone.
> ...

Applied.
