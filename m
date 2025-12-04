Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702761EFFB4
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764888434; cv=none; b=LO+7kYvztPSVHnc+evrIYNjnZXBZFtTd2rHReSzMnpO4pF27zf4NeNsH2Mk3lbcdt7c2+vhdO9sy4Xw2uGn7e5qZaqP5qtsgtjV3BBvBLq+vArV7J2KfbmaPWczZhHuIKhftSQ0IqWVyszGFJiWWpiy0o8iGEAVomJBtkqAlDBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764888434; c=relaxed/simple;
	bh=mro/VmCVuATm6nr3ZFu0eWUdWX/ANxY6kh45KikufXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z4IK/TY1agwP7e5DHm162uImkdRhEULrzlJgbFmLYaPeBgyMQjF/k4eX1gvP8eJkrA8WI09/v4jYZaVO6kLG49YdxcdmQ0Y9fq5AmDEIiGx+VXFG0+OmafGykyPUiCKQ575Sn3bD05rvjeQm4TAp+PY7Su5cPqI/qqqw/Z+SyvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AkZpfzyS; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkZpfzyS"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee0084fd98so13136821cf.3
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 14:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764888431; x=1765493231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRs0VA7JgvYUTS/tdqCTWEdlNAGOofjXdHT/cmKOZ2c=;
        b=AkZpfzySWbWK9lqjUctzbUjbRbIvi5E3Ts4MRoFu6ZXmkNIbsWNqRve8RQD0hkD8mr
         tUcQEg7rX9iDGoKSS8HgyzAIVOEzJqdFjrALULxi9+wl7kFUWnrj+jRCs3lVOme7BsLL
         1No3A+6FfZ6HFbXMqr2GczXOO4ehv5Ze49AhaYGi9yXsAW82/xhaxEGID5tXOUcSn5Sd
         aAUC0D1UCheyoRyjiDCKJ4ENTufPXbnXSptDuVoWoXp/Qao4jwMJh4FxgtG6WrGtI0RU
         rWpt6n0pSQ/Dej6OXqO+SL1BxKORDnVjNK2QOWQeGGLqlAW/mxa6sG6lYrA5UKOhJ2/1
         sG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764888431; x=1765493231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lRs0VA7JgvYUTS/tdqCTWEdlNAGOofjXdHT/cmKOZ2c=;
        b=WhSbM9v+NaUMMGvnnwrx0z/625xWY5pPkacS7MTdwVu+0MBWJbwodEoHu1NBzlQ7YV
         Cn0ENm7IHMHOb4N81vJSujfOzhOrE6g3PDpBqk47WWCJ4D+mGMgphNhXUL8hwK1nXeWG
         n7aoVg1POpvURyiy9S5qC89D3JIf7EbzhWzYPdZTCMzHH+NdjIVyYCBz4RnDvkxoLxEc
         7K7+pJdQwn7aEbHCXrvg0tya8dPiSGuBUizxoHVZWu6o+EYHzi+38cbk/O+L118AhWCV
         YhXspkCOhTwhtC3T3LRTkGZnQAnaDbMdPpidxirJ0HvDBhQJ/3+3lLUZZPfa70No8ELc
         UIAw==
X-Forwarded-Encrypted: i=1; AJvYcCU7FkAzLWYpl8D1HbLruLI6lvkaPNj+3x72qkK2v+BmYfXu64WGhE9wTHu+uS+83d/h2QUq8yNXHLVZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9VBfIxJBrWHBjllqYrzDdbZ2UCoVRAFul4MinLdioMXx6wlv8
	bOc/vzd8RvFnHnZnOy8dyBtnPq1l8fSRJVfRUYQ/sg+qiv2tZlghqn5+y+KhPy5U/xI+cr233mh
	Z9jEZ6vEA8SiDpPkZSS1b2s/QMhba3/g=
