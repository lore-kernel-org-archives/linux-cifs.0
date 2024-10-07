Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522E3C2F;
	Mon,  7 Oct 2024 04:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728274281; cv=none; b=j0wn1wVeVSl17bBTW3RwC+e5pfPGC9PDQ0siUNjdsA6NIfcVrFPmTagXBNrgEqKqUWfVJvvYGPrdEFhkJztnYUDdtEZGKNW3uG9zU3tEZLEXl//Gyn60xmDGNv8RmGLEwZkl3H8RxAjSarz/jpLx4aWX/z463w2hx2agikKiF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728274281; c=relaxed/simple;
	bh=Rb+NMvTY5S/RhDbReczXEbZXZgp9atdbuN4jT0ffcgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nT9vsnVAhwSMQt06QvTi1qVwGGC6c3LMcVfhAKTRaMNf+5kAfvRVn8xUhNs+3AdJVsY/NqQzyM3bQXJe2bKoUvGxrW1zHjDxrQrg8+x/89hvlMapIbCj4/lffL6ayNmtz8rLHR+z5XWy73MRguTBV7x1EZbWt3xdfqHU5Rf+iVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c21jGEas; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c21jGEas"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53993c115cfso4929062e87.2;
        Sun, 06 Oct 2024 21:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728274278; x=1728879078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOgArWBJC8EePXX6ZD6ccL3/wpe9oAMr2gqSbvNQi/8=;
        b=c21jGEasHjBB31ABlPRvmQr+6iXmtAa33Mb1vLcQuUeN1PDwejRgAEw7zN79PXr0Y5
         A3IW8BPIiTIhPSyd5wJ7X9rEYsagXCmzbxmMt9MG2Ti0PlUOw1kRjPajQD/c614KEvm2
         vNpecVXuM4PUX9+RIcFs7kqL9g6frCE03V0wNPIhB0BKtsrdKM2sjbh1DNU6MljyWOup
         GzKD7W0ygmDVxMiBfyt6GkjIwjzX1Cq6Gx5w5W4Ocf1/yZUoF/VvWPS/iCcccfzA2ceR
         GWsNLqEz6KUIKulUH4CdhmitUSFaV5yZUQYN3wXmgkNxXQq2gTZBv050xM4qz/y9hoWC
         LcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728274278; x=1728879078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOgArWBJC8EePXX6ZD6ccL3/wpe9oAMr2gqSbvNQi/8=;
        b=vRBwthtSJ2FMaa+dIWieTPh32RHGsHWgfL+PMA+8URi0/cuPkkiDNCNAg44sjkuK6w
         /MZ8WQThQtC9RVizDgLBSG/B0NbO1bDNiOQuTkxWKjS7koogYwrqpJ13izqqHC8NVadF
         S8eoEqrht95eoOskJrJ71GggbSieqdB18J3wQEwHfyQr3WH8G/OC3STSa8hJi22pvmi7
         7QRv/2+A8yPvOTZSqBHF54lZxJiEiZOkMVGJAFHY5LUDUAl8S+ukzRhQMjFsEn89wiWj
         tO5z/iD6GWWx39peDJ9U3iaIPf5ttIE9BDwRjBUMqkkZmZkuEigCbWCcg6mE2jTVwaS4
         T/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBU3ByIeK8yFFF72qoG52DqOZ2VYD03ECgQW8nX6pv93Am9RQlvz2PZ1tFR9Cu4yWou+DXt26X7rAf@vger.kernel.org, AJvYcCVWN9aTHqIimkX3IFOJ7SXHaQlQyXrK3UotvOy0HsPeBEm0dE2b1amLdjXvTFVEitx/hFi4BnmVjmS572Y0@vger.kernel.org
X-Gm-Message-State: AOJu0YxyzqyWyiXSRtxo8YTEeQ2EZPehVbJGjZgOFrrekKicdOT3k4C9
	Ur6O9fc/3EyWxId1fyYFw79GVe4KVt3iFa4oIKZmq/R2Mm8YvNKrHNCagBTuolXEDX+Ud6dJRX/
	frC7RUyLTvJ5mnyjJCooiF0t+y0A=
X-Google-Smtp-Source: AGHT+IFZ5wRH6KQjFJkULO+H6xtDDe0Y4MoVBbNHr537uuoluDWd91eMT9lO+88/pRE7voBqHVE5Wp+6sajcy6L/R10=
X-Received: by 2002:a05:6512:104b:b0:535:3c94:70c2 with SMTP id
 2adb3069b0e04-539ab87710amr4641895e87.19.1728274277641; Sun, 06 Oct 2024
 21:11:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007004855.150168-1-linux@treblig.org>
