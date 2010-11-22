From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: use CreationTime like an i_generation field
Date: Mon, 22 Nov 2010 15:31:25 -0500
Message-ID: <20101122153125.68ee4ee6@corrin.poochiereds.net>
References: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
	<1277723413-23769-3-git-send-email-jlayton@redhat.com>
	<20101122145541.2ab3536f@corrin.poochiereds.net>
	<AANLkTimtg0vFVQ5HGo+nq7rE=Z4Sob=z7LuVCMFgWdnv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimtg0vFVQ5HGo+nq7rE=Z4Sob=z7LuVCMFgWdnv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Nov 2010 14:22:50 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Nov 22, 2010 at 1:55 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Mon, 28 Jun 2010 07:10:12 -0400
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >
> > Steve, can you clarify where we are with this patch? I originally sent
> > this back in June. You and I discussed this at the CIFS plugfest and I
> > had thought you had decided to merge it. It's still not in your tree
> > however. Can you give a verdict on whether you're going to merge it and
> > let me know when I can expect to see it in your tree if so?
> >
> >
> Thanks for reminding me.  I had forgotten to ask JRA about a question
> on legacy Samba behavior.   I remembered that older Samba
> had problems with creation time - and was trying to remember what
> the implication of using this patch with older Samba was.
> 

All samba versions have issues with create times (at least on Linux
anyway). They fake them, by using the ctime (which seems like an odd
choice to me) in most cases.

Either way, let me know when you decide or if you have a question on
this.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
