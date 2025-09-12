Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BBE155A4E
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 02:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757645682; cv=none; b=U7XZ5JZH63yInVYQWamt39ETY++3UD0Bn9wCj+uUc1NCcje/74Ec0MwTOV3VWlSAkkf/Y2ufHtUEMHl9wXJ6uk4ThZiKn1oW5ExvEbfEd3HGtemzKwZoKMVg/byf45jDHqag7DYDt/gz/V0DkL+VCJG6MYOBofDEfJFTzZmEHNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757645682; c=relaxed/simple;
	bh=QcDTjqoNM8e14hYD2dRGnyq2H7/2aYbRHqP7TSSUnaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rebV+1C1aBo4ANuBUe1aAo23Wd1ocWofAnFqnipsdCz/b00n0ZSW7Tk5xKQKI7gD53PQTwcjzn1Xg833kdv/a0J4bzy19/qFTZLMqdcf/EwAvWW6jxsMhyYFa1359QM62vjhG1Xts2ooJRqXk2qb41NGO50nrag4MPBJl3qrIC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTwVfmUD; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTwVfmUD"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-816ac9f9507so280130485a.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 19:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757645680; x=1758250480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWlEui1MS4p+97Kef0Cku33kemleVm/j9It+B+skSEY=;
        b=YTwVfmUD8Nc1UtcbxC6Ibr6M5r54+cUHlzHdgnPv3nWZ4z8Ejd3NACk12hbpeJkUE+
         nlu4RcZjLbD+e/8Dbf9UGL/1j/fLndWZB6zKdL/6CrcxN1CErMdppFM4PWK/xrRhX9ER
         o5c0S9xjXZplV3RWMkFrwKhWE7TDCjyZ1+ntdOgeTjx6j3ZNQ63k7hIAr7EP4RKIUpkX
         P2fCU/0NXRnbE3rmAsDNAsogs4jbRN+nsgI1Q7/heRPxhxtIP5j3DplN1okmPtK0cXS7
         9CxAT0rjcZe/gmTYEXzbyUGFfns7PEowd6pToDlLpgTzzj35cQRn6pexHoCfJLaZKASt
         2++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757645680; x=1758250480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWlEui1MS4p+97Kef0Cku33kemleVm/j9It+B+skSEY=;
        b=JxHvz0wCzgpFM3Oy2CHpbVaYKyVPRd9uoUsno0s1FBNpktVWcPsB/i0MpCjULnlNZX
         beKxlorlZaqGDbC8MfFdr83ViGDlbK+IzVGivWbvi1djXBVrkBWCmO60VTLADecQI840
         A29tZT7u9OttOS9XMWs1PObDeNMW/wSkYEfUFeL1O3+er/bDvD/zeAo5+v6rSCUN8Kb6
         Vemi2PsR1Q4JCyI0A7+Cyu5JiwauZQdDuBzJuArlSghfKwf38jOEqm9pJ+OhzQmVc2Bl
         w29k7gu/bTxMVyHyESRucwa7/aRKi2ZUEnIrK5VE3PN4iq4HPx958pT6IS2cjk8A/ZGS
         dVMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz7NNXtONniMUrvJSzn8xYXa8VekhDWggabIGZTgUwX10ho4sU1x56votKZ5QkJdELxwIOptsIxC1+@vger.kernel.org
X-Gm-Message-State: AOJu0YyI24A8o8FobDkijMvjS81aTfwjoDfwDzrajkprQqn5Vnj/Cag8
	Xgze3MyaodU9OCVtUhTlJme/GpqMKkf7cdW6vBExKbF1wy44PddrB6JUu+APfLPV2hI82E4u1wm
	HzKhcbAceYAo2Y5o/FhWgZHtenD4zuCo=
