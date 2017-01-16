From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: SMB2: Enforce sec= mount option
Date: Mon, 16 Jan 2017 11:19:03 +0530
Message-ID: <1484545743.2471.9.camel@redhat.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
         <58756A3D.6000705@tlinx.org>
         <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM3S+p3sU26LKGwqaZ_3g4gkPPzEFzohwAFOa-PZPqZTAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-01-11 at 15:02 -0600, Scott Lovenberg wrote:
> On Tue, Jan 10, 2017 at 5:11 PM, L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
> > Sachin Prabhu wrote:
> > > 
> > > If the security type specified using a mount option is not
> > > supported,
> > > the SMB2 session setup code changes the security type to
> > > RawNTLMSSP. We
> > > should instead fail the mount and return an error.
> > > 
> > 
> > ---
> > Saw the comment by Steve F, and it got me to thinking.
> > Please take this as a suggestion or idea...  I'm not
> > heavily committed to a single solution, at this point, as
> > haven't really thought through all of the ramifications.
> > 
> > Is it possible to add a 'prefix' or 'suffix', like an
> > "=" sign or a '+' -- to mean:
> > 
> > '=' = exactly this 'sec' level
> > '+' = this 'sec'-level or greater
> > '<' = less than or equal to this sec-level
> > ---
> > Using the symbols is a similar idea to some fields in
> > 'find' where +/- are used to indicate greater or less than
> > the stated number.
> > 
> > I'm not sure about the symbols, exactly, but I know in samba I
> > ask for smb2 for the protocol and more often than not, only
> > get smb1, but I'd rather have it work than fail.
> > 
> > Since I'm on a closed net, I'd have to say the same for
> > security options, but I'd like to have a choice to force it
> > if I wanted to...
> > 
> > Anyway -- just an idea that might offer more flexibility than just
> > 'fail'...
> > 
> 
> It'd take a tiny bit of messing with the command line parser, but I'd
> be for that.  As a gesture of good faith, since I raised the issue,
> I'd be willing to submit the patch set for mount.cifs to support this
> if everyone is on board.  I'd suggest staying away from '<' and '>'
> as
> they're shell redirects though.  This would be a reasonable shorthand
> for a comma separated list (which also might take a bit of messing
> with the parser since we split on ',') - it could reasonably loop in
> the userland mount helper, mount.cifs, in much the same way Steve
> suggested that it should be handled in userland.
> 

I think the userland would be a good option to handle this as I suspect
it may be much easier to  recover from mount failures and to attempt a
remount from userland.
