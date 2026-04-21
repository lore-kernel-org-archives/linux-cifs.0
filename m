Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E8718FC80
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 01:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776735651; cv=none; b=Ci40a/M2Najqbi77dzeXUKWLyKdOtJ3Wt4o6eNRRLswpHI5o3Dso5dKsooOc3Mgalxe0CG1+MKhTkrA8JkWfgK4UzMDpwl8CZnGsRxzLt9VveuxKn4HnE1KmE1we7kz8gtx9HOboWFjTXJGv3lecI30Huyo7fU1tr4S1ASB+Y7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776735651; c=relaxed/simple;
	bh=lblu2Y/M/ip+rbBgyea4HYOI9n11bjXagzI+TlLTkZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E2mF7DNfLcf0+93FA9aKf3hl+7U8kj3fLMNR5SFNfuZlTQblJhbz8S73vWc2Tf3rN2KSfIXOJ7YMMwe27SIqopLs/308QdyM0DxzR8OpQvVk5oX3i9PYPE4qQyzMryabC5pvuV9k28zEH/0RNjWr0G88mcgOxcpauyBpl1lX9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOfbvTds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOfbvTds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE83C2BCB4
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 01:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776735651;
	bh=lblu2Y/M/ip+rbBgyea4HYOI9n11bjXagzI+TlLTkZg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jOfbvTdsdgvb/jo3/hyE9iRPXWE3VDB6L8ZCykdajh9/T9W3FhnrQDi3TNKDA/L5H
	 j9GUAGbTxdjwTH8xR1qTn4AC1jZWGfnMRKgeLVCc5nLugngCpzCsFLYo7zaNUEH5nf
	 Frl8pypK63QaeddNUr5qse19644FzMTc3/mStFJFBkiRkpBFtO0UZqcNLuAiCWU2zB
	 lvSiIv+YUXYBsDLSIYY+f8k/ZcV9KOU/dWfQm1X8V/U3+4KON8WqIxKJrfN56bwAQ6
	 OrQlb3E9XDNK/tHrQ0Z7E2klsALpgb+ISB63yhcSrLbRN2/3bX+UYorHQzt+LoaLdV
	 NONLEqpZwCF0A==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-676ab6d8075so325263a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 18:40:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/NXCBwAUz6rr4TFEpqzh8KNMAKj3BnVaRJvqdDeMebzHEtJ8WpjFowMvA9Vh1qGOQboQgMtF25gEvt@vger.kernel.org
X-Gm-Message-State: AOJu0YzXATMHOhZ86lSBlFBugwVgkAvFCP6TlDWjhKEzcLV4Dmz+gRxf
	ZHnK1OnoCriU6QGme32HxiEpHpHc6coWyAiSw47amb7TjDVWWkEdpNEIee5c41GiYsORaR0X8TZ
	WULdyKFqKeu4PJWaC1vuiqG9QONlkZZ4=
X-Received: by 2002:aa7:d7da:0:b0:670:8b7b:5004 with SMTP id
 4fb4d7f45d1cf-672bfedb106mr5146737a12.25.1776735649668; Mon, 20 Apr 2026
 18:40:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aeZG4xhoMhYFSsIy@v4bel>
In-Reply-To: <aeZG4xhoMhYFSsIy@v4bel>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 21 Apr 2026 10:40:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_QFUQb2f2y0ectw29ghrFwEEDPLBVRnwvpMzrZfSj1RA@mail.gmail.com>
X-Gm-Features: AQROBzAGiUcR3IXtqMt5pyphEnnH-CkpRIKgfldNfK5XGWSR6IadCvxs2cDXB0o
Message-ID: <CAKYAXd_QFUQb2f2y0ectw29ghrFwEEDPLBVRnwvpMzrZfSj1RA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: scope conn->binding slowpath to bound sessions only
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 12:31=E2=80=AFAM Hyunwoo Kim <imv4bel@gmail.com> wr=
ote:
>
> When the binding SESSION_SETUP sets conn->binding =3D true, the flag stay=
s
> set after the call so that the global session lookup in
> ksmbd_session_lookup_all() can find the session, which was not added to
> conn->sessions. Because the flag is connection-wide, the global lookup
> path will also resolve any other session by id if asked.
>
> Tighten the global lookup so that the returned session must have this
> connection registered in its channel xarray (sess->ksmbd_chann_list).
> The channel entry is installed by the existing binding_session path in
> ntlm_authenticate()/krb5_authenticate() when a SESSION_SETUP completes
> successfully, so this condition is a strict equivalent of "this
> connection has been accepted as a channel of this session". Connections
> that have not bound to a given session cannot reach it via the global
> table.
>
> The existing conn->binding gate for entering the slowpath is preserved
> so that non-binding connections keep the fast-path-only behavior, and
> the session->state check is unchanged.
>
> Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
