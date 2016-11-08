From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 0/6] Add support for DFS in smb2+
Date: Tue,  8 Nov 2016 17:33:20 +0100
Message-ID: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This series of patch tries to implement the get_dfs_refer operation
for smb2.

In smb2+, DFS resolving is now done through an FSCTL. The relevant
Microsoft specifications for this are:

MS-SMB2: 3.2.4.20   Application Requests an IO Control Code Operation
MS-SMB2: 3.2.4.20.3 Application Requests DFS Referral Information
MS-SMB2: 3.2.5.14   Receiving an SMB2 IOCTL Response
MS-SMB2: 3.2.5.14.4 Handling a DFS Referral Information Response

MS-DFSC: 2.2  Message Syntax (but really the whole document is useful)

I've managed to make it work while keeping the same prototype for the
operation but I believe it should be changed to be more correct and
closer to the rest of the smb2 code.

I've sucessfuly tested this against a Windows Server 2016 DFS setup.

There are some things that I'm not sure how to do properly:

* find the right tcon from the session object
* find the IPC tcon from the share tcon

I suspect these can be solved by changing the operation prototype so
it provides the right objects (tcon, cifs_sb, ...).

There are some things I've worked around:

* SMB2_ioctl() explicitely checks for DFS requests and uses the IPC tid
* since the tcon in build_path_from_dentry() does *not* have the
  IN_DFS_SHARE flag (I don't know why that is, because it is set in
  smbv1) I've added a new version of the function that uses an boolean
  argument to control whether or not to prefix the tree name. this
  version is only called once in the smb-generic code that deals with
  DFS.

You will find more information in the commit messages. Any help
solving these issues is welcome.

Aurelien Aptel (6):
  fs/cifs: add smb2 fsctl payloads for DFS resolving
  fs/cifs: implement get_dfs_refer for smb2
  fs/cifs: always use ipc for DFS resolving ioctls
  fs/cifs: add build_path_from_dentry_optional_prefix()
  fs/cifs: always use tree name prefix for DFS resolving
  fs/cifs: enable get_dfs_refer operation for smb2+

 fs/cifs/cifs_dfs_ref.c |   2 +-
 fs/cifs/cifsproto.h    |   1 +
 fs/cifs/dir.c          |  12 ++-
 fs/cifs/smb2ops.c      | 210 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c      |   4 +
 fs/cifs/smb2pdu.h      |  15 ++++
 6 files changed, 241 insertions(+), 3 deletions(-)

-- 
2.1.4
