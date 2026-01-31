Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A19385EE0
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896724; cv=pass; b=aPA1grQ/8glfGOvq1KvZ2W2hr/2NzU2n877pXfzL8TO3leOMjBL8kfnZZEeoKwdHEdfK54hj4IFtxzYGKrdmjHFEgI7M0NIbEpjVJBxLpuLWPoex7fXd2JA8RxafUE9l4RgXkceMSQZvUGp6ZYnBXjidB4IUs1DVdFPu8sY4Yjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896724; c=relaxed/simple;
	bh=+IFYfbx66iDHpQz8LyM0sFJnwNNgXGwt9EHRF5rs66o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMvCwKIP6zX50KGMBkx9CnZ1onh90rboOMdKNERU57ny3fcZy0ooEWUgmzS+LcAj4rRPv9P4RvgU92ayrcykJPWxTAuJraTGg0ogyiYWrnsOuPuwXR42mdb6vHMqEFoe0V30A5BeNuWfdDZJrJ5VGLG+7V0LzCVV494Dw5dYLI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBbSuKLg; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBbSuKLg"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c6b16bd040so373208685a.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 13:58:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769896721; cv=none;
        d=google.com; s=arc-20240605;
        b=LlU+OROjvkvz2ICxEezDqxDNOcgNXzC65NQr8/iFwz/DsqhMyEhj3zikPZwJKm/xIb
         gClYBHyjW194wyKajYIUe+2v4Uhgrf1uf49uhePxeSaAbebWtiC9yiWsLUHG0Vq9nMEM
         c+0eGpotY2jbTZjPy0BgeLNM6Bx00y6xczI4yzeKP9Q0drsRo/k2iU4vmRKrzuBBXzim
         Z6XdA/p9A74RlR9vQBj9uYiB1mSNMdAjfvTdBALXl4zYzKWr6Y8LyQI387sGJmTyXaTA
         s8/8dKnf+x9PukLDoSojszE+78Gcw3KntxR18Jg0yrpmElUdTrzbCI7phsFzgame43z6
         29sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fUb4GVY9sR/dfgvRbhWLpTPEHZGy2rgVgUKD5HMU4qE=;
        fh=6qSQyaLfXUK2cREIqGy/JigMEhJkoRgvX6VOgfcpReU=;
        b=FUP1ijKXq3XwOXO9S1xKTp4JanYaTV96vMlp5Ys9Sfw4F56egmhkRFkKHPu/+r2WBP
         Fj1pqaDp0AeSPlNUlkw2174/wqhpbk7lf9f41I+IpeK6vL85hYJvLX6F2ORKBj40hUXl
         Ot5+XF+akO4KO2Op2kpdQZ8yCbk9zJwHU7lo9f1EmCWaj8vTU2kDoKt2iC2yIZRE+/dl
         NMIK8DmeCTV1weeYjS4H0UtiQnLkND92k38n9S2PpiA8rPqIq7uDW1M14cXcFesH037j
         z11qle3qm5W6TJvE1qOx2cA3AKNwys2pvpxlkU8b6Rbe45tam1/yPsv3An4TqJ5vC8ow
         B6mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769896721; x=1770501521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUb4GVY9sR/dfgvRbhWLpTPEHZGy2rgVgUKD5HMU4qE=;
        b=JBbSuKLg1zOOyUfCMtGX/kEbaLwYmuY+4JF0iQj/rODOHe76ur2+ewIJFREwUNp4/D
         dYR0UUcMULBTN6tMZO2M+yjsw+iLL9QH6jkJ8IMBVi742+Ft1K7GXfJ2jSyAsdowXfil
         Gg2DICavurAmZNYbfkgePCNE6scysmMi/r3NbReoMRT7AjENauqA2fEX3by1GqzLfAbV
         JiFezw6k7lI8MH29bt51clpxlJ0rninfQhYGAzzobp51UC+uTd0b48u7bP679fHQ/9qY
         90QfWpT1RjUjUIJE3Xy28CSkPSpczGIiKbx5INnjb69dYReMxA+l7+9SjW/tt1sxW8br
         kyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769896721; x=1770501521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fUb4GVY9sR/dfgvRbhWLpTPEHZGy2rgVgUKD5HMU4qE=;
        b=nL2ETCvo5zfzS6Zu9yABqSnO8ea/k09eSKr0qWtZ9Ht83daEhcWL2GyBK2wNZkbHnV
         uoUmcEN61U+oH/khIC1AinNa1rPl0WbbeO/+zbFwCUz3McowWAq2kX+eu8JS+UShoe/t
         2aihODu36pVQUlUQJsE7HkXErclM+Xskd5MGsWGzmLOGXiUf7x6q3VzfLAJdVGLDyUwf
         WQ+dpqEbgDBcNCyKQOensW9rgTizL6KadHSYxBvYY4zAkZVyXStGjdfoYJ/L1zvzl0Jj
         h3RzCppEBa1TsKCCmE+CS7mVUVh4fSGoXPEqCy0I6sQwOwe7otd8Mfk4VlhA59xRnrSW
         DeYA==
