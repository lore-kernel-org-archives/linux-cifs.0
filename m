Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEE3BFE33
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 06:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440395; cv=none; b=D6Ht8n0cXcXFjucPU05WrSLW5yx91+QfbVs8Tyj9BJau0IFRegnMiQMpoY3JdEpPDwnhICoA6bManD4qbtps5cNiQfgUPEA5tcKQKDiP9x8PxXiXVQdgO88OfJkZn8qvPJNevOqhVp05CbOTGwiiJMcThtfNEv4RlFlpE5RU/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440395; c=relaxed/simple;
	bh=3eUEBAxEBHdf0vxB0Gl2ftu677ZQ+iuLUYtu6Qfd8Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L5DvwDfwEil0RifPWpXwArm1dIs4drw112VZbtxA0FSKmVNLiUzBPCun9dw6v6rdtvlzl9/GIUc46u+PT7aLm6oi8dCkM0Zk+VCmjh8yd2c3ttiz/chE297gSJEyZkdjHkYLU6poNa6FAY0axp8vBlidMks6DdhPx727AyJN21M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnFWWItq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnFWWItq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5911C1F00898
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 06:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791440394;
	bh=r2Y2fxsPL+pszBLjC5Y7l/3x5ePB0WLopgx41T7ILMw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FnFWWItqyvPV0IL7n5Ej9Z+VErp2FmPq5JPRzN29TpyxexZ71RU4FEHng4IXRQLWP
	 131PP4+4VGwTT4FSDUmb6x8QiPYOJBue0fgscAEaS/5R/f+KrBP+KeYw1enRvujX2z
	 iXMioLzpY+js26dmD+GTEBHURB9cu3isZ4+OR2odk5vOWAyOFhqgufvGMp3/750sVm
	 bn1Rw62ayJO7nP/YAkqWXZkg/KNQVMuE/brCc3MH8Spncfko732Ggdi9dMG2ljknbT
	 uQe/wDkF5ykLuhzcXTO+IR9OLLvss6veBDZliu/uG6Swagiikd7JnmwXMcXQh/csp4
	 ia7oE7SlknCsw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6aa5d092211so7931098a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 23:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBytXAGnPiBnCrZPUkgjDLce4d0MGyvouEVV1mtR6sEJUvGH8xDuz/2ZWeMcdlbnktnUWavrFuqTrFTl@vger.kernel.org
X-Gm-Message-State: AFuF++m+sCPO6Sj6w2ifV8Lgyg2AdnkQmDmdt242c1NvR9IeFpAjaBjq
	HM4ZWlOL9YO392QQmHJ99LxgghAAYsHYAxUWo5i2Jy19Jcpil4KBYiCT40rXvRLWUqQR/3Tdh1O
	wm+BScMC/GI0GDCOCqVV/slCSOuFAYjs=
X-Received: by 2002:a17:907:3da8:b0:c2e:3d17:5259 with SMTP id
 a640c23a62f3a-c317c132f17mr425028566b.41.1791440392953; Wed, 07 Oct 2026
 23:19:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791311817.git.metze@samba.org> <ab714dc8161c7b23734d95157b0b86e5d0081f1b.1791311817.git.metze@samba.org>
 <CAKYAXd-ziPYkMzYodQ1=nEEL2JGnAeGe9eYR8d_jk5EOTOEMPw@mail.gmail.com>
 <CANTrAmz-eDf4yacfb+LKEug8Asz3cEEGg2h_6w-pmT_6L4GTzg@mail.gmail.com> <76ad9700-db36-4c9e-966a-3dd403706780@samba.org>
In-Reply-To: <76ad9700-db36-4c9e-966a-3dd403706780@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 8 Oct 2026 15:19:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91zf8Y+9u9V7OS5m3N_QdN=6geC9LhzUKUSEfYNPGdqQ@mail.gmail.com>
X-Gm-Features: AclHuK-HvOCfrbDyKNh9rUVfECUGuy8vdvz1oCwDnvUIS_EBxTo4_Tc2Ytm2L_A
Message-ID: <CAKYAXd91zf8Y+9u9V7OS5m3N_QdN=6geC9LhzUKUSEfYNPGdqQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] smb: smbdirect: release failed pending sockets of
 a listener
To: Stefan Metzmacher <metze@samba.org>
Cc: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Sashiko <sashiko-bot+sashiko@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 3:10=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 08.10.26 um 06:53 schrieb =EC=9D=B4=EC=84=B1=ED=98=84:
> >   Re: [PATCH v3 2/3] smb: smbdirect: release failed pending sockets of =
a
> > listener
> >
> > Hi Namjae, Metze,
> >
> > On Thu, Oct 8, 2026, Namjae Jeon wrote:
> >> Does this make return 0 unsafe? This path now queues cleanup after
> >> creating the QP, then returns before cleanup runs. If DEVICE_REMOVAL
> >> event arrives in that gap, the temporary handler sets sc->rdma.cm_id
> >> to NULL and returns -ESTALE. The CM core then destroys the ID, and the
> >> cleanup worker tries to destroy the QP with NULL ID, causing kernel
> >> oops ?
>
> Thanks Namjae for finding this!
>
> > I agree, and I think there is also a UAF variant of the same window.
> >
> > The patch comment says nsc "cannot receive any rdma event", but that
> > is only true while the CONNECT_REQUEST handler runs. After return 0 the
> > core drops new_id's handler_mutex, so cma_send_device_removal_put() can
> > deliver DEVICE_REMOVAL before smbdirect_socket_cleanup_work() runs.
> >
> > In smbdirect_socket_destroy():
> >
> > if (sc->rdma.cm_id)
> > rdma_lock_handler(sc->rdma.cm_id);
> >
> > sc->rdma.cm_id is read without a lock. If the worker reads a non-NULL
> > pointer, and then the removal handler clears it and returns -ESTALE,
> > destroy_id_handler_unlock() frees the id_priv and rdma_lock_handler()
> > touches freed memory. So it is UAF, not only a NULL deref.
> >
> > Also, the QP/CQ/mem pools are still alive at device removal time. They
> > need to be released before the removal handler returns, otherwise the
> > later teardown runs against a device that is already gone.
> >
> > The old code had no such window, because the failure path returned
> > non-zero and the core destroyed the id while handler_mutex was held.
> >
> > Possible direction:
> > - in the DEVICE_REMOVAL branch, destroy QP/CQ/MRs/PD synchronously
> > (rdma_destroy_qp() is fine under handler_mutex), clear cm_id under
> > the lock and return non-zero;
> > - in the teardown, read/clear sc->rdma.cm_id under a lock and skip the
> > RDMA teardown when it is NULL.
> >
> > I will try to reproduce it with rxe + "rdma link delete" under KASAN,
> > forcing a failure in smbdirect_accept_connect_request() and delaying
> > smbdirect_socket_cleanup_work(), and report back.
>
> I think while we have smbdirect_new_rdma_event_handler it's fine.
> But starting with smbdirect_socket_init_accepting which currently sets
> it so smbdirect_socket_rdma_event_handler, still fine until
> we call smbdirect_accept_connect_request, I think before calling
> smbdirect_accept_connect_request() we need to set smbdirect_accept_rdma_e=
vent_handler
> at the beginning.
>
> Do you agree that would fix it?
Agreed, that should fix it.
Thanks!
