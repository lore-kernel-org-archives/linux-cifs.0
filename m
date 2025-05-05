Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118E846C
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746451266; cv=none; b=CXqu3VWzZwEV5EuiXtrT/nVvyuv2piW9ORueqD/KvR2oNtuDiu+z5X5aTxl7jE/1VYaKm72EkFqpMmBhcBpDYsQrFq7UcCrHIB9hrxLAzxX/9oFR+7yqHGPld9LWnDeTwOsp6UnyNTg5ivOsymLxgenXoCSriEtCw4ofv+cq2ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746451266; c=relaxed/simple;
	bh=aqgq1sO0FZ00ldgKW8080tQjHqJUHNpbP2Pptuvog5E=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SzbC0pqxJT6eCB0UEm0VDp4iqP8285pHa/GjUDP1J9qESjTarrOfY9M0IS0KJeJLzArhU6LZNR1ObRtPLxB+NZ8F5lUUBZdfb3DcUwv/0jbXoJbhyehGdGwLu+5k/ZKC0m/QlpoYj2YbGo0mF6ASU+FeONsonHHH7FFbApU/AdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ignOIzLC; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ignOIzLC"
Message-ID: <3d7d41c055cd314342ec1f33e6332c32@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1746450741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nrxPvV3tahgTgvIphw8AmB/SVo3F/ozV22cwavgsniY=;
	b=ignOIzLC0p0JTIfE0GSWI9vdOyPnfzfLGPq7ho2PkaLlW3dYA30HkquF5+jPq/Qq8XuuWb
	cgF9itbQPrzMMRCCh/pLr0AofTsoq/UNTTR1nddO54GxLFk7ffX5BribF3aVHCxjxQGWFT
	zpjBMs26sXA4IQNYOjkQEa/gC89RBNGYI20mSHdF4z7/nrSKsK/yg63OSOUvrcWeySXEVl
	dtPelVZZlnywl2BB2iUy/gzjNhKmJIdWDHkfVqL6RsHow0Z7hfoWgZa1IrzHhPWa+vha4S
	ByzV1sTLcLmnY8rNFzl5cqusCW+QubOdRc2aY1Pp1lwa573rJd4oVFT0SCmrRA==
From: Paulo Alcantara <pc@manguebit.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, David
 Howells <dhowells@redhat.com>, Pierguido Lambri <plambri@redhat.com>,
 Bharath S M <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
 <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
Date: Mon, 05 May 2025 10:12:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bharath SM <bharathsm.hsk@gmail.com> writes:

> If the file has only deferred handles and a handle lease break occurs,
> closing all the handles triggers an implicit acknowledgment. After the
> last handle is closed, the server may release the structures
> associated with the file handle. If the acknowledgment is sent after
> closing all the handles, the server may ignore it or it may return an
> invalid file error, as it could have already freed the handle/lease
> key and related structures. 

I couldn't find anything in the specs related to the above.  Could you
please point me out to the correct specs or is this just theorical?

Have you been able to reproduce the above?  If so, please share the
details.

If the server is returning an invalid file error for a lease break ack
sent by the client that should be a no-op, isn't that a server bug then?

> Additionally, this would result in an extra command being sent to the
> server. This check was added to avoid this case to send lease break
> ack only when openfilelist is not empty.

I understand.  The problem with attempting to save that extra roundtrip
has caused performance problems with our customers accessing their
Windows Server SMB shares.

> I didn't understand why a client would break 'H' lease on a file if
> "one client writing to a file and other client remained the file's
> parent directory."
> Can you please help sharing more details and exact repro steps.?

mount.cifs //srv/share /mnt/1 -o ...,nosharesock
mount.cifs //srv/share /mnt/2 -o ...,nosharesock
tail -f /dev/null > /mnt/1/dir/foo &
mv /mnt/2/dir /mnt/2/dir2
