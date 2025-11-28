Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FED41FC8
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764300035; cv=none; b=nrmfE/Sr/GT52gIB7kd6gArdmTQdJTsXvRLS6uHlbi75B4AZNBwB4iydsgfDPnl3eLWYD3mvVop6JM4iKu3ClTv+zw75ARc/IrZ6LXaf8yoTNldmcIXUIAEr1RE2TyoMD6djgINbVvejR1SJK20iIHbEd5Wi1rv9hr8/qFyYWnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764300035; c=relaxed/simple;
	bh=sDExBSUWwxmVOwn43vrN1ZoTULhjDDkXCc7MXRgcvwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWwEz4C5Nbf0eAsTG4s8lILw/BVFtynrEsi+KIKd99BG9+Nydo1mPhFW+UzHJe2U3Z72frhC+Vk/EoEDSToVcS6GuARTKBzKvJ+U3gfiURhKq89jl4RNGMfkRlDRR8ov1oGwGk4uoeu4sqMZ8nflfktUm2QERxiwSp9htOyT+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4nBLi/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4nBLi/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E551C4AF0C
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 03:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764300034;
	bh=sDExBSUWwxmVOwn43vrN1ZoTULhjDDkXCc7MXRgcvwI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W4nBLi/3m7MUZEl6WhPGEEDeLy/Xz1yuvVdeU4F6zYWIi1Q8eoivKXD3YsB/rd4SC
	 BtH/2JlQcPw+pycdUxVsOMA9x6hJIoOeu+VzWho1DfNYE51QThs/sF6x7I4LJz9m9f
	 +umf6BUCbLE76vQ/kFUqjPpi9TRkRBZsH215DslbkAv3/Rket0tKd5IDg5UlhWkKS5
	 NKo0OvFplDu8SEY6Z2EPlmXok8gsE/rqfyG4wUBbI6ITsk7mtoB2UhUNDqmGfQTKV2
	 Eyu0yINWsAorplrc9BDkQ9IWsFlbH9jiAmyCkUIDAzuYXt7L/ENh4lQNPFZnrf6T9a
	 vyuvkpvJX88BQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso2210325a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 19:20:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUZj/hND5yGOIGGqFXBQ7vadDlyhAEFykUOzJo1dovsvOALd9AhSGogaLDCeE2Ej8xf9PUaemFClO5S@vger.kernel.org
X-Gm-Message-State: AOJu0YxVF1JT/bSxpj0EwPGcKtp0ngCHzAUm5DDvipObGspDVSptxw/j
	UJrq1Ptg+Zp92mncNi34qnos24fL4DYskGBQTrCLQpQU51ti6p1EFizpsB5Un8dGqnQyJGsD2IH
	sLpypR7Ebj8FGbMBLxTrTNcyx9BLddMU=
X-Google-Smtp-Source: AGHT+IHe69xOS3lJUUujyxSL635KRk127SWq4UDqx0bSitEYrvJKWUekmiMyi7gAiA8QLTRyBY/PTr+wAiAqEwXOfUo=
X-Received: by 2002:a05:6402:13d4:b0:640:7402:4782 with SMTP id
 4fb4d7f45d1cf-645559fc4d0mr22327177a12.0.1764300029109; Thu, 27 Nov 2025
 19:20:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <2786ee25-b543-48a8-8fff-e6c7ff341774@samba.org> <CAKYAXd8N-j8K1CUUH9_+wXpEZBo5i=K=ywkQPjJmmo76JbmXng@mail.gmail.com>
 <bd457989-d73e-4098-b3f7-c6871f49d188@samba.org> <ad3feff5-553d-4d98-b702-9c7a594dd7c0@samba.org>
 <CAKYAXd_UJHTsa6QNW+Qzo6BjEqOXEF_bM=a=XRKm=OFwoigu4A@mail.gmail.com>
 <dea0cad7-c068-4401-85e0-0757252c7857@samba.org> <afb8eb46-30e4-4e84-b0b2-b7e145abbdb0@samba.org>
In-Reply-To: <afb8eb46-30e4-4e84-b0b2-b7e145abbdb0@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 28 Nov 2025 12:20:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_K0mEKyzxMzFQiw7dLa2nRmZGrRm4Ja=kNffayamx0Fw@mail.gmail.com>
X-Gm-Features: AWmQ_bljg0AOTxLWs7F9TNYYKeaHXKNQDIKRqk4G4bHL9vScsxamXzOnwq_7o6s
Message-ID: <CAKYAXd_K0mEKyzxMzFQiw7dLa2nRmZGrRm4Ja=kNffayamx0Fw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Paulo Alcantara <pc@manguebit.org>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 12:50=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 27.11.25 um 16:45 schrieb Stefan Metzmacher via samba-technical:
> > Am 27.11.25 um 00:10 schrieb Namjae Jeon:
> >> On Thu, Nov 27, 2025 at 1:03=E2=80=AFAM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>>
> >>> Am 26.11.25 um 16:18 schrieb Stefan Metzmacher via samba-technical:
> >>>> Am 26.11.25 um 16:17 schrieb Namjae Jeon:
> >>>>> On Wed, Nov 26, 2025 at 4:16=E2=80=AFPM Stefan Metzmacher <metze@sa=
mba.org> wrote:
> >>>>>>
> >>>>>> Am 26.11.25 um 00:50 schrieb Namjae Jeon:
> >>>>>>> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze=
@samba.org> wrote:
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
> >>>>>>> First, the warning message has been improved. Thanks.
> >>>>>>> However, when copying a 6-7GB file on a Windows client, the follo=
wing
> >>>>>>> error occurs. These error messages did not occur when testing wit=
h the
> >>>>>>> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
> >>>>>>
> >>>>>> With transport_rdma.* from restored from 6.17?
> >>>>> I just tested it and this issue does not occur on ksmbd rdma of the=
 6.17 kernel.
> >>>>
> >>>> 6.17 or just transport_rdma.* from 6.17, but the rest from 6.18?
> >>>>
> >>>
> >>> Can you also test with 6.17 + fad988a2158d743da7971884b93482a73735b25=
e
> >>> Maybe that changed things in order to let RDMA READs fail or cause a
> >>> disconnect.
> >> The kernel version I tested was 6.17.9 and this patch was already appl=
ied.
> >
> > Ah, good it also has:
> > smb: server: let smb_direct_flush_send_list() invalidate a remote key f=
irst
> >
> >>> Otherwise I'd suggest to test the following commits in order
> >>> to find where the problem was introduced:
> >>> 177368b9924314bde7d2ea6dc93de0d9ba728b61
> >> I don't have time to do this right now due to other work.
> >> Did you test it with a Windows client and can't find this issue?
> >
> > I can only reproduce the problem this patchset is fixing,
> > (recv completion before getting the ESTABLISHED callback).
> >
> > I tested with an Intel-E810-CQDA2 card in RoCEv2 mode
> > and a Windows 2025 server (acting as client against ksmbd).
> >
> > And I can only reproduce the problem with the recv completion
> > before the ESTABLISHED event. So this patchset is not only
> > used for setups with a connectx-7, btw were you testing with infiniband=
 or rocev2?
> >
> > Otherwise copying a 2G and 5G file to and from the share works
> > without problems.
>
> I also tested with my latest smbdirect.ko patchset
> in the for-6.19/fs-smb-20251125-v4 branch, also without problems.
I will test your latest smbdirect.ko patchset with my windows client
and share the result with you.
Thanks.
>
