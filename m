Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97B238D39
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741692089; cv=none; b=qi3rjwl8xj740eZpKFl3fNlmh8mJI9p1igDiaSXZdjkpJQFglJ3hMdzW6bqhofSgXHImuCItcoiUdyTTix8gUja3eJNrBE3eRXZitNmJIAzatnonDy6RFp1gDJobtDfH57M1MszPe/dM5gCu/cYWifOqU3RFJNOOFI1QOlxDL48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741692089; c=relaxed/simple;
	bh=a3u0RqiXDQGsu2bJ0+xuR4y0Vjcb5LGG49kvytpquvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1tMD8NHA1XvIDb7lOL/WWPnAoKtIiDqwtbFlnQ9tgs/KygIJo0PyH0bT/WNlfjYG/NVHR3Q5r/T8VvmiC8GZRqXR+G3wUKFgkA9T5FFjMJJ9K/ALse3v11u2vVjGXPUhJBnljP+aCaO0jFGziFgXm6PmoZu+zZnWc6L3VYnU/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZFV2Gct; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZFV2Gct"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6f6ae4846c7so49685727b3.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741692086; x=1742296886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGfF2oChBNlWgudPq4MvCbSKf9hsaaXh+51nW7aQvZ0=;
        b=PZFV2GctmAQXoRKfwzi/8CwZaqwKwOR7G1QwvQaOn6deNsyvS10UJkiXx90IRa070E
         R8+B1Rc1NVXJQBK22KY1gLfmBl73kI7TLhqaz01XQwSuM/jFcv5TIt2cbKoRZkcs97AS
         eZhnL8ijInnzJXHgFVRc9e+JOA48lhc2bCeSweJFNOf8JAWPBKYsXXkKQ1ndNiZ2yVi3
         n49xXl/UdxKRlVNe6jIGELF+oGA5O86KIVNR8qBV65rKhAve8gayeHXj+N2arIDO/zPu
         w3zIcSyk/DJqRwiaW2afuiYP/hQP0V05aLDWMLsoth0WT7R3oz0InMUvDIJS2rvY0SHA
         P5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741692086; x=1742296886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hGfF2oChBNlWgudPq4MvCbSKf9hsaaXh+51nW7aQvZ0=;
        b=HCW3EcMYGdJyfxDgafFQKOUlq50P2eT4hpXKMTTGCcMmsRsdA7DhOCxw4D4Gi85mWX
         ctKnJapJPXyVzdGf5MQ+voxotchj49qhTOL3AigebL9aDv5yX1P5CeBG9/JJ13lE05Sc
         sF9C+3RG0O1iSN53v/zjUzVlVprj42Hsz42X9qsmcXKFFf5oan0IHHBnGCnhPCeddgRF
         +8S8JZDFy4nQrjudd6gJFWfpH0BkZGqEAQEny+uJ88EcCP2QhsisiNQbgXak8pdjfLfe
         gePC822daG3GGX2Dk6kIXrF88wUHK8AtDi5SSV3+Z48zfjYKptgYL8KRF8xLffazmRQB
         fJRA==
X-Gm-Message-State: AOJu0YzsHIIZPYq3sIMgzlP1Q0MnowtwrHcSJHIjKKi2+QQuc5FztUVh
	+Kc/t9jpBEsg5sYXMIzxPcLX1rw89/F6mmVzITPjpNtdM4EW8eHCZuSV5g8Z/QcKF6w0lW0niXD
	3z7HDWUlf/L/yCpJAOJ9ygYPN8XY=
X-Gm-Gg: ASbGncvoYChnVj5mPrdjkomkp4EQyhORufCI3kZo0aXZpKjm0ZL1QR/Ne4sw8NNBLB4
	0+6Im5pWxmYT92zzmU4M+XoYHsg52nPIbQDSZh1yz40n+oZZMtkUtgxoEZPjZjWdKUPnDOKABl7
	1IIEEEPWUl1f0IXh8JB22Bqn7RCbMSdZ7BC68=
X-Google-Smtp-Source: AGHT+IFiorq9JhyMa0piYWoHmihkbQBENGWJzebVlH7LRRAp4OgF5QzBuYYJEXLQq3uGxojbDJ4HFkUSXzrxkRnXU/k=
X-Received: by 2002:a05:690c:6e01:b0:6fd:47aa:c6ba with SMTP id
 00721157ae682-6ff091f7da5mr45237837b3.19.1741692086460; Tue, 11 Mar 2025
 04:21:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214124306.498808-1-aman1cifs@gmail.com> <20250306174642.584848-2-aman1cifs@gmail.com>
 <CAH2r5mtrsqR+93ZvcWM3eyd2WrmY9DyRCUCWf=Sr97S3pus8SA@mail.gmail.com>
