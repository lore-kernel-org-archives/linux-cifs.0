Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E9118024
	for <linux-cifs@vger.kernel.org>; Mon, 12 May 2025 22:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747090680; cv=none; b=AAU7oowI4Bxi6vfVf5euF4Xc79tfSQSNA/2fnXGCGt7Lf88NFLa2RdyWLHqTv3LY2hJ2H9oJ5agLBhsQNeJyZLACq0RM9TzIoHJ51jMWnLpvCt8P9dhEh+EIekekzblvC6ifvhGycs8FLpgVCZ36pRPWMvC66zG+tsWZOgVvadk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747090680; c=relaxed/simple;
	bh=UUte5PlwpTG7GzVye66hQKuHtM6ULk870glJwEHHDTo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=TEywqBqmBb/oJxWk/oyy2JsKSXJYeNNpPMsC4IijOCMF5Xo9J0Oe9dsII4YCylgUt09+JFVRtRdjQRsMRAF1rtErAIt/566advB3ZUPL7xxUlpus9D6Rl5T4xNJXSLj/BkzTrKtDseGNM2g/0GGiG5eh9T94Vh2wvkoCLJnEH8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=obPzezQP; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="obPzezQP"
Message-ID: <2f71b485b8a733acf11c5de66e68438c@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1747090676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrmQFZQmwvXAURtSmxjz/L1sCYGbtxTrsIHrPveDF5A=;
	b=obPzezQPV3zCoZ9EzHcVn9qZNao6JTaszNpO9F9yO6A9uq6yVWJAXMz9B6JeL/CwDiBNr3
	fhj4owfNJdQIKM37HOcQ0nzqofBIOB+IMnJCW/3ilvWN1Klu7kCN1QEURmoSI5Q0sPMA9G
	38coTa2aXUZrZ4ZU/B/nTabyOznUFSqQEILajBCKMbmxIqYLgn/CxifN80IUUwMdxNoPQ/
	cOQUyWYob51EprXFcGfU7E2EUjf3iJREW07R+qIL34Kw4GhFjWvivu7Yg5z1l8TPqoqo9c
	ktczviHOcVs5IdQGTGh8CTe4U/EMlSC+FYuaxXYIVAow9pCbM7xfd7kjMPc9TQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Bharath SM
 <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, David Howells
 <dhowells@redhat.com>, Pierguido Lambri <plambri@redhat.com>, Bharath S M
 <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAH2r5mtmcFWw6Gm4hg9Ze_1VnN-t4d5LSmEh+oObKASWNXbatw@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
 <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
 <3d7d41c055cd314342ec1f33e6332c32@manguebit.com>
 <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
 <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com>
 <CANT5p=r2-Sm-9=jPY0YM1mV4J0H5fOG31WSZ+E_4dKqNcNJ_Kg@mail.gmail.com>
 <3d60f40bbcd3d297b860f4359bf63def@manguebit.com>
 <CAH2r5mtmcFWw6Gm4hg9Ze_1VnN-t4d5LSmEh+oObKASWNXbatw@mail.gmail.com>
Date: Mon, 12 May 2025 19:57:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Steve French <smfrench@gmail.com> writes:

> On Mon, May 12, 2025 at 8:31=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
>>
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>
>> > I think this version of the patch will be more problematic, as it will
>> > open up a time window between the lease break ack and the file close.
>> > Which is why we moved the _cifsFileInfo_put above as it is today.
>>
>> Can you explain why it would be a problem sending a lease break ack
>> and then closing the file?
>
> It is a performance issue to send an extra roundtrip that is unneeded, so
> key question is why was the close not sent immediately if it was
> a deferred close case.

Agreed.  Even worse when the saved roundtrip causes concurrent opens to
be delayed by 30s.

Look at the commands I shared.  The close is sent immediately after the
lease break is received by the client.
