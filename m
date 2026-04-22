Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12EB33B96B
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776901617; cv=none; b=Q7yU+toKUaxhGJzkc8R4MOqDvNXq2zNPOq1dsFnmbHE47kATuqcGa9xNTmcW9RlWy7/vKdr1Hh55LSermatUdTpW9DiC73f63/bizC3LykWUB326zkJdO4B3rt4POsAw4iXghM/WI7bsE3SpEf21/SIvAi4t+ymWL1unaou2TIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776901617; c=relaxed/simple;
	bh=wYAfT8KDTE+ECW5vGCHEkwg7zZHuqkLNTHP+XfHzM/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXRf+DuzCpiWT3FbwWG7v/xPeEBW4fO1seHDPef/u8TIlcJnOg5Sf/IJeoQ6weH/n9hFrui4hkeO1zQLfjJVZ+Y23HXvlwc2vtFwFcBMlaE6GXb3qRYylW1Y8bNJvCQxJeHXk6/XWrAgmD7+dRv9O7+0Ah2r5RKuy9NMRBtWcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odX78xgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odX78xgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE1C4AF09
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 23:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776901617;
	bh=wYAfT8KDTE+ECW5vGCHEkwg7zZHuqkLNTHP+XfHzM/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=odX78xgDKYGhl4WlXE2un5h+XBNikrs4vd+4UAog2MhTnQ6CuECm1oAXkagH2mx8V
	 0IpCgdJaFTv8IUGcxO1DPdvyGXo5nJe1gIWXut3BtIFfBqxobAjdlz9p4mHozcAu+I
	 T62OeWbTlwg5AIMKbzyR2LVptXv+JvSbUGFFPbm/EDB/KjRorpnyVM8nuwful7RXA9
	 hGEWQRHfSBr8wPUAruSRribk/rGkhgm+Bi4Sb+BOyeeZArL/BNbwtlctpvmxXbtdzi
	 jJFEC4IKTtgVpXepfR6R/41vwkl95NxcA9gIy2Vn1B1Y22ktPQmzqfKsnqAzsyoNLl
	 eqzfwr2NjoL9Q==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c745e18a0so1013385166b.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 16:46:57 -0700 (PDT)
X-Gm-Message-State: AOJu0YzRKFeB1KaPMZJYnWTIHYT9f4TyJtga17McJ6oIpM7H7yDktwag
	RGNjmzADTNxX3jMxtj8z6z0jt+JAlGa8NbZCnMjGeYlLFeQs5ZeIKtrv6M+VP6dLeRjSwmdCpmT
	uvPTotNy7KpOQAWrvXydbgRO9cKd8A6o=
X-Received: by 2002:a17:906:c150:b0:b9c:617b:4a36 with SMTP id
 a640c23a62f3a-ba421debe01mr1113324366b.21.1776901615795; Wed, 22 Apr 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419192018.3046449-1-metze@samba.org>
In-Reply-To: <20260419192018.3046449-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Apr 2026 08:46:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd97h9EgR=3=oan=OSxZzKUnqZG_Ss1fM9tA-+dgE_+q+w@mail.gmail.com>
X-Gm-Features: AQROBzByHLyJtD5ZN4UyVvs8qtWAogUhrU8gJkb15HWObgOd_1VMiQyAqaMCGcY
Message-ID: <CAKYAXd97h9EgR=3=oan=OSxZzKUnqZG_Ss1fM9tA-+dgE_+q+w@mail.gmail.com>
Subject: Re: [PATCH] smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Steve French <smfrench@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 4:21=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> This also removes the smbdirect_ prefix from the files.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/linux-cifs/CAHk-=3Dwhmue3PVi88K0UZLZO0at22Q=
hQZ-yu+qO2TOKyZpGqecw@mail.gmail.com/
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
I also prefer to leave it in fs/smb, and I completely agree with
Linus's opinion.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
