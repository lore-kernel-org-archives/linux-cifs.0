Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BCD23BD1B
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789568548; cv=none; b=sW5UmD2dLrhf7zzbxvEwXyGp6v45sOAa/bBCRLWAH9HvgpKauzVpyepaBmrMPKw1El8gPIxXM10pXWNFQZsitHZwghpALJ+uK1VieoKyzEKVka4fnpJkl2EHDcgbGt9CcfTXy8iTufpyWPCLH/ZYyfJUPNxhPhJvk6RkzNjrFG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789568548; c=relaxed/simple;
	bh=6E+xzTL7DbkU+p8+lJHA8G2s+FloobMidjGveHbpIw0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ronD8V7rwgnupvFYua27ZlF7qyovn/6LZ7W6LQIsVADRVOaAwrGTIreJ5Co/9irLnLs9OYjYoFhoY49OXjTn6EYnUZPih5nJkPX/eYewXqKYlvFipZ0oIIuuOIL9hCKaPq7LtTH8u16fexQrnqVK2oiuaAYHa2AacL4v+M7VGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=NWd71Dm3; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="NWd71Dm3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=4IGM/rH1LVHBe5P6HSqOSvDe4BGVXc+zTcm0hyj+cjs=; b=NWd71Dm3rjxXlOQIlpwefthc9p
	ohDDE+guWN2ShHDtYqVDFSJoahcB/SVUWASNPJm0Tq25uWHHLIBqq5Ei3th7CjRfXHSH8S5E5tvDm
	6jee2GweXqfRAOtWkS6qEaPu8mo03fTj0sq9kZRVJuZhMA6fLTjdKJg7cWY9RELEstUo0pooLEd/m
	l50uzjup1By0PS5MQ4cDEouUbP8smhqj6mTTRjS5Qjgsh6wu0M8lSH9GX3ztLBzxtZzJDBrvoAFXb
	mzZACDlRLRz/7KYosc69AgbwpIYL7Jhuwlsehq2TUhg1u+guzrmuSjGAFRQ1T2dRJPlKfnMNb3Oys
	XEMQDTQQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6qWj-00000001Zka-29rZ;
	Wed, 16 Sep 2026 11:22:21 -0300
Message-ID: <61c3e91f49dd33c4acc172eb95730d31@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: sorenson@redhat.com, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH v4 02/10] smb: client: validate minimum PDU size before
 smb2_get_data_area_len()
In-Reply-To: <6a11c41e-d636-4051-9b89-95186eb8e280@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
 <20260913214510.3071370-3-sorenson@redhat.com>
 <0b3d295a3f9ada22c99ac4e49b935106@manguebit.org>
 <6a11c41e-d636-4051-9b89-95186eb8e280@redhat.com>
Date: Wed, 16 Sep 2026 11:22:21 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Frank Sorenson <sorenson@redhat.com> writes:

> On 9/15/26 10:04 AM, Paulo Alcantara wrote:
>> I don't understand why you're creating a new array.
>>
>> What about to replace @has_smb2_data_area with the above array, then
>> have something like
>>
>>          #define smb2_has_data_area(cmd) (smb2_min_pdu_len[cmd] !=3D 0)
>>
>> and in __smb2_calc_size()
>>
>>          if (!smb2_has_data_area(le16_to_cpu(shdr->Command)))
>>                  ....
>>
>> Then we don't need to worry about keeping both arrays in sync.
>
> *facepalm*=C2=A0 yes, of course.=C2=A0 I will fix.

Thanks.  Please also check if you could replace some of the cifs_dbg()
calls with cifs_server_dbg() or cifs_tcon_dbg(), respectively.  It could
be useful to log the hostnames or UNCs from such broken servers.
