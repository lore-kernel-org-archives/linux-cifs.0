Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C654242314F;
	Fri,  8 May 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274714; cv=none; b=a3IR+eGnQJd6MIFQO8W4k/7s8YxQ3RMu1abUtiYfOuRaJDpywbY+zjXVBJ6WHEDCcSOdwnfO4ampZ9Ce937VQyHvQ8vJcqn9GRiMHd2vXqbcLTpFCgj9GQkWPrSBr19yF7HdfFbd2C8IGo6oBFf41ZBb6N+/davY1XcpxyaPXlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274714; c=relaxed/simple;
	bh=Wm1oFhjlDHVMbWPEmGFvlTH0XsXVNjxx5xMjj8qlXUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLly3sNDDnKVTbaM6B746ma5CP8sL2roh+Vem0z0gFyT30fkBxGFk1Mz6lYYzlMuj9unwVfZBmWWJX9bwB0bXUA8ahozYmjsvgRnmhCK7FKE7r4xOxL/eJFqtmxYPNOMOOZ2/tW+BR/VKTVHGP5nCSXLRGk3oM5O1hSWBXZ+EjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyeV1EnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyeV1EnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E699C2BCB0;
	Fri,  8 May 2026 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778274714;
	bh=Wm1oFhjlDHVMbWPEmGFvlTH0XsXVNjxx5xMjj8qlXUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyeV1EnClOq6luiXdvvic554mXNaVkpH3fu2P3PVuoKrluyKZFRajvjs3v0B8nnxe
	 GEJoJxEd/ml6VGZCBcPac3MaZrwIlxNV7S8t6fLanrtt8o1bjt0783CewWfeJbMJmq
	 ly0/bfV5i1LYICz0DZp7Q38J0kpTLKU+BoTJq/wVvQYGA63cZozh3sfRtl/zURyBJj
	 UBebsJg49iS8Mg9qcZxz1Xb3+1OeteNvQwxZ3X8QGq2UnJSDlVxHXYq0RdhR+qKScI
	 O/nBEtIb5tqFHiN7Wgc2mMsNFmCkDBYiuZkwSt1M0mRgr9AInp5Wpt1Ngi9KdHGqP5
	 ezT1/9JQV+ZGw==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	imv4bel@gmail.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	sfrench@samba.org,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	Li hongliang <1468888505@139.com>
Subject: Re: [PATCH 5.15.y] ksmbd: do not expire session on binding failure
Date: Fri,  8 May 2026 17:11:41 -0400
Message-ID: <0bf77c8c295b5e9a-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260507085758.3514265-1-1468888505@139.com>
References: <20260507085758.3514265-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Subject: [PATCH 5.15.y] ksmbd: do not expire session on binding failure
>
> commit 9bbb19d21ded7d78645506f20d8c44895e3d0fb9 upstream.

Now queued for 5.15, thanks.

--
Thanks,
Sasha
