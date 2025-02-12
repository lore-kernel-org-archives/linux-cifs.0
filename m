Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293F20E02B;
	Wed, 12 Feb 2025 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739383318; cv=none; b=iUOXF4oG6fb2SAtD933hTWGAg1iDJ37yM1esmqYyA1xUD6TD9+Ke0T7b3rfe7qgVlYLbjUThABNPDSF0QFROgQh1yG4m4Lg2GSREbpRltre/CNKfUWCuHt6C/Ixbkfov82kXmu/t0Lo/st7UY354L/rZrI9M0a2xsZ98etPpc0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739383318; c=relaxed/simple;
	bh=ApVjZL7R4gIKkJK0P861NvcM7oao9TZoGvth5kdN1QI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=hYS/kP78s72z5iiGB2Yw61bdZsW3BRo+olT7m+IpLrurmawAJud8zkubmkYCq2W+YYj8sgSYdepyaZ8Snnm6cW/hsNhZQrxphHyvSDXTZix7gONPEGVMkfafZgvorR+gh6Acym3YJ/GPO7DxylvvOsX0TE5z+Xfwb/w+4819ZwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gnECJf1c; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gnECJf1c"
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739383303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xzDmp7n11SXDWq7ajSDnUq46FyfKrhpeHIHAWHCUuZw=;
	b=gnECJf1cKJ5M5rm0NV6epIvN4swhWMvhk8bPz5Q9uS0EFIW2dkZiBTPUjQZ0NEcqzvBJOq
	lfZQGt6LRxQMhPn63eFx7OnBzTUmwErFPiocGe/S79yjXcM7Zbq6Oxf3AAO6CT1fXcQGn0
	zNpCUiqYtLRaoeUvCLbFpdv+c0cx1HY=
Date: Wed, 12 Feb 2025 18:01:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Ihor Solodrai" <ihor.solodrai@linux.dev>
Message-ID: <62dacb9480327bfececb60e956f18f6f1924745b@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] netfs: Fix setting NETFS_RREQ_ALL_QUEUED to be after all
 subreqs queued
To: "David Howells" <dhowells@redhat.com>
Cc: dhowells@redhat.com, "Marc Dionne" <marc.dionne@auristor.com>, "Steve 
 French" <stfrench@microsoft.com>, "Eric Van Hensbergen"
 <ericvh@kernel.org>, "Latchesar  Ionkov" <lucho@ionkov.net>, "Dominique
 Martinet" <asmadeus@codewreck.org>, "Christian Schoenebeck"
 <linux_oss@crudebyte.com>, "Paulo Alcantara" <pc@manguebit.com>, "Jeff
 Layton" <jlayton@kernel.org>, "Christian Brauner" <brauner@kernel.org>,
 v9fs@lists.linux.dev, linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 ast@kernel.org, bpf@vger.kernel.org
In-Reply-To: <3459755.1739353676@warthog.procyon.org.uk>
References: <84a8e6737fca05dd3ec234760f1c77901d915ef9@linux.dev>
 <8d8a5d5b00688ea553b106db690e8a01f15b1410@linux.dev>
 <335ad811ae2cf5ebdfc494c185b9f02e9ca40c3e@linux.dev>
 <3173328.1738024385@warthog.procyon.org.uk>
 <3187377.1738056789@warthog.procyon.org.uk>
 <2986469.1739185956@warthog.procyon.org.uk>
 <3210864.1739229537@warthog.procyon.org.uk>
 <3459755.1739353676@warthog.procyon.org.uk>
X-Migadu-Flow: FLOW_OUT

On 2/12/25 1:47 AM, David Howells wrote:
> Hi Ihor,
>
> Okay, the bug you're hitting appears to be a different one to the one I
> thought first.  Can you try the attached patch?  I managed to reproduce=
 it
> with AFS by injecting a delay.
>
> [...]
>
> netfs: Fix setting NETFS_RREQ_ALL_QUEUED to be after all subreqs queued
>
> [...]

Hi David.

I tried this patch locally, and then on BPF CI. It fixes the 9p hanging i=
ssue.
A couple of platforms and toolchains are tested there:
https://github.com/kernel-patches/vmtest/actions/runs/13291034531

Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>

Note that on CI the "netfs: Fix a number of read-retry hangs" patch [1]
is *not* applied. Only this one.

Thank you!

[1] https://lore.kernel.org/v9fs/3173328.1738024385@warthog.procyon.org.u=
k/

> [...]