X-Gm-Message-State: AOJu0YwLQ/KqqciDEPN0H/F9mkSdmdM8DXjvaVUUduRrPKHtxzeKmFE/
	jMw/CFdnmQ1F5UKSyNo536yf51Hx5AxwLyvFV5CmV9Eo1yQoPzzJZd3pO8bREBW/RCBccyX55Z4
	IVmDLOZTgrPvUMIm9aUbzcgbAln/Ucak=
X-Gm-Gg: AZuq6aKdCE6iecPFp072nWo0jIMxwlLhx1RrWcAvO+9JUlrgU8S6D8FyrqsHaDW1B7S
	P3ylgrJOXad1QFlmPO2BQjOnXmUzoLKI9OO3uTgfil4wSEx5BYZFogX7Gepq8SWTQ3hkxM5D6Gv
	EMsaR7RlxY124HANLMs7xCpTyKZLwWcXtF+1GRgQ/24zKaUY66cvj1lXYQ+08h8z76aCg8bDj1r
	CAClPTSDr+bQmiz+DU/kx1YNzw+FNkAumNqjaoCsNSbT/NsyfxuZAJGHe5GIGm1gjSmhNKdkM8K
	iLaQzCpYs36MAMjl8sKNepbrSW7GEynGbA71KlRTrHyQzR4OA+FltmXeu4Yqp47EzWs6w5XJ1yS
	4kkUSCmCrb/JjjGeX238QG5UPv03uD0SVfAyqTVwjH4fnlvaMOnrvcsWr54VdTGWZ05cYRair1t
	40pazq67PNlQ==
X-Received: by 2002:a05:620a:1997:b0:8b2:f2c5:e7f6 with SMTP id
 af79cd13be357-8c9eb28ea2bmr870087285a.37.1769896721080; Sat, 31 Jan 2026
 13:58:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131083325.945635-1-sprasad@microsoft.com>
In-Reply-To: <20260131083325.945635-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Jan 2026 15:58:29 -0600
X-Gm-Features: AZwV_QjiLC5cz4EOGLGXHV_lcoXG-4XAawif2Yh6rr9DDDBQQ-qntFjvKBWHdRQ
Message-ID: <CAH2r5msTWkjG629p+A-rz0Fm0ync7wbzu1UOO6kFexYnrMApng@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] cifs: on replayable errors back-off before replay,
 not after
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, netfs@lists.linux.dev, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged these four into cifs-2.6.git for-next pending additional
testing and review

