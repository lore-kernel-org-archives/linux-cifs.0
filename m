From: =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
 allocate memory
Date: Mon, 24 Sep 2012 12:39:45 +0200
Message-ID: <CAPJ9Yc-K8YEu5yE-6Zgq2AqghWfLRx5WswgCOL6_qG=Q8z3Hkw@mail.gmail.com>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
	<4EC269FC.1060104@suse.com>
	<004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
	<4EC334D6.9020208@suse.com>
	<loom.20120922T005738-960@post.gmane.org>
	<CAH2r5msw6r9N2WQAVX+iHGMy++=wp4qUU1k_F+N93xLsZ9i1zg@mail.gmail.com>
	<CAPJ9Yc-FKLzH_BK++iL4uV59gy-dVCDGYs=ZFfsJVimWfGKdbw@mail.gmail.com>
	<CAH2r5msLRvtFOzEVR3g8Tq+j+k9D4SurBPOeez=DOL7d3_uTDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msLRvtFOzEVR3g8Tq+j+k9D4SurBPOeez=DOL7d3_uTDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 24 September 2012 02:03, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If it still fails with max_pending set to 9 or 10 (on the client) -
> then you are stuck with having to fix the server (there were a couple
> of registry parms which can be set in Windows, mentioned in earlier
> posts which apparently resolve this).  ( had trouble reproducing this
> with max pending set low.
>
> We may want to enable SMB2 dialect (SMB2.1 dialect is currently
> enabled in linux-next, but not SMB2.0 dialect which Vista uses) if
> Vista fails (was this Vista or Windows 7) - since SMB2 uses a
> different crediting mechanism?

I tested with Windows 7 (Professional SP1 64-bit, up to date, mostly
default options).

As a user, I just want my gear to work, without needing to google for
tweaks and hacks.

Is it possible that SystemRescueCd uses some strange (kernel)
configuration that causes problems?
Because with Ubuntu as client I has fewer problems (but it might just
be chance, I only did a few quick tests).

Regards,
David
