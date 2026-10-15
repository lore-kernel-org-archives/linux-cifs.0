Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144F34A0153;
	Thu, 15 Oct 2026 21:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099723; cv=none; b=FpMNIhiJoAsZ2TyStTVoXwiWzWqqkA33sLV+ZvIdyqF8VMAkvb5ZcDDGMISpHFBfz2hAMpSOKwtFsqsCsZes1uMK6tkA2CZaSV+vTg3zLI/Xa/TheuyQ4fxvv5xkNhB8ehc0AKLSGQUA+vftCtWEp72L0w7DvOhGsqmE8FR3is4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099723; c=relaxed/simple;
	bh=yL0ChYH6MtEznGaMEmznmcr07mfrlaodRx4tIVasE1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txmQhAwQUBryb7KhukLpODOegDGf8SWiyoidcESIQz7jUIvm6DErFlIXgHUNtkzWUC+jk3B5djKUw69zRjRcni3qCVS0iR3KRhPX8dGs192n+xygH/oc+eUBBMLSYO3J1DbtNDRVggyxdbjVYqLLRhvLUcrU4p3hBGBlXEo0ms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=C8KKd3AI; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=ppSQRD+3; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="C8KKd3AI";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="ppSQRD+3"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1792099721; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=/hE6TFrqXYpuYok253VvbchQ0KBtQW0k2a+QqfpvjSw=;
 b=C8KKd3AI6d882O1pAuX1oswWhhkIxXxbFFftsXJcPA5/eu3cjnygqy6O3Ct1p+nvDH3mF
 qACCmTKhcRfBK0BBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1792099721; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=/hE6TFrqXYpuYok253VvbchQ0KBtQW0k2a+QqfpvjSw=;
 b=ppSQRD+3Ukv7H4Uxmq9bnyVXvKcBsAqnGiv5VcfguBUsJSpc8BOOjpfbb7Sj0bkBTVVXm
 5X1BccJm3foyEQl9wpEFY40S66zrBU6GJ5PAtQzp6y1NY0NQovZYOL9yuBvKSeqi2H87nQF
 5xaU1g0lS1bueBSbtP+NZK9s5n1ItLxh4se74oBbh9pHxk6EdYXX4j3hfoNqDkN/sGqxik7
 syCdj8GK/HX2w31823Zlz4sBHuRcneCUKuekEIwi+c1noSemIK0QFu6sdROQF8pvAiqPDZn
 gIdI2c+6vlG499JOw5F2SeV0jQpkt4hhiHlNzJTT4GrGYQSdQRqHkC4idd9w==
Received: by o-chul.darkrain42.org (Postfix) id 45E6B83F6;
	Thu, 15 Oct 2026 14:28:41 -0700 (PDT)
Received: by redcloak.home.arpa (Postfix, from userid 1000)
	id 11DF54804FB; Thu, 15 Oct 2026 14:28:40 -0700 (PDT)
Date: Thu, 15 Oct 2026 14:28:40 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Subject: Re: [REGRESSION] smb: client: batch SRV_COPYCHUNK entries to cut
 round trips - 6.12.y EIO above 12 MiB with SMB3 encryption
Message-ID: <atFFiAr9gbs9jXZA@redcloak.home.arpa>
Mail-Followup-To: Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org, stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
References: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
 <441cd931c56cb539eb099bf6d976cc59@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <441cd931c56cb539eb099bf6d976cc59@manguebit.org>

On 2026-10-15 16:54:29 -0300, Paulo Alcantara wrote:
>Thanks for the report.
>
>Paul Aurich <paul@darkrain42.org> writes:
>
>> In stable 6.12.y releases, a copy_file_range request exceeding 12 MiB on an
>> encrypted SMB3 mount fails with EIO and a WARN_ON_ONCE() splat in
>> SMB2_ioctl_init:
>>
>>      # cp /mnt/otters/13mib.bin /mnt/otters/output.bin
>>      cp: error copying '/mnt/otters/13mib.bin' to '/mnt/otters/output.bin':
>>      Input/output error
>>
>> Works in 6.12.110.  Fails in 6.12.111 through 6.12.113 (latest).  Via
>> bisection, introduced by 8d103b285359 ("smb: client: batch SRV_COPYCHUNK
>> entries to cut round trips").
>
>Does it work if you backport the other 3 missing commits?

Yes.  With v6.12.113 + bc925c1216f0 + 9f544d26b15b + 90f7c100d2dd, 'cp' and 
the Python reproducer work.  (Tested with both a 13 MiB file and a 250 MiB 
file)

-- 
~Paul