In-Reply-To: <CAH2r5mtrsqR+93ZvcWM3eyd2WrmY9DyRCUCWf=Sr97S3pus8SA@mail.gmail.com>
From: aman <aman1cifs@gmail.com>
Date: Tue, 11 Mar 2025 16:51:15 +0530
X-Gm-Features: AQ5f1JrnzCP1lVLF1uwB6ruELiAfaJxIXRFljQ0VMxkBHdnPfJOOfum6RWFyNYc
Message-ID: <CAJr1uc-3Yj66kqCjR9tDA-_1f=KEEPBeuFArpUZyH6MU6N+c7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] CIFS: Propagate min offload along with other
 parameters from primary to secondary channels.
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com, 
	bharathsm@microsoft.com, psachdeva@microsoft.com, Aman <aman1@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

`srv_sign_required` and `mnt_sign_required` when true, override the
sign value for each session. If the srv_sign_required or
mnt_sign_required are not true, then the sign value will not be copied
from the primary to secondary without our fix.

The logic can be found in fs/smb/client/connect.c:
```
int
cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
{
bool srv_sign_required =3D server->sec_mode & server->vals->signing_require=
d;
bool srv_sign_enabled =3D server->sec_mode & server->vals->signing_enabled;
bool mnt_sign_enabled;

/*
* Is signing required by mnt options? If not then check
* global_secflags to see if it is there.
*/
if (!mnt_sign_required)
mnt_sign_required =3D ((global_secflags & CIFSSEC_MUST_SIGN) =3D=3D
CIFSSEC_MUST_SIGN);

/*
* If signing is required then it's automatically enabled too,
* otherwise, check to see if the secflags allow it.
*/
mnt_sign_enabled =3D mnt_sign_required ? mnt_sign_required :
(global_secflags & CIFSSEC_MAY_SIGN);

/* If server requires signing, does client allow it? */
if (srv_sign_required) {
if (!mnt_sign_enabled) {
cifs_dbg(VFS, "Server requires signing, but it's disabled in SecurityFlags!=
\n");
return -EOPNOTSUPP;
}
server->sign =3D true;
}

/* If client requires signing, does server allow it? */
if (mnt_sign_required) {
if (!srv_sign_enabled) {
cifs_dbg(VFS, "Server does not support signing!\n");
return -EOPNOTSUPP;
}
server->sign =3D true;
}
```


On Tue, Mar 11, 2025 at 8:56=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Was doing some testing with this and tried an experiment with
> multichannel and "sign" mount parm - and it looks like even without
> the fix, we do sign on all channels even though tcp_ses->sign was not
> updated on the secondary channels.  Do you have a reproduction
> scenario for the signing issue?
>
> On Thu, Mar 6, 2025 at 11:47=E2=80=AFAM <aman1cifs@gmail.com> wrote:
> >
> > From: Aman <aman1@microsoft.com>
> >
> > In a multichannel setup, it was observed that a few fields were not bei=
ng
> > copied over to the secondary channels, which impacted performance in ca=
ses
> > where these options were relevant but not properly synchronized. To add=
ress
> > this, this patch introduces copying the following parameters from the
> > primary channel to the secondary channels:
> >
> > - min_offload
> > - compression.requested
> > - dfs_conn
> > - ignore_signature
> > - leaf_fullpath
> > - noblockcnt
> > - retrans
> > - sign
> >
> > By copying these parameters, we ensure consistency across channels and
> > prevent performance degradation due to missing or outdated settings.
> >
> > Signed-off-by: Aman <aman1@microsoft.com>
> > ---
> >  fs/smb/client/connect.c | 1 +
> >  fs/smb/client/sess.c    | 7 +++++++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index eaa6be445..eb82458eb 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1721,6 +1721,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
> >         /* Grab netns reference for this server. */
> >         cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
> >
> > +       tcp_ses->sign =3D ctx->sign;
> >         tcp_ses->conn_id =3D atomic_inc_return(&tcpSesNextId);
> >         tcp_ses->noblockcnt =3D ctx->rootfs;
> >         tcp_ses->noblocksnd =3D ctx->noblocksnd || ctx->rootfs;
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index 91d4d409c..b4d76a37a 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -522,6 +522,13 @@ cifs_ses_add_channel(struct cifs_ses *ses,
> >         ctx->sockopt_tcp_nodelay =3D ses->server->tcp_nodelay;
> >         ctx->echo_interval =3D ses->server->echo_interval / HZ;
> >         ctx->max_credits =3D ses->server->max_credits;
> > +       ctx->min_offload =3D ses->server->min_offload;
> > +       ctx->compress =3D ses->server->compression.requested;
> > +       ctx->dfs_conn =3D ses->server->dfs_conn;
> > +       ctx->ignore_signature =3D ses->server->ignore_signature;
> > +       ctx->leaf_fullpath =3D ses->server->leaf_fullpath;
> > +       ctx->rootfs =3D ses->server->noblockcnt;
> > +       ctx->retrans =3D ses->server->retrans;
> >
> >         /*
> >          * This will be used for encoding/decoding user/domain/pw
> > --
> > 2.43.0
> >
> >
>
>
> --
> Thanks,
>
> Steve
