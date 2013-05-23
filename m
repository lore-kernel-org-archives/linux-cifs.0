From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/19] cifs: overhaul of auth selection code
Date: Thu, 23 May 2013 11:05:44 -0400
Message-ID: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the change to make cifs default to NTLMSSP auth was made recently,
it broke a number of working setups. If the server doesn't support
extended security, then there is no way to recover. This is mostly due
to the fact that CIFS handles the selection of the authentication to use
badly. It makes that decision before ever talking to the server.  If it
guesses wrong, then there is no recourse.

At SambaXP this year, I also spoke with Simo Sorce about making cifs.ko
talk directly to the new gssproxy daemon to handle GSSAPI auth. I think
that would be a good thing to do. Doing that would allow us to get out
of the ASN.1 parsing business for the most part, and allow cifs to
support things like NegoEx. We can't reasonably support that though with
the code as rickety as it is today.

This patchset represents an overhaul of how cifs.ko selects the type of
authentication to use with the server. The idea here is to defer that
decision until SESSION_SETUP time, so that we can make an intelligent
decision about it based on the results of the NEGOTIATE.

The first several patches in the series represent some cleanup of dead
and broken code and struct fields that are unused. Next, chunks of
CIFSSMBNegotiate are factored out into helper functions. Next, we change
how the auth selection is done, and do that using securityEnum values
and a flag for signing, rather than trying to pass around variants of
SecurityFlags.

Lastly, there are a couple of patches that try to bring some sanity to
the SecurityFlags interface.

I'd like to see this merged for 3.11, so getting it into linux-next soon
would be good. Once this is merged, we can start looking at how best to
integrate gssproxy with cifs.ko as well.

Comments and suggestions welcome...

Jeff Layton (19):
  cifs: remove protocolEnum definition
  cifs: remove useless memset in LANMAN auth code
  cifs: make decode_ascii_ssetup void return
  cifs: throw a warning if negotiate or sess_setup ops are passed NULL
    server or session pointers
  cifs: remove the cifs_ses->flags field
  cifs: remove "seal" stubs
  cifs: break out decoding of security blob into separate function
  cifs: break out lanman NEGOTIATE handling into separate function
  cifs: move handling of signed connections into separate function
  cifs: factor out check for extended security bit into separate
    function
  cifs: add new "Unspecified" securityEnum value
  cifs: track the flavor of the NEGOTIATE reponse
  cifs: add new fields to smb_vol to track the requested security flavor
  cifs: add new fields to cifs_ses to track requested security flavor
  cifs: track the enablement of signing in the TCP_Server_Info
  cifs: move sectype to the cifs_ses instead of TCP_Server_Info
  cifs: update the default global_secflags to include "raw" NTLMv2
  cifs: clean up the SecurityFlags write handler
  cifs: try to handle the MUST SecurityFlags sanely

 fs/cifs/cifs_debug.c    |  48 +++++-
 fs/cifs/cifsencrypt.c   |   5 +-
 fs/cifs/cifsfs.c        |  13 +-
 fs/cifs/cifsglob.h      |  35 ++---
 fs/cifs/cifspdu.h       |   4 +-
 fs/cifs/cifsproto.h     |   3 +
 fs/cifs/cifssmb.c       | 405 ++++++++++++++++++++++--------------------------
 fs/cifs/connect.c       | 156 +++++++------------
 fs/cifs/misc.c          |   3 +-
 fs/cifs/sess.c          |  95 +++++++++---
 fs/cifs/smb1ops.c       |  21 +--
 fs/cifs/smb2pdu.c       | 114 ++++----------
 fs/cifs/smb2transport.c |   3 +-
 fs/cifs/transport.c     |   4 +-
 14 files changed, 427 insertions(+), 482 deletions(-)

-- 
1.8.1.4
