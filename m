Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABA0385D94;
	Sun, 13 Sep 2026 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789326190; cv=none; b=rRZtLjIFVgps7QIRGUarICRSuKBf6NRv5TJzMbMvs+fMQ0sb4ihgp0Tg6cI7727wT1WfVcFdAHxlTYmKfT8w4yMypR9BCgQTxu4ZnRMXUKkeoyeIsA/Yw62xsFgpGihnf2amU9+Mi1WF2A9zOYOVS9qzxl8d3T/KE3ClwvGBjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789326190; c=relaxed/simple;
	bh=j1POOw7zyFhM4p3F1u6l+NVUEhsBwqMhcDyt3MJAlOk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=lrzSJr5EiKnjNdnvHC6sfDJrK19qbaobpN+pi/XBliLR59U0yMjXmP3DVmNQDN+QbrSLEJ9yR7+IOCUiMKoce6xlDA2PXExgsHdZC4KsFm7GU+D0gimq+Hz/EI8YMd51yS8iiZzD57YNUCWD9HuJrUUiqb4Prd1nuV1N180J4hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=r1Hsq/PM; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="r1Hsq/PM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KeLqeYfEtK6z/jDRCOarG2PW5UF/d7oBGyYDN5ezOj0=; b=r1Hsq/PM92PjnL0E3fhaiKCEFB
	4gZzjQc0Fob2OsMlLZAzrNfJEpOLaCcHi1EVedE0DmV6IAs3A+WVMxb7kqpP/3WQd4Y0ijVnvIMFn
	RcVIrjPkw+vSoyvMqTT25jVoWNop0PM+45mHWLg3CPjokCWRokskFnpa6O7UTcUQlMMOB93zdmtup
	sQdk0FY11/2lNJqVVNR0N425ie06J/kz3tIfeXztLWreA0mLzeibtYBQ0McGq269noVwbJ3EUd+jM
	J9IBXrLhkWDhebn/1qUiJR6WLiCfA/JY+NrxNsMkiVPV0eEs+sjYF/LwESt010qJOIZjpzbr+FJTc
	Ar6MpyaQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5pTl-00000001LJg-3wOK;
	Sun, 13 Sep 2026 16:03:05 -0300
Message-ID: <1cd47320f94f87c18b12e88256741eb2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Diego Oliva <diego@bynar.io>, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>, Jeff
 Layton <jlayton@kernel.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] smb: client: reject short WRITE responses in the
 SMB1 write paths
In-Reply-To: <20260911145758.3833254-2-diego@bynar.io>
References: <20260911145758.3833254-1-diego@bynar.io>
 <20260911145758.3833254-2-diego@bynar.io>
Date: Sun, 13 Sep 2026 16:03:05 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Diego Oliva <diego@bynar.io> writes:

> cifs_writev_callback(), CIFSSMBWrite() and CIFSSMBWrite2() all read
> Count and CountHigh out of the WRITE_RSP returned by the server
> without first checking that a whole WRITE_RSP was actually received.
> The length of the response is available to each of them, in
> mid->response_pdu_len, bytes_returned and rsp_iov.iov_len
> respectively, but none of them constrains it to be at least
> sizeof(WRITE_RSP) before those fields are dereferenced. In the
> asynchronous case cifs_check_receive() has run first, but it only
> verifies the signature and maps the SMB error; it performs no length
> validation.
>
> A malicious or compromised SMB1 server can therefore return a response
> shorter than the WRITE_RSP header and still have it parsed. In
> CIFSSMBWrite() the response buffer is the request buffer, since
> smb_init() hands out a single allocation for both, so the count is
> read back out of the request that was just sent; in the other two the
> reply lives in the demultiplex thread's buffer, so it comes from
> recycled slab memory. Either way the client reports a number of bytes
> written that the server never sent. SMB1 is not negotiated by default;
> reaching this code requires an explicit vers=1.0 mount.
>
> Reject the response unless it is at least sizeof(WRITE_RSP) bytes
> long. This cannot reject a conforming server: WRITE_RSP is documented
> as wct = 6, so the smallest valid reply is
> sizeof(struct smb_hdr) + 2 * 6 + 2, which is sizeof(WRITE_RSP).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: c28c89fc43e3 ("cifs: add cifs_async_writev")
> Cc: <stable@vger.kernel.org> # 6.19.x
> Assisted-by: Bynario AI
> Signed-off-by: Diego Oliva <diego@bynar.io>
> ---
>  fs/smb/client/cifssmb.c | 21 +++++++++++++++++++++
>  fs/smb/client/trace.h   |  1 +
>  2 files changed, 22 insertions(+)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index f9aff0712794..b1525d491ce5 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -1880,6 +1880,12 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
>  	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>  	if (rc) {
>  		cifs_dbg(FYI, "Send error in write = %d\n", rc);
> +	} else if (bytes_returned < (int)sizeof(WRITE_RSP)) {
> +		/* check that the received response can hold a whole WRITE_RSP */

Please don't add these useless comments.  The bound check, trace and
debug messages are already enough to understand it.

Ditto for the rest of the series.

Also, check sashiko comments [1] and see if any of those make sense to
address.

Thanks.

[1] https://sashiko.dev/#/patchset/20260911145758.3833254-1-diego%40bynar.io
