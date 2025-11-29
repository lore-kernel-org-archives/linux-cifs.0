Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650F1391
	for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764410099; cv=none; b=nqd0SzdJ+rKUK+kJ2T/wVv4eytyBkviHwsX8/UCPFDipNIFCQKKKMf2N7G4SDUGL1Bv+yA/bU73EgENtCz0ELBZ4CcFVDYJo9TwVvI4mgBzhl9uBH98DzAKQtWl4N0YyW2R/yrzoaWmKgAInpAZvs32qDlMzYixSIdjc86nrJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764410099; c=relaxed/simple;
	bh=93PgR+uiqEaP+YXfNmKB0fsgHhTm0n0MmP3ttqBY0O0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kXWWoX2CEzDd6AO1+O4j/KPzOrDSCIf2Omf/B9qnAfOt/y9T5MAWQU4kDKtXiEokutCvBCpJ1zOq0/UW3iUEAnEibAtSUDldTY07xe84FIWYh/dSg6Gc3DACCUo3zxOhKGRF91QWEjTOjwI1Swwx0TsvPEfq0tXfcnv4W++CFd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6VpKAdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6VpKAdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB78C16AAE
	for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764410098;
	bh=93PgR+uiqEaP+YXfNmKB0fsgHhTm0n0MmP3ttqBY0O0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X6VpKAdJNMnlWhsD+ItqKDGTtH4z0VanXWTUZUdN+OR2yLmhYmEllmJVn1zByAzqR
	 6Mj0YOocWYzw68Tq7K3G1T64YYYUxErDSO4hhrBzoqRwAFPdIFOONjQp/ak8Gto9Uj
	 ZNHhbmzYe9Rz/ehEUEBOi/OsQhU/wpcfVWt9SbDgnkImR6jLFM3Qb9GIqoJJ5fe/25
	 R5aq/WFE2kSh6mRU5w4YefnkKrYbsq6WcZcvwv6PZXQDfeluwxZ8eQfN5rinchtGcy
	 RgOP031uQCvZBOQXH6pT2Z6Zpc7zkMNNBvefD+lTZksXpeQGL78g7dXvo/KM6MEGQ8
	 V7WiCeMKMC39g==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so3964295a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 01:54:58 -0800 (PST)
X-Gm-Message-State: AOJu0YwjDvaJ8KaApdeCAolowMlObLqV3O4C8tuq0yhYbozLjhbvZlk0
	EKL2/9O/DWzob1GNSm4son5DYatEBk4gl/bEcyXmeUF7lhvQHXkLAj2ALXUwtlyViKnkvMkRNst
	/ZPghX6QKclgB7XPAh8108KanXgPSPmI=
X-Google-Smtp-Source: AGHT+IFUnQ4fPN9hnHsqfI/hb2fw50b9LdPmnrdZ+bXTSO9hsrxtENOCuIBQbfGjjjcPXZRpgNf4hRFIoFtVPgLcEeA=
X-Received: by 2002:a05:6402:50cf:b0:641:3960:511 with SMTP id
 4fb4d7f45d1cf-645eb23f98emr18198866a12.7.1764410096744; Sat, 29 Nov 2025
 01:54:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764091285.git.metze@samba.org>
In-Reply-To: <cover.1764091285.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Nov 2025 18:54:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd97Vf1j6GmS04qeZJuZQVzuR7Z6vxwM9+FHeJCsPz8JqA@mail.gmail.com>
X-Gm-Features: AWmQ_bkwFy_QeftFmJprWUpdu0zjm9hZTqpRyi-y5Uc-uo5bvMKV61arMy_pbEw
Message-ID: <CAKYAXd97Vf1j6GmS04qeZJuZQVzuR7Z6vxwM9+FHeJCsPz8JqA@mail.gmail.com>
Subject: Re: [PATCH v4 000/145] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"

This patchset completely breaks ksmbd rdma. Even simple file copying
on Windows clients and cifs.ko doesn't work with the following error
messages.

with Windows client :
[  307.323201] ksmbd: smb_direct:
smbdirect_socket_schedule_cleanup(-ESHUTDOWN) called from
smbdirect_socket_shutdown in line=683 status=LISTENING
[  307.572330] ksmbd: running
[  473.984576] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  473.984595] ksmbd: sock_read failed: -107
[  473.984708] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  473.984726] ksmbd: sock_read failed: -107
[  480.044722] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  480.044742] ksmbd: sock_read failed: -107
[  480.045290] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  480.045307] ksmbd: sock_read failed: -107
[  480.045650] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  480.045667] ksmbd: sock_read failed: -107
[  485.115961] ksmbd: smb_direct: status=DISCONNECTED
first_error=-ECONNRESET => -ENOTCONN
[  485.115980] ksmbd: sock_read failed: -107

with cifs.ko :
[  191.319885] CIFS: Attempting to mount //192.168.0.200/homes2
[  191.322664] CIFS: VFS: smbdirect_connect_rdma_event_handler:251
RDMA_CONNECT_RUNNING (first_error=0, expected=established) =>
event=rejected status=8 => ret=-ECONNREFUSED
[  191.322671] CIFS: VFS: smbdirect_connect_rdma_event_handler:260
smbdirect_socket_schedule_cleanup(-ECONNREFUSED) called from
smbdirect_connect_rdma_event_handler in line=260
status=RDMA_CONNECT_RUNNING
[  191.322681] CIFS: VFS: smbdirect_connection_wait_for_connected:784
connection failed -ECONNREFUSED device: rocep1s0f0 local:
192.168.0.200:50941 remote: 192.168.0.200:5445
[  191.322685] CIFS: VFS: smbdirect_connect_sync:834 wait for
smbdirect_connect(192.168.0.200:5445) failed -ECONNREFUSED
[  191.322688] CIFS: VFS: _smbd_get_connection:291
smbdirect_connect_sync(192.168.0.200:5445) failed with -111
-ECONNREFUSED
[  191.339145] CIFS: VFS: RDMA transport established
