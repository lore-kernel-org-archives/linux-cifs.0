Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004791B4F09
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779065656; cv=pass; b=jm1Zz87vhw1vFqaB9UoTfkD36Vu+57lKIrpTn+mwag9M47vbaMeQUQUPaaZ+wAQ8MMRSxuekNLrMGu9Ksc79Ta0NW3tpk+/mcMqTHQEuwsDZvfdglFDerCy2t/zrZjfaGDD1h+n20m3xhEOIttufVjGMlyFXBEkxe5MTchVcCuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779065656; c=relaxed/simple;
	bh=qTBmL6QfFcD6kKhnQvC3pHPD1D3e4ZcwXDhQczgLb5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mG1ovtWzMGSfYJppUGK5h0SnCvlUVMdiUdDsdKKD6ABkn47S0ehHFVj+fBNLuu3Xd5NLCd+pwf9aV7CjdHxC+cnP+06mK3wSjI7ohfGY+U32Imsd2psuu2vxTZNgadw/G3TugK/5P7or7ZwkemvO887+SEqNBv5kxFrIl3givmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nf7uRQ7o; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nf7uRQ7o"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8acb3daf2aaso36024676d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 17:54:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779065654; cv=none;
        d=google.com; s=arc-20240605;
        b=YawvIYpYX9s2+Hlca3WuGJYO53Rin6CZjo2IH3MENPm5lEeVfcaa6j2P6NJZYb1PAi
         HacG+6t18Flf9iFfOUh9d3I7B/L/6Gio4jShqy+MqIXf3FoSqRwPCoiDbIxW7yP1Z+jq
         GLLZbR7mApZzZOdJ9O89mnKZpYHt8IGobQ5izpeJ18n6anaxs7n2ksjd4vTx0UwTlEn4
         jc/ADBQT+MQgpI9Su5bHtBRsbUi1yEmFxEkyr1TGX6SkJHFh4nhIsTdPHE9SEoanCpn1
         hyZ4xvf/QS5ixPL0U8WioUobq4AItX0Tan1yEdu4HKeSOYtXVV9q1oYGrOClgGapm4jF
         RTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uJd83rLCVfxsj/mKfcuVoPeefEJUdst8wi4jVzT8UGQ=;
        fh=N1noLi/nnu9wuP6SiG2NSNshDwggtwAGsPUl24EfuD4=;
        b=BUvBonMXz9jfAe6rOSgSPdkgXAn7JVVyXx2gaeXLb9IFMYsdKPy08p/UN1bSqZ4/ut
         Wzdrpweh+iO/b2pGO1MFA9M6P/MUSTRisWmn8kGlEo7IbLwCOUIjhao5Of1glMA//5/2
         Gn20+XXtVWl1bSjXBmNrcakvdbzvwsMfNeowbwA1RIq6wqMO/69anDeloBAR2/gl8ZCt
         j6S0PTQbArMxqVpPUMhdBnHii1M+hTRtFsLIKh8ZpC0pZwF+ryy/klx+q9fypd+E+WhZ
         kkflLwqU1Ge1bvMxSX30h6YJl4HIzWQDSwyRsJRPbMjy02nU/rBZH43BsQ8OaJ2dkpNg
         w80A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779065654; x=1779670454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJd83rLCVfxsj/mKfcuVoPeefEJUdst8wi4jVzT8UGQ=;
        b=nf7uRQ7o06WhwyzR9ERgbPYs1hzBhi9WOSSouJ8SixB/t4BJaQpCKuwcgV1iMq0sSH
         fdD7klBLbK4HQjnIIPeQlnr3pNBtq7yJG9Y9ixo817Etreuy/KBPwrw125QU3k+lA77K
         ScKha1WK5kYeapzACFOEZjxFzajM50Y1p1nqWHKXI/kMtYkICmJiMnL7WxfK8vP3hORF
         eh3iLDIJYZVQ1LhKCbyJTG58254ieYmGSVtuovjcEoUOM3xGHnZqjI1fdrWEkAYZqV4n
         GF2xPuvRfBe61vSTpGw4CzKNt0dX+YfKfNhpLN4ql8I+fUYE2xuSrUu2EmIC/8oBO7yQ
         x3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779065654; x=1779670454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uJd83rLCVfxsj/mKfcuVoPeefEJUdst8wi4jVzT8UGQ=;
        b=XtXhqR0an+jNB5nBuCFmkXIFOE4+D+NdB5XVpCEB93N8OOhQp/96RHPG7pQIM6JiKi
         8QlYgA2TjXQ/RgoXT3hTciE7IOlxGK/M27PzAJ4Uj38VKxXoD94jiLBXnQiWiZENby2M
         e2Abe0KbO5qGY5gtbD2SABG64+xTLApcYGW2NZ6kUIJVoerbHOInvkvi5I+Z4A9pOT/3
         Gm2L/nPTp3Zj8mPuelZ3lkTQcP6GfjbWLNmtteXGReznrw6X2MhPjIs+OcYfb227MqSj
         +29v5f0sVinzJIPGG/0IsatoV3uS7SziBIeIX5jNNvsU+6UCZsJE4BjV3sPoIaY0xgcm
         YnWw==
