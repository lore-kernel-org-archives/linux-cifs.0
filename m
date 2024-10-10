Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D65542A8C
	for <linux-cifs@vger.kernel.org>; Thu, 10 Oct 2024 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578583; cv=none; b=Z1JJU4dSMlu9uuSesSHsyplsp2poxKwTuBJurYxAiSXYP1ge1FIIjDOASkAnOzuNt25EyOi2zGSyIJxqQAFgTqofO6DWyTxwtpKfgxVoffBRz66YWhaBnwy1DYHci6G+ZGFIy/PKDHsUH8sPc43PDe/w7pp8ELgawSnQqfD6KLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578583; c=relaxed/simple;
	bh=Vj5KpDy6+wRoimMezhxY3Vwgej5JKpoav3MEFnPK//8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIXGFnFGALNiKAQMkPp6FzWj5XbDj4l3/8FBZ8jX+NPSWdge2avz8ehrRY8zmj2ovXIwsA6Avc9I3KPuTVmVAFGzbs0rVe4zKiodU1fiZ/PXApkrDi+2KgiALWg9YRXdaKcXyfvZKXOmWZUCNeytJPfQRmE8bl7rmnqy4bTvda8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Qjb5CzIN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Qjb5CzIN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=Vj5KpDy6+wRoimMezhxY3Vwgej5JKpoav3MEFnPK//8=; b=Qjb5CzINBAm1J7Q/gyDX2suIss
	+vMZd0L7+VWECIvLYxr4z9Nq3nCa1ROVaHB2QmrOXov5g23trsPxH1AgFo8tjmQjGZOQlo4NAhD94
	BmH9L6vKqU1/HannobBWHjinRXWpVsEXBPPNlXebmvdUIOeIs8B1BP74OH/vm//uNSnY1YBiFJgUK
	EaeS1itce2JyfPiP7tCWbgxTVq4W4jWCQcQ9022t4MLFj7SksmS0h+SQaOuHCpS82UjWrHUPe+jLr
	oDjbj10mlipk6R6r6vfTHYHLu79VYlMpIzu7TFCWEb1PcKcGatoSDYkh2z1eqYuLeRZpPiDGnZr4X
	DXn04ZCf24jdx7neFsxpPdA8gceOO9/ye/HRZ/6GQwQQOFzTkG7nThu9xDSAe9Kl33PoNfvOufuTf
	H7jYB/VdSYQmEZWKfENV29QeBCcTkBWpRZjJARbE1q4kf1cHIkuHtM0C3OieYXejYgpkLKLsaC+7u
	oeEjJvHUcpzF+m8hnlCy9N4E;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sywFc-004Eae-1s;
	Thu, 10 Oct 2024 16:42:56 +0000
Date: Thu, 10 Oct 2024 09:42:53 -0700
From: Jeremy Allison <jra@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Ralph Boehme <slow@samba.org>, Steve French <smfrench@gmail.com>,
	samba-technical <samba-technical@lists.samba.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE
 on copy_chunk
Message-ID: <ZwgEDfnvQWwd1R7N@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <b84b2bb0-0afe-4f9e-9553-1a0201ed92d3@samba.org>
 <ZwblLYrVQM92eFl8@jeremy-HP-Z840-Workstation>
 <7980bb29-e434-487f-b70d-aa9d29156f00@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7980bb29-e434-487f-b70d-aa9d29156f00@samba.org>

On Thu, Oct 10, 2024 at 11:01:48AM +0200, Stefan Metzmacher wrote:
>
>MS-FSA 2.1.5.4 Server Requests a Write has this:
>
>If ByteOffset equals -2, then set ByteOffset to Open.CurrentByteOffset.
>
>So I think if a file is opened with O_APPEND (on the client), a write() syscall without explicit
>offset (so no pwrite), could be mapped to an SMB2 write with offset -2.
>But I fear the linux vfs layer already replaces offset before cifs_file_write_iter() and friends
>are called... But I guess the per operation IOCB_APPEND flag can be used in order to decide
>if offset -2 should be used. On the server we could map that to pwritev2(RWF_APPEND).
>So O_APPEND could be a client only thing...

Hmmm. We should test against a Windows server doing an open with
FILE_APPEND_DATA|SYNCHRONIZE and an offset of other than -2, and
see if it writes at the end of file or not.

Looks like the protocol has one way of expressing APPEND, and
the internal syscall has another. We need to figure out what
is required on the wire to see what works.
