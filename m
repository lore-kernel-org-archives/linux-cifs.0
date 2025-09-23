Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2D30C637
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 06:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607501; cv=none; b=NjOypr7+xWKuESCpUq09bP8WP33RAdUrgSObTtItiDhlAPHFlO0VxSzroIgVCac3IP7rd038GdXUl7+droQBAd+/cTe8bXJ6Q7yfpvd9YjhKkOL1gQKRqZg7eqtkOeH2/3QnLjLfrg1bKs4lgZxcUE3ngjk2sm6aXr3HbuDFmXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607501; c=relaxed/simple;
	bh=Z3vWSBUKk4vPa5Dhi69BGEU0f4G5L8uTvqC8rKu89sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZjM2AcsoB3y/La3b7zwP7DqEl19XH1sYUhPjlIMxzQYt/gnHa1EaKGUBQ5wS3G5OdmGdpurmn6o3TntQM1gfk+noUt4iI7BPcIMe1gKnHDnazBNFu4+BHVROING74wOwMPUQDF3hdEADk//39FLloEIvs1DizirxnH+3Xv3kzyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcHTtwRt; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcHTtwRt"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b30ead58e0cso16054666b.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 23:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758607498; x=1759212298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e22fIZQhYlC3/KF+d3LRMImuPrbyTUVTTfdpcAAK9oQ=;
        b=jcHTtwRt4tMLw/2bSWfM3SwioCLb6kDeNt6BjS8lsBgpoYrs3nDol3fy6DVsIAuG6y
         az2e43QweaBx8V1PCr8iNnFz0P1RXoLvt0H1I0f3gmzRR1lP9ptm15gblpBZjI5rj6z8
         uuXJXam0MWnSjC5DY92xvMn+7lVc+jLxgolKmmt/QCOaOGSrEnFM1LO8Ra7TLtlaRddO
         zlBMLQ600fN6doV9iA8+b7OhrhHGKV4bbIGtERj0C+giadqUUnpDyjhwJxJWJcfZsa5G
         mzvCCAwHE9U2BSiB//bs+ZKX5oppuc+owWThOo3gQbfG5vnlWcW15+vYV14y7wGq3esq
         Ov3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758607498; x=1759212298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e22fIZQhYlC3/KF+d3LRMImuPrbyTUVTTfdpcAAK9oQ=;
        b=DrkMNkpGKgf3CPAt/n0XD3W/uy1vHohlTvXCJP63pU9Zo57KVAcTNDkgeZ3LJAwx20
         8Dp8k7WGoeJYotEN6sw9MHQYfxOl17+AycTrV7AKLTLFOuLoXiVEmcpTV0XgMFfTfBUF
         tx+HdRf4UUfTQn2Iw5VF8vvTleIE1AP8YSu8+yfy6ytK4Qks7PInsSbfLrbXajmI1PNs
         bPtQby5yYKwDglxolqrnuOn3wzpYesG+i0nEZaIUwfDisA3fUAmsPluaStguzU467glq
         aG8R+Ism2fD519UZSbhB6nA9gyJ709rkRIPJKDMYeBQxT0u0vmN1YgdjRxBvWbZquX43
         D/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXma8s/n5zqiLhfnKKsIqCUApltdY40UYU37DGQtTANtcyKY4LuNuevI9sMP8ZA8ATlj9gXRp+qxaZ0@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9p5SdrsGUP3sPomGB2K2NU/kXY9cOGGF2M8JMykDHeEV+suI1
	BBT4WSK/ix2UQYiL0fKpizVvMlgHdKYFxhl/xbK0F1irXb+hdIlbc8xoalvUI3CGQhoLHoXDA1/
	DcRtZ1SJK8s/deAzcRjNVzgGAL0wgk68=
X-Gm-Gg: ASbGncu7M/3RG2CFnSH2MYKaCVZHHWa4gfLR7Hh9PoI3DlHe0pa6x4QmBL9A1Q2kUcU
	FAqWwvRtl2BjugjjIIZU/kJPnwOHr+cQEB4DN5BGwwnowEcbXnwtFCzBk5mSLpvx54Ym2wrInDg
	TrAMqH0yMONFjwgYXRVaRyB6NgOoqgaEMCHDB00e2WcPnoMtFzqlqol931d4xNaFfJHnmyjSgz8
	kuMVJ9lWt/IVr9u
