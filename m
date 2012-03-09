From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 9 Mar 2012 13:14:29 -0800
Message-ID: <20120309211429.GL9348@samba2>
References: <1329895984-9251-7-git-send-email-piastry@etersoft.ru>
 <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
 <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
 <20120303070921.5ce2bb10@tlielax.poochiereds.net>
 <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
 <20120309073930.3a79fa10@redhat.com>
 <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
 <4F5A543D.2040808@samba.org>
 <20120309201439.GH9348@samba2>
 <4F5A70A3.906@samba.org>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F5A70A3.906-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 09, 2012 at 03:05:39PM -0600, Christopher R. Hertel wrote:
> On 03/09/2012 02:14 PM, Jeremy Allison wrote:
> >On Fri, Mar 09, 2012 at 01:04:29PM -0600, Christopher R. Hertel wrote:
> >>
> >>The folks at Microsoft (who are, of course, well ahead in their
> >>SMB2.x implementations) are very surprised that we are trying to
> >>maintain a single codebase for both protocols.  (I heard the same
> >>thing from several Microsoft engineers during separate
> >>conversations.)
> >
> >That's just a misunderstanding of how our codebase is
> >structured, that's all.
> >
> >The SMB1 parser/protocol engine is completely different code from the SMB2
> >parser/protocol engine in Samba.
> 
> I was thinking of the CIFS client, which is what Jeff was talking about.

Then I am confused, sorry :-).

> Keep in mind, though, that SMB1 is dead and will never make use of
> things like durable, resilient, and persistent handles.  It will
> also never fully expose the semantics of ReFS.  Similarly, SMB2 will
> never need to worry about presenting DOS and OS/2 as SMB1 does.
> 
> So some of the semantics that file system mapping layer has to
> handle are going to be purely for one protocol or the other.  The
> biggest part of the overlap there will be NTFS semantics... which
> is, admittedly, the lions share of the market now and for some time
> to come.

So what we'll end up doing is migrating the layer to SMB2
semantics and then mapping the old SMB1 semantics into a
layer that goes on top (it's like one of those topological
tricks of turning a sphere inside out :-).

http://www.youtube.com/watch?v=BVVfs4zKrgk

We did it before when migrating from DOS semantics to
NT semantics.

Jeremy.
