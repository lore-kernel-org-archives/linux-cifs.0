Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804608;
	b=0Tn0LLemZdsyTNFT6+43FWF2hVsJhTP90Gi3+RnWkae6CjuhgbWxQjLhPPuuiAeje26Y
	 HOuCqeRwP9+eXiQJwTB+BlEObunGAQ6nBqrR4nDluk245SSPu04zUd/C9MkwRww+RlyrR
	 3CPMT8Br85QmnKZ7Le0ksJn8YJd8DCNj73jg7xk0Fiw3Io7nJ0EcfxlRYPuvsO8OlIEnb
	 xkAyYBbCcGRVHQCeS9DHQD+qOwHi48SbwMkHw5tncHRvSLegOW9nRafa/BSsEcI5zh/n7
	 FbGKu8jxmPmhzytu9KPc9jjeBJmpGOgQufqyxGK+djjjfdfJsRhiHwV3jgvDdwSGsyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xdojI5MulhmiBf3zVV9kSFjtPEvP2aafXP1ED37OKs0=;
	b=R0kyn8ZcfhjIaLGP9U3Az2DHbLmb+NlS7JuPeSQPsfqW2heFCSl82/bXLFSeUsOmYoXx
	 4iESX5Ron3vMbGHG9Sv+gVxDogxrCktsLMdBscV63C/ka3a4qjda7PR6J3m1P/G4Mo7w/
	 VIxqoESgdi2Fq4RQxaRfodpVk1Bn6/o/HzcJfGOm2jdESlZ+iUTXLGtYKCqDxBZH2wa06
	 e+DfGFRWf7VMXcKiGDnchovK6bz0nlqZlEuRDKGeUl8nshPmYq+ZSvbgFO8mjc1MAxp4A
	 ukfh51AYfRzLOpxYJ1VyVnI3o1nF9Nyn59QRQHS6c01UKWWf+/XeR1hKbDSQB9VBpMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5QnXy7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9885D606A326;
	Wed,  4 Nov 2026 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5QnXy7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8801F00919;
	Wed,  4 Nov 2026 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804608;
	bh=xdojI5MulhmiBf3zVV9kSFjtPEvP2aafXP1ED37OKs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5QnXy7Al8OeQ9R9YjXI9tpmQGN6Tta+nW979NatPw0gdzrKX81qnW5EQxHSD0YGm
	 jvP4sVqB+1BoqLvHljcdMXCjc3pVZkgthRuIY/ZIkY3GKs6hr7/o7ueB+wiC+b8lL+
	 DnJ33NjLG6B22BmUaPNvn5b/CJBXX6LRXr7PxkSAxrLofEAKgaVNy5exd2usTml9tG
	 5OcHxpBH7vWeYx3slCU3afEgwzTaZYxH6MlVzB84nQvmeBhFsfNM2j+2PGMZ3ppuYl
	 +iTbGy+E9lLOeff8XsY+i61pjQ3YV89tXz9TAf2R6aogtSfrGDN6MZzjAW+2MYvKl/
	 kMYB+6ddzfMQg==
From: Sasha Levin <sashal@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y v2] smb: client: base punch-hole EOF decision on server_eof
Date: Wed,  4 Nov 2026 10:03:10 -0500
Message-ID: <2026-11-04-1-daily-reply-0001-re-smb-punch-hole-v2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104082535.404128-1-joseph.qi@linux.alibaba.com>
References: <20261104082535.404128-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026-11-04, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> Reading remote_i_size therefore compares the punch against whatever the
> slab object last held.

This is a stable-only change with no upstream commit, so I need an Acked-by or
Reviewed-by from Steve or Paulo before I can queue it. Steve, Paulo, could you
review it?

-- 
Thanks,
Sasha
