Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404697;
	b=qd8KP3DRSqElxGlIVnPLC9RkdkBRAd73F3FhxuQKKSeLfWr3nHY9isN+KVHA1D1uYqAf
	 hvXqSrBnsCO1yAft2kQfnFN1UmO2+w4x5mEiyzspK2529E5eYLA0PvPuibJErjxo9gYBg
	 ZOG/iHvMxcEF6ba/9Uru/DVsHo+o1jnx6NJdC/V5tGKWW3l1feXM3HCUndMTq2oqeosTw
	 LqGH/EILd2yQvL+HUV187I8dJ4vavRTA4VQpPGdLCOFJx1QGZIkIV6WsOzH92h2lF8ob/
	 ACk66fW9XWNrbaDMA+T8Zlm5SSO7xjJdIVM7hv+mnwSSJMjN+JzHnV6DRSQMfImiT1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404697;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=L9NVOt4hOFoYtGev0mEhj0TEZnxJ0HjT+1Qu0Bv20T0=;
	b=E6MY9MRCuzaCDNxcVXF8t0x0zBIZSPrrp17Q3hHwPfe+GGCcm7phmcLNuGfHC2AuTZ0S
	 PaLCnBsJcLzkl1S4jrz/ltHDWf5M3cUOQS6+xTmmZmLjp7umNaIMQ3XZLSCcR/dv8Si5x
	 JWwVfKqcw35der4uihEMAACm8bxGv+mQvAUa426MCftGpV+HgxYYXsjIaf3sax9xDQwA0
	 cPO+WMSMalpmKxQcyUfKzh8EG151TvEi0rl6opQOQ/Hqi1UTjMMScsezJgCFod1sJGhDB
	 SQHzbsem2sIa2ObQ+07bYsBItPjJ6jZwJDfLIy+QgYqiWXQLPsKqzCbHEx3YUuCqPoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vV+0FcTB;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81ED606A31C;
	Wed, 11 Nov 2026 13:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E81ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vV+0FcTB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L9NVOt4hOFoYtGev0mEhj0TEZnxJ0HjT+1Qu0Bv20T0=; b=vV+0FcTBoNU5o4OLSQPC6PgnRv
	fgHstmcDFOtYkngXKEoAi2RMXhliQ/4spjCvQ9nlOI+mZb/xXFgUtY+yiig6PXX9y6k7NOR3Elkvr
	FM8cqexiY0emYR3TlgAj1TV+tz/qP60mxdF6USCI15sJgqLex7T7rFKWB8Uc1XTxdU39ZqtZRhjI8
	vbAniFGvU4pH34YgOGgPNOonS1U4UL4eDK5lXgNEN3Gxac5H4kEtMi6j4qWKu9RQ1CZ/PoEDe93zv
	Ix1OOYGXg81QTqFSZhqqdH3gQPl3tX2Kc0G/o19I9cBSYs1xS4x0jjk7zvhYo0vHV3t36Pe/ZNDGo
	GrdGWOCA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xR8d7-00000001Stc-3el0;
	Wed, 11 Nov 2026 10:44:51 -0300
Message-ID: <10dd9cea16f8ebff2103ee7ac7e5ec4f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Giuseppe Piscitelli <ooonea@gmail.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: retry a hard link open without a lease
In-Reply-To: <CAKYAXd-VC8shz7r9P=mS5XvOuGoadBhjJ6XYaaivL1z8v0UGpA@mail.gmail.com>
References: <20261110225412.3937476-1-pc@manguebit.org>
 <CAKYAXd-VC8shz7r9P=mS5XvOuGoadBhjJ6XYaaivL1z8v0UGpA@mail.gmail.com>
Date: Wed, 11 Nov 2026 10:44:50 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Namjae Jeon <linkinjeon@kernel.org> writes:

>> @@ -214,6 +214,19 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>>                 rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
>>                                &err_buftype);
>>         }
>> +       if (rc == -EINVAL && smb2_oplock != SMB2_OPLOCK_LEVEL_NONE &&
>> +           !oparms->pending) {
>> +               cifs_dbg(FYI, "%s: invalid lease key, resending request without lease\n",
>> +                        __func__);
>> +               free_rsp_buf(err_buftype, err_iov.iov_base);
>> +               memset(&err_iov, 0, sizeof(err_iov));
>> +               err_buftype = CIFS_NO_BUFFER;
>> +               smb2_oplock = SMB2_OPLOCK_LEVEL_NONE;
>> +               oparms->reconnect = reconnect;
>> +               oparms->replay = false;
>> +               rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock,
>> +                              data, NULL, &err_iov, &err_buftype);
> Should we retry without FILE_READ_ATTRIBUTES if this retry returns
> -EACCES?  EACCES handling above only applies to the first SMB2_open()
> call...

Indeed.  We should retry on -EACESS without read attr there as well.
Thanks!
