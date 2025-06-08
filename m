Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7DD10FD;
	Sun,  8 Jun 2025 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749419415; cv=none; b=h1b44Fm3HrTFuvnDTr1V0byh1GJdbLzXIbxgtT3SgE2ME5neCXjdleROE922VbB3B2ZB4FE3NmmeI1WxOJl+toHhXA5dAYqQoU14Mdx/XXGIdDUbNBmwQqdgFOw5lhhRR1nlEf6vCfa+qez+f8BuH/+GCog9k35lBRC5xUg70R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749419415; c=relaxed/simple;
	bh=DvPnn+CHzAzRysDOc9328M3MrGvmtkscnu4qSnt6GVk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=uyD/2z2Ruawyu1Nz53lcuJ9M5xthMKtg5Q+lwIw5owjgZSG6dJAAsOLWraVSzkiIf6MMaUORx86Q6dou9Lo/l+F2ItzF0cyK+EOfVa1AIeDMgTAyrsVGWQtwSxLMsvOli1U59iOra+u/RNhaK/Rp7hewx2O+OZyceTVb05FKzxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fC9xoVnC; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fC9xoVnC"
Message-ID: <1bde0a162a5905828806e0993ba9e524@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1749419405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7K6Tfinx4/Z11bP3ZXBA1pTegEGY/siB4o4+g9gwKE=;
	b=fC9xoVnCCgzFo8ko6kdZBGjZ8rlDfpxbV+PsaUwy18NKGjqWaJoEjNhSIJPw97f1T+FgR8
	tsNC2nH3fXNLG8mvErujw7QpwFmna54YdqrDlyOuzKyalhO318esxmISH4gC/pvOUYnOGa
	MElsinQOWrm72xz+gG70e6I0Ybf4YFyUmVqZ1VkIui4s/m1w+Y/I7zzj8kkr2O0NtdGZA+
	8/AZv/KKiYFwiKdfVUFbAPsZZ93V+AOBIvtSrXJEVS30Y8/NuIhYzAym29Xd6NGDuA3V+H
	1uptaD9lSB2+618oTWEWjlQERRZtxnwE2LBcIyxrFbpfn5gmd9hPGQt/h5u3vA==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cifs: Fix validation of SMB2_OP_QUERY_WSL_EA
 response size
In-Reply-To: <20250608170119.6813-4-pali@kernel.org>
References: <20250608170119.6813-1-pali@kernel.org>
 <20250608170119.6813-4-pali@kernel.org>
Date: Sun, 08 Jun 2025 18:49:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Currently the SMB2_OP_QUERY_WSL_EA checks that response buffer has at lea=
st
> size SMB2_WSL_MIN_QUERY_EA_RESP_SIZE and maximally it is
> SMB2_WSL_MAX_QUERY_EA_RESP_SIZE.
>
> Constant SMB2_WSL_MIN_QUERY_EA_RESP_SIZE is defined wrongly because it
> expects that the there are at least 3 EAs. But WSL subsystem has only one
> mandatory EA: $LXMOD. So fix the SMB2_WSL_MIN_QUERY_EA_RESP_SIZE to be si=
ze
> of the structure of one EA.
>
> Relax also SMB2_WSL_MAX_QUERY_EA_RESP_SIZE, calculate maximum size from t=
he
> size of the largest EA which is 8 bytes for $LXDEV.
>
> This change allows to recognize WSL CHR and BLK reparse points which have
> only $LXMOD and $LXDEV EAs (no $LXUID or $LXGID). WSL subsystem recognize
> such reparse points too.
>
> Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/smb2pdu.h | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

If we're querying all those EAs and the file has only $LXMOD, wouldn't
the server return empty EAs except for $LXMOD?
