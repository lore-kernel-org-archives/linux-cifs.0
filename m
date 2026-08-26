Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4B11F938;
	Wed, 26 Aug 2026 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702634; cv=none; b=jCtXlVOGl+E82gDSd8oKynRU3hyXrwiuCjdHKM6lJFCcXcyoqfHy832dyhBrv33jJQE3zPKy5JcIHBgMZTUivtjyS1jo4KBlzYCuMxVAMMAPSDmWkADCWyR5I/mJqhDQyDKXVsbaRXXlgVJA6CsomWPENEBbP2qQ0BquIElXQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702634; c=relaxed/simple;
	bh=TkV0yfnmttToJnctJPVJOk56LrLV7FXdcb6wtlTl14o=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=XBTbICydSQ5jmrMi0nyvzPxnt5HD7AZczIWZh5GzQJv2Bu43R9HrVPDr4H2Zwaqh0RuIzuiqefYx2p5kqfkz2hPOOHrI6dCiBjoNByM4kdWgdKt3sMYmnjYEOWIGKFFC+vvGsHEOFmj1Gk4ZsZXeEO/3a2o7IcI3fOreZTRKX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=s6QNzEj+; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="s6QNzEj+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dSyGYgQDWVGiejz01uIuvTstpuIaB2U4LpIO3bu8Ty8=; b=s6QNzEj+xuh4NqcuHTEEP9RBGf
	egzbJU8I+rg2HMpwa6H4imnocGXiSfB2ecIL03MFbgcviIfFyc28j2r+E7jYK2PscOr49bIIF20g0
	BysGKMdOBinKuiAmQV1g1ehZUDPJ6k2WNdlX3K4RtwmP2H5XFrqd1l3zdMTwBHRPvm6ErJAPr38Ob
	fXFyc8GEerswPU3keOrg5dvfSO0a3bibo4dhmg1Vc+iiQ16n+zIbT8tQv3fWNEV7mDBQfgS5OQDFB
	aR/hTt3UA9FANbzduzP8CybvSeRwZSum8SaCknba2X5Am6hQ+zazN5OPi84bCPTbUqyh5Co5WHtFF
	R0Re0IlA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wz17N-000000000Pi-3bpY;
	Tue, 25 Aug 2026 21:03:49 -0300
Message-ID: <b8ea942d21a0f0ede8518f33895def69@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix heap overflow in cifs_do_set_acl()
In-Reply-To: <20260825214328.3852168-1-sorenson@redhat.com>
References: <20260825183229.3799705-1-sorenson@redhat.com>
 <20260825214328.3852168-1-sorenson@redhat.com>
Date: Tue, 25 Aug 2026 21:03:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> cifs_set_acl() validates ACL size using posix_acl_xattr_size():
>
>         4 + (count * 8)  // 4-byte header + 8 bytes per ACE
>
> cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
> wire format into the same buffer:
>
>         6 + (count * 10)  // 6-byte header + 10 bytes per ACE
>
> An ACL that passes the xattr-based check in cifs_set_acl() can
> overflow the heap when posix_acl_to_cifs() writes the larger CIFS
> format.
>
> Validate the CIFS format size against the remaining buffer space and
> USHRT_MAX before converting--data_count is __u16, so sizes above
> USHRT_MAX truncate the on-wire packet length, causing the server to
> apply a partial ACL.  Replace MaxDataCount = 1000 with
> min(CIFSMaxBufSize, USHRT_MAX).
>
> Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
> v2 changes:
>  - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
>    with more than 6553 entries, which would cause a partial ACL to be
>    silently applied on the server
>  - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)
>
>  fs/smb/client/cifssmb.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index f5aad5f61dce..621aca5d3b75 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>  	int rc = 0;
>  	int bytes_returned = 0;
>  	__u16 params, byte_count, data_count, param_offset, offset;
> +	size_t cifs_acl_size, bytes_available;
>  
>  	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
>  setAclRetry:
> @@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>  	}
>  	params = 6 + name_len;
>  	pSMB->MaxParameterCount = cpu_to_le16(2);
> -	/* BB find max SMB size from sess */
> -	pSMB->MaxDataCount = cpu_to_le16(1000);
> +	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
>  	pSMB->MaxSetupCount = 0;
>  	pSMB->Reserved = 0;
>  	pSMB->Flags = 0;
> @@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>  	parm_data = ((char *)pSMB) + offset;
>  	pSMB->ParameterOffset = cpu_to_le16(param_offset);
>  
> +	/* make sure we can fit the larger cifs_posix_aces in the buffer */
> +	cifs_acl_size = sizeof(struct cifs_posix_acl) +
> +		       (acl->a_count * sizeof(struct cifs_posix_ace));
> +	bytes_available = (CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) - offset;

Are you sure you want to use MAX_SMB2_HDR_SIZE?  This is SMB1 code, so I
would expect to see MAX_CIFS_HDR_SIZE.  Alternatively, use
MAX_HEADER_SIZE() helper.

Do you have any reproducer?

What server did you test these changes against?
