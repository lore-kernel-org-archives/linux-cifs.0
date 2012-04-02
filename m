From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Alternate Data Streams
Date: Mon, 2 Apr 2012 10:26:35 -0700
Message-ID: <CACyXjPxyc=xsOMjx2xPfzyLu4pnD1dOBhkNcMGAn2y8+RR0xaA@mail.gmail.com>
References: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
	<CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A@mail.gmail.com>
	<20120402172346.GA6980@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120402172346.GA6980@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 4/2/12, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, Apr 02, 2012 at 10:21:31AM -0700, Richard Sharpe wrote:
>> On 4/2/12, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > A user was asking about how to query alternate data streams of fil=
es
>> > (over cifs) remotely for backup.
>> >
>> > Alternate Data Streams can be read from cifs (e.g.
>> > /path/filename:streamname) but not listed or created.   Any though=
ts
>> > about whether this (at least listing the streams) should be done v=
ia
>> > an ioctl, xattr or ...?
>>
>> Well, FindFirstStreamW and FindNextStreamW seem to available from
>> W2K03 on. There is a code project out there that you can search on. =
I
>> hit it as the first link returned when I searched for "Enumerating
>> Alternate Data Streams"
>
> Remember Alternate Data Streams are dead from ReFS-onwards (thank
> god :-).

A very useful piece of info.

There seems to be an additional way to query for them however.

     http://www.flexhex.com/doc/articles/alternat-streams.phtml

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
