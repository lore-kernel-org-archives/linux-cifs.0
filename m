Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188EA34AB1B
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756840192; cv=none; b=ed6J72rpoGZv5oCUFxKnoDUGuyNWGBMhZtrbSKQgrfgAIH2TBvKOOFh1udQ7orCLxQGSMzK/mJPOPbxICfpMSud8q/vsId+/vAirKnI8q2+AsL/VHlDBrbCuwFo7MsG9K5RVny1JpQPas1y3ehXGHYganhioxDpT0G+uHj/lg2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756840192; c=relaxed/simple;
	bh=9Kfhstu0vCPhXyZB4w28kYeF5U1iV7GO1re5uVlmXtU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=paQNSAZnrydRIZ1CsmOOsMGbT3yrXvZkx14sdeTbB/z6zmMjWxrsLh7ykWWvEwNGcmkaN/tdZy+BGlFHeTbAEmn8SIX58qtAFIoihN+PLvy6o6iyirhJ7qjuOWvie6Wj2UAmNxH7C4vbxdCC1NpOzMv8RabyBNU9KOu66HXVO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=QArtdtap; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="QArtdtap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tl6qkTiWM/iYbz5V8fPHuvH+ChWaWnPMbNzcr1PVqDs=; b=QArtdtap13GVrteZ4qQMbtYYja
	CDyEejCekiIQxGXaqc1nXyC4NASJjGIPp1KvSD5XAWz68Xe3LRu8LBlA3tICTZiFS4qIeuFXsOEC6
	Rj2fIb79s1iIRLM2oE1obR3d7GWC/k2R2VBSTm5/H4nYGnvmdqCjZrdNDHAIZXzpEpSA5KhdnshbV
	YRObwEgRphbgVMSFEJCSN9h80BEpJjlOT+lSUyVnbkakAQALr6Cy1ggqVdeFgtIwhpmmti0s0+/t/
	9wyuTRzRdlpmH4CGtbufti/GCxV2kRHNY8pfmnKxn4kpRgc4Km0vPYZcCpGMZDjJdQw/1v0zBRx2J
	EeC8buWQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utWO3-00000000iGT-0u54;
	Tue, 02 Sep 2025 16:09:47 -0300
Message-ID: <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
Date: Tue, 02 Sep 2025 16:09:47 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Ralph,

Ralph Boehme <slow@samba.org> writes:

> Why not simply fail the rename instead of trying to implement some 
> clever but complex and error prone fallback?

We're doing this for SMB1 for a very long time and haven't heard of any
issues so far.  I've got a "safer" version [1] that does everything a
single compound request but then implemented this non-compound version
due to an existing Azure bug that seems to limit the compound in 4
commands, AFAICT.  Most applications depend on such behavior working,
which is renaming open files.

Once we rename the file and then mark it as delete pending, what other
problems do you have in mind that we might have?
