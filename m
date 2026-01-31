Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36331F91D6
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769848523; cv=pass; b=DwA/UINW2MvbVYqYBm7OPMfaTD/vzbOA3M/WN64QdJ0KIsB0gSz20Z2bHT+piE0tOqvjBkwODyH4fGjvWxHYYQPmMYZNmcHNPrYkO92ERMED7qMhKXLncH6JG3rFpLkRjL9L1smUAp8MhFYCNgfB0UDJWXo2pJqS5GE/k5gTDsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769848523; c=relaxed/simple;
	bh=ToGjpm7aYWVJi8QWFMIwYGv2l21QPb/xPHltBEfA0nY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RgatXbrzqaqCfKRDNkqyqd7JxEQwCe/ewAqVFIrrBZzXVP9VFPa8nYGWkCKzkT5Uvl1MuTFi84TKXXztAgiv49lAL7YRGlcLgvpQ/FULnoBuWdWbB3w2V7gem+39HXlPWSvimkakcHHozvFCQPwtItaamZsyR/UCkuzuLHwkNsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyIBrVZ/; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyIBrVZ/"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-658b9e95990so5472283a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:35:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769848519; cv=none;
        d=google.com; s=arc-20240605;
        b=DtQ0oErFztq2AqxeAiPjnKoK4KtpXP+3hlHRrWKbAssUshotecBmyzi4yBYsIlO8Uq
         rAq+d4B3Mgv3ZGPZpO57TOb13UZLhs3ITT9O5hrg+LjIfUwHH3luwHxf/PvYBEQ4DhQr
         YMlamyvJ0+hC815YVYfROMA9lIWeUNV4QyEhmimq4Nypye8nDHS4WcLhcWWKgQo6jZmx
         hEOnL+ghtdHnmsdY7pjh2qadKc0ENzClxQON0iVaR2q0ND55y5JAhD2aywrtX9ZPf0Vf
         3vyy+/nBExCKledl+xZfCS1y8WAiUISnGFkEtS1OXdh0+gznQzMcmUC8rZaIwNWpiOVi
         OT1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OLDmIgRIO5Orn0/6aifbQAPNsNsK1c7qiQxEQfXfUNc=;
        fh=J36udwqGe3ENCbI43dyhq3tnY3sVexKew3UMmDoOCvc=;
        b=EvfRHmNBtdEyqqFwymqJkGqVY68lKlPq3lR+G4bTy0KX+YLF5s8zAaARAEzZBI+Quq
         /5J1pj8UJtd+eJvU1UIKscg9nf1+o5iZPW5pl/bJl4SwZa4gkU7dsySMv2AS4p5cElfa
         U/aiqwBR3OBtsO2khw/kJhFK1heMeWMnLaGpMdu9EM0NvfcxmYBfI+7dN0ihrqF+aHui
         5AXOeXHwUIvCDXJGhZmAhinPLs4ztkaBajNpd9Chw7j+u/6QvVFiv6bPA7yriarzLkvV
         vbBdELKs/8+0oDrqgI/BP3yuNfl1+fk3WMf7NL796Z49a3KhRpY2CARmCEL6OU0hfEiu
         ZQyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769848519; x=1770453319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLDmIgRIO5Orn0/6aifbQAPNsNsK1c7qiQxEQfXfUNc=;
        b=RyIBrVZ/jnCa98q8CXxQ5psdey4Oqy61LFDLg3RGZJoWt9T0dcO1gjKo9uKzw26l9x
         mYDqy6gDlpv5MpWiq2tXN2CTlu2k9mXV4qYn0f76XusdJowbnzlqwzi2Emqk1Qeqsp5C
         lFxCVLW4mwXSLiOGj6l3GE0bAKF1uz9cJG1Aqv1uS8ZpCfYnqIsq3y1a3A/Y1nOhFuy0
         1gqMJbeQG9tStxKC8iYNgGK/dkX0gItlJVOdCwMV6hji/vjxlr1iIulUzr/+sBAM4Z+V
         Ur3VgSUPXISpLL/zgeHh6XKDLbsabFd7WrnDx/1XwCjH9zBOu/rURGkN16PDJlp24VlL
         uN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769848519; x=1770453319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OLDmIgRIO5Orn0/6aifbQAPNsNsK1c7qiQxEQfXfUNc=;
        b=K0nmUP13o9sR4WXidb4BeRFe6i5DsYs2dvi9rFBNLnn+A6ng26JCulliKzmQ/DtEMi
         5fvNQ6yTsfI2Tv0jXKx95v7tCUjQTffDuqzO8zzTQV2S8+vWVwL1T+Umi8daYDkfRXT6
         zh06/irQFz1+KWRAgzczwFZnZ+ZG37nlTvLTEbQvsesrtEoPg6jgCQHiBT6jtlGOcXuj
         k8NW40JkFOv9A//rdvV2CMGvodw8FnwYXFBCEc9ECv3sWTqmqHEO6tUWbvtiIQwSkyOY
         grH14jWT/zPdPMBYWa1c6hVDqwFCq3Fs7EilLzyqX/PIWUAd/eGbYCObg29tjDacDmiP
         PDSA==
