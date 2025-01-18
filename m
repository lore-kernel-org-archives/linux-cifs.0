Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41184039
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737224209; cv=none; b=AWjG9oxSZCVU6Eiv1kpYFQpjQJ9FEdqn2eZTNDTzZq3GMstLDDRHr/G9PBly2vGhL5CtCteKezybTj2LNNikrzwYE7xQHwl7vHFruLAMUC0XpIUevqFmj0cOd2IGqoD+Qm5TkFoYCZSiJ8LsWdRcVrcnxzEsKSFiWdw38fHzdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737224209; c=relaxed/simple;
	bh=F6EG1kTVlrBrBZJ0txfSn69CbvXhmyrX8JunoNxfj6c=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=pQytestTcOftf77vP7ITh+p//ZhIaF3LkS4Y+W5cb/58ps0b6a5AqO/kB2eSTPMbLq5ZP+fpxNMWCid9zZozO8eOoMuKrhyLOhF3hKC/g0MRkOJnY3Rh8gvLEFZt5UraZFCZ7nWFuvvEB/5iMICgyjPiqpRaOdla7ChUtekgVQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=jOE02XYg; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jOE02XYg"
Message-ID: <90151ee469458d74e7ada8b1fb2e85a0@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737224199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C5LtjVENzi8Ge8fbVhZl/7sda7ojtrXNZIocqueTkBY=;
	b=jOE02XYgezEKAcs994BpNISIjk/ICruPkPNzU6ldjmq+4QbgQ2yJUsCvQHyUu0dih4RrKm
	r8PprQKILWJ4qUOftC4E7bhXUtI70uMUBSwsyltGE6LsPGZTRqh5SJnHEJib2jkzPzY+NH
	5Pb9fVOwaqNg+wzDPhUmPjSe5N5HmJJAIhsfQ0+xhS+tsgGGsJAx1Dv3IGReWa+8KJ6Tnt
	Ni2QFhlfz7/0S5I51+ggWMnN268zrgry3QV75YtGTB5QnC9TsKA+yT29A0xZbEDmC1TJYx
	X6h8CBfck4hsmlVTFyTZwVYFCOpcu/SQ5q1MFNatbVUyl/xHAr2yNwXGJKGcOA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad N <nspmangalore@gmail.com>, Tom
 Talpey <tom@talpey.com>, Frank Sorenson <sorenson@redhat.com>, Jay Shin
 <jaeshin@redhat.com>
Subject: Re: [PATCH] smb: client: fix oops due to unset link speed
In-Reply-To: <CAH2r5mugqpmkbh5=TThZqp6XWGGCsOOdfQWvei2JjbKST-J0Nw@mail.gmail.com>
References: <20250116172903.666243-1-pc@manguebit.com>
 <CAH2r5mugqpmkbh5=TThZqp6XWGGCsOOdfQWvei2JjbKST-J0Nw@mail.gmail.com>
Date: Sat, 18 Jan 2025 15:16:36 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> With current for-next which includes this patch I noticed xfstest
> cifs/104 now failing

I can't find cifs/104 in xfstests.  What does this test do?