X-Gm-Gg: ASbGncu9UvPXXlPuieyLJYJmwH1H2dAEXsjy2KUSkitMLNypteAWxScz3D8neePktkR
	33ivA56JMhRG9eJg4ZZN9hIcWZ6BRHfZTj2vj5qLtbBuOqNwNv09cav9wlK6FCoxUKucCntyu64
	6SmKFa93B/3ZQpn57ahVF7oOH/fzuhsNg6BuZjxWEdSB55TIObx69tBeWUv7+kTlmeED2QlLIxY
	NA4UKZsR/vvCDF8AmJqswQmO0a5gj74/CG2ziXXIOA5OfGiLLlPvirU7J9sGUgJxEO/4NkssFBY
	+7b1J2SmWC2v+/l3cnmvlvVR/g1voBFaI31d6EnYMs43bEzGgY8yQLySt9ZIGpeb+B/RCneKtr4
	h
X-Google-Smtp-Source: AGHT+IFAOe2YtHJQzNZar2wGMA38p97B8ZZpaRrLwP+aTqMRGt8JNDXNrJqps6zidw347rnDa3kvIdtQevwFZItdd1E=
X-Received: by 2002:a05:620a:2990:b0:813:5fc5:d95 with SMTP id
 af79cd13be357-823fdeb37bfmr183072085a.33.1757645679710; Thu, 11 Sep 2025
 19:54:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250909202749.2443617-1-henrique.carvalho@suse.com>
 <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
 <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
 <bdfb29eb-35ab-473c-be08-1e0857c3c96b@suse.com> <b4373c49-6c3e-40fd-b942-b7a967833eaa@samba.org>
In-Reply-To: <b4373c49-6c3e-40fd-b942-b7a967833eaa@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Sep 2025 21:54:27 -0500
X-Gm-Features: AS18NWANpVteJSFKvySFI10IOsH6r-abKYGbu613-VMeEvUZxypfgFyHrlCO5Ms
Message-ID: <CAH2r5msehyTqjT_bpsw_t6CqUM00ZSOWPWmbfBTBvT02Uno7pg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Stefan Metzmacher <metze@samba.org>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have confirmed that it is patch:  "smb: client: skip cifs_lookup on
mkdir" which causes the generic/005 failure (and also an umount leak?
that causes rmmod cifs to fail) but interestingly this patch does seem
like the one that "fixes" (or at least works around) the generic/637
(incorrect directory contents with dir leases and new file created)
failure.

Let me know if updated version of this patch to test.

On Thu, Sep 11, 2025 at 8:55=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Henrique,
>
> I'm also seeing problems with generic/005, before failing
> it hangs a long time here:
>
> root@ub1704-166:~# ps axuf | grep D
> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAN=
D
> root         917  0.0  0.1  53408  3328 ?        Ssl  15:33   0:00 /usr/s=
bin/gssproxy -D
> root        1037  0.0  0.2  10888  7508 ?        Ss   15:33   0:00 sshd: =
/usr/sbin/sshd -D [listener] 0 of 10-100 startups
> root       11704  0.0  0.0   2824  1636 pts/1    D+   15:49   0:00  |    =
       |           \_ touch symlink_self
