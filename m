Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3DF1F8755
	for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786297262; cv=none; b=irMHKl6P3ALKXHm4QFZwKAioDXmuzpX6lwFYr32vKlcsSXEDyvVQXXGrcmM/1vB6kIUnTeZp9Auvz+jL9y5oAH5HMaVa5rZghkc7mp4Zt9D0A+7rczzuY9hSXps99mLFKwSpfv7JaaRwGzK6cD1eKOgMMVDiJnmCSySQ2+WpOPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786297262; c=relaxed/simple;
	bh=SZ3qEnmVaFaNZO/wl4tVKSztBWJ9sTYx4AA6tyGczYE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WcDG+CGnEZ/aonpMFzeRyu9hFQor0n2GQqomTorIRuRyLwMwDw5lpn/wgsNsCHRL0H+LxXESqZesjVoyF8/zo7IY7AgDEcZ/w8URnGiSUjskHHCxms/cUaDGf5aRitE/FEsD3wvD9sL6txG9Z7pUYyESO6jIGF80kXHxTr1BYzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=YdR6OrmC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="YdR6OrmC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YVd2irYh871YxHPbYBJg9z1teUrNMks212jr0KBezhE=; b=YdR6OrmCUWLuyc1LXAB3tDepTC
	BeRmhXBYQHV50l/IuF0CVJ5GwUbCFsTWe2rejOZ0W4QuTrmahbjsubVmfzAOpCBUFuj+71EgswYWS
	1uhEnsNAP/T9aJsubdMMbk9msgzFbMbXEarbZt0f3YI1Dg4QUg+hOscsQfoJP0HRUIiQrVPg1hoxx
	tK71MvM9Yugy8DV38Ukio3UTIOY6G0AQa+Hqq15kV+33oVxK5YJyyyrLzcUR7bwIfB4IkTnKnnivr
	/ffPsk5Qbe1jlZTnlwdtM+fgGehKEx6BCwmcmEb7C3OvByWNQB3LRkIoVIaAqpbhgHzF7+I3yGVp2
	IXsw8FNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1wt7Vz-00000000wSa-3ast;
	Sun, 09 Aug 2026 14:40:51 -0300
Message-ID: <d2ee4c33330379ff4a51fa090a551137@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Gustavo F N <gustavofn@gmail.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com
Subject: Re: Per-entry WSL EA queries during readdir cause severe ls -la
 slowdown on high-latency links (6.12)
In-Reply-To: <CAJr=uVQ2VGLuHqV2oYsgCxj_EkqdtJAngq8BHUgq_4iU_MNCZg@mail.gmail.com>
References: <20260805203900.2930456-1-gustavofn@gmail.com>
 <dc3725f8e227b1dc7c1bee1189806e3f@manguebit.org>
 <CAJr=uVQ2VGLuHqV2oYsgCxj_EkqdtJAngq8BHUgq_4iU_MNCZg@mail.gmail.com>
Date: Sun, 09 Aug 2026 14:40:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Gustavo,

I was able to reproduce your problem with coreutils-9.10-5.fc44.x86_64
and mainline kernel.

The `ls -la` command is, in fact, calling llistxattr(2) on every file
returned by getdents64(2).  That's why you're seeing those extra
requests being sent to the server.  See below

	$ mount.cifs //srv/share /mnt/1 -o ...
	$ strace -e llistxattr -f ls -la /mnt/1 >/dev/null
	llistxattr("/mnt/1", "", 152)           = 0
	llistxattr("/mnt/1/.", "", 152)         = 0
	llistxattr("/mnt/1/..", "security.selinux\0", 152) = 17
	llistxattr("/mnt/1/008.174041", "", 152) = 0
	llistxattr("/mnt/1/008.5301", "", 152)  = 0
	llistxattr("/mnt/1/008.5307", "", 152)  = 0
	llistxattr("/mnt/1/008.5313", "", 152)  = 0
	llistxattr("/mnt/1/008.5384", "", 152)  = 0
	llistxattr("/mnt/1/008.6320", "", 152)  = 0
	llistxattr("/mnt/1/009.6781", "", 152)  = 0
	llistxattr("/mnt/1/012.8056", "", 152)  = 0
	...

That has nothing to do with the client trying to get WSL EAs on the
files.  By using 'reparse=' mount option will also not help because it
is only used for creating special files and symlinks.

I don't know why why llistxattr(2) is being called by default when
running `ls -la`, sorry.

One way to prevent the above from happening is by using 'nouser_xattr'
mount option, which would disable getfattr/setfattr entirely, so `ls
-la` wouldn't attempt to llistxattr(2) each file over directory listing.
