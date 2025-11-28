Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B325A32570F
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764331904; cv=none; b=EWdY/EEJSehRDxquF1flBC8GgxI8nEFEBLGP5WmRwB7jZDJbltJOVBWVYyhvFTRZL/FMPu3EnDqJRLFSg41R5zbYFopz89jpxTFpYlK7MwIIs+8T2U/4MBZAntmgdECiAMStMaD0XLUunS5rZ5GFp/M5u1YAbvtddJrAItNb1dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764331904; c=relaxed/simple;
	bh=F9f9DGXUrMDAnd6Dn6rt6a+KkNE9C3JXOmFHvWQiH2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J5VP++ldQox92BWXUiK93dnKHPh8p+aeVbSrv7QxXxm6+Ck1swopLinjyRI0wYlrDcPIzV5I+1CHJMKQtk7rJqOBmCpjK9Q1JiQcPfI0zkx0gL4daL3zvTqJ3ieBOpyRuvoDWOBZwJzB1zll/YciX+9GVBZSTDqJq+rBmLN6f+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtFqyPfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtFqyPfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E81DC116B1
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764331904;
	bh=F9f9DGXUrMDAnd6Dn6rt6a+KkNE9C3JXOmFHvWQiH2A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jtFqyPfLOECpSBRGXvZlHENcJWOaafmlVI/XoNG+NUo5pUYtKn5PHcaNBZdbsqRzZ
	 NfWyE2kkh6t6flZD0ou6Z46szF3f36nC58bLLdTaACXbld6paHUteedw5l1pXXgGRa
	 aWt4a8bQNU+dtN6t4XVDFfCNgZfSf/vtzXKgKhZ70GBqbMjMhxHSbYMXJSlJaHobUh
	 m+Cbo3ZI16L23yXMReP8SsIcgu37L5ins+kwDpbx+HQWkrOLSEgzA0qOUTSnEond+B
	 m9yrp/iKKR/3AWaNSC4ynJrO5T5zdGN1iwS9WrPU6Hat4lsPmNHSTzOPIuO2zG8GMd
	 hsHhpAGTqGUHQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2714165a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 04:11:44 -0800 (PST)
X-Gm-Message-State: AOJu0YykCt0MgkNfwlTOiD5I4Q71zBlSFi6vn/lrL7e6rkfZFRYvBIo4
	F/6wTl9J3k4gQvCAn0czfyiGaqJ73b+0DT7zlPQ8s7NxeJj1tntRKNc13eBCyD1lnfxfcVh2RK9
	tA6XdggWJY1+y38tJ65tOIyAxPpYbbgM=
X-Google-Smtp-Source: AGHT+IEffDeZwVF5mFCzAVnIQ8TJdGu+rjb9yXvUfWzVpLBxZiS0LGnwDmnR/XdTLP4zWNha3bWXYAMaNbnF3wfwIOk=
X-Received: by 2002:a05:6402:1d1c:b0:640:aae6:adc5 with SMTP id
 4fb4d7f45d1cf-6454ddd44e5mr19170827a12.4.1764331902898; Fri, 28 Nov 2025
 04:11:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
 <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org> <CAKYAXd8QhE_=zoK3pLqd0M-8Zw8M0auTw-P5yoqe6DioGXtsaQ@mail.gmail.com>
 <CAH2r5mv0BLnF9+ori1ZfoaYfBLXcscjuFkkAjggSY+aroKDRiw@mail.gmail.com> <b1f6271b-3c2a-493a-a404-7cdacd791acb@samba.org>
In-Reply-To: <b1f6271b-3c2a-493a-a404-7cdacd791acb@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 28 Nov 2025 21:11:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ykY7y0PGFcibQMUjQxb9_usEqKEJFrWJCBFuNesji1A@mail.gmail.com>
X-Gm-Features: AWmQ_bmtVVQXPh5UQzokz3qk6O3MeIluP216uxsVWDjRbdhl1T9UnaQJmZGX-Js
Message-ID: <CAKYAXd9ykY7y0PGFcibQMUjQxb9_usEqKEJFrWJCBFuNesji1A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 7:17=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 28.11.25 um 05:53 schrieb Steve French:
> > On Thu, Nov 27, 2025 at 9:19=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.=
org> wrote:
> >
> >> On Fri, Nov 28, 2025 at 12:54=E2=80=AFAM Stefan Metzmacher <metze@samb=
a.org>
> >> wrote:
> >>>
> >>> Am 26.11.25 um 02:07 schrieb Namjae Jeon:
> >>>> On Wed, Nov 26, 2025 at 8:50=E2=80=AFAM Namjae Jeon <linkinjeon@kern=
el.org>
> >> wrote:
> >>>>>
> >>>>> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@s=
amba.org>
> >> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> here are some small cleanups for a problem Nanjae reported,
> >>>>>> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> >>>>>> by a Windows 11 client.
> >>>>>>
> >>>>>> The patches should relax the checks if an error happened before,
> >>>>>> they are intended for 6.18 final, as far as I can see the
> >>>>>> problem was introduced during the 6.18 cycle only.
> >>>>>>
> >>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
> >>>>>> message, I'd really propose to keep this for 6.18, also for the
> >>>>>> client where the actual problem may not exists, but if they
> >>>>>> exist, it will be useful to have the more useful messages
> >>>>>> in 6.16 final.
> >>>> Anyway, Applied this patch-set to #ksmbd-for-next-next.
> >>>> Please check the below issue.
> >>>
> >>> Steve, can you move this into ksmbd-for-next?
> >> Steve, There are more patches in ksmbd-for-next-next.
> >> Please apply the following 6 patches in #ksmbd-for-next-next to
> >> #ksmbd-for-next.
> >>
> >> 3858665313f1 (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-next)
> >> ksmbd: ipc: fix use-after-free in ipc_msg_send_request
> >> b9c7d4fe6e93 smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >> checks in recv_done() and smbd_conn_upcall()
> >> 6c5ceb636d08 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >> checks in recv_done() and smb_direct_cm_handler()
> >> d02a328304e5 smb: smbdirect: introduce
> >> SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> >> 340255e842d5 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helpe=
r
> >> 01cba263d1bd ksmbd: vfs: fix race on m_flags in vfs_cache
>
> It seems these are the v2 patches, please use v3,
> the difference is that the __SMBDIRECT_SOCKET_DISCONNECT
> defines are moved up in order to let the patches on top work
> with out modifications. I noticed the difference while
> doing a rebase on ksmbd-for-next and get conflicts.
Right, Sorry for missing v3 patches.

Steve, Please apply updated 4 patches in ksmbd-for-next-next to ksmbd-for-n=
ext.

fc86cca6087f (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-next)
smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
recv_done() and smbd_conn_upcall()
111b7cb1b7f6 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
checks in recv_done() and smb_direct_cm_handler()
12059ee95a5b smb: smbdirect: introduce
SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
3658d5ac7908 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper

Thanks.
>
> Thanks!
> metze
>
>
