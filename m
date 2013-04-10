From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while smbclient works
Date: Wed, 10 Apr 2013 15:41:01 -0500
Message-ID: <CAH2r5muGsam56ShjokfTUGko+UPxoOgd=45TTJK5rCWkZsQuzw@mail.gmail.com>
References: <20130408194049.GE10949@torres.zugschlus.de>
	<20130410090415.7e1c40b3@corrin.poochiereds.net>
	<20130410184639.GB31333@torres.zugschlus.de>
	<CAH2r5msWFVuQFVb2fNn7W-_Gp8Uf4phE1Xd3h9HU0AOewzJHPg@mail.gmail.com>
	<20130410200746.GB515@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410200746.GB515-MEsB+WDYHc7QKvwJT6wXshvVK+yQ3ZXh@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Given that it worked before probably better to try "sec=ntlm" (or
"sec=ntlmv2") since that will send what we used to send.

On Wed, Apr 10, 2013 at 3:07 PM, Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org> wrote:
> On Wed, Apr 10, 2013 at 03:01:06PM -0500, Steve French wrote:
>> On Wed, Apr 10, 2013 at 1:46 PM, Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org> wrote:
>> > On Wed, Apr 10, 2013 at 09:04:15AM -0400, Jeff Layton wrote:
>> >> In any case, a workaround for now might be to try and mount with
>> >> sec=none. I *think* that will make the client do what smbclient is
>> >> doing here.
>> >
>> > I tried that, no change. Would another dump of a mount.cifs -o
>> > sec=none help?
>>
>> yes
>
> http://q.bofh.de/~mh/stuff/tcpdump.mount.cifs.secnone
>
> Command line was:
> $ sudo mount.cifs  '\\mx420-sch8.local\canon_memory' /media/scanner -o user=anonymous,nounix,sec=none --verbose
> mount.cifs kernel mount options:
> ip=192.168.218.36,unc=\\mx420-sch8.local\canon_memory,nounix,sec=none,user=anonymous,pass=********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
>
> Greetings
> Marc
>
> --
> -----------------------------------------------------------------------------
> Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
> Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
> Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062



-- 
Thanks,

Steve
