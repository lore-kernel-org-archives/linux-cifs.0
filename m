Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C63B2FC2
	for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277552; cv=none; b=B2M6CQxGORGB6uGzgI7CdsuTBQNUSWr/rPa8S6mQ8MglFlvuCHRtWKw4hbed3qoBWPMlIYQ1mhmHwFlHnKuEM42iaT3CaJ/3eYOZyXLZ17AJfhee7aim66gyjGakp3xTJVzvIgAKnGaOoDrxdR3UM7GsmN4knhgYFl4uWvnqsFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277552; c=relaxed/simple;
	bh=KbfctE9xbMaq8z82UyfhfkaRlUugJsUcn7ei3aJP0ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cLAKmq4Aa4OmjQvOV5FyAMdCeS3dJ4db+um+rfFzrhJJZC1aG1yvT36Ni4V7rW4IypW4LVlsoQC/Q+F8Fym4tNq/KgIVPNyGSnqjp5xGTwS+2coOHpSDnN3YBxoqlBMjLo4u1+Wi59Bwiv05kBru1KPlHDzH3Tn2JoIn9tuS3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=idjAmKJn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="idjAmKJn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=KbfctE9xbMaq8z82UyfhfkaRlUugJsUcn7ei3aJP0ck=; b=idjAmKJndQK6w0F9Fk3UKCTEXB
	uD7ZpClad8U/fhD+e7TDHDNe7EQ8M1uyeUJdHjeLkZsnYqsWONaQIhQth/6swG0uHWkelubCBSWee
	2y+b7Bk2gjaaBhIhh6BdfdnZoCbjj5GxrN+ZaTzyRsTkm1t9GapMCgb/fgVqgZTZzh/3BXCqIhc35
	p2Lw03TXFWAdlw92Fph4+h0NBTGnMcNwikUDcHNME26WHTa9cHs0kTycJlD3b1pJm4mzPDdEWVrbf
	L92hS2JrJM4LmNgh1NY7PC2dXRwqEuxSOhf7/6nNYiT2pwvTd9iB37HORc1B1hg1oWxtHw7+rJAJ8
	EtMhqsToxc3TyFV2VQ18vKku2cCx0SN5++2iiqXddfwWBj0uTkYzEb/UJ8xUd+6ZFNZIj31iIL1+K
	eFsHuOf4SmWfFR9TekWYT6BD512p/pxl8RVfHr/2Di5BJwb5amio86ZTU7V2OhPEQoQcbX7ljlB1u
	RGh3ZtTW7YkgW89Sb5BIP+LO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1w4gdn-000000036Ya-3TjC;
	Mon, 23 Mar 2026 14:52:27 +0000
Message-ID: <69c54f80-dff1-4c02-af97-08799fe59b94@samba.org>
Date: Mon, 23 Mar 2026 15:52:27 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [samba-ksmbd:ksmbd-for-next-next 11/12]
 fs/smb/server/smb2pdu.c:5723:3: warning: variable 'pntsd' is uninitialized
 when used here
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Asim Viladi Oglu Manizada <manizada@pm.me>,
 kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Steve French <stfrench@microsoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <202603180118.ClDWNtId-lkp@intel.com>
 <b859bfa1-7844-4b23-91a4-bbd526ffc19b@samba.org>
 <CAH2r5mvvjWtJza+9YrLYvneysyEQa5rENhTYiFTAwrE+KhOy8Q@mail.gmail.com>
 <CAKYAXd_yLYLD5SsRUZy8d6u7vknTPuN8Cbe11HJt0Eq6bLzBBw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd_yLYLD5SsRUZy8d6u7vknTPuN8Cbe11HJt0Eq6bLzBBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.26 um 15:43 schrieb Namjae Jeon:
> On Mon, Mar 23, 2026 at 10:22 PM Steve French <smfrench@gmail.com> wrote:
>>
>> looks like a simple fix to initialize it to null at declaration, right?
> It seems this test was performed on an outdated version. The current
> ksmbd-for-next already includes the updated one, so we don't need to
> check it.

For it still happens with the current state:

1ce4e48216b84385319da308f2262eb11ee7e459
(smfrench-smb3-kernel/ksmbd-for-next) smb: smbdirect: fix inverted comparison operator in negotiation log message

And there it's likely:

6a0795e46296589d8eba6c194586e9e65974d73f
ksmbd: fix OOB write in QUERY_INFO for compound requests

With setting it to NULL the smatch warning goes away.

metze
