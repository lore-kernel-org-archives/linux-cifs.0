Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C75B26B2AC
	for <linux-cifs@vger.kernel.org>; Mon, 28 Apr 2025 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745851467; cv=none; b=t9Wcoe4lxKPlxbt55AQct3NZhgBBUEFUwlqDQ8mA+BxdWpthNInwGMu+Ybz9wD+EUVYQz3sta4fR0ehZLPNoCiLvsBcyg9WvHXYZE5cMn0DrkuUfFQIZheIOh29/8H7nFFuusLMvODKIiBxi/TO/y6BNzGdgFTTa1F/TUalnji8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745851467; c=relaxed/simple;
	bh=725WkPoeTerLtu4+LzkFJErq5dQxxK0e3+jZ+nc8OH4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=dK0LCNildU4/wDpatxe5T8TAoqODT3OaUKHPZ9du49AZYIAtIwxe7H+UnKoj5G8s+NEECWUP9gS6xycXax1+A+108spY53vDuXhvuFu7lLynAkY1ondUHGvnM0Do3ofOrNK1/Z/Eec6uz+WrlEFCFIzNSw5uBpt2UApQRecu2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=XRya8quQ; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XRya8quQ"
Message-ID: <f2f3ff92339e89b6b361b99e8bf9ac8f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745851464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ji9ephIrsTpZIU83RDT+phevG6GBxzJtkA195ptqXKc=;
	b=XRya8quQG5Z2+ZUclIa0zcDrKJLww39rxinc1bmguDNdbWk9hqdcmePVGPp8prebMGt8jj
	4FmqHAN2rVhMXMCYKiQfl0vrv8XQeAhS/TssCnmoWoXaGBv7hBkW54W/CXwurTcqJw/Qy6
	+FP0fMB6yyltb19qdHQz8zJF9CThTxxiL3ttE0JVPHDX11uIYaZHzKtnTvSCQ+bpGcdvr+
	bUqilLe5FD4w2PHfV6cS3ft7rIl35YH4TN8/f9t5j6XTsDKXE57X0k0+4HOfgnSr9j5gxr
	gmd4Nch241KW5qxVx0Bxa3iPOJdDnvxB5FG/ZjMqBAQB1RuhJYrEk3BvSxaLqA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Pierguido Lambri <plambri@redhat.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAH2r5muAjn5XLRFVgqwj6ZPATHj6iWLvTHTixuBx+a0BZnKUOA@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muAjn5XLRFVgqwj6ZPATHj6iWLvTHTixuBx+a0BZnKUOA@mail.gmail.com>
Date: Mon, 28 Apr 2025 11:44:21 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Were you able to simulate a reproducer for this?

No.  Customers just confirmed that fix works.
