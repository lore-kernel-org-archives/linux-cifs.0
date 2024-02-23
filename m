Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64DD76039
	for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708697316; cv=pass; b=bUd57rYRvUZmHqSjw6quSNUVBxzB8MyvNdl5ROn3KbD396/fdTDiTbwrM6ZNCUq0ncNMMM7KoN1ZHXJNW8YGhvR5rSER9eEc5gs7gHr+BhQsIKlbPw5+mwBwOcaTKyupMss5upevYKeiKPu88MWZUVVg6B81uHdX8Gz3OdQSZy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708697316; c=relaxed/simple;
	bh=GhSpiUN71FtSiIUHtfntpSS0l5wK/UGRP/jVFESSSxI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=U/aWn9lHeFjCasQlABojFGF0VAxUM6z7jEcurm/n8w+uGAh1zPxkW419YpzALwQme2/CNQbj5ilZltB9wh7aASK9COLoTXZtnjjWZdOIf4NvDAHTGIGtzBRSQ3BoJqJrPT7VU79hfF6TsUELt6cGZ7MV+aSSCFYcnXsz/+bbKA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ULbon3Cx; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ULbon3Cx"
Message-ID: <e215357d673befaf1a2198aeb26b595b@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708697311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DQ/LzJJfBJCKVDK6q7WrGii3p2efzatgCGr1R/lL0Io=;
	b=ULbon3CxdOjjIkuaOJgE/wlyfRO/FPejJfsfYuaiDCwB0acHg9dmddFtb8GRmDsEtscHaI
	fac2Wi09sOuuuCn5RhAVCtb1PZ2pho5LD8ipFLVnSmnTh4IY0TLEo+BFcrOlVU7hKk2UrO
	xgCGte4B74G/MjOhyP+U6TMMOrHLC11fjuJrMIUFelI1MG2kaf9nbEGJVUGt4QYGVnbGQ5
	kJX+GHm4ZEquijTj1F4TQwu3qf4dzLs8QBT3ai6es7GUlUE8sWyG7Ju/GuOF9SRt/tmwbJ
	RGKLcAMHRLedGE4QmXcQavh+PTulFW/2UPgwhoDACn6QHFlTcA2GLyTo6fWcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708697311; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DQ/LzJJfBJCKVDK6q7WrGii3p2efzatgCGr1R/lL0Io=;
	b=Z+EFF2NYL7AZP2/DCjUT9N27XaCQt1Ei72rOhncPFW6uXIJ863dJBunMRyRwIwmF+KZQm7
	Y3KTOA1bued54MjEgUqmwCFN2D9xfiyE9F8Ji7doWIrADUkEWdI0dReR3F1wz4a9MqBi0V
	jR1K/CESjUcEbbzKU5csMvhvBoQ9ZGUvPU4Q6fBB5fcfghbbTfD8XuKp53MHExaLV6r7XT
	5Ui39Rj3TVQe8xmQkjsu+8PLLnF6wEzjVI/xnwMfPmY9hT0DYzo1s7fy0DmLlrmdDSM84B
	ueeW3i+4CMWiX46vXUwssrs80WlhYQYurvFRIa2ye8HAV8aPJfYyLxZpz6G8xg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1708697311; a=rsa-sha256;
	cv=none;
	b=Yk8Y86VPl8FMJacYJytZ9HWQDgoxbfejODI11gHuXgjrreH4Jv7uBy+uTQFfqPGTsgYKza
	wyrk7kTglrDYT2t2hLqAAoAng8q1XHrx5aDxF8MG/TiEiFPLEj51hGeLULxo8g/i8043ji
	4gqKNdGUt+rAhfKrl2vhfciqcKYUkWBc/Xuh7iVz1OxWGXiF2gacNKsjeGRzKt3iueVthS
	rg3qjkpBm4q/bcPXU5Ho6nzaWP/YrOLrcv1Ppa3sWZsZokvfuGK/DvnA+nBRejhGD/5sSo
	nS6H1ARrTcmdwGdeUVNIbxkw6ofnEVKx2NP8MSnoCRpiJNgkuSQ0OeYzt+OkMQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>, Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Bharath S M
 <bharathsm@microsoft.com>, Meetakshi Setiya
 <meetakshisetiyaoss@gmail.com>, David Howells <dhowells@redhat.com>,
 samba-technical <samba-technical@lists.samba.org>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
In-Reply-To: <CANT5p=qTe2XQJYVdYiVkc34WdsE4ekHaH0f4uMwUoDtSNchwug@mail.gmail.com>
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
 <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
 <CAH2r5mtSB0nDKxAJHtnp6USgoeVN7hNF79NaOcX_pnF5MVPFhA@mail.gmail.com>
 <CANT5p=qTe2XQJYVdYiVkc34WdsE4ekHaH0f4uMwUoDtSNchwug@mail.gmail.com>
Date: Fri, 23 Feb 2024 11:08:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Shyam Prasad N <nspmangalore@gmail.com> writes:

> No major objections for this patch. While it may not cover all cases
> like DFS, multiuser etc., it's still a starting point to allowing
> users to change password on existing mounts without unmounting.

As long as it doesn't go through -stable and is accompanied with at
least a new option like 'forcenewcreds', should be fine.  Then you have
the next merge window to handle the missing cases and fix any problems.