X-Gm-Message-State: AOJu0YwL/+Ql3uUtdy5/5zrs+EHCMTZYl/xYyGKBASfqrPv2sZQSICpc
	d4Y5c6XbB1dLseEtXI/k58Si9vF26fLmWEVvdzrIHIiawobKS09JFmOZVebolaXBk08DDBRbq+Y
	PGFcZVDCpxfb7lIZjF1uGJSaf49HcYrs=
X-Gm-Gg: AZuq6aIeb/+h3KgH2ByCaoD1hbKiv1MKbUWGhp+bAek8kFAcWKN71a6Om8lkZAVwS3M
	i51sgD/5JVyeAfk655fMz26WeBQ01tr677UcwxBD/wXMZV98W9KQ5nIltJNGT4XX7Y6Vv7ReuW0
	M9vwoa5CehMnGlScMGn7fiX0BFjyIPesOMa3wYbuERU/rxPxmLONBEqP/l03AtYdlvBQalLfaQz
	uAVoWLiDPjMzQVgJ8nUrLdqyesR15JORJjMErh3AfyqI0m8QR0INWKZIAWYRHA0XIdindBzo7Y5
	EXTJ
X-Received: by 2002:a17:907:709:b0:b8a:f225:edd2 with SMTP id
 a640c23a62f3a-b8dff78c5e2mr318108466b.47.1769848518988; Sat, 31 Jan 2026
 00:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129173725.887651-1-sprasad@microsoft.com> <CAH2r5msuwKLRthznEmHfasczU8_Pti+KAi1crXcMwNBnuiubsA@mail.gmail.com>
In-Reply-To: <CAH2r5msuwKLRthznEmHfasczU8_Pti+KAi1crXcMwNBnuiubsA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 31 Jan 2026 14:05:07 +0530
X-Gm-Features: AZwV_QiQtR0ws4_ujAO7eGCaIap31Xsx76uTONAYlJ9VlAHQ8AnTrRVTI2luVVs
Message-ID: <CANT5p=qhf1mMav0ef5pOW6OM2eVPQmJXeaF2NMPg+cv97K6D8Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] cifs: on replayable errors back-off before replay,
 not after
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, bharathsm@microsoft.com, 
	dhowells@redhat.com, netfs@lists.linux.dev, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 9:07=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Have updated cifs-2.6.git for-next with these four patches
