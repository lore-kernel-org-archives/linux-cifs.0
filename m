From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mtab: handle ENOSPC/EFBIG condition properly when
 altering mtab (try #2)
Date: Tue, 12 Jul 2011 08:22:22 -0400
Message-ID: <20110712082222.6884655f@tlielax.poochiereds.net>
References: <1310471623-1407-1-git-send-email-jlayton@samba.org>
	<4E1C3B74.5090103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E1C3B74.5090103-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Jul 2011 17:47:56 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 07/12/2011 05:23 PM, Jeff Layton wrote:
> > This patch is mostly the same as the original. The only difference is
> > that it also attempts an ftruncate if the addmntent call fails.
> > 
> > It's possible that when mount.cifs goes to append the mtab that there
> > won't be enough space to do so, and the mntent won't be appended to the
> > file in its entirety.
> > 
> > Add a my_endmntent routine that will fflush and then fsync the FILE if
> > that succeeds. If either fails then it will truncate the file back to
> > its provided size. It will then call endmntent unconditionally.
> > 
> > Have add_mtab call fstat on the opened mtab file in order to get the
> > size of the file before it has been appended. Assuming that that
> > succeeds, use my_endmntent to ensure that the file is not corrupted
> > before closing it. It's possible that we'll have a small race window
> > where the mtab is incorrect, but it should be quickly corrected.
> > 
> > This was reported some time ago as CVE-2011-1678:
> > 
> >     http://openwall.com/lists/oss-security/2011/03/04/9
> > 
> > ...and it seems to fix the reproducer that I was able to come up with.
> > 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  mount.cifs.c |   27 +++++++++++++++++++++++++--
> >  mount.h      |    1 +
> >  mtab.c       |   27 +++++++++++++++++++++++++++
> >  3 files changed, 53 insertions(+), 2 deletions(-)
> 
> 
> Looks good to me.
> 
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> 

Thanks -- patch committed...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
