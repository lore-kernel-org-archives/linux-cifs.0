From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Fri, 05 Jul 2013 17:50:27 -0400
Message-ID: <1373061027.2261.14.camel@tlielax.poochiereds.net>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
	 <CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
	 <20130705184031.67afd669@f163.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130705184031.67afd669-c9q3rVCHQSqoYr4blSSd5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2013-07-05 at 18:40 +0200, David Disseldorp wrote:
> On Thu, 4 Jul 2013 14:43:23 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > I merged an equivalent but slightly smaller version of your patch into
> > cifs-2.6.git (see below) and added stable since we should not be
> > returning nlink of 0.  Let me know if any objections.
> 
> Looks good to me Steve.
> FWIW, I've been using the following patch to replicate the
> NumberOfLinks=0 behaviour on Samba:
> http://gitweb.samba.org/?p=ddiss/samba.git;a=commitdiff;h=93c8795c9a9e9f
> 
> Cheers, David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm sorry, this patch is incomplete.

It ignores the readdir codepath completely. If Steve has already merged
this, then it needs a follow-on patch that fixes the readdir code too,
probably with the same workaround in cifs_fill_common_info.

Otherwise, you're going to end up with different st_nlink values
depending on whether it got instantated by a readdir() or stat().

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