>
> On Thu, Jan 29, 2026 at 11:37=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > On replayable errors, we call smb2_should_replays that does these
> > things today:
> > 1. decide if we need to replay the command again
> > 2. sleep to back-off the failed request
> > 3. update the next sleep value
> >
> > We will not be able to use this for async requests, when this is
> > processed in callbacks (as this will be called in cifsd threads that
> > should not sleep in response processing).
> >
> > Modify the behaviour by taking the sleep out of smb2_should_replay
> > and performing the sleep for back-off just before actually
> > performing the replay.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c |   6 +-
> >  fs/smb/client/smb2inode.c  |  21 +++++--
> >  fs/smb/client/smb2ops.c    |  32 ++++++++---
> >  fs/smb/client/smb2pdu.c    | 112 +++++++++++++++++++++++++++----------
> >  4 files changed, 129 insertions(+), 42 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index 1db7ab6c2529c..df9977030d199 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -154,7 +154,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >         struct cached_fid *cfid;
> >         struct cached_fids *cfids;
> >         const char *npath;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >         __le32 lease_flags =3D 0;
> >
> >         if (cifs_sb->root =3D=3D NULL)
> > @@ -304,6 +304,10 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >         smb2_set_related(&rqst[1]);
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> > +
> >                 smb2_set_replay(server, &rqst[0]);
> >                 smb2_set_replay(server, &rqst[1]);
> >         }
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 2ded3246600c0..498a26a7bd415 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -188,7 +188,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >         struct reparse_data_buffer *rbuf;
> >         struct TCP_Server_Info *server;
> >         int resp_buftype[MAX_COMPOUND];
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >         __u8 delete_pending[8] =3D {1,};
> >         struct kvec *rsp_iov, *iov;
> >         struct inode *inode =3D NULL;
> > @@ -638,18 +638,26 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >         num_rqst++;
> >
> >         if (cfile) {
> > -               if (retries)
> > +               if (retries) {
> > +                       /* Back-off before retry */
> > +                       if (cur_sleep)
> > +                               msleep(cur_sleep);
> >                         for (i =3D 1; i < num_rqst - 2; i++)
> >                                 smb2_set_replay(server, &rqst[i]);
> > +               }
> >
> >                 rc =3D compound_send_recv(xid, ses, server,
> >                                         flags, num_rqst - 2,
> >                                         &rqst[1], &resp_buftype[1],
> >                                         &rsp_iov[1]);
> >         } else {
> > -               if (retries)
> > +               if (retries) {
> > +                       /* Back-off before retry */
> > +                       if (cur_sleep)
> > +                               msleep(cur_sleep);
> >                         for (i =3D 0; i < num_rqst; i++)
> >                                 smb2_set_replay(server, &rqst[i]);
> > +               }
> >
> >                 rc =3D compound_send_recv(xid, ses, server,
> >                                         flags, num_rqst,
> > @@ -1180,7 +1188,7 @@ smb2_unlink(const unsigned int xid, struct cifs_t=
con *tcon, const char *name,
> >  {
> >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> >         __le16 *utf16_path __free(kfree) =3D NULL;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >         struct TCP_Server_Info *server;
> >         struct cifs_open_parms oparms;
> >         struct smb2_create_req *creq;
> > @@ -1242,6 +1250,9 @@ smb2_unlink(const unsigned int xid, struct cifs_t=
con *tcon, const char *name,
> >                 goto err_free;
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 for (int i =3D 0; i < ARRAY_SIZE(rqst);  i++)
> >                         smb2_set_replay(server, &rqst[i]);
> >         }
> > @@ -1262,7 +1273,7 @@ smb2_unlink(const unsigned int xid, struct cifs_t=
con *tcon, const char *name,
> >         if (rc =3D=3D -EINVAL && dentry) {
> >                 dentry =3D NULL;
> >                 retries =3D 0;
> > -               cur_sleep =3D 1;
> > +               cur_sleep =3D 0;
> >                 goto again;
> >         }
> >         /*
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index a16ded46b5a26..7980c6f80730f 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -1184,7 +1184,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_t=
con *tcon,
> >         struct smb2_file_full_ea_info *ea;
> >         struct smb2_query_info_rsp *rsp;
> >         int rc, used_len =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -1314,6 +1314,9 @@ smb2_set_ea(const unsigned int xid, struct cifs_t=
con *tcon,
> >         smb2_set_related(&rqst[2]);
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst[0]);
> >                 smb2_set_replay(server, &rqst[1]);
> >                 smb2_set_replay(server, &rqst[2]);
> > @@ -1582,7 +1585,7 @@ smb2_ioctl_query_info(const unsigned int xid,
> >         void *data[2];
> >         int create_options =3D is_dir ? CREATE_NOT_FILE : CREATE_NOT_DI=
R;
> >         void (*free_req1_func)(struct smb_rqst *r);
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -1731,6 +1734,9 @@ smb2_ioctl_query_info(const unsigned int xid,
> >         smb2_set_related(&rqst[2]);
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst[0]);
> >                 smb2_set_replay(server, &rqst[1]);
> >                 smb2_set_replay(server, &rqst[2]);
> > @@ -2440,7 +2446,7 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >         struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> >         struct smb2_create_rsp *op_rsp =3D NULL;
> >         struct TCP_Server_Info *server;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -2498,6 +2504,9 @@ smb2_query_dir_first(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >         smb2_set_related(&rqst[1]);
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst[0]);
> >                 smb2_set_replay(server, &rqst[1]);
> >         }
> > @@ -2774,10 +2783,14 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
> >                 return false;
> >
> >         if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) =
{
> > -               msleep(*pcur_sleep);
> > -               (*pcur_sleep) =3D ((*pcur_sleep) << 1);
> > -               if ((*pcur_sleep) > CIFS_MAX_SLEEP)
> > -                       (*pcur_sleep) =3D CIFS_MAX_SLEEP;
> > +               /* Update sleep time for exponential backoff */
> > +               if (!(*pcur_sleep))
> > +                       (*pcur_sleep) =3D 1;
> > +               else {
> > +                       (*pcur_sleep) =3D ((*pcur_sleep) << 1);
> > +                       if ((*pcur_sleep) > CIFS_MAX_SLEEP)
> > +                               (*pcur_sleep) =3D CIFS_MAX_SLEEP;
> > +               }
> >                 return true;
> >         }
> >
> > @@ -2808,7 +2821,7 @@ smb2_query_info_compound(const unsigned int xid, =
struct cifs_tcon *tcon,
> >         int rc;
> >         __le16 *utf16_path;
> >         struct cached_fid *cfid;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -2898,6 +2911,9 @@ smb2_query_info_compound(const unsigned int xid, =
struct cifs_tcon *tcon,
> >         smb2_set_related(&rqst[2]);
> >
> >         if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 if (!cfid) {
> >                         smb2_set_replay(server, &rqst[0]);
> >                         smb2_set_replay(server, &rqst[2]);
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 5d57c895ca37a..7d75ba675f774 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -2904,7 +2904,7 @@ int smb311_posix_mkdir(const unsigned int xid, st=
ruct inode *inode,
> >         unsigned int total_len;
> >         __le16 *utf16_path =3D NULL;
> >         struct TCP_Server_Info *server;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -3016,8 +3016,12 @@ int smb311_posix_mkdir(const unsigned int xid, s=
truct inode *inode,
> >         trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_pa=
th, CREATE_NOT_FILE,
> >                                     FILE_WRITE_ATTRIBUTES);
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         /* resource #4: response buffer */
> >         rc =3D cifs_send_recv(xid, ses, server,
> > @@ -3265,7 +3269,7 @@ SMB2_open(const unsigned int xid, struct cifs_ope=
n_parms *oparms, __le16 *path,
> >         int resp_buftype =3D CIFS_NO_BUFFER;
> >         int rc =3D 0;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -3293,8 +3297,12 @@ SMB2_open(const unsigned int xid, struct cifs_op=
en_parms *oparms, __le16 *path,
> >         trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->=
path,
> >                 oparms->create_options, oparms->desired_access);
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags,
> > @@ -3478,7 +3486,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tc=
on *tcon, u64 persistent_fid,
> >         int resp_buftype =3D CIFS_NO_BUFFER;
> >         int rc =3D 0;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >         if (!tcon)
> >                 return smb_EIO(smb_eio_trace_null_pointers);
> > @@ -3518,8 +3526,12 @@ SMB2_ioctl(const unsigned int xid, struct cifs_t=
con *tcon, u64 persistent_fid,
> >         if (rc)
> >                 goto ioctl_exit;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags,
> > @@ -3675,7 +3687,7 @@ __SMB2_close(const unsigned int xid, struct cifs_=
tcon *tcon,
> >         int rc =3D 0;
> >         int flags =3D 0;
> >         bool query_attrs =3D false;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -3707,8 +3719,12 @@ __SMB2_close(const unsigned int xid, struct cifs=
_tcon *tcon,
> >         if (rc)
> >                 goto close_exit;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -3878,7 +3894,7 @@ query_info(const unsigned int xid, struct cifs_tc=
on *tcon,
> >         struct TCP_Server_Info *server;
> >         int flags =3D 0;
> >         bool allocated =3D false;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >         cifs_dbg(FYI, "Query Info\n");
> >
> > @@ -3912,8 +3928,12 @@ query_info(const unsigned int xid, struct cifs_t=
con *tcon,
> >         trace_smb3_query_info_enter(xid, persistent_fid, tcon->tid,
> >                                     ses->Suid, info_class, (__u32)info_=
type);
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -4069,7 +4089,7 @@ SMB2_change_notify(const unsigned int xid, struct=
 cifs_tcon *tcon,
> >         int resp_buftype =3D CIFS_NO_BUFFER;
> >         int flags =3D 0;
> >         int rc =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -4100,8 +4120,12 @@ SMB2_change_notify(const unsigned int xid, struc=
t cifs_tcon *tcon,
> >         trace_smb3_notify_enter(xid, persistent_fid, tcon->tid, ses->Su=
id,
> >                                 (u8)watch_tree, completion_filter);
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -4405,7 +4429,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tc=
on *tcon, u64 persistent_fid,
> >         int resp_buftype =3D CIFS_NO_BUFFER;
> >         int flags =3D 0;
> >         int rc =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -4431,8 +4455,12 @@ SMB2_flush(const unsigned int xid, struct cifs_t=
con *tcon, u64 persistent_fid,
> >
> >         trace_smb3_flush_enter(xid, persistent_fid, tcon->tid, ses->Sui=
d);
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -5190,7 +5218,7 @@ SMB2_write(const unsigned int xid, struct cifs_io=
_parms *io_parms,
> >         int flags =3D 0;
> >         unsigned int total_len;
> >         struct TCP_Server_Info *server;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -5238,8 +5266,12 @@ SMB2_write(const unsigned int xid, struct cifs_i=
o_parms *io_parms,
> >         rqst.rq_iov =3D iov;
> >         rqst.rq_nvec =3D n_vec + 1;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, io_parms->tcon->ses, server,
> >                             &rqst,
> > @@ -5590,7 +5622,7 @@ SMB2_query_directory(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >         struct cifs_ses *ses =3D tcon->ses;
> >         struct TCP_Server_Info *server;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -5615,8 +5647,12 @@ SMB2_query_directory(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >         if (rc)
> >                 goto qdir_exit;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -5725,7 +5761,7 @@ send_set_info(const unsigned int xid, struct cifs=
_tcon *tcon,
> >         struct cifs_ses *ses =3D tcon->ses;
> >         struct TCP_Server_Info *server;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -5758,8 +5794,12 @@ send_set_info(const unsigned int xid, struct cif=
s_tcon *tcon,
> >                 return rc;
> >         }
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags,
> > @@ -5838,7 +5878,7 @@ SMB2_oplock_break(const unsigned int xid, struct =
cifs_tcon *tcon,
> >         struct kvec iov[1];
> >         struct kvec rsp_iov;
> >         int resp_buf_type;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -5868,8 +5908,12 @@ SMB2_oplock_break(const unsigned int xid, struct=
 cifs_tcon *tcon,
> >         rqst.rq_iov =3D iov;
> >         rqst.rq_nvec =3D 1;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buf_type, flags, &rsp_iov);
> > @@ -5971,7 +6015,7 @@ SMB311_posix_qfs_info(const unsigned int xid, str=
uct cifs_tcon *tcon,
> >         struct TCP_Server_Info *server;
> >         FILE_SYSTEM_POSIX_INFO *info =3D NULL;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -5992,8 +6036,12 @@ SMB311_posix_qfs_info(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >         rqst.rq_iov =3D &iov;
> >         rqst.rq_nvec =3D 1;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -6036,7 +6084,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs=
_tcon *tcon,
> >         struct TCP_Server_Info *server;
> >         unsigned int rsp_len, offset;
> >         int flags =3D 0;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -6073,8 +6121,12 @@ SMB2_QFS_attr(const unsigned int xid, struct cif=
s_tcon *tcon,
> >         rqst.rq_iov =3D &iov;
> >         rqst.rq_nvec =3D 1;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, ses, server,
> >                             &rqst, &resp_buftype, flags, &rsp_iov);
> > @@ -6136,7 +6188,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tc=
on *tcon,
> >         int flags =3D CIFS_NO_RSP_BUF;
> >         unsigned int total_len;
> >         struct TCP_Server_Info *server;
> > -       int retries =3D 0, cur_sleep =3D 1;
> > +       int retries =3D 0, cur_sleep =3D 0;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > @@ -6172,8 +6224,12 @@ smb2_lockv(const unsigned int xid, struct cifs_t=
con *tcon,
> >         rqst.rq_iov =3D iov;
> >         rqst.rq_nvec =3D 2;
> >
> > -       if (retries)
> > +       if (retries) {
> > +               /* Back-off before retry */
> > +               if (cur_sleep)
> > +                       msleep(cur_sleep);
> >                 smb2_set_replay(server, &rqst);
> > +       }
> >
> >         rc =3D cifs_send_recv(xid, tcon->ses, server,
> >                             &rqst, &resp_buf_type, flags,
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve

Resent a v4 of all 4 patches again, so that there's no confusion about
the patches. Please consider v4 of all 4 patches.

--=20
Regards,
Shyam
