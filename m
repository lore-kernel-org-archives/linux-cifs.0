Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795825437;
	b=JyLuw2NM7Cn2OK0KCPNBT0pdxv8q5zJ5setNXdanTHbVdhmnxkvq4DF3SLdUB942eQj+
	 KfqFjPlKOEBZV569HRhsRg2QKmlxSs9XEvrU0/t9NfU2UxHgEytO/QeIPa7YEmH42Pbwz
	 tbAyPFdg7Ud69hV+xssezF0UeZi23KTgKdz01X+m9482V1Bl0VPCbvSNv2InbLYuLNAvm
	 s4SbAtB8zlBQkcNmRCvbSpmOKVHodubLJ0vLhO5UlsYVunI0s1Z9zlpdVNSF3mYv/T4Ng
	 DSrRSj2d6n44xVpb0hm5jznVsxYZteALExbI2/EnX6te67igQoenyDdUwjvzNgmBljg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795825437;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=UBKf2DMMbkMXRFILq1FMa1FiaVBhOkjwnOibVfgSAP0=;
	b=DJnkRrz+/nXXmu/OOYymgfOdS7EEty83YUYK5rY6RysWJLMzu8Mx2vVUdjb3eOF6thDD
	 Ba107FCFlq2LupJTk2WfR6Fvq3TlWFn8Z/ywThJnlDCvYtx/AlZqahuIhM5Dq9P09Crzk
	 9oYU0e8FyrL4LuHfZqmG883FVKkPbmQaHQAWjQqguK5hleJZCzhXaMW7btbUVncICCydp
	 Qsxk7OyhomLF9b4S6dNs1+Ve4tTCacgbv+f5qO4LEiVYwIFZbw4BOTRPETFegpApi2l8L
	 tN1uZXfRa3S8PTXLPhHeyILErFXKxj5972o6HOLCgY7NtDl9D61S9s2ybOhNgoOGqEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeclS2Yk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CE6606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeclS2Yk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B01F0089A
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795825436;
	bh=UBKf2DMMbkMXRFILq1FMa1FiaVBhOkjwnOibVfgSAP0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MeclS2YkdjU9LWp5lw/lH0mynGCq9o4mvsKBC99R8TAbrKbVVNUbpUG25HhTcOI5S
	 rmd1LJmtXd+bsXu1GCiPUKzbCJ1IQLpYeVY37vtiup20cFL2NvMhAYRLjl4cc2DE0K
	 65C49d0nZZ2qBBnyJ+SvEq4qjyZSIJWWqGhGMjDOhh2awanpS6tR07sqQyvt8EeG/7
	 lGuazzgCW3I2PQrJsvJZ9Mnc85pD613bNLSxkGlCJt9iZHVAFSH6/Blfbx/BEU8Bbk
	 Ngp0UwrMhbxWFr5HKIbYNW7HeERGaPM75aAkWtWGDn0u9jINKcwbnso5owIcU2iESa
	 tJjPiq51PG/bw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c5126505cb3so1132388266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 16:23:56 -0800 (PST)
X-Gm-Message-State: APuU4Z9yAMNbXN9MrG0h1B5eKa2ElrBSZ58swu/90fXDvvPVBdo6zLpd
	Dik1yii3Lz5LANg+FCmbNH6DbeencvpntTje+/i+JqUUi0SKNWr8xxWwa/UcD6OLp022OjJjMvS
	5Ihi6dLgJvdumsEU4SjCHLiVoWUsGS2E=
X-Received: by 2002:a17:907:7f91:b0:c50:c747:a4ce with SMTP id
 a640c23a62f3a-c513a4b083bmr2267377366b.4.1795825435408; Fri, 27 Nov 2026
 16:23:55 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795797772.git.metze@samba.org> <f8e60e33c424c1efe397e94bee170a45823e3d95.1795797772.git.metze@samba.org>
In-Reply-To: <f8e60e33c424c1efe397e94bee170a45823e3d95.1795797772.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 09:23:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+Jr6bn-Pce2x4gMsQbiWqparP+dJ87V+x-Dq7Wp08VA@mail.gmail.com>
X-Gm-Features: Aa3M54q1mhkdljTqaw2Elt9O4l1jN2fdGSiSKsJD0FSxldCTnHcvIoB21ROvpDA
Message-ID: <CAKYAXd-+Jr6bn-Pce2x4gMsQbiWqparP+dJ87V+x-Dq7Wp08VA@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: server: use a counter for the nonce of encrypted responses
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset="UTF-8"

> @@ -36,6 +36,10 @@ struct ksmbd_conn;
>  struct ksmbd_work;
>  struct kvec;
>
> +struct ksmbd_session;
I have directly removed this line and applied this patch to #ksmbd-for-next.
Thanks!
