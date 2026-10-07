Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850283A83AC
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791357641; cv=none; b=kbqm9ToJxPZisYcDV06gGTkIGlrgBdK38w+2Lr6gIKTMLDQH+MKRJmsGOY8Agg1aYgoH9IBYiHScI17cbC5nRb1ft46NWhd4LLSue4kLx7didZ6gKZm9jnvFFJ6zwTLZgzOQCme1chj6ObKHxL8HiAmKcL3QcTGp7HG2s2vpXl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791357641; c=relaxed/simple;
	bh=riUDtEj/3tWKW/FxjI9uQ7SAYtPb0IoaeiJwcNo2vJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eaINi2Y7CyZWo8GreMdz1LmBnCPd3FvX4Hoz7l4LQjnTBGGtIO/IqnodZawGv+MpilHSvIFByOWD22JW0QUTWCJOOkG2ck1FUjtpimlRXqTu/j/1X3qWuGrOD2K/39tLsXzotp7OaaW62jIpoyIfYz6yrjSCNgNp14qd+2Qpjyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATatyvqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATatyvqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FEA1F0089B
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 07:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791357640;
	bh=F3elOqQ2nAti4tI7B310kb2xr7jGX6gDLp0BjVbTvvU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ATatyvqq4tpVB4Fqf91y1ACN0NXNVOr7BEOx6arkPakCzu1a4UvTjROzEDdjEJoEK
	 oYdJNTw5buudokn7bjx3IYNNGNfDUaPKIp32NYNyXSZgvTtlHgDzKvcU610684o/44
	 ChvxryDIZyeh9Qrualfdx8KY5B2GRmtcN6QrIFEhkGHUZhIjw3K98fEe7rWKI8DJ6o
	 ETCfzdVtAZ/LviFMuaWbOQlnPlHSdsTGM5+j0aOzg5WnXpBtoUnOn0S1c64KAIJ2iO
	 UVVoFkvyWKsHbAWRfCXCJXUZkIbMupWYxtCA6ys1ZTrTHBnCismeBMW53lb9etYl76
	 J0yA6XC4h+0oA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2533d83e3bso217617166b.2
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 00:20:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzW0YwNWCvCf+hMt0tSoLuMP52GzWBBHq5kdYMqKqDE7ufm8KIGAvt9gg7DoChFq/t8Ytd3XAjGcgR5@vger.kernel.org
X-Gm-Message-State: AFuF++llQLwIUcusxEfmK3gZyAzIOXfDldh+3TRoOYy97ZIzAk5yeFG2
	mHg4JJLPDcmgj3rCQfAV69jrWyDyPmki8CeCca8Q27Eb5yGhtvFoWBxkqC1QeuEnpLhCYp1SBa0
	1PRuX2lVHwAVZ9AOLbFNo/lVTVvRAOG4=
X-Received: by 2002:a17:907:3d92:b0:c2e:855:3375 with SMTP id
 a640c23a62f3a-c317c0ba250mr114168066b.30.1791357638840; Wed, 07 Oct 2026
 00:20:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007063046.26260-1-tjdqudcks0424@naver.com>
In-Reply-To: <20261007063046.26260-1-tjdqudcks0424@naver.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 7 Oct 2026 16:20:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9p2u3KiC1a-cOeCNcW0rMPpS7cge8rVE3uyUrgHiLOFw@mail.gmail.com>
X-Gm-Features: AclHuK-XXsrkb_RwEiNoWx76gosq7LqwiaFB7XYYk_yHF8MRJ035OF62OaojfcM
Message-ID: <CAKYAXd9p2u3KiC1a-cOeCNcW0rMPpS7cge8rVE3uyUrgHiLOFw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: hold TCP session for async decrypt work
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -5384,6 +5385,9 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
>                 dw->buf = server->smallbuf;
>                 server->smallbuf = (char *)cifs_small_buf_get();
>
> +               spin_lock(&cifs_tcp_ses_lock);
> +               server->srv_count++;
Shouldn't we check under cifs_tcp_ses_lock whether srv_count is zero
before incrementing it? If so, we should skip queueing the work and
release dw.

> +               spin_unlock(&cifs_tcp_ses_lock);
>                 queue_work(decrypt_wq, &dw->decrypt);
>                 *num_mids = 0; /* worker thread takes care of finding mid */
>                 return -1;
> --
> 2.43.0
>
