Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2C94AFE15;
	Wed,  2 Sep 2026 22:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388357; cv=none; b=SBaL4EbHVCDZagRgPWIh4QH3g+9PtpTNCHTMA8IGG7NgX+7jMYHFClmm8kZdzDpPGS8JBNjHMhxIZcWvvJZn5gd90cVMzqcjGfmiEHiAj5ySaRGdhDaWNzPlcm5qv0tw6pqTmzcNaalTA/vgiIPeH19Y4sKkpOYwFddd6EiSKes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388357; c=relaxed/simple;
	bh=VQagNx1XMK4MWLhqyV1DQ6Rj9do5580oR+OZM0qvDiM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SrGBclmzl/CQ5n0OqwbVM03gcAYW2DiyGbmCQHNs8Qs+UcpDZrc6+sQI9KhIGKwRgSqqtdJHSPrw6mAwAV1Mb5Z/fucBNqx/ixnDz6IxAjT36LSRSUq1B6F3OSF+2Y4qyota7iEt1wZXxqbQsOYUvyzFkaXvycpZqJWLGP+lCO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=E3mVt0H9; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="E3mVt0H9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=IUV13IXwrQN6nECVLH6FjSQYZXk3YksSteM+9KPRI+Y=; b=E3mVt0H9L59upxgjviLBXo8BXf
	6+KXGgrtYYIhFZWZPXTccel4DQ1w3tb44DXQWBUtvyKeRsOM+xHM4JSxjyS3QJDSW98AhUjZG7GE3
	Jx6Reo/H1g0EsQAoOy6MNunjQiImr8GdAy4uEE+IGLWaDeK33k9PeRsK1026wb7O1HZ7lddv1PDsE
	oMN4zvr9rxcZzJzVBETRj3bqiPgzmMY+APE3XcekBT1id0HvXAsDICghunxprEnbkh5Ne8pnCpWi+
	0w5PA9eCc36OwxEJtcBzUEkTiEUxcGB3EV6GZwSotNDbS8m5/3UwXXFQTc7WOfj/r+D1/o5ynNwOw
	xOtujkBQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1tVJ-00000000YRb-0bBN;
	Wed, 02 Sep 2026 19:32:25 -0300
Message-ID: <498fd2508ad66ac9d8fd19cbd4b4a02b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: sorenson@redhat.com, Diego Oliva <diego@bynar.io>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in
 CIFSSMBRead()
In-Reply-To: <e5dec57a-0186-4087-9de4-5037f0a09879@redhat.com>
References: <20260902104207.1820332-1-diego@bynar.io>
 <e5dec57a-0186-4087-9de4-5037f0a09879@redhat.com>
Date: Wed, 02 Sep 2026 19:32:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Frank Sorenson <sorenson@redhat.com> writes:

> On 9/2/26 5:42 AM, Diego Oliva wrote:
>> CIFSSMBRead() parses the server's READ_RSP without validating either
>> the length of the response or the DataOffset it carries. A malicious
>> or compromised SMB1 server can exploit either to read past the end of
>> the receive buffer, leaking adjacent kernel heap into the caller's
>> read buffer or oopsing on unmapped memory. SMB1 is not negotiated by
>> default; reaching this code requires an explicit vers=3D1.0 mount.
>>
>> Patch 1 rejects responses too short to contain a whole READ_RSP, so
>> the header fields can be dereferenced safely. Patch 2 ejects a
>> DataOffset/DataLength pair that falls outside the received response.
>
> Your patch 2 checks that data_offset + data_length fit:
>
> +		} else if ((size_t)data_offset + data_length > rsp_iov.iov_len) {
>
> but I think you may also need a lower-bound check to make sure
> data_offset is at least sizeof(READ_RSP):
>
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (data_o=
ffset < sizeof(READ_RSP)) {
>
> otherwise, the data would overlap the response header itself.

Frank is right.

Diego, do you want me to fold this in:

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f3cba16f6e17..f9aff0712794 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1742,7 +1742,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_pa=
rms *io_parms,
                        rc =3D smb_EIO2(smb_eio_trace_read_overlarge,
                                      data_length, count);
                        *nbytes =3D 0;
-               } else if ((size_t)data_offset + data_length > rsp_iov.iov_=
len) {
+               } else if (data_offset < sizeof(*pSMBr) ||
+                          (size_t)data_offset + data_length > rsp_iov.iov_=
len) {
                        /* check that the data lies within the received res=
ponse */
                        cifs_dbg(FYI, "%s: bad data offset %u length %u for=
 response of %zu\n",
                                 __func__, data_offset, data_length, rsp_io=
v.iov_len);
