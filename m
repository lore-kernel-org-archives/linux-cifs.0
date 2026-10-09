Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4143B582F
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556692; cv=none; b=gQ+WjPTBd0QR/puMx9W9oeghJLgAFxHPF2K2xq2sJaDjrhZydUXNxwvD6+Mx2FuahuUM5mfzRUXHDk/HU4Wqa6MFF7KIiS0D8j46uN+l7WsJEvLsCb/JhcBExs2uEu5F4eQzNmTTsnV2T2J4V7xywL+MgwdBCN6beWUKbIU448g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556692; c=relaxed/simple;
	bh=JLopNOZ/myT30NPpGfLpD1rXbjMMLtaysWXzRWAWSCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5UDHTMk+zOdSQOvfr90UyC2mV407XNnK0g1j/e8jKSUEjtWpRwGwoq09TdxndPcsHMSIcLNlzWT5bjhssPH4u1d2Yjmn+ExPjf/Tc4QBQbsflccx1JG5+L9YUbNMO/F5lsPJhsNwrnmsTs3FEuXJNW1wHYv7dvp5xtfa8/WWjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HA9R8BTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HA9R8BTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7DF1F00898
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791556691;
	bh=bsQLUcaGtbp1qf2cGbEbtWgXLw9Mvc3l8cAzO0kngZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HA9R8BTjVDURBSW5I3oPlGJ3ZWY+aZfukKO5kJD9qq+Zgida3hVY/UiAIcz49BcX2
	 EQMwILFDwOUenU+A6li2YUARUVbsHR+Ysk0liDQtEl18M8u6ji1r+WScarjUB38oqt
	 Sw+zRsMssRjqpBSg1gUVm+rZq5NDdQnEbqpfm6SUP94no3ryI0bqoxzHEM7fk8RcKJ
	 gm4qrzb2bTP2MkVFrrVArGSJO8+eKlhDzxTi28EgqDllGE9A4Wu2ZLqzXmY0Gd3md8
	 4MnEkLBnwgrqgWBRafCYjmRvpOtXpXuPDPbnFIcN2nSLIkYtNTSp+xYHtG7/wk7EwB
	 U9NSnSio8sGEg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2afa22e1dcso611519566b.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 07:38:11 -0700 (PDT)
X-Gm-Message-State: AFq9FYKQ7GFnvhdtZYcU8oPaakIeJMA6lm1UBsSwbOubCfJ9IdZsJZEM
	Kvgy1MozBwTLffBYxrUdrVqEdjNq1NgcFYXPEy3z0hD29dG9aYWMevGw0Yo3wD6gmlLoywnH3BY
	PXDkGYlWAehRz3EZppQ6CM/A2UPCc0kY=
X-Received: by 2002:a17:907:9620:b0:c20:3402:bd35 with SMTP id
 a640c23a62f3a-c31a9fe68c1mr216602966b.12.1791556689907; Fri, 09 Oct 2026
 07:38:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007062936.25827-1-tjdqudcks0424@naver.com>
 <20261009135400.722291-1-tjdqudcks0424@naver.com> <CAKYAXd8md_8UbhNCJU6-SswRfsOo+vKpmVQQoyZK_WXAW7uaJw@mail.gmail.com>
In-Reply-To: <CAKYAXd8md_8UbhNCJU6-SswRfsOo+vKpmVQQoyZK_WXAW7uaJw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Oct 2026 23:37:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd98mTzSQfjW=AS7PkD_d75e+J4EaZBjoWXRNZnRf2pu2A@mail.gmail.com>
X-Gm-Features: AclHuK9PYAc0hgyg3IQgQtWXIPq6v8rTR03HpbX1GLp3lAiOJO_oRuXQb2sElyM
Message-ID: <CAKYAXd98mTzSQfjW=AS7PkD_d75e+J4EaZBjoWXRNZnRf2pu2A@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: hold TCP session for async decrypt work
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 9, 2026 at 11:37=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Fri, Oct 9, 2026 at 10:54=E2=80=AFPM Sung Byeongchan <tjdqudcks0424@na=
ver.com> wrote:
> >
> > Large encrypted reads may be queued to the global decrypt workqueue.  T=
he
> > work item stores a TCP_Server_Info pointer, but does not hold a server
> > reference while queued.
> >
> > If a multichannel mount removes a secondary channel before the worker r=
uns,
> > the final reference can be dropped and the demultiplex thread can free =
the
> > server.  smb2_decrypt_offload() then accesses the freed server object.
> >
> > Acquire a reference only while srv_count is nonzero under
> > cifs_tcp_ses_lock, which serializes the acquisition against the final p=
ut
> > without resurrecting a server already being torn down.  Do not queue th=
e
> > work if acquisition fails.  Let each queued worker own one reference
> > until its final server use, and release the transferred small buffer an=
d
> > reference if queue_work() unexpectedly rejects the work item.
> >
> > The unmodified kernel reproduced the same KASAN use-after-free in three
> > fresh encrypted multichannel runs.  With this change, the same race and
> > subsequent encrypted I/O, unmount, remount, and cleanup completed witho=
ut a
> > sanitizer report in three fresh runs.  Encrypted multichannel,
> > single-channel, and unencrypted controls also passed.
> >
> > The demonstrated impact is a client-kernel use-after-free and crash cau=
sed
> > by an SMB peer able to coordinate encrypted responses and channel teard=
own.
> > No controlled write, information disclosure, privilege escalation, or c=
ode
> > execution was demonstrated.
> >
> > Fixes: 35cf94a39728 ("smb3: allow parallelizing decryption of reads")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> > Assisted-by: LLM
> > Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo.

> Thanks!
