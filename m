Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64175224D6
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758651137; cv=none; b=i4Vx+xkK33E3HVProL71QS8U0QRMe27i4nASEEjCZPu8ChQa3jQvg1AcYbA4iPrmKSovifbcTyOhsEro69mW1o59BQFZpOs7sYU1UcUAYcxQllrqjuJ0cSZo8sLywveEmBL0o4gDhwACTJ+mYqJFJHE3dqw4iJvO/DpeuEhD2Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758651137; c=relaxed/simple;
	bh=e3bpqXHfMC9UKjbnnIubk1Yemt/TIFANrtKuL7OEVec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/EdzRkypbq1cOv7glmZYFbI6KCzNoT8BqjJqwUlBS+7rmsugtey1mLWurRpqOyrlFMO1kaaEihDIXQqpurNwCI3DLftXTrcakXDYJTS3x4OHTQtNE8zfOP0N7vklqFNtLdtDO4XpGNcT1fP6lfXEB+rS8VJmpImkrtH9CLC/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MqQN+dfk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NtOr7NJs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MqQN+dfk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NtOr7NJs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MqQN+dfk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NtOr7NJs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MqQN+dfk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NtOr7NJs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 900531F7E4;
	Tue, 23 Sep 2025 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758651131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBLvQbCD+EnZHsnnhHpyQNAIGqJcP9/fpsVc7onYFzs=;
	b=MqQN+dfkJQ9VuHubeJCh4IpOdH0+htcLa5mDXLM47AZRc+iveeyrk/Hd3FcJ9/YiwbVMGG
	87HM7stiBYqIwGS9qL7YJPCG6YjK0TLgLORxochPhUm7SkC1/3IpBNn6EWnjl9a+t7PSbY
	rOiRfD+64LaVDu44Dy0pmvSwCcioKj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758651131;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBLvQbCD+EnZHsnnhHpyQNAIGqJcP9/fpsVc7onYFzs=;
	b=NtOr7NJsX43gKGgByBUHO0sAQer8DENmQCAwN8HH/PRFye7+ykuT2oY9K0l/RfmeOKW27t
	4YEIp4oGbw111jDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758651131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBLvQbCD+EnZHsnnhHpyQNAIGqJcP9/fpsVc7onYFzs=;
	b=MqQN+dfkJQ9VuHubeJCh4IpOdH0+htcLa5mDXLM47AZRc+iveeyrk/Hd3FcJ9/YiwbVMGG
	87HM7stiBYqIwGS9qL7YJPCG6YjK0TLgLORxochPhUm7SkC1/3IpBNn6EWnjl9a+t7PSbY
	rOiRfD+64LaVDu44Dy0pmvSwCcioKj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758651131;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBLvQbCD+EnZHsnnhHpyQNAIGqJcP9/fpsVc7onYFzs=;
	b=NtOr7NJsX43gKGgByBUHO0sAQer8DENmQCAwN8HH/PRFye7+ykuT2oY9K0l/RfmeOKW27t
	4YEIp4oGbw111jDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F539132C9;
	Tue, 23 Sep 2025 18:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DK0rMvri0mjgDgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 23 Sep 2025 18:12:10 +0000
Date: Tue, 23 Sep 2025 15:12:08 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: RAJASI MANDAL <rajasimandalos@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, ronnie sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath S M <bharathsm@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: Re: [PATCH 2/2] cifs: client: allow changing multichannel mount
 options on remount
