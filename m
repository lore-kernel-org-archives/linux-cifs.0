Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BDA1411DE
	for <linux-cifs@vger.kernel.org>; Thu,  2 Oct 2025 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375194; cv=none; b=FN/uas22egC51jgemDuzT9LFOL2cCIw4pxus0PjJqYX7F6j/9cOm5lzvI7oyV50tqXoj4JxFi/DFEs2CMZvQl13ZSxvxWSFC8PyEMhPnuhzO7RAsc84CWsGTLVLhrXkFjmIihlTQE+fI9/O58a+FwHPga9zr+Y6joTwdgy+Xpp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375194; c=relaxed/simple;
	bh=c2Wmjzq0mnVNk307dy7OY3lHMzfLGJE60heLsNXKXpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jDaxZp8+QrAqnJJD6WXThsie6V1iGZDEJl3lMf4QJthMbHDBR0FmMhW3BIwMexfR+1UFtFrS58tsVd8PfVCKZCCQcuhfHqvfXggkcheHEgCZ4FQcdEeLS2lnz9PxtVz0AGucGn0tGLmPgpgp8S6rkT5W4Yw41VeePyhXUDlHIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RC2t2gyh; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RC2t2gyh"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-87499a3cd37so4961606d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 01 Oct 2025 20:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759375190; x=1759979990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OglOXsuEiF7i6+vYy+41fucRP7/Kh76ZuAKRSo8eIQw=;
        b=RC2t2gyhjNJ5o3zuLEZLPIsfaJGUyX+nBn6qpI0Bf7SweaCeVjjHk0LoeosQ9NCkue
         DwaYEOLQuizlWEuC5/SE7JgyEAIwRKDvtf/WMS4P9o72if+EaMfpSTj3qO0/MyjVzxUL
         wg9eFydk4yMuZL6f9UESgR13HcsWOcFQiCv95E6DTaP1vp7BkJR/pqZIaaMJjm/5WEH1
         Mn9weTTTYHeobQZt3wQNSvHd2iKhOGDyE2Dym8i1b31Kx5lFh1ammGapoMsu71hNMQWe
         atRUHbL6Lc01mLkoH5GyymQFAEf9SYL964SuMKriglOyNb99z6r/C0Gd+4PD+C3NarIu
         brAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375190; x=1759979990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OglOXsuEiF7i6+vYy+41fucRP7/Kh76ZuAKRSo8eIQw=;
        b=EqhPO53YR9w1R0hrtxKuOws9c9of6J/GrQhte6OfDzj2NbcliFxYvaBdVdKe2pd5hw
         puvt8ksjAiyCv/MOoy/vEiQbstoUmzSQFTdS69vqJs7IqTB+nOVFpraG8JFZxcNwm2Je
         7XCTe7jclB0/wnGYujSeWxgg1mbv3Q+vxWoFr3fmWl8TWDwXZclHawQ2lMweblbQwk+Z
         rH0nrt16d9bih7BYHmHVbMRvxEFKjgwh/kxSRI/hpn+Lg5kJEmue7Shi1As90NH1cjiM
         TAW8GvXk9pHDkaolv05QvjDWIVXJOnWVz1cyi2GwoZPH3Iz7kFz1jYasH/yTv36BJMqJ
         suEw==
X-Forwarded-Encrypted: i=1; AJvYcCX7dcUIdVRmzcTkAcyhyqRmNRISLEqFqG2IuqIs/tyxk+lkD1MGf6Zqv1nJb3qwJKdUEduiCNy2iz43@vger.kernel.org
X-Gm-Message-State: AOJu0YyljDz0cgQuEXcduik3S111x3U8UCLalDavUxH8yOTNCSPS3s2g
	ljrl+aOu1uMm8C92CHIs1wTCIqZ5Y1cy0UAnTlM7+5WewLm1Wk45I7hzxZ/ONKg66ZTO34mtvda
	dc+kt+CBLC3Gy839G4PjObpi9A2lewGI=
