Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCE63909B8
	for <linux-cifs@vger.kernel.org>; Thu,  3 Sep 2026 05:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414220; cv=none; b=Rk3tcxbF5/mdD2jPntWbsS3nwN0fqgIvcbxcN+gJtjdHRshXxnuQWlQ7GQBH7g9YAoA03Q3ClXZGd4Oy/NG9G2E95WqCh64JNKrMTqV7Wn9ncJqj6kX1GsawpnBe06BLIskHepf+oYEpACxWGiO8vg0VHooobVJ2q0/7xrikYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414220; c=relaxed/simple;
	bh=ofiLLHLDfwzySuuunJRX4J2e22gy3Ugg6yJTkjpKmwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SXO3NJk/pHPTuuxcS/e/3nRTk0Kfgltc2j2iF8fz+Cm64XVlQxWnFBPyrqiGncSbkQFTkfdfLEt5/0FoXA/MSTvlTFGuGIIDJ1cvMaxj1f0xHS2V7hQCbFVsom3cMpOkABzYFrLHEMfnV/G/PCvdC2RvYIA1BoQlv2lgpFPetqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrgtiVPd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrgtiVPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987621F00A3E
	for <linux-cifs@vger.kernel.org>; Thu,  3 Sep 2026 05:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414218;
	bh=XcpoTZXG1MHyNgHtd/cSLu6It3M3M1eToJKHs3JQ6hc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PrgtiVPdA0g4/tl0Kip/5jB0JvVV0TUsAZ6fIyXNYguAeTaP5CROBB/Ch61T0jAbS
	 HPEK9dBN9PZDv4GqvT+Zhn/QDN9ZTcKMiaEK8J5MtwrYqNYS9+lwzI9+eS8pgPFaNV
	 ib01PZKyoDLal22E6HsF9ufv+6MVxlTPNPr7ZG7eWmLHW1PtSyOauQknYm8+r5L5Sg
	 jjafxhrxb3crgN1+Jyd6ErDDsuA1XB34gLgzPi2d3ynDy7x9Wp56Bh9qg9aXes2eid
	 wSQHtrxOXM2h9VmWeZolaSaQUUT1P+9WaiIi7JquR3Jq7Wxgl+AhR/zu1XpygMQUzd
	 yMqdL0v0axQGg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c25420fe973so26947466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 22:43:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx0R52duaAkrU3oFnPPOyGGdFulG6Y0Hodhpkwy5l8yIEialqXYPmDa+YBlZFTIoTeGhXMHfP2kXe1N@vger.kernel.org
X-Gm-Message-State: AFuF++n+LhsrF+j4JJuZTsrpZGGzyv8yxkTIiePC1s6biplAPwtwHY/E
	w6JhMdxJH+vlDC4+P4Dh7P3xyQdlIZt9QFnE3R31DsFUkptBE4jArbCaAaf5Lu2e4IIdbxqohxq
	HG0MlVSCPNgPKvOmpjBTlIZkzfcW4MmI=
X-Received: by 2002:a17:907:c003:b0:c21:180c:d82d with SMTP id
 a640c23a62f3a-c25d55bb06cmr666009866b.20.1788414217171; Wed, 02 Sep 2026
 22:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901182136.13745-1-cenzhang@linux.microsoft.com>
In-Reply-To: <20260901182136.13745-1-cenzhang@linux.microsoft.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 3 Sep 2026 14:43:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8L2i9QHzRu-wq9BUS_BUHOkcFUyGpGO=FHrDvJ0ei8sA@mail.gmail.com>
X-Gm-Features: AcwNN1UvCEc8oUBLYY2XF2vqejSf66y3cJqjX4QnBbUfsGV7QaFnvrDkspB_UP8
Message-ID: <CAKYAXd8L2i9QHzRu-wq9BUS_BUHOkcFUyGpGO=FHrDvJ0ei8sA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
To: "Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, nicholas@carlini.com, bahubali.bg@samsung.com, 
	kees@kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, AutonomousCodeSecurity@microsoft.com, xmei5@asu.edu, 
	tgopinath@linux.microsoft.com, kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 3:21=E2=80=AFAM Cen Zhang (Microsoft Security FORGE
Labs) <cenzhang@linux.microsoft.com> wrote:
>
> ksmbd_tree_conn_connect() publishes a new tree connection in
> sess->tree_conns with a single reference and returns its pointer to
> smb2_tree_connect(). The handler continues to initialize the object and
> build the response after publication. A concurrent session logoff can
> erase the connection and drop that reference, freeing the object while
> the handler still uses it.
>
> BUG: KASAN: slab-use-after-free in smb2_tree_connect+0xe3d/0xf90
>   smb2_tree_connect (fs/smb/server/smb2pdu.c:2872)
>   handle_ksmbd_work
>   process_one_work
>   worker_thread
>   kthread
>
> After xa_store() succeeds, take a second reference before releasing
> tree_conns_lock. The original reference belongs to the xarray entry and
> the second belongs to the creating smb2_tree_connect() handler.
>
> Keep the references balanced in every path:
>
> - On normal exit or an error after publication, smb2_tree_connect()
>   drops its creator reference. Error cleanup also calls
>   ksmbd_tree_conn_disconnect(), which drops the xarray reference only if
>   it removes the exact entry.
> - SMB2 TREE_DISCONNECT uses the same helper to remove the entry and drop
>   its xarray reference. The request's existing lookup reference remains
>   owned by the request and is released by the existing cleanup.
> - Session LOGOFF removes each entry and drops its xarray reference. If
>   it wins the race, later cleanup sees that the entry is gone and does
>   not drop that reference again.
>
> To enforce this ownership, claim the disconnected state and erase the
> exact entry atomically under tree_conns_lock. This guarantees one drop
> for the xarray reference and one drop by each in-flight user, regardless
> of which teardown path wins. If logoff removes the entry before
> initialization completes, fail the connect instead of marking the
> detached object TREE_CONNECTED.
>
> Fixes: 33b235a6e6eb ("ksmbd: fix race condition between tree conn lookup =
and disconnect")
> Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
> Cc: AutonomousCodeSecurity@microsoft.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.=
microsoft.com>
Applied it to #ksmbd-for-next.
Thanks!
