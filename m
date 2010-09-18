From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: question about CIFS client glitches
Date: Sat, 18 Sep 2010 07:25:02 -0400
Message-ID: <20100918072502.73987a62@corrin.poochiereds.net>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
	<6.2.5.6.2.20100917193123.056b6f78@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100917193123.056b6f78-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 19:38:21 -0400
starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org wrote:

> At 05:50 PM 9/16/2010 -0500, Steve French wrote:
> >On Thu, Sep 16, 2010 at 4:39 PM,  <starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org> wrote:
> >> Trying out a CIFS mount of a W2K8 x64 file system from CentOS
> >> 5.5 and running into problems, and trying to figure out how to
> >> proceed.
> ...
> >
> >This is quite old kernel, but perhaps it was updated to include more
> >recent fixes - can you view the version information on the file, ie
> >the cifs.ko module (you can do this by running modinfo on cifs.ko)
> 
> 
> Tried the RHEL6 beta 2 and it behaves the same as RHEL 5.5.
> 'modinfo' output for both attached.  'cifs.ko' versions are
> 1.60RH and 1.63.
> 
> In both versions it seems like hard-links work and symbolic
> links fail with
> 
>    ln: creating symbolic link `zzzz': Operation not supported
> 

That's expected. The core cifs protocol as implemented in windows
doesn't support symlinks. You need unix extensions for that, or you may
want to play with the "mfsymlinks" patches that Metze proposed recently.

> And it appears that a 'pax -r' extraction followed by 'rm' for
> selected files has some difficulty with CIFS 1.6x rendered
> hard link in the mix.
> 
> I'm probably giving up on the idea for now, but thanks
> for your help.

What sort of difficulty is it having?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