X-Google-Smtp-Source: AGHT+IHXPC0Qk0LRGZJjkY7SA/XSVwAw4qDoNZWUJwZfUSEPJLVRVevwB78H3aY3Bytrw30vv9KTgERvdEBWZa+rAvE=
X-Received: by 2002:a17:907:6d16:b0:b24:b95e:87e5 with SMTP id
 a640c23a62f3a-b302785d7demr118528866b.29.1758607497588; Mon, 22 Sep 2025
 23:04:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <20250922082417.816331-2-rajasimandalos@gmail.com> <4htyleuklcdod3togdqcjl5w7g3j5cmwcc4bww5knlwgwhtsbd@a7s2fa2nvcup>
In-Reply-To: <4htyleuklcdod3togdqcjl5w7g3j5cmwcc4bww5knlwgwhtsbd@a7s2fa2nvcup>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Sep 2025 11:34:46 +0530
X-Gm-Features: AS18NWD7yFAhyjvoORA4y21HuDx6Djlw300tcZDsGry0395_x6REr5brTqW3ch8
Message-ID: <CANT5p=oQaYZEjrkroP8sHw73GgT6tTX=Do6q_Mu8zmKettufHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: client: allow changing multichannel mount
 options on remount
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: rajasimandalos@gmail.com, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 8:43=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 09/22, rajasimandalos@gmail.com wrote:
> >From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> >Previously, the client did not properly update the session's channel
> >state when multichannel or max_channels mount options were changed
> >during remount. This led to inconsistent behavior and prevented
> >enabling or disabling multichannel support without a full
> >unmount/remount.
> >
> >Enable dynamic reconfiguration of multichannel and max_channels
> >options during remount by introducing smb3_sync_ses_chan_max() to
> >safely update the session's chan_max field, and smb3_sync_ses_channels()
> >to synchronize the session's channels with the new configuration.
> >Replace cifs_disable_secondary_channels() with
> >cifs_decrease_secondary_channels(), which now takes a from_reconfigure
> >argument for more flexible channel cleanup. Update the remount logic
> >to detect changes in multichannel or max_channels and trigger the
> >appropriate session/channel updates.
> >
> >With this change, users can safely change multichannel and
> >max_channels options on remount, and the client will correctly adjust
> >the session's channel state to match the new configuration.
> >
> >Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> >---
> > fs/smb/client/cifsproto.h  |  2 +-
> > fs/smb/client/fs_context.c | 29 ++++++++++++++++++
> > fs/smb/client/fs_context.h |  2 +-
> > fs/smb/client/sess.c       | 35 +++++++++++++++-------
> > fs/smb/client/smb2pdu.c    | 60 ++++++++++++++++++++++++++++++--------
> > fs/smb/client/smb2pdu.h    |  2 ++
> > 6 files changed, 105 insertions(+), 25 deletions(-)
>
> I think the fix is necessary, and the implementation works (at least
> with the simple case I tested).  I just think we now have too many
> functions related to channel adding/removing/updating and they're all
> too similar.  IMHO they could all be merged into a single "update
> channels" one.
>
> Do you think it's possible to do that?  Probably would require a bit
> more work, but at least we would end up with a centralized place to deal
> with channel management.

That's a good option. Will explore this with Rajasi.

