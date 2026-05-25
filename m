Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651E1D5174
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779713382; cv=none; b=YvTKSGemKcSz52x5jGvIbh889MS0cQnlBJwc2enYVLVqIB0luTE8f+vuP5Asvarklqqls1mRg0Rqo6b7mrFKqefOtbeE+KiRLZ75cFoQHoyeDoa9JhBYf6UQRUVVcgErKvMbkOWFHdRBnGZLaEzxP3Yko89fMneLJBIK6AXZfJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779713382; c=relaxed/simple;
	bh=fOPmn7hicSySIT9MuWiGfP4/nGNOOTpjYJ+RW+E52SM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjqcLd4l3+4n1WmiEDjFnL8uieIquKV2iY9/VVD0H+aT5Xi4N/T+cPJSZ4Il1GIhT1q1wPTZE8VNZSauThpdRqox/MtvuOLjZ6j+Qhz8aU4JTEO1U0p2H9qj1GNdmEhrlQIesLDatxmrRZ6C1kHBlNuKhO7nxMx5431FnaYYooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=k0F754vk; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="k0F754vk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=fOPmn7hicSySIT9MuWiGfP4/nGNOOTpjYJ+RW+E52SM=; b=k0F754vkMOpUaKl9Q2JFGyh96G
	vhQ3yPA18rB3pnF7toWfSYLLBN+6ixfLO0VzlHwBbBaxBJYa1v0/AfObtWCTWSxIJ78Jpk+dceErQ
	IEDG4+4iQbmPrxN9k5rCuRT78QipeBtFFIibe3b/VauosZsct7suGSboiU7P+PBF8CKEQ0doEIztB
	GcFHRCtENN3G1zTharLp/1pyv5Nvx1my0BSul/CacMqUktDaV9wW+dkgtZLCUNojAp37E53a0x9SN
	bH3j/poTah3VBXmk00S/KoLA5+3Mp9o98N9tx471+WlP7tRtr9ywl+TqKqOtZN1M4qMaLwHWD1h+O
	cju+vuGYXiiMrpS02bs8K08OjRbUj0aMsnnarWjWZgG/Rt7TKqpiJDR1b6yCBUbM3EB4MRqGG+/+6
	7uH9Ngcj4zoNIxDwiU2vNNMDXX2Sp76I8cGxNjambSSertpSNKH/gC3yd2QUjYZ82frUD7W9LG/VD
	YW9oCcFD4bvxDJWJ9/+lczoL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wRUkP-0000000BZ4c-1AcW;
	Mon, 25 May 2026 12:49:33 +0000
Message-ID: <472015a3-3592-4eda-a2b7-9ac2304c1d24@samba.org>
Date: Mon, 25 May 2026 14:49:32 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: add missing software bounds checks in RDMA
 transport layer
To: Namjae Jeon <linkinjeon@kernel.org>, _Vx Ano13 <ano13vx@gmail.com>
Cc: stfrench@microsoft.com,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
 <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.05.26 um 04:34 schrieb Namjae Jeon:
> On Sun, May 24, 2026 at 10:50 PM _Vx Ano13 <ano13vx@gmail.com> wrote:
>>
>> Hi maintainers,
>> This patch fixes a missing software bounds check in the ksmbd RDMA
>> transport layer. I noticed that a length parameter was not being
>> properly validated before use, which could lead to potential issues.
>> Please review this fix. Any feedback is appreciated.
> Could you please explain where the problem occurs without this patch?
> It must be described in detail in the patch description.
> And wouldn't it be better to move the validation check inside
> smbdirect_connection_rdma_xmit ?
> Thanks.

I think the patch is wrong as it assumes a single descriptor.

These checks belong to the SMB2 layer and not the smbdirect layer.

I guess smb2_write()/smb2_read() need more checks,
currently is never validates req->WriteChannelInfoLength
against the length of the SMB2 pdu, and the checks for
WriteChannelInfoOffset also seem to be incomplete, it only
checks for a value being to lower than offsetof(struct smb2_write_req, Buffer),
which that check is not really critical, but a value larger
than the client provided request buffer is a problem.

I think ksmbd_conn_rdma_write and ksmbd_conn_rdma_read should
already get a struct smbdirect_buffer_descriptor_v1 *descs
and descs_count (which is the number of array elements)
instead of the buffer length in the SMB2/3 protocol.

metze
