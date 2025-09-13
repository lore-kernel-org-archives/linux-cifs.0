Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593DB5C96
	for <linux-cifs@vger.kernel.org>; Sat, 13 Sep 2025 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757721796; cv=none; b=rFabd8uedF2CwiXpapww95TYKZ6lTaDJlOErup6HJL2olMLOPgglQT96ul/m7sll6KsPzF27VeABPsNoxRNYFkfJByaDFsK6kGRLmPUkV4THbgVkT0dFAD00EVERXUPVVLJ+cruVMA2JYXKqhGhQxFuCnwYbZoPfgFSVZ2fBiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757721796; c=relaxed/simple;
	bh=+HZJnxIXmVvvxzyAcEW6dH8cYPxR20aTuDYKz6b5bSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i00QGm2uM5QJFjGw8WVekoJysGyhV97CK+znD/0Yybp74l8+dXK5QckVwAQzgGxr1s7X4MAKdkNRFG+Kpc4wQPFBbqHUq/zA1rr9ZnTcBem3qZgndwOA721h+aT+uLHgRnD8a3q9fl7SQiMjd2zTyjhdjU6K1t3e8kAD7AAJje8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cy48agI2; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cy48agI2"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b340966720so21965921cf.2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 17:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757721793; x=1758326593; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KW5G3MXY/0pVf8/DjV6yOsnsMGNgnj9XmP/64EtE3w=;
        b=Cy48agI2wZwBo55EpazltldvvCgZf2lPkWjG/H9WPLztj7TtyK19bBdH7D1IOqiVeT
         FKmvmb9zBiKmSwq6PY2HBG3V757r/iytBECJXW96zwC4F+PkpLwcCY8KPwbULvZAWtzi
         VCvAD4b1mpHq4FWx81CnwyUmI0/YcnzNbr3UjHMdEB59BOpZafPoufPc/hDyeg35JmxV
         33JtC5/T7NxYw16LltTjuldoDLTZEqVglhT/lnc76TOyiXg0KA0G5A9c6pUsdQjKThUt
         wzysVsamK8sipgYXPwz8sZcz6glK0oP5zz74xnyr88wTkWVec3QSsmFF0KLlhVclIH1v
         Szkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757721793; x=1758326593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KW5G3MXY/0pVf8/DjV6yOsnsMGNgnj9XmP/64EtE3w=;
        b=X97AxjP5F2tndlUlYoH0Ot9Pn8TG0R8cidgzMOzl8h10DpZ6zd+BdyvI5RNPHUmWTt
         LxQBBHcpLgcTRZ/0QyR+RDfgfCWawb57sYikWO9Anv7waYgN4co+1SMU7B7oAZz1J4xG
         WmmR0JC8oeyvrBzoWuWSly9s2XJv4n0Qw6DtosPsrE8tgP/z7nOtax1PeZDYOPi9YrT5
         ElWwZL2UFArTeyjTois0cL5nCMRYVH+2zoYD3JEUXI5E8PsHjm9zNCs20uTufunQCnuV
         pJIgS+ACqL4yfeCUok20dd1BtnBNorpPbxH/M/nVgTLjg5Z7Nt8/kIyyRVC3fb2+H76X
         rGrg==
X-Forwarded-Encrypted: i=1; AJvYcCXlGfFcbTC8G7EcEaKoCm+08LdKE00BCP8kCPy6kbSPj4LgTYiYRkNOJE3b3N3uYljYnpxSK8ZdgKnB@vger.kernel.org
X-Gm-Message-State: AOJu0YzKZn9yJ3vAu0JJRvI0mMic6j/g55n5wXTV8tmaUSqWNAdyUXn2
	NuVR7Hg5AyIifHU3t8OUjoaCOaKwClhNuV6u70KU0d8QnN2qlhgTDxMv8Rmg4uXD09Itk6qfRoY
	YXOOMVyoanxrIrX3Wgq8JRZDRA2C3Bf2bLw==
X-Gm-Gg: ASbGnctUt3KyuAz0gSBaYTpHuJIIdUS2pIeLImKU6UG3/QSBKgR33Po2HsPLh6c1WON
	p50K+gBfsuhdFfCN+39kYoNB+PVvFa/SmP3WwoRTUZzR5k3Wo7mfOqC4MsugnWsc7M0O4Lk5lKx
	0Bykcby43/4I4RC4lv6XFgr6b4mGSF4Ws7zE5LsFaq4hfFRyxzRd8evroPI8GjypZsMXWrzA2Qk
	ZE31BUMvu0On/clNb1c5T6ghp9lW8kJfEW/CSMzgVUkFPyjoUNoR0/WpNZBvxUrvsVu2M0AbYHg
	IcuvH+m40qLB1bPstouPg2sDkTAN8kMSIvYmVoX/Wbwq+Jlp3sJ82wjciC9TnU9seklMWsahTH0
	8
