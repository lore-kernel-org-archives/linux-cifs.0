Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F7235360
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342073; cv=none; b=bRHlhvuq5UFSjEPP83Ofy9Bklpju01p+K6vvIDuHKNWE4I4sV0EpuIPZQ/39ci91ViepUdP8ifNj0ydAmUWQH1DkjjQsknYhh0uR+ufHKEbhbAqpllpi53Zyx1hr07JqXy4/0k+uCJDID036ifxQ6mFKabBAwJAxCIDrLW5zQZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342073; c=relaxed/simple;
	bh=/szzNrYlz98R3QfGXotkgAtD3Y44xYYQjzP9HCDXiVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AddJIZys6EAUkJAJvMAQRjqjBQqgFhRGGhfDdXAVf15TX8X3TCqQ5oC2soJDv4qWlLW21EMYPBTwRXOZco4b6JiGFA7UdLPwQNSuFdaq6LIKiDPONmTG5tQr96yMBp6vaj0qXVv2u7k7gsFcfqhU1RhohfbxXfn/jw1ZbQ91z70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNZEbyV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNZEbyV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEAFC4CEFB
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764342071;
	bh=/szzNrYlz98R3QfGXotkgAtD3Y44xYYQjzP9HCDXiVk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dNZEbyV9tQ66RlTMpyKfSEU9OSZd3fhDhPK+ARWSBtc+LXVGICwsyvkKJ4p64l7se
	 pYdXrmglCcRcyyyU/e7MJ9o0gP3TxJTBqGGTlHZMjFEmR5C17jgNOePhstHKxLoLKw
	 CoXP4L1gWZQjBgsn+ZmBxHxCdHU+XzhwIUBDfc/PGo/WNyOpiB0oqgcJbcb33NDkKg
	 PvLYeBgM5DsqDzzRwPZq9sceBYRbuZ+rgDKTZovyBrd+VWDUu6eLTekko4HgtAhZEb
	 OTkrfxPfVsj265+Uj/9p+cau6oBQKL9SLQRPuhQxkplcVzGDkdBoXxJCw3u4enWwCS
	 Xq+wGOGc01fnA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b76b5afdf04so359664666b.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 07:01:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXLLm0fpmy15StQoU8tayXSIL678IpS9xqx/tabcx38P3lz/8EHQ7nZjhpJbKzZn2i3W/OqQHsZY69k@vger.kernel.org
X-Gm-Message-State: AOJu0YxkXQh+coOUbu59Ppc6Cx3Ct8lQiTKUpMebkokosiodg8EyUK3I
	fEtHwsNvigLKjC0KLba0JgWeb2w4JJqupIq8R4RCP0HcCaqHHx4cQKu8tpQ0RX+HV+g+6O+oZje
	YAVFRr+kMI4JP417bHOHVkFb3YSN20xI=
X-Google-Smtp-Source: AGHT+IGHlZ1Es0U7rEAngTS8cZtvPlTvl4knXZuU8toy/vG2ApkMPS/LvqqgX2OzPNh3dmKI6PABZy/tw9ZtuOSzk6M=
X-Received: by 2002:a17:907:9487:b0:b76:6020:ed2b with SMTP id
 a640c23a62f3a-b7671898fd8mr2929650466b.45.1764342070152; Fri, 28 Nov 2025
 07:01:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
 <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org> <CAKYAXd8QhE_=zoK3pLqd0M-8Zw8M0auTw-P5yoqe6DioGXtsaQ@mail.gmail.com>
 <CAH2r5mv0BLnF9+ori1ZfoaYfBLXcscjuFkkAjggSY+aroKDRiw@mail.gmail.com>
 <b1f6271b-3c2a-493a-a404-7cdacd791acb@samba.org> <CAKYAXd9ykY7y0PGFcibQMUjQxb9_usEqKEJFrWJCBFuNesji1A@mail.gmail.com>
 <788d9b9e-e693-437f-bb56-1b84868b4250@samba.org>
