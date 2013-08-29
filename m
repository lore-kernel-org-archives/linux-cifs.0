From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/3] Change session key to per smb session for smb2 and smb3
Date: Thu, 29 Aug 2013 08:35:08 -0500
Message-ID: <1377783311-3924-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


This patchset makes changes to make session key used for smb signature
generation, per smb session from per smb connection, for smb2 and smb3.
For smb1, the scheme remains the same.

Patch 1 separates common post session setup processing to dialet
specific processing.  smb3 also generates signing key (based on
session key) which is used in signature generation instead of session key.

Patch 2 enables that the keys are exchanged during session setup with
NTLMSSP authentication mechanism for smb2 and smb3

Patch 3 starts using the per session session keys for signature generation
for smb2 and smb3 after finding for a matching session in the linked list
off of smb connection structure.



Shirish Pargaonkar (3):
  cifs: Process post session setup code in respective dialect functions.
  cifs: Add a variable specific to NTLMSSP for key exchange.
  cifs: Start using per session key for smb2/3 for signature generation

 fs/cifs/cifsglob.h      |  6 ++---
 fs/cifs/cifsproto.h     |  2 +-
 fs/cifs/connect.c       | 27 +------------------
 fs/cifs/misc.c          |  1 +
 fs/cifs/sess.c          | 48 +++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.c       | 42 +++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c | 70 ++++++++++++++++++++++++++++++++++++-------------
 7 files changed, 143 insertions(+), 53 deletions(-)

-- 
1.8.1.2