X-Google-Smtp-Source: AGHT+IGVQviI3GUKab3s7x7KIHH/QqolYWI5+Clhn+dSVA9v6GWnOzJzvX+IxR3a6HD2AZYZqI8qRD4qZn3a+JLfc0s=
X-Received: by 2002:a05:6214:29c2:b0:722:3a59:fd9c with SMTP id
 6a1803df08f44-767bc9e3085mr69038776d6.23.1757721792895; Fri, 12 Sep 2025
 17:03:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1756139607.git.metze@samba.org> <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
 <CAH2r5msKSbUfOVXUabNQep3s2H4kW0AMnDh0XA68Pk3_oqaHCQ@mail.gmail.com>
 <642872f4-e076-4588-b011-920479b06949@samba.org> <CAKYAXd8fJtjESeMiNmAACw8jGkEU_JWCQd3=9XFf_rdx6TxqUw@mail.gmail.com>
In-Reply-To: <CAKYAXd8fJtjESeMiNmAACw8jGkEU_JWCQd3=9XFf_rdx6TxqUw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 12 Sep 2025 19:03:01 -0500
X-Gm-Features: AS18NWCUhPcdoIClDu4V14I2QLHpssKx13x_q7WjKfy2acnhuMBRLtZrfpa7f2A
Message-ID: <CAH2r5ms8JUL+R8zDVa4L2=ydESUFjvPPLdJxHTeOWPFmwCBHQQ@mail.gmail.com>
Subject: Re: replace for-next-next... Re: [PATCH v4 000/142] smb:
 smbdirect/client/server: make use of common structures
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated cifs-2.6.git for-next with the client patch

