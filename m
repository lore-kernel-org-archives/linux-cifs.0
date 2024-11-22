Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0D1C8FB4
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 23:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732320000; cv=fail; b=AqDjJsCXXA8UsHrWdy9a3j6utX3yqgQP0Oek/oMoFxARsHx6GAWg/dZUe/0QvTs+4r+F6z/JOPXdX6JtaEbL90ZzLKbVqumzwkje4/KUNxtj3yFhMO12wTXJZP3KnXKgucPY/pl+rTFUaSq8FqFRIuUTWmQZvn2o57hKdejhYVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732320000; c=relaxed/simple;
	bh=ss9K1qsus0RKXlxkcrX/+x290Sza6I1xhoYO+sA7P3E=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=PkLCAEE4QpcxdkY/wt4ZrstOFD/lkAg1qiqEXabIF0VLWPrPla9RAU2a5Fsz7x9vTe/UluKVNO6qlke7n4H8SL2fUYvxjVKIN0zORF2VLScdR2lMWKtPSsBK0sGCZZAOroiuEYBPS8TTOm8sR+rGZhKOdP5Tornt+djpmO52d1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=QqCvUO9B; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="QqCvUO9B"
Message-ID: <f783a9a53769e3e4f9df14621691fa9e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732319996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NWGn7ZfOkj83Oow+ImRDsYpqND4JyXNlCqTwovkMtJw=;
	b=QqCvUO9Bmlu0RqpU8wEEIHyJVc93mL93lq3whseIBmrT0mvKctaD3yLi1AU1xG7gbJGhL6
	l5VZ19l0wMdrbecwjahOEk9XeN5Jz0zg4IQgQ+SH0UPQ4HXhbLAMdYWMvEqgR+pL1JnQ7l
	K9kk+/y+SXgllRhl4iLLHTvcfAv5e49PGvjjneKfdv9r4aXHlhWNzL4wGvSJ1ipwiWgktZ
	9R6HtJP12Ywp78jjhoU/mqTYBlb5pPmHYXaiRLBqS68MoHCDyElHvxF5cKFQ23XA2IUSeb
	J58yzNlmQAQ48ap4YVWpiVLrpVC7v5rSMK3sZgp5L1xkjYWQj+1iOa41QnsnIQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1732319996; a=rsa-sha256;
	cv=none;
	b=Gn4KK8MP2tMMT5z2/PyFombrdItwtxYsxLRB0gCO1isXdOfrL3L63ajLYqJNe95MHj9NoY
	a8mhiyXS3U0NGFEYeqyPIAZ8skQJBZOyQluMDKezfvS8sxwz5og2KVtpJFNJLFy3+xkY2J
	B+43Cv8YlhpjscN5nmWYq6PgIlysamZ8Js1f8D7S4O6lMpeDG/1M5Vi4xmoCwnd7e3Alsl
	WeWvNkWaccg0wNeMu/YsVDkNV7uXHvN/a81+NF5ryLrfF5WlIHFPvB16yOAYXiGgkIOqYt
	clyHjIaxRE1dKoLnDHzcszd1ZvCTWYzKeveJrhBxSPKrsKr3UaTa+PIgLYpidw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732319996; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NWGn7ZfOkj83Oow+ImRDsYpqND4JyXNlCqTwovkMtJw=;
	b=eX0aU9Dx5n4EaR3av2vUt2DdQ3SFiIMcNhVG2QkLhMiNS+5su1KXu6BkpiwEMYcZi88pIp
	vcUAF1b01YvLaOBppKG5HkL5UTGU5KHc1HJ8oIaN29MF5E8wG8T58S2bZzqaxTdcVt50+N
	7ZI8uKRozxORv2/X14iIg5Dnx3UsxvX81q+Pn7qnaA1tVccWJQUvNHUmAZKKFFkASrWWt1
	AB++LDmhrBJ5lMr7sYTsowsQUluO1zzXkXp8xTUbxP/DnehSfwUQCRbixSNLa73mrK9H8R
	7PendIIK7pFFMl7QyeV8Jum20z5T+r0ONEpXG74UyU2lsbshAdKA7m72rMVooA==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, ematsumiya@suse.de, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
