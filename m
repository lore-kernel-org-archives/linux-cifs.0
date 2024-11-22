Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF7C16EBEC
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732316142; cv=fail; b=Ne7z9SW0uY9bugvrg+R/UuDf53PNaN/eUeMLtX8dD/FTA/Ne/VZt4f7axv3KBFQ+dYrMOOfR96MgpMxK6/NKxHOV/OYKW3U0fRRVdwhNIZR5YdBXSBG20+S6GgbsIfflu3LjBVWFsihswfRlUnLyYYrA0IF+ImyEh/dVLh9an2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732316142; c=relaxed/simple;
	bh=M6mdQFkvY+BTggRhHcJnQ5gi8Puiu9Bm7M4PoxsTWOA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fkXnMWGr6CXRXKBrT90sMwdCtdBzbG0L78rE3vhBqRsM3nyqtYpm6OOc8xi2ZGHjZqo5+q9Q3jaOp+QmG21/JWUAGqJeO/dQ1AIdTYoT4TuB635LlFDhCog6DkYiLbr39gejvtpGJD4ScD1X2tiyAp7JmhjhioT8mYUl7wha6vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=JjG0LGYD; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JjG0LGYD"
Message-ID: <f1809e2140cd1d942b0930996ad5740f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732316137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Wa77WSkRdlp40IbjBcUBk0nRqGqWc26D8ilF5UPrvY=;
	b=JjG0LGYDswjZFmSeym5RwJwj85gwLY7exfMFLG1b3mVPbm1wVJt8HJeAxAhXUp3iUZMMTj
	fT7yho/moYJw7FogKw4A7JK7o+sDjLR9QJzalgPeuTVxtcMG6x45W7dsyIEjA17C4t8QQI
	bcOCwi2BmendqKyZMaoGG5aonLuz0UnugkjIKM+sb3sPRwe1nO0OJr+evp3/NxaCD9v0Nx
	r/XO+ibO6LPi6sC4AgsXQA+CkKHexvxYX1Y9CweAth94v01EzxaArSQBtF7pxPBmamXS/s
	e0yCjQ56F2cQzvsKvrQLftO32U5LXR3OPI+R/3G+8lkDb3QSIEMxe2GUYNBk8g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1732316137; a=rsa-sha256;
	cv=none;
	b=Z5qBw3ae/pCogHgRuR4WPYWZRx+EUwcXkQTejSnX6uqr0h5/8cvvDqQdK2xMCTU0SBfd2N
	qL7OTgk/ONsEfRFOxXClmW5APU/t3nrpPtKO9jstem7UAGeLnsjXhRsKaLt5NVznhGnRO5
	/4T0msamwVkL+tq/13Goxu3aUpEst3mV9rkbZhdkRh9NCSJVil5VeJY9++vUwEyFscJ1N4
	Opx7WOVw1gXVsKZBQ7xfI/g9AHxHGqaIVmyxy0jTPiKPD0l+PS9Gq3csaFGIxXVDvYotjc
	mWjb4ZDG1CRBLYcH3XjVhKMsrXK6hdcaCbbFo1/I+QNk32ezZMm0yJUYyh1bsw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732316137; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Wa77WSkRdlp40IbjBcUBk0nRqGqWc26D8ilF5UPrvY=;
	b=CbY7O5oC6AuswpFBdc0NACdoxKTC01MrZD0JotBDYFZA727Lh2dH7na8wx8AXdFKzsGSGO
	kj3hQJb3WpH1IGSsGxa6/w9XiJM7ao5JmMwqz6fVGfiQ35pc/LIz1j35uu+lvr0sU6PAyj
	xVGJFrVCeEnUrP4iTKvtUVVf8+E6Wh8tOufYTi+3XDNK7FVULB3xoavyXYrQljZ49TvDBf
	jLrxUzlsO1bR4PHWNnehiwGPJw2Dl3IsPqOFgfGdHLvNPf71DnqMBRjUx2ya63rh9XLdtt
	E0HjEmzRQ0/IrczY/2mLjq0pH3aRP4Xipg3ytoYWoeH5eVC/tMD2qJ4nScaeWw==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, ematsumiya@suse.de, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
In-Reply-To: <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
 <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
 <cpbqdqjvgoaamvhg262ruhcnkilrns3gwabcwjgihsvjx7yict@jqzjvkkutjta>
Date: Fri, 22 Nov 2024 19:55:35 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> On Fri, Nov 22, 2024 at 07:07:06PM GMT, Paulo Alcantara wrote:
>> Henrique Carvalho <henrique.carvalho@suse.com> writes:
>> 
>> > According to the dir_cache_timeout description, setting it to zero
>> > should disable the caching of directory contents. However, even when
>> > dir_cache_timeout is zero, some caching related functions are still
>> > invoked, and the worker thread is initiated, which is unintended
>> > behavior.
>> >
>> > Fix the issue by setting tcon->nohandlecache to true when
>> > dir_cache_timeout is zero, ensuring that directory handle caching
>> > is properly disabled.
>> >
>> > Clean up the code to reflect this change, to improve consistency,
>> > and to remove other unnecessary checks.
>> >
>> > is_smb1_server() check inside open_cached_dir() can be removed because
>> > dir caching is only enabled for SMB versions >= 2.0.
>> >
>> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> > ---
>> >  fs/smb/client/cached_dir.c | 12 +++++++-----
>> >  fs/smb/client/cifsproto.h  |  2 +-
>> >  fs/smb/client/connect.c    | 10 +++++-----
>> >  fs/smb/client/misc.c       |  4 ++--
>> >  4 files changed, 15 insertions(+), 13 deletions(-)
>> 
>> The fix could be simply this:
>> 
>> 	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>> 	index b227d61a6f20..62a29183c655 100644
>> 	--- a/fs/smb/client/connect.c
>> 	+++ b/fs/smb/client/connect.c
>> 	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>> 	 
>> 	 	if (ses->server->dialect >= SMB20_PROT_ID &&
>> 	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
>> 	-		nohandlecache = ctx->nohandlecache;
>> 	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
>> 	 	else
>> 	 		nohandlecache = true;
>> 	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
>> 
>> and easily backported to -stable kernels that have
>> 
>>         238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
>>
>
> Then I could split this into two separate patches, one with the fix for
> the mentioned commit, and another patch for the changes in cached_dir.c
> (which I still make sense to have).

Removing is_smb1_server() check looks good, but the other changes don't
make much sense as we could potentially return -EOPNOTSUPP in
cifs_readdir(), for example, and -ENOENT is probably what you want.

Am I missing something?