Message-ID: <vs3r33bqfug44hyax2o4zxtuop7m5w3npfbvm7belb6veto3dx@dx5pihhf6ovn>
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <20250922082417.816331-2-rajasimandalos@gmail.com>
 <4htyleuklcdod3togdqcjl5w7g3j5cmwcc4bww5knlwgwhtsbd@a7s2fa2nvcup>
 <CAEY6_V3RanNnjd=QkaZO=QoLLfiOhRGg7cCxHe2xGB1A05hEhQ@mail.gmail.com>
 <vwwwvo2ehhlvq64vzp3j62asaryc6kkw34rjnkf7ozssv3hzyd@vwmxraotzwo6>
 <CAH2r5msS2hrFOhjGddNUrAU3ZTSPyVwLv8w5c39cNKeH2MdgqA@mail.gmail.com>
 <23xlv6coiyaxwdfitprfvwfmipi5avk4of27hqypukibm2mkop@44sd5ici4sis>
 <CAH2r5ms3W5S5tozMAk2NUj6tBEb=OCFK=OTO+TcYrmu_vncGTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5ms3W5S5tozMAk2NUj6tBEb=OCFK=OTO+TcYrmu_vncGTw@mail.gmail.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,samba.org,manguebit.org,microsoft.com,talpey.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 09/23, Steve French wrote:
>The interface info in debug data that we get at mount time I have found
>useful for debugging non multichannel cases. I don't have strong opinions
>about whether requerying it occasionally in non multichannel case is of
>value but clearly has been useful to get it at mount time to populate Debug
>data

Steve, sorry, are you reading what I'm proposing/saying here?

mount.cifs -o multichannel,...
-> fills debug data, starts query_interface, try/add chans, yadda yadda


mount.cifs -o nomultichannel,...
-> do nothing related to multichannel


What's so wrong/problematic with having it that way?

