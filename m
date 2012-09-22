From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
 allocate memory
Date: Fri, 21 Sep 2012 19:03:18 -0500
Message-ID: <CAH2r5mtVkpD+6Zgf_iAeTRps06Mr0O720UkOk-1fmYwH47XBHQ@mail.gmail.com>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
	<4EC269FC.1060104@suse.com>
	<004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
	<4EC334D6.9020208@suse.com>
	<loom.20120922T005738-960@post.gmane.org>
	<CAH2r5msw6r9N2WQAVX+iHGMy++=wp4qUU1k_F+N93xLsZ9i1zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msw6r9N2WQAVX+iHGMy++=wp4qUU1k_F+N93xLsZ9i1zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 21, 2012 at 6:05 PM, David Bala=C5=BEic <xerces9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>
> Suresh Jayaraman <sjayaraman@...> writes:
>
> > Ah, ok. In case if you have not figured out how to overcome this
> > problem, take a look at
> >
> >
> > http://alan.lamielle.net/2009/09/03/windows-7-nonpaged-pool-srv-err=
or-2017
>
> (I'm not subscribed, so please CC me)
>
> Hi!
>
> I also encountered this error 12 accessing a shared folder on a Windo=
ws 7
> Pro
> SP1 64-bit "server", client being SystemRescueCd 3.0.0 with kernel ve=
rsion
> 3.2.28 32 bit. It also happens with other kernels (RipLinux 13.7, ker=
nel
> 3.2.1).
>
>
> I got the error when copying a single large file to the shared folder=
=2E
> The registry tweaks at that URL mitigates the problem.
> But I changed it back to do some research.
> When accessing the same shared folder from a Windows 7 Home Premium S=
P1
> x64
> client, there is no problem.
>
> When I tried with Linux just before posting this, I got error 12 righ=
t
> when
> mounting, before doing any file operations.
>
> Is this because linux-cifs does not respect the MaxReq parm that the
> server
> sends, as suggested in this post:
> http://article.gmane.org/gmane.linux.kernel.cifs/4294 ?
>

We were able to reproduce this problem to Windows, even when
the (Windows Vista/Windows 7) server was configured for 50 requests,
but current cifs.ko (3.4 kernels and later) does respect the servers
MaxReq parameter (maximum simultaneous requests limit).

To servers, like Samba, which can handle much more than 50
simultaneous requests, note that the server's limit can be configured
(increased) in the server's smb.conf file beyond the typical default
(50 for most server's and clients - thus the reason cifs client
simply defaulted to 50 prior to 3.4).



--
Thanks,

Steve



--
Thanks,

Steve