In-Reply-To: <788d9b9e-e693-437f-bb56-1b84868b4250@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Nov 2025 00:00:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9eAZieZPb3RuOpC6msi9ctjpQ8aT-V33oF7qHxvAELLA@mail.gmail.com>
X-Gm-Features: AWmQ_bliYiHSUKajTi2xnXqj7qubxaxH6gUefndRP-u8yPXTyL9LKZBdO65mDiU
Message-ID: <CAKYAXd9eAZieZPb3RuOpC6msi9ctjpQ8aT-V33oF7qHxvAELLA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 10:35=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 28.11.25 um 13:11 schrieb Namjae Jeon:
> > On Fri, Nov 28, 2025 at 7:17=E2=80=AFPM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> Am 28.11.25 um 05:53 schrieb Steve French:
> >>> On Thu, Nov 27, 2025 at 9:19=E2=80=AFPM Namjae Jeon <linkinjeon@kerne=
l.org> wrote:
> >>>
> >>>> On Fri, Nov 28, 2025 at 12:54=E2=80=AFAM Stefan Metzmacher <metze@sa=
mba.org>
> >>>> wrote:
> >>>>>
> >>>>> Am 26.11.25 um 02:07 schrieb Namjae Jeon:
> >>>>>> On Wed, Nov 26, 2025 at 8:50=E2=80=AFAM Namjae Jeon <linkinjeon@ke=
rnel.org>
> >>>> wrote:
> >>>>>>>
> >>>>>>> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze=
@samba.org>
> >>>> wrote:
> >>>>>>>>
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> here are some small cleanups for a problem Nanjae reported,
> >>>>>>>> where two WARN_ON_ONCE(sc->status !=3D ...) checks where trigger=
ed
> >>>>>>>> by a Windows 11 client.
> >>>>>>>>
> >>>>>>>> The patches should relax the checks if an error happened before,
> >>>>>>>> they are intended for 6.18 final, as far as I can see the
> >>>>>>>> problem was introduced during the 6.18 cycle only.
> >>>>>>>>
> >>>>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE(=
)
> >>>>>>>> message, I'd really propose to keep this for 6.18, also for the
> >>>>>>>> client where the actual problem may not exists, but if they
> >>>>>>>> exist, it will be useful to have the more useful messages
> >>>>>>>> in 6.16 final.
> >>>>>> Anyway, Applied this patch-set to #ksmbd-for-next-next.
> >>>>>> Please check the below issue.
> >>>>>
> >>>>> Steve, can you move this into ksmbd-for-next?
> >>>> Steve, There are more patches in ksmbd-for-next-next.
> >>>> Please apply the following 6 patches in #ksmbd-for-next-next to
> >>>> #ksmbd-for-next.
> >>>>
> >>>> 3858665313f1 (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-nex=
t)
> >>>> ksmbd: ipc: fix use-after-free in ipc_msg_send_request
> >>>> b9c7d4fe6e93 smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >>>> checks in recv_done() and smbd_conn_upcall()
> >>>> 6c5ceb636d08 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >>>> checks in recv_done() and smb_direct_cm_handler()
> >>>> d02a328304e5 smb: smbdirect: introduce
> >>>> SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> >>>> 340255e842d5 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() hel=
per
> >>>> 01cba263d1bd ksmbd: vfs: fix race on m_flags in vfs_cache
> >>
> >> It seems these are the v2 patches, please use v3,
> >> the difference is that the __SMBDIRECT_SOCKET_DISCONNECT
> >> defines are moved up in order to let the patches on top work
> >> with out modifications. I noticed the difference while
> >> doing a rebase on ksmbd-for-next and get conflicts.
> > Right, Sorry for missing v3 patches.
> >
> > Steve, Please apply updated 4 patches in ksmbd-for-next-next to ksmbd-f=
or-next.
> >
> > fc86cca6087f (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-next)
> > smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
> > recv_done() and smbd_conn_upcall()
> > 111b7cb1b7f6 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> > checks in recv_done() and smb_direct_cm_handler()
> > 12059ee95a5b smb: smbdirect: introduce
> > SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> > 3658d5ac7908 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
>
> Given that we missed linux-next for this week anyway,
> we could also add everything from my for-6.19/fs-smb-20251128-v5
> branch, which is rebased on smfrench-smb3-kernel/ksmbd-for-next with
> the top 3 commits replaced by the top 3 commits from
> smfrench-smb3-kernel/ksmbd-for-next-next.
> And has the patches from David's cifs-cleanup branch
> as well as my smbdirect.ko patches.
I have added stable tags to the top 4 patches in ksmbd-for-next-next
so they can be applied into 6.18.
Cc: stable@vger.kernel.org # v6.18
>
> metze