>Thanks,
>
>Steve
>
>On Tue, Sep 23, 2025, 1:01=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
>> On 09/23, Steve French wrote:
>> >> IMO, like I replied to Shyam, is that the worker should only run if t=
he
>> user
>> >requested multichannel.
>> >
>> >I would like it (query interfaces) to run at least once (at mount time =
)so
>> >debug data is populated properly for user, but don't mind either way ab=
out
>> >periodic queries after mount or not eg if it is run periodically every =
few
>> >hours would be no performance issue, but slight value for debugging and
>> >fail over eg if interface 1 is mounted but doesn't become available in a
>> >few hours and causes reconnect which fails, client might be able to use
>> >information from query interfaces to reconnect to interface 2?!
>>
>> This goes completely against to what a user requested.
>>
>> Why would you care about debugging multichannel or concerned about
>> connecting to another interface if you didn't even request multichannel
>> in first place?
>>
>> Sure we can automate/autodetect things, but we should do so according to
>> what the user requested.
>>
>> And if we want to do multichannel debugging, it should be
>> created/enhanced in cifs_debug.c
>>
>> >Thanks,
>> >
>> >Steve
>> >
>> >On Tue, Sep 23, 2025, 12:32=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.=
de> wrote:
>> >
>> >> On 09/23, RAJASI MANDAL wrote:
>> >> >> (for all hunks above) Can we stick to /* */ comments instead of //
>> >> >please?
>> >> >
>> >> >Yes sure I will do that.
>> >> >
>> >> >> This effectively makes query_interfaces worker run even with
>> >> >max_channels=3D1 -- just a heads up because it didn't look like your
>> >> >original intention.
>> >> >
>> >> >This change ensures that the multichannel option can be enabled duri=
ng
>> >> >remounts, even if it wasn't specified during the initial mount.
>> >> >During the initial mount, if the user does not pass the multichannel
>> >> >option, the client does not advertise multichannel capability to the
>> >> >server.
>> >> >Since remounts do not trigger a fresh negotiation with the server, i=
t's
>> >> not
>> >> >possible to enable multichannel at that stage if it was previously
>> >> omitted.
>> >> >
>> >> >To address this, the client is modified to *advertise multichannel
>> >> >capability by default*, regardless of whether the option was explici=
tly
>> >> >provided during the initial mount.
>> >>
>> >> Yes, and I agree with that change.
>> >>
>> >> I was just mentioning that because cifs_get_tcon() starts the
>> >> query_interface worker based on that flag (and not on ses->chan_max, =
for
>> >> example):
>> >>
>> >>          if (ses->server->dialect >=3D SMB30_PROT_ID &&
>> >>              (ses->server->capabilities &
>> SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
>> >>                  /* schedule query interfaces poll */
>> >>                  queue_delayed_work(cifsiod_wq, &tcon->query_interfac=
es,
>> >>                                     (SMB_INTERFACE_POLL_INTERVAL * HZ=
));
>> >>         }
>> >>
>> >> IMO, like I replied to Shyam, is that the worker should only run if t=
he
>> >> user requested multichannel.
>> >>
>> >> I'd suggest changing it to "if (ses->chan_max > 1) ...", and then also
>> >> add a call to queue_delayed_work() on reconfigure when chan_max chang=
es.
>> >>
>> >>
>> >> Cheers,
>> >>
>> >> Enzo
>> >>
>> >> >On Mon, Sep 22, 2025 at 8:43=E2=80=AFPM Enzo Matsumiya <ematsumiya@s=
use.de>
>> >> wrote:
>> >> >
>> >> >> On 09/22, rajasimandalos@gmail.com wrote:
>> >> >> >From: Rajasi Mandal <rajasimandal@microsoft.com>
>> >> >> >
>> >> >> >Previously, the client did not properly update the session's chan=
nel
>> >> >> >state when multichannel or max_channels mount options were changed
>> >> >> >during remount. This led to inconsistent behavior and prevented
>> >> >> >enabling or disabling multichannel support without a full
>> >> >> >unmount/remount.
>> >> >> >
>> >> >> >Enable dynamic reconfiguration of multichannel and max_channels
>> >> >> >options during remount by introducing smb3_sync_ses_chan_max() to
>> >> >> >safely update the session's chan_max field, and
>> >> smb3_sync_ses_channels()
>> >> >> >to synchronize the session's channels with the new configuration.
>> >> >> >Replace cifs_disable_secondary_channels() with
>> >> >> >cifs_decrease_secondary_channels(), which now takes a
>> from_reconfigure
>> >> >> >argument for more flexible channel cleanup. Update the remount lo=
gic
>> >> >> >to detect changes in multichannel or max_channels and trigger the
>> >> >> >appropriate session/channel updates.
>> >> >> >
>> >> >> >With this change, users can safely change multichannel and
>> >> >> >max_channels options on remount, and the client will correctly
>> adjust
>> >> >> >the session's channel state to match the new configuration.
>> >> >> >
>> >> >> >Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
>> >> >> >---
>> >> >> > fs/smb/client/cifsproto.h  |  2 +-
>> >> >> > fs/smb/client/fs_context.c | 29 ++++++++++++++++++
>> >> >> > fs/smb/client/fs_context.h |  2 +-
>> >> >> > fs/smb/client/sess.c       | 35 +++++++++++++++-------
>> >> >> > fs/smb/client/smb2pdu.c    | 60
>> ++++++++++++++++++++++++++++++--------
>> >> >> > fs/smb/client/smb2pdu.h    |  2 ++
>> >> >> > 6 files changed, 105 insertions(+), 25 deletions(-)
>> >> >>
>> >> >> I think the fix is necessary, and the implementation works (at lea=
st
>> >> >> with the simple case I tested).  I just think we now have too many
>> >> >> functions related to channel adding/removing/updating and they're =
all
>> >> >> too similar.  IMHO they could all be merged into a single "update
>> >> >> channels" one.
>> >> >>
>> >> >> Do you think it's possible to do that?  Probably would require a b=
it
>> >> >> more work, but at least we would end up with a centralized place to
>> deal
>> >> >> with channel management.
>> >> >>
>> >> >> >diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>> >> >> >index e8fba98690ce..ec3118457b26 100644
>> >> >> >--- a/fs/smb/client/cifsproto.h
>> >> >> >+++ b/fs/smb/client/cifsproto.h
>> >> >> >@@ -667,7 +667,7 @@ bool
>> >> >> > cifs_chan_is_iface_active(struct cifs_ses *ses,
>> >> >> >                         struct TCP_Server_Info *server);
>> >> >> > void
>> >> >> >-cifs_disable_secondary_channels(struct cifs_ses *ses);
>> >> >> >+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool
>> >> >> from_reconfigure);
>> >> >> > void
>> >> >> > cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_I=
nfo
>> >> >> *server);
>> >> >> > int
>> >> >> >diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_contex=
t.c
>> >> >> >index 43552b44f613..96e80c70f25d 100644
>> >> >> >--- a/fs/smb/client/fs_context.c
>> >> >> >+++ b/fs/smb/client/fs_context.c
>> >> >> >@@ -1015,6 +1015,22 @@ int smb3_sync_session_ctx_passwords(struct
>> >> >> cifs_sb_info *cifs_sb, struct cifs_se
>> >> >> >       return 0;
>> >> >> > }
>> >> >> >
>> >> >> >+/**
>> >> >> >+ * smb3_sync_ses_chan_max - Synchronize the session's maximum
>> channel
>> >> >> count
>> >> >> >+ * @ses: pointer to the old CIFS session structure
>> >> >> >+ * @max_channels: new maximum number of channels to allow
>> >> >> >+ *
>> >> >> >+ * Updates the session's chan_max field to the new value,
>> protecting
>> >> the
>> >> >> update
>> >> >> >+ * with the session's channel lock. This should be called whenev=
er
>> the
>> >> >> maximum
>> >> >> >+ * allowed channels for a session changes (e.g., after a remount=
 or
>> >> >> reconfigure).
>> >> >> >+ */
>> >> >> >+void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int
>> >> >> max_channels)
>> >> >> >+{
>> >> >> >+      spin_lock(&ses->chan_lock);
>> >> >> >+      ses->chan_max =3D max_channels;
>> >> >> >+      spin_unlock(&ses->chan_lock);
>> >> >> >+}
>> >> >> >+
>> >> >> > static int smb3_reconfigure(struct fs_context *fc)
>> >> >> > {
>> >> >> >       struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
>> >> >> >@@ -1097,6 +1113,18 @@ static int smb3_reconfigure(struct fs_cont=
ext
>> >> *fc)
>> >> >> >               ses->password2 =3D new_password2;
>> >> >> >       }
>> >> >> >
>> >> >> >+      /*
>> >> >> >+       * If multichannel or max_channels has changed, update the
>> >> >> session's channels accordingly.
>> >> >> >+       * This may add or remove channels to match the new
>> >> configuration.
>> >> >> >+       */
>> >> >> >+      if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
>> >> >> >+              (ctx->max_channels !=3D cifs_sb->ctx->max_channels=
)) {
>> >> >> >+              //Synchronize ses->chan_max with the new mount
>> context
>> >> >> >+              smb3_sync_ses_chan_max(ses, ctx->max_channels);
>> >> >> >+              //Now update the session's channels to match the n=
ew
>> >> >> configuration
>> >> >> >+              rc =3D smb3_sync_ses_channels(cifs_sb);
>> >> >> >+      }
>> >> >> >+
>> >> >> >       mutex_unlock(&ses->session_mutex);
>> >> >> >
>> >> >> >       STEAL_STRING(cifs_sb, ctx, domainname);
>> >> >> >@@ -1110,6 +1138,7 @@ static int smb3_reconfigure(struct fs_conte=
xt
>> >> *fc)
>> >> >> >       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>> >> >> >       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
>> >> >> >       smb3_update_mnt_flags(cifs_sb);
>> >> >> >+
>> >> >> > #ifdef CONFIG_CIFS_DFS_UPCALL
>> >> >> >       if (!rc)
>> >> >> >               rc =3D dfs_cache_remount_fs(cifs_sb);
>> >> >> >diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_contex=
t.h
>> >> >> >index b0fec6b9a23b..a75185858285 100644
>> >> >> >--- a/fs/smb/client/fs_context.h
>> >> >> >+++ b/fs/smb/client/fs_context.h
>> >> >> >@@ -371,7 +371,7 @@ static inline struct smb3_fs_context
>> >> >> *smb3_fc2context(const struct fs_context *f
>> >> >> > extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx,
>> struct
>> >> >> smb3_fs_context *ctx);
>> >> >> > extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info
>> >> *cifs_sb,
>> >> >> struct cifs_ses *ses);
>> >> >> > extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
>> >> >> >-
>> >> >> >+extern void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned
>> int
>> >> >> max_channels);
>> >> >> > /*
>> >> >> >  * max deferred close timeout (jiffies) - 2^30
>> >> >> >  */
>> >> >> >diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
>> >> >> >index 0a8c2fcc9ded..42b5481c884a 100644
>> >> >> >--- a/fs/smb/client/sess.c
>> >> >> >+++ b/fs/smb/client/sess.c
>> >> >> >@@ -264,13 +264,16 @@ int cifs_try_adding_channels(struct cifs_ses
>> >> *ses)
>> >> >> >       return new_chan_count - old_chan_count;
>> >> >> > }
>> >> >> >
>> >> >> >-/*
>> >> >> >- * called when multichannel is disabled by the server.
>> >> >> >- * this always gets called from smb2_reconnect
>> >> >> >- * and cannot get called in parallel threads.
>> >> >> >+/**
>> >> >> >+ * cifs_decrease_secondary_channels - Reduce the number of active
>> >> >> secondary channels
>> >> >> >+ * @ses: pointer to the CIFS session structure
>> >> >> >+ * @from_reconfigure: if true, only reduce to chan_max; if false,
>> >> reduce
>> >> >> to a single channel
>> >> >> >+ *
>> >> >> >+ * This function disables and cleans up extra secondary channels
>> for a
>> >> >> CIFS session.
>> >> >> >+ * If called during reconfiguration, it reduces the channel count
>> to
>> >> the
>> >> >> new maximum (chan_max).
>> >> >> >+ * Otherwise, it disables all but the primary channel.
>> >> >> >  */
>> >> >> >-void
>> >> >> >-cifs_disable_secondary_channels(struct cifs_ses *ses)
>> >> >> >+void cifs_decrease_secondary_channels(struct cifs_ses *ses, bool
>> >> >> from_reconfigure)
>> >> >> > {
>> >> >> >       int i, chan_count;
>> >> >> >       struct TCP_Server_Info *server;
>> >> >> >@@ -281,12 +284,13 @@ cifs_disable_secondary_channels(struct
>> cifs_ses
>> >> >> *ses)
>> >> >> >       if (chan_count =3D=3D 1)
>> >> >> >               goto done;
>> >> >> >
>> >> >> >-      ses->chan_count =3D 1;
>> >> >> >-
>> >> >> >-      /* for all secondary channels reset the need reconnect bit=
 */
>> >> >> >-      ses->chans_need_reconnect &=3D 1;
>> >> >> >+      // Update the chan_count to the new maximum
>> >> >> >+      if (from_reconfigure)
>> >> >> >+              ses->chan_count =3D ses->chan_max;
>> >> >> >+      else
>> >> >> >+              ses->chan_count =3D 1;
>> >> >> >
>> >> >> >-      for (i =3D 1; i < chan_count; i++) {
>> >> >> >+      for (i =3D ses->chan_max ; i < chan_count; i++) {
>> >> >> >               iface =3D ses->chans[i].iface;
>> >> >> >               server =3D ses->chans[i].server;
>> >> >> >
>> >> >> >@@ -318,6 +322,15 @@ cifs_disable_secondary_channels(struct cifs_=
ses
>> >> *ses)
>> >> >> >               spin_lock(&ses->chan_lock);
>> >> >> >       }
>> >> >> >
>> >> >> >+      /* For extra secondary channels, reset the need reconnect
>> bit */
>> >> >> >+      if (ses->chan_count =3D=3D 1) {
>> >> >> >+              cifs_server_dbg(VFS, "server does not support
>> >> multichannel
>> >> >> anymore. Disable all other channels\n");
>> >> >> >+              ses->chans_need_reconnect &=3D 1;
>> >> >> >+      } else {
>> >> >> >+              cifs_server_dbg(VFS, "Disable extra secondary
>> >> channels\n");
>> >> >> >+              ses->chans_need_reconnect &=3D ((1UL << ses->chan_=
max)
>> -
>> >> 1);
>> >> >> >+      }
>> >> >> >+
>> >> >> > done:
>> >> >> >       spin_unlock(&ses->chan_lock);
>> >> >> > }
>> >> >> >diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> >> >> >index c3b9d3f6210f..bf9a8dc0e8fc 100644
>> >> >> >--- a/fs/smb/client/smb2pdu.c
>> >> >> >+++ b/fs/smb/client/smb2pdu.c
>> >> >> >@@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le=
16
>> >> >> smb2_cmd,
>> >> >> > static int
>> >> >> > cifs_chan_skip_or_disable(struct cifs_ses *ses,
>> >> >> >                         struct TCP_Server_Info *server,
>> >> >> >-                        bool from_reconnect)
>> >> >> >+                        bool from_reconnect, bool from_reconfigu=
re)
>> >> >> > {
>> >> >> >       struct TCP_Server_Info *pserver;
>> >> >> >       unsigned int chan_index;
>> >> >> >@@ -206,10 +206,49 @@ cifs_chan_skip_or_disable(struct cifs_ses
>> *ses,
>> >> >> >               return -EHOSTDOWN;
>> >> >> >       }
>> >> >> >
>> >> >> >-      cifs_server_dbg(VFS,
>> >> >> >-              "server does not support multichannel anymore.
>> Disable
>> >> all
>> >> >> other channels\n");
>> >> >> >-      cifs_disable_secondary_channels(ses);
>> >> >> >+      cifs_decrease_secondary_channels(ses, from_reconfigure);
>> >> >> >
>> >> >> >+      return 0;
>> >> >> >+}
>> >> >> >+
>> >> >> >+/**
>> >> >> >+ * smb3_sync_ses_channels - Synchronize session channels
>> >> >> >+ * with new configuration (cifs_sb_info version)
>> >> >> >+ * @cifs_sb: pointer to the CIFS superblock info structure
>> >> >> >+ * Returns 0 on success or -EINVAL if scaling is already in
>> progress.
>> >> >> >+ */
>> >> >> >+int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb)
>> >> >> >+{
>> >> >> >+      struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
>> >> >> >+      struct smb3_fs_context *ctx =3D cifs_sb->ctx;
>> >> >> >+      bool from_reconnect =3D false;
>> >> >> >+
>> >> >> >+      /* Prevent concurrent scaling operations */
>> >> >> >+      spin_lock(&ses->ses_lock);
>> >> >> >+      if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
>> >> >> >+              spin_unlock(&ses->ses_lock);
>> >> >> >+              return -EINVAL;
>> >> >> >+      }
>> >> >> >+      ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
>> >> >> >+      spin_unlock(&ses->ses_lock);
>> >> >> >+
>> >> >> >+      /*
>> >> >> >+       * If the old max_channels is less than the new chan_max,
>> >> >> >+       * try to add channels to reach the new maximum.
>> >> >> >+       * Otherwise, disable or skip extra channels to match the =
new
>> >> >> configuration.
>> >> >> >+       */
>> >> >> >+      if (ctx->max_channels < ses->chan_max) {
>> >> >> >+              mutex_unlock(&ses->session_mutex);
>> >> >> >+              cifs_try_adding_channels(ses);
>> >> >> >+              mutex_lock(&ses->session_mutex);
>> >> >> >+      } else {
>> >> >> >+              cifs_chan_skip_or_disable(ses, ses->server,
>> >> >> from_reconnect, true);
>> >> >> >+      }
>> >> >> >+
>> >> >> >+      /* Clear scaling flag after operation */
>> >> >> >+      spin_lock(&ses->ses_lock);
>> >> >> >+      ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
>> >> >> >+      spin_unlock(&ses->ses_lock);
>> >> >> >
>> >> >> >       return 0;
>> >> >> > }
>> >> >> >@@ -356,7 +395,7 @@ smb2_reconnect(__le16 smb2_command, struct
>> >> cifs_tcon
>> >> >> *tcon,
>> >> >> >       if (ses->chan_count > 1 &&
>> >> >> >           !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL=
))
>> {
>> >> >> >               rc =3D cifs_chan_skip_or_disable(ses, server,
>> >> >> >-                                             from_reconnect);
>> >> >> >+                                             from_reconnect,
>> false);
>> >> >> >               if (rc) {
>> >> >> >                       mutex_unlock(&ses->session_mutex);
>> >> >> >                       goto out;
>> >> >> >@@ -439,7 +478,7 @@ smb2_reconnect(__le16 smb2_command, struct
>> >> cifs_tcon
>> >> >> *tcon,
>> >> >> >                        */
>> >> >> >
>> >> >> >                       rc =3D cifs_chan_skip_or_disable(ses, serv=
er,
>> >> >> >-
>>  from_reconnect);
>> >> >> >+
>>  from_reconnect,
>> >> >> false);
>> >> >> >                       goto skip_add_channels;
>> >> >> >               } else if (rc)
>> >> >> >                       cifs_dbg(FYI, "%s: failed to query server
>> >> >> interfaces: %d\n",
>> >> >>
>> >> >> (for all hunks above) Can we stick to /* */ comments instead of //
>> >> >> please?
>> >> >>
>> >> >> >@@ -1105,8 +1144,7 @@ SMB2_negotiate(const unsigned int xid,
>> >> >> >               req->SecurityMode =3D 0;
>> >> >> >
>> >> >> >       req->Capabilities =3D
>> cpu_to_le32(server->vals->req_capabilities);
>> >> >> >-      if (ses->chan_max > 1)
>> >> >> >-              req->Capabilities |=3D
>> >> >> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>> >> >> >+      req->Capabilities |=3D
>> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>> >> >> >
>> >> >> >       /* ClientGUID must be zero for SMB2.02 dialect */
>> >> >> >       if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
>> >> >> >@@ -1310,10 +1348,8 @@ int smb3_validate_negotiate(const unsigned
>> int
>> >> >> xid, struct cifs_tcon *tcon)
>> >> >> >       if (!pneg_inbuf)
>> >> >> >               return -ENOMEM;
>> >> >> >
>> >> >> >-      pneg_inbuf->Capabilities =3D
>> >> >> >-                      cpu_to_le32(server->vals->req_capabilities=
);
>> >> >> >-      if (tcon->ses->chan_max > 1)
>> >> >> >-              pneg_inbuf->Capabilities |=3D
>> >> >> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>> >> >> >+      pneg_inbuf->Capabilities =3D
>> >> >> cpu_to_le32(server->vals->req_capabilities);
>> >> >> >+      pneg_inbuf->Capabilities |=3D
>> >> >> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
>> >> >>
>> >> >> This effectively makes query_interfaces worker run even with
>> >> >> max_channels=3D1 -- just a heads up because it didn't look like yo=
ur
>> >> >> original intention.
>> >> >>
>> >> >>
>> >> >> Cheers,
>> >> >>
>> >> >> Enzo
>> >> >>
>> >>
>> >>
>>
