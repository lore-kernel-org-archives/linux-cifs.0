From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Slow CIFS navigation due to excessive use of QUERY_PATH_INFO
Date: Mon, 21 Jun 2010 11:34:11 -0400
Message-ID: <20100621113411.01cb5e41@corrin.poochiereds.net>
References: <38a6d6051003081231q5fcec8ebi7bb49a8f3761649a@mail.gmail.com>
	<4BD5E7E8.3090508@clediere.net>
	<20100426153232.6eb907c7@tlielax.poochiereds.net>
	<4BD7F20C.4060901@clediere.net>
	<20100428062708.7e78cd2b@tlielax.poochiereds.net>
	<4C1F27E8.2010609@clediere.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: seb-XN6Y3A9Iwz7k1uMJSBkQmQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1F27E8.2010609-XN6Y3A9Iwz7k1uMJSBkQmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 21 Jun 2010 10:50:48 +0200
Sebastien Clediere <Seb-XN6Y3A9Iwz7k1uMJSBkQmQ@public.gmane.org> wrote:

> 
> > On Wed, 28 Apr 2010 10:30:04 +0200
> > Seb <Seb-XN6Y3A9Iwz7k1uMJSBkQmQ@public.gmane.org> wrote:
> >
> >   
> >> Jeff Layton wrote:
> >>     
> >>> On Mon, 26 Apr 2010 21:22:16 +0200
> >>> Seb <Seb-XN6Y3A9Iwz7k1uMJSBkQmQ@public.gmane.org> wrote:
> >>>
> >>>   
> >>>       
> >>>> Hi Jeff,
> >>>>
> >>>> Sorry to contact you direct. I tried to send this email to the cifs
> >>>> client mailing list a number of times without luck. I registered 2
> >>>> different accounts, but my email is always rejected now! I think the
> >>>> setting for spam of the list is a bit too aggressive. Anyway, that is
> >>>> the message:
> >>>>
> >>>> Seb.
> >>>>
> >>>>
> >>>> =======
> >>>> Going from kernel (x86) 2.6.27-8 (I am not sure which version of
> >>>> mount.cifs) to 2.6.31-19 with mount.cifs version: 1.12-3.4.0, I
> >>>> noticed an important decrease of performance while navigating CIFS
> >>>> shares on a Windows 2003 server. Navigating means here either using
> >>>> midnight commander, ls -l (with ls unaliased first...), rsync, etc..
> >>>>
> >>>> I added noserverino,nolinux to the mount command, but it does not make
> >>>> much difference.
> >>>>
> >>>> The kind of performance degradation I am talking about is in the order
> >>>> of times ten or so. An rsync which takes less that 2 minutes on old
> >>>> hardware, now takes over 15 minutes on newer hardware!
> >>>>
> >>>> Doing a bit of investigation with tcpdump, we can see a lot
> >>>> QUERY_PATH_INFO requests happening which are not necessary as all the
> >>>> information is already returned by FIND_FIRST2 requests. A trivial
> >>>> example will illustrate it. Lets have a directory with 3 files inside.
> >>>>
> >>>> ls -l with my old machine, it gives:
> >>>> Protocol Info
> >>>> SMB      Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path: \Temp
> >>>> SMB      Trans2 Response, QUERY_PATH_INFO
> >>>> SMB      Trans2 Request, FIND_FIRST2, Pattern: \Temp\*
> >>>> SMB      Trans2 Response, FIND_FIRST2, Files: . .. file1 file2 file3
> >>>>
> >>>>
> >>>> With the new one, it gives:
> >>>> Protocol Info
> >>>> SMB      Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path: \Temp
> >>>> SMB      Trans2 Response, QUERY_PATH_INFO
> >>>> SMB      Trans2 Request, FIND_FIRST2, Pattern: \Temp\*
> >>>> SMB      Trans2 Response, FIND_FIRST2, Files: . .. file1 file2 file3
> >>>> SMB      Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path:
> >>>> \Temp\file1
> >>>> SMB      Trans2 Response, QUERY_PATH_INFO
> >>>> SMB      Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path:
> >>>> \Temp\file2
> >>>> SMB      Trans2 Response, QUERY_PATH_INFO
> >>>> SMB      Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path:
> >>>> \Temp\file3
> >>>> SMB      Trans2 Response, QUERY_PATH_INFO
> >>>>
> >>>> So for every file in the directory, as returned by the FIRST_FIND2
> >>>> response, it does a QUERY_PATH_INFO, which does not bring any new
> >>>> information, all the attributes were already returned by FIRST_FIND2.
> >>>> I attached to the email the tcpdump so you can really double check by
> >>>> yourself that the QUERY_PATH info does not bring anything new.
> >>>>
> >>>> That is the cause of the slowness I notice.
> >>>> Is that a known issue?
> >>>>
> >>>> Thanks,
> >>>>
> >>>> Seb.
> >>>>
> >>>>     
> >>>>         
> >>> Does your kernel have this commit?
> >>>
> >>> commit f12f98dba6ea1517cd7fbb912208893b9c014c15
> >>> Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Date:   Fri Feb 5 13:14:00 2010 -0500
> >>>
> >>>     cifs: fix length calculation for converted unicode readdir names
> >>>     
> >>> ...that's most likely the cause of the problem.
> >>>
> >>>   
> >>>       
> >> Thanks a lot for answering my email Jeff.
> >> I don't think the kernel I use has this commit as I am on Ubuntu Karmic
> >> and it was based on "v2.6.31 final".
> >>
> >> Seb.
> >>
> >>     
> > On 04/28/2010 12:27 PM, Jeff Layton wrote
> > Ok, then you'll probably want to apply that patch and test it out, or
> > ask your distro to include it. That patch fixes a bug that can cause
> > the symptoms you're seeing.
> >
> >   
> Hi Jeff,
> 
> Sorry to bother you again. It took me a while to try out as I moved and
> did not have a fast internet connexion. However, I have just upgraded my
> system, and this kernel has this commit you mentioned. However, I still
> see the exact same problem.
> What can I do to help identify that bug?
> 

(re-cc'ing linux-cifs mailing list)

First, please cc the list rather than emailing me directly. I generally
don't do personal one-on-one support unless you're paying me ;)

You don't say what your upgraded kernel actually is, but you should
probably start with testing a recent upstream kernel. I don't see this
behavior with a quick test on a 2.6.34-ish kernel.

If you see this problem with a 2.6.34-ish kernel, then I'd say to open
a bug at bugzilla.samba.org and one of us will have a look when we have
time. If you can't reproduce it on a more recent kernel, then you'll
probably want to open a bug with your distro vendor, and see whether
they can track down what fixed it then they can put the patches in the
kernels they're shipping.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
