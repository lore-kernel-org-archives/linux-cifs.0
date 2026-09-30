Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CF236A033;
	Wed, 30 Sep 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789840; cv=none; b=JWPk/M1CbyAZXWD2zlroMmf786h/GwtnpFHZ0jrK7H8i53d4W8Bmq5m5YpFtIL1nBi4AIdq4XUB2i7XNsQBO28b6h4krSCruHWA+bDywkJfD0ixVNQv4mTgeZsgwTYdQ7zA9rcFUJgz44zGwV3rnVNhLwe86nFBtfwKzgaZyLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789840; c=relaxed/simple;
	bh=x3Sp+halSc1VTDrX1jIO9a7MTuCS/nutqmPG2/e5f9k=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=I5tqI2MEENKX8b0HFnMktwihuAmnVtKqtOC0x7ClovDSHatXRtSGt3B/tq1qM46EBTAwL7dsCZASx2yPZOqS9E/zFjeKZHZC58shC3NP5i1b39zUgCIoe3rtZqSla/uKkF2yMLXSmLGXUenkQhf3v+5+HCAzxJPCeBHgKUJw2oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KoiQhuBn; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KoiQhuBn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x3Sp+halSc1VTDrX1jIO9a7MTuCS/nutqmPG2/e5f9k=; b=KoiQhuBnCK0ncZcAtrdYhPf8kt
	AqcioPpNXVDicf+wSYadyvEuMXZNV3lL6DH9/wYthAg9QaKOpTPbJ/Oy3FMdL4VqMtRHQ5QoaWeGb
	tDSgTQFKLxOjWlHOZzzSceky5b/MVez1MJlVmeRf08omKf+9PKBLsJnj31L6oFhoLSXkdtJ3vef2K
	HjSrefxAPtWxjkCI0BmJJfkkGQm6Oy7K0+zBkF3C7u48xCpO3Ibbttsmg6d6xYZTfIq2l+glshxfo
	nEW0qFtoxPher8G7owH3Hd9kylF+ASL1/03XfHdXIWSoMNqXcqoCjMuvzunrDyCMn8Ez+Gf5pjmRD
	NFw66KQA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xByEz-00000002e3b-1hDX;
	Wed, 30 Sep 2026 14:37:13 -0300
Message-ID: <bc3eca3415ba9804d33209be36806399@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>, David Howells
 <dhowells@redhat.com>, Matthew Wilcox <willy@infradead.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Subject: Re: [PATCH v3 00/15] netfs, cifs: data corruption fixes
In-Reply-To: <20260930032822.1835287-1-pc@manguebit.org>
References: <20260930032822.1835287-1-pc@manguebit.org>
Date: Wed, 30 Sep 2026 14:37:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> This series fixes a number of data corruption and spurious I/O error
> bugs found by running generic/363 (fsx) in a loop against Windows
> Server 2022 and Samba 4.24 servers.
> ...

Applied.
