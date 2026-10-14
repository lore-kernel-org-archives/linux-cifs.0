Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6003F788F
	for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2026 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019197; cv=none; b=p3cL+rPqDyLyLPBsUQUWyGWlV01VV+TCT3l3usOMJwWhfEkJEuXKCcBDp7JjVa04l9QxDchuAty2D/sobaNiUT7NMrMsM1ROSFBFgWIRLMWyjwTickeZo+aCP3pNhYQ16FHcHv2+lbJiBd9JOokfQwDnk56KFXVNIzxb/JQIqoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019197; c=relaxed/simple;
	bh=O3kcsc/wjAUCWA3m+n/j7qbPuWuNMx8KaAafTLFGOL4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JHIMlxheUwYXkHtfFnBeRCN97VLgkMccgmT0WXQuwFF/ozhuJ+s+R4Uccx0pXMEerCkTotSTRIFaOB1vu7WI32NtWaVcofRnhIt6TGmyl8S5QZAs9sFakbLovpPccfcN0hNwqxQd5CWyWB+I7Azc69HCpni5oaoN5CWXyRJ+wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=bDqd5PDY; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="bDqd5PDY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=93CWaKi/vVBe/kVNvqhlUkzqitBYlT3JTTO72+6OCKY=; b=bDqd5PDYAy73YTo3mglJES3GYa
	MCKN4pFuNCIK+RCD2LjA9Jj3dmR3OKRUChOz+Nq26UVI2bsQCSRk8Vw+mL84tTkbKaeImh+iB77yi
	fmASaofIHvQ9wz5X8GPDKLKAsC0JBNvUTx97wazL2QoAGI3sYFbZn5ALQvh8YVA8i4O6lt3S9n3vA
	gaSWyDCFntsRn2gM/tDQMeozfpHmhrdDjJ5+A5DQDnyyxypGg6cEzghS+YnMnLBCufnHZNyttGKmO
	f++p8/tSfWq+rZzBAcVN2a0IMywg8AXk0u8EYkaReQH9jGSyjTcRQ2xm8PiCJRXrCy8lGLko/51SL
	hAkRDjPw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xH839-00000003f9n-2p0n;
	Wed, 14 Oct 2026 20:06:19 -0300
Message-ID: <adb08c60bb8da380fe105c5b9aa4331c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ren Wei <n05ec@lzu.edu.cn>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, jlayton@kernel.org,
 smfrench@gmail.com, bird@lzu.edu.cn, rakukuip@gmail.com, n05ec@lzu.edu.cn
Subject: Re: [PATCH 1/1] cifs: fix buffer overflow in SMB2_tcon
In-Reply-To: <0f3d431d65a5f46c0487293d127e748775ca85b8.1791865501.git.rakukuip@gmail.com>
References: <cover.1791865501.git.rakukuip@gmail.com>
 <0f3d431d65a5f46c0487293d127e748775ca85b8.1791865501.git.rakukuip@gmail.com>
Date: Wed, 14 Oct 2026 20:06:19 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ren Wei <n05ec@lzu.edu.cn> writes:

> From: Luxiao Xu <rakukuip@gmail.com>
>
> In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
> MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
> UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
> destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
> units.
>
> Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
> length check on UNC mount options, allowing mount paths to exceed
> MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
> SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
> to write past the end of the heap object, resulting in a slab-out-of-bounds
> write.
>
> Fix this by dynamically allocating unc_path based on the length of tree so
> that it safely accommodates all UTF-16 code units.

I don't think we should allow SMB2_tcon() with a @tree more than
MAX_TREE_SIZE characters.

With your fix, we might end up with a truncated tree name set in
cifs_tcon::tree_name.  It will work in the first tree connect, but if
the client needs to issue another tree connect for some reason
(e.g. reconnect/failover), then it will fail.

Some places rely on the tree name not having more than MAX_TREE_SIZE
characters.  I'd rather return -EINVAL along with an error message in
SMB2_tcon() if @tree exceeds that length.

From another patch, we could also add an early MAX_TREE_SIZE check
against smb3_fs_context::UNC in smb3_parse_devname().

BTW, mount.cifs(8) will not allow an UNC path that has more than 1024
characters.

What do you think?
