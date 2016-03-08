From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NTFS pseudo-xattr
Date: Mon, 7 Mar 2016 23:21:18 -0600
Message-ID: <CAH2r5mtMs5wx7bb+56x4-TBtBsrB15NS_6FH=0iCh68ykofFDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: ntfs-3g-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I was prototyping returning some of the NTFS pseudo-extended
attributes in cifs.ko over SMB3 protocol (cifs.ko Linux kernel driver
for accessing Windows, Macs, Samba and various NAS devices using CIFS
or SMB3 protocol), and using the same names for convenience may be
useful if there are any tools that depend on these since they may be
reusable (and the metadata is very similar in NTFS and in the SMB3
protocol).   In ntfs-3g I noticed the following set of extended
attributes for the additional metadata that NTFS userspace driver can
return (and these pseudo-xattrs do seem to work on current Fedora when
I run getfattr on them e.g. "getattr -n system.ntfs_dos_name
filename"):

static const char nf_ns_xattr_ntfs_acl[] = "system.ntfs_acl";
static const char nf_ns_xattr_attrib[] = "system.ntfs_attrib";
static const char nf_ns_xattr_attrib_be[] = "system.ntfs_attrib_be";
static const char nf_ns_xattr_efsinfo[] = "system.ntfs_efsinfo";
static const char nf_ns_xattr_reparse[] = "system.ntfs_reparse_data";
static const char nf_ns_xattr_object_id[] = "system.ntfs_object_id";
static const char nf_ns_xattr_dos_name[] = "system.ntfs_dos_name";
static const char nf_ns_xattr_times[] = "system.ntfs_times";
static const char nf_ns_xattr_times_be[] = "system.ntfs_times_be";
static const char nf_ns_xattr_crtime[] = "system.ntfs_crtime";
static const char nf_ns_xattr_crtime_be[] = "system.ntfs_crtime_be";
static const char nf_ns_xattr_ea[] = "system.ntfs_ea";
static const char nf_ns_xattr_posix_access[] = "system.posix_acl_access";
static const char nf_ns_xattr_posix_default[] = "system.posix_acl_default";
static const char nf_ns_alt_xattr_efsinfo[] = "user.ntfs.efsinfo";

In addition, I see pseudo-xattr "ntfs.streams.list" in the ntfs source code,
but I get a "no such attribute" returned by getfattr when I try to
query that one directly unless
mounted with "streams_interface=windows"  The "-o user_xattr" mount
option doesn't seem to be good enough. Also FYI - I do have a patch to
cifs.ko to query this pseudo-xattr when mounted over SMB3 protocol.

Two quick questions:
1) are there ntfs userspace tools to more sanely dump the blobs for
any of these (e.g. for ACLs it could be similar to cacls.exe in
Windows or smbcacls in Samba/Linux and would be very useful for
viewing ACL information, for backup and for migration, but dumping the
creation time or reparse info could also be very useful).

2) Are there other psuedo-xattrs possible or being considered for
adding to ntfs-3g (e.g. for quota information, or for claims based
ACLs)?  I would like to use a similar format to make tools easier.
-- 
Thanks,

Steve
