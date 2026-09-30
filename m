Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F6364931
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790992; cv=none; b=stslUNkXD5f/D0UBR4dInp6tHGTwlu3GEt+OQaiKPXTDW0Sb+EApZf1kGEBmEg9cWB3JO+kwJJ+AaZKT4LvFpRCq+No0+IxUI6MgfR+Bt2h6BkbOalploogVSUNLXpvl6SoZGlqWJ9rncjuWsQuXack9zbnSamsPC8kf6gpmZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790992; c=relaxed/simple;
	bh=KS4QDGG3Uq4c1qv4hF+a3vEzQ4M7Ljnp/hKL5Il5CDE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=TzipLW+L0wZkDPLi8oyn+pbc65mJeBJsc0rxGC40SRBl02Q4aImQVNJvPnz4o3lReasNGlQakWhtK2GdLC0P/0O4UI3oqkPGHqF6ie/WsV3VfcUBi/5KgEUewZknUurKgolQTtMp92YVsVSIKJBpynHwdqz6vTims6v3X+o6NF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=wToBainF; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="wToBainF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=euj7UTZXQdokpbSLplQ/LcnVUy9KnYpkW3sLYv1MiMU=; b=wToBainFHGlg7wr+17aFKv3qNB
	lpW1+B2CQ8HdXV8PoNMqFPVpkgRBWtjyTFVfp5NfpXvss9EJHpygAoCqTvdux6zgAh55rZfIV0CAg
	PKNiu+SaQVFpXD85s8TMs+TRlzHZls167QDY1EscZ9rJYKzp0p3HOTJ5qzp+2320rJR1ZDdwnNQM4
	6b633NA/AgiXZ1MKQ25TP3ZNns53kgae7F6bVUSVBb76TkoK9p3A1uP36GPQ+ZSx7zw9GmmgTlY/F
	nXr/w4kfEyhfnrqYEUxMBjyfwwd/q/P8CfAxv5olp8LNvA8taWSeDseRnVWgJx8qino+hcjTB8WHD
	GsF0jh+A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xByXc-00000002e99-1KfF;
	Wed, 30 Sep 2026 14:56:28 -0300
Message-ID: <c49a534edb402ce127e794a948681ef6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: sorenson@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Henrique Carvalho
 <henrique.carvalho@suse.com>
Subject: Re: [Discuss] smb: client: bitfield aliasing and locking chaos in
 cifsFileInfo
In-Reply-To: <7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com>
References: <7689764e-c0f6-4016-9557-b54cf4a3de4e@redhat.com>
Date: Wed, 30 Sep 2026 14:56:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> I ran xfstests on cifs/cifs-next (7.3-rc3+) with KCSAN enabled, and caught
> a number of data races in the smb client.
>
> The most concerning finding is a structural bitfield aliasing issue in
> 'struct cifsFileInfo'.

Nice catch.

Please take a look at the following fix from Henrique

        ec306600d5ba ("smb: client: split cached_fid bitfields to avoid shared-byte RMW races")

You should probably fix them the same way.

Regarding the serialisation on them, yes, we would to check which one
really requires it.  That could be done separately, too.
