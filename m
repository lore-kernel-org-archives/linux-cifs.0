Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736443C0611
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787784767; cv=none; b=ThiE7g7fqEz8+VcsYEiTInQDEMSd+FZvZLMkI19ycftlakhHIGaRck+XAR67ymgnWsOOk+VKCcytmP547QsDtS9HczS59XaSsNldKypxiT6YHnIzX4p/y5lsooyB8nqSrWYlHsv8kh6Sr0mHRxComP0wgglxW5ONtzOcLenXhuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787784767; c=relaxed/simple;
	bh=gMX9Nck+M/zxq7xs5XGGLaxdc4JMLvgMEXSptRP8D1w=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=L7lHYGXGdTnjGUh25Tl49F/yp2LUVOYDOKPD7Cl06mVEvEY0Ykkuy0k8AEqydsxGk+tv9bkhwFj+pT2/SYptpHu5SLr+OQ0RVgQAatyLDoP7L/4HG9RsEwbhBeQkxR292LmrhbonK3feRSSLkZUT+X5Dr8Qew/0l+fwV5/1bbDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=dQ9MTcEV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="dQ9MTcEV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=9+XZldKFjeI4l/USomq2q7h1T2DzuFfSDKn0FM3VtTk=; b=dQ9MTcEVQiZvGyN2quGE4sjKc9
	Zj1huTQWnDFKf4bY0r9Hwk5XHi2Rq2JXMG+f77l9nByZtfZxjgLLp/5FGjpoYg2P7Zj9snpRtzLKV
	UVTp+XLyePAmQh3luqNvg3l803XS0MZaj8s8NHG9sKE1PvX2aZrUf6Ok6QdV0M/CIafkh4FcKZbxK
	Bo4xmXf1KXbCsIYswY0AwpRSRkOW7PqwObAnQzvz3QdPT3aCAy4Xud8lPcS8wtK7cm1kj1QUE6DrS
	g1GSL7hCqjDKwiihyzjBQEaP0HEn6PXyidSa1Z6BEIbnFfkXojaTmRjtZR1/0dIcQS3rgxX6yIiU3
	htuW+DlQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzMU7-000000004Ec-0eqe;
	Wed, 26 Aug 2026 19:52:43 -0300
Message-ID: <4475a3bab754e633b20f78a6827cbc75@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: sorenson@redhat.com, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org
Subject: Re: [PATCH v2] smb: client: fix heap overflow in cifs_do_set_acl()
In-Reply-To: <58e597c3-93ac-45c3-a52a-ca8572fec7a8@redhat.com>
References: <20260825183229.3799705-1-sorenson@redhat.com>
 <20260825214328.3852168-1-sorenson@redhat.com>
 <b8ea942d21a0f0ede8518f33895def69@manguebit.org>
 <58e597c3-93ac-45c3-a52a-ca8572fec7a8@redhat.com>
Date: Wed, 26 Aug 2026 19:52:42 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Frank Sorenson <sorenson@redhat.com> writes:

> On 8/25/26 7:03 PM, Paulo Alcantara wrote:
>> Frank Sorenson <sorenson@redhat.com> writes:
>>
>>> cifs_set_acl() validates ACL size using posix_acl_xattr_size():
>>>
>>>          4 + (count * 8)  // 4-byte header + 8 bytes per ACE
>>>
>>> cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
>>> wire format into the same buffer:
>>>
>>>          6 + (count * 10)  // 6-byte header + 10 bytes per ACE
>>>
>>> An ACL that passes the xattr-based check in cifs_set_acl() can
>>> overflow the heap when posix_acl_to_cifs() writes the larger CIFS
>>> format.
>>>
>>> Validate the CIFS format size against the remaining buffer space and
>>> USHRT_MAX before converting--data_count is __u16, so sizes above
>>> USHRT_MAX truncate the on-wire packet length, causing the server to
>>> apply a partial ACL.  Replace MaxDataCount =3D 1000 with
>>> min(CIFSMaxBufSize, USHRT_MAX).
>>>
>>> Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>>> ---
>>> v2 changes:
>>>   - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
>>>     with more than 6553 entries, which would cause a partial ACL to be
>>>     silently applied on the server
>>>   - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)
>>>
>>>   fs/smb/client/cifssmb.c | 13 +++++++++++--
>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
>>> index f5aad5f61dce..621aca5d3b75 100644
>>> --- a/fs/smb/client/cifssmb.c
>>> +++ b/fs/smb/client/cifssmb.c
>>> @@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struc=
t cifs_tcon *tcon,
>>>   	int rc =3D 0;
>>>   	int bytes_returned =3D 0;
>>>   	__u16 params, byte_count, data_count, param_offset, offset;
>>> +	size_t cifs_acl_size, bytes_available;
>>>=20=20=20
>>>   	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
>>>   setAclRetry:
>>> @@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struc=
t cifs_tcon *tcon,
>>>   	}
>>>   	params =3D 6 + name_len;
>>>   	pSMB->MaxParameterCount =3D cpu_to_le16(2);
>>> -	/* BB find max SMB size from sess */
>>> -	pSMB->MaxDataCount =3D cpu_to_le16(1000);
>>> +	pSMB->MaxDataCount =3D cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize=
, USHRT_MAX));
>>>   	pSMB->MaxSetupCount =3D 0;
>>>   	pSMB->Reserved =3D 0;
>>>   	pSMB->Flags =3D 0;
>>> @@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>>>   	parm_data =3D ((char *)pSMB) + offset;
>>>   	pSMB->ParameterOffset =3D cpu_to_le16(param_offset);
>>>=20=20=20
>>> +	/* make sure we can fit the larger cifs_posix_aces in the buffer */
>>> +	cifs_acl_size =3D sizeof(struct cifs_posix_acl) +
>>> +		       (acl->a_count * sizeof(struct cifs_posix_ace));
>>> +	bytes_available =3D (CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) - offset;
>> Are you sure you want to use MAX_SMB2_HDR_SIZE?  This is SMB1 code, so I
>> would expect to see MAX_CIFS_HDR_SIZE.  Alternatively, use
>> MAX_HEADER_SIZE() helper.
>
> The only reason I used=C2=A0MAX_SMB2_HDR_SIZE is that it's the actual siz=
e=20
> allocated in cifs_buf_get() from cifs_req_cachep...=C2=A0 but now that I=
=20
> think about it, we don't actually want to use the extra=20
> (MAX_SMB2_HDR_SIZE -=C2=A0MAX_CIFS_HDR_SIZE) bytes, even though we have i=
t=20
> allocated.=C2=A0 So as you say, MAX_CIFS_HDR_SIZE or=20
> MAX_HEADER_SIZE(tcon->ses->server) would be better.

Thanks for checking.

> I can respin.

Please.

>> Do you have any reproducer?
>
> Yes, I'll attach the script.=C2=A0 It sets 1800 named user ACEs, which is=
=20
> 14436 xattr bytes, ~18046 CIFS bytes

Thanks.  That's really useful.
