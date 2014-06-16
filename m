From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5 v4] Split CIFS_SessSetup()
Date: Mon, 16 Jun 2014 15:35:23 +0100
Message-ID: <1402929328-12866-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am investigating the possibility of adding support for gss-proxy in the
cifs client module. As part of that investigation, I was looking at the
CIFS_SessSetup() function. This is a long function which handles multiple auths
using if conditions and switch statements. The code struction makes it
difficult to modify or add support for new authentication mechanisms.

The proposal is to split the various authentication code into its own separate
functions. This increases the lines of code but will simplify maintenance and
addition of new auth methods.

The short term goal is to add gss-proxy support for kerberos authentication.
This will require to and fro communication with the gss-proxy module over a
unix socket.

Further long term goals are 
1) Add support for NTLMSSP using SPNEGO,
2) Allow clients to negotiate which authentication mechanism to use using SPNEGO.

V2:
- Ensure that sess_data allocated on intermediate patches are freed.
- Remove ifdef-endif blocks from the switch statement in CIFS_SessSetup().

V3:
- Fix whitespace errors in some patches.
- Change sess_establish_session to return errors. Call this function only in
  case of successful establish session calls to the server.
- Delete an incorrect comment in case of rawntlmssp authentication.
- Delete an if statement before kfree(ntlmssp) in rawntlmssp authentication.

v4:
- reordered elements of struct sess_data as asked by jlayton
- Use free_rsp_buf() to clean buffer.
- Clean up the rawntlmssp case further and break the calls into separate
  functions.

Sachin Prabhu (5):
  cifs: replace code with free_rsp_buf()
  cifs: Split lanman auth from CIFS_SessSetup()
  cifs: Split ntlm and ntlmv2 authentication methods off
    CIFS_SessSetup()
  cifs: Split Kerberos authentication off CIFS_SessSetup()
  cifs: Separate rawntlmssp auth from CIFS_SessSetup()

 fs/cifs/cifsproto.h |    1 +
 fs/cifs/cifssmb.c   |   20 +-
 fs/cifs/misc.c      |    9 +
 fs/cifs/sess.c      | 1192 ++++++++++++++++++++++++++++++++++++---------------
 fs/cifs/smb2pdu.c   |   10 -
 5 files changed, 854 insertions(+), 378 deletions(-)

-- 
1.9.3
