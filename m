Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAE92BD015
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756916379; cv=none; b=PfmJwU5suYGGXccwprW07+80SlCmM8ckoHl1Csy3pGBO5asIgCNgZxIsI5gj4Zz0zkAsmpuw1XozSp2cHEMrL3Aames6k2JZBriw/yUVqvmpvsRI6mQzFqZVyRS0lqspwNvKxHxK31aBf+nuVWg4HjxOSzuJdS2p41wXoN6rrrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756916379; c=relaxed/simple;
	bh=Yue4a7TyqXlr8TLGVYdsrbOPPs+23nPFfhFAxYDY2cI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=D/ih0Emm2GSfVt8B5JPE2nGSa4i2K31l5OtNXJSSrL0+JFP/LJwJFHyzpu2PHBfpqAmJjCOqHp7cSS2UBpg2yaxDFxSiJjgzKD9eR9Tk3KOefh/dhLLQgaedYG4h6bLS54hvfC73ZjUOgn9cIH6HHKMZI1JxFJFcoPB/U+I9+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GXKOu62A; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GXKOu62A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EhQYRz6mkCzjJBLtjAJ0hfJNGRCmJX23t7e29fUytGo=; b=GXKOu62AnEWXa6jCiMO1WJkzd7
	14MgaMJu1uzgzRPaA9DHyfXaOpTrL0GItLLcoKy0Y05pFbXAZfX5kk3MZ/7UNWY7V/g3zFGVMd492
	P5Oip4EB9GCoVDTsQWnCQMNJT7ERc2r2b4f14OBevCl8LB9xOHauixrKFtbk0wIG99SvvdEun8TcQ
	TcFDXej47XXuSjlPlGxmobwBUamfAKgOalJ9qOeVwebogDbf2I96fpe61OeJjbV0MP4buQOafDACV
	JzPdnAISz6XyBmEpjOa+GsGc5gMqOH7+0XDQhj+Qz1I07Bz95cZQJrALK0wMRMT9KW0SttgUIOpeG
	N2HWBHMg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utqCr-00000000ljy-3T3j;
	Wed, 03 Sep 2025 13:19:33 -0300
Message-ID: <7dbf8f8019d8e5a0cd16c47b4ae319e2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, Steve French <smfrench@gmail.com>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>, CIFS
 <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <CAH2r5mvqJXfgQwKLSWrfBDw8Rc88ys8a_cWB5DtD19HSDmFn5w@mail.gmail.com>
 <e66bfd26-9766-4075-bb8e-89df33e88e59@samba.org>
 <b29ed180e00cf6197644e54d944c59fc@manguebit.org>
 <e2a50c26-42ad-4060-9da4-96f89517ee1b@samba.org>
Date: Wed, 03 Sep 2025 13:19:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> On 9/2/25 9:39 PM, Paulo Alcantara wrote:
>> Ralph Boehme <slow@samba.org> writes:
>> 
>>> Likely? How? Does a Windows client also do this stuff when the rename
>>> destination is open? All this additionaly complexity is only waiting for
>>> bugs to happen and now that we have POSIX Extensions back we should
>>> phase out this crap.
>> 
>> Claiming POSIX support and being unable to rename open files, that would
>> be even worse, no?
>
> with SMB3 POSIX support all this just works including renames, what are 
> you alluding to?

What I mean is renaming *open files*, which is currently broken in
cifs.ko for SMB2+.  IMHO, anyone using something that mentions POSIX
support would expect renaming open files just work like in any UNIX
enviroment.

The protocol allows us to implement such thing, so why not doing it?  If
you want to us to return -EBUSY when attempting to rename open files,
then we should mention it to the users to keep using SMB1 to have such
fundamental behavior working.