X-Gm-Gg: ASbGncuFzh7Ik6ZsTH+TWVf+90EWbFLLlDnkvChUWIEF4iYg6aUJncGayaeWwhLeicG
	ITZSdNwi5YAQaD76GTWl7/tgvOQV45EZU1jpNtevWdmDy1xQd0DvOvgdTAd+yXEPjtIayNkYLwI
	FkLHM5ZFUTxu3cFjV7cKoWRrFpdg26EhaQkKS8FiUrKxEVm+kkIR0jq4fo3tr40gdSU+3hOldAf
	nZVftGAyIvQ/VtMrjKGaXeQwsVgAT2A1Uh7dVDE43ftqRY2VoEfZBw0lmJ5WUDpi037LugW2YRN
	qLrxbiItr2bd1pufz7xeUwLTtnirKFbUFpIvTwSyNaAyfp972rkqvE2UW9qDhu4DaHckwDnCZVY
	l2vH4ug+D9vf9iQ2Y+26/3pk6meLZTyouwsM4wYCTHdhw/FbeCBNdlAsuJS1n7vjRWlAfKcIHxT
	zRVUdUubNnog==
X-Google-Smtp-Source: AGHT+IHs6JFA/++3tLgPCmvYvS4MpYUEXQhcE7YPCHn9tvw4axwMlZKEIdz8UwgxVclHUK1sb/kiSTP7PEZg2y/Gdlo=
X-Received: by 2002:a05:622a:314:b0:4e8:b2df:fe1f with SMTP id
 d75a77b69052e-4f017576c94mr101732601cf.28.1764888431108; Thu, 04 Dec 2025
 14:47:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204213914.546291-1-pc@manguebit.org>
In-Reply-To: <20251204213914.546291-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Dec 2025 16:46:58 -0600
X-Gm-Features: AQt7F2of2m3eXyWH0f7RDgw79wDgX4zFyT6nW7m5MKOmX6VfkVSZi4qmalMDYrg
Message-ID: <CAH2r5mvyXwctLKvjov2ioEUoVk6LymfsS3hxPHkSrB0ENqueBQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: Add tracepoint for krb5 auth
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Pierguido Lambri <plambri@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively applied to cifs-2.6.git for-next pending testing and
additional review