X-Forwarded-Encrypted: i=1; AFNElJ/C/Txv5NAXY5OAL+Tn2zhtVwOQ8iQblAsxJbhqDoeNAImESBjmaE/UQxQqvDIsxkqyd6Gr738+erF0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9uZUxb03dBClOHJADjnFG1QtsteTQ7viUREFfmgc3iYYqeNh8
	kakeGB8uSSpGzFGE5AxGjT98hCsBkVLPHSQoHItklG2uZn+pAA2jcM+jy+YITb15tQFEYcLB0Ja
	98Z7Lts/q2Cj0LVFYVSfgJKvg1C2scEA=
X-Gm-Gg: Acq92OE05dwQlO9YlfQRP9faMOUUT/aEVrqeaxK/ZBqxAhafqHhgbIpKbftkf3CASV2
	34v0g03JYQw0PPw9UemnUN2xSQzq83/6jg7ZzN+ZJ174Um5Yw+39XmL6bQ8W8/1M4Ipv2kVQmMi
	0VH8LKKtjpwYgXrhGU7qjRTwXEaLpElML6W5EfPYbFx1sIoZh2OaYchNidQG4IhkXPVNh7F/0/w
	QC5VfIFXnDeo92WzjWCZvNA1Igd/cX4P9TgJ2ON/3MRJ9MRbJcafwi+a7Ph8IyURxQ3bbypD7Jg
	w2volaKmu7rnXOWhJ2gLiMjhYNlnffDnBAsm5oWjzNRA6hHmy00OoTbiBVXe5wbLXWrUxVNPV+N
	Nj2oRYgt9Lo0r5qUR2sk5Yzj7bzgX+7wghgY6xHifzzeBuBir/GuR8o98MGnrzBwRAxar0tcmKY
	KYdi4cx+RHpWX0UcIM5GyqzExURmLV4cVY
X-Received: by 2002:a05:622a:1181:b0:50f:b6ef:e10a with SMTP id
 d75a77b69052e-5165a201513mr187647751cf.43.1779065653906; Sun, 17 May 2026
 17:54:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518001150.1323245-1-michael.bommarito@gmail.com>
In-Reply-To: <20260518001150.1323245-1-michael.bommarito@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 17 May 2026 19:54:02 -0500
X-Gm-Features: AVHnY4Ja0__tLlqpTmPCVxH-h5n8wgdhcQVIyZE9ERfySgSyuUOST1mYYhqUOWE
Message-ID: <CAH2r5msZ+R8ZL3mmF4y-i3rGiC_5CDj_a+8mfsydqg7mDOcW-w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] smb: client: fix CIFS SWN notify lifetime and permissions
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Samuel Cabrero <scabrero@suse.de>, Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng

