Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA0C3DDB1D;
	Wed,  2 Sep 2026 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371289; cv=none; b=WG4mZocWwQUstqf3e7+2Tsk0Cw6cykUf/SwR1z480c7I49Nwggvntp1OpnswwDa/AG1VDf/2RNp3DZjUIojVGw0TWMRboTv4Q5psOsTI5vWocNoDI0HvLpsQ0ES1j4uYiHF8nWMW6aGOOD8M9BpVmkU6JFXCYcabWwG3aehGVno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371289; c=relaxed/simple;
	bh=96bnf5Ay0NWyRYE3n5heQ5d+s0k6AzcgMD0wv30tl8s=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=HbnLgYhxem5rgxzwzz1ml29t59MlA9xjPXnVRpwXsDWDaBkg3qug63nGrND2J7no/2eF5kg6zGFmoWbSL6R5jLGakFxUZ/4kNyugo+cSTHLALIfFufJ3iuxBgByrns3Yp6TdWkeHKZzGXCLJkKTAgS42UlXdGgncMZJX4g626SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=m7G7k1iq; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="m7G7k1iq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+zGqViqajbDVzzs6i/KKRDonBemKHDWDXGoETv6wS5U=; b=m7G7k1iqcuCOa+ZtzTSgIObzpE
	51iK6QjHhb6VRLRp6JQFueRhdV35DR/Uld/NWWufep/yzJeXWejecCqx4h0EtHfa1J/2pkW8m8atx
	uP4/SDOTfgZUMYzWB+RATX/10+8m0mBeXcrDF9hroFKOto9Yb0ujZYIChTqd8QDMaQ2JWMTR8bFF2
	RZ77+1Nz9u1U/ejl0aDoHwrzt5icaRYVeAbm3y8KQMlAZXLKjQyNVPV6Lkj0EQWiEWynoz3YWgNEJ
	o833gmiUc0MxTsnmao+dGmz812wUm3fqGfwWXrkI32wktQfp5KsgccWqXQKBmUbGW3FKld+2Xt+Bm
	Q1UyBDNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1p49-00000000X4Z-0cV6;
	Wed, 02 Sep 2026 14:48:05 -0300
Message-ID: <7f87f15e7136147297a33a540f0880f3@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH 2/2] smb: client: prevent out-of-bounds dfs_info3_param
 access in copy_ref_data()
In-Reply-To: <notmuch-sha1-3e5d257ab3acfa72da7284e13dd0c817fac4b88c>
References: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
 <20260826191033.162320-3-fredric.cover.lkernel@gmail.com>
Date: Wed, 02 Sep 2026 14:48:04 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> Fredric Cover <fredric.cover.lkernel@gmail.com> writes:
>
>> Currently, copy_ref_data() assumes that numrefs > 0, and unconditinally
>> accesses refs[0]. If copy_ref_data() somehow is passed an empty list,
>> this would cause major out-of-bounds write and read problems.
>>
>> Enforce numrefs > 0.
>>
>> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
>> ---
>>  fs/smb/client/dfs_cache.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
>> index b0388c460499..b51c8355d73d 100644
>> --- a/fs/smb/client/dfs_cache.c
>> +++ b/fs/smb/client/dfs_cache.c
>> @@ -389,6 +389,9 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
>>  	struct cache_dfs_tgt *target;
>>  	int i;
>>  
>> +	if (WARN_ON_ONCE(numrefs <= 0))
>> +		return -EINVAL;
>
> I don't understand why this check is necessary.  All target referrals
> come from get_dfs_referral(), and in case @numrefs < 0,
                                            ^ @numrefs <= 0                                        

Sorry for the typo.
