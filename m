Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9FC13D2BC;
	Mon, 24 Jun 2024 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719241059; cv=none; b=l33OpUFeMbH9YUBlZY8MfUjYoBVwIv/+cYcBjmvFAcuObiYYt2O8Ao42b1Mng7koh99JcDkwbaFoBC1Bojbj7IubWMLJSXqKaXqLMLUKuPHh0OfvIol46teOOUjYFf6jfFl9miAnKmTkKFgpVgLA5mncjEVVElOvIBhsre+zJMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719241059; c=relaxed/simple;
	bh=ljl4E6hHkXcMr5/gqOWCW0aJytip+Bwdtu85glYAFNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQOSKGKx9sujjNynZ2esaNLH3rGBrlRSItp8X76E0dm/cjtut/SgHz1odIEzE6BTU1zdnr0G6A0j1bmNoysSovHp0VtvirKqoVOuN3PaULqXggwtaZiMsWvYePD/EcHNxKFsvdSplRhJ/lOiieK6nqlEaGR/WzbxQaeQKowwH9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWmzbYYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWmzbYYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18507C2BBFC;
	Mon, 24 Jun 2024 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719241058;
	bh=ljl4E6hHkXcMr5/gqOWCW0aJytip+Bwdtu85glYAFNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aWmzbYYyMSrUyBwJpLriAK1eAsJj2dgWzglqCLfwJmQY0k/HfghoLLc7DirX2CV0i
	 U4PHd4QAt2NOd3HlQLw+nToX2BTdu6aFeyn+IBNjYj58CObODR588X23+Vkp11ZBwd
	 lSVv85Lud3NnmCNmwC56CO2YQytM38aJF6XGMcAQ=
Date: Mon, 24 Jun 2024 16:57:30 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yang Erkun <yangerkun@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	dhowells@redhat.com, linux-cifs@vger.kernel.org,
	stable@vger.kernel.org, stable-commits@vger.kernel.org,
	yangerkun@huaweicloud.com
Subject: Re: [PATCH 6.6~6.9] cifs: fix pagecache leak when do writepages
Message-ID: <2024062422-imaging-evaluate-3f85@gregkh>
References: <20240624042815.2242201-1-yangerkun@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624042815.2242201-1-yangerkun@huawei.com>

On Mon, Jun 24, 2024 at 12:28:15PM +0800, Yang Erkun wrote:
> After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
> writepages for cifs will find all folio needed writepage with two phase.
> The first folio will be found in cifs_writepages_begin, and the latter
> various folios will be found in cifs_extend_writeback.
> 
> All those will first get folio, and for normal case, once we set page
> writeback and after do really write, we should put the reference, folio
> found in cifs_extend_writeback do this with folio_batch_release. But the
> folio found in cifs_writepages_begin never get the chance do it. And
> every writepages call, we will leak a folio(found this problem while do
> xfstests over cifs).
> 
> Besides, the exist path seem never handle this folio correctly, fix it too
> with this patch.
> 
> The problem does not exist in mainline since writepages path for cifs
> has changed to netfs. It's had to backport all related change, so try fix
> this problem with this single patch.
> 
> Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
> Signed-off-by: Yang Erkun <yangerkun@huawei.com>
> ---
>  fs/smb/client/file.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
