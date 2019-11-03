Return-Path: <SRS0=MPEU=Y3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198DACA9ED1
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E070E215EA
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Nov 2019 01:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKCBV0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 21:21:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:57514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727335AbfKCBV0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Nov 2019 21:21:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96C17ADB5;
        Sun,  3 Nov 2019 01:21:23 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 0/6] add multichannel support
Date:   Sun,  3 Nov 2019 02:21:06 +0100
Message-Id: <20191103012112.12212-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I have very little time to work on this during the work week due to
annoying^W lovely customers, company stuff and backporting work but
during this long weekend of festivities I somehow mustered the courage
to dig in again...

So without further ado, here is another iteration of the multichannel
patchset.

Couple of changes since last time:
* do round-robin on the channels (cycle over them on requests)
* reuse master client guid for new channel (fixes binding against samba)
* simplification of crypto key lookup and potential race condition fix
* properly discard channels on session closing
* better display of channels info in DebugData

Usage
=====

Make sure your server exposes multiple interfaces and mount with:

    -o multichannel,max_channels=2

To have a total of 2 connections. One master and one extra channel.
* Each call to ...send_recv() will alternate between the 2 channels.
* You can check /proc/fs/cifs/DebugData for channel infos

Overview
========

Multichannel is part of SMB3 and above. It lets the client "share" the
same SMB session over multiple TCP (or RDMA) connections.

* First, a regular connection is made.

client                                                       server
  |							       |
  | ----------- negprot req (unsigned, guid=0xABC)--------->   |
  |							       |
  | <---------- negprot res (unsigned)	-------------------    |
  |							       |
  | ----------  sesssetup req (sesid=0x000, unsigned) ------>  |
  |							       |
  | <---------  sesssetup res (sesid=0x123, signed) ---------  |
  |                                                            |
  |  (client now has signing/encryption/decryption keys)       |
  |                                                            |
  |							       |
  | ----------- ... (signed) ------------------------------->  |
  | <-------------------------------------------------------   |
  |							       |

* The client then queries the network interface available on the
  server via an FSCTL (this already implemented in cifs.ko)

* For each new channel, the client opens another connection, but
  reuses the client guid, and at session setup it sets a binding flag
  to say "this is a new channel, please make this session an alias to
  sess id 0x123"

* Since the session is an alias, you can use TreeCons, files, etc
  interchangeably between channels as if it was the same transport.

* Channels use the same encryption/decryption keys from the session
  BUT each channel has its own signing key.

* When you see "signed" in lowercase, it's signed using the session/master key.
  When you see "SIGNED" in uppercase, it's signed with the CHANNEL key.

Here is the traffic for opening and using new channels:
                                                              |
  | ---------  negprot req (unsigned, guid=0xABC) ----------> |  o
  |                                                           |  o
  | <--------  negprog res (unsigned) ----------------------  |  o BINDING
  |                                                           |  o  PART
  | ---------  sesssetup req (sesid=0x123, binding, signed)-> |  o
  |                                                           |  o
  | <--------  sesssetup res (sesid=0x123, SIGNED) ---------  |  o
  |                                                           |
  | (from then on, client needs to use CHANNEL key            |
  |  for signing)                                             |
  |                                                           |
  | ---------  ... (SIGNED) --------------------------------> |
  | <-------------------------------------------------------- |
  |                                                           |

This signing key business is tricky to get right. As usual refer to
MS-SMB2 for more boring details.

cifs.ko implementation
======================

Data structure
--------------

We add an array of struct cifs_chan to cifs_ses. A channel has a
server pointer and a signing key.

struct cifs_ses {
    struct TCP_Server_Info *server; <-- master con
    u8 smb3signingkey[...];         <-- master sign key
    u8 smb3encryptionkey[...];      <-- extra channels & master
    u8 smb3decryptionkey[...];      <-- extra channels & master
    bool binding;                   <--- true during BINDING PART
    ...
    struct cifs_chan {
           struct TCP_Server_Info *server; <-- channel con
           u8 signkey[SMB3_SIGN_KEY_SIZE]; <-- channel sign key
    } chans[16];
};

New channel connections (TCP_Server_Info) end up in the usual global
cifs_tcp_ses_list linked list but also in the ses channel array.

 ,-------------> global cifs_tcp_ses_list <-------------------------.
 |                                                                  |
 '- TCP_Server_Info  <-->  TCP_Server_Info  <-->  TCP_Server_Info <-'
       (master con)           (chan#1 con)         (chan#2 con)
       |      ^                    ^                    ^
       v      '--------------------|--------------------'
    cifs_ses                       |
    - chan_count = 3               |
    - chans[].server --------------'

Some important details:

* ses->server still points to the master con.
* ses->server == chans[0].server
* chan#1 and chan#2 have an empty server->smb_ses_list

Channel/session establishment
-----------------------------

* When opening channels we check ses->binding to know that we are in the
  BINDING PART. In which case we don't create a new session object but
  merely reuse the existing one.

* chan_count only keeps track of fully established channels. During
  the BINDING PART there is actually chan_count+1 channels, the last
  one being the channel in the process of being created.

NOTE: we could add a state field to cifs_chan and make cifs_count
      always accurate. Not sure if it's better.

Channel dispatch
----------------

On syscalls, as we get lower and lower in the bowels of cifs.ko we
eventually reach the transport layer. There we often pass a ses
pointer to code that assumes the transport can be reached via
ses->server.

* A big change was to decouple ses from server in those codepaths. So
  that we can select a channel and make the code use that one instead
  of the master.
* That often means passing ses AND server and replacing ses->server by
  server.

Signing and encryption
----------------------

* When generating the keys we make sure to not overwrite enc/dec keys
  for new channels and store the sign key in cifs_chan.

* When sending and receiving a message we have to search for the right
  keys by searching the whole cifs_tcp_ses_list instead of just
  looking at the master con sessions.


Aurelien Aptel (6):
  cifs: sort interface list by speed
  cifs: add multichannel mount options and data structs
  cifs: add server param
  cifs: switch servers depending on binding state
  cifs: try opening channels after mounting
  cifs: dump channel info in DebugData

 fs/cifs/cifs_debug.c    |  35 +++++++-
 fs/cifs/cifs_spnego.c   |   2 +-
 fs/cifs/cifsfs.c        |   4 +
 fs/cifs/cifsglob.h      |  45 +++++++++-
 fs/cifs/cifsproto.h     |   8 ++
 fs/cifs/connect.c       |  92 ++++++++++++++++----
 fs/cifs/sess.c          | 218 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2misc.c      |  37 +++++---
 fs/cifs/smb2ops.c       |  31 +++++--
 fs/cifs/smb2pdu.c       | 109 ++++++++++++++----------
 fs/cifs/smb2proto.h     |   3 +-
 fs/cifs/smb2transport.c | 165 +++++++++++++++++++++++++++---------
 fs/cifs/transport.c     |  18 +++-
 13 files changed, 636 insertions(+), 131 deletions(-)

--
2.16.4
