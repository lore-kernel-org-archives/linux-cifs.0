From: simo <idra@samba.org>
Subject: Re: Alternate Data Streams
Date: Mon, 02 Apr 2012 13:45:05 -0400
Message-ID: <1333388705.2983.79.camel@pico.li.ssimo.org>
References: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
	 <CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A@mail.gmail.com>
	 <20120402172346.GA6980@samba2>
	 <CACyXjPxyc=xsOMjx2xPfzyLu4pnD1dOBhkNcMGAn2y8+RR0xaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Richard Sharpe <realrichardsharpe@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CACyXjPxyc=xsOMjx2xPfzyLu4pnD1dOBhkNcMGAn2y8+RR0xaA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 2012-04-02 at 10:26 -0700, Richard Sharpe wrote: 
> On 4/2/12, Jeremy Allison <jra@samba.org> wrote:
> > On Mon, Apr 02, 2012 at 10:21:31AM -0700, Richard Sharpe wrote:
> >> On 4/2/12, Steve French <smfrench@gmail.com> wrote:
> >> > A user was asking about how to query alternate data streams of files
> >> > (over cifs) remotely for backup.
> >> >
> >> > Alternate Data Streams can be read from cifs (e.g.
> >> > /path/filename:streamname) but not listed or created.   Any thoughts
> >> > about whether this (at least listing the streams) should be done via
> >> > an ioctl, xattr or ...?
> >>
> >> Well, FindFirstStreamW and FindNextStreamW seem to available from
> >> W2K03 on. There is a code project out there that you can search on. I
> >> hit it as the first link returned when I searched for "Enumerating
> >> Alternate Data Streams"
> >
> > Remember Alternate Data Streams are dead from ReFS-onwards (thank
> > god :-).
> 
> A very useful piece of info.
> 
> There seems to be an additional way to query for them however.
> 
>      http://www.flexhex.com/doc/articles/alternat-streams.phtml

I get a page not found for this link.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>