X-Gm-Gg: ASbGncv8UAOjy5sD0cwRMRhrH1fxbnE2aVmFBqrWvfZV1u/nUZ7p+kZJkE2tEnpBnPP
	zpy4eHQGN6rCcFbVGKXfhRRVz1+u+KdByu6zdbgDLMpBJEGETZRUpoB5WKCxdjCxIiKlCB2uHHB
	O2VfusWA6LOFyzH9HWTK2/Mn3TJOCmfk+XNcmBLiLjxgx9juqoLwyxRLUCdV/7EK17tgregRlE9
	L5gRjpwOKVWCY5MlrJmHMQPZX9iEJ9BSn1kMmUM2uHqw8WJE0R+tg5+gZp2/E/AzhWap+yAz8ml
	nwCl8QLTFZCPRS9UJnvTd+5UOvE7P2f6HIkva8oqWuvmA3D1u6BDLPTYN482JJb5q2oIaU1ewHF
	476CauPUQcg==
X-Google-Smtp-Source: AGHT+IH57Fk72s9H3LGBTK+2pXoFM5w1cHiCSNe9fpORipn06qi265yhxApLm6Bna2MZLP55cAugDROOr1PS64rQS9A=
X-Received: by 2002:a05:6214:528f:b0:78f:493d:15c6 with SMTP id
 6a1803df08f44-8739be1dec0mr69139036d6.3.1759375190477; Wed, 01 Oct 2025
 20:19:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915151950.1017597-1-f.ebner@proxmox.com> <20250915151950.1017597-2-f.ebner@proxmox.com>
In-Reply-To: <20250915151950.1017597-2-f.ebner@proxmox.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Oct 2025 22:19:39 -0500
X-Gm-Features: AS18NWDPGaX3z3mO1YUySJ5IK4Ie9SMZF7A_a6-KW3yYqMPpeYqFnxmRZrWKqrs
Message-ID: <CAH2r5mu_6WYwBioQ-6iS8Z+oVYBJA0nmhkkGQoqroWXjdrBVCA@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: transport: avoid reconnects triggered by
 pending task work
To: Fiona Ebner <f.ebner@proxmox.com>
Cc: linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, tom@talpey.com, 
	sprasad@microsoft.com, ronniesahlberg@gmail.com, pc@manguebit.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have tentatively merged these two into cifs-2.6.git for-next pending
testing, but additional review/testing would be helpful.


On Mon, Sep 15, 2025 at 10:23=E2=80=AFAM Fiona Ebner <f.ebner@proxmox.com> =
wrote:
>
> When io_uring is used in the same task as CIFS, there might be
> unnecessary reconnects, causing issues in user-space applications
> like QEMU with a log like:
>
> > CIFS: VFS: \\10.10.100.81 Error -512 sending data on socket to server
>
> Certain io_uring completions might be added to task_work with
> notify_method being TWA_SIGNAL and thus TIF_NOTIFY_SIGNAL is set for
> the task.
>
> In __smb_send_rqst(), signals are masked before calling
> smb_send_kvec(), but the masking does not apply to TIF_NOTIFY_SIGNAL.
>
> If sk_stream_wait_memory() is reached via sock_sendmsg() while
> TIF_NOTIFY_SIGNAL is set, signal_pending(current) will evaluate to
> true there, and -EINTR will be propagated all the way from
> sk_stream_wait_memory() to sock_sendmsg() in smb_send_kvec().
> Afterwards, __smb_send_rqst() will see that not everything was written
> and reconnect.
>
> Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
> ---
>  fs/smb/client/transport.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index a61ba7f3fb86..940e90107134 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -22,6 +22,7 @@
>  #include <linux/mempool.h>
>  #include <linux/sched/signal.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include <linux/task_work.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -173,9 +174,16 @@ smb_send_kvec(struct TCP_Server_Info *server, struct=
 msghdr *smb_msg,
>                  * send a packet.  In most cases if we fail to send
>                  * after the retries we will kill the socket and
>                  * reconnect which may clear the network problem.
> +                *
> +                * Even if regular signals are masked, EINTR might be
> +                * propagated from sk_stream_wait_memory() to here when
> +                * TIF_NOTIFY_SIGNAL is used for task work. For example,
> +                * certain io_uring completions will use that. Treat
> +                * having EINTR with pending task work the same as EAGAIN
> +                * to avoid unnecessary reconnects.
>                  */
>                 rc =3D sock_sendmsg(ssocket, smb_msg);
> -               if (rc =3D=3D -EAGAIN) {
> +               if (rc =3D=3D -EAGAIN || unlikely(rc =3D=3D -EINTR && tas=
k_work_pending(current))) {
>                         retries++;
>                         if (retries >=3D 14 ||
>                             (!server->noblocksnd && (retries > 2))) {
> --
> 2.47.2
>
>
>


--=20
Thanks,

Steve
