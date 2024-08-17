Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B392F23;
	Sat, 17 Aug 2024 00:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723854655; cv=none; b=Uda6kKSw+Y1TKbR6RvCPNM1KPVT6hW3os+KOsVTGQet0tZwMUMAHNnsaiSrmu9feS53hfUfvne/dfXLW4ioyNeNKxXF6ZkJJZkiGCd8LFElrHEz4m+yRXP412hsfnYlSbi/H2s/AVBbiBxYMOeJ6KLzJZxl17N6eFP0Sbfubhns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723854655; c=relaxed/simple;
	bh=F5aspppFrEtEePh9CnIr/vLJ3B5tE+uRZgfVD9WFVBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G4oWFpw/LdBzNhLB1lP62d05p1mrJhLsC2wC+yRpBC07FlsWQqUHjuVCJ9UTAhMXgr5lxdAdmehDOiZs9VJL7hjPTlSmZ58a6EDF9nURlkeyveTPcqXgD3sIcuq8jLVWOayO4G1qphJXNyOdnT2b7pAk3gr6fALHg7huzIQ3mqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYPiW8Nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYPiW8Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECF9C4AF0B;
	Sat, 17 Aug 2024 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723854655;
	bh=F5aspppFrEtEePh9CnIr/vLJ3B5tE+uRZgfVD9WFVBM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jYPiW8Nq+BRitUI9AkFnkpClYFna480NX7wsxlmcEjcHWNrr1aB8VMHIFKSL2zXwx
	 Uo8BN78lpbCzJrYpuHg46IjUW9HtqO0VAezh3MzL06uwt5/g8JJCY2WOjhD91v8qxS
	 MK93PaCGE9diRFK4ci+FC+jkvz1Xi0czvztZvUc8ldikKeuorcGhQzp0NLx9iVl3lT
	 WSz7kLj6AVBNTYdNO2RDhp6b5iUIH40dYH4hdHqdV2UMxBQWxCwM0GadtZPkkrZCau
	 3nb3YJpNrVvQ9UwoGCeRJfCGYzxFT3ig++rhbA2QKGyn3oXqHlneQQDw8zZJzRKWgy
	 QveOjai0o8FWA==
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3db14930a1aso1707435b6e.3;
        Fri, 16 Aug 2024 17:30:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWR3yfdFkBzPXje5x13geXuOOkkj6yhBN5D/2HEdlbBcR2Fnxx8NAixjsCGH8RQOgy7yXNtdo22dORF+NXmstGlv5aPC3w9NOZ9LYWjXL47hMaB9zXgr27Du5Qh56FYznbSR+u7c5oLP5DkaYw3/g3vs6YU4xXC/wlPfKLmuTf5SBjC6g==
X-Gm-Message-State: AOJu0YzKHPYnoiVG8b0LKlfRKSv8+gaOQ8Cabun49ImbqcMo9RpNVvcw
	RtTTc4PnOjYP1g12Pu9i1JI+5F3khYG0OfDadHx9zRy+PjC8jUL/X7qaIq3VW+GtRInMSSKPVuF
	9ZRxL5C/r+tfTsVw26RECo/fOdjw=
X-Google-Smtp-Source: AGHT+IHHRnHezftEcv3s3ZnckNZuMCCVxWJhwhlH67g9+rkY/1D5CiBCtMsyGUTzWWm7MOGnfq7OZTFosvxHhZwoIOM=
X-Received: by 2002:a05:6870:2183:b0:260:f9e4:1fc with SMTP id
 586e51a60fabf-2701c3a1c26mr5056307fac.20.1723854654316; Fri, 16 Aug 2024
 17:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816192452.38211-1-victor@vtimothy.com>
In-Reply-To: <20240816192452.38211-1-victor@vtimothy.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 17 Aug 2024 09:30:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-W=3kgGgWccAOUNS9nwuJ5PErp9jPudJSZzDu83=B9=g@mail.gmail.com>
Message-ID: <CAKYAXd-W=3kgGgWccAOUNS9nwuJ5PErp9jPudJSZzDu83=B9=g@mail.gmail.com>
Subject: Re: [PATCH] ksmdb: fix spelling mistakes in documentation
To: Victor Timofei <victor@vtimothy.com>
Cc: sfrench@samba.org, corbet@lwn.net, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

>
> There are a couple of spelling mistakes in the documentation. This patch
> fixes them.
>
> Signed-off-by: Victor Timofei <victor@vtimothy.com>
Applied it to #ksmbd-for-next-next.
Thanks!
