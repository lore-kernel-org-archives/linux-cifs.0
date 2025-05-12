Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2242920A1
	for <linux-cifs@vger.kernel.org>; Mon, 12 May 2025 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056689; cv=none; b=ur5S680f++GTvsbBCWlCnrPa8Cwux9/HjzRY17Zb6ajk7bxohFBxZdyTVwDzH8M8f8RrxlM/kCHKLtxG9zsDaPQJL8r7+JHw99ybO9SUizKfSY7dtI2JpnM12H7KmQtpBocCrDNyE7KvLKWNXas2scHRT/ofPPlEyvGiVPSkvO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056689; c=relaxed/simple;
	bh=r5KiAfZNaLO5U5aQSSPR0m7uwm7/EN26va90xLIz664=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SHlfmrnHa8RKHLbAF+SXgtZgc9e4V55XIZ+TdctdlNsptyIZdxg/QxuM7cFYesSspwB/6ZMKeRVcntiKyXHOlF7FJ+rXQFelsQ/Ejis/BdtrzmycBXIZp0kQoCxCM6jxR8CpiQz8NH84jYOh4vU3Uwwhe/pzOQsv8CdnufQhe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MaKNMWum; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MaKNMWum"
Message-ID: <3d60f40bbcd3d297b860f4359bf63def@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1747056680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UC4CM2lFGfubiAix5dWxZ6iafBdlvrNFI8b6NmLquCo=;
	b=MaKNMWumrv1uGEDPng0Dy5rpP71gbI0i3ExgOmTaNoXb7e/IYwgJcIUeJDj691+/rf79YJ
	ehogJH/1gMbFdvTvOnBQmuQBp6HfRyyIvSJG17bf64O11JPH3G2CnHAQUGmZvxpSUHtDI+
	M7AJ0WfyXfXL2EP1KelzKUodZmFKCQ2OAc9pFgpKMa19NjtK8cvO9OYg8vzJp7xaZ263M3
	yntZSE9xuvtABg+K65zpNCRDks8ZN7YLUEjWY3mc/hB7MVLfNkwgiUYLicNNshyADtXfWM
	HiExOwM7wF3w3q8w6ty3xSpmsiorWOogRlUWiRtoeTaB63fxKdUp8eNuKppfVQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Steve French <smfrench@gmail.com>,
 linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, Pierguido
 Lambri <plambri@redhat.com>, Bharath S M <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CANT5p=r2-Sm-9=jPY0YM1mV4J0H5fOG31WSZ+E_4dKqNcNJ_Kg@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
 <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
 <3d7d41c055cd314342ec1f33e6332c32@manguebit.com>
 <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
 <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com>
 <CANT5p=r2-Sm-9=jPY0YM1mV4J0H5fOG31WSZ+E_4dKqNcNJ_Kg@mail.gmail.com>
Date: Mon, 12 May 2025 10:31:15 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> I think this version of the patch will be more problematic, as it will
> open up a time window between the lease break ack and the file close.
> Which is why we moved the _cifsFileInfo_put above as it is today.

Can you explain why it would be a problem sending a lease break ack
and then closing the file?

Do you have any reproducers for such problem?

> Specifically, it is still not clear to me what was the exact bug that
> your customer hit. And why is your patch fixing that issue? Can you
> please elaborate on that?

(1) CREATE foo
(2) CREATE resp
(3) CREATE foo
(4) LEASE BREAK (RWH -> RW)
(5) CLOSE foo
(6) CLOSE resp
...30s later...
(7) CREATE resp for (3)

Windows Server is delaying the CREATE request in (3) by 30s because the
client hasn't sent the lease break ack for (4).

Since the client closed the last open handle,
!list_empty(&cinode->openFileList) is obviously false and hence the
lease break ack isn't sent.

Pierguido suggested 'closetimeo=0' to the customer and it seemed to help
them with the performance issues due to delayed opens.

What is your suggestion to get rid of this optimization and then sending
lease break acks regardless whether there are open handles or not?

> On RWH to RW lease break, we would force close all deferred handles.
> But any active handles (that are still kept open by the user) will
> continue to remain open. Which is what this check is about.

The check you're referring to is related to whether or not sending lease
break acks.  What do you mean about "continue to remain open"?
