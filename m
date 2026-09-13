Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263513CF82
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789260318; cv=none; b=XdghJNTMXGn9razg38eGv5xqc549MuDWgjQU+zcmaNGZmYMrRJfeHdzHLcWl1uSYG1uqexsOLf1cEkH+kavlW79KW0TR7bsiLaSfqzZ6hF0GhqGLYT/L+MVmy/hLuJi6ofhWC8FS6NE83jL/ynMehQ086efvX+QvEq2d6dSSXyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789260318; c=relaxed/simple;
	bh=NUcbszGp5tUNERew/7VfMlM/MVzhmtWvUZP6CSY+x2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRjZKl+V/QeN2VqdvYHo6zYVqrC1oaplEpR4ymVoG/e58avC8nRjn9QCEDToojC6oR1SopdFyjNH/AB8YmMYeK7/0GIzF1MIDd+6gF31oQ5K8Yq5S0bRGNa6tqJnyCsJVRUKWXYwKlwrT+TSFfZ5khd+Ey9B3ojfLqX+K5gQsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzKTdT7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzKTdT7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609421F0089B
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 00:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789260317;
	bh=ULB/Au0giQJsbmdaaBd+KQN+LPLOz+eyRpSt00+Fetc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OzKTdT7+ssH+F0q+rCktk/69kALO1KpIjp3G49JQ1POMFuj4DIVNVVske1d325ftm
	 KrjyUxPPRAknVvROq0bafOmGvS42QU2GmDUzYhnN1qSLGJOR3/6LnHz/TxknrHeIVm
	 qYvHeVsLV1508iqJV232akLn2dVX02WyuN6IQTbW+WsR4+AAkhkPcq7FN+OczEKmxb
	 hIBOJFU9BOH3TDqhD3wYxSu8g9HhHBDkhK2ADLTMPnolLx84ayjib2/E97r4SNjCg9
	 bqkA3+0ZvFAxbrzN+eSiE+yFUERUadtfAq8n4+8iWsDDBNZE3ZOmXT+pmcDfuaEi8L
	 tuVdg/Un/QQzA==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6063d7daaso1664522a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 17:45:17 -0700 (PDT)
X-Gm-Message-State: AFuF++liKRQqzoRPOw1WPvulV1sAKHE2491YcP8YoXjI4aBSjTyxFGAt
	V3fgUmjNTxQY8yIjTj1CupibSTmFLkPpyeKbQSwFo/ArfDKkbWhczlaRlV+9jq4BZKIatATRxvs
	V9LZtQ++0afsGazb0CDvNpka8YNQd4rc=
X-Received: by 2002:a05:6402:1f47:b0:6a5:f4f4:5c10 with SMTP id
 4fb4d7f45d1cf-6a9b5605f43mr10800506a12.3.1789260315855; Sat, 12 Sep 2026
 17:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260912172509.542168-1-pc@manguebit.org>
In-Reply-To: <20260912172509.542168-1-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 13 Sep 2026 09:45:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-H==fMY_nSLD+9KG_ZwVz+KQQ4noA6qzVhT07Sq=SjMA@mail.gmail.com>
X-Gm-Features: AcwNN1UA5CgVF2Ye1Qmc29G3GqG5WA2lLA8XhbjY_FtoocwVRS6zpmOMRf0fof0
Message-ID: <CAKYAXd-H==fMY_nSLD+9KG_ZwVz+KQQ4noA6qzVhT07Sq=SjMA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix smbd_connection leak on
 cifs_get_tcp_session() error
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Stefan Metzmacher <metze@samba.org>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 13, 2026 at 2:25=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When an RDMA connection is successfully established via
> smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
> kthread_create() returns an error), the error path frees tcp_ses
> without first destroying the smbd_connection.
>
> Fix this by calling smbd_destroy() in the out_err cleanup path before
> kfree(tcp_ses).  smbd_destroy() safely handles the case where
> smbd_conn is NULL, so it can be called unconditionally.
>
> Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40mangu=
ebit.org
> Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect sessi=
on")
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Stefan Metzmacher <metze@samba.org>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