On Sun, May 17, 2026 at 7:12=E2=80=AFPM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> This is v2 of the CIFS witness notify fix series.  v1 fixed the
> basic cifs_swn_notify() use-after-free and added GENL_ADMIN_PERM to
> the incoming notify command, but review pointed out that the lifetime
> fix still trusted the raw tcon pointer cached in cifs_swn_reg.
>
> That cache is unsafe because cifs_get_swn_reg() lets multiple tcons
> for the same net/share name share one witness registration id.  If the
> first tcon goes away while another same-share tcon keeps the
> registration alive, swnreg->tcon can dangle.  Taking tc_lock through
> that pointer is therefore still a use-after-free, and taking tc_lock
> while holding cifs_swnreg_idr_mutex also violates the documented CIFS
> lock order.
>
> Patch 1 changes the SWN registration model so the registration stores
> only stable witness identity: registration id, net name, share name,
> and notify flags.  Notify handling copies that identity under
> cifs_swnreg_idr_mutex, drops the mutex, and then finds and pins a live
> matching tcon under the normal cifs_tcp_ses_lock -> tc_lock order.
> Register and unregister messages use the caller's live tcon rather
> than a cached registration tcon, and the unregister path no longer
> finds a registration, drops the mutex, and later puts a raw pointer.
>
> The intended one-registration/many-tcon semantics are therefore:
> a registration id represents a net/share pair, and notify handling acts
> on a live representative selected at use time.  If the registration id
> exists but no live matching tcon remains, cifs_swn_notify() reports
> that separately instead of logging "registration id not found".
>
> Patch 2 keeps the GENL_ADMIN_PERM gate for SWN_NOTIFY and also adds
> GENL_MCAST_CAP_NET_ADMIN to CIFS_GENL_MCGRP_SWN.  The multicast group
> carries register messages that include the registration id and, for
> NTLM-authenticated mounts, username/domain/password attributes copied
> from the CIFS session, so unprivileged local users should not be able
> to join the group.
>
> Build, static, and runtime validation for this revision:
>
> Targeted UM build of fs/smb/client/cifs_swn.o and fs/smb/client/netlink.o
> on top of v7.1-rc2 rebuilt both touched objects with no new warnings.
> scripts/checkpatch.pl --strict on both patches is clean.
>
> I also ran a KASAN + PROVE_LOCKING QEMU build with the existing ksmbd
> test harness that advertises CLUSTER capability so the client witness
> path is exercised:
>
>   - root-sender race campaign, four parallel mount/umount profiles,
>     using root notify senders to bypass GENL_ADMIN_PERM and stress the
>     lifetime fix directly: no KASAN, oops, or lockdep signatures
>   - same-share regression: two witness mounts with nosharesock shared
>     one registration id; after unmounting the first tcon, CLIENT_MOVE
>     against that id completed successfully on the remaining live tcon
>   - CLIENT_MOVE trace: unregister-for-old-IP still precedes
>     register-for-new-IP
>   - echo/check path: echo_interval=3D1 drove cifs_swn_check() while
>     DebugData exercised cifs_swn_dump()
>   - SWN_NOTIFY permission probe: uid 65534 gets -EPERM; root reaches
>     the handler and receives the expected no-registration -EINVAL
>   - multicast permission probe: uid 65534 gets -EPERM joining
>     CIFS_GENL_MCGRP_SWN; root joins successfully
>
> The notable runtime results are summarized above.
>
> Changes since v1:
>
>   - remove the raw struct cifs_tcon pointer from struct cifs_swn_reg
>   - resolve and pin a live matching tcon after dropping the SWN idr
>     mutex
>   - avoid taking tc_lock while holding cifs_swnreg_idr_mutex
>   - keep unregister send and kref put under one SWN mutex section
>   - distinguish "registration id not found" from "no live tcon"
>   - mirror extract_hostname() / extract_sharename() byte-for-byte in
>     the new cifs_swn_tcon_matches() helper to avoid GFP_KERNEL
>     allocations under cifs_tcp_ses_lock and tcon->tc_lock
>   - restrict joins to the CIFS SWN multicast group
>   - add runtime coverage for the shared-registration case called out
>     in v1 review
>
> Michael Bommarito (2):
>   smb: client: resolve SWN tcon from live registrations
>   smb: client: require net admin for CIFS SWN netlink
>
>  fs/smb/client/cifs_swn.c | 314 +++++++++++++++++++++++++++++++--------
>  fs/smb/client/netlink.c  |   6 +-
>  fs/smb/client/trace.h    |   2 +
>  3 files changed, 267 insertions(+), 55 deletions(-)
>
> --
> 2.53.0
>


--=20
Thanks,

Steve
