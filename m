Return-Path: <SRS0=9D0L=XN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38EBC4CEC9
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 02:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8287D2189D
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 02:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqZqjTvw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfIRCpE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:45:04 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:38958 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIRCpD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Sep 2019 22:45:03 -0400
Received: by mail-io1-f41.google.com with SMTP id a1so12600536ioc.6
        for <linux-cifs@vger.kernel.org>; Tue, 17 Sep 2019 19:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0GL6viqBFBne3ZWWYknnhC6uRCrght42rBxeGCkJ9K0=;
        b=iqZqjTvwH1MOPDwfbJ90AN1EffbgW6XePbE6F/vwBz99P0s+qm2/MIsTKtExMJvvUR
         3KkGwNEhCtjrbc/QVnhWc2AZJFTrY8x7CvG5F52E80doJFhUPJ2U6voPVnImYlkpJpal
         EB6ChH+ZAZUGD2vVPgya/OOmv5oBBAan/IGqI3o4n4oF0XlgdccqEL1pnbXm/afzPYMU
         iKupAQyGu9qGdbu8fGUxdSw42/W3zJu1ozG0Vyi4nxKM1enhDO6jbPue7mPs72HtfCke
         mZpczRy9a4INKueyDZe6vwsGZrxLg7MoNroxPBnn8nfde8SFV8SZxyL1dgBVJs2tPoPZ
         9uVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0GL6viqBFBne3ZWWYknnhC6uRCrght42rBxeGCkJ9K0=;
        b=bFlD8ZVJdQMpPEp3JRXNUZx59vzEVNC4zz0Kkcdt02bzBmTPrip7fjnxyCWfxdhU28
         M7q1iab9hxXW//LKTVPkgIMTXbeXenz6nTMCuMYKCBqQ0UPABKGy7nRYbQ83sOFGiHln
         BOIbV07AEDeK956XFn6ux46NMx/6QUAxblfmNMg4sjfjs0wEnq57PUz5UpJnDshFxF9H
         1TtTZlSEefesREXrPTkqp5nnwejxx2Fj7EdHdnbV8oiPQleWUGHRXqJylL6U7Dhyvb/4
         xuoeMNWKBdcRyWximibKsktEts3M2Tdd0pY9Aejew+BnsAiji+36oUFeJ6xLD1t9jyAf
         xNdg==
X-Gm-Message-State: APjAAAUdmaYfZcsBW1+bk9iZzvZjpaAdAYhR06e1nE5II9YQ11EYJ4IY
        mtyAYRamurCiClfqFRjg5n7RDsusmZI1DLQnB+0ovCOp1Hc=
X-Google-Smtp-Source: APXvYqxMRR0DR73Sj4sXfOjrUYU0mfoU0XTzYxR038RraU8y3v6MRjPp6plV4CFB683DuGzZuxREw5vYKhVMXzwQTfo=
X-Received: by 2002:a6b:a0d:: with SMTP id z13mr2436960ioi.5.1568774701093;
 Tue, 17 Sep 2019 19:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190917221451.18065-1-aaptel@suse.com> <20190917235114.26247-1-aaptel@suse.com>
In-Reply-To: <20190917235114.26247-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Sep 2019 21:44:49 -0500
Message-ID: <CAH2r5msndZMzJyOSDD16+=Y_b9MC-dJAuKGNWk5wzajxUcDS8A@mail.gmail.com>
Subject: Re: [WIP v3] multichannel
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Checkpatch had a few minor indentation complaints and then probably a
valid one about not using %px and these two as well:

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#1245: FILE: fs/cifs/transport.c:999:
+        uint index = ((unsigned)get_random_int()) % ses->chan_count;

WARNING: Missing a blank line after declarations
#1246: FILE: fs/cifs/transport.c:1000:
+        uint index = ((unsigned)get_random_int()) % ses->chan_count;
+        cifs_dbg(VFS, "XXX: send/recv: using random channel %d", index);

