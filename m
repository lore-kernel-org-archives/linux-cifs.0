Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72F390981;
	Mon, 18 May 2026 19:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132070; cv=none; b=Bf851Onwlqr5AmF0wUYKWHZfJcUMjJ+ZPmoPn/cl11h2pZfM29EYi5t7JufkmAbygHG89K9fEplEThDM7q+0NhX0oWy+prX4sL9HsmNYhQvhuQSg9Jeejx6u0icYeGsNi5Ln1Dx8KUomnQ1fC+O+KtRaouA1Lk8p23XtIHClWEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132070; c=relaxed/simple;
	bh=pNqPJ/RAnCf5cF3YAJOcO1eZFU78osS7PwdX2Ra/EGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtpuA+EASPufb3UPG5t72K8cD2ARao41n2m/u5CC5Oufm96z1PqJkExdZzMrYYAo23sgraDljJoofmXFLVDzkPeAiv+gQhIXpC+4EDDAk5o9Hie1vxMA6rZHt6OBxAewkd7yayssN/LvWSKSS4UGeorv+9/IBhuNthlw0HoaEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkH6HMVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkH6HMVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1475C2BCC9;
	Mon, 18 May 2026 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132070;
	bh=pNqPJ/RAnCf5cF3YAJOcO1eZFU78osS7PwdX2Ra/EGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkH6HMVNCaT4GvP/iZdoR+F6sJfqgVVqwSMHTKgMjF15a7PRjBs5TkwRSt8jU4h6Z
	 /t0Ty/aETsn30fJobdA1HJ7XsZHW0d6SsTQyFkUvfqqj4N6+g+iPQKZjLgWHBmoMww
	 8bzPDxnHnoHiWKwuNfueWqa6h4Di+Rw7UqOzprFVU6dYPV+KXqO/uRQg4udfn7E7Zi
	 tt+A1M3b9OycjE3xTHwdaSJ63/X2Z5odptBJZD0ug3vj/BgEzKY3zxzSgXlHMzZkbX
	 EMJQakn2bIvPuLluewED+G5dDULe6pW+yM2OzFderZw82wMBb72MyryuPVrVeuQZh4
	 n94+xJqDv44zQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: Re: [PATCH 6.12.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 15:20:55 -0400
Message-ID: <20260518155236.reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_012481AD8B713E60401A2269D96B463EBE09@qq.com>
References: <tencent_012481AD8B713E60401A2269D96B463EBE09@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026, Alva Lan wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> [ Upstream commit 3df690bba28edec865cf7190be10708ad0ddd67e ]

Queued for 6.12 along with the 1/2 prerequisite (215b7f9ecb8d), thanks.

--
Thanks,
Sasha