>
> >diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> >index e8fba98690ce..ec3118457b26 100644
> >--- a/fs/smb/client/cifsproto.h
> >+++ b/fs/smb/client/cifsproto.h
> >@@ -667,7 +667,7 @@ bool
> > cifs_chan_is_iface_active(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server);
> > void
> >-cifs_disable_secondary_channels(struct cifs_ses *ses);
> >+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconf=
igure);
> > void
> > cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *se=
rver);
> > int
> >diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> >index 43552b44f613..96e80c70f25d 100644
> >--- a/fs/smb/client/fs_context.c
> >+++ b/fs/smb/client/fs_context.c
> >@@ -1015,6 +1015,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_s=
b_info *cifs_sb, struct cifs_se
> >       return 0;
> > }
> >
> >+/**
> >+ * smb3_sync_ses_chan_max - Synchronize the session's maximum channel c=
ount
> >+ * @ses: pointer to the old CIFS session structure
> >+ * @max_channels: new maximum number of channels to allow
> >+ *
> >+ * Updates the session's chan_max field to the new value, protecting th=
e update
> >+ * with the session's channel lock. This should be called whenever the =
maximum
> >+ * allowed channels for a session changes (e.g., after a remount or rec=
onfigure).
> >+ */
> >+void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_chan=
nels)
> >+{
> >+      spin_lock(&ses->chan_lock);
> >+      ses->chan_max =3D max_channels;
> >+      spin_unlock(&ses->chan_lock);
> >+}
> >+
> > static int smb3_reconfigure(struct fs_context *fc)
> > {
> >       struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> >@@ -1097,6 +1113,18 @@ static int smb3_reconfigure(struct fs_context *fc=
)
> >               ses->password2 =3D new_password2;
> >       }
> >
> >+      /*
> >+       * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> >+       * This may add or remove channels to match the new configuration=
.
> >+       */
> >+      if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> >+              (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> >+              //Synchronize ses->chan_max with the new mount context
> >+              smb3_sync_ses_chan_max(ses, ctx->max_channels);
> >+              //Now update the session's channels to match the new conf=
iguration
> >+              rc =3D smb3_sync_ses_channels(cifs_sb);
> >+      }
> >+
> >       mutex_unlock(&ses->session_mutex);
> >
> >       STEAL_STRING(cifs_sb, ctx, domainname);
> >@@ -1110,6 +1138,7 @@ static int smb3_reconfigure(struct fs_context *fc)
> >       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> >       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> >       smb3_update_mnt_flags(cifs_sb);
> >+
> > #ifdef CONFIG_CIFS_DFS_UPCALL
> >       if (!rc)
> >               rc =3D dfs_cache_remount_fs(cifs_sb);
> >diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> >index b0fec6b9a23b..a75185858285 100644
> >--- a/fs/smb/client/fs_context.h
> >+++ b/fs/smb/client/fs_context.h
> >@@ -371,7 +371,7 @@ static inline struct smb3_fs_context *smb3_fc2contex=
t(const struct fs_context *f
> > extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct =
smb3_fs_context *ctx);
> > extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb=
, struct cifs_ses *ses);
> > extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
> >-
> >+extern void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int m=
ax_channels);
> > /*
> >  * max deferred close timeout (jiffies) - 2^30
> >  */
> >diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> >index 0a8c2fcc9ded..42b5481c884a 100644
> >--- a/fs/smb/client/sess.c
> >+++ b/fs/smb/client/sess.c
> >@@ -264,13 +264,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
> >       return new_chan_count - old_chan_count;
> > }
> >
> >-/*
> >- * called when multichannel is disabled by the server.
> >- * this always gets called from smb2_reconnect
> >- * and cannot get called in parallel threads.
> >+/**
> >+ * cifs_decrease_secondary_channels - Reduce the number of active secon=
dary channels
> >+ * @ses: pointer to the CIFS session structure
> >+ * @from_reconfigure: if true, only reduce to chan_max; if false, reduc=
e to a single channel
> >+ *
> >+ * This function disables and cleans up extra secondary channels for a =
CIFS session.
> >+ * If called during reconfiguration, it reduces the channel count to th=
e new maximum (chan_max).
> >+ * Otherwise, it disables all but the primary channel.
> >  */
> >-void
> >-cifs_disable_secondary_channels(struct cifs_ses *ses)
> >+void cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_r=
econfigure)
> > {
> >       int i, chan_count;
> >       struct TCP_Server_Info *server;
> >@@ -281,12 +284,13 @@ cifs_disable_secondary_channels(struct cifs_ses *s=
es)
> >       if (chan_count =3D=3D 1)
> >               goto done;
> >
> >-      ses->chan_count =3D 1;
> >-
> >-      /* for all secondary channels reset the need reconnect bit */
> >-      ses->chans_need_reconnect &=3D 1;
> >+      // Update the chan_count to the new maximum
> >+      if (from_reconfigure)
> >+              ses->chan_count =3D ses->chan_max;
> >+      else
> >+              ses->chan_count =3D 1;
> >
> >-      for (i =3D 1; i < chan_count; i++) {
> >+      for (i =3D ses->chan_max ; i < chan_count; i++) {
> >               iface =3D ses->chans[i].iface;
> >               server =3D ses->chans[i].server;
> >
> >@@ -318,6 +322,15 @@ cifs_disable_secondary_channels(struct cifs_ses *se=
s)
> >               spin_lock(&ses->chan_lock);
> >       }
> >
> >+      /* For extra secondary channels, reset the need reconnect bit */
> >+      if (ses->chan_count =3D=3D 1) {
> >+              cifs_server_dbg(VFS, "server does not support multichanne=
l anymore. Disable all other channels\n");
> >+              ses->chans_need_reconnect &=3D 1;
> >+      } else {
> >+              cifs_server_dbg(VFS, "Disable extra secondary channels\n"=
);
> >+              ses->chans_need_reconnect &=3D ((1UL << ses->chan_max) - =
1);
> >+      }
> >+
> > done:
> >       spin_unlock(&ses->chan_lock);
> > }
> >diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> >index c3b9d3f6210f..bf9a8dc0e8fc 100644
> >--- a/fs/smb/client/smb2pdu.c
> >+++ b/fs/smb/client/smb2pdu.c
> >@@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2=
_cmd,
> > static int
> > cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server,
> >-                        bool from_reconnect)
> >+                        bool from_reconnect, bool from_reconfigure)
> > {
> >       struct TCP_Server_Info *pserver;
> >       unsigned int chan_index;
> >@@ -206,10 +206,49 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >               return -EHOSTDOWN;
> >       }
> >
> >-      cifs_server_dbg(VFS,
> >-              "server does not support multichannel anymore. Disable al=
l other channels\n");
> >-      cifs_disable_secondary_channels(ses);
> >+      cifs_decrease_secondary_channels(ses, from_reconfigure);
> >
> >+      return 0;
> >+}
> >+
> >+/**
> >+ * smb3_sync_ses_channels - Synchronize session channels
> >+ * with new configuration (cifs_sb_info version)
> >+ * @cifs_sb: pointer to the CIFS superblock info structure
> >+ * Returns 0 on success or -EINVAL if scaling is already in progress.
> >+ */
> >+int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb)
> >+{
> >+      struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> >+      struct smb3_fs_context *ctx =3D cifs_sb->ctx;
> >+      bool from_reconnect =3D false;
> >+
> >+      /* Prevent concurrent scaling operations */
> >+      spin_lock(&ses->ses_lock);
> >+      if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> >+              spin_unlock(&ses->ses_lock);
> >+              return -EINVAL;
> >+      }
> >+      ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> >+      spin_unlock(&ses->ses_lock);
> >+
> >+      /*
> >+       * If the old max_channels is less than the new chan_max,
> >+       * try to add channels to reach the new maximum.
> >+       * Otherwise, disable or skip extra channels to match the new con=
figuration.
> >+       */
> >+      if (ctx->max_channels < ses->chan_max) {
> >+              mutex_unlock(&ses->session_mutex);
> >+              cifs_try_adding_channels(ses);
> >+              mutex_lock(&ses->session_mutex);
> >+      } else {
> >+              cifs_chan_skip_or_disable(ses, ses->server, from_reconnec=
t, true);
> >+      }
> >+
> >+      /* Clear scaling flag after operation */
> >+      spin_lock(&ses->ses_lock);
> >+      ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
> >+      spin_unlock(&ses->ses_lock);
> >
> >       return 0;
> > }
> >@@ -356,7 +395,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon=
 *tcon,
