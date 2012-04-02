From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Alternate Data Streams
Date: Mon, 2 Apr 2012 10:51:37 -0700
Message-ID: <CACyXjPzVLLKCzN5-8z6ojSdDvRJakMfu6PWTYVVGTJZx0p53Lw@mail.gmail.com>
References: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
	<CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A@mail.gmail.com>
	<20120402172346.GA6980@samba2>
	<CACyXjPxyc=xsOMjx2xPfzyLu4pnD1dOBhkNcMGAn2y8+RR0xaA@mail.gmail.com>
	<1333388705.2983.79.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333388705.2983.79.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 4/2/12, simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 2012-04-02 at 10:26 -0700, Richard Sharpe wrote:
>> On 4/2/12, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> > On Mon, Apr 02, 2012 at 10:21:31AM -0700, Richard Sharpe wrote:
>> >> On 4/2/12, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> > A user was asking about how to query alternate data streams of =
files
>> >> > (over cifs) remotely for backup.
>> >> >
>> >> > Alternate Data Streams can be read from cifs (e.g.
>> >> > /path/filename:streamname) but not listed or created.   Any tho=
ughts
>> >> > about whether this (at least listing the streams) should be don=
e via
>> >> > an ioctl, xattr or ...?
>> >>
>> >> Well, FindFirstStreamW and FindNextStreamW seem to available from
>> >> W2K03 on. There is a code project out there that you can search o=
n. I
>> >> hit it as the first link returned when I searched for "Enumeratin=
g
>> >> Alternate Data Streams"
>> >
>> > Remember Alternate Data Streams are dead from ReFS-onwards (thank
>> > god :-).
>>
>> A very useful piece of info.
>>
>> There seems to be an additional way to query for them however.
>>
>>      http://www.flexhex.com/doc/articles/alternate-streams.phtml
>
> I get a page not found for this link.

Try now. I misspelled it ...

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
