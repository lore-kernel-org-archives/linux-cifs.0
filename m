From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] RFC: Split CIFS_SessSetup()
Date: Mon, 28 Apr 2014 15:12:26 +0100
Message-ID: <1398694350-8526-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am investigating the possibility of adding support for gss-proxy in the
cifs client module. As part of that investigation, I was looking at the
CIFS_SessSetup() function. This is a long function which handles multiple auths
using if conditions and switch statements. The code struction makes it
difficult to modify of add support for new authentication mechanisms.

The proposal is to split the various authentication code into its own separate
functions. This increases the lines of code but will simplify maintenance and
addition of new auth methods.

The short term goal is to add gss-proxy support for kerberos authentication.
This will require to and fro communication with the gss-proxy module over a
unix socket.

Further long term goals are 
1) Add support for NTLMSSP using SPNEGO,
2) Allow clients to negotiate which authentication mechanism to use using SPNEGO.

I would like the opinion of this list about these proposed changes.
Is there any part of the code which needs changing?

Sachin Prabhu



Sachin Prabhu (4):
  cifs: Split lanman auth from CIFS_SessSetup()
  cifs: Split ntlm and ntlmv2 authentication methods off
    CIFS_SessSetup()
  cifs: Split Kerberos authentication off CIFS_SessSetup()
  cifs: Separate rawntlmssp auth from CIFS_SessSetup()

 fs/cifs/sess.c | 1118 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 775 insertions(+), 343 deletions(-)

-- 
1.8.4.2
