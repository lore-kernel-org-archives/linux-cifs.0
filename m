From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 9 Mar 2012 12:14:39 -0800
Message-ID: <20120309201439.GH9348@samba2>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
 <1329895984-9251-7-git-send-email-piastry@etersoft.ru>
 <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
 <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
 <20120303070921.5ce2bb10@tlielax.poochiereds.net>
 <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
 <20120309073930.3a79fa10@redhat.com>
 <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
 <4F5A543D.2040808@samba.org>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F5A543D.2040808-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote:
> 
> The folks at Microsoft (who are, of course, well ahead in their
> SMB2.x implementations) are very surprised that we are trying to
> maintain a single codebase for both protocols.  (I heard the same
> thing from several Microsoft engineers during separate
> conversations.)

That's just a misunderstanding of how our codebase is
structured, that's all.

The SMB1 parser/protocol engine is completely different code from the SMB2
parser/protocol engine in Samba.

What is in common (as is also in common in Microsoft's codebase)
is the code that implements the underlying file system functionality.

They have a common NTFS (and now ReFS) codebase, we have a common
map POSIX to Windows semantics layer.

Jeremy.