On Sat, Jan 31, 2026 at 2:33=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> On replayable errors, we call smb2_should_replays that does these
> things today:
> 1. decide if we need to replay the command again
> 2. sleep to back-off the failed request
> 3. update the next sleep value
>
> We will not be able to use this for async requests, when this is
> processed in callbacks (as this will be called in cifsd threads that
> should not sleep in response processing).
>
> Modify the behaviour by taking the sleep out of smb2_should_replay
> and performing the sleep for back-off just before actually
> performing the replay.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c |   6 +-
>  fs/smb/client/smb2inode.c  |  21 +++++--
>  fs/smb/client/smb2ops.c    |  32 ++++++++---
>  fs/smb/client/smb2pdu.c    | 112 +++++++++++++++++++++++++++----------
>  4 files changed, 129 insertions(+), 42 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 1db7ab6c2529c..df9977030d199 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -154,7 +154,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>         struct cached_fid *cfid;
>         struct cached_fids *cfids;
>         const char *npath;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>         __le32 lease_flags =3D 0;
>
>         if (cifs_sb->root =3D=3D NULL)
> @@ -304,6 +304,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
>         smb2_set_related(&rqst[1]);
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
> +
>                 smb2_set_replay(server, &rqst[0]);
>                 smb2_set_replay(server, &rqst[1]);
>         }
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 2ded3246600c0..498a26a7bd415 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -188,7 +188,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>         struct reparse_data_buffer *rbuf;
>         struct TCP_Server_Info *server;
>         int resp_buftype[MAX_COMPOUND];
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>         __u8 delete_pending[8] =3D {1,};
>         struct kvec *rsp_iov, *iov;
>         struct inode *inode =3D NULL;
> @@ -638,18 +638,26 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>         num_rqst++;
>
>         if (cfile) {
> -               if (retries)
> +               if (retries) {
> +                       /* Back-off before retry */
> +                       if (cur_sleep)
> +                               msleep(cur_sleep);
>                         for (i =3D 1; i < num_rqst - 2; i++)
>                                 smb2_set_replay(server, &rqst[i]);
> +               }
>
>                 rc =3D compound_send_recv(xid, ses, server,
>                                         flags, num_rqst - 2,
>                                         &rqst[1], &resp_buftype[1],
>                                         &rsp_iov[1]);
>         } else {
> -               if (retries)
> +               if (retries) {
> +                       /* Back-off before retry */
> +                       if (cur_sleep)
> +                               msleep(cur_sleep);
>                         for (i =3D 0; i < num_rqst; i++)
>                                 smb2_set_replay(server, &rqst[i]);
> +               }
>
>                 rc =3D compound_send_recv(xid, ses, server,
>                                         flags, num_rqst,
> @@ -1180,7 +1188,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tco=
n *tcon, const char *name,
>  {
>         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>         __le16 *utf16_path __free(kfree) =3D NULL;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>         struct TCP_Server_Info *server;
>         struct cifs_open_parms oparms;
>         struct smb2_create_req *creq;
> @@ -1242,6 +1250,9 @@ smb2_unlink(const unsigned int xid, struct cifs_tco=
n *tcon, const char *name,
>                 goto err_free;
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 for (int i =3D 0; i < ARRAY_SIZE(rqst);  i++)
>                         smb2_set_replay(server, &rqst[i]);
>         }
> @@ -1262,7 +1273,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tco=
n *tcon, const char *name,
>         if (rc =3D=3D -EINVAL && dentry) {
>                 dentry =3D NULL;
>                 retries =3D 0;
> -               cur_sleep =3D 1;
> +               cur_sleep =3D 0;
>                 goto again;
>         }
>         /*
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index c1aaf77e187b6..f6806946d0eee 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1184,7 +1184,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>         struct smb2_file_full_ea_info *ea;
>         struct smb2_query_info_rsp *rsp;
>         int rc, used_len =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -1314,6 +1314,9 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>         smb2_set_related(&rqst[2]);
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst[0]);
>                 smb2_set_replay(server, &rqst[1]);
>                 smb2_set_replay(server, &rqst[2]);
> @@ -1582,7 +1585,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         void *data[2];
>         int create_options =3D is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
>         void (*free_req1_func)(struct smb_rqst *r);
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -1731,6 +1734,9 @@ smb2_ioctl_query_info(const unsigned int xid,
>         smb2_set_related(&rqst[2]);
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst[0]);
>                 smb2_set_replay(server, &rqst[1]);
>                 smb2_set_replay(server, &rqst[2]);
> @@ -2446,7 +2452,7 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>         struct smb2_query_directory_rsp *qd_rsp =3D NULL;
>         struct smb2_create_rsp *op_rsp =3D NULL;
>         struct TCP_Server_Info *server;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -2504,6 +2510,9 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
>         smb2_set_related(&rqst[1]);
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst[0]);
>                 smb2_set_replay(server, &rqst[1]);
>         }
> @@ -2780,10 +2789,14 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
>                 return false;
>
>         if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
> -               msleep(*pcur_sleep);
> -               (*pcur_sleep) =3D ((*pcur_sleep) << 1);
> -               if ((*pcur_sleep) > CIFS_MAX_SLEEP)
> -                       (*pcur_sleep) =3D CIFS_MAX_SLEEP;
> +               /* Update sleep time for exponential backoff */
> +               if (!(*pcur_sleep))
> +                       (*pcur_sleep) =3D 1;
> +               else {
> +                       (*pcur_sleep) =3D ((*pcur_sleep) << 1);
> +                       if ((*pcur_sleep) > CIFS_MAX_SLEEP)
> +                               (*pcur_sleep) =3D CIFS_MAX_SLEEP;
> +               }
>                 return true;
>         }
>
> @@ -2814,7 +2827,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>         int rc;
>         __le16 *utf16_path;
>         struct cached_fid *cfid;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -2904,6 +2917,9 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>         smb2_set_related(&rqst[2]);
>
>         if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 if (!cfid) {
>                         smb2_set_replay(server, &rqst[0]);
>                         smb2_set_replay(server, &rqst[2]);
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 5d57c895ca37a..7d75ba675f774 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2904,7 +2904,7 @@ int smb311_posix_mkdir(const unsigned int xid, stru=
ct inode *inode,
>         unsigned int total_len;
>         __le16 *utf16_path =3D NULL;
>         struct TCP_Server_Info *server;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -3016,8 +3016,12 @@ int smb311_posix_mkdir(const unsigned int xid, str=
uct inode *inode,
>         trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_path=
, CREATE_NOT_FILE,
>                                     FILE_WRITE_ATTRIBUTES);
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         /* resource #4: response buffer */
>         rc =3D cifs_send_recv(xid, ses, server,
> @@ -3265,7 +3269,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>         int resp_buftype =3D CIFS_NO_BUFFER;
>         int rc =3D 0;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -3293,8 +3297,12 @@ SMB2_open(const unsigned int xid, struct cifs_open=
_parms *oparms, __le16 *path,
>         trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->pa=
th,
>                 oparms->create_options, oparms->desired_access);
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags,
> @@ -3478,7 +3486,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon=
 *tcon, u64 persistent_fid,
>         int resp_buftype =3D CIFS_NO_BUFFER;
>         int rc =3D 0;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>         if (!tcon)
>                 return smb_EIO(smb_eio_trace_null_pointers);
> @@ -3518,8 +3526,12 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tco=
n *tcon, u64 persistent_fid,
>         if (rc)
>                 goto ioctl_exit;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags,
> @@ -3675,7 +3687,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tc=
on *tcon,
>         int rc =3D 0;
>         int flags =3D 0;
>         bool query_attrs =3D false;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -3707,8 +3719,12 @@ __SMB2_close(const unsigned int xid, struct cifs_t=
con *tcon,
>         if (rc)
>                 goto close_exit;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -3878,7 +3894,7 @@ query_info(const unsigned int xid, struct cifs_tcon=
 *tcon,
>         struct TCP_Server_Info *server;
>         int flags =3D 0;
>         bool allocated =3D false;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>         cifs_dbg(FYI, "Query Info\n");
>
> @@ -3912,8 +3928,12 @@ query_info(const unsigned int xid, struct cifs_tco=
n *tcon,
>         trace_smb3_query_info_enter(xid, persistent_fid, tcon->tid,
>                                     ses->Suid, info_class, (__u32)info_ty=
pe);
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -4069,7 +4089,7 @@ SMB2_change_notify(const unsigned int xid, struct c=
ifs_tcon *tcon,
>         int resp_buftype =3D CIFS_NO_BUFFER;
>         int flags =3D 0;
>         int rc =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -4100,8 +4120,12 @@ SMB2_change_notify(const unsigned int xid, struct =
cifs_tcon *tcon,
>         trace_smb3_notify_enter(xid, persistent_fid, tcon->tid, ses->Suid=
,
>                                 (u8)watch_tree, completion_filter);
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -4405,7 +4429,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon=
 *tcon, u64 persistent_fid,
>         int resp_buftype =3D CIFS_NO_BUFFER;
>         int flags =3D 0;
>         int rc =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -4431,8 +4455,12 @@ SMB2_flush(const unsigned int xid, struct cifs_tco=
n *tcon, u64 persistent_fid,
>
>         trace_smb3_flush_enter(xid, persistent_fid, tcon->tid, ses->Suid)=
;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -5190,7 +5218,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_p=
arms *io_parms,
>         int flags =3D 0;
>         unsigned int total_len;
>         struct TCP_Server_Info *server;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -5238,8 +5266,12 @@ SMB2_write(const unsigned int xid, struct cifs_io_=
parms *io_parms,
>         rqst.rq_iov =3D iov;
>         rqst.rq_nvec =3D n_vec + 1;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, io_parms->tcon->ses, server,
>                             &rqst,
> @@ -5590,7 +5622,7 @@ SMB2_query_directory(const unsigned int xid, struct=
 cifs_tcon *tcon,
>         struct cifs_ses *ses =3D tcon->ses;
>         struct TCP_Server_Info *server;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -5615,8 +5647,12 @@ SMB2_query_directory(const unsigned int xid, struc=
t cifs_tcon *tcon,
>         if (rc)
>                 goto qdir_exit;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -5725,7 +5761,7 @@ send_set_info(const unsigned int xid, struct cifs_t=
con *tcon,
>         struct cifs_ses *ses =3D tcon->ses;
>         struct TCP_Server_Info *server;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -5758,8 +5794,12 @@ send_set_info(const unsigned int xid, struct cifs_=
tcon *tcon,
>                 return rc;
>         }
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags,
> @@ -5838,7 +5878,7 @@ SMB2_oplock_break(const unsigned int xid, struct ci=
fs_tcon *tcon,
>         struct kvec iov[1];
>         struct kvec rsp_iov;
>         int resp_buf_type;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -5868,8 +5908,12 @@ SMB2_oplock_break(const unsigned int xid, struct c=
ifs_tcon *tcon,
>         rqst.rq_iov =3D iov;
>         rqst.rq_nvec =3D 1;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buf_type, flags, &rsp_iov);
> @@ -5971,7 +6015,7 @@ SMB311_posix_qfs_info(const unsigned int xid, struc=
t cifs_tcon *tcon,
>         struct TCP_Server_Info *server;
>         FILE_SYSTEM_POSIX_INFO *info =3D NULL;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -5992,8 +6036,12 @@ SMB311_posix_qfs_info(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         rqst.rq_iov =3D &iov;
>         rqst.rq_nvec =3D 1;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -6036,7 +6084,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_t=
con *tcon,
>         struct TCP_Server_Info *server;
>         unsigned int rsp_len, offset;
>         int flags =3D 0;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -6073,8 +6121,12 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_=
tcon *tcon,
>         rqst.rq_iov =3D &iov;
>         rqst.rq_nvec =3D 1;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, ses, server,
>                             &rqst, &resp_buftype, flags, &rsp_iov);
> @@ -6136,7 +6188,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon=
 *tcon,
>         int flags =3D CIFS_NO_RSP_BUF;
>         unsigned int total_len;
>         struct TCP_Server_Info *server;
> -       int retries =3D 0, cur_sleep =3D 1;
> +       int retries =3D 0, cur_sleep =3D 0;
>
>  replay_again:
>         /* reinitialize for possible replay */
> @@ -6172,8 +6224,12 @@ smb2_lockv(const unsigned int xid, struct cifs_tco=
n *tcon,
>         rqst.rq_iov =3D iov;
>         rqst.rq_nvec =3D 2;
>
> -       if (retries)
> +       if (retries) {
> +               /* Back-off before retry */
> +               if (cur_sleep)
> +                       msleep(cur_sleep);
>                 smb2_set_replay(server, &rqst);
> +       }
>
>         rc =3D cifs_send_recv(xid, tcon->ses, server,
>                             &rqst, &resp_buf_type, flags,
> --
> 2.43.0
>


--=20
Thanks,

Steve