In-Reply-To: <20241007004855.150168-1-linux@treblig.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 6 Oct 2024 23:11:06 -0500
Message-ID: <CAH2r5mvHnBnoS+hcyFiqNO8Z9rvzy6x=segDEvgP_hCyXfcAPg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove unused functions
To: linux@treblig.org
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and any
additional reviews

On Sun, Oct 6, 2024 at 7:49=E2=80=AFPM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> cifs_ses_find_chan() has been unused since commit
> f486ef8e2003 ("cifs: use the chans_need_reconnect bitmap for reconnect st=
atus")
>
> cifs_read_page_from_socket() has been unused since commit
> d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than =
a page list")
>
> cifs_chan_in_reconnect() has been unused since commit
> bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
>
> Remove them.
>
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  fs/smb/client/cifsproto.h |  9 ---------
>  fs/smb/client/connect.c   | 12 ------------
>  fs/smb/client/sess.c      | 32 --------------------------------
>  3 files changed, 53 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 68c716e6261b..1d3470bca45e 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -252,10 +252,6 @@ extern int cifs_read_from_socket(struct TCP_Server_I=
nfo *server, char *buf,
>                                  unsigned int to_read);
>  extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
>                                         size_t to_read);
> -extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
> -                                       struct page *page,
> -                                       unsigned int page_offset,
> -                                       unsigned int to_read);
>  int cifs_read_iter_from_socket(struct TCP_Server_Info *server,
>                                struct iov_iter *iter,
>                                unsigned int to_read);
> @@ -623,8 +619,6 @@ enum securityEnum cifs_select_sectype(struct TCP_Serv=
er_Info *,
>  int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
>  void cifs_free_hash(struct shash_desc **sdesc);
>
> -struct cifs_chan *
> -cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server)=
;
>  int cifs_try_adding_channels(struct cifs_ses *ses);
>  bool is_server_using_iface(struct TCP_Server_Info *server,
>                            struct cifs_server_iface *iface);
> @@ -640,9 +634,6 @@ cifs_chan_set_in_reconnect(struct cifs_ses *ses,
>  void
>  cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
>                                struct TCP_Server_Info *server);
> -bool
> -cifs_chan_in_reconnect(struct cifs_ses *ses,
> -                         struct TCP_Server_Info *server);
>  void
>  cifs_chan_set_need_reconnect(struct cifs_ses *ses,
>                              struct TCP_Server_Info *server);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index adf8758847f6..15d94ac4095e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -794,18 +794,6 @@ cifs_discard_from_socket(struct TCP_Server_Info *ser=
ver, size_t to_read)
>         return cifs_readv_from_socket(server, &smb_msg);
>  }
>
> -int
> -cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *=
page,
> -       unsigned int page_offset, unsigned int to_read)
> -{
> -       struct msghdr smb_msg =3D {};
> -       struct bio_vec bv;
> -
> -       bvec_set_page(&bv, page, to_read, page_offset);
> -       iov_iter_bvec(&smb_msg.msg_iter, ITER_DEST, &bv, 1, to_read);
> -       return cifs_readv_from_socket(server, &smb_msg);
> -}
> -
>  int
>  cifs_read_iter_from_socket(struct TCP_Server_Info *server, struct iov_it=
er *iter,
>                            unsigned int to_read)
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 3216f786908f..c88e9657f47a 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -115,18 +115,6 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
>         ses->chans[chan_index].in_reconnect =3D false;
>  }
>
> -bool
> -cifs_chan_in_reconnect(struct cifs_ses *ses,
> -                         struct TCP_Server_Info *server)
> -{
> -       unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> -
> -       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> -               return true;    /* err on the safer side */
> -
> -       return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
> -}
> -
>  void
>  cifs_chan_set_need_reconnect(struct cifs_ses *ses,
>                              struct TCP_Server_Info *server)
> @@ -487,26 +475,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct =
TCP_Server_Info *server)
>         spin_unlock(&ses->chan_lock);
>  }
>
> -/*
> - * If server is a channel of ses, return the corresponding enclosing
> - * cifs_chan otherwise return NULL.
> - */
> -struct cifs_chan *
> -cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server)
> -{
> -       int i;
> -
> -       spin_lock(&ses->chan_lock);
> -       for (i =3D 0; i < ses->chan_count; i++) {
> -               if (ses->chans[i].server =3D=3D server) {
> -                       spin_unlock(&ses->chan_lock);
> -                       return &ses->chans[i];
> -               }
> -       }
> -       spin_unlock(&ses->chan_lock);
> -       return NULL;
> -}
> -
>  static int
>  cifs_ses_add_channel(struct cifs_ses *ses,
>                      struct cifs_server_iface *iface)
> --
> 2.46.2
>
>


--=20
Thanks,

Steve