> root       11720  0.0  0.0   9784  2564 pts/3    S+   15:50   0:00      \=
_ grep --color=3Dauto D
> root@ub1704-166:~# cat /proc/11704/stack
> [<0>] wait_for_response+0x195/0x250 [cifs]
> [<0>] compound_send_recv+0xb9d/0x2ac0 [cifs]
> [<0>] cifs_send_recv+0x22/0x40 [cifs]
> [<0>] SMB2_open+0x352/0x17b0 [cifs]
> [<0>] smb3_query_mf_symlink+0x1c0/0x3a0 [cifs]
> [<0>] check_mf_symlink+0x281/0x7a0 [cifs]
> [<0>] cifs_get_fattr+0xc5f/0x21b0 [cifs]
> [<0>] cifs_get_inode_info+0xad/0x460 [cifs]
> [<0>] cifs_do_create.isra.0+0xe4c/0x2250 [cifs]
> [<0>] cifs_atomic_open+0x4f5/0x1120 [cifs]
> [<0>] path_openat+0x244e/0x47a0
> [<0>] do_filp_open+0x1e3/0x440
> [<0>] do_sys_openat2+0x100/0x190
> [<0>] __x64_sys_openat+0x127/0x220
> [<0>] x64_sys_call+0x1bce/0x2680
> [<0>] do_syscall_64+0x7e/0x960
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> I'm using these mount options
> -ousername=3Droot,password=3Dtest,noperm,vers=3D3.1.1,mfsymlinks,actimeo=
=3D0
>
> I hope this helps tracking it down.
>
> metze
>
> Am 10.09.25 um 23:09 schrieb Henrique Carvalho:
> > Hi Steve,
> >
> > On 9/10/25 5:28 PM, Steve French wrote:
> >> Henrique, I can repro the failure in generic/005 with your patches,
> >> but am fascinated that one of your patches may have worked around the
> >> generic/637 problem at least in some cases, but am having difficulty
> >> bisecting this.
> >
> > I had not seen the failures in generic/005, but I also had not tested
> > with smb 2.1.
> >
> > I will run more tests and dig into both generic/637 and the other
> > failing cases.
> >
> > I will get back to you once I have something more concrete.
> >
> >>
> >> On Wed, Sep 10, 2025 at 12:50=E2=80=AFPM Steve French <smfrench@gmail.=
com> wrote:
> >>>
> >>> Interesting that running with three of your patches, I no longer see
> >>> the failure in generic/637 (dir lease related file contents bug) but =
I
> >>> do see two unexpected failures in generic/005 and generic/586:
> >>>
> >>> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/build=
ers/5/builds/116
> >>>
> >>> e.g.
> >>>
> >>> generic/005 5s ... - output mismatch (see
> >>> /data/xfstests-dev/results//smb21/generic/005.out.bad)
> >>>      --- tests/generic/005.out 2024-05-15 02:56:10.033955659 -0500
> >>>      +++ /data/xfstests-dev/results//smb21/generic/005.out.bad
> >>> 2025-09-10 08:33:45.271123450 -0500
> >>>      @@ -1,8 +1,51 @@
> >>>       QA output created by 005
> >>>      +ln: failed to create symbolic link 'symlink_00': No such file o=
r directory
> >>>      +ln: failed to create symbolic link 'symlink_01': No such file o=
r directory
> >>>      +ln: failed to create symbolic link 'symlink_02': No such file o=
r directory
> >>>      +ln: failed to create symbolic link 'symlink_03': No such file o=
r directory
> >>>      +ln: failed to create symbolic link 'symlink_04': No such file o=
r directory
> >>>      +ln: failed to create symbolic link 'symlink_05': No such file o=
r directory
> >>>
> >>> Do you also see these test failures?
> >>>
> >>> On Tue, Sep 9, 2025 at 3:30=E2=80=AFPM Henrique Carvalho
> >>> <henrique.carvalho@suse.com> wrote:
> >>>>
> >>>> For mkdir the final component is looked up with LOOKUP_CREATE |
> >>>> LOOKUP_EXCL.
> >>>>
> >>>> We don't need an existence check in mkdir; return NULL and let mkdir
> >>>> create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).
> >>>>
> >>>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >>>> ---
> >>>>   fs/smb/client/dir.c | 4 ++++
> >>>>   1 file changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> >>>> index 5223edf6d11a..d26a14ba6d9b 100644
> >>>> --- a/fs/smb/client/dir.c
> >>>> +++ b/fs/smb/client/dir.c
> >>>> @@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, str=
uct dentry *direntry,
> >>>>          void *page;
> >>>>          int retry_count =3D 0;
> >>>>
> >>>> +       /* if in mkdir, let create path handle it */
> >>>> +       if (flags =3D=3D (LOOKUP_CREATE | LOOKUP_EXCL))
> >>>> +               return NULL;
> >>>> +
> >>>>          xid =3D get_xid();
> >>>>
> >>>>          cifs_dbg(FYI, "parent inode =3D 0x%p name is: %pd and dentr=
y =3D 0x%p\n",
> >>>> --
> >>>> 2.50.1
> >>>>
> >>>
> >>>
> >>> --
> >>> Thanks,
> >>>
> >>> Steve
> >>
> >>
> >>
> >
>


--=20
Thanks,

Steve