On Wed, Sep 10, 2025 at 6:36=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Thu, Sep 11, 2025 at 4:05=E2=80=AFAM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Hi Steve, hi Namjae,
> Hi Metze,
> >
> > I found "ksmbd: smbdirect: validate data_offset and data_length field o=
f smb_direct_data_transfer"
> > https://git.samba.org/?p=3Dksmbd.git;a=3Dcommitdiff;h=3D927f8fe05e334d0=
16c598d2cc965161c2808d9ba
> > in ksmbd-for-next-next.
> >
> > I added a Fixes and Reviewed-by tag
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3Dfa36d=
b4e8d62aa9c3ba1200323d8e01e4eb88b19
> > and two additional patches:
> I will update it with your tags.
> > ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_=
recv_size
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3D9e881=
174900e53dd2b17c0c0933cc4395ceb47a6
> Looks good to me. I will apply it to #ksmbd-for-next-next.
>
> > smb: client: let recv_done verify data_offset, data_length and remainin=
g_data_length
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3D174fa=
eea9ee496b724206d405b74db8b05729f11
> Looks good to me. Reviewed-by: Namjae Jeon <linkinjeon@kernel.org> for
> this client patch.
>
> Thanks!
> >
> > I think these should go into 6.17.
> >
> > As there as conflicts with for-next-next I rebased it again
> > and made sure each commit compiles and the result still passes
> > the tests I made last time.
> >
> > The result can be found under
> > git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-202=
50910-v6
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/he=
ads/for-6.18/fs-smb-20250910-v6
> >
> > Please have a look and replace for-next-next again...
> > The diff against the current for-next-next (e2e99af785ee91ce20c6d583e39=
6660494db77a2)
> > and for-6.18/fs-smb-20250910-v6 (1fb2a52741e836f54a4691cbd74d9d70d736e5=
06) follows below.
> >
> > Thanks!
> > metze
> >
> >   fs/smb/client/smbdirect.c                  | 19 ++++++++++++++++++-
> >   fs/smb/common/smbdirect/smbdirect_socket.h |  2 +-
> >   fs/smb/server/transport_rdma.c             | 25 +++++++++++++++++----=
----
> >   3 files changed, 36 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> > index 322334097e30..6215a6e91c67 100644
> > --- a/fs/smb/client/smbdirect.c
> > +++ b/fs/smb/client/smbdirect.c
> > @@ -548,7 +548,9 @@ static void recv_done(struct ib_cq *cq, struct ib_w=
c *wc)
> >         struct smbdirect_socket *sc =3D response->socket;
> >         struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> >         u16 old_recv_credit_target;
> > -       int data_length =3D 0;
> > +       u32 data_offset =3D 0;
> > +       u32 data_length =3D 0;
> > +       u32 remaining_data_length =3D 0;
> >         bool negotiate_done =3D false;
> >
> >         log_rdma_recv(INFO,
> > @@ -600,7 +602,22 @@ static void recv_done(struct ib_cq *cq, struct ib_=
wc *wc)
> >         /* SMBD data transfer packet */
> >         case SMBDIRECT_EXPECT_DATA_TRANSFER:
> >                 data_transfer =3D smbdirect_recv_io_payload(response);
> > +
> > +               if (wc->byte_len <
> > +                   offsetof(struct smbdirect_data_transfer, padding))
> > +                       goto error;
> > +
> > +               remaining_data_length =3D le32_to_cpu(data_transfer->re=
maining_data_length);
> > +               data_offset =3D le32_to_cpu(data_transfer->data_offset)=
;
> >                 data_length =3D le32_to_cpu(data_transfer->data_length)=
;
> > +               if (wc->byte_len < data_offset ||
> > +                   wc->byte_len < (u64)data_offset + data_length)
> > +                       goto error;
> > +
> > +               if (remaining_data_length > sp->max_fragmented_recv_siz=
e ||
> > +                   data_length > sp->max_fragmented_recv_size ||
> > +                   (u64)remaining_data_length + (u64)data_length > (u6=
4)sp->max_fragmented_recv_size)
> > +                       goto error;
> >
> >                 if (data_length) {
> >                         if (sc->recv_io.reassembly.full_packet_received=
)
> > diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common=
/smbdirect/smbdirect_socket.h
> > index 8542de12002a..91eb02fb1600 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> > +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> > @@ -63,7 +63,7 @@ const char *smbdirect_socket_status_string(enum smbdi=
rect_socket_status status)
> >         case SMBDIRECT_SOCKET_DISCONNECTING:
> >                 return "DISCONNECTING";
> >         case SMBDIRECT_SOCKET_DISCONNECTED:
> > -               return "DISCONNECTED,";
> > +               return "DISCONNECTED";
> >         case SMBDIRECT_SOCKET_DESTROYED:
> >                 return "DESTROYED";
> >         }
> > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_r=
dma.c
> > index 33d2f5bdb827..e371d8f4c80b 100644
> > --- a/fs/smb/server/transport_rdma.c
> > +++ b/fs/smb/server/transport_rdma.c
> > @@ -538,7 +538,7 @@ static void recv_done(struct ib_cq *cq, struct ib_w=
c *wc)
> >         case SMBDIRECT_EXPECT_DATA_TRANSFER: {
> >                 struct smbdirect_data_transfer *data_transfer =3D
> >                         (struct smbdirect_data_transfer *)recvmsg->pack=
et;
> > -               unsigned int data_length;
> > +               u32 remaining_data_length, data_offset, data_length;
> >                 u16 old_recv_credit_target;
> >
> >                 if (wc->byte_len <
> > @@ -548,15 +548,24 @@ static void recv_done(struct ib_cq *cq, struct ib=
_wc *wc)
> >                         return;
> >                 }
> >
> > +               remaining_data_length =3D le32_to_cpu(data_transfer->re=
maining_data_length);
> >                 data_length =3D le32_to_cpu(data_transfer->data_length)=
;
> > -               if (data_length) {
> > -                       if (wc->byte_len < sizeof(struct smbdirect_data=
_transfer) +
> > -                           (u64)data_length) {
> > -                               put_recvmsg(sc, recvmsg);
> > -                               smb_direct_disconnect_rdma_connection(s=
c);
> > -                               return;
> > -                       }
> > +               data_offset =3D le32_to_cpu(data_transfer->data_offset)=
;
> > +               if (wc->byte_len < data_offset ||
> > +                   wc->byte_len < (u64)data_offset + data_length) {
> > +                       put_recvmsg(sc, recvmsg);
> > +                       smb_direct_disconnect_rdma_connection(sc);
> > +                       return;
> > +               }
> > +               if (remaining_data_length > sp->max_fragmented_recv_siz=
e ||
> > +                   data_length > sp->max_fragmented_recv_size ||
> > +                   (u64)remaining_data_length + (u64)data_length > (u6=
4)sp->max_fragmented_recv_size) {
> > +                       put_recvmsg(sc, recvmsg);
> > +                       smb_direct_disconnect_rdma_connection(sc);
> > +                       return;
> > +               }
> >
> > +               if (data_length) {
> >                         if (sc->recv_io.reassembly.full_packet_received=
)
> >                                 recvmsg->first_segment =3D true;
> >
> >
> >
> >



--=20
Thanks,

Steve
