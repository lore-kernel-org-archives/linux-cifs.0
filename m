Return-Path: <SRS0=/HTR=UK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0472C43218
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 14:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910682054F
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 14:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389777AbfFKOrw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jun 2019 10:47:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:50932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389454AbfFKOrw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 Jun 2019 10:47:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3AAB6ABD2
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jun 2019 14:47:49 +0000 (UTC)
From:   aaptel@suse.com (=?utf-8?Q?Aur=C3=A9lien?= Aptel)
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [WIP] multichannel
Date:   Tue, 11 Jun 2019 16:47:48 +0200
Message-ID: <87pnnkkwkr.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Since I was asked about my multichannel progress at SambaXP I thought I
would send the current state of the code as a WIP for maybe early
feedback. I've discussed it already a bit with Pavel last year when I
was working on it.

I've sort of resurected my multichannel branch and put it on github.
It is based on cifs as of last year so in the middle of compounding and
before the DFS failover (which refactored a lot of reconnection code and
mount code).

Also I now understand cifs reconnection code enough to know that the
multichannel recon code is most likely wrong and needs to be rewritten
:)

I'm juggling large backports for SUSE, debugging customer bugs, the
POSIX extensions reparse point stuff, being a GSoC mentor this summer
and it seems I'm never finishing anything which is pretty
frustrating... anyway (/rant)

Code is *old* but available on my github on the multichannel-v2 branch
as a big single "wip" commit...

https://github.com/aaptel/linux.git multichan-v2

https://github.com/aaptel/linux/commit/bcc0ac27a03e100a5f444ab012cc27711919cf74

Here is a *simplified* overview of the changes:

Datastructure changes
=====================

I've added an array of cifs_chan inside cifs_ses.
I could have added an array of TCP_Server_Info but since a channel uses
a different signing key and signing keys are stored in cifs_ses I needed
the extra struct.

+struct cifs_chan {
+       struct TCP_Server_Info *server;
+       __u8 signkey[SMB3_SIGN_KEY_SIZE];
+};

...

