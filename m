From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/7] Add support for DFS in SMB2+
Date: Wed, 1 Mar 2017 22:41:28 -0600
Message-ID: <CAH2r5mu2C200nBkgbaSwHSFEkR0Ld5AuQspyGpWJcveZcs=CAA@mail.gmail.com>
References: <20170228184034.18771-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged v4 of this into cifs-2.6.git for-next

On Tue, Feb 28, 2017 at 12:40 PM, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrote:
> This series of patch tries to implement the get_dfs_refer operation
> for SMB2+.
>
> In SMB2+, DFS resolving is now done through an FSCTL (patch #7). The
> relevant Microsoft specifications for this are:
>
> MS-SMB2: 3.2.4.20   Application Requests an IO Control Code Operation
> MS-SMB2: 3.2.4.20.3 Application Requests DFS Referral Information
> MS-SMB2: 3.2.5.14   Receiving an SMB2 IOCTL Response
> MS-SMB2: 3.2.5.14.4 Handling a DFS Referral Information Response
>
> MS-DFSC: 2.2  Message Syntax (but really the whole document is useful)
>
> The DFS response payload however is identical. Patch #1 moves the
> DFS response parsing out of SMB1 code and makes it work on any version
> of SMB.
>
> DFS code has 2 "main" entry points: initial mounting and automount
> (when a DFS link is accessed/traversed).
>
> When automounting, cifs.ko calls build_path_from_dentry() which only
> makes treename-prefixed paths when the tcon has the
> SMB_IN_DFS_SHARE. This flag is checked in tcon->Flags which is never
> touched by SMB2 code as it sets tcon->share_flags on connexion.
>
> * CIFS requires to prefix all pathnames with the treename prefix when
>   connected to a DFS server, so the current build_path_from_dentry()
>   makes sense for CIFS.
> * For SMB2+ it seems only the Create request requires the treename
>   prefix. Simply making the function check for both CIFS SMB2+ flag
>   for DFS to add a prefix does not work as the server has different
>   expectations about which packet can have/require a DFS pathname.
>
> Patch #2 adds build_path_from_dentry_optional_prefix() with an extra
> bool arg to decide to prefix or not. The automount code path always
> ask for it. Patch #6 modifies SMB2_open() to add the treename prefix
> to the given path if the server requires it.
>
> We try to use an IPC connection first for the DFS request. Patch #3
> adds a flag to SMB2_ioctl() to force the usage of ipc_tid. The SMB2
> get_dfs_refer operation tries with the flag set and fallback to a
> share connection if that doesn't work.
>
> Patch #4 updates the type of ipc_tid from u16 to u32 as that is what a
> Tid is in SMB2+. This is correct and really needed since in SMB2 Samba
> doesn't use sequential tree id but random ones in the 32bit space.
>
> As part of the mouting process a IPC tcon is made (I suspect we don't
> need it anymore in SMB3). This tcon doesn't respect the signing
> requirement. This is fixed by patch #5.
>
> Finally the SMB2+ implementation of the get_dfs_referral operation is
> added in all supported SMB versions in patch #7.
>
> I've sucessfuly tested this (v1.0 and v3.0) against a Windows Server
> 2016 DFS setup and a Samba DFS setup.
>
> Samba used to only accepts DFS referrals requests on an IPC connexion,
> which is in violation of the spec. A patch was sent on samba-technical
> and merged. It is not required anymore.
>
> https://lists.samba.org/archive/samba-technical/2017-February/118859.html
>
> Changes since v2:
>
> * add use_ipc flag to SMB2_open()
> * make smb2_get_dfs_refer() try IPC connections first
> * use first_entry_or_null() instead of first_entry() on the tcon list
> * protect tcon list access with spinlock
> * add inc/dec of the tcon reference number, protected by spinlock
>
> Aurelien Aptel (7):
>   CIFS: move DFS response parsing out of SMB1 code
>   CIFS: add build_path_from_dentry_optional_prefix()
>   CIFS: add use_ipc flag to SMB2_ioctl()
>   CIFS: let ses->ipc_tid hold smb2 TreeIds
>   CIFS: set signing flag in SMB2+ TreeConnect if needed
>   CIFS: use DFS pathnames in SMB2+ Create requests
>   CIFS: implement get_dfs_refer for SMB2+
>
>  fs/cifs/cifs_dfs_ref.c |   4 +-
>  fs/cifs/cifsglob.h     |   2 +-
>  fs/cifs/cifspdu.h      |  16 ++++---
>  fs/cifs/cifsproto.h    |   7 +++
>  fs/cifs/cifssmb.c      | 119 ++---------------------------------------------
>  fs/cifs/dir.c          |  13 +++++-
>  fs/cifs/misc.c         | 105 +++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2file.c     |   3 +-
>  fs/cifs/smb2ops.c      | 123 ++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/smb2pdu.c      | 114 +++++++++++++++++++++++++++++++++++++--------
>  fs/cifs/smb2pdu.h      |   8 ++++
>  fs/cifs/smb2proto.h    |   3 +-
>  12 files changed, 365 insertions(+), 152 deletions(-)
>
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
