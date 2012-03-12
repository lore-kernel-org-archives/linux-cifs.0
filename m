From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Mon, 12 Mar 2012 11:09:37 -0400
Message-ID: <20120312110937.60a6f0ed@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
	<CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
	<20120309073930.3a79fa10@redhat.com>
	<CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
	<4F5A543D.2040808@samba.org>
	<20120309201439.GH9348@samba2>
	<CAH2r5mvMWOVrKXYJjcKYwUR+yaJpzYysDoc+TvPmfN+RDHAQ5g@mail.gmail.com>
	<4F5A712C.8030500@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5A712C.8030500-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 09 Mar 2012 15:07:56 -0600
"Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On 03/09/2012 02:16 PM, Steve French wrote:
> > On Fri, Mar 9, 2012 at 2:14 PM, Jeremy Allison<jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>  wrote:
> >> On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote:
> >>>
> >>> The folks at Microsoft (who are, of course, well ahead in their
> >>> SMB2.x implementations) are very surprised that we are trying to
> >>> maintain a single codebase for both protocols.  (I heard the same
> >>> thing from several Microsoft engineers during separate
> >>> conversations.)
> >>
> >> That's just a misunderstanding of how our codebase is
> >> structured, that's all.
> >>
> >> The SMB1 parser/protocol engine is completely different code from the SMB2
> >> parser/protocol engine in Samba.
> >>
> >> What is in common (as is also in common in Microsoft's codebase)
> >> is the code that implements the underlying file system functionality.
> >>
> >> They have a common NTFS (and now ReFS) codebase, we have a common
> >> map POSIX to Windows semantics layer.
> >
> > On the client side, as a compromise with those who wanted one module,
> > (ie in Pavel's tree) we keep the majority of the smb2 specific code in
> > distinct c files
> > which are not linked in by default to cifs.ko.   Sharing the same transport code
> > does have headaches though as the discussion above mentions with regard
> > to "credits" vs. "maxmpx" but it has turned out better than I originally
> > expected (ie the changes to common code)
> 
> No doubt.
> 
> ...and we certainly want only one piece of code actually creating and 
> managing connections to the server.
> 

(sorry for the long delay in responses here, we just got a newborn baby
at home and I've been a little busy ;)

Yep. There are probably more pieces that will be shared, but we really
*do not* want to do what was done in the initial pass here. A basically
a wholesale copy and paste of fs/cifs into fs/smb2 with "s/cifs/smb2/g"
done over it. Steve tried that for a while and it was a mess -- bugs
would get fixed in fs/cifs but not fs/smb2 and vice versa.

We'll get far more benefit and less maintenance hassle over the long
haul by expanding the infrastructure to be able to handle both
protocols correctly.

Here's sort of what I would envision but we may need to alter it as we
find problems. I think we should model this similarly to how the NFS
code is layed out:

The transport layer should be unified. Basically we don't need an
entirely separate set of code handling sockets, etc. Also, the code
that handles NEGOTIATE ought to eventually be somewhat integrated as
well. We do want to be able to handle the smb1/2 protocol negotiation
a'la section 4.2 of MS-SMB2. That's not necessary initially, but is a
nice to have eventually.

By the same token we do not want a separate fs_type for smb2. We went
down that road with nfs vs nfs4 and it's still a headache today. We'll
be happier if we can keep that unified between the two protocols.

We'll probably want a unified superblock for the fs, though I would
envision that we may want a union or something inside the struct for
smb1 or smb2 specific parts.

inode and dentry operations can probably be the same for the most part,
but we may want smb1/2 specific ones in some cases. Below that, there
should be a set of protocol-level operations.

For instance, we might have a Linux VFS inode operation for doing an
open that we share between both protocols, but that calls out to a set
of protocol specific operations to do the actual call on the wire.
Where the protocols are widely divergent in behavior we may need
specific inode and dentry operations for each protocol as well.

Obviously as things move along we may need to abstract out more or
fewer pieces, but keeping code duplication to a minimum ought to be a
design goal.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
