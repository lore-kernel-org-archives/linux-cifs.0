Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1583DC4B3
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 04:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790655263; cv=none; b=IjyUaREhjgNgsFts3B0fTPG6X19afmCoN/KcZEyXg5NUwOzXhCty9MK6F/6oRVjSowWeZdEZCE0enHXWRAJZQuyvOp/M32Wdqeti4Nave1ihfQk4kSM7tV5hQvH9df9pg+aoJQVlf5hM/m58+fdROU1j8nPc3PM6XVEZb4VuR7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790655263; c=relaxed/simple;
	bh=keKHSU3frx9bJj9azkE55Fe+QxClzJfwAiUgPyb5dNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MONWCyFJUcCjeodaJzXg3n0SrG+5VFaeRoOOVk6Z0fL1noIbZUweLZB6LVUyL7BWX8L1HdbT778rKY1Tp1aHHJKbm5JF+OUNj8wQE37Hjm1HrkBQRbk8Vn4U1JluwkK5y4pP61yk+m5gQr5x26k9Pg2YdcTYGJnD5//44vMPxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBok4nBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBok4nBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C2E1F000FF
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 04:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790655261;
	bh=gx1Yirtz2znkNYI5JnZDb59Z/MY1BVKbmlMOBZDrMHQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eBok4nBPQJ/Pgc9Fx8BXVnxxR22SFplhcs9BntACJyZTCHU8JwmBi0UNFA2soeN4M
	 X75G3FB8VUDtTohmNAmrooQdMsiIPoe5w5St0nioyLffw5QCDyBniscTA6kfl0eFFp
	 yaRfBe4mPSRVW4OF1eKMrZkSpB7/4pnBUSQfWs+xdml/vFY5WM349G4YbRI2izaoOd
	 3eZizHo/psdBY2FBJRFkDLajwv9Yd2EbuXbKeLcqiuzK/RDvyeC4qgI6XPi2jgEimV
	 eou0olbPb2h3Zoo+P7bAstcUm1hfuqLZN7UNYFG705kIEuY6T6rc7u9S2IdIGNgIQG
	 +KapFm1HfZ2Tg==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2da4eea067so319048966b.3
        for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 21:14:21 -0700 (PDT)
X-Gm-Message-State: AFuF++kIxf4uRhsfk5AsMjpeyqFE2ZIL5iDp1JUaZR8HTt2q81d2prfn
	WJtsn9+XclCd1A92R9EZnS/3jWsR7K2Vmmsi17TNxHor1Upqh8fanp1rnNPOtbFVWRiU/4WIR1S
	bsUNkaumwvqN0XRM1aNAAunfnQGC2uOU=
X-Received: by 2002:a17:907:9487:b0:c25:cb7a:12d6 with SMTP id
 a640c23a62f3a-c2ac528c69amr1044392366b.14.1790655260268; Mon, 28 Sep 2026
 21:14:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928150355.850472-1-ematsumiya@suse.de> <20260928150355.850472-2-ematsumiya@suse.de>
In-Reply-To: <20260928150355.850472-2-ematsumiya@suse.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 29 Sep 2026 13:14:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9oL+fGZopR7+yx4Pin4eJKCbYW=ZXpdNSXMSjzw_JRiA@mail.gmail.com>
X-Gm-Features: AclHuK9GbLdelm3k6NhZJG7A-6c-xhaq6IBnZZNgttVzlIve8_L5w_zzo7hkT98
Message-ID: <CAKYAXd9oL+fGZopR7+yx4Pin4eJKCbYW=ZXpdNSXMSjzw_JRiA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: fast fail sends if need to reconnect
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"

> @@ -184,6 +214,9 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
>                 }
>         }
>
> +       if (shutdown)
> +               kill_socket_queues(server);
> +
>         spin_lock(&cifs_tcp_ses_lock);
Since this loop still holds cifs_tcp_ses_lock, It can sleep while
holding a spinlock, causing a scheduling-while-atomic failure. The
previous set_need_reco macro did not acquire a mutex.

Please check sashiko's review comments.

https://sashiko.dev/#/patchset/20260928150355.850472-1-ematsumiya%40suse.de

Thanks.
>         list_for_each_entry_safe(server, nserver, &reco, rlist) {
>                 list_del_init(&server->rlist);
> @@ -365,9 +398,10 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
>         cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
>         trace_smb3_reconnect(server->current_mid, server->conn_id,
>                              server->hostname);
> -       server->tcpStatus = CifsNeedReconnect;
> -
>         spin_unlock(&server->srv_lock);
> +
> +       set_need_reco(server);
> +
>         return true;