In-Reply-To: <xb4fyaabfrm6p3tuzlwtdbv74pcw63t6rjbqnrgzftm2xaeq4r@wla6hlp6nb7a>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
 <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
 <f1809e2140cd1d942b0930996ad5740f@manguebit.com>
 <xb4fyaabfrm6p3tuzlwtdbv74pcw63t6rjbqnrgzftm2xaeq4r@wla6hlp6nb7a>
Date: Fri, 22 Nov 2024 20:59:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> On Fri, Nov 22, 2024 at 07:55:35PM GMT, Paulo Alcantara wrote:
>> Henrique Carvalho <henrique.carvalho@suse.com> writes:
>> 
>> > On Fri, Nov 22, 2024 at 07:07:06PM GMT, Paulo Alcantara wrote:
>> >> Henrique Carvalho <henrique.carvalho@suse.com> writes:
>> >> 
>> >> > According to the dir_cache_timeout description, setting it to zero
>> >> > should disable the caching of directory contents. However, even when
>> >> > dir_cache_timeout is zero, some caching related functions are still
>> >> > invoked, and the worker thread is initiated, which is unintended
>> >> > behavior.
>> >> >
>> >> > Fix the issue by setting tcon->nohandlecache to true when
>> >> > dir_cache_timeout is zero, ensuring that directory handle caching
>> >> > is properly disabled.
>> >> >
>> >> > Clean up the code to reflect this change, to improve consistency,
>> >> > and to remove other unnecessary checks.
>> >> >
>> >> > is_smb1_server() check inside open_cached_dir() can be removed because
>> >> > dir caching is only enabled for SMB versions >= 2.0.
>> >> >
>> >> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> >> > ---
>> >> >  fs/smb/client/cached_dir.c | 12 +++++++-----
>> >> >  fs/smb/client/cifsproto.h  |  2 +-
>> >> >  fs/smb/client/connect.c    | 10 +++++-----
>> >> >  fs/smb/client/misc.c       |  4 ++--
>> >> >  4 files changed, 15 insertions(+), 13 deletions(-)
>> >> 
>> >> The fix could be simply this:
>> >> 
>> >> 	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> >> 	index b227d61a6f20..62a29183c655 100644
>> >> 	--- a/fs/smb/client/connect.c
>> >> 	+++ b/fs/smb/client/connect.c
>> >> 	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>> >> 	 
>> >> 	 	if (ses->server->dialect >= SMB20_PROT_ID &&
>> >> 	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
>> >> 	-		nohandlecache = ctx->nohandlecache;
>> >> 	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
>> >> 	 	else
>> >> 	 		nohandlecache = true;
>> >> 	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
>> >> 
>> >> and easily backported to -stable kernels that have
>> >> 
>> >>         238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
>> >>
>> >
>> > Then I could split this into two separate patches, one with the fix for
>> > the mentioned commit, and another patch for the changes in cached_dir.c
>> > (which I still make sense to have).
>> 
>> Removing is_smb1_server() check looks good, but the other changes don't
>> make much sense as we could potentially return -EOPNOTSUPP in
>> cifs_readdir(), for example, and -ENOENT is probably what you want.
>> 
>> Am I missing something?
>
> I might be missing something, but only place I'm changing the return
> value is in open_cached_dir_by_dentry() so it is consistent with
> open_cached_dir().
>
> open_cached_dir() already returns -EOPNOTSUPP for these checks:
>
>  if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
>      is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
>          return -EOPNOTSUPP;
>
>
> The changes in this function relate to removing unnecessary checks.

Sounds good.
>
> --
> Henrique
