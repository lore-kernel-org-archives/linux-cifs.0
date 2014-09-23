From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Remapping the seven reserved characters in UCS-2 when in file names
Date: Mon, 22 Sep 2014 21:27:28 -0500
Message-ID: <CAH2r5mvGyASEOnFJPs=cCAO21KSpsMZdGkuG_kRcZLf1Xwg_WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The question of how to best handle the seven reserved characters
(those that are ok in POSIX, but not in Windows, NTFS, CIFS and
SMB2/3) when mapping to/from UCS-2 came up again.  These characters
are:

            : \ * < > ? |

The mac maps these to 0xF021 through 0xF027 (apparently was used in
the old "Services for Mac"). cifs.ko instead use the normal UCS-2
remap range for this in order to convert this to/from UTF8 as did
Windows Services for Unix ie "SFU" and "SUA" components of Windows
(basically this add 0xF000 to the 7 reserved characters to get its
mapping e.g. 0xF02A for asterisk).  cifs mounts allow using such
characters when mounted with mount option "mapchars" by following the
SFU style mapping.  This mount option is unneeded if we are mounted to
Samba (with POSIX extensions) but is helpful when mounting to Mac or
Windows or other NAS (which do not support the CIFS UNIX/POSIX
extensions).

Since we can't use both mappings at the same time (even though they
don't overlap, and they both use a reserved range of UCS-2 it would
fail if we list directory contents which contained a filename with a
character mapped Apple style but tried to open it with the normal Unix
mapping or vice versa) - we need to use only one mapping at a time.

So basically as some on the Samba team noted - there are three cases:

1) use the apple mapping
2) use the SFU mapping ("mapchars")
3) don't remap the seven characters (they will be reported with a '?'
in some characters and won't be able to be opened)

With SMB3 we want to do the right thing by default, and given that Mac
already maps these to 0xF021 through 0xF027 it may be easier to
default to that.

The suggestion was to do the following for smb2/smb2.1/smb3
1) default to Apple mapping ("services for mac" style mapping) of the
7 characters
2) turn off the Apple style mapping and use the SFU mapping instead if
"mapchars" is specified on mount
3) don't map the seven characters at all if "nomapchars" is specified on mount

For cifs we could leave the behavior unchanged (which is basically,
don't map unless "mapchars" is specified on mount and if it is
specified map the seven characters SFU style) or change to the
behavior above.  No mapping is needed if cifs unix extensions are
negotiated (mounts to Samba).

-- 
Thanks,

Steve
