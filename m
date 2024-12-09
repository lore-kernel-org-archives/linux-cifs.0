Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C191E14E2CC
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733772875; cv=none; b=t2v9lW1gZzlXVNOkGmgTDUGbUhiGY5VVHGq/SaQ65Ptpjl8yFsQGqGcj4COxM6TgR7zdB4YlI4CJx3/E0VsI0TDxz5o4Ugfbc2SxErF9ecSxr3hE6MTf/761sMBOds8FUjPsAzvjgmo6GJ1HED6Bh/jNlQAhCiDk1+yVgNBirAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733772875; c=relaxed/simple;
	bh=LPRXFfSlU+Lx8Li3nSK93IEv/EnFPxNkZQn2t2L/QiA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=VAJ4jEH2CAD0C8FqGDn+Zp2poyl9p4Z4M3ABGSws43PkazCyhqk2yZgW5hDm2/L48QLSOseby3FdDFm6tce8B4iqEieG7UD/vz245CdPCIDwU7FVKSBoobxDoATNxoxpxXa7ber2UITLM13IQKkL3/5pHaKAfuynBNzVwkhn5n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=edJVvKn6; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="edJVvKn6"
Message-ID: <1098e751d1109d8730254ada7648ae4d@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733772491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dm7Iv+6q23cPeCU7zBqQbOfx+QUHVcj49nbJ82UIFYs=;
	b=edJVvKn6hWjU43s30jWuxMXazkWCRCPHursrnICyZbFdrEpxZ21HoXR2Bu3DkQUdJxC5x8
	axhJP1ROU//4kfreqZ/pOAZ1aIeZQvOpCQ3FvAZtfGaHzxDmWpOm6N8AP8zbcfdUhhUaYe
	8rgZa7Txhay6qhg+hYNvf4QUO4N2Hz7ixjt4QXr8i2yUkuP12FLQyKF0BX8OPSQCBVBfm6
	zpv/UTc4PzfNorqGzKKDkNPwGPVNAcfnEg9iKTpL1i66tniUkpAFCw+6iOzrudu5NhRmnv
	AZR+0MFCwqSoQ2Fd98YkLWiwB1CVg29dl46v1HcS1KcyCUAI86galNzXtq/WDA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Ralph Boehme
 <slow@samba.org>, Steven
 French <Steven.French@microsoft.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
In-Reply-To: <20241209183946.yafga2vixfdx5edu@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
Date: Mon, 09 Dec 2024 16:28:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Hello, this patch is incomplete and still does not fix the main problem
> that SMB2_OP_QUERY_WSL_EA command does not work with any Windows SMB
> server except the last Windows Server version. On non-recent Windows
> versions it is not possible to set both EAs and reparse point at the
> same time and Windows SMB server is returning error when trying to query
> EAs on file with reparse point.

No, Ralph's patch has nothing to do with your problem.  SMB3.1.1 POSIX
will support NFS reparse points with no EAs, so makes sense skipping
SMB2_OP_QUERY_WSL_EA altogether for posix case.

> Which basically means that it is not possible to query data about the
> special files from Windows SMB server (except 2022 version).
>
> More details are in the email which I wrote in September:
> https://lore.kernel.org/linux-cifs/20240928140939.vjndryndfngzq7x4@pali/
>
> I proposed similar but extended patch which skips asking for EAs based
> on reparse point:
> https://lore.kernel.org/linux-cifs/20240913200204.10660-1-pali@kernel.org/

Yes, that patch looks incorrect and untested.  Can you tell me how is
@data->reparse.tag supposed to be set, for non-readdir case, if the
compound request wasn't sent yet?  Have you tried to stat(2) those files
with your patch?

> But it was somehow rejected as the proper solution should be different:
> https://lore.kernel.org/linux-cifs/20240917210707.4lt4obty7wlmm42j@pali/

Yes.  Have you sent a patch with the proposed solution yet?