On Thu, Dec 4, 2025 at 3:39=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Add tracepoint to help debugging krb5 auth failures.
>
> Example:
>
> $ trace-cmd record -e smb3_kerberos_auth
> $ mount.cifs ...
> $ trace-cmd report
> mount.cifs-1667 [003] .....  5810.668549: smb3_kerberos_auth: vers=3D2
> host=3Dw22-dc1.zelda.test ip=3D192.168.124.30:445 sec=3Dkrb5 uid=3D0 crui=
d=3D0
> user=3Droot pid=3D1667 upcall_target=3Dapp err=3D-126
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Pierguido Lambri <plambri@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
> v1 -> v2: simplify trace function
>
>  fs/smb/client/cifs_spnego.c |  1 +
>  fs/smb/client/smb2pdu.c     |  2 --
>  fs/smb/client/trace.c       |  1 +
>  fs/smb/client/trace.h       | 43 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
> index da935bd1ce87..3a41bbada04c 100644
> --- a/fs/smb/client/cifs_spnego.c
> +++ b/fs/smb/client/cifs_spnego.c
> @@ -159,6 +159,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         cifs_dbg(FYI, "key description =3D %s\n", description);
>         scoped_with_creds(spnego_cred)
>                 spnego_key =3D request_key(&cifs_spnego_key_type, descrip=
tion, "");
> +       trace_smb3_kerberos_auth(server, sesInfo, PTR_ERR_OR_ZERO(spnego_=
key));
>
>  #ifdef CONFIG_CIFS_DEBUG2
>         if (cifsFYI && !IS_ERR(spnego_key)) {
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 0d2940808be6..599cdc6db46c 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -1691,8 +1691,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data=
)
>         spnego_key =3D cifs_get_spnego_key(ses, server);
>         if (IS_ERR(spnego_key)) {
>                 rc =3D PTR_ERR(spnego_key);
> -               if (rc =3D=3D -ENOKEY)
> -                       cifs_dbg(VFS, "Verify user has a krb5 ticket and =
keyutils is installed\n");
>                 spnego_key =3D NULL;
>                 goto out;
>         }
> diff --git a/fs/smb/client/trace.c b/fs/smb/client/trace.c
> index 16b0e719731f..8a99b68d0c71 100644
> --- a/fs/smb/client/trace.c
> +++ b/fs/smb/client/trace.c
> @@ -5,5 +5,6 @@
>   *   Author(s): Steve French <stfrench@microsoft.com>
>   */
>  #include "cifsglob.h"
> +#include "cifs_spnego.h"
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 252073352e79..b0fbc2df642e 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -1692,6 +1692,49 @@ DEFINE_SMB3_CREDIT_EVENT(waitff_credits);
>  DEFINE_SMB3_CREDIT_EVENT(overflow_credits);
>  DEFINE_SMB3_CREDIT_EVENT(set_credits);
>
> +TRACE_EVENT(smb3_kerberos_auth,
> +               TP_PROTO(struct TCP_Server_Info *server,
> +                        struct cifs_ses *ses,
> +                        int rc),
> +               TP_ARGS(server, ses, rc),
> +               TP_STRUCT__entry(
> +                       __field(pid_t, pid)
> +                       __field(uid_t, uid)
> +                       __field(uid_t, cruid)
> +                       __string(host, server->hostname)
> +                       __string(user, ses->user_name)
> +                       __array(__u8, addr, sizeof(struct sockaddr_storag=
e))
> +                       __array(char, sec, sizeof("ntlmsspi"))
> +                       __array(char, upcall_target, sizeof("mount"))
> +                       __field(int, rc)
> +               ),
> +               TP_fast_assign(
> +                       __entry->pid =3D current->pid;
> +                       __entry->uid =3D from_kuid_munged(&init_user_ns, =
ses->linux_uid);
> +                       __entry->cruid =3D from_kuid_munged(&init_user_ns=
, ses->cred_uid);
> +                       __assign_str(host);
> +                       __assign_str(user);
> +                       memcpy(__entry->addr, &server->dstaddr, sizeof(__=
entry->addr));
> +
> +                       if (server->sec_kerberos)
> +                               memcpy(__entry->sec, "krb5", sizeof("krb5=
"));
> +                       else if (server->sec_mskerberos)
> +                               memcpy(__entry->sec, "mskrb5", sizeof("ms=
krb5"));
> +                       else if (server->sec_iakerb)
> +                               memcpy(__entry->sec, "iakerb", sizeof("ia=
kerb"));
> +                       else
> +                               memcpy(__entry->sec, "krb5", sizeof("krb5=
"));
> +
> +                       if (ses->upcall_target =3D=3D UPTARGET_MOUNT)
> +                               memcpy(__entry->upcall_target, "mount", s=
izeof("mount"));
> +                       else
> +                               memcpy(__entry->upcall_target, "app", siz=
eof("app"));
> +                       __entry->rc =3D rc;
> +               ),
> +               TP_printk("vers=3D%d host=3D%s ip=3D%pISpsfc sec=3D%s uid=
=3D%d cruid=3D%d user=3D%s pid=3D%d upcall_target=3D%s err=3D%d",
> +                         CIFS_SPNEGO_UPCALL_VERSION, __get_str(host), __=
entry->addr,
> +                         __entry->sec, __entry->uid, __entry->cruid, __g=
et_str(user),
> +                         __entry->pid, __entry->upcall_target, __entry->=
rc))
>
>  TRACE_EVENT(smb3_tcon_ref,
>             TP_PROTO(unsigned int tcon_debug_id, int ref,
> --
> 2.52.0
>


--=20
Thanks,

Steve
