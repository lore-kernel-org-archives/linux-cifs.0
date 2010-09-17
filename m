From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 20:44:22 -0400
Message-ID: <20100916204422.3d23313f@corrin.poochiereds.net>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100916195402.0573dcc0-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Sep 2010 20:00:14 -0400
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
> >the cifs.ko module (you can do this by running modinfo on 
> >cifs.ko)
> >
> 
> Thank you for the follow-up.  Per my last message this was my 
> being a clueless in regards to the lack of hard/soft link 
> support in the old version.  'modinfo' pegs it as 1.60RH.
> 
> Hopefully RHEL6 will include CIFS file links as it might work 
> better to compile on Linux from a Windows share rather than 
> vice-versa.  'makedepend' runs painfully slow from Windows over
> a Samba share unless IPoIB is used for transport.
> 
> Perhaps I'll try it under Fedora, though in general I find 
> wrestling with the constant change of the moving-target distro 
> too much.
> 
> It is quite encouraging to see CIFS work in general.  Last time 
> I tried three or four years ago the system crashed shortly after 
> issuing the mount command.
> 

RHEL6 is fairly current with mainline code (at least as of this past
spring or so). If it works OK on Fedora, it should be OK in RHEL6.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