@@ -881,12 +890,15 @@ struct cifs_ses {
        bool sign;              /* is signing required? */
        bool need_reconnect:1; /* connection reset, uid now invalid */
        bool domainAuto:1;
+       bool binding:1; /* are we binding the session? */
        __u16 session_flags;
        __u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
        __u8 smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
        __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
        __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
 
@@ -900,8 +912,22 @@ struct cifs_ses {
        struct cifs_server_iface *iface_list;
        size_t iface_count;
        unsigned long iface_last_update; /* jiffies */
+
+#define CIFS_MAX_CHANNELS 16
+       struct cifs_chan chans[CIFS_MAX_CHANNELS];
+       size_t chan_count;
+       size_t chan_max;
 };

The "main" channel is still ses->server (copied to ses->chans[0] for
convinience too)

Sending-to-the-wire code changes
================================

When sending something on the wire, instead of sending it to ses->server
we send it to a random one instead for now:

@@ -809,7 +810,16 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
+       if (!ses->binding) {
+               uint index = ((unsigned)get_random_int()) % ses->chan_count;
+               cifs_dbg(VFS, "XXX: send/recv: using random channel %d", index);
+               server = ses->chans[index].server;
+       } else {
+               cifs_dbg(VFS, "XXX: send/recv: binding, using last serv");
+               server = cifs_ses_server(ses);
+       }

Couple of func in that code path take a ses as input but really only use
server properties (we are doing the low-level work of sending after all)
so I had to refactor things a bit to pass just the server, or pass ses
AND server (and remove ses->server usage).

Session establishment code changes
==================================

Currently a lot of the code to initialize a connection & session uses
the cifs_ses as input. But depending on if we are opening a new session
or a new channel we need to use different server pointers. So I've added
a "binding" flag in cifs_ses and this helper function that returns the
current server a session should use (only in the sess establishment code
path):

+static inline
+struct TCP_Server_Info *cifs_ses_server(struct cifs_ses *ses)
+{
+       if (ses->binding)
+               return ses->chans[ses->chan_count].server;
                 //                ^^^^^return the last channel (always the new one)
+       else
+               return ses->server;
+}
+

Which needs to be used in all the code related to establishing a
session. A lot of changes are basically turning this:

void foo(struct cifs_ses *ses, ...)
{
    ses->server->...;
    func(ses->server, ...);
    ...
}

into this:

void foo(struct cifs_ses *ses, ...)
{
    TCP_Server_Info *server = cifs_ses_server(ses);

    server->...;
    func(server, ...);
    ...
}

Mount code changes
==================

- "max_channels=N"
  Sets the max number of channel (set this to 2 or more to get extra
  connections)
  
- "[no]multichannel"
  enables multichannel, without this max_channel will be ignored.

The reason for those 2 steps is so that user can enable multichannel
without having to know the details of how it works. Right now we decide
manually via max_channels but in the future it could be dynamic.

After doing cifs_mount() sucessfully we call cifs_try_adding_channels()
which will open as many channels as it can.

+/* returns number of channels added */
+int cifs_try_adding_channels(struct cifs_ses *ses)
+{
+       int old_chan_count = ses->chan_count;
+       int left = ses->chan_max - ses->chan_count;
+       int i = 0;
+       int rc = 0;
+
+       if (left <= 0) {
+               cifs_dbg(FYI,
+                        "ses already at max_channels (%zu), nothing to open\n",
+                        ses->chan_max);
+               return 0;
+       }
+
+       if (ses->server->dialect != SMB311_PROT_ID) {
+               cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.1.1\n");
+               return 0;
+       }
+
+       /* ifaces are sorted by speed, try them in order */
+       for (i = 0; left > 0 && i < ses->iface_count; i++) {
+               struct cifs_server_iface *iface;
+
+               iface = &ses->iface_list[i];
+               if (is_ses_using_iface(ses, iface) && !iface->rss_capable)
+                       continue;
+
+               rc = cifs_ses_add_channel(ses, iface);
+               if (rc) {
+                       cifs_dbg(FYI, "failed to open extra channel\n");
+                       continue;
+               }
+
+               cifs_dbg(FYI, "sucessfully opened new channel\n");
+               left--;
+       }
+
+       /*
+        * TODO: if we still have channels left to open try to connect
+        * to same RSS-capable iface multiple times
+        */
+
+       return ses->chan_count - old_chan_count;
+}


Which in turns calls cifs_ses_add_chanel() to add a channel to an
existing session by connecting to iface:

+cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
+{
+       struct cifs_chan *chan;
+       struct smb_vol vol = {0};
+       const char unc_fmt[] = "\\%s\\foo";
+       char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
+       struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
+       struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
+       int rc;
+       unsigned int xid = get_xid();
+
+       cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ",
+                ses, iface->speed, iface->rdma_capable ? "yes" : "no");
+       if (iface->sockaddr.ss_family == AF_INET)
+               cifs_dbg(FYI, "ip:%pI4)\n", &ipv4->sin_addr);
+       else
+               cifs_dbg(FYI, "ip:%pI6)\n", &ipv6->sin6_addr);
+
+       /*
+        * Setup a smb_vol with mostly the same info as the existing
+        * session and overwrite it with the requested iface data.
+        *
+        * We need to setup at least the fields used for negprot and
+        * sesssetup.
+        *
+        * We only need the volume here, so we can reuse memory from
+        * the session and server without caring about memory
+        * management.
+        */
+
+       /* Always make new connection for now (TODO?) */
+       vol.nosharesock = true;
+
+       /* Auth */
+       vol.domainauto = ses->domainAuto;
+       vol.domainname = ses->domainName;
+       vol.username = ses->user_name;
+       vol.password = ses->password;
+       vol.sectype = ses->sectype;
+       vol.sign = ses->sign;
+
+       /* UNC and paths */
+       /* XXX: Use ses->server->hostname? */
+       sprintf(unc, unc_fmt, ses->serverName);
+       vol.UNC = unc;
+       vol.prepath = "";
+
+       /* Require SMB3.1.1 */
+       vol.vals = &smb311_values;
+       vol.ops = &smb311_operations;
+
+       vol.noblocksnd = ses->server->noblocksnd;
+       vol.noautotune = ses->server->noautotune;
+       vol.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
+       vol.echo_interval = ses->server->echo_interval / HZ;
+
+       /*
+        * This will be used for encoding/decoding user/domain/pw
+        * during sess setup auth.
+        *
+        * XXX: We use the default for simplicity but the proper way
+        * would be to use the one that ses used, which is not
+        * stored. This might break when dealing with non-ascii
+        * strings.
+        */
+       vol.local_nls = load_nls_default();
+
+       /* Use RDMA if possible */
+       vol.rdma = iface->rdma_capable;
+       memcpy(&vol.dstaddr, &iface->sockaddr, sizeof(struct sockaddr_storage));
+
+       mutex_lock(&ses->session_mutex);
+
+       chan = &ses->chans[ses->chan_count];
+       chan->server = cifs_get_tcp_session(&vol);
+       if (IS_ERR(chan->server)) {
+               rc = PTR_ERR(chan->server);
+               chan->server = NULL;
+               goto out;
+       }
+
+       /*
+        * We need to allocate the server crypto now as we will need
+        * to sign packets before we generate the channel signing key
+        * (we sign with the session key)
+        */
+       rc = smb311_crypto_shash_allocate(chan->server);


Locking
=======

I'm not sure things are race-free. The ses->binding flag could be an
issue.

For signing, we need to have access to the session a channel belongs
to... but we actually cannot walk "up" from the server to the
session. So I decided to walk "down" from the global
cifs_tcp_ses_list. But that requires taking the global spinlock for each
packet we sign. Probably not good for parallelism. See
smb2_find_global_smb_ses() usages.


Testing
=======

I have only tested this on a simple Win 2016 VM. Just add network
interfaces to the VM, Windows automatically lists them back when doing a
FSCTL_QUERY_INTERFACE.

Then mount from linux with -o multichannel,max_channels=2

Look at DebugData, network traces or dmesg for runtime info.

I have not made many any benchmark, reconnection tests, DFS tests,
or compounding tests so this really is WIP but I'm very interested in
people trying it anyway :)

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)

