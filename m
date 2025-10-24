Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF557273D84
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761318285; cv=none; b=Czp7mW8Hl4yV2GbEyZNojP8QWbyt+zyIQD6h/LOuMWGmoUbehPN8Bl/s+q3ISETLFH0GKyv8iq+rS/a8uRPPgItonbIHrALegGEuO2IxYxWmuhEGg8162HoYMj0+8DpqEd5I44b79A5JQx1u+wOkynalSknmzfEqMNVba/ortIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761318285; c=relaxed/simple;
	bh=zfVGScX21Uymrm3fFC5oA9XB60VQzBMJiR/inSj9KDo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=l86XDIpVN5gri3GfYbGAAzwqFgNOdOyU0vEMpC0sM5xSUUF4yFwhEYTLX3HU2tVGpULFmnvEtdNja1V+xN9biOoBCOlBJvniN34oboL1J3gkHQOHDOQ8FP5NdPk5pphlCPMX4P020o0pZKlVJh1CeA6IuIGkRbtBiEeOUKQfiXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=a+ayQRXP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="a+ayQRXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6BTA1bw07oVECFdl97GHrSXczsGi470tIMiugw6WcIk=; b=a+ayQRXPHlXgIW+2xoTK8eh6NO
	R3KOeMDj8924kdVJqIBnd80tVLnisrkE/77Xt25Hy95V/qNxYbm2VNVPYKBOavhswjpAAoOw2DujY
	XoD4k99cw9daPBNUhIULPchu4fohqOcPbEgST3yCIOrx7aThtA5KOeRBJFgKHECGNbCQaivGOllgY
	jySDLr/joSOaogcT7dFpatbEirN2w3xMQZBwFoBQKfFvOjqPJxxqbPa6y500SMjnzBXYC730hrscE
	I78S+nfDg+zF76kgkytuz+BtdqT1jX/P38tm/K8XcKGOUC4Di8XyofUaJNHcMjg8FdcDW07luWlkz
	yZGEePxA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vCJLL-00000000J8v-2CXP;
	Fri, 24 Oct 2025 12:04:39 -0300
Message-ID: <1e79d87961ffb6ca90c46067a5b79213@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Shyam Prasad N <nspmangalore@gmail.com>, David Howells
 <dhowells@redhat.com>
Cc: smfrench@gmail.com, Anoop C S <anoopcs@samba.org>, Xiaoli Feng
 <xifeng@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix cifs_close_deferred_file_under_dentry()
In-Reply-To: <CANT5p=oXTjGTfDffYwvHkZ5g32C0QMzitthbBdk0R5XJaM=Gzg@mail.gmail.com>
References: <20251022234321.279422-1-pc@manguebit.org>
 <1837802.1761204083@warthog.procyon.org.uk>
 <CANT5p=oXTjGTfDffYwvHkZ5g32C0QMzitthbBdk0R5XJaM=Gzg@mail.gmail.com>
Date: Fri, 24 Oct 2025 12:04:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> AFAICT this would just be a problem only for __cifs_unlink as it drops
> the dentry before the call to cifs_close_deferred_file_under_dentry.
> Why not just move the call to cifs_close_deferred_file_under_dentry to
> before where the dentry is dropped?

I don't know about __cifs_unlink().  The problem was originally found
due to d_drop() being called in cifs_do_rename() to force a new lookup
on the moved dentry.  The "smb: client: get rid of d_drop() in
cifs_do_rename()" removes the d_drop() call, but that is unrelated to
this commit.

This commit is to simply fix the filename lookup without risking of
causing any more regressions.

If we want to go ahead with optimising it by matching the dentry pointer
directly, then let's do in a separate patch and make sure that it will
always be called with a dentry pointer that is expected to be found in
the list of open files.
