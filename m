From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: Remapping the seven reserved characters in UCS-2 when in file names
Date: Tue, 23 Sep 2014 09:59:00 +0100
Message-ID: <9540BB2E-F7D1-4F41-90FF-96602AFE9B1E@cam.ac.uk>
References: <CAH2r5mvGyASEOnFJPs=cCAO21KSpsMZdGkuG_kRcZLf1Xwg_WQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: samba-technical <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvGyASEOnFJPs=cCAO21KSpsMZdGkuG_kRcZLf1Xwg_WQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi,

On 23 Sep 2014, at 03:27, Steve French <smfrench@gmail.com> wrote:
> The question of how to best handle the seven reserved characters
> (those that are ok in POSIX, but not in Windows, NTFS, CIFS and
> SMB2/3) when mapping to/from UCS-2 came up again.  These characters
> are:
> 
>            : \ * < > ? |
> 
> The mac maps these to 0xF021 through 0xF027 (apparently was used in
> the old "Services for Mac").

Yes it was.  It was the AFP server for Windows effectively.  It also defined how to store finder information, resource fork, etc (on NTFS anyway) which is why I implemented support for all of those when writing the NTFS kernel driver that is now in Mac OS X.  On Mac OS X cifs/smb also implement the same so they are all compatible in what they do.

All the names/layout relevant to above can be seen for example in the ntfs_sfm.h header file I wrote (including documentation at the top):

	http://www.opensource.apple.com/source/ntfs/ntfs-83/kext/ntfs_sfm.h

> cifs.ko instead use the normal UCS-2
> remap range for this in order to convert this to/from UTF8 as did
> Windows Services for Unix ie "SFU" and "SUA" components of Windows
> (basically this add 0xF000 to the 7 reserved characters to get its
> mapping e.g. 0xF02A for asterisk).  cifs mounts allow using such
> characters when mounted with mount option "mapchars" by following the
> SFU style mapping.  This mount option is unneeded if we are mounted to
> Samba (with POSIX extensions) but is helpful when mounting to Mac or
> Windows or other NAS (which do not support the CIFS UNIX/POSIX
> extensions).
> 
> Since we can't use both mappings at the same time (even though they
> don't overlap, and they both use a reserved range of UCS-2 it would
> fail if we list directory contents which contained a filename with a
> character mapped Apple style but tried to open it with the normal Unix
> mapping or vice versa) - we need to use only one mapping at a time.
> 
> So basically as some on the Samba team noted - there are three cases:
> 
> 1) use the apple mapping
> 2) use the SFU mapping ("mapchars")
> 3) don't remap the seven characters (they will be reported with a '?'
> in some characters and won't be able to be opened)
> 
> With SMB3 we want to do the right thing by default, and given that Mac
> already maps these to 0xF021 through 0xF027 it may be easier to
> default to that.
> 
> The suggestion was to do the following for smb2/smb2.1/smb3
> 1) default to Apple mapping ("services for mac" style mapping) of the
> 7 characters
> 2) turn off the Apple style mapping and use the SFU mapping instead if
> "mapchars" is specified on mount
> 3) don't map the seven characters at all if "nomapchars" is specified on mount

I think that would make sense given that on Mac OS X, everything uses the "Apple mapping" as you call it whilst on Windows no remapping happens by default (AFAIK) unless Services for Unix are enabled and you are using the POSIX subsystem.

So it is perfectly sensible to do it the Apple way by default but to allow people using SFU to switch to that mapping with an option like mapchars and for "Windows purists" allowing turning all remapping off is also good.

> For cifs we could leave the behavior unchanged (which is basically,
> don't map unless "mapchars" is specified on mount and if it is
> specified map the seven characters SFU style) or change to the
> behavior above.  No mapping is needed if cifs unix extensions are
> negotiated (mounts to Samba).

Would it not make sense to behave the same regardless of which on the wire protocol is used?  I think it would and would be in favour of changing the behaviour to match the smb2/smb2.1/smb3 behaviour.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

