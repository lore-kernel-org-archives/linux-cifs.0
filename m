From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while smbclient works
Date: Wed, 10 Apr 2013 15:01:06 -0500
Message-ID: <CAH2r5msWFVuQFVb2fNn7W-_Gp8Uf4phE1Xd3h9HU0AOewzJHPg@mail.gmail.com>
References: <20130408194049.GE10949@torres.zugschlus.de>
	<20130410090415.7e1c40b3@corrin.poochiereds.net>
	<20130410184639.GB31333@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410184639.GB31333-MEsB+WDYHc7QKvwJT6wXshvVK+yQ3ZXh@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 10, 2013 at 1:46 PM, Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org> wrote:
> On Wed, Apr 10, 2013 at 09:04:15AM -0400, Jeff Layton wrote:
>> In any case, a workaround for now might be to try and mount with
>> sec=none. I *think* that will make the client do what smbclient is
>> doing here.
>
> I tried that, no change. Would another dump of a mount.cifs -o
> sec=none help?

yes
--
Thanks,

Steve