> >       if (ses->chan_count > 1 &&
> >           !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> >               rc =3D cifs_chan_skip_or_disable(ses, server,
> >-                                             from_reconnect);
> >+                                             from_reconnect, false);
> >               if (rc) {
> >                       mutex_unlock(&ses->session_mutex);
> >                       goto out;
> >@@ -439,7 +478,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon=
 *tcon,
> >                        */
> >
> >                       rc =3D cifs_chan_skip_or_disable(ses, server,
> >-                                                     from_reconnect);
> >+                                                     from_reconnect, fa=
lse);
> >                       goto skip_add_channels;
> >               } else if (rc)
> >                       cifs_dbg(FYI, "%s: failed to query server interfa=
ces: %d\n",
>
> (for all hunks above) Can we stick to /* */ comments instead of //
> please?
>
> >@@ -1105,8 +1144,7 @@ SMB2_negotiate(const unsigned int xid,
> >               req->SecurityMode =3D 0;
> >
> >       req->Capabilities =3D cpu_to_le32(server->vals->req_capabilities)=
;
> >-      if (ses->chan_max > 1)
> >-              req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_=
CHANNEL);
> >+      req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL)=
;
> >
> >       /* ClientGUID must be zero for SMB2.02 dialect */
> >       if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> >@@ -1310,10 +1348,8 @@ int smb3_validate_negotiate(const unsigned int xi=
d, struct cifs_tcon *tcon)
> >       if (!pneg_inbuf)
> >               return -ENOMEM;
> >
> >-      pneg_inbuf->Capabilities =3D
> >-                      cpu_to_le32(server->vals->req_capabilities);
> >-      if (tcon->ses->chan_max > 1)
> >-              pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP=
_MULTI_CHANNEL);
> >+      pneg_inbuf->Capabilities =3D cpu_to_le32(server->vals->req_capabi=
lities);
> >+      pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_C=
HANNEL);
>
> This effectively makes query_interfaces worker run even with
> max_channels=3D1 -- just a heads up because it didn't look like your
> original intention.
>
I discussed this with Rajasi during my review. We should probably have
a comment in the code somewhere about this behaviour.
We could disable the worker when multichannel gets disabled, and
enable it when multichannel gets enabled.
However, that needs careful changes. I didn't think that a worker to
refresh server interfaces every ten minutes is such a big deal. So I
was okay with this.
Perhaps we can fix this in a future patch.

>
> Cheers,
>
> Enzo
>


--=20
Regards,
Shyam
