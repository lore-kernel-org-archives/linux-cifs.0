From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 0/6] Add support for DFS in SMB2+
Date: Thu, 23 Feb 2017 15:43:28 +0100
Message-ID: <20170223144334.22320-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This series of patch tries to implement the get_dfs_refer operation
for SMB2+.

In SMB2+, DFS resolving is now done through an FSCTL (patch #3). The
relevant Microsoft specifications for this are:

MS-SMB2: 3.2.4.20   Application Requests an IO Control Code Operation
MS-SMB2: 3.2.4.20.3 Application Requests DFS Referral Information
MS-SMB2: 3.2.5.14   Receiving an SMB2 IOCTL Response
MS-SMB2: 3.2.5.14.4 Handling a DFS Referral Information Response

MS-DFSC: 2.2  Message Syntax (but really the whole document is useful)

The DFS response payload however is identical. Patch #1 moves the
DFS response parsing out of SMB1 code and makes it work on any version
of SMB.

DFS code has 2 "main" entry points: initial mounting and automount
(when a DFS link is accessed/traversed).

When automounting, cifs.ko calls build_path_from_dentry() which only
makes treename-prefixed paths when the tcon has the
SMB_IN_DFS_SHARE. This flag is checked in tcon->Flags which is never
touched by SMB2 code as it sets tcon->share_flags on connexion.

* CIFS requires to prefix all pathnames with the treename prefix when
  connected to a DFS server, so the current build_path_from_dentry()
  makes sense for CIFS. 
* For SMB2+ it seems only the Create request requires the treename
  prefix. Simply making the function check for both CIFS SMB2+ flag
  for DFS to add a prefix does not work as the server has different
  expectations about which packet can have/require a DFS pathname.

Patch #2 adds build_path_from_dentry_optional_prefix() with an extra
bool arg to decide to prefix or not. The automount code path always
ask for it. Patch #5 modifies SMB2_open() to add the treename prefix
to the given path if the server requires it.

As part of the mouting process a IPC tcon is made (I suspect we don't
need it anymore in SMB3). This tcon doesn't respect the signing
requirement. This is fixed by patch #4.

Finally the SMB2+ implementation of the get_dfs_referral operation is
added in all supported SMB versions in patch #6.

I've sucessfuly tested this against a Windows Server 2016 DFS
setup. Samba requires a patch as currently it only accepts DFS
referrals requests on an IPC connexion, which is in violation of the
spec. A patch was sent on samba-technical:

https://lists.samba.org/archive/samba-technical/2017-February/118859.html

Changes since v1:

* The fsctl is made on the first available tcon to the server, which
  is allowed by the spec. This way we avoid hardcoding additional
  rules in SMB2_ioctl().
* add signing flag in smb2 header if required
* no copy/pasting, the DFS parsing code is now generic and works for
  both SMB versions
* add treename prefix in SMB2_open() when required

Aurelien Aptel (6):
  CIFS: move DFS response parsing out of SMB1 code
  CIFS: add build_path_from_dentry_optional_prefix()
  CIFS: implement get_dfs_refer for SMB2+
  CIFS: set signing flag in SMB2+ TreeConnect if needed
  CIFS: use DFS pathnames in SMB2+ Create requests
  CIFS: enable get_dfs_refer for SMB2+

 fs/cifs/cifs_dfs_ref.c |   4 +-
 fs/cifs/cifspdu.h      |  16 ++++---
 fs/cifs/cifsproto.h    |   7 +++
 fs/cifs/cifssmb.c      | 119 +++----------------------------------------------
 fs/cifs/dir.c          |  13 +++++-
 fs/cifs/misc.c         | 105 +++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c      |  76 +++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c      |  97 ++++++++++++++++++++++++++++++++--------
 fs/cifs/smb2pdu.h      |   8 ++++
 9 files changed, 305 insertions(+), 140 deletions(-)

-- 
2.10.2