On Tue, Sep 17, 2019 at 6:51 PM Aurelien Aptel <aaptel@suse.com> wrote:
>
> WIP WIP WIP WIP WIP WIP
>
> to test, mount server with multiple interface with
>
>     -o vers=3.11,multichannel,max_channels=3
>
> WIP WIP WIP WIP WIP WIP
>
> changes since last version:
> - reuse client guid from master tcp connection
> - now works against samba & windows server
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/cifs_debug.c    |   6 +-
>  fs/cifs/cifs_spnego.c   |   2 +-
>  fs/cifs/cifsglob.h      |  30 ++++++-
>  fs/cifs/cifsproto.h     |   8 ++
>  fs/cifs/connect.c       |  84 +++++++++++++++----
>  fs/cifs/sess.c          | 216 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/smb2misc.c      |  37 ++++++---
>  fs/cifs/smb2ops.c       |  13 ++-
>  fs/cifs/smb2pdu.c       | 106 ++++++++++++++----------
>  fs/cifs/smb2proto.h     |   3 +-
>  fs/cifs/smb2transport.c | 162 +++++++++++++++++++++++++++---------
>  fs/cifs/transport.c     |  14 +++-
>  12 files changed, 562 insertions(+), 119 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 0b4eee3bed66..ef454170f37d 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -410,8 +410,12 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>                                 seq_printf(m, "\n\tServer interfaces: %zu\n",
>                                            ses->iface_count);
>                         for (j = 0; j < ses->iface_count; j++) {
> +                               struct cifs_server_iface *iface;
> +                               iface = &ses->iface_list[j];
>                                 seq_printf(m, "\t%d)", j);
> -                               cifs_dump_iface(m, &ses->iface_list[j]);
> +                               cifs_dump_iface(m, iface);
> +                               if (is_ses_using_iface(ses, iface))
> +                                       seq_puts(m, "\t\t[CONNECTED]\n");
>                         }
>                         spin_unlock(&ses->iface_lock);
>                 }
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 7f01c6e60791..7b9b876b513b 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -98,7 +98,7 @@ struct key_type cifs_spnego_key_type = {
>  struct key *
>  cifs_get_spnego_key(struct cifs_ses *sesInfo)
>  {
> -       struct TCP_Server_Info *server = sesInfo->server;
> +       struct TCP_Server_Info *server = cifs_ses_server(sesInfo);
>         struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
>         struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
>         char *description, *dp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 54e204589cb9..441970293697 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -230,7 +230,8 @@ struct smb_version_operations {
>         bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
>         /* setup request: allocate mid, sign message */
>         struct mid_q_entry *(*setup_request)(struct cifs_ses *,
> -                                               struct smb_rqst *);
> +                                            struct TCP_Server_Info *,
> +                                            struct smb_rqst *);
>         /* setup async request: allocate mid, sign message */
>         struct mid_q_entry *(*setup_async_request)(struct TCP_Server_Info *,
>                                                 struct smb_rqst *);
> @@ -590,6 +591,9 @@ struct smb_vol {
>         bool resilient:1; /* noresilient not required since not fored for CA */
>         bool domainauto:1;
>         bool rdma:1;
> +       bool multichannel:1;
> +       bool use_client_guid:1;
> +       u8 client_guid[SMB2_CLIENT_GUID_SIZE]; /* reuse existing guid from master channel */
>         unsigned int bsize;
>         unsigned int rsize;
>         unsigned int wsize;
> @@ -606,6 +610,7 @@ struct smb_vol {
>         __u64 snapshot_time; /* needed for timewarp tokens */
>         __u32 handle_timeout; /* persistent and durable handle timeout in ms */
>         unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
> +       unsigned int max_channels;
>         __u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
>         bool rootfs:1; /* if it's a SMB root file system */
>  };
> @@ -952,11 +957,17 @@ struct cifs_server_iface {
>         struct sockaddr_storage sockaddr;
>  };
>
> +struct cifs_chan {
> +       struct TCP_Server_Info *server;
> +       __u8 signkey[SMB3_SIGN_KEY_SIZE];
> +};
> +
>  /*
>   * Session structure.  One of these for each uid session with a particular host
>   */
>  struct cifs_ses {
>         struct list_head smb_ses_list;
> +       struct list_head chan_ses_list;
>         struct list_head tcon_list;
>         struct cifs_tcon *tcon_ipc;
>         struct mutex session_mutex;
> @@ -982,12 +993,15 @@ struct cifs_ses {
>         bool sign;              /* is signing required? */
>         bool need_reconnect:1; /* connection reset, uid now invalid */
>         bool domainAuto:1;
> +       bool binding:1; /* are we binding the session? */
>         __u16 session_flags;
>         __u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
>         __u8 smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
>         __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
>         __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
>
> +       __u8 binding_preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
> +
>         /*
>          * Network interfaces available on the server this session is
>          * connected to.
> @@ -1001,8 +1015,22 @@ struct cifs_ses {
>         struct cifs_server_iface *iface_list;
>         size_t iface_count;
>         unsigned long iface_last_update; /* jiffies */
> +
> +#define CIFS_MAX_CHANNELS 16
> +       struct cifs_chan chans[CIFS_MAX_CHANNELS];
> +       size_t chan_count;
> +       size_t chan_max;
>  };
>
> +static inline
> +struct TCP_Server_Info *cifs_ses_server(struct cifs_ses *ses)
> +{
> +       if (ses->binding)
> +               return ses->chans[ses->chan_count].server;
> +       else
> +               return ses->server;
> +}
> +
>  static inline bool
>  cap_unix(struct cifs_ses *ses)
>  {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 99b1b1ef558c..4cda8bba308b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -109,6 +109,7 @@ extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
>  extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
>                             char *in_buf, int flags);
>  extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
> +                               struct TCP_Server_Info *,
>                                 struct smb_rqst *);
>  extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
>                                                 struct smb_rqst *);
> @@ -241,6 +242,7 @@ extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
>                                          struct tcon_link *tlink,
>                                          struct cifs_pending_open *open);
>  extern void cifs_del_pending_open(struct cifs_pending_open *open);
> +extern struct TCP_Server_Info *cifs_get_tcp_session(struct smb_vol *vol);
>  extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
>                                  int from_reconnect);
>  extern void cifs_put_tcon(struct cifs_tcon *tcon);
> @@ -582,6 +584,12 @@ void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
>
>  extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
>                                 unsigned int *len, unsigned int *offset);
> +int cifs_try_adding_channels(struct cifs_ses *ses);
> +int cifs_ses_add_channel(struct cifs_ses *ses,
> +                               struct cifs_server_iface *iface);
> +bool is_server_using_iface(struct TCP_Server_Info *server,
> +                          struct cifs_server_iface *iface);
> +bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
>
>  void extract_unc_hostname(const char *unc, const char **h, size_t *len);
>  int copy_path_name(char *dst, const char *src);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2850c3ce4391..efd9ed46d5d6 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -97,6 +97,7 @@ enum {
>         Opt_persistent, Opt_nopersistent,
>         Opt_resilient, Opt_noresilient,
>         Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
> +       Opt_multichannel, Opt_nomultichannel,
>         Opt_compress,
>
>         /* Mount options which take numeric value */
> @@ -106,7 +107,7 @@ enum {
>         Opt_min_enc_offload,
>         Opt_blocksize, Opt_rsize, Opt_wsize, Opt_actimeo,
>         Opt_echo_interval, Opt_max_credits, Opt_handletimeout,
> -       Opt_snapshot,
> +       Opt_snapshot, Opt_max_channels,
>
>         /* Mount options which take string value */
>         Opt_user, Opt_pass, Opt_ip,
> @@ -199,6 +200,8 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_noresilient, "noresilienthandles"},
>         { Opt_domainauto, "domainauto"},
>         { Opt_rdma, "rdma"},
> +       { Opt_multichannel, "multichannel" },
> +       { Opt_nomultichannel, "nomultichannel" },
>
>         { Opt_backupuid, "backupuid=%s" },
>         { Opt_backupgid, "backupgid=%s" },
> @@ -218,6 +221,7 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_echo_interval, "echo_interval=%s" },
>         { Opt_max_credits, "max_credits=%s" },
>         { Opt_snapshot, "snapshot=%s" },
> +       { Opt_max_channels, "max_channels=%s" },
>         { Opt_compress, "compress=%s" },
>
>         { Opt_blank_user, "user=" },
> @@ -1664,6 +1668,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>
>         vol->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
>
> +       /* default to no multichannel (single server connection) */
> +       vol->multichannel = false;
> +       vol->max_channels = 1;
> +
>         if (!mountdata)
>                 goto cifs_parse_mount_err;
>
> @@ -1957,6 +1965,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                 case Opt_rdma:
>                         vol->rdma = true;
>                         break;
> +               case Opt_multichannel:
> +                       vol->multichannel = true;
> +                       break;
> +               case Opt_nomultichannel:
> +                       vol->multichannel = false;
> +                       break;
>                 case Opt_compress:
>                         vol->compression = UNKNOWN_TYPE;
>                         cifs_dbg(VFS,
> @@ -2120,6 +2134,15 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         }
>                         vol->max_credits = option;
>                         break;
> +               case Opt_max_channels:
> +                       if (get_option_ul(args, &option) || option < 1 ||
> +                               option > CIFS_MAX_CHANNELS) {
> +                               cifs_dbg(VFS, "%s: Invalid max_channels value, needs to be 1-%d\n",
> +                                        __func__, CIFS_MAX_CHANNELS);
> +                               goto cifs_parse_mount_err;
> +                       }
> +                       vol->max_channels = option;
> +                       break;
>
>                 /* String Arguments */
>
> @@ -2665,6 +2688,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
>  {
>         struct task_struct *task;
>
> +       cifs_dbg(VFS, "XXX server %px", server);
>         spin_lock(&cifs_tcp_ses_lock);
>         if (--server->srv_count > 0) {
>                 spin_unlock(&cifs_tcp_ses_lock);
> @@ -2705,7 +2729,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
>                 send_sig(SIGKILL, task, 1);
>  }
>
> -static struct TCP_Server_Info *
> +struct TCP_Server_Info *
>  cifs_get_tcp_session(struct smb_vol *volume_info)
>  {
>         struct TCP_Server_Info *tcp_ses = NULL;
> @@ -2764,7 +2788,10 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                sizeof(tcp_ses->srcaddr));
>         memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
>                 sizeof(tcp_ses->dstaddr));
> -       generate_random_uuid(tcp_ses->client_guid);
> +       if (volume_info->use_client_guid)
> +               memcpy(tcp_ses->client_guid, volume_info->client_guid, SMB2_CLIENT_GUID_SIZE);
> +       else
> +               generate_random_uuid(tcp_ses->client_guid);
>         /*
>          * at this point we are the only ones with the pointer
>          * to the struct since the kernel thread not created yet
> @@ -2853,6 +2880,13 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
>             vol->sectype != ses->sectype)
>                 return 0;
>
> +       /*
> +        * If an existing session is limited to less channels than
> +        * requested, it should not be reused
> +        */
> +       if (ses->chan_max < vol->max_channels)
> +               return 0;
> +
>         switch (ses->sectype) {
>         case Kerberos:
>                 if (!uid_eq(vol->cred_uid, ses->cred_uid))
> @@ -3269,14 +3303,25 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>         ses->sectype = volume_info->sectype;
>         ses->sign = volume_info->sign;
>         mutex_lock(&ses->session_mutex);
> +
> +       /* add server as first channel */
> +       ses->chans[0].server = server;
> +       ses->chan_count = 1;
> +       ses->chan_max = volume_info->multichannel ? volume_info->max_channels:1;
> +
>         rc = cifs_negotiate_protocol(xid, ses);
>         if (!rc)
>                 rc = cifs_setup_session(xid, ses, volume_info->local_nls);
> +
> +       /* each channel uses a different signing key */
> +       memcpy(ses->chans[0].signkey, ses->smb3signingkey,
> +              sizeof(ses->smb3signingkey));
> +
>         mutex_unlock(&ses->session_mutex);
>         if (rc)
>                 goto get_ses_fail;
>
> -       /* success, put it on the list */
> +       /* success, put it on the list and add it as first channel */
>         spin_lock(&cifs_tcp_ses_lock);
>         list_add(&ses->smb_ses_list, &server->smb_ses_list);
>         spin_unlock(&cifs_tcp_ses_lock);
> @@ -4885,6 +4930,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>         cifs_autodisable_serverino(cifs_sb);
>  out:
>         free_xid(xid);
> +       cifs_try_adding_channels(ses);
>         return mount_setup_tlink(cifs_sb, ses, tcon);
>
>  error:
> @@ -5130,7 +5176,7 @@ int
>  cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
>  {
>         int rc = 0;
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>
>         if (!server->ops->need_neg || !server->ops->negotiate)
>                 return -ENOSYS;
> @@ -5157,23 +5203,25 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>                    struct nls_table *nls_info)
>  {
>         int rc = -ENOSYS;
> -       struct TCP_Server_Info *server = ses->server;
> -
> -       ses->capabilities = server->capabilities;
> -       if (linuxExtEnabled == 0)
> -               ses->capabilities &= (~server->vals->cap_unix);
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
> +
> +       if (!ses->binding) {
> +               ses->capabilities = server->capabilities;
> +               if (linuxExtEnabled == 0)
> +                       ses->capabilities &= (~server->vals->cap_unix);
> +
> +               if (ses->auth_key.response) {
> +                       cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
> +                                ses->auth_key.response);
> +                       kfree(ses->auth_key.response);
> +                       ses->auth_key.response = NULL;
> +                       ses->auth_key.len = 0;
> +               }
> +       }
>
>         cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
>                  server->sec_mode, server->capabilities, server->timeAdj);
>
> -       if (ses->auth_key.response) {
> -               cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
> -                        ses->auth_key.response);
> -               kfree(ses->auth_key.response);
> -               ses->auth_key.response = NULL;
> -               ses->auth_key.len = 0;
> -       }
> -
>         if (server->ops->sess_setup)
>                 rc = server->ops->sess_setup(xid, ses, nls_info);
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 4c764ff7edd2..20c73a42755d 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -31,6 +31,217 @@
>  #include <linux/utsname.h>
>  #include <linux/slab.h>
>  #include "cifs_spnego.h"
> +#include "smb2proto.h"
> +
> +bool
> +is_server_using_iface(struct TCP_Server_Info *server,
> +                     struct cifs_server_iface *iface)
> +{
> +       struct sockaddr_in *i4 = (struct sockaddr_in *)&iface->sockaddr;
> +       struct sockaddr_in6 *i6 = (struct sockaddr_in6 *)&iface->sockaddr;
> +       struct sockaddr_in *s4 = (struct sockaddr_in *)&server->dstaddr;
> +       struct sockaddr_in6 *s6 = (struct sockaddr_in6 *)&server->dstaddr;
> +
> +       if (server->dstaddr.ss_family != iface->sockaddr.ss_family)
> +               return false;
> +       if (server->dstaddr.ss_family == AF_INET) {
> +               if (s4->sin_addr.s_addr != i4->sin_addr.s_addr)
> +                       return false;
> +       } else if (server->dstaddr.ss_family == AF_INET6) {
> +               if (memcmp(&s6->sin6_addr, &i6->sin6_addr,
> +                          sizeof(i6->sin6_addr)) != 0)
> +                       return false;
> +       } else {
> +               /* unknown family.. */
> +               return false;
> +       }
> +       return true;
> +}
> +
> +bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
> +{
> +       int i;
> +       for (i = 0; i < ses->chan_count; i++) {
> +               if (is_server_using_iface(ses->chans[i].server, iface))
> +                       return true;
> +       }
> +       return false;
> +}
> +
> +/* returns number of channels added */
> +int cifs_try_adding_channels(struct cifs_ses *ses)
> +{
> +       int old_chan_count = ses->chan_count;
> +       int left = ses->chan_max - ses->chan_count;
> +       int i = 0;
> +       int rc = 0;
> +
> +       if (left <= 0) {
> +               cifs_dbg(FYI,
> +                        "ses already at max_channels (%zu), nothing to open\n",
> +                        ses->chan_max);
> +               return 0;
> +       }
> +
> +       if (ses->server->dialect != SMB311_PROT_ID) {
> +               cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.1.1\n");
> +               return 0;
> +       }
> +
> +       /* ifaces are sorted by speed, try them in order */
> +       for (i = 0; left > 0 && i < ses->iface_count; i++) {
> +               struct cifs_server_iface *iface;
> +
> +               iface = &ses->iface_list[i];
> +               if (is_ses_using_iface(ses, iface) && !iface->rss_capable)
> +                       continue;
> +
> +               rc = cifs_ses_add_channel(ses, iface);
> +               if (rc) {
> +                       cifs_dbg(FYI, "failed to open extra channel\n");
> +                       continue;
> +               }
> +
> +               cifs_dbg(FYI, "sucessfully opened new channel\n");
> +               left--;
> +       }
> +
> +       /*
> +        * TODO: if we still have channels left to open try to connect
> +        * to same RSS-capable iface multiple times
> +        */
> +
> +       return ses->chan_count - old_chan_count;
> +}
> +
> +int
> +cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
> +{
> +       struct cifs_chan *chan;
> +       struct smb_vol vol = {0};
> +       const char unc_fmt[] = "\\%s\\foo";
> +       char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
> +       struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
> +       struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
> +       int rc;
> +       unsigned int xid = get_xid();
> +
> +       cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ",
> +                ses, iface->speed, iface->rdma_capable ? "yes" : "no");
> +       if (iface->sockaddr.ss_family == AF_INET)
> +               cifs_dbg(FYI, "ip:%pI4)\n", &ipv4->sin_addr);
> +       else
> +               cifs_dbg(FYI, "ip:%pI6)\n", &ipv6->sin6_addr);
> +
> +       /*
> +        * Setup a smb_vol with mostly the same info as the existing
> +        * session and overwrite it with the requested iface data.
> +        *
> +        * We need to setup at least the fields used for negprot and
> +        * sesssetup.
> +        *
> +        * We only need the volume here, so we can reuse memory from
> +        * the session and server without caring about memory
> +        * management.
> +        */
> +
> +       /* Always make new connection for now (TODO?) */
> +       vol.nosharesock = true;
> +
> +       /* Auth */
> +       vol.domainauto = ses->domainAuto;
> +       vol.domainname = ses->domainName;
> +       vol.username = ses->user_name;
> +       vol.password = ses->password;
> +       vol.sectype = ses->sectype;
> +       vol.sign = ses->sign;
> +
> +       /* UNC and paths */
> +       /* XXX: Use ses->server->hostname? */
> +       sprintf(unc, unc_fmt, ses->serverName);
> +       vol.UNC = unc;
> +       vol.prepath = "";
> +
> +       /* Require SMB3.1.1 */
> +       vol.vals = &smb311_values;
> +       vol.ops = &smb311_operations;
> +
> +       vol.noblocksnd = ses->server->noblocksnd;
> +       vol.noautotune = ses->server->noautotune;
> +       vol.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
> +       vol.echo_interval = ses->server->echo_interval / HZ;
> +
> +       /*
> +        * This will be used for encoding/decoding user/domain/pw
> +        * during sess setup auth.
> +        *
> +        * XXX: We use the default for simplicity but the proper way
> +        * would be to use the one that ses used, which is not
> +        * stored. This might break when dealing with non-ascii
> +        * strings.
> +        */
> +       vol.local_nls = load_nls_default();
> +
> +       /* Use RDMA if possible */
> +       vol.rdma = iface->rdma_capable;
> +       memcpy(&vol.dstaddr, &iface->sockaddr, sizeof(struct sockaddr_storage));
> +
> +       /* reuse master con client guid */
> +       memcpy(&vol.client_guid, ses->server->client_guid, SMB2_CLIENT_GUID_SIZE);
> +       vol.use_client_guid = true;
> +
> +       mutex_lock(&ses->session_mutex);
> +
> +       chan = &ses->chans[ses->chan_count];
> +       chan->server = cifs_get_tcp_session(&vol);
> +       if (IS_ERR(chan->server)) {
> +               rc = PTR_ERR(chan->server);
> +               chan->server = NULL;
> +               goto out;
> +       }
> +
> +       /*
> +        * We need to allocate the server crypto now as we will need
> +        * to sign packets before we generate the channel signing key
> +        * (we sign with the session key)
> +        */
> +       rc = smb311_crypto_shash_allocate(chan->server);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
> +               goto out;
> +       }
> +
> +       ses->binding = true;
> +       rc = cifs_negotiate_protocol(xid, ses);
> +       if (rc)
> +               goto out;
> +
> +       rc = cifs_setup_session(xid, ses, vol.local_nls);
> +       if (rc)
> +               goto out;
> +
> +       /* success, put it on the list
> +        * XXX: sharing ses between 2 tcp server is not possible, the
> +        * way "internal" linked lists works in linux makes element
> +        * only able to belong to one list
> +        *
> +        * the binding session is already established so the rest of
> +        * the code should be able to look it up, no need to add the
> +        * ses to the new server.
> +        */
> +
> +       ses->chan_count++;
> +
> +out:
> +       ses->binding = false;
> +       mutex_unlock(&ses->session_mutex);
> +
> +       if (rc && chan->server)
> +               cifs_put_tcp_session(chan->server, 0);
> +       unload_nls(vol.local_nls);
> +
> +       return rc;
> +}
>
>  static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
>  {
> @@ -342,6 +553,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>  void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>                                          struct cifs_ses *ses)
>  {
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>         NEGOTIATE_MESSAGE *sec_blob = (NEGOTIATE_MESSAGE *)pbuffer;
>         __u32 flags;
>
> @@ -354,9 +566,9 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>                 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
>                 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
>                 NTLMSSP_NEGOTIATE_SEAL;
> -       if (ses->server->sign)
> +       if (server->sign)
>                 flags |= NTLMSSP_NEGOTIATE_SIGN;
> -       if (!ses->server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
> +       if (!server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
>                 flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
>
>         sec_blob->NegotiateFlags = cpu_to_le32(flags);
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index e311f58dc1c8..a95ed951c67f 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -29,6 +29,7 @@
>  #include "cifs_unicode.h"
>  #include "smb2status.h"
>  #include "smb2glob.h"
> +#include "nterr.h"
>
>  static int
>  check_smb2_hdr(struct smb2_sync_hdr *shdr, __u64 mid)
> @@ -788,23 +789,37 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
>         int i, rc;
>         struct sdesc *d;
>         struct smb2_sync_hdr *hdr;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>
> -       if (ses->server->tcpStatus == CifsGood) {
> -               /* skip non smb311 connections */
> -               if (ses->server->dialect != SMB311_PROT_ID)
> -                       return 0;
> +       hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
> +       /* neg prot are always taken */
> +       if (hdr->Command == SMB2_NEGOTIATE)
> +               goto ok;
>
> -               /* skip last sess setup response */
> -               hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
> -               if (hdr->Flags & SMB2_FLAGS_SIGNED)
> -                       return 0;
> -       }
> +       /*
> +        * If we process a command which wasn't a negprot it means the
> +        * neg prot was already done, so the server dialect was set
> +        * and we can test it. Preauth requires 3.1.1 for now.
> +        */
> +       if (server->dialect != SMB311_PROT_ID)
> +               return 0;
> +
> +       if (hdr->Command != SMB2_SESSION_SETUP)
> +               return 0;
> +
> +       /* skip last sess setup response */
> +       if ((hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
> +           && (hdr->Status == NT_STATUS_OK
> +               || (hdr->Status !=
> +                   cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))))
> +               return 0;
>
> -       rc = smb311_crypto_shash_allocate(ses->server);
> +ok:
> +       rc = smb311_crypto_shash_allocate(server);
>         if (rc)
>                 return rc;
>
> -       d = ses->server->secmech.sdescsha512;
> +       d = server->secmech.sdescsha512;
>         rc = crypto_shash_init(&d->shash);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: could not init sha512 shash\n", __func__);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index eaed18061314..0e66dc1aa1c9 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -10,6 +10,7 @@
>  #include <linux/falloc.h>
>  #include <linux/scatterlist.h>
>  #include <linux/uuid.h>
> +#include <linux/sort.h>
>  #include <crypto/aead.h>
>  #include "cifsglob.h"
>  #include "smb2pdu.h"
> @@ -315,7 +316,7 @@ smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>  {
>         int rc;
>
> -       ses->server->CurrentMid = 0;
> +       cifs_ses_server(ses)->CurrentMid = 0;
>         rc = SMB2_negotiate(xid, ses);
>         /* BB we probably don't need to retry with modern servers */
>         if (rc == -EAGAIN)
> @@ -558,6 +559,13 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>         return rc;
>  }
>
> +static int compare_iface(const void *ia, const void *ib)
> +{
> +       const struct cifs_server_iface *a = (struct cifs_server_iface *)ia;
> +       const struct cifs_server_iface *b = (struct cifs_server_iface *)ib;
> +
> +       return a->speed == b->speed ? 0 : (a->speed > b->speed ? -1 : 1);
> +}
>
>  static int
>  SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
> @@ -587,6 +595,9 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>         if (rc)
>                 goto out;
>
> +       /* sort interfaces from fastest to slowest */
> +       sort(iface_list, iface_count, sizeof(*iface_list), compare_iface, NULL);
> +
>         spin_lock(&ses->iface_lock);
>         kfree(ses->iface_list);
>         ses->iface_list = iface_list;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 87066f1af12c..8bcb278fdb0a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -789,7 +789,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>         struct kvec rsp_iov;
>         int rc = 0;
>         int resp_buftype;
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>         int blob_offset, blob_length;
>         char *security_blob;
>         int flags = CIFS_NEG_OP;
> @@ -811,7 +811,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>         memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>         memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>
> -       if (strcmp(ses->server->vals->version_string,
> +       if (strcmp(server->vals->version_string,
>                    SMB3ANY_VERSION_STRING) == 0) {
>                 req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>                 req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
> @@ -827,7 +827,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>                 total_len += 8;
>         } else {
>                 /* otherwise send specific dialect */
> -               req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
> +               req->Dialects[0] = cpu_to_le16(server->vals->protocol_id);
>                 req->DialectCount = cpu_to_le16(1);
>                 total_len += 2;
>         }
> @@ -1169,7 +1169,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
>         int rc;
>         struct cifs_ses *ses = sess_data->ses;
>         struct smb2_sess_setup_req *req;
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>         unsigned int total_len;
>
>         rc = smb2_plain_req_init(SMB2_SESSION_SETUP, NULL, (void **) &req,
> @@ -1177,13 +1177,18 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
>         if (rc)
>                 return rc;
>
> -       /* First session, not a reauthenticate */
> -       req->sync_hdr.SessionId = 0;
> -
> -       /* if reconnect, we need to send previous sess id, otherwise it is 0 */
> -       req->PreviousSessionId = sess_data->previous_session;
> -
> -       req->Flags = 0; /* MBZ */
> +       if (sess_data->ses->binding) {
> +               req->sync_hdr.SessionId = sess_data->ses->Suid;
> +               req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
> +               req->PreviousSessionId = 0;
> +               req->Flags = SMB2_SESSION_REQ_FLAG_BINDING;
> +       } else {
> +               /* First session, not a reauthenticate */
> +               req->sync_hdr.SessionId = 0;
> +               /* if reconnect, we need to send previous sess id, otherwise it is 0 */
> +               req->PreviousSessionId = sess_data->previous_session;
> +               req->Flags = 0; /* MBZ */
> +       }
>
>         /* enough to enable echos and oplocks and one max size write */
>         req->sync_hdr.CreditRequest = cpu_to_le16(130);
> @@ -1256,28 +1261,33 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
>  {
>         int rc = 0;
>         struct cifs_ses *ses = sess_data->ses;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>
> -       mutex_lock(&ses->server->srv_mutex);
> -       if (ses->server->ops->generate_signingkey) {
> -               rc = ses->server->ops->generate_signingkey(ses);
> +       mutex_lock(&server->srv_mutex);
> +       if (server->ops->generate_signingkey) {
> +               rc = server->ops->generate_signingkey(ses);
>                 if (rc) {
>                         cifs_dbg(FYI,
>                                 "SMB3 session key generation failed\n");
> -                       mutex_unlock(&ses->server->srv_mutex);
> +                       mutex_unlock(&server->srv_mutex);
>                         return rc;
>                 }
>         }
> -       if (!ses->server->session_estab) {
> -               ses->server->sequence_number = 0x2;
> -               ses->server->session_estab = true;
> +       if (!server->session_estab) {
> +               server->sequence_number = 0x2;
> +               server->session_estab = true;
>         }
> -       mutex_unlock(&ses->server->srv_mutex);
> +       mutex_unlock(&server->srv_mutex);
>
>         cifs_dbg(FYI, "SMB2/3 session established successfully\n");
> -       spin_lock(&GlobalMid_Lock);
> -       ses->status = CifsGood;
> -       ses->need_reconnect = false;
> -       spin_unlock(&GlobalMid_Lock);
> +       /* keep exising ses state if binding */
> +       if (!ses->binding) {
> +               spin_lock(&GlobalMid_Lock);
> +               ses->status = CifsGood;
> +               ses->need_reconnect = false;
> +               spin_unlock(&GlobalMid_Lock);
> +       }
> +
>         return rc;
>  }
>
> @@ -1315,16 +1325,19 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>                 goto out_put_spnego_key;
>         }
>
> -       ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
> -                                        GFP_KERNEL);
> -       if (!ses->auth_key.response) {
> -               cifs_dbg(VFS,
> -                       "Kerberos can't allocate (%u bytes) memory",
> -                       msg->sesskey_len);
> -               rc = -ENOMEM;
> -               goto out_put_spnego_key;
> +       /* keep session key if binding */
> +       if (!ses->binding) {
> +               ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
> +                                                GFP_KERNEL);
> +               if (!ses->auth_key.response) {
> +                       cifs_dbg(VFS,
> +                                "Kerberos can't allocate (%u bytes) memory",
> +                                msg->sesskey_len);
> +                       rc = -ENOMEM;
> +                       goto out_put_spnego_key;
> +               }
> +               ses->auth_key.len = msg->sesskey_len;
>         }
> -       ses->auth_key.len = msg->sesskey_len;
>
>         sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
>         sess_data->iov[1].iov_len = msg->secblob_len;
> @@ -1334,9 +1347,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>                 goto out_put_spnego_key;
>
>         rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
> -       ses->Suid = rsp->sync_hdr.SessionId;
> -
> -       ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       /* keep session id and flags if binding */
> +       if (!ses->binding) {
> +               ses->Suid = rsp->sync_hdr.SessionId;
> +               ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       }
>
>         rc = SMB2_sess_establish_session(sess_data);
>  out_put_spnego_key:
> @@ -1430,9 +1445,11 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
>
>         cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
>
> -
> -       ses->Suid = rsp->sync_hdr.SessionId;
> -       ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       /* keep existing ses id and flags if binding */
> +       if (!ses->binding) {
> +               ses->Suid = rsp->sync_hdr.SessionId;
> +               ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       }
>
>  out:
>         kfree(ntlmssp_blob);
> @@ -1489,8 +1506,11 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
>
>         rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
>
> -       ses->Suid = rsp->sync_hdr.SessionId;
> -       ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       /* keep existing ses id and flags if binding */
> +       if (!ses->binding) {
> +               ses->Suid = rsp->sync_hdr.SessionId;
> +               ses->session_flags = le16_to_cpu(rsp->SessionFlags);
> +       }
>
>         rc = SMB2_sess_establish_session(sess_data);
>  out:
> @@ -1507,7 +1527,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
>  {
>         int type;
>
> -       type = smb2_select_sectype(ses->server, ses->sectype);
> +       type = smb2_select_sectype(cifs_ses_server(ses), ses->sectype);
>         cifs_dbg(FYI, "sess setup type %d\n", type);
>         if (type == Unspecified) {
>                 cifs_dbg(VFS,
> @@ -1535,7 +1555,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>                 const struct nls_table *nls_cp)
>  {
>         int rc = 0;
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server = cifs_ses_server(ses);
>         struct SMB2_sess_data *sess_data;
>
>         cifs_dbg(FYI, "Session Setup\n");
> @@ -1561,7 +1581,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>         /*
>          * Initialize the session hash with the server one.
>          */
> -       memcpy(ses->preauth_sha_hash, ses->server->preauth_sha_hash,
> +       memcpy(ses->preauth_sha_hash, server->preauth_sha_hash,
>                SMB2_PREAUTH_HASH_SIZE);
>
>         while (sess_data->func)
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 67a91b11fd59..804b6dc5546b 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -46,7 +46,8 @@ extern int smb2_verify_signature(struct smb_rqst *, struct TCP_Server_Info *);
>  extern int smb2_check_receive(struct mid_q_entry *mid,
>                               struct TCP_Server_Info *server, bool log_error);
>  extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
> -                             struct smb_rqst *rqst);
> +                                             struct TCP_Server_Info *,
> +                                             struct smb_rqst *rqst);
>  extern struct mid_q_entry *smb2_setup_async_request(
>                         struct TCP_Server_Info *server, struct smb_rqst *rqst);
>  extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 148d7942c796..539cf2fc1f3b 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
>                                &server->secmech.sdeschmacsha256);
>  }
>
> -static int
> +int
>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>  {
>         struct cifs_secmech *p = &server->secmech;
> @@ -98,6 +98,47 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
>         return rc;
>  }
>
> +u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
> +{
> +       int i;
> +       struct cifs_chan *chan;
> +       int count;
> +       spin_lock(&cifs_tcp_ses_lock);
> +       count = ses->chan_count;
> +       if (ses->binding)
> +               count++;
> +       for (i = 0; i < count; i++) {
> +               chan = ses->chans + i;
> +               if (chan->server == server) {
> +                       spin_unlock(&cifs_tcp_ses_lock);
> +                       return chan->signkey;
> +               }
> +       }
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       return NULL;
> +}
> +
> +struct cifs_ses *
> +smb2_find_global_smb_ses(__u64 ses_id)
> +{
> +       struct TCP_Server_Info *server;
> +       struct cifs_ses *ses;
> +       cifs_dbg(VFS, "XXX: searching for sesid %llu", ses_id);
> +       spin_lock(&cifs_tcp_ses_lock);
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> +               cifs_dbg(VFS, "XXX: server %px ", server);
> +               list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +                       cifs_dbg(VFS, "XXX: ses %px ", ses);
> +                       if (ses->Suid == ses_id) {
> +                               spin_unlock(&cifs_tcp_ses_lock);
> +                               return ses;
> +                       }
> +               }
> +       }
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       return NULL;
> +}
> +
>  static struct cifs_ses *
>  smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
>  {
> @@ -328,21 +369,34 @@ generate_smb3signingkey(struct cifs_ses *ses,
>  {
>         int rc;
>
> -       rc = generate_key(ses, ptriplet->signing.label,
> -                         ptriplet->signing.context, ses->smb3signingkey,
> -                         SMB3_SIGN_KEY_SIZE);
> -       if (rc)
> -               return rc;
> -
> -       rc = generate_key(ses, ptriplet->encryption.label,
> -                         ptriplet->encryption.context, ses->smb3encryptionkey,
> -                         SMB3_SIGN_KEY_SIZE);
> -       if (rc)
> -               return rc;
> -
> -       rc = generate_key(ses, ptriplet->decryption.label,
> -                         ptriplet->decryption.context,
> -                         ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
> +       if (ses->binding) {
> +               struct TCP_Server_Info *server;
> +               cifs_dbg(VFS, "XXX: BINDING! gen signkey");
> +               server = cifs_ses_server(ses);
> +               rc = generate_key(ses, ptriplet->signing.label,
> +                                 ptriplet->signing.context,
> +                                 smb2_find_chan_signkey(ses, server),
> +                                 SMB3_SIGN_KEY_SIZE);
> +               if (rc)
> +                       return rc;
> +       } else {
> +               rc = generate_key(ses, ptriplet->signing.label,
> +                                 ptriplet->signing.context,
> +                                 ses->smb3signingkey,
> +                                 SMB3_SIGN_KEY_SIZE);
> +               if (rc)
> +                       return rc;
> +               rc = generate_key(ses, ptriplet->encryption.label,
> +                                 ptriplet->encryption.context,
> +                                 ses->smb3encryptionkey,
> +                                 SMB3_SIGN_KEY_SIZE);
> +               rc = generate_key(ses, ptriplet->decryption.label,
> +                                 ptriplet->decryption.context,
> +                                 ses->smb3decryptionkey,
> +                                 SMB3_SIGN_KEY_SIZE);
> +               if (rc)
> +                       return rc;
> +       }
>
>         if (rc)
>                 return rc;
> @@ -434,18 +488,35 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>         struct cifs_ses *ses;
>         struct shash_desc *shash = &server->secmech.sdesccmacaes->shash;
>         struct smb_rqst drqst;
> +       u8 *key;
>
> -       ses = smb2_find_smb_ses(server, shdr->SessionId);
> +       ses = smb2_find_global_smb_ses(shdr->SessionId);
>         if (!ses) {
>                 cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
>                 return 0;
>         }
>
> +       /*
> +        * If we are binding an existing session use the session key,
> +        * otherwise use the channel key
> +        */
> +       if (ses->binding) {
> +               key = ses->smb3signingkey;
> +               cifs_dbg(VFS, "XXX: using bind ses key %px", key);
> +       } else {
> +               key = smb2_find_chan_signkey(ses, server);
> +               cifs_dbg(VFS, "XXX: using chan ses key %px", key);
> +               if (!key) {
> +                       cifs_dbg(VFS, "XXX: could not find channel key");
> +                       return 0;
> +               }
> +        }
> +
>         memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
>         memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>
>         rc = crypto_shash_setkey(server->secmech.cmacaes,
> -                                ses->smb3signingkey, SMB2_CMACAES_SIZE);
> +                                key, SMB2_CMACAES_SIZE);
>         if (rc) {
>                 cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
>                 return rc;
> @@ -494,18 +565,35 @@ static int
>  smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  {
>         int rc = 0;
> -       struct smb2_sync_hdr *shdr =
> -                       (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
> +       struct smb2_sync_hdr *shdr;
> +       struct smb2_sess_setup_req *ssr;
> +       bool is_binding;
> +       bool is_signed;
>
> -       if (!(shdr->Flags & SMB2_FLAGS_SIGNED) ||
> -           server->tcpStatus == CifsNeedNegotiate)
> -               return rc;
> +       shdr = (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
> +       ssr = (struct smb2_sess_setup_req *)shdr;
>
> -       if (!server->session_estab) {
> +       is_binding = shdr->Command == SMB2_SESSION_SETUP &&
> +               (ssr->Flags & SMB2_SESSION_REQ_FLAG_BINDING);
> +       is_signed = shdr->Flags & SMB2_FLAGS_SIGNED;
> +
> +       printk(KERN_WARNING "XXX: sign_rqst\n");
> +
> +       if (!is_signed) {
> +               printk(KERN_WARNING "XXX: no signed flag\n");
> +               return 0;
> +       }
> +       if (server->tcpStatus == CifsNeedNegotiate) {
> +               printk(KERN_WARNING "XXX: need nego\n");
> +               return 0;
> +       }
> +       if (!is_binding && !server->session_estab) {
>                 strncpy(shdr->Signature, "BSRSPYL", 8);
> -               return rc;
> +               printk(KERN_WARNING "XXX: !session_estab\n");
> +               return 0;
>         }
>
> +       printk(KERN_WARNING "XXX: actually signing!\n");
>         rc = server->ops->calc_signature(rqst, server);
>
>         return rc;
> @@ -610,18 +698,18 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
>  }
>
>  static int
> -smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
> +smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server, struct smb2_sync_hdr *shdr,
>                    struct mid_q_entry **mid)
>  {
> -       if (ses->server->tcpStatus == CifsExiting)
> +       if (server->tcpStatus == CifsExiting)
>                 return -ENOENT;
>
> -       if (ses->server->tcpStatus == CifsNeedReconnect) {
> +       if (server->tcpStatus == CifsNeedReconnect) {
>                 cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
>                 return -EAGAIN;
>         }
>
> -       if (ses->server->tcpStatus == CifsNeedNegotiate &&
> +       if (server->tcpStatus == CifsNeedNegotiate &&
>            shdr->Command != SMB2_NEGOTIATE)
>                 return -EAGAIN;
>
> @@ -638,11 +726,11 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
>                 /* else ok - we are shutting down the session */
>         }
>
> -       *mid = smb2_mid_entry_alloc(shdr, ses->server);
> +       *mid = smb2_mid_entry_alloc(shdr, server);
>         if (*mid == NULL)
>                 return -ENOMEM;
>         spin_lock(&GlobalMid_Lock);
> -       list_add_tail(&(*mid)->qhead, &ses->server->pending_mid_q);
> +       list_add_tail(&(*mid)->qhead, &server->pending_mid_q);
>         spin_unlock(&GlobalMid_Lock);
>
>         return 0;
> @@ -675,24 +763,24 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>  }
>
>  struct mid_q_entry *
> -smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
> +smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server, struct smb_rqst *rqst)
>  {
>         int rc;
>         struct smb2_sync_hdr *shdr =
>                         (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
>         struct mid_q_entry *mid;
>
> -       smb2_seq_num_into_buf(ses->server, shdr);
> +       smb2_seq_num_into_buf(server, shdr);
>
> -       rc = smb2_get_mid_entry(ses, shdr, &mid);
> +       rc = smb2_get_mid_entry(ses, server, shdr, &mid);
>         if (rc) {
> -               revert_current_mid_from_hdr(ses->server, shdr);
> +               revert_current_mid_from_hdr(server, shdr);
>                 return ERR_PTR(rc);
>         }
>
> -       rc = smb2_sign_rqst(rqst, ses->server);
> +       rc = smb2_sign_rqst(rqst, server);
>         if (rc) {
> -               revert_current_mid_from_hdr(ses->server, shdr);
> +               revert_current_mid_from_hdr(server, shdr);
>                 cifs_delete_mid(mid);
>                 return ERR_PTR(rc);
>         }
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 308ad0f495e1..a4c2d62ee437 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -923,7 +923,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>  }
>
>  struct mid_q_entry *
> -cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
> +cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored, struct smb_rqst *rqst)
>  {
>         int rc;
>         struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
> @@ -995,7 +995,15 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>                 return -EIO;
>         }
>
> -       server = ses->server;
> +       if (!ses->binding) {
> +               uint index = ((unsigned)get_random_int()) % ses->chan_count;
> +               cifs_dbg(VFS, "XXX: send/recv: using random channel %d", index);
> +               server = ses->chans[index].server;
> +       } else {
> +               cifs_dbg(VFS, "XXX: send/recv: binding, using last serv");
> +               server = cifs_ses_server(ses);
> +       }
> +
>         if (server->tcpStatus == CifsExiting)
>                 return -ENOENT;
>
> @@ -1040,7 +1048,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         }
>
>         for (i = 0; i < num_rqst; i++) {
> -               midQ[i] = server->ops->setup_request(ses, &rqst[i]);
> +               midQ[i] = server->ops->setup_request(ses, server, &rqst[i]);
>                 if (IS_ERR(midQ[i])) {
>                         revert_current_mid(server, i);
>                         for (j = 0; j < i; j++)
> --
> 2.16.4
>


-- 
Thanks,

Steve
