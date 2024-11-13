Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DA1632FD
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731534595; cv=none; b=SW1kNq7kkt/q1KJbjJHnCJR6iK08FeeBrbCFJL8BZPm+60OIJTDxdKrF6R8+q9ZRRMGkdQm8+wCQt7J0X+I5R+Mjrp4e0NIBkjhWolv5cwwNUEbvPx/8bQnMuor8LEMX8sQLENMQ7OZ04jfbBAuWZMVfZp3Lo3z2FcW7ZJ4ML5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731534595; c=relaxed/simple;
	bh=JEQ6Q91R3g69Yta2y6uVBZB17nNLH2ghjRGY/7NuRHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qq8jFGE7gy7WyxsP5KyUIz0bWS4NL5vFXfYz3uICa7Qo50AvZPAAcwYqhMMyVVhO+sIvVbP2FDflGEftxf5QTEIr1k8CUPITT+5Y/vWYideuKJWL+Ez48WABrSvvepQ7A2xzw8WLzgbFY+PuZltZHe/jFI5ksUpZ8J/jLQ1HeTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ckKifl34; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ckKifl34"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=JEQ6Q91R3g69Yta2y6uVBZB17nNLH2ghjRGY/7NuRHw=; b=ckKifl34hxU2lDcrNLvgwo4AW8
	IXgIYfmWa0hPrAG5O7ydJ1huEGfpHwC7EXW0x5JaNTe3qVnWnljajRvERIHEA1L8JqTGuXiEPrxmQ
	EzQPYINrUldC7WIA8SbnMajx4RM3Oa4OL/mBeN1XmtzLDroSIf+eUHQrWMdbP1BPR7hZNkmSpi36j
	CKLCYyWhWRotQv+l2HDulhljH/rBSjF8tofMEFlYWu3Afl0yLfXcmzP446btDGdneTh33K3I2BUx5
	l4pjyWepxnKaGDJOZAJ4cIVFDX8o86T71+zxa8voRqZGnWgjg3ACQhai7gf5dxpTo1FbBOGX7+KNI
	K/zz8iqhq7jUYLDox5Az2Yg38ugm1fAYn692fHRqrSxmLvV5Y8w+4LCqofzYM5xSve0s8kCxABNww
	3O37Rm4u8ugjJDBERhUNeFSdI3PwQkEy0HkdjbbPr1CnScfbptH9diSTb9C6ZmeQuG2El8XQtHycg
	VVNLyuzvZT7hUtmEb/u4gP2d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tBLFG-00ARfk-36;
	Wed, 13 Nov 2024 21:49:51 +0000
Date: Wed, 13 Nov 2024 13:49:47 -0800
From: Jeremy Allison <jra@samba.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Steven French <Steven.French@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	Samuel Cabrero <scabrero@suse.de>
Subject: Re: chmod
Message-ID: <ZzUe-xBC9NLcDSQi@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com>
 <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
 <0447a472-9b60-478a-98e4-9f07a058380b@samba.org>
 <CAN05THQ=fx5hfp=FFRw4D5hCHvcoU8bs6cbeZT2X4o5i=QZkGg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAN05THQ=fx5hfp=FFRw4D5hCHvcoU8bs6cbeZT2X4o5i=QZkGg@mail.gmail.com>

On Thu, Nov 14, 2024 at 06:52:14AM +1000, ronnie sahlberg wrote:
>On Thu, 14 Nov 2024 at 05:07, Ralph Boehme <slow@samba.org> wrote:
>>
>> On 11/13/24 4:39 PM, Ralph Boehme wrote:
>> > Am I missing anything? Thoughts?
>>
>> did some more research on what the option modefromsid actually does and
>> I guess the problem is that the behaviour is likely correct for
>> modefromsid, it just doesn't work for smb3 posix, so populate_new_aces()
>> needs to be tweaked to not include sid_authusers.
>
>Remember, it also need to work for use-cases with normal Windows and
>Azure servers where you do NOT
>have a multiuser mount (i.e. all client access is using the
>credentials from the mount)
>and you basically have an inherited ACE to "allow all access to the
>mount user" for the whole share.

This is different from the SMB3-POSIX chmod operation.

I think Ralph is suggesting the modefromsid is left alone,
and a new (separate) code path used for SMB3-POSIX that
sends the one-ACE entry defined in that spec.
