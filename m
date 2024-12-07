Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD6C38FA6
	for <linux-cifs@vger.kernel.org>; Sat,  7 Dec 2024 04:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546055; cv=none; b=nAywMv6YGKW+IqmU3imgGlgPX4ScKLUJT91Rmwl5/FLdo8jBcN72U6dEbv5w5wSYJ3cFCBUatG1M+hw30wxiPou3uGfOJ9hKJj8WHW0ZvYuMJHVwyGmvO7k/pCDVS6XwAtUcnuLyQAFhxjrPXNZHk8rOfwe0OnsTd9QW9dQxI2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546055; c=relaxed/simple;
	bh=xxsZrkawzY+Nlp4b4VWtjX4cVtX+fS21BmfIukU4Go0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLPGlsbsRw7I8eq200aZZzJ89x3h5T2qFVnWbfxCbtbxky//33w0qmI2OEKf3mlqPhyoOP2O61D/lvIvAZBcF9u0DAHTXfuwU7/QnNcxPBtE2qaUWNyse9BNZCyKYhV75BzFcWQ2bWm2wA3D8+FRYFVOS2gZG25tmecHHeLLeYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OmnTUo+x; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OmnTUo+x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=vrgjbnOtPxYJlYfLipcER+Wosg1cL+h8NE6cFBNOQAg=; b=OmnTUo+xPtYs1tNBqj75ctiSS4
	G4zYtGH6ZcboakPUMI/6l1smxKz3hCjtJjye0nFsOSjlg+LK9q2d8qiRqwPJAGYxYGot38s/LDuab
	6WQZE6/sbi1kyhys/JIPE2xkUPkHh8fX4/RDtuRlp/VNgw2nOFbYXRC0YnuvkFfxyv/rCXKrzNXX5
	u5DGNY4I3lcv6TSMkqchh5GdaGO57JuAvNVOlP2YRx9dPyvnAQiFmUhOqZXc0cctfC7CAxyw4Di2r
	UwDGp5TcvNju4OLAXjmlh/38ObkR/MLFypnitDfxioD3k7PAyyKrumu2w3OWRG4i/NF8U6H7TvWcr
	g35M1egAdyEYuGzCwY9dXtU/EojtEVTtj6KGZGSj3pLvn+9RbBieSVQpxk3fk0CrmZ9YvxougocFW
	3SxKD+nnpVgQR13sz1vTbvFOVOQ98appnERi8GZy5/HeVBsTVdm/XXvGGEcplJNzMizowzBJWsjr/
	GaaHIcGgPKjbb0Q6aQxh7pIs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tJmW9-001MqM-0R;
	Sat, 07 Dec 2024 04:34:09 +0000
Date: Fri, 6 Dec 2024 20:34:06 -0800
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Andrew Gunnerson <accounts.samba@chiller3.com>,
	Steve French <smfrench@gmail.com>, samba@lists.samba.org,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [Samba] Random EINVAL when opening files with SMB3 POSIX
 extensions enabled
Message-ID: <Z1PQPsijuDuBiZuH@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <9995d904-6d0b-4086-b49c-944e845f127e@app.fastmail.com>
 <fa1f85a7-b086-485c-bb25-3c3d8c4cc490@samba.org>
 <53b97278-a054-4bf1-97cb-e2d648c6868a@app.fastmail.com>
 <6c44d87f-de98-4efd-b016-a491e9c57cb5@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6c44d87f-de98-4efd-b016-a491e9c57cb5@samba.org>

On Fri, Nov 29, 2024 at 05:22:11PM +0100, Ralph Boehme via samba wrote:
>On 11/28/24 9:46 PM, Andrew Gunnerson wrote:
>>Thanks for the replies!
>>
>>On Thu, Nov 28, 2024, at 04:34, Rowland Penny via samba wrote:
>>>I do not use the SMB3 Unix extensions, but perhaps you may not be
>>>either, have you tried replacing 'server min protocol = SMB2' (which is
>>>the default anyway) with 'server min protocol = SMB3' ?
>>
>>I took a packet capture and do see the the client making POSIX extension
>>requests, like SMB2_FILE_POSIX_INFO.
>>
>>On Thu, Nov 28, 2024, at 04:53, Ralph Boehme wrote:
>>>can you grab a network trace when it happens?
>>
>>Sure thing! I disabled SMB encryption first since it seemed to make the pcaps
>>useless.
>>
>>1. pcap when running `cat <file>`, which fails with EINVAL:
>>
>>     https://files.pub.chiller3.com/issues/samba/posix_extensions/2024-11-28/posix_enabled_broken.pcap
>>
>it's a client problem.
>
>See packet 30: the client issues an POSIX SMB2-CREATE with a pathname 
>starting with a "/" which is not allowed. If you check the working 
>cases there the pathnames are relative and don't start with "/".
>
>@Steve: do you have any idea what could be causing this in cifs.ko?

DFS mistake ?
